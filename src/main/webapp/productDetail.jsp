<%-- 
    Document    : productDetail.jsp
    Description : Product Detail - Reviews Layout Updated (Left Rating, Right Filter, Avatar, Date)
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.text.DecimalFormat"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-iYQeCzEYFbKjA/T2uDLTpkwGzCiq6soy8tYaI1GyVh/UjpbCx/TYkiZhlZB6+fzT" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link href='https://fonts.googleapis.com/css?family=Quicksand:300,400,500,600,700&display=swap' rel='stylesheet'>
        <link rel="icon" href="${pageContext.request.contextPath}/images/LG2.png" type="image/x-icon">
        <title>${p.name} | GIO</title>

        <style>
            /* === CORE VARIABLES === */
            :root {
                --primary-color: #a0816c;
                --primary-hover: #8a6d5a;
                --text-dark: #2d2d2d;
                --text-gray: #6c757d;
                --border-color: #e5e5e5;
                --bg-light: #f8f9fa;
                --sale-color: #d70000;
                --shadow-soft: 0 10px 30px rgba(0,0,0,0.05);
                --shadow-hover: 0 15px 35px rgba(0,0,0,0.1);
            }

            * { margin: 0; padding: 0; font-family: 'Quicksand', sans-serif; box-sizing: border-box; }
            body { background-color: #fff; color: var(--text-dark); overflow-x: hidden; }
            img { max-width: 100%; display: block; }
            a { text-decoration: none; color: inherit; transition: color 0.3s; }

            /* === BREADCRUMBS STYLE === */
            .breadcrumb-container {
                margin-bottom: 30px;
                padding: 10px 0;
                display: flex;
                justify-content: flex-start;
                width: 100%;
            }
            .breadcrumb {
                display: flex;
                align-items: center;
                gap: 8px;
                font-size: 1rem;
                font-weight: 500;
                list-style: none;
                margin: 0; 
                padding-left: 0 !important;
                flex-wrap: wrap;
            }
            .breadcrumb-item a { color: #888; }
            .breadcrumb-item a:hover { color: var(--primary-color); }
            .breadcrumb-item.active { color: var(--text-dark); font-weight: 700; pointer-events: none; }
            .breadcrumb-separator { color: #ccc; font-size: 0.8rem; }

            /* === ANIMATIONS (KEYFRAMES) === */
            @keyframes fadeInUp {
                from { opacity: 0; transform: translateY(30px); }
                to { opacity: 1; transform: translateY(0); }
            }

            @keyframes fadeInScale {
                from { opacity: 0; transform: scale(0.95); }
                to { opacity: 1; transform: scale(1); }
            }

            /* Utility Classes for Animation */
            .reveal-element { opacity: 0; animation-fill-mode: forwards; }
            .animate-up { animation: fadeInUp 0.8s cubic-bezier(0.2, 0.8, 0.2, 1) forwards; }
            .animate-scale { animation: fadeInScale 0.8s ease-out forwards; }

            /* Stagger Delays */
            .delay-100 { animation-delay: 0.1s; }
            .delay-200 { animation-delay: 0.2s; }
            .delay-300 { animation-delay: 0.3s; }
            .delay-400 { animation-delay: 0.4s; }
            .delay-500 { animation-delay: 0.5s; }
            .delay-600 { animation-delay: 0.6s; }

            /* === LAYOUT === */
            .product-detail-wrapper {
                max-width: 1200px;
                margin: 20px auto 80px;
                padding: 0 20px;
            }

            /* Image Section */
            .col-sticky-image { position: sticky; top: 150px; align-self: start; z-index: 10; }
            .product-image-container { 
                position: relative;
                border-radius: 16px; 
                overflow: hidden; 
                box-shadow: var(--shadow-soft); 
                border: 1px solid #f0f0f0; 
                background: #fff;
                max-width: 400px;
                width: 100%;
                margin: 0 auto;
            }
            .product-image-container img { 
                width: 100%; 
                height: auto; 
                object-fit: cover; 
                transition: transform 0.7s cubic-bezier(0.2, 0.8, 0.2, 1);
            }

            /* Info Section */
            .product-info-wrapper { padding-left: 30px; }
            .product-title { font-size: 2.2rem; font-weight: 700; color: var(--text-dark); line-height: 1.2; margin-bottom: 10px; }
            .product-sku { font-size: 0.9rem; color: var(--text-gray); margin-bottom: 20px; letter-spacing: 1px; font-weight: 500; }

            /* Price */
            .price-wrapper { display: flex; align-items: center; gap: 15px; margin-bottom: 30px; padding-bottom: 20px; border-bottom: 1px solid var(--border-color); }
            .current-price { font-size: 2rem; font-weight: 700; color: var(--sale-color); }
            .old-price { font-size: 1.2rem; color: #aaa; text-decoration: line-through; }
            .discount-badge { 
                background-color: rgba(215, 0, 0, 0.1); color: var(--sale-color); 
                font-size: 0.85rem; font-weight: 700; padding: 6px 12px; border-radius: 30px; 
            }

            /* Selectors */
            .selector-label { font-size: 0.95rem; font-weight: 700; color: var(--text-dark); margin-bottom: 12px; display: block; }
            
            .size-selector { display: flex; flex-wrap: wrap; gap: 12px; margin-bottom: 30px; }
            .size-option-radio { display: none; }
            .size-option-label {
                min-width: 50px; height: 50px; padding: 0 15px; display: flex; align-items: center; justify-content: center;
                border: 1px solid #e0e0e0; border-radius: 10px; background: #fff; font-weight: 600; color: var(--text-dark); 
                cursor: pointer; transition: all 0.2s ease; user-select: none;
            }
            .size-option-label:hover { border-color: var(--primary-color); transform: translateY(-2px); box-shadow: 0 4px 8px rgba(0,0,0,0.05); }
            .size-option-radio:checked + .size-option-label { 
                background-color: var(--primary-color); color: #fff; border-color: var(--primary-color); 
                box-shadow: 0 5px 15px rgba(160, 129, 108, 0.4); transform: translateY(-1px);
            }
            .size-option-radio:disabled + .size-option-label { 
                background-color: #f8f9fa; color: #ccc; cursor: not-allowed; border-color: #f0f0f0; transform: none; box-shadow: none;
            }

            /* Quantity */
            .quantity-stock-wrapper { margin-bottom: 35px; }
            .quantity-control { 
                display: flex; align-items: center; 
                border: 1px solid #ddd; border-radius: 10px; 
                width: 150px; height: 50px; overflow: hidden; 
                transition: all 0.3s ease; background: #fff;
            }
            .quantity-control:hover:not(.disabled) { border-color: var(--primary-color); }
            .quantity-control.disabled { background-color: #f5f5f5; opacity: 0.6; pointer-events: none; border-color: #eee; }

            .quantity-btn { width: 45px; height: 100%; border: none; background: #fff; font-size: 1.2rem; cursor: pointer; color: var(--text-dark); transition: background 0.2s; }
            .quantity-btn:hover { background: #f8f9fa; color: var(--primary-color); }
            
            .quantity-input { 
                flex: 1; border: none; text-align: center; font-weight: 600; font-size: 1.1rem; color: var(--text-dark); background: transparent;
                -moz-appearance: textfield;
            }
            .quantity-input:focus { outline: none; }
            
            .stock-status { display: inline-block; margin-left: 8px; font-size: 0.9rem; font-weight: 600; transition: color 0.3s; }
            .stock-available { color: #27ae60; }
            .stock-out { color: var(--sale-color); font-style: italic; }

            /* Action Buttons */
            .action-buttons { display: flex; gap: 20px; margin-bottom: 40px; }
            .btn-action {
                display: inline-flex;
                min-width: 200px;
                padding: 16px 24px;
                border-radius: 50px; 
                font-weight: 700; 
                font-size: 1rem; 
                text-transform: uppercase; 
                letter-spacing: 0.5px;
                transition: all 0.3s cubic-bezier(0.2, 0.8, 0.2, 1);
                align-items: center; 
                justify-content: center; 
                gap: 10px; 
                cursor: pointer;
                position: relative; 
                overflow: hidden;
            }
            
            .btn-add-cart { background: #fff; border: 2px solid var(--text-dark); color: var(--text-dark); }
            .btn-add-cart:hover { background: var(--text-dark); color: #fff; transform: translateY(-4px); box-shadow: 0 10px 20px rgba(45, 45, 45, 0.2); }
            .btn-add-cart:active { transform: translateY(-1px); }

            .btn-buy-now { background: var(--primary-color); border: 2px solid var(--primary-color); color: #fff; box-shadow: 0 8px 20px rgba(160, 129, 108, 0.3); }
            .btn-buy-now:hover { background: var(--primary-hover); border-color: var(--primary-hover); transform: translateY(-4px); box-shadow: 0 12px 25px rgba(160, 129, 108, 0.4); }
            .btn-buy-now:active { transform: translateY(-1px); }
            
            .btn-action:disabled { opacity: 0.6; cursor: not-allowed; transform: none !important; box-shadow: none !important; }

            /* Accordion */
            .accordion-item { border-bottom: 1px solid var(--border-color); overflow: hidden; }
            .accordion-header { padding: 20px 0; cursor: pointer; display: flex; justify-content: space-between; align-items: center; transition: color 0.3s ease; }
            .accordion-header h6 { margin: 0; font-weight: 700; font-size: 1.05rem; color: var(--text-dark); }
            .accordion-header .icon { font-size: 0.9rem; transition: transform 0.4s cubic-bezier(0.4, 0, 0.2, 1); color: var(--text-gray); }
            
            .accordion-content { max-height: 0; opacity: 0; overflow: hidden; transition: max-height 0.4s cubic-bezier(0.4, 0, 0.2, 1), opacity 0.4s ease; color: var(--text-gray); font-size: 0.95rem; line-height: 1.7; }
            .accordion-content p { padding-bottom: 20px; }
            .accordion-content img { margin-top: 10px; border-radius: 12px; border: 1px solid #eee; margin-bottom: 20px; box-shadow: 0 4px 10px rgba(0,0,0,0.03); }
            
            .accordion-item.active .accordion-header h6 { color: var(--primary-color); }
            .accordion-item.active .accordion-content { opacity: 1; }
            .accordion-item.active .accordion-header .icon { transform: rotate(180deg); color: var(--primary-color); }

            /* === REVIEWS SECTION (UPDATED) === */
            .reviews-section { 
                margin-top: 40px; 
                padding-top: 30px; 
                border-top: 1px dashed var(--border-color); 
                opacity: 0; transform: translateY(20px); transition: all 1s ease-out;
            }
            .reviews-section.visible { opacity: 1; transform: translateY(0); }

            .reviews-title { 
                text-align: left; 
                font-weight: 700; 
                font-size: 1.5rem; 
                margin-bottom: 25px; 
                color: var(--text-dark); 
                position: relative; 
            }
            .reviews-title::after { content: ''; position: absolute; bottom: -8px; left: 0; width: 200px; height: 3px; background: var(--primary-color); border-radius: 2px; }

            /* REVIEW SUMMARY CARD (HORIZONTAL LAYOUT) */
            .review-summary-card { 
                border: none; border-radius: 16px; padding: 25px; background: #fff; 
                box-shadow: var(--shadow-soft); 
                display: flex; 
                flex-direction: row; /* Horizontal Alignment */
                justify-content: space-between; 
                align-items: center; 
                transition: transform 0.3s;
                margin-bottom: 20px; 
                border: 1px solid #f0f0f0;
                gap: 20px;
                flex-wrap: wrap; /* Cho phép xuống dòng trên mobile */
            }
            
            .summary-left {
                display: flex;
                flex-direction: column;
                align-items: flex-start;
            }
            
            .summary-right {
                flex: 1;
                display: flex;
                justify-content: flex-end;
            }

            .rating-number { font-size: 3rem; font-weight: 700; color: var(--text-dark); line-height: 1; margin-bottom: 5px; }
            .rating-stars { font-size: 1.2rem; color: #f1c40f; margin-bottom: 5px; letter-spacing: 2px; }
            .rating-text { font-size: 0.9rem; color: #888; }

            /* REVIEW CARD ITEM (WITH AVATAR) */
            .review-card-item { 
                background: #fff; border-radius: 12px; padding: 20px; margin-bottom: 15px; border: 1px solid #f0f0f0; 
                box-shadow: 0 4px 10px rgba(0,0,0,0.02); transition: all 0.3s ease;
            }
            .review-card-item:hover { border-color: var(--primary-color); box-shadow: 0 8px 20px rgba(0,0,0,0.05); }
            
            .review-card-header { display: flex; align-items: flex-start; margin-bottom: 10px; }
            
            .review-avatar {
                width: 45px; height: 45px;
                background: #f1f1f1;
                border-radius: 50%;
                display: flex; align-items: center; justify-content: center;
                margin-right: 15px;
                font-size: 1.5rem; color: #aaa;
                flex-shrink: 0;
            }

            .review-info { flex: 1; }
            .review-top-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 4px; }
            
            .review-user-name { font-weight: 700; color: var(--text-dark); font-size: 1rem; }
            .review-item-stars { color: #f1c40f; font-size: 0.9rem; margin-bottom: 4px; line-height: 1; }
            .review-date { font-size: 0.8rem; color: #999; }
            .review-content { font-size: 0.95rem; color: #555; line-height: 1.6; }
            
            /* FILTER BUTTONS STYLES */
            .reviews-filter-wrapper {
                display: flex;
                flex-wrap: wrap;
                gap: 8px;
                justify-content: flex-end; /* Align buttons right */
            }
            .review-filter-btn {
                background: #fff;
                border: 1px solid #ddd;
                padding: 6px 14px;
                border-radius: 20px;
                font-size: 0.85rem;
                cursor: pointer;
                transition: all 0.2s;
                color: #555;
            }
            .review-filter-btn:hover, .review-filter-btn.active {
                border-color: var(--primary-color);
                color: var(--primary-color);
                background-color: #fff8f5;
                font-weight: 600;
            }

            .no-reviews-container { text-align: center; padding: 40px; background: #f8f9fa; border-radius: 16px; border: 1px dashed #d1d1d1; }
            .no-reviews-icon { font-size: 2.5rem; color: #ccc; margin-bottom: 15px; display: block; }

            /* Style for Hidden Reviews & Show More Button */
            .hidden-review { display: none; }
            .hidden-by-filter { display: none !important; }
            
            .btn-show-more {
                border: 1px solid var(--border-color);
                background: transparent;
                color: var(--text-dark);
                padding: 8px 20px;
                border-radius: 20px;
                font-size: 0.9rem;
                font-weight: 600;
                transition: all 0.3s;
                margin-top: 10px;
                cursor: pointer;
            }
            .btn-show-more:hover {
                background: var(--bg-light);
                color: var(--primary-color);
                border-color: var(--primary-color);
            }

            /* Responsive tweaks */
            @media (max-width: 768px) {
                .review-summary-card { flex-direction: column; text-align: center; }
                .summary-left { align-items: center; margin-bottom: 15px; }
                .summary-right { justify-content: center; width: 100%; }
                .reviews-filter-wrapper { justify-content: center; }
                .col-sticky-image { position: static; } 
                .product-info-wrapper { padding-left: 0; margin-top: 40px; } 
                .product-title { font-size: 1.8rem; }
            }

            /* Popup */
            .stock-popup { 
                position: fixed; top: 120px; right: 30px;
                padding: 15px 30px; 
                background: rgba(30, 30, 30, 0.85);
                backdrop-filter: blur(10px); -webkit-backdrop-filter: blur(10px);
                color: #fff; border-radius: 12px; 
                font-size: 0.95rem; font-weight: 500; 
                box-shadow: 0 15px 40px rgba(0,0,0,0.25); 
                opacity: 0; transform: translateX(50px); pointer-events: none; 
                transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275); 
                z-index: 10000; border: 1px solid rgba(255,255,255,0.1);
                display: flex; align-items: center; gap: 10px;
            }
            .stock-popup::before { content: '\F332'; font-family: "bootstrap-icons"; font-size: 1.2rem; }
            .stock-popup.show { opacity: 1; transform: translateX(0); }
            .stock-popup.success::before { content: '\F26A'; color: #2ecc71; }
            .stock-popup.error::before { content: '\F332'; color: #e74c3c; }
            /* Back to Top Button */
        #btn-back-to-top {
            position: fixed;
            bottom: 30px;
            right: 30px;
            display: none;
            background-color: var(--primary-color);
            color: white;
            border: none;
            width: 50px; height: 50px;
            border-radius: 50%;
            font-size: 1.5rem;
            z-index: 100;
            cursor: pointer;
            box-shadow: 0 4px 10px rgba(0,0,0,0.3);
            transition: all 0.3s;
        }
        #btn-back-to-top:hover {
            background-color: var(--primary-color);
            transform: translateY(-5px);
        }
        </style>
    </head>

    <body>
        <%@ include file="header.jsp" %>
        <c:if test="${not empty ms}">
    ${ms}
</c:if>


        <main class="product-detail-wrapper">
            
            <%-- === BREADCRUMBS SECTION === --%>
            <c:set var="ctx" value="${requestScope.pageContext}" />
            <c:if test="${empty ctx}"><c:set var="ctx" value=""/></c:if>

            <div class="breadcrumb-container reveal-element animate-up">
                <nav aria-label="breadcrumb">
                    <ul class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}">Home</a></li>
                        <li class="breadcrumb-separator"><i class="bi bi-chevron-right"></i></li>

                        <c:choose>
                            <c:when test="${fn:contains(ctx, 'male') && !fn:contains(ctx, 'female')}">
                                <li class="breadcrumb-item">
                                    <a href="${pageContext.request.contextPath}/productList/male">Men's Fashion</a>
                                </li>
                                <li class="breadcrumb-separator"><i class="bi bi-chevron-right"></i></li>
                            </c:when>
                            <c:when test="${fn:contains(ctx, 'female')}">
                                <li class="breadcrumb-item">
                                    <a href="${pageContext.request.contextPath}/productList/female">Women's Fashion</a>
                                </li>
                                <li class="breadcrumb-separator"><i class="bi bi-chevron-right"></i></li>
                            </c:when>
                        </c:choose>

                        <c:choose>
                            <c:when test="${ctx == 'male_tshirt'}">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/productList/male/t_shirt">T-shirt</a></li>
                                <li class="breadcrumb-separator"><i class="bi bi-chevron-right"></i></li>
                            </c:when>
                            <c:when test="${ctx == 'male_pant'}">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/productList/male/pant">Long Pants</a></li>
                                <li class="breadcrumb-separator"><i class="bi bi-chevron-right"></i></li>
                            </c:when>
                            <c:when test="${ctx == 'male_short'}">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/productList/male/short">Shorts</a></li>
                                <li class="breadcrumb-separator"><i class="bi bi-chevron-right"></i></li>
                            </c:when>
                            <c:when test="${ctx == 'female_tshirt'}">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/productList/female/t_shirt">T-shirt</a></li>
                                <li class="breadcrumb-separator"><i class="bi bi-chevron-right"></i></li>
                            </c:when>
                            <c:when test="${ctx == 'female_pant'}">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/productList/female/pant">Long Pants</a></li>
                                <li class="breadcrumb-separator"><i class="bi bi-chevron-right"></i></li>
                            </c:when>
                            <c:when test="${ctx == 'female_dress'}">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/productList/female/dress">Dresses</a></li>
                                <li class="breadcrumb-separator"><i class="bi bi-chevron-right"></i></li>
                            </c:when>
                        </c:choose>

                        <li class="breadcrumb-item active" aria-current="page">${p.name}</li>
                    </ul>
                </nav>
            </div>

            <form action="cartInsert" method="get" id="productForm">
                <div class="row align-items-start"> 
                    <div class="col-lg-6 mb-4 col-sticky-image reveal-element animate-scale">
                        <div class="product-image-container">
                            <img src="${p.picURL}" alt="${p.name}">
                        </div>
                    </div>

                    <div class="col-lg-6">
                        <div class="product-info-wrapper">
                            <h1 class="product-title reveal-element animate-up delay-100">${p.name}</h1>
                            <div class="product-sku reveal-element animate-up delay-100">SKU: ${p.id}</div>

                            <c:set var="formattedPrice2"><fmt:formatNumber type="number" value="${p.price}" pattern="###,###" /></c:set>
                            <c:set var="formattedPrice"><fmt:formatNumber type="number" value="${p.price - ((p.price * voucherMap[p.voucherID])/100)}" pattern="###,###" /></c:set>

                            <div class="price-wrapper reveal-element animate-up delay-200">
                                <span class="current-price">${formattedPrice} VND</span>
                                <c:if test="${voucherMap[p.voucherID] > 0}">
                                    <span class="old-price">${formattedPrice2} VND</span>
                                    <span class="discount-badge">-${voucherMap[p.voucherID]}%</span>
                                </c:if>
                            </div>

                            <div class="reveal-element animate-up delay-300">
                                <label class="selector-label">Select Size:</label>
                                <div class="size-selector">
                                    <c:set var="sizeOrder" value="S,M,L" />
                                    <c:forEach items="${fn:split(sizeOrder, ',')}" var="targetSize">
                                        <c:forEach items="${sizeList}" var="s">
                                            <c:if test="${s.size_name eq targetSize}">
                                                <div class="size-option-item">
                                                    <input type="radio" id="size${s.size_name}" name="size" value="${s.size_name}" class="size-option-radio" data-stock="${s.quantity}">
                                                    <label for="size${s.size_name}" class="size-option-label">${s.size_name}</label>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                    </c:forEach>
                                </div>
                            </div>

                            <div class="quantity-stock-wrapper reveal-element animate-up delay-300">
                                <label class="selector-label">Quantity: <span id="stock-display" class="stock-status"></span></label>
                                <div class="quantity-control" id="qtyControl">
                                    <button id="decrementButton" type="button" class="quantity-btn"><i class="bi bi-dash"></i></button>
                                    <input type="number" id="quantityInput" name="quantity" value="1" min="1" 
                                           class="quantity-input" readonly>
                                    <button id="incrementButton" type="button" class="quantity-btn"><i class="bi bi-plus"></i></button>
                                </div>
                            </div>

                            <div class="action-buttons reveal-element animate-up delay-400">
                                <button id="check" type="button" class="btn-action btn-add-cart">
                                    <i class="bi bi-cart-plus" style="font-size: 1.2rem;"></i> Add to Cart
                                </button>
                                <button type="submit" formaction="productBuy" name="id" value="${p.id}" class="btn-action btn-buy-now">Buy Now</button>
                            </div>

                            <div class="product-accordion reveal-element animate-up delay-500">
                                <div class="accordion-item active"> 
                                    <div class="accordion-header" onclick="toggleAccordion(this)">
                                        <h6>Description</h6>
                                        <i class="icon bi bi-chevron-down"></i>
                                    </div>
                                    <div class="accordion-content" style="display: block;">
                                        <p>${p.description}</p>
                                    </div>
                                </div>
                                <div class="accordion-item">
                                    <div class="accordion-header" onclick="toggleAccordion(this)">
                                        <h6>Size Guide</h6>
                                        <i class="icon bi bi-chevron-down"></i>
                                    </div>
                                    <div class="accordion-content">
                                        <div class="mb-2"><b>1) Men's T-shirt:</b></div>
                                        <img src="${pageContext.request.contextPath}/images/male-tshirt-size.jpg" alt="Size Chart">
                                        <div class="my-2"><b>2) Men's Shorts:</b></div>
                                        <img src="${pageContext.request.contextPath}/images/male-short-size.jpg" alt="Size Chart">
                                        <div class="my-2"><b>3) Men's Pants:</b></div>
                                        <img src="${pageContext.request.contextPath}/images/male-pant-size.jpg" alt="Size Chart">
                                        <div class="my-2"><b>4) Women's T-shirt:</b></div>
                                        <img src="${pageContext.request.contextPath}/images/female-tshirt-size.jpg" alt="Size Chart">
                                        <div class="my-2"><b>5) Women's Pants:</b></div>
                                        <img src="${pageContext.request.contextPath}/images/female-pant-size.jpg" alt="Size Chart">
                                        <div class="my-2"><b>6) Women's Dress:</b></div>
                                        <img src="${pageContext.request.contextPath}/images/female-dress-size2.jpg" alt="Size Chart">
                                    </div>
                                </div>
                                <div class="accordion-item">
                                    <div class="accordion-header" onclick="toggleAccordion(this)">
                                        <h6>Shipping & Returns</h6>
                                        <i class="icon bi bi-chevron-down"></i>
                                    </div>
                                    <div class="accordion-content">
                                        <p>Free shipping on this orders. Returns accepted within 30 days of delivery.</p>
                                    </div>
                                </div>
                            </div>

                            <%-- === REVIEWS SECTION MOVED HERE (INSIDE INFO WRAPPER) === --%>
                            <div class="reviews-section reveal-element animate-up delay-600" id="reviewsSection">
                                <%-- [UPDATE 1] Changed Title --%>
                                <h3 class="reviews-title">Product Reviews</h3>
                                <c:if test="${empty feedbackList}">
                                    <div class="no-reviews-container">
                                        <i class="bi bi-chat-quote no-reviews-icon"></i>
                                        <p class="no-reviews-text">No reviews yet. Be the first to share your thoughts!</p>
                                    </div>
                                </c:if>
                                <c:if test="${not empty feedbackList}">
                                    
                                    <%-- [UPDATE 2] Calculate Counts in JSTL --%>
                                    <c:set var="count5" value="0"/> <c:set var="count4" value="0"/>
                                    <c:set var="count3" value="0"/> <c:set var="count2" value="0"/>
                                    <c:set var="count1" value="0"/> <c:set var="countComment" value="0"/>
                                    
                                    <c:forEach var="f" items="${feedbackList}">
                                        <c:if test="${f.ratePoint == 5}"><c:set var="count5" value="${count5 + 1}"/></c:if>
                                        <c:if test="${f.ratePoint == 4}"><c:set var="count4" value="${count4 + 1}"/></c:if>
                                        <c:if test="${f.ratePoint == 3}"><c:set var="count3" value="${count3 + 1}"/></c:if>
                                        <c:if test="${f.ratePoint == 2}"><c:set var="count2" value="${count2 + 1}"/></c:if>
                                        <c:if test="${f.ratePoint == 1}"><c:set var="count1" value="${count1 + 1}"/></c:if>
                                        <c:if test="${not empty f.content}"><c:set var="countComment" value="${countComment + 1}"/></c:if>
                                    </c:forEach>

                                    <div class="row">
                                        <div class="col-12 mb-4">
                                            <div class="review-summary-card">
                                                
                                                <%-- [UPDATE 3] Left Side: Rating Info --%>
                                                <div class="summary-left">
                                                    <div class="rating-number">
                                                        <fmt:formatNumber value="${averageRating}" maxFractionDigits="1"/>/5
                                                    </div>
                                                    <div class="rating-stars">
                                                        <c:forEach begin="1" end="5" var="i">
                                                            <i class="bi ${i <= averageRating ? 'bi-star-fill' : (i - 0.5 <= averageRating ? 'bi-star-half' : 'bi-star')}"></i>
                                                        </c:forEach>
                                                    </div>
                                                    <div class="rating-text">Based on ${reviewCount} reviews</div>
                                                </div>
                                                
                                                <%-- [UPDATE 3] Right Side: Filter Buttons --%>
                                                <div class="summary-right">
                                                    <div class="reviews-filter-wrapper">
                                                        <button type="button" class="review-filter-btn active" onclick="filterReviews('all', this)">All (${fn:length(feedbackList)})</button>
                                                        <button type="button" class="review-filter-btn" onclick="filterReviews('5', this)">5 Star (${count5})</button>
                                                        <button type="button" class="review-filter-btn" onclick="filterReviews('4', this)">4 Star (${count4})</button>
                                                        <button type="button" class="review-filter-btn" onclick="filterReviews('3', this)">3 Star (${count3})</button>
                                                        <button type="button" class="review-filter-btn" onclick="filterReviews('2', this)">2 Star (${count2})</button>
                                                        <button type="button" class="review-filter-btn" onclick="filterReviews('1', this)">1 Star (${count1})</button>
                                                        <button type="button" class="review-filter-btn" onclick="filterReviews('comment', this)">With Comments (${countComment})</button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="col-12" id="reviews-container">
                                            <c:forEach var="fb" items="${feedbackList}" varStatus="status">
                                                <%-- Check if index is >= 2 (0 and 1 are shown, rest are hidden) --%>
                                                <div class="review-card-item ${status.index >= 2 ? 'hidden-review' : ''}" 
                                                     data-star="${fb.ratePoint}" 
                                                     data-comment="${not empty fb.content}">
                                                    
                                                    <div class="review-card-header">
                                                        <%-- [UPDATE 4] Avatar --%>
                                                        <div class="review-avatar">
                                                            <i class="bi bi-person-fill"></i>
                                                        </div>
                                                        <div class="review-info">
                                                            <div class="review-top-row">
                                                                <div class="review-user-name">${fb.customerName}</div>
                                                                <%-- [UPDATE 5] Timestamp --%>
                                                                <div class="review-date">
                                                                    <fmt:formatDate value="${fb.createdAt}" pattern="dd-MM-yyyy HH:mm"/>
                                                                </div>
                                                            </div>
                                                            <div class="review-item-stars">
                                                                <c:forEach begin="1" end="5" var="i">
                                                                    <i class="bi ${i <= fb.ratePoint ? 'bi-star-fill' : 'bi-star'}"></i>
                                                                </c:forEach>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="review-content">${fb.content}</div>
                                                </div>
                                            </c:forEach>

                                            <%-- Show More Button (Only if there are more than 2 reviews) --%>
                                            <c:if test="${fn:length(feedbackList) > 2}">
                                                <div class="text-center" id="showMoreContainer">
                                                    <button id="btnShowMoreReviews" type="button" class="btn-show-more">
                                                        Show All <i class="bi bi-chevron-down"></i>
                                                    </button>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                            <%-- === END REVIEWS SECTION === --%>

                            <input type="hidden" name="id" class="id" value="${p.id}">
                            <input type="hidden" name="price" class="price" value="${p.price - ((p.price * voucherMap[p.voucherID])/100)}">
                            <input type="hidden" name="name" value="${p.name}">
                            <input type="hidden" name="picURL" value="${p.picURL}">
                            <input type="hidden" name="voucherPct" value="${voucherMap[p.voucherID]}">
                        </div>
                    </div>
                </div>
            </form>
        </main>
                        <button type="button" class="btn" id="btn-back-to-top">
        <i class="bi bi-arrow-up"></i>
    </button>

        <%@ include file="footer.jsp" %>
        <div id="stock-popup" class="stock-popup"></div>

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <script>
            let stockPopupTimer = null;
            // Enhanced Popup Function
            function showPopup(message, type = 'normal') {
                const popup = document.getElementById('stock-popup');
                if (!popup) return;
                popup.textContent = message;
                
                // Reset classes
                popup.className = 'stock-popup';
                if(message.toLowerCase().includes('success') || message.toLowerCase().includes('added')) {
                    popup.classList.add('success');
                } else {
                    popup.classList.add('error');
                }
                
                // Force Reflow for animation reset
                void popup.offsetWidth; 
                popup.classList.add('show');
                
                if (stockPopupTimer) clearTimeout(stockPopupTimer);
                stockPopupTimer = setTimeout(() => popup.classList.remove('show'), 3500);
            }

            function toggleAccordion(header) {
                const item = header.parentElement;
                const content = header.nextElementSibling;
                const isOpen = item.classList.contains('active');
                if (!isOpen) {
                    item.classList.add('active');
                    content.style.maxHeight = content.scrollHeight + "px";
                } else {
                    item.classList.remove('active');
                    content.style.maxHeight = null;
                }
            }

            // [UPDATE 5] Filter Reviews JS
            function filterReviews(filterType, btn) {
                // 1. Update Active Button
                document.querySelectorAll('.review-filter-btn').forEach(b => b.classList.remove('active'));
                btn.classList.add('active');

                // 2. Logic: If filtering, show matching items. 
                // If "all", revert to default state (first 2 shown, rest hidden, show button visible)
                
                const reviews = document.querySelectorAll('.review-card-item');
                const showMoreContainer = document.getElementById('showMoreContainer');
                
                if (filterType === 'all') {
                    // Reset to default view
                    reviews.forEach((el, index) => {
                        el.classList.remove('hidden-by-filter'); // Remove filter hide
                        if (index < 2) {
                            el.classList.remove('hidden-review');
                            el.style.display = 'block';
                        } else {
                            el.classList.add('hidden-review');
                            el.style.display = 'none'; // Re-hide items > 2
                        }
                    });
                    if(showMoreContainer) showMoreContainer.style.display = 'block';
                } else {
                    // Specific Filter
                    reviews.forEach(el => {
                        const star = el.getAttribute('data-star');
                        const hasComment = el.getAttribute('data-comment');
                        let match = false;

                        if (filterType === 'comment') {
                            match = (hasComment === 'true');
                        } else {
                            match = (star === filterType);
                        }

                        if (match) {
                            el.classList.remove('hidden-by-filter');
                            el.classList.remove('hidden-review'); // Ensure visible
                            el.style.display = 'block';
                        } else {
                            el.classList.add('hidden-by-filter');
                            el.style.display = 'none';
                        }
                    });
                    // Hide "Show More" button when filtering
                    if(showMoreContainer) showMoreContainer.style.display = 'none';
                }
            }

            document.addEventListener('DOMContentLoaded', function () {
                // Scroll Animation Observer for Reviews
                const observerOptions = { threshold: 0.1 };
                const observer = new IntersectionObserver((entries) => {
                    entries.forEach(entry => {
                        if (entry.isIntersecting) {
                            entry.target.classList.add('visible');
                            observer.unobserve(entry.target); // Run once
                        }
                    });
                }, observerOptions);
                
                const reviewsSection = document.getElementById('reviewsSection');
                if(reviewsSection) observer.observe(reviewsSection);

                // Initialize Accordion
                const activeItems = document.querySelectorAll('.accordion-item.active');
                activeItems.forEach(item => {
                    const content = item.querySelector('.accordion-content');
                    if(content) content.style.maxHeight = content.scrollHeight + "px";
                });

                // Logic Variables
                const isLoggedIn = ${sessionScope.acc != null};
                const loginUrl = "${pageContext.request.contextPath}/login.jsp";
                const decBtn = document.getElementById('decrementButton');
                const incBtn = document.getElementById('incrementButton');
                const qtyInput = document.getElementById('quantityInput');
                const qtyControl = document.getElementById('qtyControl');
                const form = document.getElementById('productForm');
                const addToCartBtn = document.getElementById('check');
                const buyNowBtn = document.querySelector('.btn-buy-now');
                const stockDisplay = document.getElementById('stock-display');
                
                const sizeRadios = document.querySelectorAll("input[name='size']");
                let firstAvailableSize = null;

                // Size & Stock Logic
                sizeRadios.forEach(radio => {
                    const stock = parseInt(radio.getAttribute('data-stock')) || 0;
                    if (stock <= 0) {
                        radio.disabled = true;
                    } else if (!firstAvailableSize) {
                        firstAvailableSize = radio;
                    }
                    radio.addEventListener('change', function () {
                        updateStockUI(parseInt(this.getAttribute('data-stock')) || 0);
                    });
                });

                if (firstAvailableSize) {
                    firstAvailableSize.checked = true;
                    updateStockUI(parseInt(firstAvailableSize.getAttribute('data-stock')));
                } else {
                    stockDisplay.textContent = "(Temporarily out of stock)";
                    stockDisplay.className = "stock-status stock-out";
                    addToCartBtn.disabled = true;
                    buyNowBtn.disabled = true;
                    qtyInput.disabled = true;
                    qtyInput.value = 0;
                    qtyControl.classList.add('disabled');
                }

                function updateStockUI(maxStock) {
                    if (maxStock > 0) {
                        stockDisplay.textContent = "(" + maxStock + " available)";
                        stockDisplay.className = "stock-status stock-available";
                        qtyInput.disabled = false;
                        qtyInput.max = maxStock;
                        qtyInput.value = 1;
                        addToCartBtn.disabled = false;
                        buyNowBtn.disabled = false;
                        qtyControl.classList.remove('disabled');
                    } else {
                        stockDisplay.textContent = "(Out of stock)";
                        stockDisplay.className = "stock-status stock-out";
                        addToCartBtn.disabled = true;
                        buyNowBtn.disabled = true;
                        qtyInput.value = 0;
                        qtyInput.disabled = true;
                        qtyControl.classList.add('disabled');
                    }
                }

                function setQty(val) {
                    const max = parseInt(qtyInput.max) || 1;
                    let newVal = parseInt(val);
                    if (isNaN(newVal)) newVal = 1;
                    if (newVal < 1) newVal = 1;
                    if (newVal > max) {
                        newVal = max;
                        showPopup("Max quantity reached (" + max + ")");
                    }
                    qtyInput.value = newVal;
                }

                incBtn.addEventListener('click', () => setQty((parseInt(qtyInput.value) || 1) + 1));
                decBtn.addEventListener('click', () => setQty((parseInt(qtyInput.value) || 1) - 1));

                function checkStock() {
                    const sizeRadio = document.querySelector("input[name='size']:checked");
                    if (!sizeRadio) { showPopup("Please select a size."); return false; }
                    const stock = parseInt(sizeRadio.getAttribute('data-stock')) || 0;
                    const requested = parseInt(qtyInput.value) || 1;
                    if (stock <= 0) { showPopup("Size out of stock."); return false; }
                    if (requested > stock) { showPopup(`Only ${stock} items left.`); return false; }
                    return true;
                }

                // --- SHOW MORE REVIEWS LOGIC ---
                const btnShowMore = document.getElementById('btnShowMoreReviews');
                if(btnShowMore) {
                    btnShowMore.addEventListener('click', function() {
                        // When Show More is clicked in "All" mode
                        const hiddenReviews = document.querySelectorAll('.hidden-review');
                        hiddenReviews.forEach(el => {
                            el.style.display = 'block';
                            el.classList.remove('hidden-review'); // Remove class so they stay shown
                            el.classList.add('animate-up');
                        });
                        this.closest('div').style.display = 'none'; // Hide button container
                    });
                }

                // AJAX Add to Cart
                addToCartBtn.addEventListener('click', function (e) {
                    e.preventDefault();
                    if (!isLoggedIn) { window.location.href = loginUrl; return; }
                    if (!checkStock()) return;
                    
                    // Button Loading Effect
                    const originalText = this.innerHTML;
                    this.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Adding...';
                    this.disabled = true;

                    const formData = new FormData(form);
                    const params = new URLSearchParams(formData);
                    const url = form.getAttribute('action') + "?" + params.toString();
                    
                    fetch(url, {method: 'GET'})
                        .then(res => { 
                            // Nếu Server redirect (ví dụ: bắt đăng nhập lại), thì mới chuyển trang
                            if (res.redirected) {
                                window.location.href = res.url; 
                                return null;
                            }
                            return res.text(); 
                        })
                        .then(text => { 
    this.innerHTML = originalText;
    this.disabled = false;

    if (text === null) return;

    const t = (text || "").trim();

    if (t === "OK") {
        showPopup("Added to cart successfully!", "success");
        setQty(1);
        return;
    }

    let msg = "Cannot add to cart. Please check stock and quantity in your cart.";
    const m = t.match(/alert\(['"](.+?)['"]\)/);
    if (m && m[1]) msg = m[1];

    showPopup(msg, "error");
})

                        .catch(err => {
                            console.error(err);
                            this.innerHTML = originalText;
                            this.disabled = false;
                            showPopup("Error adding to cart", "error");
                        });
                });

                form.addEventListener('submit', function (e) {
                    if (!isLoggedIn) { e.preventDefault(); window.location.href = loginUrl; }
                    else if (!checkStock()) { e.preventDefault(); }
                });
            });
            // --- 2. BACK TO TOP BUTTON ---
        let mybutton = document.getElementById("btn-back-to-top");

        window.onscroll = function () {
            scrollFunction();
        };

        function scrollFunction() {
            if (document.body.scrollTop > 300 || document.documentElement.scrollTop > 300) {
                mybutton.style.display = "block";
            } else {
                mybutton.style.display = "none";
            }
        }

        mybutton.addEventListener("click", backToTop);

        function backToTop() {
            document.body.scrollTop = 0;
            document.documentElement.scrollTop = 0;
        }
        </script>
        
    </body>
</html>