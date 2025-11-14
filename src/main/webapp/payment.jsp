<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-iYQeCzEYFbKjA/T2uDLTpkwGzCiq6soy8tYaI1GyVh/UjpbCx/TYkiZhlZB6+fzT" crossorigin="anonymous">
        <title>Payment</title>
        <link rel="icon" href="${pageContext.request.contextPath}/images/LG1.png" type="image/x-icon">
        <style>
            body{
                margin:5% 0;
                font-family:"Quicksand",sans-serif;
                color:#444;
            }
            a{
                text-decoration:none;
                color:rgb(58,132,180);
            }
            #accountinfo p{
                margin:0;
            }
            .account{
                width:80%;
                height:80%;
                background-color:rgb(214,214,214);
            }
            input{
                width:100%;
                padding:10px;
                margin:10px 0;
            }
            #product{
                width:100%;
            }
            .address{
                padding:5px 20px;
                background-color:rgb(239,240,240);
            }
            .address input{
                border:none;
                background:transparent;
            }
            .methods{
                margin:20px 0;
            }
            .methods img{
                margin:10px;
            }
            .deli{
                border:gray solid 1px;
                padding:.75rem;
                border-radius:.25rem;
            }
            #complete input{
                border:none;
                background-color:rgb(82,177,255);
                color:white;
                font-weight:1000;
                padding:10px 0;
                width:100%;
            }
            #complete input:hover{
                background-color:rgb(31,99,187);
                transition:.2s;
            }
            .col-md-5{
                padding:5% 5% 5% 2%;
                background-color:rgb(239,240,240);
            }
            .col-md-7{
                margin:0;
            }
            .error{
                color:red;
            }
            .disabled-link {
                pointer-events:none;
                opacity:.6;
            }

            /* ==== POPUP ORDER SUCCESS (same style as BuyNow.jsp) ==== */
            .popup-backdrop {
                position: fixed;
                inset: 0;
                background: rgba(15,23,42,0.35);
                backdrop-filter: blur(4px);
                display: none;              /* Ẩn mặc định */
                align-items: center;
                justify-content: center;
                z-index: 9999;
            }

            .popup-card {
                background: #ffffff;
                border-radius: 18px;
                padding: 22px 26px 20px;
                max-width: 380px;
                width: 92%;
                text-align: center;
                box-shadow: 0 18px 45px rgba(15,23,42,0.25);
                animation: popup-scale-in 0.25s ease-out;
                position: relative;
            }

            .popup-icon {
                width: 64px;
                height: 64px;
                border-radius: 50%;
                margin: 0 auto 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                background: radial-gradient(circle at 30% 20%, #6ee7b7, #22c55e);
                color: #ffffff;
                font-size: 34px;
                box-shadow: 0 10px 25px rgba(34,197,94,0.45);
            }

            .popup-title {
                font-size: 20px;
                font-weight: 700;
                margin-bottom: 4px;
                color: #111827;
            }

            .popup-text {
                font-size: 14px;
                color: #6b7280;
                margin-bottom: 16px;
            }

            .popup-actions {
                display: flex;
                gap: 10px;
                justify-content: center;
                margin-top: 4px;
            }

            .popup-actions .btn {
                min-width: 130px;
                font-size: 14px;
                border-radius: 999px;
                padding: 8px 14px;
            }

            .btn-view-order {
                background: linear-gradient(135deg,#4f46e5,#2563eb);
                border: none;
                color: #fff;
                font-weight: 600;
            }
            .btn-view-order:hover {
                filter: brightness(1.07);
            }

            .btn-continue {
                border-radius: 999px;
                font-weight: 500;
                border-color: #d1d5db;
                color: #4b5563;
                background-color: #ffffff;
            }
            .btn-continue:hover {
                background-color: #f3f4f6;
                border-color: #9ca3af;
                color: #111827;
            }

            @keyframes popup-scale-in {
                from {
                    transform: translateY(10px) scale(0.95);
                    opacity: 0;
                }
                to {
                    transform: translateY(0) scale(1);
                    opacity: 1;
                }
            }
        </style>
        <script>const BASE = '${pageContext.request.contextPath}';</script>
    </head>

    <body>
        <%-- Bắt buộc đăng nhập --%>
        <c:set var="customer" value="${sessionScope.acc}" />
        <c:if test="${empty customer}">
            <c:redirect url='${pageContext.request.contextPath}/login.jsp'/>
        </c:if>

        <%-- Nhận số liệu từ cart.jsp --%>
        <fmt:parseNumber var="subtotal" value="${empty param.total ? 0 : param.total}"/>
        <fmt:parseNumber var="shipping" value="${empty param.shipping ? 0 : param.shipping}"/>
        <c:choose>
            <c:when test="${not empty param.grandTotal}">
                <fmt:parseNumber var="grand" value="${param.grandTotal}"/>
            </c:when>
            <c:otherwise>
                <c:set var="grand" value="${subtotal + shipping}"/>
            </c:otherwise>
        </c:choose>

        <fmt:formatNumber var="subtotalF" value="${subtotal}" pattern="###,###"/>
        <fmt:formatNumber var="shippingF" value="${shipping}" pattern="###,###"/>
        <fmt:formatNumber var="grandF"    value="${grand}"    pattern="###,###"/>

        <div class="container">
            <div class="row">

                <!-- LEFT -->
                <div class="col-md-7">
                    <form action="${pageContext.request.contextPath}/insertOrders" method="get" id="payment">
                        <h1>GIO</h1>
                        <h6><b>SHIPMENT DETAILS</b></h6>

                        <div class="row">
                            <div class="col-2">
                                <img class="account"
                                     src="https://cdn.icon-icons.com/icons2/3054/PNG/512/account_profile_user_icon_190494.png"
                                     alt="">
                            </div>
                            <div id="accountinfo" class="col-10">
                                <p>
                                    <c:choose>
                                        <c:when test="${not empty customer.fullName}">${customer.fullName}</c:when>
                                        <c:otherwise>${customer.username}</c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </div>

                        <input type="text" placeholder="Your phone number" name="phoneNumber" id="phoneNumber"
                               value="${customer.phoneNumber}">

                        <div>
                            <b>Default address</b>
                            <div class="address">
                                <input type="text" id="defaultAddress" name="address" value="${customer.address}" readonly>
                            </div>
                        </div>

                        <div>
                            <input type="text" id="newaddress" name="newaddress" placeholder="Add new address (optional)">
                        </div>

                        <div class="methods">
                            <b>Payment methods</b><br>
                            <div class="deli">
                                <img src="https://hstatic.net/0/0/global/design/seller/image/payment/other.svg?v=6" alt="">
                                Payment on delivery (COD)
                            </div>
                        </div>

                        <div class="row">
                            <div id="back" class="col-8">
                                <a id="cartLink" href="${pageContext.request.contextPath}/loadCart">CART</a>
                            </div>
                            <div id="complete" class="col-4">
                                <input id="btnComplete" type="submit" value="COMPLETE">
                                <!-- Hidden gửi đủ dữ liệu -->
                                <input type="hidden" name="size"      value="${param.size}">
                                <input type="hidden" name="subtotal"  value="${subtotal}">
                                <input type="hidden" name="shipping"  value="${shipping}">
                                <input type="hidden" name="total"     value="${grand}">
                                <!-- promo nếu có -->
                                <input type="hidden" name="promoCode"  value="${param.promoCode}">
                                <input type="hidden" name="promoType"  value="${param.promoType}">
                                <input type="hidden" name="promoValue" value="${param.promoValue}">
                                <input type="hidden" name="discount"   value="${param.discount}">
                            </div>
                        </div>
                    </form>
                </div>

                <!-- RIGHT: tóm tắt giỏ -->
                <div class="col-md-5">
                    <div class="row">
                        <c:forEach items="${requestScope.cartList}" var="cart">
                            <div class="col-2">
                                <img id="product" src="${picUrlMap[cart.productID]}" alt="">
                            </div>
                            <div class="col-8">
                                <b>${nameProduct[cart.productID]}</b>
                                <p>Quantity: ${cart.quantity}</p>
                                <p>Size: ${cart.size_name}</p>
                            </div>
                            <c:set var="formattedPrice">
                                <fmt:formatNumber type="number" value="${cart.price}" pattern="###,###"/>
                            </c:set>
                            <div class="col-2 text-end">
                                <p class="price">${formattedPrice}</p>
                            </div>
                        </c:forEach>

                        <hr>

                        <div class="row align-items-center">
                            <div class="col-7"><h5 class="m-0">Subtotal</h5></div>
                            <div class="col-5 text-end"><h5 class="m-0">${subtotalF}&nbsp;VND</h5></div>
                        </div>
                        <div class="row align-items-center">
                            <div class="col-7"><h5 class="m-0">Shipping</h5></div>
                            <div class="col-5 text-end"><h5 class="m-0">${shippingF}&nbsp;VND</h5></div>
                        </div>

                        <div class="mt-2"></div>

                        <div id="line" class="row align-items-center">
                            <div class="col-7"><h5 class="m-0"><b>Total</b></h5></div>
                            <div class="col-5 text-end"><h5 class="m-0"><b>${grandF}&nbsp;VND</b></h5></div>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <!-- Popup đặt hàng thành công (giống buyNow.jsp) -->
        <div id="orderSuccessPopup" class="popup-backdrop">
            <div class="popup-card">
                <div class="popup-icon">
                    ✓
                </div>
                <div class="popup-title">Order placed successfully</div>
                <div class="popup-text">
                    Thank you for shopping with GIO.<br>
                    You can review your orders or continue shopping.
                </div>
                <div class="popup-actions">
                    <a href="${pageContext.request.contextPath}/orderView"
                       class="btn btn-view-order">
                        View Orders
                    </a>
                    <a href="${pageContext.request.contextPath}/productList"
                       class="btn btn-continue btn-outline-secondary">
                        Continue shopping
                    </a>
                </div>
            </div>
        </div>

        <!-- Scripts -->
        <script src="${pageContext.request.contextPath}/js/jquery-3.7.0.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery.validate.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"
                integrity="sha384-u1OknCvxWvY5kfmNBILK2hIq7F0vZ7Zlqp6jAU6Yk0G04Z3E0GmH2A3O5r5d0M8Q"
        crossorigin="anonymous"></script>

        <script>
            // Validate
            $("#payment").validate({
                rules: {
                    phoneNumber: {required: true, minlength: 10, digits: true},
                    newaddress: {minlength: 3}
                },
                messages: {
                    phoneNumber: {required: "Phone number is required", digits: "Please enter only digits"}
                }
            });

            // Submit AJAX (GET) - dùng popup giống buyNow.jsp
            document.getElementById('payment').addEventListener('submit', function (e) {
                e.preventDefault();
                if (!$("#payment").valid())
                    return;

                const btn = document.getElementById('btnComplete');
                const link = document.getElementById('cartLink');
                btn.disabled = true;
                link.classList.add('disabled-link');

                const defAddr = (document.getElementById('defaultAddress').value || '').trim();
                const newAddr = (document.getElementById('newaddress').value || '').trim();
                const finalAddr = newAddr !== '' ? newAddr : defAddr;

                const fd = new URLSearchParams(new FormData(this));
                fd.set('address', finalAddr);

                $.ajax({
                    url: this.action, // /insertOrders
                    type: 'GET',
                    data: fd.toString(),
                    headers: {
                        'X-Requested-With': 'XMLHttpRequest',
                        'Accept': 'application/json, text/html'
                    },
                    success: function () {
                        const popup = document.getElementById('orderSuccessPopup');
                        if (popup) {
                            popup.style.display = 'flex';
                        }
                    },
                    error: function () {
                        alert("Cannot place order now, please try again.");
                        btn.disabled = false;
                        link.classList.remove('disabled-link');
                    }
                });
            });

            // Optional: click ra ngoài card để tắt popup
            document.addEventListener('DOMContentLoaded', function () {
                const popupBg = document.getElementById('orderSuccessPopup');
                if (popupBg) {
                    popupBg.addEventListener('click', function (e) {
                        if (e.target === popupBg) {
                            popupBg.style.display = 'none';
                        }
                    });
                }
            });
        </script>
    </body>
</html>
