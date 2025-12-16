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
            --primary-light: #fdfbf9;
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

        a { text-decoration: none; color: inherit; transition: 0.2s; }
        
        #page-loader {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background-color: var(--white);
            z-index: 99999;
            display: flex; justify-content: center; align-items: center;
            transition: opacity 0.4s ease-out, visibility 0.4s;
        }
        .spinner-custom {
            width: 50px; height: 50px;
            border: 3px solid rgba(160, 129, 108, 0.3);
            border-radius: 50%;
            border-top-color: var(--primary-color);
            animation: spin 1s ease-in-out infinite;
        }
        @keyframes spin { to { transform: rotate(360deg); } }

        .main-container {
            max-width: 1100px;
            margin: 30px auto;
            padding: 0 15px;
        }

        .cart-header-row {
            display: grid;
            grid-template-columns: 50px 3fr 1fr 1fr 1fr 50px;
            background: var(--white);
            padding: 18px 25px;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-soft);
            margin-bottom: 15px;
            font-weight: 600;
            color: var(--text-light);
            align-items: center;
            text-align: center;
        }
        .header-left { text-align: left; grid-column: span 1; }
        .header-product { text-align: left; }

        .cart-item-card {
            background: var(--white);
            padding: 25px;
            margin-bottom: 15px;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-soft);
            display: grid;
            grid-template-columns: 50px 3fr 1fr 1fr 1fr 50px;
            align-items: center;
            transition: transform 0.2s, border-color 0.2s;
            border: 1px solid transparent;
            position: relative;
        }
        .cart-item-card:hover { transform: translateY(-2px); }
        .cart-item-card.item-disabled { opacity: 0.5; background: #fafafa; pointer-events: none; }
        .cart-item-card.item-disabled .col-action, 
        .cart-item-card.item-disabled .col-check { pointer-events: auto; }

        .col-check { display: flex; justify-content: center; align-items: center; }
        .form-check-input {
            width: 20px; height: 20px;
            cursor: pointer;
            border: 2px solid #ddd;
            border-radius: 4px;
        }
        .form-check-input:checked {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }
        .form-check-input:focus { box-shadow: 0 0 0 0.25rem rgba(160, 129, 108, 0.25); }

        .product-flex {
            display: flex;
            align-items: center;
            gap: 20px;
            text-align: left;
        }
        .cart-img-wrapper {
            width: 90px; height: 90px;
            border-radius: 8px;
            overflow: hidden;
            flex-shrink: 0;
            background: #f9f9f9;
        }
        .cart-img-wrapper img { width: 100%; height: 100%; object-fit: cover; }
        
        .product-details { display: flex; flex-direction: column; gap: 6px; }
        .product-name {
            font-weight: 600;
            font-size: 1.05rem;
            line-height: 1.4;
            color: var(--text-main);
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .product-name:hover { color: var(--primary-color); }

        .size-group { 
            display: flex; 
            align-items: center; 
            font-size: 0.9rem; 
            color: var(--text-light); 
        }
        .size-select {
            border: none;
            background: var(--bg-body);
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 0.9rem;
            color: var(--text-main);
            font-weight: 600;
            cursor: pointer;
            margin-left: 5px;
            outline: none;
        }
        .size-select:focus { background: #ececec; }

        .col-price { text-align: center; color: var(--text-light); }
        .col-total { text-align: center; font-weight: 700; color: var(--primary-color); font-size: 1.1rem; }
        
        .qty-wrapper { display: flex; justify-content: center; }
        .qty-control {
            display: flex;
            align-items: center;
            border: 1px solid #eee;
            border-radius: 8px;
            overflow: hidden;
            background: var(--white);
        }
        .qty-btn {
            width: 32px; height: 32px;
            border: none; background: #fff;
            color: var(--text-main);
            display: flex; align-items: center; justify-content: center;
            cursor: pointer; transition: 0.2s;
        }
        .qty-btn:hover { background: var(--primary-light); color: var(--primary-color); }
        .qty-input {
            width: 40px; height: 32px;
            border: none; text-align: center;
            font-weight: 600; color: var(--text-main);
            background: #fff; pointer-events: none;
        }

        .btn-remove {
            border: none; background: transparent;
            color: #999; font-size: 1.2rem;
            cursor: pointer; transition: 0.2s;
        }
        .btn-remove:hover { color: #dc3545; transform: scale(1.1); }

        .cart-warning-row { grid-column: 2 / -1; margin-top: 10px; font-size: 0.85rem; font-weight: 500; text-align: left; }
        .warning-text { color: #dc3545; display: flex; align-items: center; gap: 5px; }
        .warning-text.info { color: #e58e26; }

        /* --- STICKY BOTTOM BAR --- */
        .sticky-footer {
            position: fixed;
            bottom: 0; left: 0; width: 100%;
            background: var(--white);
            box-shadow: 0 -4px 20px rgba(0,0,0,0.08);
            z-index: 1000;
            padding: 0;
            height: var(--bar-height);
            display: flex; align-items: center;
        }
        .footer-content {
            max-width: 1100px;
            width: 100%;
            margin: 0 auto;
            padding: 0 15px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .footer-left { display: flex; align-items: center; gap: 15px; }
        .footer-right { display: flex; align-items: center; gap: 30px; }
        
        .select-all-label { cursor: pointer; user-select: none; font-weight: 500; color: var(--text-main); }
        
        .total-label { font-size: 1rem; color: var(--text-main); margin-right: 10px; }
        .total-price { font-size: 1.5rem; font-weight: 700; color: var(--primary-color); }
        
        .btn-checkout {
            background-color: var(--primary-color);
            color: var(--white);
            border: none;
            padding: 0 40px;
            height: 45px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 1rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            transition: 0.3s;
        }
        .btn-checkout:hover:not(:disabled) { background-color: var(--primary-dark); box-shadow: 0 4px 15px rgba(160, 129, 108, 0.4); }
        .btn-checkout:disabled { background-color: #ccc; cursor: not-allowed; }

        .empty-cart-box {
            background: var(--white);
            border-radius: var(--border-radius);
            padding: 60px 20px;
            text-align: center;
            box-shadow: var(--shadow-soft);
        }
        .empty-icon { font-size: 4rem; color: #eee; margin-bottom: 20px; }
        .btn-continue {
            display: inline-block; padding: 12px 35px;
            background: var(--text-main); color: white;
            border-radius: 8px; font-weight: 600;
            transition: 0.3s;
        }
        .btn-continue:hover { background: #000; }

        @media (max-width: 768px) {
            .cart-header-row { display: none; }
            .cart-item-card {
                display: flex; flex-wrap: wrap; gap: 15px;
                position: relative; padding: 20px;
            }
            .col-check { width: auto; position: absolute; top: 20px; left: 15px; z-index: 2; }
            .product-flex { width: 100%; padding-left: 30px; }
            .col-price { display: none; } 
            .qty-wrapper { width: auto; margin-left: auto; }
            .col-total { width: 100%; text-align: right; margin-top: 10px; display: flex; justify-content: space-between; align-items: center; }
            .col-total::before { content: "Total:"; color: #888; font-size: 0.9rem; font-weight: 500; }
            .col-action { position: absolute; top: 15px; right: 15px; }
            
            .footer-content { flex-direction: column; height: auto; padding: 15px; gap: 15px; align-items: stretch; }
            .sticky-footer { height: auto; }
            .footer-left { justify-content: space-between; }
            .footer-right { justify-content: space-between; width: 100%; gap: 0; }
            .total-price { font-size: 1.3rem; }
            .btn-checkout { flex: 1; margin-left: 15px; }
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
                <div class="empty-cart-box" data-aos="fade-up">
                    <i class="bi bi-cart-x empty-icon"></i>
                    <h3>Your cart is empty</h3>
                    <p class="text-muted mb-4">Looks like you haven't added anything to your cart yet.</p>
                    <a href="${pageContext.request.contextPath}/" class="btn-continue">Start Shopping</a>
                </div>
            </c:when>

            <c:otherwise>
                <div class="cart-header-row d-none d-md-grid">
                    <div class="col-check">
                        <input class="form-check-input" type="checkbox" id="selectAllTop" title="Select all">
                    </div>
                    <div class="header-product">Product</div>
                    <div>Unit Price</div>
                    <div>Quantity</div>
                    <div>Total</div>
                    <div></div>
                </div>

                <div class="cart-list">
                    <c:forEach items="${requestScope.cartList}" var="cart">
                        <c:set var="availableQty" value="${cart.stockQuantity}" />
                        <c:set var="isMissing" value="${empty nameProduct[cart.productID]}" />
                        <c:set var="isOutOfStock" value="${availableQty le 0}" />
                        <c:set var="isStopped" value="${activeP[cart.productID] != null and not activeP[cart.productID]}" />
                        <c:set var="isInsufficient" value="${availableQty lt cart.quantity}" />
                        <c:set var="hasError" value="${isMissing or isOutOfStock or isStopped}" />

                        <c:set var="priceNow" value="${priceP[cart.productID]}" />
                        <c:if test="${empty priceNow}"><c:set var="priceNow" value="${cart.price}" /></c:if>

                        <c:set var="lineTotal" value="${priceNow * cart.quantity}" />

                        <div class="cart-item-card ${hasError ? 'item-disabled' : ''}" 
                             data-id="${cart.productID}" 
                             data-row-id="${cart.productID}">

                            <div class="col-check">
                                <input class="form-check-input item-check" 
                                       type="checkbox" 
                                       data-id="${cart.productID}" 
                                       data-size="${cart.size_name}"
                                       data-price="${priceNow}"
                                       data-stock="${availableQty}"
                                       data-locked="${hasError}"
                                       data-auto-recheck="${isInsufficient}"
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
                                                <select class="size-select action-change-size" <c:if test="${hasError}">disabled</c:if>>
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
                                <fmt:formatNumber value="${priceNow}" pattern="###,###" /> VND
                            </div>

                            <div class="qty-wrapper">
                                <div class="qty-control">
                                    <button type="button" class="qty-btn btn-decrease" <c:if test="${hasError}">disabled</c:if>>
                                        <i class="bi bi-dash"></i>
                                    </button>
                                    <input type="text" class="qty-input" value="${cart.quantity}" readonly>
                                    <button type="button" class="qty-btn btn-increase" <c:if test="${hasError}">disabled</c:if>>
                                        <i class="bi bi-plus"></i>
                                    </button>
                                </div>
                            </div>

                            <div class="col-total">
                                <span class="line-total-display"><fmt:formatNumber value="${lineTotal}" pattern="###,###" /></span> VND
                            </div>

                            <div class="col-action">
                                <button class="btn-remove action-delete">
                                    <i class="bi bi-trash3"></i>
                                </button>
                            </div>

                            <c:if test="${hasError or isInsufficient}">
                                <div class="cart-warning-row">
                                    <c:choose>
                                        <c:when test="${isMissing or isStopped}">
                                            <div class="warning-text"><i class="bi bi-x-circle-fill"></i> Product unavailable. Please remove.</div>
                                        </c:when>
                                        <c:when test="${isOutOfStock}">
                                            <div class="warning-text"><i class="bi bi-x-circle-fill"></i> Out of stock.</div>
                                        </c:when>
                                        <c:when test="${isInsufficient}">
                                            <div class="warning-text info warn-insufficient">
                                                <i class="bi bi-exclamation-circle-fill"></i> Only ${availableQty} left. Please reduce quantity.
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
                        <div class="footer-left">
                            <div class="d-flex align-items-center">
                                <input class="form-check-input me-2" type="checkbox" id="selectAllBottom">
                                <label for="selectAllBottom" class="select-all-label">Select All (<span id="countSelected">0</span>)</label>
                            </div>
                            <button class="btn btn-link text-danger text-decoration-none p-0 ms-3" id="deleteSelectedBtn" style="font-size: 0.95rem; display:none;">Delete</button>
                        </div>

                        <div class="footer-right">
                            <div class="d-flex align-items-baseline">
                                <span class="total-label">Total Payment:</span>
                                <span class="total-price" id="grandTotalDisplay">0 VND</span>
                            </div>
                            
                            <form id="checkoutForm" action="${pageContext.request.contextPath}/loadPayment" method="get">
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
                    <h6 class="mb-4">Remove this item from cart?</h6>
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
        function formatVND(amount) { 
            return (amount || 0).toLocaleString('vi-VN') + " VND"; 
        }

        // --- Core Logic using Event Delegation ---

        $(document).ready(function() {
            // Remove Loader
            setTimeout(() => { $('#page-loader').fadeOut(); }, 400);

            // Sync Checkboxes
            const allChecks = $('.item-check');
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

                // Update Master Checkbox State
                const totalEnabled = $('.item-check:not(:disabled)').length;
                const totalChecked = $('.item-check:checked').length;
                
                if (totalEnabled > 0 && totalEnabled === totalChecked) {
                    syncMasters(true);
                    masterTop.prop('indeterminate', false);
                    masterBot.prop('indeterminate', false);
                } else {
                    syncMasters(false);
                    if (totalChecked > 0) {
                        masterTop.prop('indeterminate', true);
                        masterBot.prop('indeterminate', true);
                    } else {
                        masterTop.prop('indeterminate', false);
                        masterBot.prop('indeterminate', false);
                    }
                }
            }

            // Checkbox Events
            $('#selectAllTop, #selectAllBottom').on('change', function() {
                const isChecked = $(this).prop('checked');
                syncMasters(isChecked);
                $('.item-check:not(:disabled)').prop('checked', isChecked);
                updateSummary();
            });

            $('.item-check').on('change', updateSummary);

            // Quantity Increase
            $(document).on('click', '.btn-increase', function() {
                const row = $(this).closest('.cart-item-card');
                const qtyInput = row.find('.qty-input');
                const checkbox = row.find('.item-check');
                
                const currentQty = parseInt(qtyInput.val()) || 1;
                const newQty = currentQty + 1;
                const pid = row.data('id');
                const price = checkbox.data('price');
                const size = checkbox.data('size'); // Get dynamic size from checkbox

                $.ajax({
                    url: BASE + '/cartIncrease', method: 'GET',
                    data: {id: pid, price: price, quantity: newQty, size: size},
                    success: function(resp) {
                        const parts = (resp || '').split(',');
                        // Check logic based on your backend response. 
                        // Assuming parts[2] == 0 means OK (no error code)
                        const errCode = parseInt(parts[2] || '0'); 
                        
                        if (errCode === 0) {
                            qtyInput.val(newQty);
                            const lineTotal = newQty * price;
                            row.find('.line-total-display').text(lineTotal.toLocaleString('vi-VN'));
                            updateSummary();
                        } else {
                            alert('Stock limit reached for this item.');
                        }
                    }
                });
            });

            // Quantity Decrease
            $(document).on('click', '.btn-decrease', function() {
                const row = $(this).closest('.cart-item-card');
                const qtyInput = row.find('.qty-input');
                const checkbox = row.find('.item-check');

                const currentQty = parseInt(qtyInput.val()) || 1;
                if (currentQty <= 1) return;

                const newQty = currentQty - 1;
                const pid = row.data('id');
                const price = checkbox.data('price');
                const size = checkbox.data('size');

                $.ajax({
                    url: BASE + '/cartDecrease', method: 'GET',
                    data: {id: pid, price: price, quantity: newQty, size: size},
                    success: function(resp) {
                        qtyInput.val(newQty);
                        const lineTotal = newQty * price;
                        row.find('.line-total-display').text(lineTotal.toLocaleString('vi-VN'));
                        updateSummary();
                    }
                });
            });

            // Change Size (NO RELOAD)
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
                        // Assuming response format: "OK" or "OK,..." 
                        if (response && response.includes('OK')) {
                            // Update DOM values without reload
                            oldSizeInput.val(newSize);
                            checkbox.data('size', newSize); // Critical: Update data-size for other buttons
                            checkbox.attr('data-size', newSize);
                            
                            // Note: If price changes by size, backend needs to send new price.
                            // Currently assuming price stays same or waiting for refresh.
                        } else {
                            alert('Cannot switch to this size (Out of stock or error).');
                            selectEl.val(oldSize); // Revert
                        }
                    },
                    error: function() {
                        alert('Error connecting to server.');
                        selectEl.val(oldSize);
                    }
                });
            });

            // Delete Handling
            let deleteTarget = null;
            $(document).on('click', '.action-delete', function() {
                const row = $(this).closest('.cart-item-card');
                const checkbox = row.find('.item-check');
                deleteTarget = {
                    el: row,
                    id: row.data('id'),
                    size: checkbox.data('size') // Get current dynamic size
                };
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

                        deleteTarget.el.css({ opacity: 0, transform: 'scale(0.95)' });
                        setTimeout(() => {
                            deleteTarget.el.remove();
                            updateSummary();
                            if ($('.cart-item-card').length === 0) location.reload();
                        }, 300);
                    }
                });
            });

            // Form Submit Intercept
            $('#checkoutForm').on('submit', function(e) {
                const checked = $('.item-check:checked');
                if (checked.length === 0) {
                    e.preventDefault();
                    return;
                }
                
                // Clear old inputs
                $(this).find('input[name="selectedItems"]').remove();

                // Add selected items
                checked.each(function() {
                    const id = $(this).data('id');
                    const size = $(this).data('size'); // Uses updated size
                    $('<input>').attr({
                        type: 'hidden',
                        name: 'selectedItems',
                        value: id + '::' + size
                    }).appendTo('#checkoutForm');
                });
            });

            // Initial calc
            updateSummary();
        });
    </script>
</body>
</html>