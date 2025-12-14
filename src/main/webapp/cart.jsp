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
            function safeIdPart(s) {
                return (s || '').toString().replace(/\W/g, '_');
            }
        </script>

        <style>
            /* --- VARIABLES --- */
            :root {
                --primary-color: #a0816c;
                --primary-dark: #8a6d5a;
                --text-main: #333;
                --text-light: #777;
                --bg-body: #f5f5f5;
                --white: #ffffff;
                --border-color: #e8e8e8;
            }

            body {
                font-family: 'Quicksand', sans-serif;
                background-color: var(--bg-body);
                color: var(--text-main);
                padding-bottom: 50px;
                font-size: 14px;
            }

            a {
                text-decoration: none;
                color: inherit;
            }

            /* --- LOADING --- */
            #page-loader {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-color: var(--white);
                z-index: 99999;
                display: flex;
                justify-content: center;
                align-items: center;
                transition: opacity 0.4s ease-out, visibility 0.4s;
            }
            .spinner-custom {
                width: 50px;
                height: 50px;
                border: 3px solid rgba(160, 129, 108, 0.3);
                border-radius: 50%;
                border-top-color: var(--primary-color);
                animation: spin 1s ease-in-out infinite;
            }
            @keyframes spin {
                to {
                    transform: rotate(360deg);
                }
            }

            /* --- STEP BAR --- */
            .checkout-steps {
                display: flex;
                justify-content: center;
                margin: 20px 0 30px 0;
            }
            .step-item {
                display: flex;
                align-items: center;
                color: #ccc;
                font-weight: 600;
                font-size: 0.95rem;
            }
            .step-item.active {
                color: var(--text-main);
            }
            .step-item.active .step-count {
                background-color: var(--primary-color);
                border-color: var(--primary-color);
                color: #fff;
            }
            .step-count {
                width: 28px;
                height: 28px;
                border-radius: 50%;
                border: 2px solid #ccc;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-right: 8px;
                font-size: 0.85rem;
            }
            .step-line {
                width: 40px;
                height: 2px;
                background-color: #e0e0e0;
                margin: 0 10px;
            }

            /* --- LAYOUT --- */
            .main-container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 0 15px;
            }

            /* =================================================================
               GRID LAYOUT SYSTEM (SHOPEE STYLE - CÂN ĐỐI)
               ================================================================= */

            /* Định nghĩa cột dùng chung cho Header và Item Row */
            /* Cột: [Ảnh 100px] [Info Tự giãn] [Đơn giá 120px] [Số lượng 120px] [Thành tiền 120px] [Xóa 50px] */
            .grid-template {
                display: grid;
                grid-template-columns: 100px 1fr 120px 130px 140px 50px;
                gap: 15px;
                align-items: center; /* Quan trọng: Căn giữa theo chiều dọc */
            }

            /* --- Header Row --- */
            .cart-header {
                padding: 15px 20px;
                background: #fff;
                border-radius: 3px;
                box-shadow: 0 1px 1px 0 rgba(0,0,0,.05);
                margin-bottom: 12px;
                color: #888;
                font-weight: 500;
                text-align: center;
                font-size: 0.9rem;
            }
            .header-start {
                text-align: left;
            }
            .header-end {
                text-align: right;
            }

            /* --- Cart Item Card --- */
            .cart-item-card {
                background: var(--white);
                padding: 20px;
                margin-bottom: 12px;
                box-shadow: 0 1px 1px 0 rgba(0,0,0,.05);
                border-radius: 3px;
                border: 1px solid transparent;
                transition: all 0.2s;
            }
            .cart-item-card:hover {
                border-color: rgba(160, 129, 108, 0.3);
            }
            .cart-item-card.item-disabled {
                opacity: 0.6;
                background-color: #fafafa;
            }

            /* 1. Image */
            .cart-img-wrapper {
                width: 80px;
                height: 80px;
                flex-shrink: 0;
                border: 1px solid #e1e1e1;
                background: #f9f9f9;
            }
            .cart-img-wrapper img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            /* 2. Info (Name + Size) */
            .cart-info {
                display: flex;
                flex-direction: column;
                gap: 5px;
                text-align: left;
            }
            .product-name {
                font-size: 1rem;
                font-weight: 600;
                color: rgba(0,0,0,.87);
                line-height: 1.4;
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
                overflow: hidden;
                text-decoration: none;
            }
            .product-name:hover {
                color: var(--primary-color);
            }

            /* Size Dropdown (Nằm dưới tên) */
            .size-wrapper {
                display: flex;
                align-items: center;
            }
            .size-label {
                font-size: 0.8rem;
                color: #999;
                margin-right: 5px;
            }
            .size-select {
                padding: 2px 8px;
                border: 1px solid #ddd;
                border-radius: 2px;
                background-color: #fff;
                font-size: 0.8rem;
                color: #555;
                cursor: pointer;
                outline: none;
            }
            .size-select:focus {
                border-color: var(--primary-color);
            }

            /* 3. Unit Price */
            .col-unit-price {
                text-align: center;
                color: #666;
                font-size: 0.95rem;
            }

            /* 4. Quantity (Căn giữa ô) */
            .col-qty {
                display: flex;
                justify-content: center;
            }
            .qty-control {
                display: flex;
                align-items: center;
                border: 1px solid #ddd;
                border-radius: 2px;
            }
            .qty-btn {
                width: 30px;
                height: 30px;
                border: none;
                background: #fff;
                display: flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
                transition: 0.2s;
                color: #333;
            }
            .qty-btn:hover:not(:disabled) {
                background: #f8f8f8;
                color: var(--primary-color);
            }
            .qty-btn:first-child {
                border-right: 1px solid #ddd;
            }
            .qty-btn:last-child {
                border-left: 1px solid #ddd;
            }

            .qty-input {
                width: 45px;
                height: 30px;
                border: none;
                text-align: center;
                font-weight: 500;
                color: var(--text-main);
                font-size: 0.95rem;
                background: #fff;
                pointer-events: none;
            }

            /* 5. Total Price */
            .col-total {
                text-align: right;
            }
            .line-total {
                font-size: 1rem;
                font-weight: 700;
                color: var(--primary-color);
                display: block;
            }
            .old-price {
                font-size: 0.85rem;
                color: #999;
                text-decoration: line-through;
            }

            /* 6. Action */
            .col-action {
                text-align: center;
            }
            .btn-remove {
                border: none;
                background: transparent;
                color: #333;
                font-size: 1.1rem;
                cursor: pointer;
                transition: 0.2s;
            }
            .btn-remove:hover {
                color: #dc3545;
            }

            /* Warnings */
            .cart-warning {
                font-size: 0.75rem;
                margin-top: 4px;
                font-weight: 500;
            }
            .cart-warning.error {
                color: #dc3545;
            }
            .cart-warning.info {
                color: #fd7e14;
            }

            /* --- ORDER SUMMARY (Sticky Right) --- */
            .summary-card {
                background: var(--white);
                border-radius: 3px;
                padding: 20px;
                box-shadow: 0 1px 1px 0 rgba(0,0,0,.05);
                position: sticky;
                top: 80px;
            }
            .summary-header {
                font-size: 1.1rem;
                font-weight: 700;
                margin-bottom: 20px;
                padding-bottom: 15px;
                border-bottom: 1px dashed #ddd;
            }
            .summary-row {
                display: flex;
                justify-content: space-between;
                margin-bottom: 12px;
                font-size: 0.95rem;
                color: #666;
            }
            .summary-row.total {
                border-top: 1px dashed #ddd;
                padding-top: 15px;
                margin-top: 15px;
                color: var(--text-main);
                font-weight: 700;
                font-size: 1.2rem;
                align-items: center;
            }
            .text-highlight {
                color: var(--primary-color) !important;
                font-size: 1.4rem;
            }

            .checkout-btn {
                width: 100%;
                padding: 12px;
                margin-top: 20px;
                background-color: var(--primary-color);
                color: white;
                border: none;
                border-radius: 2px;
                font-weight: 600;
                font-size: 1rem;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                transition: all 0.2s;
            }
            .checkout-btn:hover:not(:disabled) {
                background-color: var(--primary-dark);
                opacity: 0.9;
            }
            .checkout-btn:disabled {
                background-color: #ccc;
                cursor: not-allowed;
            }

            /* --- EMPTY STATE --- */
            .empty-cart-box {
                background: white;
                border-radius: 3px;
                padding: 60px 20px;
                text-align: center;
                box-shadow: 0 1px 1px 0 rgba(0,0,0,.05);
            }
            .empty-icon {
                font-size: 4rem;
                color: #ddd;
                margin-bottom: 15px;
            }
            .btn-continue {
                display: inline-block;
                padding: 10px 30px;
                background: var(--text-main);
                color: white;
                border-radius: 2px;
                font-weight: 600;
                margin-top: 15px;
                transition: 0.3s;
            }
            .btn-continue:hover {
                background: #000;
                color: white;
            }

            /* --- RESPONSIVE MOBILE --- */
            @media (max-width: 768px) {
                .cart-header {
                    display: none;
                }

                .cart-item-card {
                    display: block;
                    position: relative;
                    padding: 15px;
                }

                .grid-template {
                    display: flex;
                    flex-wrap: wrap;
                    gap: 0;
                }

                /* Layout Mobile */
                .cart-img-wrapper {
                    width: 80px;
                    height: 80px;
                    margin-right: 15px;
                    margin-bottom: 10px;
                }
                .cart-info {
                    width: calc(100% - 100px);
                    margin-bottom: 10px;
                }
                .col-unit-price {
                    display: none;
                } /* Ẩn đơn giá trên mobile */

                .col-qty {
                    width: auto;
                    margin-right: auto;
                }
                .col-total {
                    width: auto;
                    margin-left: auto;
                    text-align: right;
                }

                .col-action {
                    position: absolute;
                    top: 10px;
                    right: 10px;
                }

                .checkout-steps {
                    display: none;
                }
            }
        </style>
    </head>

    <body>
        <div id="page-loader"><div class="spinner-custom"></div></div>

        <%@ include file="header.jsp" %>

        <div class="main-container">

            <c:choose>
                <%-- EMPTY CART --%>
                <c:when test="${empty requestScope.cartList}">
                    <div class="empty-cart-box mt-4" data-aos="fade-up">
                        <i class="bi bi-cart-x empty-icon"></i>
                        <h3>Your cart is empty</h3>
                        <p class="text-muted">Looks like you haven't added anything to your cart yet.</p>
                        <a href="${pageContext.request.contextPath}/" class="btn-continue">Start Shopping</a>
                    </div>
                </c:when>

                <%-- HAS ITEMS --%>
                <c:otherwise>
                    <div class="checkout-steps">
                        <div class="step-item active"><span class="step-count">1</span> Shopping Cart</div>
                        <div class="step-line"></div>
                        <div class="step-item"><span class="step-count">2</span> Checkout</div>
                        <div class="step-line"></div>
                        <div class="step-item"><span class="step-count">3</span> Order Complete</div>
                    </div>

                    <div class="row g-4">
                        <div class="col-lg-8">

                            <div class="cart-header grid-template d-none d-md-grid">
                                <div class="header-start" style="grid-column: span 2;">Product</div>
                                <div>Unit Price</div>
                                <div>Quantity</div>
                                <div class="header-end">Total Price</div>
                                <div><i class="bi bi-trash3"></i></div>
                            </div>

                            <c:set var="hasCartError" value="false" />
                            <div class="cart-items-column">
                                <c:forEach items="${requestScope.cartList}" var="cart">

                                    <c:set var="availableQty" value="${cart.stockQuantity}" />
                                    <c:set var="isMissingProduct" value="${empty nameProduct[cart.productID]}" />
                                    <c:set var="isOutOfStock" value="${availableQty le 0}" />
                                    <c:set var="isStoppedSelling" value="${activeP[cart.productID] != null and not activeP[cart.productID]}" />
                                    <c:set var="isInsufficient" value="${availableQty lt cart.quantity}" />
                                    <c:if test="${isMissingProduct or isOutOfStock or isInsufficient or isStoppedSelling}">
                                        <c:set var="hasCartError" value="true" />
                                    </c:if>

                                    <c:set var="priceAtAdd" value="${cart.price}" />
                                    <c:set var="priceNow" value="${priceP[cart.productID]}" />
                                    <c:if test="${empty priceNow}"><c:set var="priceNow" value="${priceAtAdd}" /></c:if>
                                    <c:set var="hasPriceChanged" value="${not empty priceNow and priceNow ne priceAtAdd}" />
                                    <c:set var="safeSize" value="${fn:replace(fn:replace(cart.size_name, ' ', '_'), '-', '_')}" />
                                    <c:set var="lineCurrent" value="${priceNow * cart.quantity}" />
                                    <fmt:formatNumber var="lineCurrentFmt" type="number" value="${lineCurrent}" pattern="###,###" />
                                    <c:set var="lineOriginal" value="${priceAtAdd * cart.quantity}" />
                                    <fmt:formatNumber var="lineOriginalFmt" type="number" value="${lineOriginal}" pattern="###,###" />
                                    <fmt:formatNumber var="unitPriceFmt" type="number" value="${priceNow}" pattern="###,###" />

                                    <div class="cart-item-card grid-template ${isMissingProduct or isOutOfStock or isStoppedSelling ? 'item-disabled' : ''}" 
                                         id='user${cart.productID}${safeSize}'>

                                        <div class="cart-img-wrapper">
                                            <a href="${pageContext.request.contextPath}/productDetail?id=${cart.productID}">
                                                <img src="${picUrlMap[cart.productID]}" alt="${nameProduct[cart.productID]}">
                                            </a>
                                        </div>

                                        <div class="cart-info">
                                            <a href="${pageContext.request.contextPath}/productDetail?id=${cart.productID}" class="product-name">
                                                ${nameProduct[cart.productID]}
                                            </a>

                                            <div class="size-wrapper mt-1">
                                                <span class="size-label">Size:</span>
                                                <c:set var="sizesOfProduct" value="${productSizeMap[cart.productID]}" />
                                                <c:choose>
                                                    <c:when test="${not empty sizesOfProduct}">
                                                        <select class="size-select"
                                                                onchange="changeSize(${cart.productID}, '${cart.size_name}', this)"
                                                                <c:if test="${isMissingProduct or isOutOfStock or isStoppedSelling}">disabled</c:if>>
                                                            <c:forEach var="sz" items="${sizesOfProduct}">
                                                                <option value="${sz}" <c:if test="${sz eq cart.size_name}">selected</c:if>>${sz}</option>
                                                            </c:forEach>
                                                        </select>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-light text-dark border">${cart.size_name}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>

                                            <c:choose>
                                                <c:when test="${isMissingProduct}"><div class="cart-warning error">This product is no longer available. Please remove it from your cart.</div></c:when>
                                                <c:when test="${isStoppedSelling}"><div class="cart-warning error">This product is no longer for sale. Please remove it from your cart.</div></c:when>
                                                <c:when test="${isOutOfStock}"><div class="cart-warning error">This item is out of stock. Please remove it from your cart.</div></c:when>
                                                <c:when test="${isInsufficient}"><div class="cart-warning info"> Only ${availableQty} item(s) left in stock. Please reduce your quantity.</div></c:when>
                                            </c:choose>
                                        </div>

                                        <div class="col-unit-price">
                                            ${unitPriceFmt} ₫
                                        </div>

                                        <div class="col-qty">
                                            <div class="qty-control">
                                                <button type="button" class="qty-btn"
                                                        onclick="decrementQuantity(${cart.productID},${priceNow},${cart.quantity}, '${cart.size_name}')"
                                                        <c:if test="${isMissingProduct or isOutOfStock or isStoppedSelling}">disabled</c:if>>
                                                            <i class="bi bi-dash"></i>
                                                        </button>

                                                        <input type="text" class="qty-input"
                                                               id="quantity${cart.productID}${safeSize}"
                                                        value="${cart.quantity}" readonly>

                                                <button type="button" class="qty-btn"
                                                        onclick="incrementQuantity2(${cart.productID},${priceNow},${cart.quantity}, '${cart.size_name}')"
                                                        <c:if test="${isMissingProduct or isOutOfStock or isStoppedSelling}">disabled</c:if>>
                                                            <i class="bi bi-plus"></i>
                                                        </button>
                                                </div>
                                            </div>

                                            <div class="col-total">
                                                <span class="line-total" id="price2${cart.productID}${safeSize}">${lineCurrentFmt} ₫</span>
                                            <c:if test="${hasPriceChanged}">
                                                <div class="old-price" id="price1${cart.productID}${safeSize}">${lineOriginalFmt} ₫</div>
                                            </c:if>
                                        </div>

                                        <div class="col-action">
                                            <button class="btn-remove"
                                                    onclick="showDeleteConfirm(${cart.productID}, '${cart.size_name}')"
                                                    id="btnDel${cart.productID}">
                                                <i class="bi bi-trash3"></i>
                                            </button>
                                        </div>

                                        <input type="hidden" class="price" value="${cart.price}">
                                        <input type="hidden" class="quantity" value="${cart.quantity}">
                                        <input type="hidden" class="size" value="${cart.size_name}">
                                    </div>
                                </c:forEach>
                            </div>
                        </div>

                        <div class="col-lg-4">
                            <div class="summary-card">
                                <div class="summary-header">Order Summary</div>
                                <div class="summary-row">
                                    <span>Subtotal</span>
                                    <span id="sum" class="fw-bold text-dark">0 VND</span>
                                </div>
                                <div class="summary-row total">
                                    <span>Total</span>
                                    <span id="grandTotal" class="text-highlight">0 VND</span>
                                </div>

                                <form action="${pageContext.request.contextPath}/loadPayment" method="get">
                                    <button class="checkout-btn" <c:if test="${hasCartError}">disabled</c:if>>
                                            Check Out
                                        </button>
                                        <input type="hidden" name="size" value="${size}">
                                    <input type="hidden" id="subtotalInput" name="total" value="0">
                                    <input type="hidden" id="discountInput" name="discount" value="0">
                                    <input type="hidden" id="grandTotalInput" name="grandTotal" value="0">
                                </form>

                                <c:if test="${hasCartError}">
                                    <div class="cart-warning error mt-2 text-center">
                                        Please remove unavailable items.
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-sm">
                <div class="modal-content border-0 shadow" style="border-radius: 4px;">
                    <div class="modal-body text-center p-4">
                        <div class="mb-3 text-warning"><i class="bi bi-exclamation-circle display-4"></i></div>
                        <h6 class="mb-3">Do you want to remove this item?</h6>
                        <div class="d-flex gap-2 justify-content-center">
                            <button type="button" class="btn btn-light px-4" data-bs-dismiss="modal">No</button>
                            <button type="button" class="btn btn-danger px-4" id="confirmDeleteBtn">Yes</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/js/jquery-3.7.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <script>
                                                        // --- UTILS ---
                                                        function formatVND(amount) {
                                                            return (amount || 0).toLocaleString('vi-VN') + "\u00A0VND";
                                                        }
                                                        function onlyDigits(s) {
                                                            return (s || '').toString().replace(/[^\d]/g, '');
                                                        }
                                                        function toInt(text) {
                                                            return parseInt(onlyDigits(text), 10) || 0;
                                                        }

                                                        // --- CALCULATION LOGIC ---
                                                        function calcSubtotalFromDom() {
                                                            let subtotal = 0;
                                                            document.querySelectorAll('.cart-item-card').forEach(itemCard => {
                                                                const lineTotalEl = itemCard.querySelector('.line-total');
                                                                if (lineTotalEl)
                                                                    subtotal += toInt(lineTotalEl.textContent);
                                                            });
                                                            return subtotal;
                                                        }

                                                        function recalcTotals() {
                                                            const subtotal = calcSubtotalFromDom();
                                                            const grand = subtotal; // Logic tính tổng

                                                            const sumEl = document.getElementById('sum');
                                                            const grandEl = document.getElementById('grandTotal');

                                                            if (sumEl)
                                                                sumEl.innerHTML = formatVND(subtotal);
                                                            if (grandEl)
                                                                grandEl.innerHTML = formatVND(grand);

                                                            if (document.getElementById('subtotalInput'))
                                                                document.getElementById('subtotalInput').value = subtotal;
                                                            if (document.getElementById('grandTotalInput'))
                                                                document.getElementById('grandTotalInput').value = grand;
                                                        }

                                                        // --- AJAX OPERATIONS (LOGIC GỐC) ---
                                                        function incrementQuantity2(productID, price, quantity, size_name) {
                                                            const safe = safeIdPart(size_name);
                                                            const qtyInput = document.getElementById('quantity' + productID + safe);
                                                            const newQty = (parseInt(qtyInput.value, 10) || 1) + 1;

                                                            $.ajax({
                                                                url: BASE + '/cartIncrease', method: 'GET',
                                                                data: {id: productID, price: price, quantity: newQty, size: size_name},
                                                                success: function (response) {
                                                                    const values = (response || '').split(',');
                                                                    const line = parseInt(values[0] || '0', 10);
                                                                    const temp = parseInt(values[2] || '0', 10);
                                                                    if (temp === 0) {
                                                                        qtyInput.value = newQty;
                                                                        const holder = document.querySelector('#price2' + productID + safe + ' .line-total');
                                                                        holder.textContent = (isNaN(line) || line <= 0) ? formatVND(price * newQty) : formatVND(line);
                                                                        recalcTotals();
                                                                    } else {
                                                                        alert('Sorry! Max stock reached.');
                                                                    }
                                                                },
                                                                error: function () {
                                                                    alert('Error updating cart');
                                                                }
                                                            });
                                                        }

                                                        function decrementQuantity(productID, price, quantity, size_name) {
                                                            const safe = safeIdPart(size_name);
                                                            const qtyInput = document.getElementById('quantity' + productID + safe);
                                                            const newQty = (parseInt(qtyInput.value, 10) || 1) - 1;
                                                            if (newQty <= 0)
                                                                return;

                                                            $.ajax({
                                                                url: BASE + '/cartDecrease', method: 'GET',
                                                                data: {id: productID, price: price, quantity: newQty, size: size_name},
                                                                success: function (response) {
                                                                    const values = (response || '').split(',');
                                                                    const line = parseInt(values[0] || '0', 10);
                                                                    qtyInput.value = newQty;
                                                                    const holder = document.querySelector('#price2' + productID + safe + ' .line-total');
                                                                    holder.textContent = (isNaN(line) || line <= 0) ? formatVND(price * newQty) : formatVND(line);
                                                                    recalcTotals();
                                                                },
                                                                error: function () {
                                                                    alert('Error updating cart');
                                                                }
                                                            });
                                                        }

                                                        function changeSize(productID, oldSize, selectEl) {
                                                            const newSize = selectEl.value;
                                                            if (!newSize || newSize === oldSize)
                                                                return;

                                                            $.ajax({
                                                                url: BASE + '/cartChangeSize', method: 'GET',
                                                                data: {id: productID, oldSize: oldSize, newSize: newSize},
                                                                success: function (response) {
                                                                    if (!response) {
                                                                        alert('Failed to change size.');
                                                                        selectEl.value = oldSize;
                                                                        return;
                                                                    }
                                                                    const parts = response.split(',');
                                                                    const status = parts[0];
                                                                    if (status === 'OK') {
                                                                        location.reload();
                                                                    } else if (status === 'OUT_OF_STOCK') {
                                                                        alert('Selected size is out of stock.');
                                                                        selectEl.value = oldSize;
                                                                    } else if (status === 'NOT_ENOUGH_STOCK') {
                                                                        alert('Not enough stock for the selected size.');
                                                                        selectEl.value = oldSize;
                                                                    } else {
                                                                        alert('Failed to change size.');
                                                                        selectEl.value = oldSize;
                                                                    }
                                                                },
                                                                error: function () {
                                                                    alert('Error changing size.');
                                                                    selectEl.value = oldSize;
                                                                }
                                                            });
                                                        }

                                                        // --- DELETE LOGIC ---
                                                        let deleteTarget = null;
                                                        function showDeleteConfirm(productID, size_name) {
                                                            deleteTarget = {id: productID, size: size_name};
                                                            const modal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
                                                            modal.show();
                                                        }

                                                        document.getElementById('confirmDeleteBtn').addEventListener('click', function () {
                                                            if (!deleteTarget)
                                                                return;
                                                            $.ajax({
                                                                url: BASE + '/cartDelete', method: 'GET',
                                                                data: {id: deleteTarget.id, size: deleteTarget.size},
                                                                success: function () {
                                                                    const safe = safeIdPart(deleteTarget.size);
                                                                    const row = document.getElementById('user' + deleteTarget.id + safe);
                                                                    const modalEl = document.getElementById('deleteConfirmModal');
                                                                    const modal = bootstrap.Modal.getInstance(modalEl);
                                                                    modal.hide();
                                                                    if (row) {
                                                                        row.style.transition = 'all 0.3s ease';
                                                                        row.style.opacity = '0';
                                                                        row.style.transform = 'translateX(20px)';
                                                                        setTimeout(() => {
                                                                            row.remove();
                                                                            recalcTotals();
                                                                            if (document.querySelectorAll('.cart-item-card').length === 0)
                                                                                location.reload();
                                                                        }, 300);
                                                                    }
                                                                },
                                                                error: function () {
                                                                    alert('Delete failed');
                                                                }
                                                            });
                                                        });

                                                        // --- INIT ---
                                                        document.addEventListener('DOMContentLoaded', function () {
                                                            setTimeout(() => {
                                                                const loader = document.getElementById('page-loader');
                                                                if (loader) {
                                                                    loader.style.opacity = 0;
                                                                    setTimeout(() => loader.remove(), 400);
                                                                }
                                                            }, 400);
                                                            recalcTotals();
                                                        });
        </script>
    </body>
</html>