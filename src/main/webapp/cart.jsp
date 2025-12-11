<%-- 
    Document    : cart.jsp
    Updated     : Changed Currency to VND & Red Total Color
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- JSTL core / fmt / fn --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- 1. Login Requirement --%>
<c:if test="${empty sessionScope.acc}">
    <c:redirect url="${pageContext.request.contextPath}/login.jsp"/>
</c:if>
<c:set var="acc" value="${sessionScope.acc}" />

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
            /* --- VARIABLES & RESET --- */
            :root {
                --primary-color: #a0816c;
                --primary-dark: #8a6d5a;
                --text-main: #333;
                --text-light: #666;
                --bg-body: #f5f7f9;
                --white: #ffffff;
                --border-radius: 16px;
                --shadow-sm: 0 2px 8px rgba(0,0,0,0.04);
                --shadow-md: 0 8px 24px rgba(0,0,0,0.08);
            }

            body {
                font-family: 'Quicksand', sans-serif;
                background-color: var(--bg-body);
                color: var(--text-main);
                padding-bottom: 50px;
            }

            a { text-decoration: none; color: inherit; }

            /* --- LOADING OVERLAY --- */
            #page-loader {
                position: fixed; top: 0; left: 0; width: 100%; height: 100%;
                background-color: var(--white); z-index: 99999;
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

            /* --- STEP PROGRESS BAR --- */
            .checkout-steps {
                display: flex; justify-content: center; margin: 30px 0 40px 0;
            }
            .step-item {
                display: flex; align-items: center; color: #ccc; font-weight: 600; font-size: 0.95rem;
            }
            .step-item.active { color: var(--text-main); }
            .step-item.active .step-count { background-color: var(--primary-color); border-color: var(--primary-color); color: #fff; }
            .step-count {
                width: 32px; height: 32px; border-radius: 50%; border: 2px solid #ccc;
                display: flex; align-items: center; justify-content: center;
                margin-right: 10px; font-size: 0.9rem;
            }
            .step-line {
                width: 60px; height: 2px; background-color: #e0e0e0; margin: 0 15px;
            }

            /* --- LAYOUT --- */
            .main-container { max-width: 1200px; margin: 0 auto; padding: 0 20px; }
            .section-title { font-weight: 700; font-size: 1.8rem; margin-bottom: 25px; color: var(--text-main); }

            /* --- CART ITEM CARD --- */
            .cart-item-card {
                background: var(--white);
                border-radius: var(--border-radius);
                padding: 20px;
                margin-bottom: 20px;
                box-shadow: var(--shadow-sm);
                display: flex; align-items: center;
                transition: transform 0.2s, box-shadow 0.2s;
                border: 1px solid transparent;
            }
            .cart-item-card:hover {
                transform: translateY(-3px);
                box-shadow: var(--shadow-md);
                border-color: rgba(160, 129, 108, 0.2);
            }

            /* Image */
            .cart-img-wrapper {
                width: 100px; height: 120px; flex-shrink: 0;
                border-radius: 10px; overflow: hidden; background: #f9f9f9;
            }
            .cart-img-wrapper img { width: 100%; height: 100%; object-fit: cover; }

            /* Info */
            .cart-info { flex-grow: 1; padding: 0 25px; }
            .product-name {
                font-size: 1.1rem; font-weight: 700; color: var(--text-main);
                margin-bottom: 5px; display: block;
                display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;
            }
            .product-name:hover { color: var(--primary-color); }
            .product-meta { font-size: 0.9rem; color: var(--text-light); margin-bottom: 15px; }
            .badge-size {
                background: #f0f0f0; padding: 3px 8px; border-radius: 6px; font-weight: 600; font-size: 0.8rem; color: #555;
            }

            /* Quantity Input */
            .qty-control {
                display: inline-flex; align-items: center; background: #f8f9fa;
                border: 1px solid #eee; border-radius: 50px; padding: 4px;
            }
            .qty-btn {
                width: 32px; height: 32px; border-radius: 50%; border: none; background: #fff;
                box-shadow: 0 2px 5px rgba(0,0,0,0.05); cursor: pointer; color: var(--text-main);
                transition: all 0.2s; display: flex; align-items: center; justify-content: center;
            }
            .qty-btn:hover { background: var(--primary-color); color: #fff; }
            .qty-input {
                width: 40px; border: none; background: transparent; text-align: center;
                font-weight: 700; color: var(--text-main); pointer-events: none;
            }

            /* Price & Delete */
            .cart-actions {
                text-align: right; min-width: 140px;
                display: flex; flex-direction: column; align-items: flex-end; justify-content: space-between;
                height: 100px;
            }
            .price-display { margin-bottom: auto; }
            .current-price { font-size: 1.25rem; font-weight: 800; color: var(--primary-color); display: block;}
            .old-price { font-size: 0.9rem; color: #999; text-decoration: line-through; }
            
            .btn-remove {
                color: #aaa; background: none; border: none; font-size: 1.2rem;
                cursor: pointer; transition: color 0.3s;
                display: flex; align-items: center; gap: 5px; font-size: 0.9rem;
            }
            .btn-remove:hover { color: #dc3545; }

            /* --- ORDER SUMMARY (Right Side) --- */
            .summary-card {
                background: var(--white); border-radius: var(--border-radius);
                padding: 30px; box-shadow: var(--shadow-sm);
                position: sticky; top: 100px;
            }
            .summary-header {
                font-size: 1.3rem; font-weight: 700; margin-bottom: 25px; padding-bottom: 15px;
                border-bottom: 2px dashed #f0f0f0;
            }
            .summary-row { display: flex; justify-content: space-between; margin-bottom: 15px; font-size: 1rem; color: var(--text-light); }
            
            .summary-row.total {
                border-top: 2px dashed #f0f0f0; padding-top: 20px; margin-top: 20px;
                color: var(--text-main); font-weight: 800; font-size: 1.3rem; align-items: center;
            }
            
            /* --- UPDATE: RED COLOR FOR TOTAL --- */
            .text-highlight { 
                color: #dc3545 !important; /* Màu đỏ Bootstrap danger */
                font-size: 1.5rem; /* Tăng kích thước số một chút */
            }
            
            .checkout-btn {
                width: 100%; padding: 16px; margin-top: 25px;
                background-color: var(--primary-color); color: white; border: none;
                border-radius: 50px; font-weight: 700; font-size: 1.1rem; text-transform: uppercase; letter-spacing: 1px;
                transition: all 0.3s; box-shadow: 0 4px 15px rgba(160, 129, 108, 0.3);
            }
            .checkout-btn:hover {
                background-color: var(--primary-dark); transform: translateY(-3px);
                box-shadow: 0 8px 20px rgba(160, 129, 108, 0.4);
            }
            
            .free-ship-alert {
                background: #e8f5e9; color: #2e7d32; padding: 10px 15px;
                border-radius: 10px; font-size: 0.9rem; margin-top: 20px; display: flex; align-items: center; gap: 8px;
            }

            /* --- EMPTY STATE --- */
            .empty-cart-box {
                background: white; border-radius: var(--border-radius);
                padding: 80px 20px; text-align: center; box-shadow: var(--shadow-sm);
            }
            .empty-icon { font-size: 5rem; color: #eee; margin-bottom: 20px; }
            .btn-continue {
                display: inline-block; padding: 12px 35px; background: var(--text-main); color: white;
                border-radius: 50px; font-weight: 600; margin-top: 20px; transition: 0.3s;
            }
            .btn-continue:hover { background: #000; color: white; transform: translateY(-2px); }

            /* --- RESPONSIVE --- */
            @media (max-width: 768px) {
                .cart-item-card { flex-wrap: wrap; }
                .cart-img-wrapper { width: 80px; height: 100px; }
                .cart-info { padding: 0 15px; width: calc(100% - 90px); }
                .cart-actions {
                    width: 100%; flex-direction: row; align-items: center;
                    margin-top: 15px; padding-top: 15px; border-top: 1px solid #f0f0f0;
                    height: auto;
                }
                .price-display { margin-bottom: 0; text-align: left; }
                .checkout-steps { display: none; }
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
                    <div class="empty-cart-box mt-5" data-aos="fade-up">
                        <i class="bi bi-cart-x empty-icon"></i>

                        <h3>Your cart is empty</h3>
                        <p class="text-muted">Looks like you haven't added anything to your cart yet.</p>
                        <a href="${pageContext.request.contextPath}/" class="btn-continue">Start Shopping</a>
                    </div>
                </c:when>

                <%-- HAS ITEMS --%>
                <c:otherwise>
                    <div class="checkout-steps">
                        <div class="step-item active">
                            <span class="step-count">1</span> Shopping Cart
                        </div>
                        <div class="step-line"></div>
                        <div class="step-item">
                            <span class="step-count">2</span> Checkout
                        </div>
                        <div class="step-line"></div>
                        <div class="step-item">
                            <span class="step-count">3</span> Order Complete
                        </div>
                    </div>

                    <div class="row g-4">
                        <div class="col-lg-8">
<h2 class="section-title">
    <i class="bi bi-cart3" style="margin-right: 8px;"></i>
    Shopping Cart 
    <span style="font-size: 1.2rem; color: #999; font-weight: 400">
        (${fn:length(requestScope.cartList)} items)
    </span>
</h2>

                
                            <c:forEach items="${requestScope.cartList}" var="cart">
                                <c:set var="safeSize" value="${fn:replace(fn:replace(cart.size_name, ' ', '_'), '-', '_')}" />
                                <c:set var="lineDisc" value="${cart.price * cart.quantity}" />
                                <fmt:formatNumber var="lineDiscFmt" type="number" value="${lineDisc}" pattern="###,###" />
                                <c:set var="originalUnitPrice" value="${priceP[cart.productID]}" />
                                <c:set var="lineOrig" value="${originalUnitPrice * cart.quantity}" />
                                <fmt:formatNumber var="originalLineTotalFmt" type="number" value="${lineOrig}" pattern="###,###" />

                                <div class="cart-item-card" id='user${cart.productID}${safeSize}'>
                                    <div class="cart-img-wrapper">
                                        <a href="${pageContext.request.contextPath}/productDetail?id=${cart.productID}">
                                            <img src="${picUrlMap[cart.productID]}" alt="${nameProduct[cart.productID]}">
                                        </a>
                                    </div>

                                    <div class="cart-info">
                                        <a href="${pageContext.request.contextPath}/productDetail?id=${cart.productID}" class="product-name">
                                            ${nameProduct[cart.productID]}
                                        </a>
                                        <div class="product-meta">
                                            Size: <span class="badge-size">${cart.size_name}</span>
                                        </div>
                                        
                                        <div class="qty-control">
                                            <button type="button" class="qty-btn" onclick="decrementQuantity(${cart.productID},${cart.price},${cart.quantity}, '${cart.size_name}')">
                                                <i class="bi bi-dash"></i>
                                            </button>
                                            <input type="text" class="qty-input" id="quantity${cart.productID}${safeSize}" value="${cart.quantity}" readonly>
                                            <button type="button" class="qty-btn" onclick="incrementQuantity2(${cart.productID},${cart.price},${cart.quantity}, '${cart.size_name}')">
                                                <i class="bi bi-plus"></i>
                                            </button>
                                        </div>
                                    </div>

                                    <div class="cart-actions">
                                        <div class="price-display text-end" id="price2${cart.productID}${safeSize}">
                                            <span class="current-price line-total">${lineDiscFmt} VND</span>
                                            <c:if test="${originalLineTotal > lineDisc}">
                                                <div class="old-price" id="price1${cart.productID}${safeSize}">${originalLineTotalFmt} VND</div>
                                            </c:if>
                                        </div>
                                        <button class="btn-remove" onclick="showDeleteConfirm(${cart.productID}, '${cart.size_name}')" id="btnDel${cart.productID}">
                                            <i class="bi bi-trash3"></i> Remove
                                        </button>
                                    </div>

                                    <%-- Hidden Data --%>
                                    <input type="hidden" class="price" value="${cart.price}">
                                    <input type="hidden" class="quantity" value="${cart.quantity}">
                                    <input type="hidden" class="size" value="${cart.size_name}">
                                </div>
                            </c:forEach>
                        </div>

                        <div class="col-lg-4">
                            <div class="summary-card">
                                <div class="summary-header">Order Summary</div>
                                
                                <div class="summary-row">
                                    <span>Subtotal</span>
                                    <span id="sum" class="fw-bold text-dark">0 VND</span>
                                </div>
                                <div class="summary-row">
                                    <span>Shipping</span>
                                    <span id="shippingValue">0 VND</span>
                                </div>
                                
                                <div class="summary-row total">
                                    <span>Total</span>
                                    <span id="grandTotal" class="text-highlight">0 VND</span>
                                </div>

                                <div class="free-ship-alert">
                                    <small class="text-muted">
                                <i class="bi bi-truck"></i> Free shipping for orders over 200.000 VND
                            </small>
                                </div>

                                <form action="${pageContext.request.contextPath}/loadPayment" method="get">
                                    <button class="checkout-btn">Proceed to Checkout</button>
                                    
                                    <input type="hidden" name="size" value="${size}">
                                    <input type="hidden" id="subtotalInput" name="total" value="0">
                                    <input type="hidden" id="shippingInput" name="shipping" value="0">
                                    <input type="hidden" id="discountInput" name="discount" value="0">
                                    <input type="hidden" id="grandTotalInput" name="grandTotal" value="0">
                                </form>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered modal-sm">
                <div class="modal-content border-0 shadow" style="border-radius: 20px; overflow: hidden;">
                    <div class="modal-body text-center p-4">
                        <div class="mb-3">
                            <i class="bi bi-exclamation-circle text-warning display-4"></i>
                        </div>
                        <h5 class="fw-bold mb-2">Remove Item?</h5>
                        <p class="text-muted small mb-4">Are you sure you want to remove this item from your cart?</p>
                        <div class="d-flex gap-2 justify-content-center">
                            <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                            <button type="button" class="btn btn-danger rounded-pill px-4" id="confirmDeleteBtn">Remove</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/js/jquery-3.7.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            const SHIPPING_FEE = 20000;
            const FREE_SHIP_THRESHOLD = 200000;

            // --- UTILS ---
            function formatVND(amount) {
                // UPDATE: Changed suffix from "₫" to "VND"
                return (amount || 0).toLocaleString('vi-VN') + "\u00A0VND";
            }
            function onlyDigits(s) { return (s || '').toString().replace(/[^\d]/g, ''); }
            function toInt(text) { return parseInt(onlyDigits(text), 10) || 0; }

            // --- CALCULATION LOGIC ---
            function calcSubtotalFromDom() {
                let subtotal = 0;
                document.querySelectorAll('.cart-item-card').forEach(itemCard => {
                    const lineTotalEl = itemCard.querySelector('.line-total');
                    if (lineTotalEl) subtotal += toInt(lineTotalEl.textContent);
                });
                return subtotal;
            }

            function recalcTotals() {
                const subtotal = calcSubtotalFromDom();
                const hasItems = subtotal > 0;
                const shipping = !hasItems ? 0 : (subtotal >= FREE_SHIP_THRESHOLD ? 0 : SHIPPING_FEE);
                const grand = subtotal + shipping;

                // Update UI
                const sumEl = document.getElementById('sum');
                const shipEl = document.getElementById('shippingValue');
                const grandEl = document.getElementById('grandTotal');
                
                if(sumEl) sumEl.innerHTML = formatVND(subtotal);
                if(shipEl) {
                    shipEl.innerHTML = shipping === 0 ? '<span class="text-success fw-bold">Free</span>' : formatVND(shipping);
                }
                if(grandEl) grandEl.innerHTML = formatVND(grand);

                // Update Form
                if(document.getElementById('subtotalInput')) document.getElementById('subtotalInput').value = subtotal;
                if(document.getElementById('shippingInput')) document.getElementById('shippingInput').value = shipping;
                if(document.getElementById('grandTotalInput')) document.getElementById('grandTotalInput').value = grand;
            }

            // --- AJAX OPERATIONS ---
            function incrementQuantity2(productID, price, quantity, size_name) {
                const safe = safeIdPart(size_name);
                const qtyInput = document.getElementById('quantity' + productID + safe);
                const newQty = (parseInt(qtyInput.value, 10) || 1) + 1;
                
                $.ajax({
                    url: BASE + '/cartIncrease',
                    method: 'GET',
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
                    error: function() { alert('Error updating cart'); }
                });
            }

            function decrementQuantity(productID, price, quantity, size_name) {
                const safe = safeIdPart(size_name);
                const qtyInput = document.getElementById('quantity' + productID + safe);
                const newQty = (parseInt(qtyInput.value, 10) || 1) - 1;
                if (newQty <= 0) return;
                
                $.ajax({
                    url: BASE + '/cartDecrease',
                    method: 'GET',
                    data: {id: productID, price: price, quantity: newQty, size: size_name},
                    success: function (response) {
                        const values = (response || '').split(',');
                        const line = parseInt(values[0] || '0', 10);
                        qtyInput.value = newQty;
                        const holder = document.querySelector('#price2' + productID + safe + ' .line-total');
                        holder.textContent = (isNaN(line) || line <= 0) ? formatVND(price * newQty) : formatVND(line);
                        recalcTotals();
                    },
                    error: function() { alert('Error updating cart'); }
                });
            }

            // --- DELETE LOGIC ---
            let deleteTarget = null;
            function showDeleteConfirm(productID, size_name) {
                deleteTarget = { id: productID, size: size_name };
                const modal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
                modal.show();
            }

            document.getElementById('confirmDeleteBtn').addEventListener('click', function() {
                if(!deleteTarget) return;
                
                $.ajax({
                    url: BASE + '/cartDelete',
                    method: 'GET',
                    data: {id: deleteTarget.id, size: deleteTarget.size},
                    success: function () {
                        const safe = safeIdPart(deleteTarget.size);
                        const row = document.getElementById('user' + deleteTarget.id + safe);
                        
                        // Close Modal
                        const modalEl = document.getElementById('deleteConfirmModal');
                        const modal = bootstrap.Modal.getInstance(modalEl);
                        modal.hide();

                        // Animation Remove
                        if(row) {
                            row.style.transition = 'all 0.3s ease';
                            row.style.opacity = '0';
                            row.style.transform = 'translateX(20px)';
                            setTimeout(() => { 
                                row.remove(); 
                                recalcTotals();
                                // Reload if empty
                                if(document.querySelectorAll('.cart-item-card').length === 0) location.reload();
                            }, 300);
                        }
                    },
                    error: function() { alert('Delete failed'); }
                });
            });

            // --- INIT ---
            document.addEventListener('DOMContentLoaded', function () {
                setTimeout(() => {
                    const loader = document.getElementById('page-loader');
                    if(loader) { loader.style.opacity = 0; setTimeout(() => loader.remove(), 400); }
                }, 400);
                recalcTotals();
            });
        </script>
    </body>
</html>