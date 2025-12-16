<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart | GIO</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href='https://fonts.googleapis.com/css?family=Quicksand:300,400,500,600,700&display=swap' rel='stylesheet'>
    <link rel="icon" href="${pageContext.request.contextPath}/images/LG2.png" type="image/x-icon">

    <script>
        const BASE = '${pageContext.request.contextPath}';
    </script>

    <style>
        :root {
            --primary-color: #a0816c;
            --primary-dark: #8a6d5a;
            --text-main: #333;
            --text-light: #888;
            --bg-body: #f4f4f4;
            --white: #ffffff;
            --border-radius: 12px;
            --shadow-soft: 0 4px 20px rgba(0,0,0,0.05);
            --bar-height: 80px;
        }

        body {
            font-family: 'Quicksand', sans-serif;
            background-color: var(--bg-body);
            color: var(--text-main);
            padding-bottom: calc(var(--bar-height) + 20px); 
            font-size: 15px;
        }
        
        #page-loader {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background-color: var(--white); z-index: 99999;
            display: flex; justify-content: center; align-items: center;
            transition: opacity 0.4s ease-out, visibility 0.4s;
        }
        .spinner-custom {
            width: 50px; height: 50px;
            border: 3px solid rgba(160, 129, 108, 0.3); border-radius: 50%;
            border-top-color: var(--primary-color); animation: spin 1s infinite;
        }
        @keyframes spin { to { transform: rotate(360deg); } }

        .main-container { max-width: 1100px; margin: 30px auto; padding: 0 15px; }

        .cart-header-row {
            display: grid; grid-template-columns: 50px 3fr 1fr 1fr 1fr 50px;
            background: var(--white); padding: 18px 25px;
            border-radius: var(--border-radius); box-shadow: var(--shadow-soft);
            margin-bottom: 15px; font-weight: 600; color: var(--text-light);
            align-items: center; text-align: center;
        }
        .header-product { text-align: left; }

        .cart-item-card {
            background: var(--white); padding: 25px; margin-bottom: 15px;
            border-radius: var(--border-radius); box-shadow: var(--shadow-soft);
            display: grid; grid-template-columns: 50px 3fr 1fr 1fr 1fr 50px;
            align-items: center; position: relative;
            transition: transform 0.2s;
        }
        
        .cart-item-card.item-disabled { opacity: 0.7; background: #fafafa; }
        /* Cho phép click nút xóa/giảm số lượng ở dòng bị disable */
        .cart-item-card.item-disabled .col-check input,
        .cart-item-card.item-disabled .size-select,
        .cart-item-card.item-disabled .btn-increase { pointer-events: none; opacity: 0.5; }

        .col-check { display: flex; justify-content: center; }
        .form-check-input { width: 20px; height: 20px; cursor: pointer; border: 2px solid #ddd; }
        .form-check-input:checked { background-color: var(--primary-color); border-color: var(--primary-color); }

        .product-flex { display: flex; align-items: center; gap: 20px; text-align: left; }
        .cart-img-wrapper { width: 90px; height: 90px; border-radius: 8px; overflow: hidden; border: 1px solid #eee; }
        .cart-img-wrapper img { width: 100%; height: 100%; object-fit: cover; }
        
        .product-details { display: flex; flex-direction: column; gap: 6px; }
        .product-name { font-weight: 600; font-size: 1.05rem; color: var(--text-main); text-decoration: none; }
        .product-name:hover { color: var(--primary-color); }
        .size-group { display: flex; align-items: center; font-size: 0.9rem; color: var(--text-light); }
        .size-select { border: none; background: #f4f4f4; padding: 4px 10px; border-radius: 6px; margin-left: 5px; font-weight: 600; }

        .col-price { text-align: center; color: var(--text-light); }
        
        /* Styles cho giá và thông báo */
        .old-price-strike { text-decoration: line-through; color: #aaa; font-size: 0.85rem; display: block; }
        .new-price-highlight { color: var(--primary-color); font-weight: 600; }
        
        .cart-warning-row { grid-column: 2 / -1; margin-top: 10px; font-size: 0.85rem; font-weight: 500; text-align: left; }
        
        .msg-price-changed { color: #0d6efd; display: flex; align-items: center; gap: 5px; margin-bottom: 4px; }
        .msg-stock-error { color: #dc3545; display: flex; align-items: center; gap: 5px; }
        .msg-stock-warn { color: #e58e26; display: flex; align-items: center; gap: 5px; }

        .col-total { text-align: center; font-weight: 700; color: var(--primary-color); font-size: 1.1rem; }
        .qty-control { display: flex; align-items: center; border: 1px solid #eee; border-radius: 8px; overflow: hidden; background: #fff; width: fit-content; margin: 0 auto;}
        .qty-btn { width: 32px; height: 32px; border: none; background: #fff; display: flex; align-items: center; justify-content: center; cursor: pointer; }
        .qty-btn:hover { background: #fdfbf9; color: var(--primary-color); }
        .qty-input { width: 40px; height: 32px; border: none; text-align: center; font-weight: 600; pointer-events: none; }

        .btn-remove { border: none; background: transparent; color: #999; font-size: 1.2rem; cursor: pointer; }
        .btn-remove:hover { color: #dc3545; }

        .sticky-footer {
            position: fixed; bottom: 0; left: 0; width: 100%; background: var(--white);
            box-shadow: 0 -4px 20px rgba(0,0,0,0.08); z-index: 1000; height: var(--bar-height); display: flex; align-items: center;
        }
        .footer-content { max-width: 1100px; width: 100%; margin: 0 auto; padding: 0 15px; display: flex; justify-content: space-between; align-items: center; }
        .total-price { font-size: 1.5rem; font-weight: 700; color: #dc3545; margin-left: 10px; }
        .btn-checkout { background-color: var(--primary-color); color: white; border: none; padding: 0 40px; height: 45px; border-radius: 8px; font-weight: 600; text-transform: uppercase; }
        .btn-checkout:hover:not(:disabled) { background-color: var(--primary-dark); }
        .btn-checkout:disabled { background-color: #ccc; cursor: not-allowed; }
        .empty-cart-box { background: var(--white); border-radius: var(--border-radius); padding: 60px 20px; text-align: center; box-shadow: var(--shadow-soft); }

        @media (max-width: 768px) {
            .cart-header-row { display: none; }
            .cart-item-card { display: flex; flex-wrap: wrap; padding: 20px; position: relative; gap: 15px; }
            .col-check { position: absolute; top: 20px; left: 15px; z-index: 2; }
            .product-flex { width: 100%; padding-left: 30px; }
            .col-price { width: 100%; text-align: left; padding-left: 30px; margin-top: -10px; }
            .qty-wrapper { margin-left: auto; }
            .col-total { width: 100%; text-align: right; display: flex; justify-content: space-between; margin-top: 10px; }
            .col-total::before { content: "Total:"; color: #888; font-size: 0.9rem; }
            .col-action { position: absolute; top: 15px; right: 15px; }
            .footer-content { flex-direction: column; gap: 10px; padding: 10px 15px; height: auto; }
            .sticky-footer { height: auto; }
            .btn-checkout { width: 100%; margin-left: 0 !important; }
        }
    </style>
</head>

<body>
    <div id="page-loader"><div class="spinner-custom"></div></div>

    <%@ include file="header.jsp" %>

    <div class="main-container">
        <h3 class="mb-4" style="font-weight: 700;">Shopping Cart</h3>

        <c:choose>
            <c:when test="${empty requestScope.cartList}">
                <div class="empty-cart-box">
                    <i class="bi bi-cart-x empty-icon" style="font-size: 4rem; color: #eee;"></i>
                    <h3>Your cart is empty!</h3>
                    <br>
                    <a href="${pageContext.request.contextPath}/" class="btn-continue mt-3" style="background:#333; color:white; padding:10px 30px; border-radius:8px; text-decoration:none;">Go Shopping</a>
                </div>
            </c:when>

            <c:otherwise>
                <div class="cart-header-row d-none d-md-grid">
                    <div class="col-check"><input class="form-check-input" type="checkbox" id="selectAllTop"></div>
                    <div class="header-product">Product</div>
                    <div>Unit Price</div>
                    <div>Quantity</div>
                    <div>Total</div>
                    <div></div>
                </div>

                <div class="cart-list">
                    <c:forEach items="${requestScope.cartList}" var="cart">
                        <%-- === LOGIC TÍNH TOÁN === --%>
                        <c:set var="availableQty" value="${cart.stockQuantity}" />
                        <c:set var="isMissing" value="${empty nameProduct[cart.productID]}" />
                        <c:set var="isOutOfStock" value="${availableQty le 0}" />
                        <c:set var="isStopped" value="${activeP[cart.productID] != null and not activeP[cart.productID]}" />
                        <c:set var="isInsufficient" value="${availableQty lt cart.quantity}" />
                        
                        <%-- Biến hasError chỉ liên quan đến khả năng MUA (tồn kho, trạng thái) --%>
                        <c:set var="hasError" value="${isMissing or isOutOfStock or isStopped or isInsufficient}" />

                        <%-- Logic Giá --%>
                        <c:set var="priceAtAdd" value="${cart.price}" />
                        <c:set var="priceNow" value="${priceP[cart.productID]}" />
                        <c:if test="${empty priceNow}"><c:set var="priceNow" value="${priceAtAdd}" /></c:if>
                        <c:set var="hasPriceChanged" value="${priceNow ne priceAtAdd}" />
                        
                        <c:set var="lineTotal" value="${priceNow * cart.quantity}" />

                        <div class="cart-item-card ${hasError ? 'item-disabled' : ''}" data-id="${cart.productID}">
                            <div class="col-check">
                                <input class="form-check-input item-check" 
                                       type="checkbox" 
                                       data-id="${cart.productID}" 
                                       data-size="${cart.size_name}"
                                       data-price="${priceNow}"
                                       data-stock="${availableQty}"
                                       <c:if test="${hasError}">disabled</c:if>
                                       <c:if test="${not hasError}">checked</c:if>>
                            </div>

                            <div class="product-flex">
                                <div class="cart-img-wrapper">
                                    <a href="${pageContext.request.contextPath}/productDetail?id=${cart.productID}">
                                        <img src="${picUrlMap[cart.productID]}" alt="${nameProduct[cart.productID]}">
                                    </a>
                                </div>
                                <div class="product-details">
                                    <a href="${pageContext.request.contextPath}/productDetail?id=${cart.productID}" class="product-name">
                                        ${nameProduct[cart.productID]}
                                    </a>
                                    <div class="size-group">
                                        <span>Size: </span>
                                        <c:set var="sizesOfProduct" value="${productSizeMap[cart.productID]}" />
                                        <c:choose>
                                            <c:when test="${not empty sizesOfProduct}">
                                                <select class="size-select action-change-size" <c:if test="${isMissing or isStopped}">disabled</c:if>>
                                                    <c:forEach var="sz" items="${sizesOfProduct}">
                                                        <option value="${sz}" <c:if test="${sz eq cart.size_name}">selected</c:if>>${sz}</option>
                                                    </c:forEach>
                                                </select>
                                                <input type="hidden" class="old-size-val" value="${cart.size_name}">
                                            </c:when>
                                            <c:otherwise>
                                                <span class="ms-1 fw-bold">${cart.size_name}</span>
                                                <input type="hidden" class="old-size-val" value="${cart.size_name}">
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>

                            <div class="col-price">
                                <c:choose>
                                    <c:when test="${hasPriceChanged}">
                                        <span class="old-price-strike"><fmt:formatNumber value="${priceAtAdd}" pattern="###,###" /> VND</span>
                                        <span class="new-price-highlight"><fmt:formatNumber value="${priceNow}" pattern="###,###" /> VND</span>
                                    </c:when>
                                    <c:otherwise><fmt:formatNumber value="${priceNow}" pattern="###,###" /> VND</c:otherwise>
                                </c:choose>
                            </div>

                            <div class="qty-wrapper">
                                <div class="qty-control">
                                    <button type="button" class="qty-btn btn-decrease">
                                        <i class="bi bi-dash"></i>
                                    </button>
                                    <input type="text" class="qty-input" value="${cart.quantity}" readonly>
                                    <button type="button" class="qty-btn btn-increase" <c:if test="${isMissing or isStopped or isOutOfStock}">disabled</c:if>>
                                        <i class="bi bi-plus"></i>
                                    </button>
                                </div>
                            </div>

                            <div class="col-total">
                                <span class="line-total-display"><fmt:formatNumber value="${lineTotal}" pattern="###,###" /></span> VND
                            </div>

                            <div class="col-action">
                                <button class="btn-remove action-delete"><i class="bi bi-trash3"></i></button>
                            </div>

                            <%-- === PHẦN THÔNG BÁO TỔNG HỢP (GIÁ & KHO) === --%>
                            <c:if test="${hasError or hasPriceChanged}">
                                <div class="cart-warning-row">
                                    
                                    <%-- 1. Thông báo Giá Thay Đổi --%>
                                    <c:if test="${hasPriceChanged}">
                                        <div class="msg-price-changed">
                                            <i class="bi bi-info-circle-fill"></i> Price has been updated based on current listing.
                                        </div>
                                    </c:if>

                                    <%-- 2. Thông báo Lỗi Kho / Trạng Thái --%>
                                    <c:choose>
                                        <c:when test="${isMissing or isStopped}">
                                            <div class="msg-stock-error"><i class="bi bi-x-circle-fill"></i> Product unavailable. Please remove.</div>
                                        </c:when>
                                        <c:when test="${isOutOfStock}">
                                            <div class="msg-stock-error"><i class="bi bi-x-circle-fill"></i> Out of stock.</div>
                                        </c:when>
                                        <c:when test="${isInsufficient}">
                                            <div class="msg-stock-warn warn-insufficient">
                                                <i class="bi bi-exclamation-triangle-fill"></i> 
                                                Insufficient stock (Only ${availableQty} left). Please reduce quantity.
                                            </div>
                                        </c:when>
                                    </c:choose>
                                </div>
                            </c:if>
                        </div>
                    </c:forEach>
                </div>

                <div class="sticky-footer">
                    <div class="footer-content">
                        <div style="display:flex; align-items:center;">
                            <input class="form-check-input me-2" type="checkbox" id="selectAllBottom">
                            <label for="selectAllBottom" style="cursor:pointer; font-weight:500;">Select All (<span id="countSelected">0</span>)</label>
                        </div>
                        <div style="display:flex; align-items:center;">
                            <span class="d-none d-md-inline me-2">Total Amount:</span>
                            <span class="total-price" id="grandTotalDisplay">0 VND</span>
                            <form id="checkoutForm" action="${pageContext.request.contextPath}/loadPayment" method="get" style="display:inline; margin-left:20px;">
                                <input type="hidden" id="grandTotalInput" name="grandTotal" value="0">
                                <button type="submit" class="btn-checkout" id="checkoutBtn" disabled>Checkout</button>
                            </form>
                        </div>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-sm">
            <div class="modal-content border-0 shadow" style="border-radius: 12px;">
                <div class="modal-body text-center p-4">
                    <div class="mb-3 text-warning"><i class="bi bi-exclamation-circle display-4"></i></div>
                    <h6 class="mb-4">Remove this item?</h6>
                    <div class="d-flex gap-2 justify-content-center">
                        <button type="button" class="btn btn-light px-4 rounded-pill" data-bs-dismiss="modal">No</button>
                        <button type="button" class="btn btn-danger px-4 rounded-pill" id="confirmDeleteBtn">Yes</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/js/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        function formatVND(amount) { return (amount || 0).toLocaleString('vi-VN') + " VND"; }

        $(document).ready(function() {
            setTimeout(() => { $('#page-loader').fadeOut(); }, 400);

            const masterTop = $('#selectAllTop');
            const masterBot = $('#selectAllBottom');

            function syncMasters(checked) {
                masterTop.prop('checked', checked);
                masterBot.prop('checked', checked);
            }

            function updateSummary() {
                let total = 0;
                let count = 0;
                $('.item-check:checked').each(function() {
                    const row = $(this).closest('.cart-item-card');
                    const qty = parseInt(row.find('.qty-input').val()) || 0;
                    const price = parseInt($(this).data('price')) || 0;
                    total += (qty * price);
                    count++;
                });

                $('#grandTotalDisplay').text(formatVND(total));
                $('#grandTotalInput').val(total);
                $('#countSelected').text(count);
                $('#checkoutBtn').prop('disabled', count === 0);

                const totalEnabled = $('.item-check:not(:disabled)').length;
                const totalChecked = $('.item-check:checked').length;
                
                if (totalEnabled > 0 && totalEnabled === totalChecked) {
                    syncMasters(true); masterTop.prop('indeterminate', false); masterBot.prop('indeterminate', false);
                } else {
                    syncMasters(false);
                    if (totalChecked > 0) { masterTop.prop('indeterminate', true); masterBot.prop('indeterminate', true); }
                    else { masterTop.prop('indeterminate', false); masterBot.prop('indeterminate', false); }
                }
            }

            $('#selectAllTop, #selectAllBottom').on('change', function() {
                const isChecked = $(this).prop('checked');
                syncMasters(isChecked);
                $('.item-check:not(:disabled)').prop('checked', isChecked);
                updateSummary();
            });

            $(document).on('change', '.item-check', updateSummary);

            $(document).on('click', '.btn-increase', function() {
                const row = $(this).closest('.cart-item-card');
                const qtyInput = row.find('.qty-input');
                const checkbox = row.find('.item-check');
                
                const currentQty = parseInt(qtyInput.val()) || 1;
                const newQty = currentQty + 1;
                const pid = row.data('id');
                const price = checkbox.data('price');
                const size = checkbox.data('size');

                $.ajax({
                    url: BASE + '/cartIncrease', method: 'GET',
                    data: {id: pid, price: price, quantity: newQty, size: size},
                    success: function(resp) {
                        const parts = (resp || '').split(',');
                        if (parseInt(parts[2] || '0') === 0) {
                            qtyInput.val(newQty);
                            row.find('.line-total-display').text((newQty * price).toLocaleString('vi-VN'));
                            updateSummary();
                        } else {
                            alert('Stock limit reached.');
                        }
                    }
                });
            });

            // LOGIC GIẢM SỐ LƯỢNG - CHỈ ẨN CẢNH BÁO TỒN KHO, GIỮ CẢNH BÁO GIÁ
            $(document).on('click', '.btn-decrease', function() {
                const row = $(this).closest('.cart-item-card');
                const qtyInput = row.find('.qty-input');
                const checkbox = row.find('.item-check');
                // Chỉ tìm phần tử cảnh báo thiếu hàng cụ thể
                const warningInsufficient = row.find('.warn-insufficient');

                const currentQty = parseInt(qtyInput.val()) || 1;
                if (currentQty <= 1) return;

                const newQty = currentQty - 1;
                const pid = row.data('id');
                const price = checkbox.data('price');
                const size = checkbox.data('size');
                const stock = parseInt(checkbox.data('stock')) || 0;

                $.ajax({
                    url: BASE + '/cartDecrease', method: 'GET',
                    data: {id: pid, price: price, quantity: newQty, size: size},
                    success: function(resp) {
                        qtyInput.val(newQty);
                        row.find('.line-total-display').text((newQty * price).toLocaleString('vi-VN'));
                        
                        // Nếu số lượng hợp lệ, mở khóa và ẩn warning thiếu hàng
                        if (newQty <= stock) {
                            if (checkbox.prop('disabled')) {
                                checkbox.prop('disabled', false); 
                                checkbox.prop('checked', true);   
                                row.removeClass('item-disabled'); 
                                
                                // Chỉ ẩn dòng chữ "Thiếu hàng"
                                if(warningInsufficient.length) warningInsufficient.fadeOut();
                                
                                // Nếu không còn cảnh báo giá nào khác thì ẩn luôn cả row (optional)
                                // Nhưng ở đây ta cứ để row nếu còn warning giá
                            }
                        }
                        updateSummary();
                    }
                });
            });

            $(document).on('change', '.action-change-size', function() {
                const selectEl = $(this);
                const row = selectEl.closest('.cart-item-card');
                const oldSizeInput = row.find('.old-size-val');
                const checkbox = row.find('.item-check');
                const pid = row.data('id');
                const oldSize = oldSizeInput.val();
                const newSize = selectEl.val();
                if (newSize === oldSize) return;
                $.ajax({
                    url: BASE + '/cartChangeSize', method: 'GET',
                    data: {id: pid, oldSize: oldSize, newSize: newSize},
                    success: function(response) {
                        if (response && response.includes('OK')) {
                            oldSizeInput.val(newSize);
                            checkbox.data('size', newSize); 
                            checkbox.attr('data-size', newSize);
                        } else {
                            alert('Cannot switch size.'); selectEl.val(oldSize); 
                        }
                    },
                    error: function() { alert('Error.'); selectEl.val(oldSize); }
                });
            });

            let deleteTarget = null;
            $(document).on('click', '.action-delete', function() {
                const row = $(this).closest('.cart-item-card');
                deleteTarget = { el: row, id: row.data('id'), size: row.find('.item-check').data('size') };
                new bootstrap.Modal('#deleteConfirmModal').show();
            });

            $('#confirmDeleteBtn').click(function() {
                if (!deleteTarget) return;
                $.ajax({
                    url: BASE + '/cartDelete', method: 'GET',
                    data: {id: deleteTarget.id, size: deleteTarget.size},
                    success: function() {
                        const modal = bootstrap.Modal.getInstance('#deleteConfirmModal');
                        modal.hide();
                        deleteTarget.el.remove();
                        updateSummary();
                        if ($('.cart-item-card').length === 0) location.reload();
                    }
                });
            });

            $('#checkoutForm').on('submit', function(e) {
                const checked = $('.item-check:checked');
                if (checked.length === 0) { e.preventDefault(); return; }
                $(this).find('input[name="selectedItems"]').remove();
                checked.each(function() {
                    $('<input>').attr({ type: 'hidden', name: 'selectedItems', value: $(this).data('id') + '::' + $(this).data('size') }).appendTo('#checkoutForm');
                });
            });

            updateSummary();
        });
    </script>
</body>
</html>