

<%@page import="java.text.NumberFormat"%>
<%@page import="java.text.DecimalFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>

<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-iYQeCzEYFbKjA/T2uDLTpkwGzCiq6soy8tYaI1GyVh/UjpbCx/TYkiZhlZB6+fzT" crossorigin="anonymous">
        <!-- bootstrap -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <!-- bootstrap icon -->
        <link rel="stylesheet" href="/css/style copy.css">
        <!-- <link rel="stylesheet" href="grid.css"> -->
        <link href='https://fonts.googleapis.com/css?family=Quicksand' rel='stylesheet'> <!-- font family -->
        <link rel="icon" href="/Project_SWP391_Group4/images/LG1.png" type="image/x-icon">

        <title>GIO</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                font-family: 'Quicksand', sans-serif;
                box-sizing: border-box;
                color: rgb(151, 143, 137);

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
                box-shadow: inset 0 0 6px rgba(0, 0, 0, 0.3);
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

            .headerContent,
            .headerList,
            .headerTool {
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

            /* hiệu ứng hover */
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
                box-shadow: rgba(0, 0, 0, 0.35) 0px 5px 15px;
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
                width: fit-content;
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
                box-shadow: rgba(0, 0, 0, 0.35) 0px 5px 15px;
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
                box-shadow: rgba(0, 0, 0, 0.35) 0px 5px 15px;
                display: none;
            }

            .infoBox-content,
            .cartBox-content,
            .searchBox-content {
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
                box-shadow: rgba(0, 0, 0, 0.35) 0px 5px 15px;
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

            .sumPrice .tbTextLeft,
            .tbTextRight {
                padding: 10px 0;
            }

            .sumPrice .tbTextRight,
            span {
                text-align: right;
                color: red;
                font-weight: bold;
            }

            .miniCartButton {
                width: 100%;
                border-radius: 2px;
                width: 100%;
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

            /* main content */
            .main {
                max-width: 1200px;
                margin: 30px auto 50px;
            }

            .mainContent {
                max-width: 100%;
            }

            .mainHeading {
                text-align: center;
                margin-bottom: 30px;
            }

            .headingContent a {
                text-decoration: none;
                color: var(--text-color);
                font-weight: bold;
                box-sizing: border-box;
            }

            .productImg img {
                width: 100%;
            }

            .productDetail {
                padding: 15px 12px 15px;
                background-color: rgba(255, 255, 255, 0.83);
                position: relative;
                transition: 0.3s;
            }

            .productDetail h3 {
                font-size: 15px;
                color: black;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

            .productDetail p {
                margin: 0;
            }

            .price {
                font-weight: bold;
                color: black;
            }

            .productButton {
                transition: 0.3s;
                color: white;
                width: 90%;
                display: flex;
                text-align: center;
                padding: 5px;
                position: absolute;
                display: none;
                transform: translateY(20%);
                background-color: var(--bg-color);
                border-radius: 4px;
                justify-content: center;
                line-height: 2;
            }

            .productDetail:hover .productButton {
                display: flex;
            }

            .productDetail:hover {
                transform: translateY(-50%);
            }

            .productButton * {
                width: 50%;
            }

            .productButton .right {
                background: white;
                position: relative;
                color: white;
                background: transparent;
                border-radius: 4px;
                overflow: hidden;
                border: none;
                font-weight: bold;
            }

            .addBtn {
                border: none;
                background-color: var(--bg-color);
                border-radius: 4px;
            }

            .addBtn span {
                color: white;
            }

            .productButton .right:hover {
                color: #a0816c;
            }

            .right span {
                background-color: white;
                height: 100%;
                width: 0;
                position: absolute;
                left: 0;
                bottom: 0;
                transition: 0.4s;
                z-index: -1;
            }

            .productButton .right:hover span {
                width: 100%;
            }

            /* END main content */

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

            /* END footer */

            @media (max-width: 768px) and (min-width: 601px) {
                .headerListItem {
                    font-size: 12px;
                    height: 18px;
                }

                .headerListItem:hover {
                    font-size: 13px;
                }

                .dropdown-icon {
                    height: 18px;
                }

                .productDetail h3 {
                    height: 50px;
                }
            }
            @media (max-width: 1024px) {
                .infoBox,
                .searchBox, .cartBox {
                    right: 0;
                }
            }
        </style>
        ${ms}
    </head>

    <body>
        <!-- header -->
        <header class="header">
            <div class="header_title">Free shipping with orders from&nbsp;<strong>200,000 VND </strong></div>
            <div class="headerContent">
                <div class="logo"><a href="/headerDemo.html">GIO</a></div>
                <nav>
                    <ul class="headerList">
                        <li class="headerListItem"><a href="/headerDemo.html">Home page ${id}</a></li>
                        <li class="headerListItem">
                            <a href="">Men's Fashion<i class="bi bi-caret-down dropdown-icon"></i></a>
                            <ul class="dropdownMenu">
                                <li><a href="">T-shirt</a></li>
                                <li><a href="">Shirt</a></li>
                                <li><a href="">Jackets, sweatshirts, sweaters</a></li>
                                <li><a href="">Long pants</a></li>
                                <li><a href="">Shorts</a></li>
                                <li><a href="">Discount</a></li>
                            </ul>
                        </li>
                        <li class="headerListItem">
                            <a href="">Women's Fashion<i class="bi bi-caret-down dropdown-icon"></i></a>
                            <ul class="dropdownMenu">
                                <li><a href="">T-shirt</a></li>
                                <li><a href="">Shirt</a></li>
                                <li><a href="">Jackets, sweatshirts, sweaters</a></li>
                                <li><a href="">Long pants</a></li>
                                <li><a href="">Skirt</a></li>
                                <li><a href="">Dress</a></li>
                                <li><a href="">Discount</a></li>
                            </ul>
                        </li>
                        <li class="headerListItem"><a href="">Accessory</a></li>
                        <li class="headerListItem">
                            <a href="">Information<i class="bi bi-caret-down dropdown-icon"></i></a>
                            <ul class="dropdownMenu">
                                <li><a href="/Project_SWP391_Group4/aboutUs.jsp">About Us</a></li>

                                <li><a href="/Project_SWP391_Group4/contact.jsp">Contact</a></li>
                               
                                <li><a href="/Project_SWP391_Group4/policy.jsp">Exchange policy</a></li>
                            
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
                                    <input oninput="searchByName(this)" name="search" type="text" size="20" placeholder="Search for products...">
                                    <button><i class="bi bi-search"></i></button>
                                </div>
                                <div class="search-list">
                                    <div class="search-list" id="search-ajax">
                                        <c:forEach items="${requestScope.productList}" var="product">

                                        </c:forEach>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="headerToolIcon">
                        <a href="http://localhost:8080/Project_SWP391_Group4/profile"><i class="bi bi-person icon"></i></a>
                        <!-- khi chưa login thì khi nhấp vào sẽ chuyển tới trang login /ps: tui khum bít làm :< -->     
                    </div>
                    <div class="infoBox box" id="box2">
                        <div class="infoBox-content">
                            <h2>ACCOUNT INFORMATION</h2>
                            <ul class="infoBox-list">
                                <li>Username</li>
                                <li><i class="infoBox-icon bi bi-dot"></i><a href="/login.html">My account</a></li>
                                <li><i class="infoBox-icon bi bi-dot"></i><a href="">Address</a></li>
                                <li><i class="infoBox-icon bi bi-dot"></i><a href="">Log out</a></li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="headerToolIcon">
                    <i class="bi bi-cart2 icon" onclick="toggleBox('box3')"></i>
                    <div class="cartBox box" id="box3">
                        <div class="cartBox-content">
                            <h2>SHOPPING CART</h2>
                            <div class="noneProduct">
                                <div class="cartIcon"><i class="bi bi-cart2 icon"></i></div>
                                <p>There are currently no products</p>
                            </div>
                            <!-- nếu có product thì haveProduct display: block -->
                            <div class="haveProduct">
                                <div class="container">
                                    <div class="row">
                                        <div class="col-md-4 miniCartImg">
                                            <img src="images/img1.jpg" alt="">
                                        </div>
                                        <div class="col-md-8 miniCartDetail">
                                            <p>GIO - Áo thun wash Cafe Clementine 8122
                                                <span>Color / size</span>
                                            </p>
                                            <div class="miniCart-quan">
                                                <span>1</span>
                                            </div>
                                            <div class="miniCart-price">
                                                <span>000,000 VND</span>
                                            </div>
                                            <div class="deleteBtn">
                                                <i class="bi bi-x-lg"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="sumPrice">
                                <table>
                                    <tr>
                                        <td class="tbTextLeft">TOTAL MONEY:</td>
                                        <td class="tbTextRight">0<span>VND</span></td>
                                    </tr>
                                    <tr class="cartButton">
                                        <td><button class="miniCartButton" onclick="redirectCartPage()">View
                                                cart</button></td>
                                        <td><button class="miniCartButton btnRight">Pay</button></td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <hr width="100%" , color="#d0a587" />
    </header>
    <!-- end header -->

    <!-- main -->
    <main class="main">
        <div class="mainHeading">
            <h2 class="headingContent">
                <a href="">GIO</a>
            </h2>
            <p>New products</p>
        </div>
        <div class="mainContent container ">
            <a href="addProduct.jsp" target="target">add</a>
            <div class="row" id="product">

                <c:forEach items="${requestScope.productList}" var="product">
                    <div class="col-md-3 p-2">
                        <div class="product">
                            <div class="productImg">
                                <img src="${product.getPicURL()}" alt="img">
                            </div>
                            <c:set var="formattedPrice">
                                <fmt:formatNumber type="number" value="${product.getPrice()}" pattern="###,###" />
                            </c:set>


                            <div class="productDetail">
                                <h3>${product.getName()}</h3>
                                <p>
                                    <span class="price">${formattedPrice} VND</span>
                                    <span class="price-sale"></span>
                                </p>
                                <div class="productButton">
                                    <button type="button" class="addBtn"><a href="productDetail?id=${product.getId()}">Add to cart</a></button>
                                    <button type="button" class="right"><a href="productBuy?name=${product.name} &price=${product.price} &quantity=1&picURL=${product.picURL} &id=${product.id}">Buy now</a></button>
                                </div>
                            </div>
                            <a href="updateJSPProduct?id=${product.getId()}">Update</a>
                            <a href="#" onclick="doDelete('${product.getId()}')">Delete</a>
                        </div>
                    </div>

                </c:forEach>

                <div class="col-md-3 p-2">
                    <div class="product">
                        <div class="productImg">
                            <img src="images/img1.jpg" alt="img">
                        </div>
                        <div class="productDetail">
                            <h3>GIO - Áo thun wash Cafe Clementine 8122</h3>
                            <p>
                                <span class="price">195,000 VND</span>
                                <span class="price-sale"></span>
                            </p>
                            <div class="productButton">
                                <button type="button" class="addBtn"><span>Add to cart</span></button>
                                <button type="button" class="right"><span></span>Buy now</button>
                            </div>
                        </div>
                        <!-- <div class="productAction">
                                <div class="action-inner">
                                    <button type="button" class="btn btn-outline-primary"><span>Add to cart</span></button>
                                    <button type="button" class="btn btn-secondary right"><span>Buy now</span></button>
                                </div>
                            </div> -->
                    </div>
                </div>
                <div class="col-md-3 p-2">
                    <div class="product">
                        <div class="productImg">
                            <img src="images/img2.jpg" alt="img">
                        </div>
                        <div class="productDetail">
                            <h3>GIO - Áo thun viền cổ WILDHEART 8121</h3>
                            <p>
                                <span class="price">190,000 VND</span>
                                <span class="price-sale"></span>
                            </p>
                            <div class="productButton">
                                <button type="button" class="addBtn"><span>Add</span></button>
                                <button type="button" class="right"><span></span>Buy now</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 p-2">
                    <div class="product">
                        <div class="productImg">
                            <img src="images/img3.jpg" alt="img">
                        </div>
                        <div class="productDetail">
                            <h3>GIO - Quần dài jeans wash 8116</h3>
                            <p>
                                <span class="price">395,000 VND</span>
                                <span class="price-sale"></span>
                            </p>
                            <div class="productButton">
                                <button type="button" class="addBtn"><span>Add to cart</span></button>
                                <button type="button" class="right"><span></span>Buy now</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 p-2">
                    <div class="product">
                        <div class="productImg">
                            <img src="images/img4.jpg" alt="img">
                        </div>
                        <div class="productDetail">
                            <h3>GIO - Áo thun tay ngắn Confitería 8115</h3>
                            <p>
                                <span class="price">195,000 VND</span>
                                <span class="price-sale"></span>
                            </p>
                            <div class="productButton">
                                <button type="button" class="addBtn"><span>Add to cart</span></button>
                                <button type="button" class="right"><span></span>Buy now</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
    <!-- end main -->

    <!-- footer -->
    <footer>
        <div class="content-footer">
            <h3 id="highlight">Follow us on Instagram</h3>
            <p>@gio.vn & @fired.vn</p>
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
    <!-- end footer -->


    <script src="./js/header.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script type="text/javascript">
                                function doDelete(id) {
                                    if (confirm("Do you want to delete this product (" + id + ")?")) {
                                        window.location = "deleteProduct?id=" + id;
                                    }
                                }


                                function searchByName(name) {
                                    var search = name.value

                                    $.ajax({
                                        url: "/Project_SWP391_Group4/searchProductByAJAX",
                                        type: "get",
                                        data: {
                                            txt: search
                                        },
                                        success: function (data) {
                                            var row = document.getElementById("product");
                                            row.innerHTML = data;
                                        },
                                        error: function (xhr) {

                                        }
                                    })
                                }
    </script>
</body>

</html>
