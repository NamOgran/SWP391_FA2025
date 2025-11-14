<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%-- JSTL core / fmt / fn --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<%
    // Nếu user quay lại cart (không phải vừa applyPromo hoặc đang ở payment)
    String referer = request.getHeader("referer");
    boolean fromPromo = (referer != null && referer.contains("applyPromo"));
    boolean fromPayment = (referer != null && referer.contains("payment.jsp"));
    if (!fromPromo && !fromPayment) {
        session.removeAttribute("promoPercent");
        session.removeAttribute("promoId");
        session.removeAttribute("promoCode");
        session.removeAttribute("promoType");
        session.removeAttribute("promoValue");
    }
%>


<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-iYQeCzEYFbKjA/T2uDLTpkwGzCiq6soy8tYaI1GyVh/UjpbCx/TYkiZhlZB6+fzT" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link href='https://fonts.googleapis.com/css?family=Quicksand' rel='stylesheet'>
        <title>Cart</title>
        <link rel="icon" href="${pageContext.request.contextPath}/images/LG1.png" type="image/x-icon">
        <script>
            const BASE = '${pageContext.request.contextPath}';
            function safeIdPart(s) {
                return (s || '').toString().replace(/\W/g, '_');
            }
        </script>
    </head>

    <style>
        body {
            font-family:"Quicksand",sans-serif;
            margin:0 10%;
            color:#444;
        }
        .content {
            text-align: center;
            border-bottom: #a0816c solid 2px;
            margin-top: 3%;
            margin-bottom: 4%;
        }
        #highlight {
            color:#a0816c;
        }
        .product {
            margin:2% 0;
        }
        .product img {
            width:100%;
            height:100%;
        }
        .quan {
            display:flex;
            border:rgb(230,230,230) solid 1px;
            width:40%;
            margin:20px 0;
        }
        .quan button {
            width:30%;
            font-size:16px;
            border:none;
        }
        .quan input {
            border:none;
            width:41%;
            text-align:center;
        }
        .info {
            border: 1px solid #dddddd;
            padding: 20px;
            border-radius: 15px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.08);
            background-color: #fff;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            margin-top: -50px;
        }
        .payment{
            width:100%;
            padding:10px 0;
            border:none;
            background-color:rgb(255,207,49);
            color:#65b9c4;
            font-weight:1000;
        }
        .payment:hover{
            background-color:red;
            color:white;
            transition:.7s;
        }
        .note li{
            font-size:12px;
            list-style:none;
        }
        .policy {
            margin-top: 20px;
            border: 1px solid #81e7f5;
            background-color: #d7f0f3;
            padding: 15px;
            border-radius: 15px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.08);
        }
        .order-info {
            top: -30px;
            padding: 20px;
        }
        * {
            margin:0;
            padding:0;
            font-family:'Quicksand',sans-serif;
            box-sizing:border-box;
            color:rgb(151,143,137);
        }
        img{
            width:100%;
        }
        :root{
            --logo-color:#a0816c;
            --nav-list-color:#a0816c;
            --icon-color:#a0816c;
            --text-color:#a0816c;
            --bg-color:#a0816c;
        }
        body::-webkit-scrollbar{
            width:.5em;
        }
        body::-webkit-scrollbar-track{
            box-shadow:inset 0 0 6px rgba(0,0,0,.3);
        }
        body::-webkit-scrollbar-thumb{
            border-radius:50px;
            background-color:var(--bg-color);
            outline:1px solid slategrey;
        }
        nav{
            height:70px;
            justify-content:center;
            display:flex;
        }
        .header_title{
            display:flex;
            text-align:center;
            justify-content:center;
            align-items:center;
            background-color:#f5f5f5;
            font-size:.8125rem;
            font-weight:500;
            height:30px;
        }
        .headerContent{
            max-width:1200px;
            margin:0 auto;
        }
        .headerContent,.headerList,.headerTool{
            display:flex;
            align-items:center;
        }
        .headerContent{
            justify-content:space-around;
        }
        .logo a{
            text-decoration:none;
            color:var(--logo-color);
            font-size:1.5em;
            font-weight:bold;
        }
        .headerList{
            margin:0;
            list-style-type:none;
        }
        .headerListItem{
            transition:font-size .3s ease;
            height:24px;
        }
        .headerListItem:hover{
            font-size:18px;
        }
        .headerListItem a{
            margin:0 10px;
            padding:22px 0;
            text-decoration:none;
            color:var(--text-color);
        }
        .dropdownMenu{
            position:absolute;
            width:200px;
            padding:0;
            margin-top:17px;
            background-color:#fff;
            display:none;
            z-index:1;
            box-shadow:rgba(0,0,0,.35) 0 5px 15px;
        }
        .dropdownMenu li{
            list-style-type:none;
            margin:0;
            border-bottom:1px solid rgb(235 202 178);
        }
        .dropdownMenu li a{
            text-decoration:none;
            padding:5px 15px;
            margin:0;
            width:100%;
            display:flex;
            font-size:.9em;
            color:var(--text-color);
        }
        .dropdownMenu li:hover{
            background-color:#f1f1f1
        }
        .headerTool a{
            padding:5px;
        }
        .headerToolIcon{
            width:45px;
            justify-content:center;
            display:flex;
        }
        .icon{
            cursor:pointer;
            font-size:26px;
        }
        .searchBox,.infoBox{
            right:13%;
        }
        .nowrap{
            white-space:nowrap;
        }
        .money{
            display:inline-block;
            max-width:100%;
            white-space:nowrap;
            font-weight:800;
            color:#d33;
            line-height:1.2;
            font-size: clamp(14px, 2vw, 22px);
            font-variant-numeric: tabular-nums;
        }
        .promo-badge{
            font-size:.85rem;
            background:#f1f1f1;
            border:1px dashed #d0a587;
            padding:.1rem .4rem;
            border-radius:.4rem;
            color:#a0816c;
        }
        .promo-remove{
            cursor:pointer;
            margin-left:.5rem;
            font-size:.85rem;
        }
                /* footer */
        footer {
            background-color: #f5f5f5;
        }

        .content-footer {
            text-align: center;
            padding: 30px;
        }

        .content-footer h3 {
            color: #a0816c;
        }

        .bct {
            width: 50%;
        }

        footer p {
            font-size: 15px;
        }

        footer a {
            text-decoration: none;
            color: rgb(151, 143, 137);
        }

        .items-footer {
            margin: 5%;
        }

        #highlight {
            color: #a0816c;
        }

        #img-footer img {
            padding: 0;
        }

        #img-footer {
            margin: 0 auto;
        }

        .phone {
            position: relative;
        }

        .bi-telephone {
            cursor: pointer;
            font-size: 3em;
            /* width: 85px; */
            /* height: 60px; */
            /* display: flex; */
            position: absolute;
            top: -16%;
            left: 15px;
        }

        .contact-item {
            display: flex;
        }

        .contact-link {
            margin-right: 10px;
            border: 1px solid #a0816c;
            border-radius: 5px;
            padding: 5px;
            width: 35.6px;
            justify-content: center;
            display: flex;
        }

        .contact-link:hover {
            background-color: var(--bg-color);

            .bi-facebook::before,
            .bi-instagram::before {
                color: white;
            }
        }
    </style>

    <body>
        <!-- Header + Nav -->
        <header class="header">
            <div class="header_title">Free shipping with orders from&nbsp;<strong>200,000 VND </strong></div>
            <div class="headerContent">
                <div class="logo"><a href="${pageContext.request.contextPath}/productList">GIO</a></div>
                <nav>
                    <ul class="headerList">
                        <li class="headerListItem"><a href="${pageContext.request.contextPath}/productList">Home page</a></li>
                        <li class="headerListItem">
                            <a href="${pageContext.request.contextPath}/productList/male">Men's Fashion<i class="bi bi-caret-down dropdown-icon"></i></a>
                            <ul class="dropdownMenu">
                                <li><a href="${pageContext.request.contextPath}/productList/male/t_shirt">T-shirt</a></li>
                                <li><a href="${pageContext.request.contextPath}/productList/male/pant">Long pants</a></li>
                                <li><a href="${pageContext.request.contextPath}/productList/male/short">Shorts</a></li>
                            </ul>
                        </li>
                        <li class="headerListItem">
                            <a href="${pageContext.request.contextPath}/productList/female">Women's Fashion<i class="bi bi-caret-down dropdown-icon"></i></a>
                            <ul class="dropdownMenu">
                                <li><a href="${pageContext.request.contextPath}/productList/female/t_shirt">T-shirt</a></li>
                                <li><a href="${pageContext.request.contextPath}/productList/female/pant">Long pants</a></li>
                                <li><a href="${pageContext.request.contextPath}/productList/female/dress">Dress</a></li>
                            </ul>
                        </li>
                        <li class="headerListItem">
                            <a href="${pageContext.request.contextPath}/aboutUs.jsp">Information<i class="bi bi-caret-down dropdown-icon"></i></a>
                            <ul class="dropdownMenu">
                                <li><a href="${pageContext.request.contextPath}/aboutUs.jsp">About Us</a></li>
                                <li><a href="${pageContext.request.contextPath}/contact.jsp">Contact</a></li>
                                <li><a href="${pageContext.request.contextPath}/policy.jsp">Exchange policy</a></li>
                            </ul>
                        </li>
                    </ul>
                </nav>
                <div class="headerTool">
                    <div class="headerToolIcon">
                        <a href="${pageContext.request.contextPath}/profile"><i class="bi bi-person icon"></i></a>
                    </div>
                    <div class="headerToolIcon">
                        <a href="${pageContext.request.contextPath}/loadCart"><i class="bi bi-cart2 icon"></i></a>
                    </div>
                </div>
            </div>
            <hr width="100%" color="#d0a587" />
        </header>

        <div class="content"><h2 id="highlight">Your Cart</h2></div>

        <!-- Thông báo số lượng sản phẩm -->
        <div class="status">
            <p>You currently have <b id="productCount">${quanP}</b><b> products</b> in your cart</p>
        </div>

        <div class="row">
            <!-- Cột danh sách item -->
            <div class="col-md-8">
                <%-- Lặp qua cartList để render từng item --%>
                <c:forEach items="${requestScope.cartList}" var="cart">
                    <%-- size an toàn để gắn vào id --%>
                    <c:set var="safeSize" value="${fn:replace(fn:replace(cart.size_name, ' ', '_'), '-', '_')}" />

                    <%-- Định dạng đơn giá & thành tiền --%>
                    <fmt:formatNumber var="unitPriceFmt" type="number" value="${cart.price}" pattern="###,###" />
                    <c:set var="lineTotalRaw" value="${cart.price * cart.quantity}" />
                    <fmt:formatNumber var="lineTotalFmt" type="number" value="${lineTotalRaw}" pattern="###,###" />

                    <!-- Item -->
                    <div class="row" id='user${cart.productID}${safeSize}'>
                        <div class="product">
                            <div class="row">
                                <div class="col-2">
                                    <!-- Ảnh sản phẩm theo productID -->
                                    <img src="${picUrlMap[cart.productID]}" alt="">
                                </div>

                                <div class="col-8">
                                    <b id="highlight">${nameProduct[cart.productID]}</b>
                                    <p>Size: ${cart.size_name}</p>

                                    <!-- Cụm tăng/giảm số lượng (readonly input để đồng bộ bằng Ajax) -->
                                    <div class="quan">
                                        <button onclick="decrementQuantity(${cart.productID},${cart.price},${cart.quantity}, '${cart.size_name}')" data-product-id="${cart.productID}">-</button>
                                        <input type="number" name="quantity" id="quantity${cart.productID}${safeSize}" value="${cart.quantity}" min="1" readonly>
                                        <button onclick="incrementQuantity2(${cart.productID},${cart.price},${cart.quantity}, '${cart.size_name}')" data-product-id="${cart.productID}">+</button>
                                    </div>

                                    <!-- Đơn giá hiển thị -->
                                    <b id="price1${cart.productID}${safeSize}" class="nowrap">${unitPriceFmt}</b>
                                </div>

                                <div class="col-2">
                                    <!-- Xoá item -->
                                    <button class="btn btn-danger" onclick="deleteCartItem(${cart.productID}, '${cart.size_name}')" data-product-id="${cart.productID}">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                    <!-- Giá trị thô phục vụ script nếu cần -->
                                    <input type="hidden" class="price" value="${cart.price}">
                                    <input type="hidden" class="quantity" value="${cart.quantity}">
                                    <input type="hidden" class="size" value="${cart.size_name}">
                                </div>
                            </div>

                            <!-- Thành tiền dòng -->
                            <div class="row">
                                <div class="col-10"><b>Into money:</b></div>
                                <div class="col-2 text-end nowrap" id="price2${cart.productID}${safeSize}">
                                    <b class="line-total">${lineTotalFmt}</b>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <!-- Cột thông tin đơn hàng + promo -->
            <div class="col-md-4 order-info">
                <div class="info">
                    <b id="highlight">Order Information</b>
                    <hr>

                    <!-- Tạm tính -->
                    <div class="row align-items-center">
                        <div class="col-7"><b>Subtotal:</b></div>
                        <div class="col-5 text-end"><h4 class="m-0 nowrap"><b id="sum" class="money">0&nbsp;VND</b></h4></div>
                    </div>

                    <!-- Phí ship (free nếu đạt ngưỡng) -->
                    <div class="row align-items-center">
                        <div class="col-7"><b>Shipping:</b></div>
                        <div class="col-5 text-end"><h4 class="m-0 nowrap"><b id="shippingValue" class="money">0&nbsp;VND</b></h4></div>
                    </div>

                    <!-- Nhập/áp dụng mã giảm -->
                    <div class="mt-3">
                        <div class="input-group">
                            <input id="promoInput" class="form-control" type="text"
                                   inputmode="numeric" pattern="[0-9]*"
                                   placeholder="Enter promo">
                            <button class="btn btn-outline-secondary" type="button" onclick="applyPromo()">Apply</button>
                        </div>
                        <small id="promoHint" class="text-muted d-block mt-1">
                            <span id="badgePromo" class="promo-badge ms-2" style="display:none;"></span>
                            <span class="promo-remove text-danger" style="display:none;" id="promoRemove" onclick="removePromo()">Remove</span>
                        </small>
                        <small id="promoError" class="text-danger d-block mt-1" style="display:none;"></small>
                    </div>

                    <!-- Hàng giảm giá hiển thị khi có promo -->
                    <div class="row align-items-center mt-2" id="discountRow" style="display:none;">
                        <div class="col-7"><b>Promo: </b></div>
                        <div class="col-5 text-end"><h5 class="m-0 nowrap"><b id="discountValue" class="money">0&nbsp;VND</b></h5></div>
                    </div>

                    <div class="mt-2"></div>

                    <!-- Tổng cộng -->
                    <div class="row align-items-center">
                        <div class="col-7"><b>Total:</b></div>
                        <div class="col-5 text-end"><h4 class="m-0 nowrap"><b id="grandTotal" class="money">0&nbsp;VND</b></h4></div>
                    </div>

                    <hr>
                    <ul class="note">
                        <li>Shipping is free for orders over 200,000 VND.</li>
                        <li>You can also enter a discount code at the checkout page.</li>
                    </ul>

                    <!-- Submit sang payment.jsp + truyền hidden các giá trị đã tính -->
                    <form action="${pageContext.request.contextPath}/payment.jsp" method="get">
                        <button class="payment">PAYMENT</button>
                        <input type="hidden" name="size" value="${size}">
                        <input type="hidden" id="subtotalInput" name="total" value="0">
                        <input type="hidden" id="shippingInput" name="shipping" value="0">
                        <input type="hidden" id="discountInput" name="discount" value="0">
                        <input type="hidden" id="grandTotalInput" name="grandTotal" value="0">
                        <input type="hidden" id="promoCodeInput" name="promoCode" value="">
                        <input type="hidden" id="promoIdInput" name="promoId" value="">
                        <input type="hidden" id="promoTypeInput" name="promoType" value="">
                        <input type="hidden" id="promoValueInput" name="promoValue" value="">
                    </form>
                </div>

                <div class="policy">
                    <b>Purchase policy:</b>
                    <p>Currently, we only apply payments for orders with a minimum value of <b>0 VND</b> or more.</p>
                </div>
            </div>
        </div>

                <footer>
            <div class="content-footer">
                <h3 id="highlight">Follow us on Instagram</h3>
                <p>@dotai.vn & @fired.vn</p>
            </div>

            <div class="row" id="img-footer">
                <img class="col-md-2" src="https://theme.hstatic.net/1000296747/1000891809/14/gallery_item_1_img.jpg?v=55"
                     alt="">
                <img class="col-md-2" src="https://theme.hstatic.net/1000296747/1000891809/14/gallery_item_2_img.jpg?v=55"
                     alt="">
                <img class="col-md-2" src="https://theme.hstatic.net/1000296747/1000891809/14/gallery_item_3_img.jpg?v=55"
                     alt="">
                <img class="col-md-2" src="https://theme.hstatic.net/1000296747/1000891809/14/gallery_item_4_img.jpg?v=55"
                     alt="">
                <img class="col-md-2" src="https://theme.hstatic.net/1000296747/1000891809/14/gallery_item_5_img.jpg?v=55"
                     alt="">
                <img class="col-md-2" src="https://theme.hstatic.net/1000296747/1000891809/14/gallery_item_6_img.jpg?v=55"
                     alt="">
            </div>

            <div class="items-footer">
                <div class="row">
                    <div class="col-sm-3">
                        <h4 id="highlight">About Gio</h4>
                        <p>Vintage and basic wardrobe for boys and girls.Vintage and basic wardrobe for boys and girls.</p>
                        <img src="//theme.hstatic.net/1000296747/1000891809/14/footer_logobct_img.png?v=55" alt="..."
                             class="bct">
                    </div>
                    <div class="col-sm-3">
                        <h4 id="highlight">Contact</h4>
                        <p><b>Address:</b> 100 Nguyen Van Cu, An Khanh Ward, Ninh Kieu District, City. Can Tho</p>
                        <p><b>Phone:</b> 0123.456.789 - 0999.999.999</p>
                        <p><b>Email:</b> info@gio.vn</p>
                    </div>
                    <div class="col-sm-3">
                        <h4 id="highlight">Customer support</h4>
                        <ul class="CS">
                            <li><a href="">Search</a></li>
                            <li><a href="">Introduce</a></li>
                        </ul>
                    </div>
                    <div class="col-sm-3">
                        <h4 id="highlight">Customer care</h4>
                        <div class="row phone">
                            <div class="col-sm-3"><i class="bi bi-telephone icon"></i></div>
                            <div class="col-9">
                                <h4 id="highlight">0123.456.789</h4>
                                <a href="">info@gio.vn</a>
                            </div>
                        </div>
                        <h5 id="highlight">Follow Us</h5>
                        <div class="contact-item">
                            <a href="" class="contact-link"><i class="bi bi-facebook contact-icon"></i></a>
                            <a href="" class="contact-link"><i class="bi bi-instagram contact-icon"></i></a>
                        </div>
                    </div>
                </div>
            </div>


        </footer>

        <%-- jQuery local + CDN (có thể giữ 1 bản) --%>
        <script src="${pageContext.request.contextPath}/js/jquery-3.7.0.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery.validate.min.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

        <script>
                                // --------- HẰNG SỐ VẬN CHUYỂN/PROMO ---------
                                const SHIPPING_FEE = 20000;                 // phí ship mặc định
                                const FREE_SHIP_THRESHOLD = 200000;         // ngưỡng freeship

                                // Đọc promo đã áp dụng từ session (nếu có)
                                const INITIAL_PROMO_PERCENT = parseInt('${sessionScope.promoPercent}', 10) || 0;
                                const INITIAL_PROMO_ID = parseInt('${sessionScope.promoId}', 10) || 0;
                                let appliedPromo = {type: 'percent', value: INITIAL_PROMO_PERCENT, id: INITIAL_PROMO_ID};

                                // --------- UTIL: format/parse tiền ---------
                                function formatVND(amount) {
                                    return (amount || 0).toLocaleString('vi-VN') + "\u00A0VND";
                                }
                                function onlyDigits(s) {
                                    return (s || '').toString().replace(/[^\d]/g, '');
                                }
                                function toInt(text) {
                                    return parseInt(onlyDigits(text), 10) || 0;
                                }

                                // Tính subtotal từ DOM (cộng tất cả .line-total)
                                function calcSubtotalFromDom() {
                                    let subtotal = 0;
                                    document.querySelectorAll('.line-total').forEach(el => subtotal += toInt(el.textContent));
                                    return subtotal;
                                }

                                // Khoá/mở ô nhập mã khi giỏ trống/có hàng
                                function setPromoDisabled(disabled) {
                                    const i = document.getElementById('promoInput');
                                    const btn = i?.nextElementSibling;
                                    if (i)
                                        i.disabled = !!disabled;
                                    if (btn)
                                        btn.disabled = !!disabled;
                                }

                                // Cập nhật UI khi có/không có promo + set hidden inputs
                                function updatePromoUI(subtotal) {
                                    const badge = document.getElementById('badgePromo');
                                    const rm = document.getElementById('promoRemove');
                                    const err = document.getElementById('promoError');
                                    const row = document.getElementById('discountRow');
                                    const val = document.getElementById('discountValue');
                                    if (err) {
                                        err.style.display = 'none';
                                        err.innerText = '';
                                    }

                                    if (appliedPromo && appliedPromo.type === 'percent' && appliedPromo.value > 0) {
                                        const discount = Math.round(subtotal * appliedPromo.value / 100.0);
                                        row.style.display = '';
                                        val.innerHTML = formatVND(discount);

                                        if (badge) {
                                            const idTxt = appliedPromo.id ? ('#' + appliedPromo.id + ' — ') : '';
                                            badge.style.display = 'inline-block';
                                            badge.textContent = `Promo`;
                                        }
                                        if (rm) {
                                            rm.style.display = 'inline';
                                        }

                                        // hidden inputs
                                        document.getElementById('discountInput').value = discount;
                                        document.getElementById('promoCodeInput').value = appliedPromo.id ? String(appliedPromo.id) : '';
                                        const pid = document.getElementById('promoIdInput');
                                        if (pid)
                                            pid.value = appliedPromo.id ? String(appliedPromo.id) : '';
                                        document.getElementById('promoTypeInput').value = 'percent';
                                        document.getElementById('promoValueInput').value = appliedPromo.value;
                                    } else {
                                        row.style.display = 'none';
                                        val.innerHTML = formatVND(0);
                                        if (badge)
                                            badge.style.display = 'none';
                                        if (rm)
                                            rm.style.display = 'none';

                                        // reset hidden inputs
                                        document.getElementById('discountInput').value = 0;
                                        document.getElementById('promoCodeInput').value = '';
                                        const pid = document.getElementById('promoIdInput');
                                        if (pid)
                                            pid.value = '';
                                        document.getElementById('promoTypeInput').value = '';
                                        document.getElementById('promoValueInput').value = '';
                                    }
                                }

                                // Recalculate: subtotal, shipping, discount, grand total + bind về UI & hidden inputs
                                function recalcTotals() {
                                    const subtotal = calcSubtotalFromDom();
                                    const hasItems = subtotal > 0;
                                    const shipping = !hasItems ? 0 : (subtotal >= FREE_SHIP_THRESHOLD ? 0 : SHIPPING_FEE);
                                    const discount = (appliedPromo && appliedPromo.type === 'percent')
                                            ? Math.round(subtotal * (appliedPromo.value || 0) / 100.0) : 0;
                                    const grand = Math.max(0, subtotal + shipping - discount);

                                    document.getElementById('sum').innerHTML = formatVND(subtotal);
                                    document.getElementById('shippingValue').innerHTML = formatVND(shipping);
                                    document.getElementById('grandTotal').innerHTML = formatVND(grand);

                                    document.getElementById('subtotalInput').value = subtotal;
                                    document.getElementById('shippingInput').value = shipping;
                                    document.getElementById('grandTotalInput').value = grand;

                                    setPromoDisabled(!hasItems);
                                    updatePromoUI(subtotal);
                                }

                                // Khởi tạo: tính tổng + hiển thị badge promo nếu có sẵn trong session
                                document.addEventListener('DOMContentLoaded', function () {
                                    recalcTotals();
                                    if (INITIAL_PROMO_PERCENT > 0) {
                                        const badge = document.getElementById('badgePromo');
                                        const rm = document.getElementById('promoRemove');
                                        if (badge) {
                                            const idTxt = INITIAL_PROMO_ID ? ('#' + INITIAL_PROMO_ID + ' — ') : '';
                                            badge.style.display = 'inline-block';
                                            badge.textContent = `Promo %`;
                                        }
                                        if (rm) {
                                            rm.style.display = 'inline';
                                        }
                                    }
                                });

                                // Gọi servlet /applyPromo để kiểm tra và lấy % giảm
                                function applyPromo() {
                                    const code = (document.getElementById('promoInput').value || '').trim();
                                    const err = document.getElementById('promoError');
                                    if (!code) {
                                        err.innerText = 'Please enter a promo ID.';
                                        err.style.display = 'block';
                                        return;
                                    }
                                    err.style.display = 'none';
                                    err.innerText = '';

                                    $.ajax({
                                        url: BASE + '/applyPromo',
                                        method: 'POST',
                                        dataType: 'json',
                                        data: {code: code},
                                        success: function (res) {
                                            if (res && res.ok && res.type === 'percent') {
                                                appliedPromo = {
                                                    type: 'percent',
                                                    value: parseInt(res.value || 0, 10) || 0,
                                                    id: parseInt(res.promoId || 0, 10) || 0
                                                };
                                                recalcTotals(); // cập nhật tổng
                                            } else {
                                                err.innerText = (res && res.message) ? res.message : 'Promo is invalid.';
                                                err.style.display = 'block';
                                            }
                                        },
                                        error: function () {
                                            err.innerText = 'Cannot apply promo right now.';
                                            err.style.display = 'block';
                                        }
                                    });
                                }

                                // Bỏ áp dụng mã giảm
                                function removePromo() {
                                    appliedPromo = {type: 'percent', value: 0, id: 0};
                                    document.getElementById('promoInput').value = '';
                                    recalcTotals();
                                }

                                // Tăng số lượng: gọi /cartIncrease; response: "lineTotal,...,temp"
                                function incrementQuantity2(productID, price, quantity, size_name) {
                                    const safe = safeIdPart(size_name);
                                    const qty = document.getElementById('quantity' + productID + safe);
                                    const newQty = (parseInt(qty.value, 10) || 1) + 1;

                                    $.ajax({
                                        url: BASE + '/cartIncrease',
                                        method: 'GET',
                                        data: {id: productID, price: price, quantity: newQty, size: size_name},
                                        success: function (response) {
                                            const values = (response || '').split(',');
                                            const line = parseInt(values[0] || '0', 10);
                                            const temp = parseInt(values[2] || '0', 10); // 0: ok, khác 0: hết hàng
                                            if (temp === 0) {
                                                qty.value = newQty;
                                                const holder = document.querySelector('#price2' + productID + safe + ' .line-total');
                                                holder.textContent = (isNaN(line) || line <= 0) ? (price * newQty).toLocaleString('vi-VN')
                                                        : line.toLocaleString('vi-VN');
                                                recalcTotals();
                                            } else {
                                                alert('sold out!');
                                            }
                                        },
                                        error: function (xhr) {
                                            alert('Increase failed: ' + (xhr?.status || '') + ' ' + (xhr?.statusText || ''));
                                        }
                                    });
                                }

                                // Giảm số lượng: gọi /cartDecrease; không cho < 1
                                function decrementQuantity(productID, price, quantity, size_name) {
                                    const safe = safeIdPart(size_name);
                                    const qty = document.getElementById('quantity' + productID + safe);
                                    const newQty = (parseInt(qty.value, 10) || 1) - 1;
                                    if (newQty <= 0)
                                        return;

                                    $.ajax({
                                        url: BASE + '/cartDecrease',
                                        method: 'GET',
                                        data: {id: productID, price: price, quantity: newQty, size: size_name},
                                        success: function (response) {
                                            const values = (response || '').split(',');
                                            const line = parseInt(values[0] || '0', 10);
                                            qty.value = newQty;
                                            const holder = document.querySelector('#price2' + productID + safe + ' .line-total');
                                            holder.textContent = (isNaN(line) || line <= 0) ? (price * newQty).toLocaleString('vi-VN')
                                                    : line.toLocaleString('vi-VN');
                                            recalcTotals();
                                        },
                                        error: function (xhr) {
                                            alert('Decrease failed: ' + (xhr?.status || '') + ' ' + (xhr?.statusText || ''));
                                        }
                                    });
                                }

                                // Xoá item: gọi /cartDelete; cập nhật đếm, ẩn dòng, set line-total=0 rồi tính lại
                                function deleteCartItem(productID, size_name) {
                                    if (!confirm('Are you sure to delete'))
                                        return;
                                    const productCount = document.querySelector('#productCount');

                                    $.ajax({
                                        url: BASE + '/cartDelete',
                                        method: 'GET',
                                        data: {id: productID, size: size_name},
                                        success: function (response) {
                                            const parts = (response || '').split(',');
                                            const cnt = parseInt(parts[2] || '0', 10); // tổng số item sau xoá
                                            if (!isNaN(cnt))
                                                productCount.textContent = cnt;

                                            const safe = safeIdPart(size_name);
                                            const row = document.getElementById('user' + productID + safe);
                                            if (row)
                                                row.style.display = 'none';

                                            const lineBox = document.querySelector('#price2' + productID + safe + ' .line-total');
                                            if (lineBox)
                                                lineBox.textContent = '0';

                                            recalcTotals();
                                        },
                                        error: function (xhr) {
                                            alert('Delete failed: ' + (xhr?.status || '') + ' ' + (xhr?.statusText || ''));
                                        }
                                    });
                                }
        </script>
    </body>
</html>
