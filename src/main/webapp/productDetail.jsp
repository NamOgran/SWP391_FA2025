<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.text.DecimalFormat"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="DAO.SizeDAO, entity.Size, entity.Product, java.util.List" %>

<%
    // Lấy product từ attribute "p" do controller set
    Product prod = (Product) request.getAttribute("p");
    int productId = (prod != null) ? prod.getId() : 0;

    SizeDAO sizeDAO = new SizeDAO();
    List<Size> sizeList = sizeDAO.getSizesByProductId(productId);

    int stockS = 0, stockM = 0, stockL = 0;
    for (Size s : sizeList) {
        if ("S".equalsIgnoreCase(s.getSize_name())) {
            stockS = s.getQuantity();
        } else if ("M".equalsIgnoreCase(s.getSize_name())) {
            stockM = s.getQuantity();
        } else if ("L".equalsIgnoreCase(s.getSize_name())) {
            stockL = s.getQuantity();
        }
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
        <link rel="icon" href="/Project_SWP391_Group4/images/LG1.png" type="image/x-icon">
        <title>Product Detail - GIO</title>

        <style>
            * {
                margin: 0;
                padding: 0;
                font-family: 'Quicksand', sans-serif;
                box-sizing: border-box;
                color: rgb(151, 143, 137);
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
            hr {
                margin-top: 0;
                margin-bottom: 10px;
            }
            img {
                width: 100%;
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
            .headerList {
                margin: 0;
                list-style-type: none;
            }
            .headerListItem {
                transition: font-size 0.3s ease;
                height: 24px;
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
                width: 100%;
                display: flex;
                font-size: 0.9em;
                color: var(--text-color);
            }
            .dropdownMenu li:hover {
                background-color: #f1f1f1;
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
                height: 42px;
                width: 15%;
                border: none;
                background-color: #f6f6f6;
            }
            .search-input input:focus {
                outline: none;
                border-color: var(--bg-color);
            }
            footer {
                background-color: #f5f5f5;
            }
            .content-footer {
                text-align: center;
                padding: 30px;
            }
            .items-footer {
                margin: 5%;
            }
            #highlight {
                color: #a0816c;
            }
            #img-footer {
                margin: 0 auto;
            }
            #img-footer img {
                padding: 0;
            }
            .phone {
                position: relative;
            }
            .bi-telephone {
                cursor: pointer;
                font-size: 3em;
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

            .product-detail-container {
                max-width: 1100px;
                margin: 40px auto;
            }

            .product-image-col img {
                width: 100%;
                border-radius: 8px;
                border: 1px solid #eee;
                max-height: 700px;
                object-fit: cover;
            }

            .product-info-col {
                padding-left: 30px;
            }

            .product-title {
                font-size: 28px;
                font-weight: 700;
                color: #333;
                margin-bottom: 10px;
            }

            .product-sku {
                font-size: 14px;
                color: #888;
                margin-bottom: 15px;
            }

            .product-price-box {
                background-color: #fafafa;
                border: 1px solid #f0f0f0;
                border-radius: 8px;
                padding: 20px;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 15px;
            }

            .sale-price {
                font-size: 28px;
                font-weight: 700;
                color: #d70000;
            }

            .original-price {
                font-size: 20px;
                color: #888;
                text-decoration: line-through;
            }

            .sale-badge {
                font-size: 14px;
                font-weight: 600;
                color: #d70000;
                background-color: #ffeaea;
                border: 1px solid #d70000;
                border-radius: 4px;
                padding: 3px 8px;
            }

            .selector-label {
                font-size: 16px;
                font-weight: 600;
                color: #333;
                margin-bottom: 10px;
                display: block;
            }

            .size-selector {
                display: flex;
                gap: 10px;
                margin-bottom: 25px;
            }
            .size-option-radio {
                display: none;
            }
            .size-option-label {
                padding: 10px 20px;
                border: 1px solid #ddd;
                border-radius: 5px;
                cursor: pointer;
                font-weight: 600;
                color: #555;
                transition: all 0.2s ease;
            }
            .size-option-label:hover {
                border-color: var(--text-color, #a0816c);
            }
            .size-option-radio:checked + .size-option-label {
                border-color: var(--bg-color, #a0816c);
                background-color: var(--bg-color, #a0816c);
                color: #fff;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }

            .quantity-selector {
                display: flex;
                border: 1px solid #ddd;
                border-radius: 5px;
                width: 140px;
                overflow: hidden;
                margin-bottom: 30px;
            }
            .quantity-selector button {
                width: 40px;
                padding: 10px 0;
                font-size: 20px;
                line-height: 1;
                border: none;
                background-color: #f9f9f9;
                color: #555;
                cursor: pointer;
            }
            .quantity-selector button:hover {
                background-color: #f0f0f0;
            }
            .quantity-selector input {
                width: 60px;
                border: none;
                border-left: 1px solid #ddd;
                border-right: 1px solid #ddd;
                text-align: center;
                font-weight: 600;
                font-size: 16px;
                color: #333;
            }
            .quantity-selector input[type=number]::-webkit-inner-spin-button,
            .quantity-selector input[type=number]::-webkit-outer-spin-button {
                -webkit-appearance: none;
                margin: 0;
            }
            .quantity-selector input[type=number] {
                -moz-appearance: textfield;
            }

            .action-buttons {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 15px;
                margin-bottom: 25px;
            }
            .btn-action {
                width: 100%;
                padding: 14px 20px;
                text-align: center;
                font-weight: 700;
                font-size: 16px;
                border-radius: 5px;
                border: 2px solid var(--bg-color, #a0816c);
                transition: all 0.3s ease;
                text-transform: uppercase;
            }
            .btn-add-to-cart {
                background-color: var(--bg-color, #a0816c);
                color: #fff;
            }
            .btn-add-to-cart:hover {
                background-color: #8d7360;
                border-color: #8d7360;
                color: #fff;
            }
            .btn-buy-now {
                background-color: #fff;
                color: var(--text-color, #a0816c);
            }
            .btn-buy-now:hover {
                background-color: var(--bg-color, #a0816c);
                color: #fff;
            }

            .product-info-accordion {
                border-top: 1px solid #eee;
            }
            .accordion-item {
                border-bottom: 1px solid #eee;
            }
            .accordion-header {
                padding: 18px 0;
                cursor: pointer;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .accordion-header h6 {
                font-weight: 600;
                color: #333;
                margin: 0;
            }
            .accordion-header .icon {
                font-size: 20px;
                transition: transform 0.3s ease;
            }
            .accordion-content {
                display: none;
                padding: 0 10px 20px 10px;
                color: #555;
            }
            .accordion-content img {
                border-radius: 5px;
            }

            .stock-popup {
                position: fixed;
                
                top: 110px;
                left: 50%;
                transform: translateX(-50%);

                min-width: 280px;
                max-width: 600px;
                padding: 12px 20px;
                background-color: #fff;
                color: #333;
                border-radius: 8px;
                font-size: 14px;
                text-align: center;
                box-shadow: 0 6px 16px rgba(0,0,0,0.2);
                border-left: 4px solid var(--bg-color, #a0816c);

                opacity: 0;
                pointer-events: none;
                transition: opacity 0.25s ease, transform 0.25s ease;
                z-index: 9999;
            }

            .stock-popup.show {
                opacity: 1;
                pointer-events: auto;
                transform: translateX(-50%) translateY(0);
            }


        </style>
    </head>

    <body>

        <header class="header">
            <div class="header_title">Free shipping with orders from&nbsp;<strong>200,000 VND </strong></div>
            <div class="headerContent">
                <div class="logo"><a href="${pageContext.request.contextPath}/">GIO</a></div>
                <nav>
                    <ul class="headerList">
                        <li class="headerListItem"><a href="${pageContext.request.contextPath}/">Home Page</a></li>
                        <li class="headerListItem">
                            <a href="${pageContext.request.contextPath}/productList/male">Men's Fashion<i class="bi bi-caret-down dropdown-icon"></i></a>
                            <ul class="dropdownMenu">
                                <li><a href="${pageContext.request.contextPath}/productList/male/t_shirt">T-shirt</a></li>
                                <li><a href="${pageContext.request.contextPath}/productList/male/pant">Long Pants</a></li>
                                <li><a href="${pageContext.request.contextPath}/productList/male/short">Shorts</a></li>
                            </ul>
                        </li>
                        <li class="headerListItem">
                            <a href="${pageContext.request.contextPath}/productList/female">Women's Fashion<i class="bi bi-caret-down dropdown-icon"></i></a>
                            <ul class="dropdownMenu">
                                <li><a href="${pageContext.request.contextPath}/productList/female/t_shirt">T-shirt</a></li>
                                <li><a href="${pageContext.request.contextPath}/productList/female/pant">Long Pants</a></li>
                                <li><a href="${pageContext.request.contextPath}/productList/female/dress">Dress</a></li>
                            </ul>
                        </li>
                        <li class="headerListItem">
                            <a href="${pageContext.request.contextPath}/aboutUs.jsp">Information<i class="bi bi-caret-down dropdown-icon"></i></a>
                            <ul class="dropdownMenu">
                                <li><a href="${pageContext.request.contextPath}/aboutUs.jsp">About Us</a></li>
                                <li><a href="${pageContext.request.contextPath}/contact.jsp">Contact</a></li>
                                <li><a href="${pageContext.request.contextPath}/policy.jsp">Exchange Policy</a></li>
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
                                    <input oninput="searchByName(this)" name="search" type="text" size="20" placeholder="Search for products...">
                                    <button><i class="bi bi-search"></i></button>
                                </div>
                                <div class="search-list" id="search-ajax"></div>
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
            <hr width="100%" , color="#d0a587" />
        </header>

        <main class="product-detail-container">
            <form action="cartInsert" method="get" id="productForm">
                <div class="row">
                    <div class="col-md-6 product-image-col">
                        <img src="${p.picURL}" alt="${p.name}">
                    </div>

                    <div class="col-md-6 product-info-col">
                        <h1 class="product-title">${p.name}</h1>
                        <p class="product-sku" name="id">SKU: ${p.id}</p>

                        <c:set var="formattedPrice2">
                            <fmt:formatNumber type="number" value="${p.price}" pattern="###,###" />
                        </c:set>
                        <c:set var="formattedPrice">
                            <fmt:formatNumber type="number" value="${p.price - ((p.price * promoMap[p.promoID])/100)}" pattern="###,###" />
                        </c:set>

                        <div class="product-price-box">
                            <span class="sale-price">${formattedPrice} VND</span>
                            <c:if test="${promoMap[p.promoID] > 0}">
                                <span class="original-price">${formattedPrice2} VND</span>
                                <span class="sale-badge">SALE: ${promoMap[p.promoID]}%</span>
                            </c:if>
                        </div>

                        <label class="selector-label">Size:</label>
                        <div class="size-selector">
                            <div class="size-option">
                                <input type="radio" id="sizeS" name="size" value="S" class="size-option-radio" checked>
                                <label for="sizeS" class="size-option-label">S</label>
                            </div>
                            <div class="size-option">
                                <input type="radio" id="sizeM" name="size" value="M" class="size-option-radio">
                                <label for="sizeM" class="size-option-label">M</label>
                            </div>
                            <div class="size-option">
                                <input type="radio" id="sizeL" name="size" value="L" class="size-option-radio">
                                <label for="sizeL" class="size-option-label">L</label>
                            </div>
                        </div>

                        <label class="selector-label">Quantity:</label>
                        <div class="quantity-selector quan">
                            <button id="decrementButton" type="button">-</button>
                            <input type="number" id="numberInput" value="1" min="1" readonly>
                            <button id="incrementButton" type="button">+</button>
                        </div>

                        <div class="action-buttons">
                            <button id="check" type="button" class="btn-action btn-add-to-cart">
                                ADD TO CART
                            </button>

                            <button type="submit" 
                                    formaction="productBuy" 
                                    name="id" 
                                    value="${p.id}" 
                                    class="btn-action btn-buy-now">
                                BUY NOW
                            </button>
                        </div>

                        <div class="product-info-accordion">
                            <div class="accordion-item">
                                <div class="accordion-header" onclick="toggleAccordion(this)">
                                    <h6>PRODUCT INFORMATION</h6>
                                    <i class="icon bi bi-chevron-down"></i>
                                </div>
                                <div class="accordion-content">
                                    <p>${p.description}</p>
                                </div>
                            </div>
                            <div class="accordion-item">
                                <div class="accordion-header" onclick="toggleAccordion(this)">
                                    <h6>SIZE CHART</h6>
                                    <i class="icon bi bi-chevron-down"></i>
                                </div>
                                <div class="accordion-content">
                                    <img src="${pageContext.request.contextPath}/images/male-tshirt-size.jpg" alt="Size Chart">
                                    <img src="${pageContext.request.contextPath}/images/male-short-size.jpg" alt="Size Chart">
                                    <img src="${pageContext.request.contextPath}/images/male-pant-size.jpg" alt="Size Chart">
                                    <img src="${pageContext.request.contextPath}/images/female-tshirt-size.jpg" alt="Size Chart">
                                    <img src="${pageContext.request.contextPath}/images/female-pant-size.jpg" alt="Size Chart">
                                    <img src="${pageContext.request.contextPath}/images/female-dress-size.jpg" alt="Size Chart">
                                </div>
                            </div>
                        </div>

                        <input type="hidden" name="id" class="id" value="${p.id}">
                        <input type="hidden" name="price" class="price" value="${p.price - ((p.price * promoMap[p.promoID])/100)}">
                        <input type="hidden" name="quantity" id="quantityInput" value="1">
                        <input type="hidden" name="name" value="${p.name}">
                        <input type="hidden" name="picURL" value="${p.picURL}">
                    </div>
                </div>
            </form>
        </main>

        <footer>
            <div class="content-footer">
                <h3 id="highlight">Follow us on Instagram</h3>
                <p>@gio.vn & @fired.vn</p>
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
                        <h4 id="highlight">About Gio</h4>
                        <p>Vintage and basic wardrobe for boys and girls.Vintage and basic wardrobe for boys and girls.</p>
                        <img src="//theme.hstatic.net/1000296747/1000891809/14/footer_logobct_img.png?v=55" alt="..." class="bct">
                    </div>
                    <div class="col-sm-3">
                        <h4 id="highlight">Contact</h4>
                        <p><b>Address:</b> 100 Nguyen Van Cu, An Khanh Ward, Ninh Kieu District, City. Can Tho</p>
                        <p><b>Phone:</b> 0123.456.789 - 0999.999.999</p>
                        <p><b>Email:</b> info@gio.vn</p>
                    </div>
                    <div class="col-sm-3">
                        <h4 id="highlight">Customer Support</h4>
                        <ul class="CS">
                            <li><a href="">Search</a></li>
                            <li><a href="">Introduction</a></li>
                        </ul>
                    </div>
                    <div class="col-sm-3">
                        <h4 id="highlight">Customer Care</h4>
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

        <!-- Popup thông báo tồn kho -->
        <div id="stock-popup" class="stock-popup"></div>

        <!-- jQuery -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>

        <script>
                                    // Popup tự tắt sau 5s
                                    let stockPopupTimer = null;
                                    function showPopup(message) {
                                        const popup = document.getElementById('stock-popup');
                                        if (!popup)
                                            return;

                                        popup.textContent = message;
                                        popup.classList.add('show');

                                        if (stockPopupTimer) {
                                            clearTimeout(stockPopupTimer);
                                        }
                                        stockPopupTimer = setTimeout(function () {
                                            popup.classList.remove('show');
                                        }, 5000);
                                    }

                                    // Accordion mô tả / size chart
                                    function toggleAccordion(headerElement) {
                                        const content = headerElement.nextElementSibling;
                                        const icon = headerElement.querySelector('.icon');

                                        if (content.style.display === "block") {
                                            content.style.display = "none";
                                            icon.classList.remove("bi-chevron-up");
                                            icon.classList.add("bi-chevron-down");
                                        } else {
                                            content.style.display = "block";
                                            icon.classList.remove("bi-chevron-down");
                                            icon.classList.add("bi-chevron-up");
                                        }
                                    }

                                    // Search box
                                    function toggleBox(id) {
                                        const el = document.getElementById(id);
                                        if (el) {
                                            el.style.display = (el.style.display === 'block') ? 'none' : 'block';
                                        }
                                    }

                                    // AJAX search
                                    function searchByName(name) {
                                        var search = name.value;
                                        $.ajax({
                                            url: "/Project_SWP391_Group4/searchProductByAJAX",
                                            type: "get",
                                            data: {txt: search},
                                            success: function (data) {
                                                var row = document.getElementById("search-ajax");
                                                if (row)
                                                    row.innerHTML = data;
                                            },
                                            error: function (xhr) { }
                                        });
                                    }

                                    // Nút +/- số lượng & kiểm tra tồn kho theo size
                                    document.addEventListener('DOMContentLoaded', function () {
                                        const decBtn = document.getElementById('decrementButton');
                                        const incBtn = document.getElementById('incrementButton');
                                        const numberInput = document.getElementById('numberInput');
                                        const qtyInput = document.getElementById('quantityInput');
                                        const form = document.getElementById('productForm');
                                        const addToCartBtn = document.getElementById('check');

                                        // Tồn kho theo size do server fill sẵn
                                        const sizeStock = {
                                            "S": <%= stockS%>,
                                            "M": <%= stockM%>,
                                            "L": <%= stockL%>
                                        };

                                        function setQty(v) {
                                            const val = Math.max(1, parseInt(v, 10) || 1);
                                            numberInput.value = val;
                                            qtyInput.value = val;
                                        }

                                        incBtn.addEventListener('click', function () {
                                            setQty((parseInt(numberInput.value, 10) || 1) + 1);
                                        });

                                        decBtn.addEventListener('click', function () {
                                            setQty((parseInt(numberInput.value, 10) || 1) - 1);
                                        });

                                        // Khi đổi size, nếu vượt tồn kho thì hạ về mức tối đa
                                        document.querySelectorAll("input[name='size']").forEach(r => {
                                            r.addEventListener('change', () => {
                                                const size = document.querySelector("input[name='size']:checked").value;
                                                const max = sizeStock[size] || 0;
                                                let cur = parseInt(numberInput.value, 10) || 1;
                                                if (max > 0 && cur > max)
                                                    setQty(max);
                                            });
                                        });

                                        // GIỮ NGUYÊN TÊN HÀM: checkStock
                                        function checkStock() {
                                            const size = document.querySelector("input[name='size']:checked").value;
                                            const stock = sizeStock[size] || 0;
                                            const requested = parseInt(qtyInput.value, 10) || 1;

                                            if (stock <= 0) {
                                                showPopup("Sorry, size " + size + " is OUT OF STOCK.");
                                                return false;
                                            }
                                            if (requested > stock) {
                                                showPopup("Sorry, we only have " + stock + " item(s) for size " + size + ".");
                                                return false;
                                            }
                                            return true;
                                        }

                                        // Add to cart (nút type="button")
                                        addToCartBtn.addEventListener('click', function (e) {
                                            if (!checkStock()) {
                                                e.preventDefault();
                                            } else {
                                                form.submit();
                                            }
                                        });

                                        // Buy now (submit form)
                                        form.addEventListener('submit', function (e) {
                                            if (!checkStock())
                                                e.preventDefault();
                                        });
                                    });
        </script>
    </body>
</html>
