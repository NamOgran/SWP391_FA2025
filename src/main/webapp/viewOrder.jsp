<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<fmt:setLocale value="vi_VN"/>

<!DOCTYPE html>
<html lang="en">
    <head>
        <!-- Meta & libs -->
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-iYQeCzEYFbKjA/T2uDLTpkwGzCiq6soy8tYaI1GyVh/UjpbCx/TYkiZhlZB6+fzT" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link href="https://fonts.googleapis.com/css?family=Quicksand" rel="stylesheet">

        <title>Orders</title>
        <link rel="icon" href="${pageContext.request.contextPath}/images/LG1.png" type="image/x-icon">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/viewOrder.css">

        <style>
            /* ===== Giống History + chống tràn ===== */
            *{
                box-sizing:border-box;
                font-family:'Quicksand',sans-serif;
                color:rgb(151,143,137)
            }
            html,body{
                max-width:100%;
                overflow-x:hidden
            }
            img{
                max-width:100%;
                height:auto;
                display:block
            }

            :root{
                --logo-color:#a0816c;
                --text-color:#a0816c;
                --bg-color:#a0816c
            }

            /* Header */
            .header{
                position:relative;
            } /* neo cho search box */
            .header_title{
                display:flex;
                justify-content:center;
                align-items:center;
                background:#f5f5f5;
                font-size:.8125rem;
                font-weight:500;
                height:30px;
            }
            .headerContent{
                max-width:1200px;
                margin:0 auto;
                padding:10px 0;
                display:flex;
                align-items:center;
                justify-content:space-between;
            }
            .logo a{
                text-decoration:none;
                color:var(--logo-color);
                font-size:1.5em;
                font-weight:bold
            }

            nav .headerList{
                display:flex;
                gap:28px;
                margin:0;
                padding:0;
                list-style:none
            }
            .headerListItem{
                position:relative;
                height:24px
            }
            .headerListItem>a{
                padding:22px 0;
                display:inline-block;
                text-decoration:none;
                color:var(--text-color)
            }

            .dropdownMenu{
                position:absolute;
                top:100%;
                left:0;
                width:200px;
                background:#fff;
                border:1px solid #eee;
                border-radius:8px;
                padding:0;
                box-shadow:0 8px 20px rgba(0,0,0,.12);
                display:none;
                z-index:1000;
                list-style:none;
                margin-top:17px;
            }
            .dropdownMenu li{
                list-style:none;
                border-bottom:1px solid rgb(235 202 178)
            }
            .dropdownMenu li:last-child{
                border-bottom:0
            }
            .dropdownMenu li a{
                display:block;
                padding:8px 14px;
                text-decoration:none;
                color:var(--text-color);
                font-size:.9em
            }
            .dropdownMenu li:hover{
                background:#f1f1f1
            }
            .headerListItem:hover>.dropdownMenu{
                display:block
            }

            .headerTool{
                display:flex;
                align-items:center;
                gap:12px
            }
            .icon{
                cursor:pointer;
                font-size:26px
            }

            /* Search box như History và không tràn */
            .searchBox{
                width:min(420px,calc(100vw - 32px));
                position:absolute;
                top:100px;
                right:13%;
                z-index:990;
                background:#fff;
                box-shadow:0 10px 24px rgba(0,0,0,.15);
                display:none;
            }
            @media (max-width:1200px){
                .searchBox{
                    right:8px;
                }
            }
            .searchBox-content{
                padding:9px 20px 20px
            }
            .search-input{
                position:relative
            }
            .search-input input{
                width:100%;
                border:1px solid #e7e7e7;
                background:#f6f6f6;
                height:44px;
                padding:8px 50px 8px 20px;
                font-size:1em;
            }
            .search-input button{
                position:absolute;
                right:1px;
                top:1px;
                height:97%;
                width:15%;
                border:none;
                background:#f6f6f6
            }

            /* Page wrap + sidebar */
            #page-wrap{
                max-width:1200px
            }
            .cat-card{
                border:1px solid #eee;
                border-radius:.5rem;
                padding:1rem;
                background:#fff;
                position:sticky;
                top:96px;
            }
            .cat-title{
                margin:0 0 .5rem;
                font-weight:700;
                color:#a0816c
            }
            .cat-link{
                display:block;
                padding:.55rem 0;
                border-top:1px solid #eee;
                text-decoration:none;
                color:#3a3a3a
            }
            .cat-link:first-of-type{
                border-top:0
            }

            /* Order card */
            .user-info{
                border:1px solid #eee;
                border-radius:.5rem;
                padding:1rem;
                margin-bottom:1rem;
                background:#fff
            }
            #header-order{
                align-items:center
            }
            .hr{
                margin:.75rem 0
            }

            .status-pill{
                display:inline-block;
                padding:.25rem .6rem;
                border-radius:999px;
                background:#f5f5f5;
                font-weight:600;
                font-size:.9rem
            }
            .status-Pending{
                color:#b57600
            }
            .status-Delivering{
                color:#0aa77a
            }
            .status-Delivered{
                color:#0666cc
            }

            .origin-price{
                opacity:.6;
                text-decoration:line-through
            }
            .saled-price{
                font-weight:700;
                color:#d33
            }

            /* Giữ dòng Total trên một dòng và canh phải */
            #product-bottom .col-md-2 p{
                white-space: nowrap;
                margin-bottom: 0;
                text-align: right;
            }

            .detail-btn,.feedback-btn{
                border:1px solid #a0816c;
                border-radius:.4rem;
                padding:.35rem .7rem;
                background:#fff;
                font-size:.9em
            }
            .detail-btn:hover,.feedback-btn:hover{
                background:#a0816c;
                color:#fff
            }

            .dropdown-container{
                display:none
            }

            /* Footer */
            footer{
                background:#f5f5f5
            }
            .content-footer{
                text-align:center;
                padding:30px
            }
            .items-footer{
                margin:5%
            }
            #img-footer, .items-footer > .row{
                margin-left:0 !important;
                margin-right:0 !important;
            }

            #highlight{
                color:#a0816c
            }
            .contact-link{
                margin-right:10px;
                border:1px solid #a0816c;
                border-radius:5px;
                padding:5px;
                width:35.6px;
                display:flex;
                justify-content:center
            }
            .contact-link:hover{
                background-color:var(--bg-color)
            }
            hr.my-0{
                margin-top:0;
                margin-bottom:10px
            }

            @media (max-width: 992px){
                .cat-card{
                    position:static
                }
            }
            .content.mb-2 h2 {
                margin-top: -30px;
            }
        </style>
    </head>

    <body>
        <!-- Header -->
        <header class="header">
            <div class="header_title">
                Free shipping with orders from&nbsp;<strong>200,000 VND</strong>
            </div>

            <div class="headerContent">
                <!-- Logo -->
                <div class="logo">
                    <a href="${pageContext.request.contextPath}/productList">GIO</a>
                </div>

                <!-- Nav -->
                <nav>
                    <ul class="headerList">
                        <li class="headerListItem">
                            <a href="${pageContext.request.contextPath}/productList">Home page</a>
                        </li>

                        <li class="headerListItem">
                            <a href="${pageContext.request.contextPath}/productList/male">
                                Men's Fashion <i class="bi bi-caret-down dropdown-icon"></i>
                            </a>
                            <ul class="dropdownMenu">
                                <li><a href="${pageContext.request.contextPath}/productList/male/t_shirt">T-shirt</a></li>
                                <li><a href="${pageContext.request.contextPath}/productList/male/pant">Long pants</a></li>
                                <li><a href="${pageContext.request.contextPath}/productList/male/short">Shorts</a></li>
                            </ul>
                        </li>

                        <li class="headerListItem">
                            <a href="${pageContext.request.contextPath}/productList/female">
                                Women's Fashion <i class="bi bi-caret-down dropdown-icon"></i>
                            </a>
                            <ul class="dropdownMenu">
                                <li><a href="${pageContext.request.contextPath}/productList/female/t_shirt">T-shirt</a></li>
                                <li><a href="${pageContext.request.contextPath}/productList/female/pant">Long pants</a></li>
                                <li><a href="${pageContext.request.contextPath}/productList/female/dress">Dress</a></li>
                            </ul>
                        </li>

                        <li class="headerListItem">
                            <a href="${pageContext.request.contextPath}/aboutUs.jsp">
                                Information <i class="bi bi-caret-down dropdown-icon"></i>
                            </a>
                            <ul class="dropdownMenu">
                                <li><a href="${pageContext.request.contextPath}/aboutUs.jsp">About Us</a></li>
                                <li><a href="${pageContext.request.contextPath}/contact.jsp">Contact</a></li>
                                <li><a href="${pageContext.request.contextPath}/policy.jsp">Exchange policy</a></li>
                            </ul>
                        </li>
                    </ul>
                </nav>

                <!-- Tools -->
                <div class="headerTool">
                    <div class="headerToolIcon">
                        <i class="bi bi-search icon" onclick="toggleBox('box1')"></i>
                        <div class="searchBox box" id="box1">
                            <div class="searchBox-content">
                                <h2>SEARCH</h2>
                                <div class="search-input">
                                    <input oninput="searchByName(this)" name="search" type="text" placeholder="Search for products...">
                                    <button type="button"><i class="bi bi-search"></i></button>
                                </div>
                                <div class="search-list">
                                    <div class="search-list" id="search-ajax"></div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="headerToolIcon">
                        <a href="${pageContext.request.contextPath}/profile"><i class="bi bi-person icon"></i></a>
                    </div>
                    <div class="headerToolIcon">
                        <a href="${pageContext.request.contextPath}/loadCart"><i class="bi bi-cart2 icon"></i></a>
                    </div>
                </div>
            </div>

            <hr/>
        </header>

        <!-- CONTENT -->
        <div class="container py-4" id="page-wrap">
            <div class="row g-3">
                <!-- LEFT: Orders -->
                <div class="col-lg-9 order-box-content">
                    <div class="content mb-2">
                        <h2 id="highlight"><b>List of orders</b></h2>
                    </div>

                    <c:choose>
                        <c:when test="${empty ordersUserList}">
                            <div class="alert alert-info">You have no orders yet.</div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${ordersUserList}" var="o">
                                <!-- Chỉ hiển thị Pending & Delivering -->
                                <c:if test="${o.status ne 'Delivered' && o.status ne 'Cancelled'}">
                                    <div class="user-info" id="user${o.orderID}">
                                        <!-- Header đơn -->
                                        <div id="header-order" class="row">
                                            <div class="col-12 col-md-3 mb-1 mb-md-0"><p>ID: <b>${o.orderID}</b></p></div>
                                            <div class="col-12 col-md-5 mb-1 mb-md-0"><p>Date: <b>${o.date}</b></p></div>
                                            <div class="col-12 col-md-2 mb-1 mb-md-0" id="status">
                                                <span class="status-pill status-${o.status}">${o.status}</span>
                                            </div>
                                            <div class="col-12 col-md-2 text-end">
                                                <button class="detail-btn" type="button" id="btn-${o.orderID}" onclick="toggleDetails(${o.orderID})">
                                                    Detail <i class="bi bi-chevron-down" id="ic-${o.orderID}"></i>
                                                </button>
                                            </div>
                                        </div>

                                        <!-- Chi tiết sản phẩm -->
                                        <div class="dropdown-container mt-2" id="dd-${o.orderID}">
                                            <c:set var="hasItem" value="false"/>
                                            <c:forEach items="${orderDetailList}" var="d">
                                                <c:if test="${d.orderID eq o.orderID}">
                                                    <c:set var="hasItem" value="true"/>

                                                    <%-- Lấy % promo của sản phẩm một cách an toàn --%>
                                                    <c:set var="pId" value="${d.productID}"/>
                                                    <c:set var="pPrice" value="${priceP[pId]}"/>
                                                    <c:set var="pPromoId" value="${promoID[pId]}"/>
                                                    <c:set var="pPromoPct" value="${promoMap[pPromoId] != null ? promoMap[pPromoId] : 0}"/>

                                                    <%-- Tính đơn giá đã giảm theo promo của SẢN PHẨM --%>
                                                    <c:set var="unitDisc" value="${pPrice - (pPrice * pPromoPct)/100}"/>
                                                    <c:set var="lineDisc" value="${unitDisc * d.quantity}"/>
                                                    <c:set var="lineOrig" value="${pPrice * d.quantity}"/>

                                                    <div id="mid-order" class="row">
                                                        <div id="product" class="col-3 col-md-2"><img src="${picUrlMap[d.productID]}" alt=""></div>
                                                        <div class="col-9 col-md-6">
                                                            <h6 id="proName"><b>${nameProduct[d.productID]}</b></h6>
                                                            <p>Size: ${d.size_name}</p>
                                                            <p>Quantity: ${d.quantity}</p>
                                                        </div>
                                                        <div class="col-12 col-md-4">
                                                            <div id="price">
                                                                <div class="row">
                                                                    <p class="col-6 origin-price">
                                                                        <fmt:formatNumber value="${lineOrig}" type="number"/> VND
                                                                    </p>
                                                                    <p class="col-6 saled-price">
                                                                        <fmt:formatNumber value="${lineDisc}" type="number"/> VND
                                                                    </p>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <hr class="hr">
                                                </c:if>
                                            </c:forEach>
                                            <c:if test="${hasItem eq false}">
                                                <div class="text-muted py-2">No order items found.</div>
                                            </c:if>
                                        </div>

                                        <!-- Footer đơn -->
                                        <div class="info">
                                            <div id="product-bottom" class="row align-items-center">
                                                <div class="col-12 col-md-3"><p>Items: <b>${totalQuantityMap[o.orderID]}</b></p></div>
                                                <div class="col-12 col-md-5"><p>Ship to: <b>${o.address}</b></p></div>
                                                <div class="col-12 col-md-2">
                                                    <%-- TOTAL: sử dụng o.total đã lưu (đã gồm ship + freeship + order-promo) --%>
                                                    <c:set var="formattedTotal"><fmt:formatNumber value="${o.total}" type="number"/></c:set>
                                                    <p>Total: <span><b>${formattedTotal} VND</b></span></p>
                                                </div>
                                                <div class="col-12 col-md-2 text-end" style="margin:5px 0">
                                                    <c:if test="${o.status eq 'Delivering'}">
                                                        <button class="feedback-btn" onclick="markDelivered(${o.orderID})">Order Received</button>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:if>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- RIGHT: Page category -->
                <div class="col-lg-3">
                    <aside class="cat-card">
                        <h5 class="cat-title"><b>Page category</b></h5>
                        <a class="cat-link" href="${pageContext.request.contextPath}/contact.jsp">Contact</a>
                        <a class="cat-link" href="${pageContext.request.contextPath}/policy.jsp">Exchange policy</a>
                        <a class="cat-link" href="${pageContext.request.contextPath}/orderHistoryView">Order's history</a>
                    </aside>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <footer class="mt-4">
            <div class="content-footer">
                <h3 id="highlight">Follow us on Instagram</h3>
                <p>@dotai.vn & @fired.vn</p>
            </div>

            <div class="row g-0" id="img-footer">
                <img class="col-md-2" src="https://theme.hstatic.net/1000296747/1000891809/14/gallery_item_1_img.jpg?v=55" alt="">
                <img class="col-md-2" src="https://theme.hstatic.net/1000296747/1000891809/14/gallery_item_2_img.jpg?v=55" alt="">
                <img class="col-md-2" src="https://theme.hstatic.net/1000296747/1000891809/14/gallery_item_3_img.jpg?v=55" alt="">
                <img class="col-md-2" src="https://theme.hstatic.net/1000296747/1000891809/14/gallery_item_4_img.jpg?v=55" alt="">
                <img class="col-md-2" src="https://theme.hstatic.net/1000296747/1000891809/14/gallery_item_5_img.jpg?v=55" alt="">
                <img class="col-md-2" src="https://theme.hstatic.net/1000296747/1000891809/14/gallery_item_6_img.jpg?v=55" alt="">
            </div>

            <div class="items-footer">
                <div class="row">
                    <div class="col-sm-3">
                        <h4 id="highlight">About GIO</h4>
                        <p>Vintage and basic wardrobe for boys and girls.Vintage and basic wardrobe for boys and girls.</p>
                        <img src="//theme.hstatic.net/1000296747/1000891809/14/footer_logobct_img.png?v=55" alt="..." class="bct">
                    </div>
                    <div class="col-sm-3">
                        <h4 id="highlight">Contact</h4>
                        <p><b>Address:</b> 100 Nguyen Van Cu, An Khanh Ward, Ninh Kieu District, City. Can Tho</p>
                        <p><b>Phone:</b> 0123.456.789 - 0999.999.999</p>
                        <p><b>Email:</b> info@dotai.vn</p>
                    </div>
                    <div class="col-sm-3">
                        <h4 id="highlight">Customer support</h4>
                        <ul class="CS">
                            <li><a href="#">Search</a></li>
                            <li><a href="#">Introduce</a></li>
                        </ul>
                    </div>
                    <div class="col-sm-3">
                        <h4 id="highlight">Customer care</h4>
                        <div class="row phone">
                            <div class="col-sm-3"><i class="bi bi-telephone icon"></i></div>
                            <div class="col-9">
                                <h4 id="highlight">0123.456.789</h4>
                                <a href="#">info@dotai.vn</a>
                            </div>
                        </div>
                        <h5 id="highlight">Follow Us</h5>
                        <div class="contact-item">
                            <a href="#" class="contact-link"><i class="bi bi-facebook contact-icon"></i></a>
                            <a href="#" class="contact-link"><i class="bi bi-instagram contact-icon"></i></a>
                        </div>
                    </div>
                </div>
            </div>
        </footer>

        <!-- Scripts -->
        <script src="${pageContext.request.contextPath}/js/jquery-3.7.0.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery.validate.min.js"></script>
        <script>
                                                            const BASE = '${pageContext.request.contextPath}';

                                                            function toggleBox(id) {
                                                                const el = document.getElementById(id);
                                                                if (!el)
                                                                    return;
                                                                el.style.display = (el.style.display === 'block') ? 'none' : 'block';
                                                            }

                                                            function toggleDetails(orderId) {
                                                                const box = document.getElementById('dd-' + orderId);
                                                                const btn = document.getElementById('btn-' + orderId);
                                                                if (!box || !btn)
                                                                    return;
                                                                const show = (box.style.display !== 'block');
                                                                box.style.display = show ? 'block' : 'none';
                                                                btn.innerHTML = show ? 'Shorten <i class="bi bi-chevron-up"></i>'
                                                                        : 'Detail <i class="bi bi-chevron-down"></i>';
                                                            }

                                                            function markDelivered(orderId) {
                                                                $.ajax({
                                                                    url: BASE + '/orderHistoryView',
                                                                    method: 'GET',
                                                                    data: {orderId: orderId, status: 'Delivered'},
                                                                    success: function () {
                                                                        window.location.href = BASE + '/orderHistoryView';
                                                                    },
                                                                    error: function (xhr) {
                                                                        alert('Update failed: ' + (xhr.status || '') + ' ' + (xhr.statusText || ''));
                                                                    }
                                                                });
                                                            }
        </script>
    </body>
</html>
