
<%@page import="java.text.NumberFormat"%>
<%@page import="java.text.DecimalFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 

<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-iYQeCzEYFbKjA/T2uDLTpkwGzCiq6soy8tYaI1GyVh/UjpbCx/TYkiZhlZB6+fzT" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link href='https://fonts.googleapis.com/css?family=Quicksand' rel='stylesheet'> <link rel="icon" href="${pageContext.request.contextPath}/images/LG1.png" type="image/x-icon">

        <title>GIO - Products</title>
        
        <style>
            /* *
             * BỘ STYLE GỐC CỦA BẠN (GIỮ NGUYÊN)
            */
            * {
                margin: 0;
                padding: 0;
                font-family: 'Quicksand', sans-serif;
                box-sizing: border-box;
                color: rgb(151, 143, 137);
            }

            img { width: 100%; }
            :root {
                --logo-color: #a0816c;
                --nav-list-color: #a0816c;
                --icon-color: #a0816c;
                --text-color: #a0816c;
                --bg-color: #a0816c;
            }
            body::-webkit-scrollbar { width: 0.5em; }
            body::-webkit-scrollbar-track { box-shadow: inset 0 0 6px rgba(0, 0, 0, 0.3); }
            body::-webkit-scrollbar-thumb {
                border-radius: 50px;
                background-color: var(--bg-color);
                outline: 1px solid slategrey;
            }
            nav { height: 70px; justify-content: center; display: flex; }
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
            .headerContent { max-width: 1200px; margin: 0 auto; }
            .headerContent, .headerList, .headerTool { display: flex; align-items: center; }
            .headerContent { justify-content: space-around; }
            .logo a {
                text-decoration: none;
                color: var(--logo-color);
                font-size: 1.5em;
                font-weight: bold;
            }
            .logo a:hover { color: var(--logo-color); }
            .headerList { margin: 0; list-style-type: none; }
            .headerListItem { transition: font-size 0.3s ease; height: 24px; }
            .headerListItem:hover { font-size: 18px; }
            .headerListItem a {
                margin: 0 10px;
                padding: 22px 0;
                text-decoration: none;
                color: var(--text-color);
            }
            .dropdown-icon { margin-left: 2px; font-size: 0.7500em; }
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
            .dropdownMenu li:hover { background-color: #f1f1f1; }
            .headerListItem:hover .dropdownMenu { display: block; }
            .headerTool a { padding: 5px; }
            .headerToolIcon { width: 45px; justify-content: center; display: flex; }
            .icon { cursor: pointer; font-size: 26px; }
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
            .search-input { position: relative; }
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
            .search-input input:focus { outline: none; border-color: var(--bg-color); }
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
            .infoBox-content ul { padding: 0; margin: 0; }
            .infoBox-content ul li { list-style-type: none; }
            .infoBox-content ul li:first-child { color: black; padding-left: 7px; }
            .infoBox-list li a {
                text-decoration: none;
                font-size: 14px;
                color: black;
                padding: 0;
            }
            .infoBox-list li a:hover { color: var(--text-color); }
            .bi-dot { color: black; }
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
            .noneProduct { padding: 0 0 10px; }
            .shopping-cart-icon {
                margin: 0 auto 7px;
                display: block;
                width: 15%;
                height: 15%;
            }
            .cartIcon { justify-content: center; display: flex; }
            .cartIcon i { font-size: 2.5em; }
            .noneProduct p { text-align: center; font-size: 14px; margin: 0; }
            .haveProduct { margin-bottom: 8px; display: none; }
            .bi-x-lg { cursor: pointer; }
            .miniCartImg { padding-left: 0; }
            .miniCartDetail { padding-right: 0; position: relative; }
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
            .miniCart-price span { color: #677279; float: left; font-weight: 500; }
            .miniCartDetail .deleteBtn {
                position: absolute;
                top: 0;
                right: 0px;
                line-height: 20px;
                text-align: center;
                width: 19px;
                height: 19px;
            }
            .miniCartDetail .deleteBtn * { color: black; }
            .sumPrice { border-top: 1px solid #e7e7e7; }
            .sumPrice table { width: 100%; }
            .sumPrice td { width: 50%; }
            .sumPrice .tbTextLeft, .tbTextRight { padding: 10px 0; }
            .sumPrice .tbTextRight, span {
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
            .cartButton td:first-child { padding-right: 5px; }
            .cartButton td:last-child { padding-left: 5px; }
            .cartButton .btnRight { transition: 0.3s; }
            .cartButton .btnRight:hover {
                background-color: white;
                border: 1px solid var(--bg-color);
                color: var(--text-color);
                transition: 0.3s;
            }
            hr { margin-top: 0; margin-bottom: 10px; }
            footer { background-color: #f5f5f5; }
            .content-footer { text-align: center; padding: 30px; }
            .content-footer h3 { color: #a0816c; }
            .bct { width: 50%; }
            footer p { font-size: 15px; }
            footer a { text-decoration: none; color: rgb(151, 143, 137); }
            .items-footer { margin: 5%; }
            #highlight { color: #a0816c; }
            #img-footer img { padding: 0; }
            #img-footer { margin: 0 auto; }
            .phone { position: relative; }
            .bi-telephone {
                cursor: pointer;
                font-size: 3em;
                position: absolute;
                top: -16%;
                left: 15px;
            }
            .contact-item { display: flex; }
            .contact-link {
                margin-right: 10px;
                border: 1px solid #a0816c;
                border-radius: 5px;
                padding: 5px;
                width: 35.6px;
                justify-content: center;
                display: flex;
            }
            .contact-link:hover { background-color: var(--bg-color); }
            .contact-link:hover .bi-facebook::before,
            .contact-link:hover .bi-instagram::before { color: white; }
            .search-info { display: flex; margin: 10px 0; }
            .title { width: 88%; }
            .search-img { width: 12%; }
            .search-info a { padding: 0; }
            .search-img a img { width: 100%; }
            .title a { text-decoration: none; color: #cfb997; }
            .title p { margin: 0; margin-top: 14px; font-size: .8em; }
            .search-list { max-height: 280px; overflow-y: scroll; scrollbar-width: none; }
            button.filter{
                color: white;
                border: none;
                border-radius: 5px;
                border-width: 0%;
                padding: 0 10px;
                border-color: var(--logo-color);
                background-color: var(--logo-color);
                margin-left: 1%;
                height: 39px;
            }
            @media (max-width: 1024px) {
                .infoBox, .searchBox, .cartBox { right: 0; }
            }
            .price{ color:black; }

            /* ========================================= */
            /* ===== STYLE MỚI CHO GIAO DIỆN YODY ===== */
            /* ========================================= */

            .main-content-wrapper {
                max-width: 1200px; 
                margin: 20px auto 50px auto; 
                padding: 0 15px;
            }

            /* === TASK 1: SỬA CSS TIÊU ĐỀ === */
            .page-title {
                color: #333;
                font-weight: 700;
                font-size: 24px;
                margin-bottom: 20px;
                text-align: center; /* Đổi từ left sang center */
                text-transform: capitalize; 
            }

            .sort-bar {
                margin-bottom: 25px;
                display: flex;
                justify-content: flex-end; 
                align-items: center;
            }
            .sort-bar label {
                margin-right: 10px;
                font-weight: 500;
                color: #333;
                font-size: 15px;
            }
            .sort-bar #filter {
                width: auto; 
                border: 1px solid #ddd;
                border-radius: 5px;
                padding: 8px 12px;
                font-size: 14px;
                background-color: #fff;
                color: #555;
            }
            .sort-bar button.filter { display: none; }
            
            /* === TASK 3: CSS CHO MÀU SORT === */
            .sort-option-new { color: #007bff; font-weight: 500; }
            .sort-option-best { color: #dc3545; font-weight: 500; }
            .sort-option-asc { color: #28a745; font-weight: 500; }
            .sort-option-desc { color: #E8A317; font-weight: 500; }
            
            .product-grid {
                display: grid;
                grid-template-columns: repeat(4, 1fr); 
                gap: 20px; 
            }
            @media (max-width: 992px) {
                .product-grid { grid-template-columns: repeat(3, 1fr); }
            }
            @media (max-width: 768px) {
                .product-grid { grid-template-columns: repeat(2, 1fr); gap: 15px; }
            }
            .product-card {
                background: #fff;
                border: 1px solid #f0f0f0; 
                border-radius: 8px; 
                overflow: hidden; 
                transition: box-shadow 0.3s ease;
                text-align: left;
            }
            .product-card:hover { box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08); }
            .product-card__image-wrapper { position: relative; overflow: hidden; }
            .product-card__image {
                width: 100%;
                height: 378px; 
                object-fit: cover;
                display: block;
                transition: transform 0.4s ease; 
            }
            .product-card:hover .product-card__image { transform: scale(1.05); }
            .product-card__actions {
                position: absolute;
                bottom: 10px;
                left: 50%;
                transform: translateX(-50%);
                display: flex;
                opacity: 0; 
                transition: opacity 0.3s ease;
            }
            .product-card:hover .product-card__actions { opacity: 1; }
            .product-card__action-btn {
                background: var(--bg-color, #a0816c); 
                color: #fff;
                border: none;
                padding: 10px 20px;
                border-radius: 5px;
                font-size: 14px;
                font-weight: 600;
                text-decoration: none;
                white-space: nowrap;
                cursor: pointer;
            }
            .product-card__action-btn:hover { background: #8d7360; color: #fff; }
            .product-card__badge {
                position: absolute;
                top: 10px;
                left: 10px;
                background: #d70000; 
                color: #fff;
                padding: 3px 8px;
                border-radius: 4px;
                font-size: 12px;
                font-weight: 600;
                z-index: 2;
            }
            .product-card__info { padding: 15px; }
            .product-card__name {
                font-size: 15px;
                font-weight: 600; /* Tên sản phẩm in đậm */
                color: #333; 
                text-decoration: none;
                display: block;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis; 
                margin-bottom: 8px;
            }
            .product-card__name:hover { color: var(--text-color, #a0816c); }
            .product-card__price { display: flex; align-items: center; gap: 8px; }
            .product-card__sale-price {
                font-size: 16px;
                font-weight: 700;
                color: #d70000; 
            }
            .product-card__original-price {
                font-size: 14px;
                color: #888; 
                text-decoration: line-through; 
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
                                        <%-- AJAX content will fill this --%>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="headerToolIcon">
                        <a href="${pageContext.request.contextPath}/profile"><i class="bi bi-person icon"></i></a>
                    </div>
                    <div class="headerToolIcon">
                        <a href="${pageContext.request.contextPath}/loadCart"><i class="bi bi-cart2 icon" onclick="toggleBox('box3')"></i></a>
                    </div>
                </div>
            </div>
            <hr width="100%" , color="#d0a587" />
        </header>
        <main class="main-content-wrapper">

            <%-- Lấy URI (đường dẫn) hiện tại --%>
            <c:set var="uri" value="${pageContext.request.requestURI}" />
            
            <%-- 1. Đặt tiêu đề mặc định hoặc dựa trên URL --%>
            <c:set var="title" value="All Products"/> 
            <c:choose>
                <%-- Các link Nam --%>
                <c:when test="${fn:endsWith(uri, '/productList/male')}">
                    <c:set var="title" value="Male"/>
                </c:when>
                <c:when test="${fn:endsWith(uri, '/productList/male/t_shirt')}">
                    <c:set var="title" value="Male - T-Shirt"/>
                </c:when>
                <c:when test="${fn:endsWith(uri, '/productList/male/pant')}">
                    <c:set var="title" value="Male - Pants"/>
                </c:when>
                <c:when test="${fn:endsWith(uri, '/productList/male/short')}">
                    <c:set var="title" value="Male - Shorts"/>
                </c:when>
                
                <%-- Các link Nữ --%>
                <c:when test="${fn:endsWith(uri, '/productList/female')}">
                    <c:set var="title" value="Female"/>
                </c:when>
                <c:when test="${fn:endsWith(uri, '/productList/female/t_shirt')}">
                    <c:set var="title" value="Female - T-Shirt"/>
                </c:when>
                <c:when test="${fn:endsWith(uri, '/productList/female/pant')}">
                    <c:set var="title" value="Female - Pants"/>
                </c:when>
                <c:when test="${fn:endsWith(uri, '/productList/female/dress')}">
                    <c:set var="title" value="Female - Dress"/>
                </c:when>
            </c:choose>
            
            <%-- 2. KIỂM TRA SORT (Nằm BÊN NGOÀI <c:choose>) --%>
            <%-- Nếu có tham số sort, nó sẽ GHI ĐÈ tiêu đề danh mục --%>
            <c:if test="${not empty param.sortID}">
                <c:choose>
                    <c:when test="${param.sortID == 'New'}"><c:set var="title" value="New Arrivals"/></c:when>
                    <c:when test="${param.sortID == 'BestSeller'}"><c:set var="title" value="Best Sellers"/></c:when>
                    <c:when test="${param.sortID == 'Increase'}"><c:set var="title" value="Price: Low to High"/></c:when>
                    <c:when test="${param.sortID == 'Decrease'}"><c:set var="title" value="Price: High to Low"/></c:when>
                </c:choose>
            </c:if>
            
            <h2 class="page-title">${title}</h2>
            <form action="${pageContext.request.contextPath}/sortProduct" method="get" class="sort-bar">
                <label for="filter">Sort by:</label>
                
                <select name="sortID" id="filter" class="form-control" onchange="this.form.submit()">
                    <option class="sort-option-new" value="New" ${param.sortID == 'New' ? 'selected' : ''}>
                        New Arrivals
                    </option>
                    <option class="sort-option-best" value="BestSeller" ${param.sortID == 'BestSeller' ? 'selected' : ''}>
                        Best Sellers
                    </option>
                    <option class="sort-option-asc" value="Increase" ${param.sortID == 'Increase' ? 'selected' : ''}>
                        Price: Low to High
                    </option>
                    <option class="sort-option-desc" value="Decrease" ${param.sortID == 'Decrease' ? 'selected' : ''}>
                        Price: High to Low
                    </option>
                </select>
            </form>
        
            <div class="product-grid" id="product">
        
                <c:forEach items="${requestScope.productList}" var="product">
        
                    <div class="product-card">
        
                        <div class="product-card__image-wrapper">
                            <a href="${pageContext.request.contextPath}/productDetail?id=${product.getId()}">
                                <img class="product-card__image" src="${product.getPicURL()}" alt="${product.getName()}">
                            </a>
        
                            <c:if test="${promoMap[product.promoID] > 0}">
                                <div class="product-card__badge">-${promoMap[product.promoID]}%</div>
                            </c:if>
        
                            <div class="product-card__actions">
                                <a href="${pageContext.request.contextPath}/productDetail?id=${product.getId()}" class="product-card__action-btn">
                                    View Details
                                </a>
                            </div>
                        </div>
        
                        <div class="product-card__info">
                            <a href="${pageContext.request.contextPath}/productDetail?id=${product.getId()}" class="product-card__name" title="${product.getName()}">
                                ${product.getName()}
                            </a>
        
                            <c:set var="formattedPrice">
                                <fmt:formatNumber type="number" value="${product.getPrice()}" pattern="###,###" />
                            </c:set>
                            <c:set var="formattedPrice2">
                                <fmt:formatNumber type="number" value="${product.price - ((product.price * promoMap[product.promoID])/100)}" pattern="###,###" />
                            </c:set>
        
                            <div class="product-card__price">
                                <span class="product-card__sale-price">${formattedPrice2} VND</span>
        
                                <c:if test="${promoMap[product.promoID] > 0}">
                                    <span class="product-card__original-price">${formattedPrice} VND</span>
                                </c:if>
                            </div>
                        </div>
        
                    </div>
                    </c:forEach>
            </div>
            </main>
        <footer>
            <div class="content-footer">
                <h3 id="highlight">Follow us on Instagram</h3>
                <p>@dotai.vn & @fired.vn</p>
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
        <script src="${pageContext.request.contextPath}/js/header.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <script type="text/javascript">
            // Các hàm JS cũ của bạn (vẫn được giữ lại)
            function doDelete(id) {
                if (confirm("Do you want to delete this product (" + id + ")?")) {
                    window.location = "deleteProduct?id=" + id;
                }
            }
            
            function searchByName(name) {
                var search = name.value;
                $.ajax({
                    url: "/Project_SWP391_Group4/searchProductByAJAX",
                    type: "get",
                    data: {
                        txt: search
                    },
                    success: function (data) {
                        // Cập nhật: Target đúng vào #search-ajax
                        var row = document.getElementById("search-ajax");
                        row.innerHTML = data;
                    },
                    error: function (xhr) { }
                });
            }
            
            // Hàm này không còn được dùng trong giao diện mới
            function showSizeOptions(button) {
                const idP = button.parentElement.querySelector('.idP').value;
                var sizeOptions = document.getElementById('sizeOptions_' + idP);
                if (sizeOptions.style.display === "block") {
                    sizeOptions.style.display = "none";
                } else {
                    sizeOptions.style.display = "block";
                }
            }
            // Hàm này không còn được dùng trong giao diện mới
            function buyNow(button) {
                var name = button.parentElement.querySelector('.name').value;
                var price = button.parentElement.querySelector('.price').value;
                var picUrl = button.parentElement.querySelector('.picUrl').value;
                var id = button.parentElement.querySelector('.id').value;
                var size = button.parentElement.querySelector('select').value;
                window.location.href = '${pageContext.request.contextPath}/productBuy?name=' + name + "&price=" + price + "&quantity=1" + "&size=" + size + "&picURL=" + picUrl + "&id="T + id;
            }
        </script>
    </body>
</html>