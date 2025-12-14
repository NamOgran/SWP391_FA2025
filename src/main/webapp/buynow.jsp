<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
    response.setHeader("Pragma", "no-cache");
%>

<%-- 1. Login Requirement --%>
<c:if test="${empty sessionScope.acc}">
    <c:redirect url="${pageContext.request.contextPath}/login.jsp"/>
</c:if>
<c:set var="acc" value="${sessionScope.acc}" />

<%-- Clear old session --%>
<c:remove var="voucherPercent" scope="session"/>
<c:remove var="voucherId" scope="session"/>
<c:remove var="voucherCode" scope="session"/>

<%-- Calculate values --%>
<c:set var="qty"       value="${quantity}" />
<c:set var="unitPrice" value="${price}" />
<c:set var="subtotal"  value="${unitPrice * qty}" />



<c:set var="voucherPercent" value="0" />
<c:set var="voucherId"      value="0" />
<c:set var="discount"     value="0" />
<c:set var="grandTotal"   value="${subtotal}" />

<%-- Lấy Product ID để dùng cho nút Back --%>
<c:set var="currentPId" value="${not empty param.productId ? param.productId : id}" />

<fmt:formatNumber var="subtotalFmt" value="${subtotal}" pattern="###,###" />
<fmt:formatNumber var="discountFmt" value="${discount}" pattern="###,###" />
<fmt:formatNumber var="grandTotalFmt" value="${grandTotal}" pattern="###,###" />

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Checkout (Buy Now) | GIO</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link href='https://fonts.googleapis.com/css?family=Quicksand:400,500,600,700&display=swap' rel='stylesheet'>
        <link rel="icon" href="${pageContext.request.contextPath}/images/LG2.png" type="image/x-icon">

        <script>const BASE = '${pageContext.request.contextPath}';</script>

        <style>
            :root {
                --primary-color: #a0816c;
                --primary-dark: #8a6d5a;
                --bg-body: #f5f7f9;
                --white: #ffffff;
                --text-main: #333;
                --text-light: #666;
                --border-radius: 12px;
                --shadow-sm: 0 2px 8px rgba(0,0,0,0.04);
                --shadow-md: 0 8px 24px rgba(0,0,0,0.08);
            }

            body {
                font-family: "Quicksand", sans-serif;
                background-color: var(--bg-body);
                color: var(--text-main);
                padding-bottom: 60px;
            }
            a {
                text-decoration: none;
                color: inherit;
            }

            /* LOADING */
            #page-loader {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-color: var(--white);
                z-index: 9999;
                display: flex;
                justify-content: center;
                align-items: center;
            }
            .spinner-custom {
                color: var(--primary-color);
                width: 3rem;
                height: 3rem;
            }

            /* HEADER & NAV */
            .checkout-nav {
                background: var(--white);
                padding: 15px 0;
                box-shadow: var(--shadow-sm);
                margin-bottom: 30px;
            }
            .nav-content {
                display: flex;
                align-items: center;
                justify-content: space-between;
            }
            .brand-logo {
                font-size: 24px;
                font-weight: 800;
                color: var(--primary-color);
                letter-spacing: 1px;
            }
            .back-link {
                font-weight: 600;
                color: var(--text-light);
                display: flex;
                align-items: center;
                gap: 5px;
                transition: 0.3s;
            }
            .back-link:hover {
                color: var(--primary-color);
            }

            /* PROGRESS STEPS */
            .checkout-steps {
                display: flex;
                justify-content: center;
                margin-bottom: 40px;
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
                width: 32px;
                height: 32px;
                border-radius: 50%;
                border: 2px solid #ccc;
                display: flex;
                align-items: center;
                justify-content: center;
                margin-right: 10px;
                font-size: 0.9rem;
            }
            .step-line {
                width: 60px;
                height: 2px;
                background-color: #e0e0e0;
                margin: 0 15px;
            }

            /* LEFT COLUMN - FORMS */
            .section-card {
                background: var(--white);
                border-radius: var(--border-radius);
                padding: 25px 30px;
                margin-bottom: 25px;
                box-shadow: var(--shadow-sm);
            }
            .section-title {
                font-size: 1.1rem;
                font-weight: 700;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
                color: var(--text-main);
            }
            .section-title i {
                color: var(--primary-color);
                font-size: 1.2rem;
            }

            /* INPUT GROUPS */
            .input-group-text {
                background: #f8f9fa;
                border-right: none;
                color: var(--text-light);
                border-radius: var(--border-radius) 0 0 var(--border-radius);
            }
            .form-control {
                border-left: none;
                height: 50px;
                font-size: 0.95rem;
                border-radius: 0 var(--border-radius) var(--border-radius) 0;
            }
            .form-control:focus {
                box-shadow: none;
                border-color: #ced4da;
            }
            .input-group:focus-within .input-group-text, .input-group:focus-within .form-control {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 0.2rem rgba(160, 129, 108, 0.15);
            }
            .error {
                color: #dc3545;
                font-size: 0.85rem;
                margin-top: 5px;
                margin-left: 5px;
                width: 100%;
            }

            /* PAYMENT METHOD */
            .payment-option {
                border: 2px solid var(--primary-color);
                background: #fdf8f5;
                border-radius: var(--border-radius);
                padding: 15px 20px;
                display: flex;
                align-items: center;
                justify-content: space-between;
                cursor: pointer;
                position: relative;
            }
            .payment-option::after {
                content: '\F26B';
                font-family: "bootstrap-icons";
                font-size: 1.3rem;
                color: var(--primary-color);
            }
            .payment-info {
                display: flex;
                align-items: center;
                gap: 15px;
                font-weight: 600;
            }
            .payment-icon {
                height: 30px;
                width: auto;
            }

            /* RIGHT COLUMN - SUMMARY */
            .summary-box {
                background: var(--white);
                border-radius: var(--border-radius);
                padding: 30px;
                box-shadow: var(--shadow-md);
                position: sticky;
                top: 100px;
            }
            .summary-header {
                font-size: 1.25rem;
                font-weight: 700;
                border-bottom: 2px dashed #eee;
                padding-bottom: 15px;
                margin-bottom: 20px;
            }

            .product-item {
                display: flex;
                gap: 15px;
                margin-bottom: 15px;
                padding-bottom: 15px;
                border-bottom: 1px solid #f8f9fa;
            }
            .product-item:last-child {
                border-bottom: none;
            }
            .product-img {
                width: 60px;
                height: 75px;
                border-radius: 8px;
                object-fit: cover;
                background: #eee;
            }
            .product-info h6 {
                font-size: 0.95rem;
                font-weight: 600;
                margin-bottom: 4px;
                line-height: 1.3;
            }
            .product-info p {
                font-size: 0.85rem;
                color: var(--text-light);
                margin: 0;
            }
            .product-price {
                font-size: 0.95rem;
                font-weight: 700;
                white-space: nowrap;
                margin-left: auto;
            }

            /* PROMO CODE */
            .voucher-container {
                margin-bottom: 20px;
            }
            .btn-apply {
                background: var(--text-main);
                color: #fff;
                font-weight: 600;
                border-radius: 0 var(--border-radius) var(--border-radius) 0;
            }
            .btn-apply:hover {
                background: #000;
                color: #fff;
            }

            /* TOTALS */
            .total-row {
                display: flex;
                justify-content: space-between;
                margin-bottom: 10px;
                color: var(--text-light);
                font-size: 0.95rem;
            }
            .grand-total {
                margin-top: 15px;
                padding-top: 15px;
                border-top: 2px dashed #eee;
                font-weight: 800;
                font-size: 1.2rem;
                color: var(--text-main);
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .grand-total .amount {
                color: #dc3545;
                font-size: 1.4rem;
            }

            .btn-confirm {
                width: 100%;
                padding: 15px;
                background: var(--primary-color);
                color: #fff;
                border: none;
                border-radius: 50px;
                font-weight: 700;
                font-size: 1.1rem;
                text-transform: uppercase;
                letter-spacing: 1px;
                margin-top: 25px;
                transition: all 0.3s;
                box-shadow: 0 4px 15px rgba(160, 129, 108, 0.3);
            }
            .btn-confirm:hover:not(:disabled) {
                background: var(--primary-dark);
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(160, 129, 108, 0.4);
            }
            .btn-confirm:disabled {
                background: #ccc;
                cursor: not-allowed;
                box-shadow: none;
            }

            /* RESPONSIVE */
            @media (max-width: 992px) {
                .checkout-steps {
                    display: none;
                }
                .row.g-5 {
                    flex-direction: column-reverse;
                }
                .summary-box {
                    position: static;
                    margin-bottom: 30px;
                }
            }
        </style>
    </head>

    <body>
        <div id="page-loader">
            <div class="spinner-border spinner-custom" role="status"></div>
        </div>

        <nav class="checkout-nav">
            <div class="container nav-content">
                <a href="${pageContext.request.contextPath}/productDetail?productId=${currentPId}" class="back-link">
                    <i class="bi bi-arrow-left"></i> Back to Product
                </a>
                <span class="brand-logo">GIO</span>
                <div style="width: 80px;"></div>
            </div>
        </nav>

        <div class="container">
            <div class="checkout-steps">
                <div class="step-item">
                    <span class="step-count">1</span> Product View
                </div>
                <div class="step-line"></div>
                <div class="step-item active">
                    <span class="step-count">2</span> Checkout (Buy Now)
                </div>
                <div class="step-line"></div>
                <div class="step-item">
                    <span class="step-count">3</span> Order Complete
                </div>
            </div>

            <div class="row g-5">
                <div class="col-lg-7">
                    <form action="${pageContext.request.contextPath}/insertOrders" method="post" id="payment-form">

                        <div class="section-card">
                            <div class="section-title">
                                <i class="bi bi-person-vcard"></i> Contact Information
                            </div>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="bi bi-person"></i></span>
                                        <input type="text" class="form-control" placeholder="Full Name" name="fullName" value="${sessionScope.acc.fullName}" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                                        <input type="tel" class="form-control" placeholder="Phone Number" name="phoneNumber" id="phoneNumber" value="${sessionScope.acc.phoneNumber}" required>
                                    </div>
                                </div>
                                <div class="col-12">
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                                        <input type="email" class="form-control" placeholder="Email Address (Optional)" name="email" value="${sessionScope.acc.email}" required>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="section-card">
                            <div class="section-title">
                                <i class="bi bi-geo-alt"></i> Shipping Address
                            </div>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-map"></i></span>
                                <input type="text" class="form-control" placeholder="House number, Street, Ward, District, City..." name="address" value="${sessionScope.acc.address}" required>
                            </div>
                        </div>

                        <div class="section-card">
                            <div class="section-title">
                                <i class="bi bi-credit-card"></i> Payment Method
                            </div>
                            <div class="payment-option">
                                <div class="payment-info">
                                    <img src="https://hstatic.net/0/0/global/design/seller/image/payment/other.svg?v=6" alt="COD" class="payment-icon">
                                    <span>Cash on Delivery (COD)</span>
                                </div>
                            </div>
                        </div>

                        <%-- Hidden Fields for Buy Now --%>
                        <input type="hidden" name="productId"      value="${currentPId}">
                        <input type="hidden" name="id"             value="${id}">
                        <input type="hidden" name="quantity"       value="${qty}">
                        <input type="hidden" name="size"           value="${param.size}">
                        <input type="hidden" id="subtotalInput"    name="total"       value="${subtotal}">
                        <input type="hidden" id="grandTotalInput"  name="grandTotal"  value="${grandTotal}">

                        <input type="hidden" id="voucherCodeInput"   name="voucherCode"   value="${sessionScope.voucherCode}">
                        <input type="hidden" id="voucherIdInput"     name="voucherId"     value="${voucherId}">
                        <input type="hidden" id="voucherTypeInput"   name="voucherType"   value="${sessionScope.voucherType}">
                        <input type="hidden" id="voucherValueInput"  name="voucherValue"  value="${voucherPercent}">
                        <input type="hidden" id="discountInput"    name="discount"    value="${discount}">
                    </form>
                </div>

                <div class="col-lg-5">
                    <div class="summary-box">
                        <div class="summary-header">Order Summary</div>

                        <div class="product-item">
                            <%-- SỬA LẠI BIẾN: Dùng ${pic} và ${name} như file gốc --%>
                            <img src="${pic}" alt="Product" class="product-img">
                            <div class="product-info">
                                <h6>${name}</h6>
                                <p>Size: ${param.size} | Qty: ${qty}</p>
                            </div>
                            <div class="product-price">
                                <fmt:formatNumber value="${subtotal}" pattern="###,###" /> VND
                            </div>
                        </div>

                        <div class="voucher-container">
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-ticket-perforated"></i></span>
                                <input type="text" class="form-control" id="voucherInput" placeholder="Voucher Code" value="${param.voucherCode}">
                                <button class="btn btn-apply" type="button" onclick="applyVoucher()">Apply</button>
                            </div>
                            <div id="voucherHint" class="mt-2 align-items-center" style="display:none;">
                                <span id="badgeVoucher" class="badge bg-success bg-opacity-75 text-white"></span>
                                <a href="javascript:void(0)" onclick="removeVoucher()" class="text-danger ms-2 small text-decoration-underline">Remove</a>
                            </div>
                            <small id="voucherError" class="text-danger d-block mt-1" style="display:none;"></small>
                        </div>

                        <div class="total-row">
                            <span>Subtotal</span>
                            <span id="subtotalText" class="fw-bold text-dark">${subtotalFmt} VND</span>
                        </div>

                        <div class="total-row" id="discountRow" style="display:none;">
                            <span class="text-success">Voucher</span>
                            <span id="discountValue" class="text-success fw-bold">-0 VND</span>
                        </div>

                        <div class="grand-total">
                            <span>Total</span>
                            <span class="amount" id="grandTotalText">${grandTotalFmt} VND</span>
                        </div>

                        <button type="submit" form="payment-form" class="btn-confirm" id="btnComplete">
                            CONFIRM ORDER
                        </button>

                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="processingModal" data-bs-backdrop="static" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered modal-sm">
                <div class="modal-content bg-transparent border-0 shadow-none">
                    <div class="modal-body text-center">
                        <div class="spinner-border text-white" style="width: 3rem; height: 3rem;" role="status"></div>
                        <p class="text-white mt-3 fw-bold">Processing Order...</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="successModal" data-bs-backdrop="static" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0 rounded-4 overflow-hidden">
                    <div class="modal-body text-center p-5">
                        <div class="mb-3">
                            <i class="bi bi-check-circle-fill text-success" style="font-size: 4rem;"></i>
                        </div>
                        <h3 class="fw-bold mb-2">Thank You!</h3>
                        <p class="text-muted mb-4">Your order has been placed successfully.</p>
                        <button type="button" class="btn btn-dark rounded-pill px-5 py-2" id="modalOkButton">Track Order</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/js/jquery-3.7.0.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery.validate.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <script>

                                    // BuyNow uses single item calc
                                    let subtotal = ${subtotal};
                                    let appliedVoucher = {value: 0, id: 0};
                                    let successModal, processingModal;

                                    $(window).on('load', function () {
                                        setTimeout(() => $('#page-loader').fadeOut('slow'), 500);
                                    });

                                    function fmt(n) {
                                        return (n || 0).toLocaleString('vi-VN') + ' VND';
                                    }

                                    function recalcTotals() {
                                        const discount = Math.round(subtotal * (appliedVoucher.value || 0) / 100.0);
                                        const grand = Math.max(0, subtotal - discount);

                                        $('#subtotalText').text(fmt(subtotal));
                                        $('#grandTotalText').text(fmt(grand));

                                        // Update hidden inputs
                                        $('#discountInput').val(discount);
                                        $('#grandTotalInput').val(grand);
                                        $('#subtotalInput').val(subtotal);
                                        $('#voucherIdInput').val(appliedVoucher.id || '');
                                        $('#voucherValueInput').val(appliedVoucher.value || 0);
                                        $('#voucherCodeInput').val(appliedVoucher.id || '');
                                        $('#voucherTypeInput').val((appliedVoucher.value > 0) ? 'percent' : '');

                                        updateVoucherUI(discount);
                                    }


                                    function updateVoucherUI(discount) {
                                        if (appliedVoucher.value > 0) {
                                            $('#voucherError').hide().text('');
                                            $('#discountRow').css('display', 'flex');
                                            $('#discountValue').text('-' + fmt(discount));
                                            $('#voucherHint').css('display', 'flex');
                                            $('#badgeVoucher').text('Saved ' + appliedVoucher.value + '%');

                                            // Giữ lại text voucher trong input
                                            // $('#voucherInput').val(''); 
                                        } else {
                                            $('#discountRow').hide();
                                            $('#discountValue').text('-0 VND');
                                            $('#voucherHint').hide();
                                        }
                                    }

                                    function applyVoucher() {
                                        const code = ($('#voucherInput').val() || '').trim();
                                        const err = $('#voucherError');
                                        err.hide().text('');

                                        if (!code) {
                                            err.text('Please enter a voucher code.').show();
                                            return;
                                        }

                                        $.ajax({
                                            url: BASE + '/applyVoucher',
                                            method: 'POST',
                                            dataType: 'json',
                                            data: {code: code},
                                            success: function (res) {
                                                if (res && res.ok && res.type === 'percent') {
                                                    appliedVoucher = {value: parseInt(res.value || 0, 10), id: parseInt(res.voucherId || 0, 10)};
                                                    recalcTotals();
                                                } else {
                                                    removeVoucher();
                                                    err.text((res && res.message) ? res.message : 'Invalid voucher code.').show();
                                                }
                                            },
                                            error: function () {
                                                removeVoucher();
                                                err.text('Cannot apply voucher right now.').show();
                                            }
                                        });
                                    }

                                    function removeVoucher() {
                                        appliedVoucher = {value: 0, id: 0};
                                        $('#voucherError').hide().text('');
                                        recalcTotals();
                                    }

                                    $(document).ready(function () {
                                        successModal = new bootstrap.Modal(document.getElementById('successModal'), {keyboard: false, backdrop: 'static'});
                                        processingModal = new bootstrap.Modal(document.getElementById('processingModal'), {keyboard: false, backdrop: 'static'});

                                        $('#modalOkButton').on('click', function () {
                                            window.location.href = '${pageContext.request.contextPath}/orderView';
                                        });

                                        $.validator.addMethod("customPhone", function (value, element) {
                                            return this.optional(element) || /^(0\d{9,10})$|^(\+84\d{9,10})$/.test(value);
                                        }, "Invalid phone number");

                                        $("#payment-form").validate({
                                            rules: {
                                                fullName: {required: true},
                                                email: {required: true, email: true},
                                                phoneNumber: {required: true, customPhone: true},
                                                address: {required: true}
                                            },
                                            messages: {
                                                fullName: "Please enter your name",
                                                email: "Valid email required",
                                                phoneNumber: "Valid phone required",
                                                address: "Address is required"
                                            },
                                            errorElement: "div",
                                            errorPlacement: function (error, element) {
                                                error.addClass("error");
                                                element.closest('.input-group').after(error);
                                            },
                                            submitHandler: function (form) {
                                                $('#btnComplete').prop('disabled', true);
                                                processingModal.show();

                                                setTimeout(function () {
                                                    const fd = new URLSearchParams(new FormData(form));
                                                    let phone = fd.get('phoneNumber');
                                                    if (phone.startsWith('+84'))
                                                        fd.set('phoneNumber', '0' + phone.substring(3));

                                                    $.ajax({
                                                        url: form.action,
                                                        type: 'POST', // Đảm bảo dùng POST
                                                        data: fd.toString(),
                                                        headers: {'X-Requested-With': 'XMLHttpRequest'},
                                                        success: function () {
                                                            processingModal.hide();
                                                            successModal.show();
                                                        },
                                                        error: function (jqXHR) {
                                                            processingModal.hide();
                                                            const msg = jqXHR?.responseJSON?.message || 'Order failed. Try again.';
                                                            alert(msg);
                                                            $('#btnComplete').prop('disabled', false);
                                                        }
                                                    });
                                                }, 800);
                                                return false;
                                            }
                                        });
                                        recalcTotals();
                                    });
        </script>
    </body>
</html>