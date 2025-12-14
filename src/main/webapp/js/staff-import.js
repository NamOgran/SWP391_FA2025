/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

/**
 * staff-import.js
 * Xử lý logic cho chức năng Nhập hàng (Import)
 */
$(document).ready(function () {
    // Biến toàn cục lưu trữ dữ liệu
    let globalProducts = [];
    let globalSizes = [];
    let importCart = [];

    // 1. Sự kiện khi mở Modal -> Load dữ liệu sản phẩm
    $('#createImportModal').on('show.bs.modal', function () {
        // Reset form
        $('#createImportForm')[0].reset();
        importCart = [];
        renderImportCartTable();
        
        // Reset dropdown
        $('#import_product').empty().append('<option value="">-- Loading products... --</option>');
        $('#import_size').prop('disabled', true).html('<option value="">-- Select product first --</option>');
        $('#import-item-error').hide();

        // Gọi AJAX lấy danh sách
        loadProductDataForImport();
    });

    // 2. Hàm AJAX load dữ liệu
    function loadProductDataForImport() {
        $.ajax({
            url: BASE_URL + "/staff/import/getproducts", // Sử dụng biến BASE_URL từ JSP
            type: "POST",
            dataType: "json",
            success: function (res) {
                if (res.isSuccess) {
                    globalProducts = res.data.products || [];
                    globalSizes = res.data.sizes || [];
                    populateProductDropdown();
                } else {
                    alert("Lỗi tải dữ liệu: " + res.description);
                }
            },
            error: function () {
                alert("Không thể kết nối tới server.");
            }
        });
    }

    // 3. Đổ dữ liệu vào Dropdown Product
    function populateProductDropdown() {
        let $select = $('#import_product');
        $select.empty().append('<option value="">-- Select Product --</option>');

        // Sắp xếp tên A-Z
        globalProducts.sort((a, b) => (a.name || "").localeCompare(b.name || ""));

        globalProducts.forEach(p => {
            // Lấy đúng ID (xử lý trường hợp tên biến khác nhau)
            let pId = p.product_id || p.productID || p.id;
            // Chỉ hiện sản phẩm đang active
            let isActive = (p.is_active !== undefined) ? p.is_active : true;

            if (isActive && pId) {
                $select.append(`<option value="${pId}">${p.name}</option>`);
            }
        });
    }

    // 4. Sự kiện chọn Product -> Lọc Size
    $('#import_product').on('change', function () {
        let selectedId = $(this).val();
        let $sizeSelect = $('#import_size');

        $sizeSelect.empty();

        if (!selectedId) {
            $sizeSelect.prop('disabled', true).append('<option value="">-- Select product first --</option>');
            return;
        }

        // Lọc size theo Product ID
        let availableSizes = globalSizes.filter(s => {
            let sProId = s.product_id || s.productID;
            return String(sProId) === String(selectedId);
        });

        if (availableSizes.length > 0) {
            $sizeSelect.prop('disabled', false).append('<option value="">-- Select Size --</option>');
            availableSizes.forEach(s => {
                $sizeSelect.append(`<option value="${s.size_name}">${s.size_name}</option>`);
            });
        } else {
            $sizeSelect.prop('disabled', true).append('<option value="">No sizes setup</option>');
        }
    });

    // 5. Nút ADD Item vào bảng tạm
    $('#btn-add-item-to-import').click(function () {
        let productId = $('#import_product').val();
        let productName = $('#import_product option:selected').text();
        let sizeName = $('#import_size').val();
        let quantity = parseInt($('#import_qty').val());

        // Validate
        if (!productId || !sizeName || isNaN(quantity) || quantity <= 0) {
            $('#import-item-error').text("Please select product, size and valid quantity.").show();
            return;
        }
        $('#import-item-error').hide();

        // Kiểm tra trùng lặp và cộng dồn
        let existingItem = importCart.find(i => i.productID == productId && i.sizeName == sizeName);
        if (existingItem) {
            existingItem.quantity += quantity;
        } else {
            importCart.push({
                productID: parseInt(productId),
                productName: productName,
                sizeName: sizeName,
                quantity: quantity
            });
        }

        // Reset input số lượng
        $('#import_qty').val(1);
        renderImportCartTable();
    });

    // 6. Vẽ bảng giỏ hàng
    function renderImportCartTable() {
        let $tbody = $('#import-items-list');
        $tbody.empty();

        if (importCart.length === 0) {
            $tbody.html('<tr><td colspan="4" class="text-center text-muted">No items added yet.</td></tr>');
            return;
        }

        importCart.forEach((item, index) => {
            $tbody.append(`
                <tr>
                    <td>${item.productName}</td>
                    <td>${item.sizeName}</td>
                    <td>${item.quantity}</td>
                    <td>
                        <button type="button" class="btn btn-sm btn-danger btn-remove-item" data-index="${index}">
                            <i class="bi bi-trash"></i>
                        </button>
                    </td>
                </tr>
            `);
        });
    }

    // 7. Xóa item (Event Delegation)
    $('#import-items-list').on('click', '.btn-remove-item', function () {
        let index = $(this).data('index');
        importCart.splice(index, 1);
        renderImportCartTable();
    });

    // 8. SUBMIT Form
    $('#createImportForm').on('submit', function (e) {
        e.preventDefault();

        if (importCart.length === 0) {
            alert("Import list is empty!");
            return;
        }

        // Map dữ liệu gửi về server
        let dataToSend = importCart.map(item => ({
            productID: item.productID,
            sizeName: item.sizeName,
            quantity: item.quantity
        }));

        $.ajax({
            url: BASE_URL + "/staff/import/create",
            type: "POST",
            data: { products: JSON.stringify(dataToSend) },
            dataType: "json",
            success: function (res) {
                if (res.isSuccess) {
                    alert("Import created successfully!");
                    $('#createImportModal').modal('hide');
                    // Reload trang hoặc danh sách nếu cần
                    if (typeof listImport === 'function') listImport();
                } else {
                    alert("Failed: " + res.description);
                }
            },
            error: function () {
                alert("Error sending request to server.");
            }
        });
    });
});