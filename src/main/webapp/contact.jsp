<%-- 
    Document   : contact
    Created on : Mar 6, 2024, 8:32:59 PM
    Author     : thinh
--%>


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


        <title>DOTAI</title>
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
                justify-content: space-between;
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

            /* main contact */
            .main-contact {
                max-width: 1200px;
                margin: 30px auto;
            }
            .main-contact h2 {
                font-size: 1.4em;
                font-weight: bold;
                color: #b7ab8d;
                margin: 30px 0;
            }
            .contact-list {
                list-style-type: none;
                padding: 0;
            }
            .contact-list li {
                margin-bottom: 20px;
            }
            .contact-list li span {
                width: 35px;
                height: 35px;
                line-height: 35px;
                border-radius: 50%;
                float: left;
                border: 1px solid #ddd;
                text-align: center;
                font-size: 15px;
            }
            .contact-list li span i {
                color: black;
            }
            .contact-list li p {
                width: calc(100% - 35px);
                float: left;
                padding-left: 15px;
                margin-bottom: 15px;
                color: #696969;
                font-weight: 500;
                font-size: 14px;
            }
            .contact-list li p strong {
                color: black;
            }
            .contact-right p {
                font-size: 14px;
                color: #696969;
                font-weight: 500;
            }
            .input-group {
                margin-bottom: 20px;
            }
            .input-group input {
                width: 100%;
                padding: 8px 20px;
                height: 45px;
                border: 1px solid #e7e7e7;
                font-size: 14px;
            }
            .input-group input:focus {
                outline: none;
                border-color: 1px solid var(--bg-color);
            }
            .input-group textarea {
                overflow: auto;
                width: 100%;
                height: 130px;
                padding: 20px 20px;
                border: 1px solid #e7e7e7;
                resize: none;
                font-size: 14px;
            }
            .input-group textarea:focus {
                outline: none;
                border-color: 1px solid var(--bg-color);
            }
            .submit-button button {
                width: 20%;
                height: 35px;
                border: none;
                background-color: #b7ab8d;
                color: white;

            }
            /* end main contact*/

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
    </head>

    <body>
        <!-- header -->
        <header class="header">
            <div class="header_title">Free shipping with orders from&nbsp;<strong>200,000 VND </strong></div>
            <div class="headerContent">
                <div class="logo"><a href="/Project_SWP391_Group4/productList">DOTAI</a></div>
                <nav>
                    <ul class="headerList">
                        <li class="headerListItem"><a href="/Project_SWP_Group2/productList">Home page</a></li>
                        <li class="headerListItem">
                            <a href="http://localhost:8080/Project_SWP391_Group4/productList/male">Men's Fashion<i class="bi bi-caret-down dropdown-icon"></i></a>
                            <ul class="dropdownMenu">
                                <li><a href="http://localhost:8080/Project_SWP391_Group4/productList/male/t_shirt">T-shirt</a></li>

                                <li><a href="http://localhost:8080/Project_SWP391_Group4/productList/male/pant">Long pants</a></li>
                                <li><a href="http://localhost:8080/Project_SWP391_Group4/productList/male/short">Shorts</a></li>
                                <!--<li><a href="">Discount</a></li>-->
                            </ul>
                        </li>
                        <li class="headerListItem">
                            <a href="http://localhost:8080/Project_SWP391_Group4/productList/female">Women's Fashion<i class="bi bi-caret-down dropdown-icon"></i></a>
                            <ul class="dropdownMenu">
                                <li><a href="http://localhost:8080/Project_SWP391_Group4/productList/female/t_shirt">T-shirt</a></li>
                                <li><a href="http://localhost:8080/Project_SWP391_Group4/productList/female/pant">Long pants</a></li>
                                <li><a href="http://localhost:8080/Project_SWP391_Group4/productList/female/dress">Dress</a></li>
                                <!--<li><a href="">Discount</a></li>-->

                            </ul>
                        </li>
                        <!--<li class="headerListItem"><a href="">Accessory</a></li>-->
                        <li class="headerListItem">
                            <a href="/Project_SWP391_Group4/aboutUs.jsp">Information<i class="bi bi-caret-down dropdown-icon"></i></a>
                            <ul class="dropdownMenu">
                                <li><a href="/Project_SWP391_Group4/aboutUs.jsp">About Us</a></li>

                                <li><a href="/Project_SWP391_Group4/contact.jsp">Contact</a></li>
                                <li><a href="/Project_SWP391_Group4/orderView">View order</a></li>
                                <li><a href="/Project_SWP391_Group4/policy.jsp">Exchange policy</a></li>
                                <li><a href="/Project_SWP391_Group4/orderHistoryView">Order's history</a></li>
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
                    <div class="headerToolIcon">
                        <a href="/Project_SWP391_Group4/loadCart"><i class="bi bi-cart2 icon" onclick="toggleBox('box3')"></i></a>

                    </div>
                </div>
            </div>

            <hr width="100%" , color="#d0a587" />
        </header>
        <!-- end header -->

        <main>
            <div class="main-contact ">
                <div class="row">
                    <div class="col-md-5">
                        <h2>Contact Info</h2>
                        <ul class="contact-list">
                            <li>
                                <span><i class="bi bi-geo-alt-fill"></i></span>
                                <p>
                                    <strong>Address</strong> 
                                    <br>
                                    10/12D. Nguyen Trai, Cai Khe Ward, Ninh Kieu District, City. Can Tho.
                                </p>
                            </li>
                            <li>
                                <span><i class="bi bi-envelope"></i></span>
                                <p>
                                    <strong>Email</strong> 
                                    <br>
                                    info@noobita.vn
                                </p>
                            </li>
                            <li>
                                <span><i class="bi bi-telephone-fill"></i></span>
                                <p>
                                    <strong>Phone</strong> 
                                    <br>
                                    0817.637.376 - 0917.637.376
                                </p>
                            </li>
                            <li>
                                <span><i class="bi bi-clock"></i></span>
                                <p>
                                    <strong>Working time</strong> 
                                    <br>
                                    Every day of the week
                                </p>
                            </li>
                        </ul>
                    </div>
                    <div class="col-md-7 contact-right">
                        <h2>Send us your questions</h2>
                        <p>If you have any questions, you can send us a request, and we will contact you as soon as possible.</p>
                        <div>
                            <form action="">
                                <div class="row">
                                    <div class="col-sm-12">
                                        <div class="input-group">
                                            <input type="text" placeholder="Your name">
                                        </div>
                                    </div>
                                    <div class="col-sm-6">
                                        <div class="input-group">
                                            <input type="text" placeholder="Your email">
                                        </div>
                                    </div>
                                    <div class="col-sm-6">
                                        <div class="input-group">
                                            <input type="text" placeholder="Your your phone number">
                                        </div>
                                    </div>
                                    <div class="col-sm-12">
                                        <div class="input-group">
                                            <textarea placeholder="Content"></textarea>
                                        </div>
                                    </div>
                                    <div class="col-sm-12 submit-button">
                                        <button>SEND US</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <!-- footer -->
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
                        <h4 id="highlight">About Dotai</h4>
                        <p>Vintage and basic wardrobe for boys and girls.Vintage and basic wardrobe for boys and girls.</p>
                        <img src="//theme.hstatic.net/1000296747/1000891809/14/footer_logobct_img.png?v=55" alt="..."
                             class="bct">
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
                                <a href="">info@dotai.vn</a>
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


        <script type="text/javascript">
            function doDelete(id) {
                if (confirm("Do you want to delete this product (" + id + ")?")) {
                    window.location = "deleteProduct?id=" + id;
                }
            }
        </script>
    </body>

</html>
