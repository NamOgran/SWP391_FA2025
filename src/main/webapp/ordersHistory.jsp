<%--
    Document   : ordersHistory
    Created on : Mar 13, 2024, 2:07:19 PM
    Author     : duyentq
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.text.DecimalFormat"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<fmt:setLocale value="vi_VN"/>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-iYQeCzEYFbKjA/T2uDLTpkwGzCiq6soy8tYaI1GyVh/UjpbCx/TYkiZhlZB6+fzT" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <title>Orders</title>
        <link rel="stylesheet" href="./css/viewOrder.css">
        <link href='https://fonts.googleapis.com/css?family=Quicksand' rel='stylesheet'> <link rel="icon" href="/Project_SWP391_Group4/images/LG1.png" type="image/x-icon">
        <script src="https://kit.fontawesome.com/1bd876819f.js" crossorigin="anonymous"></script>

        <style>
            /* ===== GIỮ NGUYÊN TOÀN BỘ STYLE HEADER CỦA BẠN ===== */

            * {
                margin: 0;
                padding: 0;
                font-family: 'Quicksand', sans-serif;
                box-sizing: border-box;
                color: rgb(151, 143, 137);
            }
            html, body{
                max-width:100%;
                overflow-x:hidden;
            }

            img {
                width: 100%;
            }

            :root {
                --logo-color: #a0816c;
                --nav-list-color: #a0816c;
                --icon-color: #a0816c;
                --text-color: #a0816c;
                --bg-color: #a0816c;
            }

            body::-webkit-scrollbar {
                width: 0.5em;
            }
            body::-webkit-scrollbar-track {
                box-shadow: inset 0 0 6px rgba(0,0,0,0.3);
            }
            body::-webkit-scrollbar-thumb {
                border-radius: 50px;
                background-color: var(--bg-color);
                outline: 1px solid slategrey;
            }

            nav {
                height: 70px;
                justify-content: center;
                display: flex;
            }

            .header_title {
                display: flex;
                text-align: center;
                justify-content: center;
                align-items: center;
                background-color: #f5f5f5;
                font-size: 0.8125rem;
                font-weight: 500;
                height: 30px;
            }

            .headerContent {
                max-width: 1200px;
                margin: 0 auto;
            }
            .headerContent, .headerList, .headerTool {
                display: flex;
                align-items: center;
            }
            .headerContent {
                justify-content: space-around;
            }

            .logo a {
                text-decoration: none;
                color: var(--logo-color);
                font-size: 1.5em;
                font-weight: bold;
            }
            .logo a:hover {
                color: var(--logo-color);
            }

            .headerList {
                margin: 0;
                list-style-type: none;
            }

            /* hiệu ứng hover */
            .headerListItem {
                transition: font-size 0.3s ease;
                height: 24px;
            }
            .headerListItem:hover {
                font-size: 18px;
            }

            .headerListItem a {
                margin: 0 10px;
                padding: 22px 0;
                text-decoration: none;
                color: var(--text-color);
            }

            .dropdown-icon {
                margin-left: 2px;
                font-size: 0.7500em;
            }

            .dropdownMenu {
                position: absolute;
                width: 200px;
                padding: 0;
                margin-top: 17px;
                background-color: #fff;
                display: none;
                z-index: 1;
                box-shadow: rgba(0,0,0,0.35) 0px 5px 15px;
            }
            .dropdownMenu li {
                list-style-type: none;
                margin: 0;
                border-bottom: 1px solid rgb(235 202 178);
            }
            .dropdownMenu li a {
                text-decoration: none;
                padding: 5px 15px;
                margin: 0;
                display: flex;
                font-size: 0.9em;
                width: 100%;
                color: var(--text-color);
            }
            .dropdownMenu li:hover {
                background-color: #f1f1f1
            }
            .headerListItem:hover .dropdownMenu {
                display: block;
            }

            .headerTool a {
                padding: 5px;
            }
            .headerToolIcon {
                width: 45px;
                justify-content: center;
                display: flex;
            }
            .icon {
                cursor: pointer;
                font-size: 26px;
            }

            .searchBox {
                width: 420px;
                position: absolute;
                top: 100px;
                right: 13%;
                left: auto;
                z-index: 990;
                background-color: #fff;
                box-shadow: rgba(0,0,0,0.35) 0px 5px 15px;
                display: none;
            }
            .search-input {
                position: relative;
            }
            .search-input input {
                width: 100%;
                border: 1px solid #e7e7e7;
                background-color: #f6f6f6;
                height: 44px;
                padding: 8px 50px 8px 20px;
                font-size: 1em;
            }
            .search-input button {
                position: absolute;
                right: 1px;
                top: 1px;
                height: 97%;
                width: 15%;
                border: none;
                background-color: #f6f6f6;
            }
            .search-input input:focus {
                outline: none;
                border-color: var(--bg-color);
            }

            .infoBox {
                width: auto;
                min-width: 260px;
                position: absolute;
                top: 100px;
                right: 13%;
                left: auto;
                z-index: 990;
                background-color: #fff;
                box-shadow: rgba(0,0,0,0.35) 0px 5px 15px;
                display: none;
            }
            .infoBox-content, .cartBox-content, .searchBox-content {
                width: 100%;
                height: 100%;
                max-height: 100%;
                overflow: hidden;
                padding: 9px 20px 20px;
            }

            .headerToolIcon h2 {
                font-size: 1.3em;
                text-align: center;
                padding-bottom: 9px;
                color: var(--text-color);
                border-bottom: 1px solid #e7e7e7;
            }

            .infoBox-content ul {
                padding: 0;
                margin: 0;
            }
            .infoBox-content ul li {
                list-style-type: none;
            }
            .infoBox-content ul li:first-child {
                color: black;
                padding-left: 7px;
            }

            .infoBox-list li a {
                text-decoration: none;
                font-size: 14px;
                color: black;
                padding: 0;
            }
            .infoBox-list li a:hover {
                color: var(--text-color);
            }
            .bi-dot {
                color: black;
            }

            .cartBox {
                width: 340px;
                position: absolute;
                top: 100px;
                right: 13%;
                left: auto;
                z-index: 990;
                background-color: #fff;
                box-shadow: rgba(0,0,0,0.35) 0px 5px 15px;
                display: none;
            }

            .noneProduct {
                padding: 0 0 10px;
            }
            .shopping-cart-icon {
                margin: 0 auto 7px;
                display: block;
                width: 15%;
                height: 15%;
            }
            .product {
                margin-top: 50px;
            }
            .cartIcon {
                justify-content: center;
                display: flex;
            }
            .cartIcon i {
                font-size: 2.5em;
            }
            .noneProduct p {
                text-align: center;
                font-size: 14px;
                margin: 0;
            }
            .haveProduct {
                margin-bottom: 8px;
                display: none;
            }
            .bi-x-lg {
                cursor: pointer;
            }
            .miniCartImg {
                padding-left: 0;
            }
            .miniCartDetail {
                padding-right: 0;
                position: relative;
            }
            .miniCartDetail p {
                font-size: 0.8em;
                color: black;
                font-weight: bold;
                padding-right: 20px;
            }
            .miniCartDetail p span {
                display: block;
                text-align: left;
                color: #677279;
                font-weight: normal;
                font-size: 12px;
            }
            .miniCart-quan span {
                float: left;
                width: auto;
                color: black;
                margin-right: 12px;
                padding: 6px 12px;
                text-align: center;
                line-height: 1;
                font-weight: normal;
                font-size: 13px;
                background: #f7f7f7;
            }
            .miniCart-price span {
                color: #677279;
                float: left;
                font-weight: 500;
            }
            .miniCartDetail .deleteBtn {
                position: absolute;
                top: 0;
                right: 0px;
                line-height: 20px;
                text-align: center;
                width: 19px;
                height: 19px;
            }
            .miniCartDetail .deleteBtn * {
                color: black;
            }

            .sumPrice {
                border-top: 1px solid #e7e7e7;
            }
            .sumPrice table {
                width: 100%;
            }
            .sumPrice td {
                width: 50%;
            }
            .sumPrice .tbTextLeft, .tbTextRight {
                padding: 10px 0;
            }
            .sumPrice .tbTextRight, span {
                text-align: right;
                color: red;
                font-weight: bold;
            }

            .miniCartButton {
                width: 100%;
                border-radius: 2px;
                background-color: var(--bg-color);
                border: none;
                color: white;
                font-size: 13px;
                height: 30px;
                font-weight: bold;
            }
            .cartButton td:first-child {
                padding-right: 5px;
            }
            .cartButton td:last-child {
                padding-left: 5px;
            }
            .cartButton .btnRight {
                transition: 0.3s;
            }
            .cartButton .btnRight:hover {
                background-color: white;
                border: 1px solid var(--bg-color);
                color: var(--text-color);
                transition: 0.3s;
            }

            /* end header */
            hr {
                margin-top: 0;
                margin-bottom: 10px;
            }

            /* ====== BỔ SUNG NHẸ CHO PHẦN CARD/STATUS/TOTAL (không đụng header) ====== */
            .user-info{
                border:1px solid #eee;
                border-radius:.5rem;
                padding:1rem;
                margin-bottom:1rem;
                background:#fff;
            }
            #header-order{
                align-items:center;
            }
            .hr{
                margin:.75rem 0;
            }

            .status-pill{
                display:inline-block;
                padding:.25rem .6rem;
                border-radius:999px;
                background:#f5f5f5;
                font-weight:600;
                font-size:.9rem;
            }
            .status-Delivered{
                color:#0666cc;
            }

            /* canh phải và cố định một dòng cho Total */
            #product-bottom .col-4 p{
                text-align:right;
                white-space:nowrap;
                margin-bottom:0;
            }

            /* Khung Page category giống View */
            .page{
                border:1px solid #eee;
                border-radius:.5rem;
                padding:1rem;
                background:#fff;
                position:sticky;
                top:96px;
            }

            /* giá gốc & giá sale cho đẹp */
            .origin-price{
                opacity:.6;
                text-decoration:line-through;
            }
            .saled-price{
                font-weight:700;
                color:#d33;
            }

            /* ===== ADDED: CSS FOR STAR RATING ===== */
            .star-rating {
                display: flex;
                flex-direction: row-reverse;
                justify-content: flex-end;
                font-size: 2em;
                cursor: pointer;
            }
            .star-rating input[type="radio"] {
                display: none;
            }
            .star-rating label {
                color: #ccc;
                padding: 0 5px;
                transition: color 0.2s;
            }

            .star-rating:not(:hover) input[type="radio"]:checked ~ label,
            .star-rating:hover label {
                color: #ffc107;
            }

            .star-rating:hover label:hover ~ label {
                color: #ccc;
            }

            .star-rating input[type="radio"]:checked ~ label {
                color: #ffc107;
            }

            footer .content-footer{
                text-align:center;
                padding: 36px 16px 20px;
            }
            footer .content-footer h3{
                font-size: 36px;
                font-weight: 700;
                letter-spacing: .2px;
                margin: 0 0 6px;
                color: #a0816c;
            }
            footer .content-footer p{
                margin: 0;
                font-size: 18px;
                opacity: .85;
            }


            #img-footer{
                margin: 0 !important;
            }
            #img-footer img{
                padding: 0 !important;
                display: block;
                height: 240px;
                object-fit: cover;
            }


            footer .items-footer{
                background: #f0eeec;
                padding: 44px 28px;
            }

            footer .items-footer .row{
                max-width: 1200px;
                margin: 0 auto;
                row-gap: 28px;
            }

            footer h4#highlight{
                color:#a0816c;
                font-size: 28px;
                font-weight: 700;
                margin-bottom: 12px;
            }

            footer p, footer li, footer a{
                color:#7b746f;
                font-size: 16px;
                line-height: 1.6;
                margin-bottom: .35rem;
            }


            footer .phone i{
                font-size: 28px;
            }
            footer .phone h4#highlight{
                font-size: 28px;
                margin: 0;
            }


            footer .contact-item{
                display: flex;
                align-items: center;
                gap: 10px;
                margin-top: 10px;
            }
            footer .contact-link{
                display:flex;
                align-items:center;
                justify-content:center;
                width: 36px;
                height: 36px;
                border: 1px solid #a0816c;
                border-radius: 6px;
                text-decoration: none;
            }
            footer .contact-link:hover{
                background:#a0816c;
            }
            footer .contact-link:hover .contact-icon{
                color:#fff;
            }
            footer .contact-icon{
                font-size: 18px;
                color:#a0816c;
            }


            footer .bct{
                width: 120px;
                margin-top: 10px;
                display:block;
            }


            @media (max-width: 768px){
                #img-footer img{
                    height: 180px;
                }
                footer .items-footer{
                    padding: 28px 16px;
                }
                footer .content-footer h3{
                    font-size: 28px;
                }
            }
            .order-box-content .content{
                margin-top: -35px;
            }
        </style>
    </head>

    <body>
        <header class="header">
            <div class="header_title">Free shipping with orders from&nbsp;<strong>200,000 VND</strong></div>

            <div class="headerContent">
                <div class="logo"><a href="/Project_SWP391_Group4/productList">GIO</a></div>

                <nav>
                    <ul class="headerList">
                        <li class="headerListItem"><a href="/Project_SWP391_Group4/productList">Home page</a></li>

                        <li class="headerListItem">
                            <a href="/Project_SWP391_Group4/productList/male">Men's Fashion
                                <i class="bi bi-caret-down dropdown-icon"></i></a>
                            <ul class="dropdownMenu">
                                <li><a href="/Project_SWP391_Group4/productList/male/t_shirt">T-shirt</a></li>
                                <li><a href="/Project_SWP391_Group4/productList/male/pant">Long pants</a></li>
                                <li><a href="/Project_SWP391_Group4/productList/male/short">Shorts</a></li>
                            </ul>
                        </li>

                        <li class="headerListItem">
                            <a href="/Project_SWP391_Group4/productList/female">Women's Fashion
                                <i class="bi bi-caret-down dropdown-icon"></i></a>
                            <ul class="dropdownMenu">
                                <li><a href="/Project_SWP391_Group4/productList/female/t_shirt">T-shirt</a></li>
                                <li><a href="/Project_SWP391_Group4/productList/female/pant">Long pants</a></li>
                                <li><a href="/Project_SWP391_Group4/productList/female/dress">Dress</a></li>
                            </ul>
                        </li>

                        <li class="headerListItem">
                            <a href="/Project_SWP391_Group4/aboutUs.jsp">Information
                                <i class="bi bi-caret-down dropdown-icon"></i></a>
                            <ul class="dropdownMenu">
                                <li><a href="/Project_SWP391_Group4/aboutUs.jsp">About Us</a></li>
                                <li><a href="/Project_SWP391_Group4/contact.jsp">Contact</a></li>
                                <li><a href="/Project_SWP391_Group4/policy.jsp">Exchange policy</a></li>
                            </ul>
                        </li>
                    </ul>
                </nav>

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
                                <div class="search-list" id="search-ajax"></div>
                            </div>
                        </div>
                    </div>

                    <div class="headerToolIcon">
                        <a href="/Project_SWP391_Group4/profile"><i class="bi bi-person icon"></i></a>
                    </div>
                    <div class="headerToolIcon">
                        <a href="/Project_SWP391_Group4/loadCart"><i class="bi bi-cart2 icon"></i></a>
                    </div>
                </div>
            </div>

            <hr />
        </header>

        <div class="mid">
            <div class="row">
                <div class="col-md-9 order-box-content">
                    <div class="content">
                        <h2 id="highlight"><b>List of order history</b></h2>
                    </div>

                    <c:forEach items="${requestScope.ordersUserList}" var="ordersUser">
                        <c:if test="${ordersUser.status eq 'Delivered' && ordersUser.status ne 'Cancelled'}">
                            <div class="user-info">
                                <div id="header-order" class="row">
                                    <div class="col-3"><p>ID: ${ordersUser.orderID}</p></div>
                                    <div class="col-5"><p>Date: ${ordersUser.date}</p></div>
                                    <div class="col-3" id="status">
                                        <span class="status-pill status-${ordersUser.status}">${ordersUser.status}</span>
                                    </div>
                                    <div class="col-1">
                                        <div class="dropdown">
                                            <div class="edit-info-btn">
                                                <button><i class="fa-regular fa-pen-to-square"></i></button>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="dropdown-container">
                                    <c:forEach items="${requestScope.orderDetailList}" var="orderDetail">
                                        <c:if test="${ordersUser.orderID eq orderDetail.orderID}">
                                            <div id="mid-order" class="row">
                                                <div id="product" class="col-2">
                                                    <img src="${picUrlMap[orderDetail.productID]}" alt="">
                                                </div>
                                                <div class="col-6">
                                                    <h6 id="proName"><b>${nameProduct[orderDetail.productID]}</b></h6>
                                                    <p>Size: ${orderDetail.size_name}</p>
                                                    <p>Quantity: ${orderDetail.quantity}</p>
                                                </div>
                                                <div class="col-4">
                                                    <div id="price">
                                                        <div class="row">
                                                            <c:set var="formattedPrice">
                                                                <fmt:formatNumber type="number"
                                                                                  value="${(priceP[orderDetail.productID] - (priceP[orderDetail.productID] * promoMap[promoID[orderDetail.productID]])/100) * orderDetail.quantity}"
                                                                                  pattern="###,###"/>
                                                            </c:set>
                                                            <c:set var="formattedPrice2">
                                                                <fmt:formatNumber type="number"
                                                                                  value="${priceP[orderDetail.productID] * orderDetail.quantity}"
                                                                                  pattern="###,###"/>
                                                            </c:set>
                                                            <p class="col-md-6 origin-price">${formattedPrice2} VND</p>
                                                            <p class="col-md-6 saled-price">${formattedPrice} VND</p>
                                                        </div>
                                                    </div>

                                                    <div class="feedback">
                                                        <button class="feedback-btn" 
                                                                data-bs-toggle="modal" 
                                                                data-bs-target="#feedbackModal"
                                                                data-product-id="${orderDetail.productID}"
                                                                data-order-id="${ordersUser.orderID}">
                                                            Feedback
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                </div>

                                <div class="info">
                                    <hr class="hr">
                                    <div id="product-bottom" class="row">
                                        <div class="col-3"><p>Quantity: ${totalQuantityMap[ordersUser.orderID]}</p></div>
                                        <div class="col-5"><p>Address: ${ordersUser.address}</p></div>
                                        <div class="col-4">
                                            <p id="total">
                                                Total:
                                                <span>
                                                    <fmt:formatNumber value="${ordersUser.total}" type="number" maxFractionDigits="0"/> VND
                                                </span>
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>

                <div class="col-md-3">
                    <div class="page">
                        <h5 id="highlight"><b>Page category</b></h5>
                        <hr>
                        <h6><a href="/Project_SWP391_Group4/contact.jsp">Contact</a></h6>
                        <hr>
                        <h6><a href="/Project_SWP391_Group4/policy.jsp">Exchange policy</a></h6>
                        <hr>
                        <h6><a href="/Project_SWP391_Group4/orderView">List of orders</a></h6>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="feedbackModal" tabindex="-1" aria-labelledby="feedbackModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="feedbackModalLabel" style="color: #333;">Đánh giá sản phẩm</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form id="feedbackForm">
                            <input type="hidden" id="modal_product_id" name="productId">
                            <input type="hidden" id="modal_order_id" name="orderId">

                            <div class="form-group mb-3">
                                <label style="color: #555;">Chất lượng sản phẩm:</label>
                                <div class="star-rating">
                                    <input type="radio" id="star5" name="rating" value="5"><label for="star5" class="fas fa-star"></label>
                                    <input type="radio" id="star4" name="rating" value="4"><label for="star4" class="fas fa-star"></label>
                                    <input type="radio" id="star3" name="rating" value="3"><label for="star3" class="fas fa-star"></label>
                                    <input type="radio" id="star2" name="rating" value="2"><label for="star2" class="fas fa-star"></label>
                                    <input type="radio" id="star1" name="rating" value="1" required><label for="star1" class="fas fa-star"></label>
                                </div>
                            </div>

                            <div class="form-group mb-3">
                                <label for="comment" style="color: #555;">Bình luận của bạn:</label>
                                <textarea id="comment" name="comment" class="form-control" rows="3" style="color: #333;"></textarea>
                            </div>

                            <div id="feedbackMessage" class="mt-2"></div> </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="button" id="submitFeedbackBtn" class="btn btn-primary" style="background-color: #a0816c; border-color: #a0816c; color: white;">Gửi đánh giá</button>
                    </div>
                </div>
            </div>
        </div>
        <footer>
            <div class="content-footer">
                <h3 id="highlight">Follow us on Instagram</h3>
                <p>@GIO.vn & @fired.vn</p>
            </div>

            <div class="row" id="img-footer">
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
                        <p><b>Email:</b> info@GIO.vn</p>
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
                                <a href="">info@GGIO.vn</a>
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
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>

        <script src="js/jquery-3.7.0.min.js"></script>
        <script src="js/jquery.validate.min.js"></script>
        <script>
                            const editInfoBtn = document.querySelectorAll('.edit-info-btn');
                            const dropdownContainer = document.querySelectorAll('.dropdown-container');

                            editInfoBtn.forEach(function (edit, i) {
                                edit.addEventListener('click', function () {
                                    if (dropdownContainer[i].style.display === "none" || dropdownContainer[i].style.display === "") {
                                        dropdownContainer[i].style.display = "block";
                                    } else {
                                        dropdownContainer[i].style.display = "none";
                                    }
                                });
                            });

                            // ===== ADDED: JAVASCRIPT CHO FEEDBACK MODAL =====

                            // Lấy modal
                            const feedbackModal = document.getElementById('feedbackModal');
                            // Lấy form
                            const feedbackForm = document.getElementById('feedbackForm');
                            // Lấy nút submit trong modal
                            const submitFeedbackBtn = document.getElementById('submitFeedbackBtn');
                            // Lấy khu vực thông báo
                            const feedbackMessage = document.getElementById('feedbackMessage');

                            // 1. Khi modal được MỞ LÊN
                            feedbackModal.addEventListener('show.bs.modal', function (event) {
                                // 'event.relatedTarget' chính là cái nút "Feedback" đã được click
                                const button = event.relatedTarget;

                                // Lấy data-attributes từ nút đó
                                const productId = button.getAttribute('data-product-id');
                                const orderId = button.getAttribute('data-order-id');

                                // Điền vào các trường <input type="hidden"> trong modal
                                document.getElementById('modal_product_id').value = productId;
                                document.getElementById('modal_order_id').value = orderId;

                                // Reset form khi mở
                                feedbackForm.reset();
                                feedbackMessage.innerHTML = '';
                                submitFeedbackBtn.disabled = false; // Đảm bảo nút Gửi được bật
                            });

                            // 2. Khi nhấn nút "Gửi đánh giá" (submitFeedbackBtn)
                            submitFeedbackBtn.addEventListener('click', function () {

                                // Lấy dữ liệu từ form
                                const productId = document.getElementById('modal_product_id').value;
                                const orderId = document.getElementById('modal_order_id').value;
                                const comment = document.getElementById('comment').value;
                                const ratingInput = document.querySelector('input[name="rating"]:checked');

                                if (!ratingInput) {
                                    feedbackMessage.innerHTML = '<span style="color: red;">Vui lòng chọn số sao.</span>';
                                    return;
                                }

                                const rating = ratingInput.value;

                                const data = {
                                    productId: parseInt(productId),
                                    orderId: parseInt(orderId),
                                    rating: parseInt(rating),
                                    comment: comment
                                };

                                // Vô hiệu hóa nút Gửi để tránh click nhiều lần
                                submitFeedbackBtn.disabled = true;
                                feedbackMessage.innerHTML = '<span style="color: blue;">Đang gửi...</span>';

                                // 3. Gửi dữ liệu đến Servlet
                                fetch('${pageContext.request.contextPath}/feedback', {// Đây là URL của Servlet bạn đã tạo
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/json',
                                    },
                                    body: JSON.stringify(data)
                                })
                                        .then(response => response.json())
                                        .then(result => {
                                            if (result.status === "success") {
                                                feedbackMessage.innerHTML = '<span style="color: green;">Cảm ơn bạn đã đánh giá!</span>';
                                                // Tự động đóng modal sau 2 giây
                                                setTimeout(() => {
                                                    const modalInstance = bootstrap.Modal.getInstance(feedbackModal);
                                                    modalInstance.hide();
                                                }, 2000);
                                            } else {
                                                feedbackMessage.innerHTML = `<span style="color: red;">Lỗi: ${result.message}</span>`;
                                                submitFeedbackBtn.disabled = false; // Bật lại nút nếu lỗi
                                            }
                                        })
                                        .catch(error => {
                                            console.error('Error:', error);
                                            feedbackMessage.innerHTML = '<span style="color: red;">Lỗi kết nối.</span>';
                                            submitFeedbackBtn.disabled = false; // Bật lại nút nếu lỗi
                                        });
                            });
        </script>
    </body>
</html>
