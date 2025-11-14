<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
    response.setHeader("Pragma", "no-cache");
%>
<c:remove var="promoPercent" scope="session"/>
<c:remove var="promoId" scope="session"/>
<c:remove var="promoCode" scope="session"/>

<c:set var="customer" value="${sessionScope.customer}" />
<c:set var="customerName"    value="${not empty customer && not empty customer.fullName ? customer.fullName : (not empty username ? username : '')}" />
<c:set var="customerAddress" value="${not empty customer && not empty customer.address ? customer.address : (not empty address ? address : '')}" />
<c:set var="customerPhone"   value="${not empty customer && not empty customer.phone   ? customer.phone   : ''}" />

<c:set var="qty"        value="${quantity}" />
<c:set var="unitPrice"  value="${price}" />
<c:set var="subtotal"   value="${unitPrice * qty}" />

<c:set var="FREE_SHIP_THRESHOLD" value="200000" />
<c:set var="SHIPPING_FEE"        value="20000" />

<c:choose>
    <c:when test="${subtotal ge FREE_SHIP_THRESHOLD}">
        <c:set var="shipping" value="0" />
    </c:when>
    <c:otherwise>
        <c:set var="shipping" value="${SHIPPING_FEE}" />
    </c:otherwise>
</c:choose>

<c:set var="promoPercent" value="0" />
<c:set var="promoId"      value="0" />
<c:set var="discount"     value="${(subtotal * promoPercent) / 100}" />
<c:set var="grandTotal"   value="${subtotal + shipping - discount}" />

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-iYQeCzEYFbKjA/T2uDLTpkwGzCiq6soy8tYaI1GyVh/UjpbCx/TYkiZhlZB6+fzT" crossorigin="anonymous">
        <title>Buy Now</title>
        <link rel="icon" href="${pageContext.request.contextPath}/images/LG1.png" type="image/x-icon">
        <script>const BASE = '${pageContext.request.contextPath}';</script>

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
                background:#d6d6d6;
            }
            input{
                width:100%;
                padding:10px;
                margin:10px 0;
            }
            .address{
                padding:5px 20px;
                background:#eff0f0;
            }
            .address input{
                border:none;
            }
            .methods{
                margin:20px 0;
            }
            .methods img{
                margin:10px;
            }
            .deli{
                border:1px solid gray;
            }
            #complete input{
                border:none;
                background:#52b1ff;
                color:#fff;
                font-weight:1000;
                padding:10px 0;
            }
            #complete input:hover{
                background:#1f63bb;
                transition:.2s;
            }
            .col-md-5{
                padding:5% 5% 5% 2%;
                background:#eff0f0;
            }
            .col-md-7{
                margin:0;
            }
            .error{
                color:red;
            }

            /* Giá trị canh hàng */
            #line{
                margin-top:10px;
            }
            #line .row-line{
                display:flex;
                justify-content:space-between;
                align-items:center;
                margin-bottom:6px;
            }
            #line h6,#line h5{
                margin:0;
            }
            #line .label{
                flex:1;
            }
            #line .value{
                min-width:120px;
                text-align:right;
            }

            /* Fix tràn ảnh cột phải */
            .col-md-5 .row img#product{
                max-width:100%;
                width:100%;
                height:auto;
                display:block;
                object-fit:contain;
                max-height:160px;
            }
            .col-md-5 .row .col-2:first-child{
                overflow:hidden;
            }

            /* Nhỏ gọn khu promo */
            .promo-wrap{
                display:flex;
                gap:.5rem;
                align-items:center;
                flex-wrap:wrap;
            }
            .promo-wrap input{
                max-width:220px;
                margin:0;
            }
            .promo-wrap .btn{
                margin:0;
            }
        </style>
    </head>

    <body>
        <div class="container">
            <div class="row">

                <!-- LEFT -->
                <div class="col-md-7">
                    <form action="insertOrders" method="get" id="payment">
                        <h1>GIO</h1>
                        <h6><b>SHIPMENT DETAILS</b></h6>

                        <div class="row">
                            <div class="col-2">
                                <img class="account"
                                     src="https://cdn.icon-icons.com/icons2/3054/PNG/512/account_profile_user_icon_190494.png"
                                     alt="">
                            </div>
                            <div id="accountinfo" class="col-10">
                                <p>${customerName}</p>
                            </div>
                        </div>

                        <!-- Phone: tự điền & khóa nếu tài khoản đã có số -->
                        <div class="position-relative">
                            <input type="text" placeholder="Your numberphone" name="phoneNumber" id="phoneNumber"
                                   value="${customerPhone}"
                                   <c:if test="${not empty customerPhone}">readonly</c:if>>
                            <c:if test="${not empty customerPhone}">
                                <small id="phoneHint" class="text-muted" style="position:absolute; right:0; top:-6px;">
                                    Using account phone • <a href="#" onclick="return enablePhoneEdit()">Change</a>
                                </small>
                            </c:if>
                        </div>

                        <div>
                            <b>Default address</b>
                            <div class="address">
                                <input type="text" name="address" value="${customerAddress}" readonly>
                            </div>
                        </div>

                        <div>
                            <input type="text" id="newaddress" name="newaddress" placeholder="Add new address">
                        </div>

                        <div class="methods">
                            <b>Payment methods</b><br>
                            <div class="deli">
                                <img src="https://hstatic.net/0/0/global/design/seller/image/payment/other.svg?v=6" alt="">Payment
                            </div>
                        </div>

                        <div class="row">
                            <div id="back" class="col-8">
                                <a href="${pageContext.request.contextPath}/productDetail?id=${id}&size=${size}">Back to product</a>
                            </div>
                            <div id="complete" class="col-4">
                                <input type="submit" value="COMPLETE">
                            </div>
                        </div>

                        <!-- Hidden -->
                        <input type="hidden" name="id"       value="${id}">
                        <input type="hidden" name="size"     value="${size}">
                        <input type="hidden" name="quantity" value="${qty}">
                        <input type="hidden" id="total"      name="total"      value="${grandTotal}">
                        <input type="hidden" id="shipping"   name="shipping"   value="${shipping}">
                        <input type="hidden" id="discount"   name="discount"   value="${discount}">
                        <input type="hidden" id="promoId"    name="promoId"    value="${promoId}">
                        <input type="hidden" id="promoPct"   name="promoPct"   value="${promoPercent}">
                    </form>
                </div>

                <!-- RIGHT -->
                <div class="col-md-5">
                    <div class="row">
                        <div class="col-2">
                            <img id="product" src="${pic}" alt="">
                        </div>
                        <div class="col-8">
                            <b>${name}</b>
                            <p>Quantity: ${qty}</p>
                            <p>Size: ${size}</p>
                        </div>
                        <div class="col-2 text-end">
                            <p class="price"><fmt:formatNumber type="number" value="${unitPrice}" pattern="###,###" /> VND</p>
                        </div>
                    </div>
                    <hr>

                    <!-- Promo apply/remove -->
                    <div class="mb-2">
                        <div class="promo-wrap">
                            <input id="promoInput" class="form-control form-control-sm" type="text" inputmode="numeric" pattern="[0-9]*"
                                   placeholder="Enter promo">
                            <button type="button" class="btn btn-sm btn-outline-secondary" onclick="applyPromo()">Apply</button>
                            <button type="button" id="promoRemove" class="btn btn-sm btn-outline-danger" style="display:none;"
                                    onclick="removePromo()">Remove</button>
                        </div>
                        <small id="promoMsg" class="d-block" style="display:none;"></small>
                    </div>

                    <!-- Price section -->
                    <div id="line">
                        <div class="row-line">
                            <h6 class="label">Subtotal</h6>
                            <h6 class="value"><fmt:formatNumber type="number" value="${subtotal}" pattern="###,###" /> VND</h6>
                        </div>

                        <div class="row-line">
                            <h6 class="label">Shipping</h6>
                            <h6 class="value"><fmt:formatNumber type="number" value="${shipping}" pattern="###,###" /> VND</h6>
                        </div>

                        <div id="discountRow" class="row-line" style="display:none;">
                            <h6 id="discountLabel" class="label">Promo</h6>
                            <h6 id="discountValue" class="value">-0 VND</h6>
                        </div>

                        <hr class="my-2">

                        <div class="row-line">
                            <h5 class="label">Total</h5>
                            <h5 id="grandTotalText" class="value"><fmt:formatNumber type="number" value="${grandTotal}" pattern="###,###" /> VND</h5>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- JS -->
        <script src="${pageContext.request.contextPath}/js/jquery-3.7.0.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery.validate.min.js"></script>
        <script>
                                        const FREE_SHIP_THRESHOLD = 200000;
                                        const SHIPPING_FEE = 20000;

                                        let subtotal = ${subtotal};
                                        let shipping = ${shipping};
                                        let promoPercent = ${promoPercent};
                                        let promoId = ${promoId};

                                        function fmt(n) {
                                            return (n || 0).toLocaleString('vi-VN') + ' VND';
                                        }

                                        function recalcTotals() {
                                            shipping = subtotal >= FREE_SHIP_THRESHOLD ? 0 : SHIPPING_FEE;
                                            const discount = Math.round(subtotal * (promoPercent || 0) / 100.0);
                                            const grand = Math.max(0, subtotal + shipping - discount);

                                            document.getElementById('grandTotalText').innerText = fmt(grand);
                                            document.getElementById('discount').value = discount;
                                            document.getElementById('total').value = grand;
                                            document.getElementById('shipping').value = shipping;
                                            document.getElementById('promoId').value = promoId || '';
                                            document.getElementById('promoPct').value = promoPercent || 0;

                                            const row = document.getElementById('discountRow');
                                            const valEl = document.getElementById('discountValue');
                                            const rmBtn = document.getElementById('promoRemove');

                                            if ((promoPercent || 0) > 0) {
                                                row.style.display = 'flex';
                                                valEl.textContent = '- ' + discount.toLocaleString('vi-VN') + ' VND';
                                                if (rmBtn)
                                                    rmBtn.style.display = 'inline-block';
                                            } else {
                                                row.style.display = 'none';
                                                valEl.textContent = '-0 VND';
                                                if (rmBtn)
                                                    rmBtn.style.display = 'none';
                                            }
                                        }

                                        function applyPromo() {
                                            const code = (document.getElementById('promoInput').value || '').trim();
                                            const msg = document.getElementById('promoMsg');
                                            if (!code) {
                                                msg.style.color = 'red';
                                                msg.innerText = 'Please enter a promo.';
                                                msg.style.display = 'block';
                                                return;
                                            }
                                            msg.style.display = 'none';
                                            msg.innerText = '';

                                            $.ajax({
                                                url: BASE + '/applyPromo',
                                                method: 'POST',
                                                dataType: 'json',
                                                data: {code: code},
                                                success: function (res) {
                                                    if (res && res.ok && res.type === 'percent') {
                                                        promoPercent = parseInt(res.value || 0, 10) || 0;
                                                        promoId = parseInt(res.promoId || 0, 10) || 0;
                                                        recalcTotals();
                                                        msg.style.color = '#28a745';
                                                        msg.innerText = 'Applied promo';
                                                        msg.style.display = 'block';
                                                    } else {
                                                        msg.style.color = 'red';
                                                        msg.innerText = (res && res.message) ? res.message : 'Promo is invalid.';
                                                        msg.style.display = 'block';
                                                    }
                                                },
                                                error: function () {
                                                    msg.style.color = 'red';
                                                    msg.innerText = 'Cannot apply promo right now.';
                                                    msg.style.display = 'block';
                                                }
                                            });
                                        }

                                        function removePromo() {
                                            promoPercent = 0;
                                            promoId = 0;
                                            const input = document.getElementById('promoInput');
                                            if (input)
                                                input.value = '';
                                            const msg = document.getElementById('promoMsg');
                                            msg.style.color = '#6c757d';
                                            msg.innerText = 'Promo removed.';
                                            msg.style.display = 'block';
                                            recalcTotals();
                                        }

                                        function enablePhoneEdit() {
                                            const i = document.getElementById('phoneNumber');
                                            if (i) {
                                                i.removeAttribute('readonly');
                                                i.focus();
                                            }
                                            const hint = document.getElementById('phoneHint');
                                            if (hint) {
                                                hint.style.display = 'none';
                                            }
                                            return false; // prevent link navigation
                                        }

                                        $("#payment").validate({
                                            rules: {
                                                phoneNumber: {required: true, minlength: 10, digits: true},
                                                newaddress: {minlength: 3}
                                            },
                                            messages: {
                                                phoneNumber: {required: "Phone number is required", digits: "Please enter only digits"},
                                                newaddress: {}
                                            }
                                        });

                                        document.addEventListener('DOMContentLoaded', recalcTotals);
        </script>
    </body>
</html>
