<%-- 
    Document    : index.jsp
    Updated     : Modern UI + Int Discount Logic
--%>

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

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

        <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">

        <link href='https://fonts.googleapis.com/css?family=Quicksand:300,400,500,600,700&display=swap' rel='stylesheet'> 
        <link rel="icon" href="${pageContext.request.contextPath}/images/LG2.png" type="image/x-icon">

        <title>Home | GIO</title>

        <style>
            /* --- 1. GLOBAL VARIABLES & RESET --- */
            :root {
                --primary-color: #a0816c;
                --primary-hover: #8a6d5a;
                --secondary-color: #2c3e50;
                --accent-bg: #fdfbf9;
                --text-dark: #2d2d2d;
                --text-muted: #6c757d;
                --price-red: #d0021b;

                /* Modern Effects */
                --card-radius: 20px;
                --card-radius-product: 12px;
                --btn-radius: 50px;
                --soft-shadow: 0 10px 40px -10px rgba(0,0,0,0.08);
                --hover-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
                --transition-smooth: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
            }

            html {
                scroll-behavior: smooth;
            }

            body {
                font-family: 'Quicksand', sans-serif;
                background-color: #ffffff;
                color: var(--text-dark);
                overflow-x: hidden;
            }

            a {
                text-decoration: none;
                transition: var(--transition-smooth);
            }
            img {
                max-width: 100%;
                height: auto;
            }

            ::-webkit-scrollbar {
                width: 8px;
            }
            ::-webkit-scrollbar-track {
                background: #f9f9f9;
            }
            ::-webkit-scrollbar-thumb {
                background: #dcdcdc;
                border-radius: 10px;
            }
            ::-webkit-scrollbar-thumb:hover {
                background: var(--primary-color);
            }

            /* --- 2. TOAST NOTIFICATION STYLES --- */
            .toast-alert {
                position: fixed;
                top: 90px;
                right: 20px;
                padding: 15px 25px;
                background-color: #fff;
                border: 1px solid #f0f0f0;
                border-radius: 8px;
                box-shadow: 0 5px 20px rgba(0,0,0,0.15);
                z-index: 9999;
                display: flex;
                align-items: center;
                gap: 12px;
                animation: slideInRight 0.5s cubic-bezier(0.68, -0.55, 0.27, 1.55) forwards;
            }
            .toast-alert.hide-toast {
                animation: slideOutRight 0.5s ease-in forwards;
            }

            @keyframes slideInRight {
                from {
                    transform: translateX(100%);
                    opacity: 0;
                }
                to {
                    transform: translateX(0);
                    opacity: 1;
                }
            }
            @keyframes slideOutRight {
                from {
                    opacity: 1;
                    transform: translateX(0);
                }
                to {
                    opacity: 0;
                    transform: translateX(100%);
                }
            }

            .toast-alert .toast-message {
                color: #333;
                font-weight: 600;
                font-size: 15px;
            }
            .toast-alert .toast-close {
                cursor: pointer;
                color: #aaa;
                margin-left: 15px;
                font-size: 18px;
                transition: color 0.2s;
            }
            .toast-alert .toast-close:hover {
                color: #333;
            }
            .toast-alert.success {
                border-left: 5px solid #28a745;
            }
            .toast-alert.success i.status-icon {
                color: #28a745;
                font-size: 1.4rem;
            }

            /* --- 3. PRELOADER --- */
            #page-loader {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-color: #fff;
                z-index: 99999;
                display: flex;
                justify-content: center;
                align-items: center;
                transition: opacity 0.6s ease, visibility 0.6s;
            }
            .spinner-box {
                width: 60px;
                height: 60px;
                border: 3px solid rgba(160, 129, 108, 0.2);
                border-top-color: var(--primary-color);
                border-radius: 50%;
                animation: spinner 0.8s linear infinite;
            }
            @keyframes spinner {
                to {
                    transform: rotate(360deg);
                }
            }

            /* --- 4. HERO CAROUSEL --- */
            .hero-section {
                position: relative;
                margin: 20px auto 60px;
                max-width: 1400px;
                padding: 0 15px;
            }
            .hero-rounded {
                border-radius: var(--card-radius);
                overflow: hidden;
                box-shadow: var(--soft-shadow);
            }
            .carousel-item {
                height: 600px;
                position: relative;
            }
            .carousel-item img {
                height: 100%;
                width: 100%;
                object-fit: cover;
                filter: brightness(0.9);
            }
            .hero-caption {
                position: absolute;
                bottom: 20%;
                left: 10%;
                z-index: 10;
                color: #fff;
                text-shadow: 0 2px 10px rgba(0,0,0,0.3);
            }
            .hero-caption h2 {
                font-size: 3.5rem;
                font-weight: 700;
                margin-bottom: 1rem;
            }
            .hero-caption p {
                font-size: 1.2rem;
                margin-bottom: 2rem;
                opacity: 0.9;
            }
            .btn-hero {
                background: #fff;
                color: var(--text-dark);
                padding: 12px 35px;
                border-radius: var(--btn-radius);
                font-weight: 600;
                border: none;
                box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            }
            .btn-hero:hover {
                background: var(--primary-color);
                color: #fff;
                transform: translateY(-3px);
            }

            @media (max-width: 768px) {
                .carousel-item {
                    height: 400px;
                }
                .hero-caption h2 {
                    font-size: 2rem;
                }
            }

            /* --- 5. CATEGORY BANNERS --- */
            .category-section {
                margin-bottom: 80px;
            }
            .cat-card {
                position: relative;
                display: block;
                height: 350px;
                border-radius: var(--card-radius);
                overflow: hidden;
                box-shadow: var(--soft-shadow);
            }
            .cat-card__bg {
                width: 100%;
                height: 100%;
                background-size: cover;
                background-position: center;
                transition: transform 0.8s cubic-bezier(0.25, 0.46, 0.45, 0.94);
            }
            .cat-male .cat-card__bg {
                background-image: url('${pageContext.request.contextPath}/images/img-male-tshirt3.jpg');
            }
            .cat-female .cat-card__bg {
                background-image: url('${pageContext.request.contextPath}/images/img-female-tshirt1.jpg');
            }

            .cat-card:hover .cat-card__bg {
                transform: scale(1.1);
            }
            .cat-overlay {
                position: absolute;
                inset: 0;
                background: linear-gradient(to top, rgba(0,0,0,0.6), transparent);
                display: flex;
                align-items: flex-end;
                padding: 30px;
            }
            .cat-content {
                color: #fff;
                width: 100%;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .cat-title {
                font-size: 1.8rem;
                font-weight: 700;
                margin: 0;
            }
            .cat-btn-icon {
                width: 50px;
                height: 50px;
                background: rgba(255,255,255,0.2);
                backdrop-filter: blur(5px);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.5rem;
                transition: var(--transition-smooth);
            }
            .cat-card:hover .cat-btn-icon {
                background: #fff;
                color: var(--primary-color);
                transform: rotate(-45deg);
            }

            /* --- 6. PRODUCTS --- */
            .section-header {
                text-align: center;
                margin-bottom: 50px;
            }
            .section-subtitle {
                color: var(--primary-color);
                font-weight: 600;
                letter-spacing: 2px;
                text-transform: uppercase;
                font-size: 0.9rem;
                margin-bottom: 10px;
                display: block;
            }
            .section-title {
                font-size: 2.5rem;
                font-weight: 700;
                color: var(--secondary-color);
                position: relative;
                display: inline-block;
            }

            .product-grid {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 25px;
                margin-bottom: 80px;
            }
            @media (max-width: 992px) {
                .product-grid {
                    grid-template-columns: repeat(3, 1fr);
                }
            }
            @media (max-width: 768px) {
                .product-grid {
                    grid-template-columns: repeat(2, 1fr);
                    gap: 15px;
                }
            }

            .product-card {
                background: #fff;
                border-radius: var(--card-radius-product);
                overflow: hidden;
                transition: all 0.3s ease;
                position: relative;
            }
            .product-card:hover {
                box-shadow: var(--hover-shadow);
                transform: translateY(-5px);
            }

            .product-card__image-wrapper {
                position: relative;
                overflow: hidden;
                border-radius: var(--card-radius-product);
                padding-top: 130%;
            }
            .product-card__image {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                object-fit: cover;
                transition: transform 0.5s ease;
            }
            .product-card:hover .product-card__image {
                transform: scale(1.08);
            }

            .product-card__badge {
                position: absolute;
                top: 15px;
                left: 15px;
                background: #e74c3c;
                color: #fff;
                padding: 4px 10px;
                border-radius: 20px;
                font-size: 0.75rem;
                font-weight: 700;
                z-index: 2;
            }
            .product-card__actions {
                position: absolute;
                bottom: 15px;
                left: 0;
                right: 0;
                display: flex;
                justify-content: center;
                opacity: 0;
                transform: translateY(10px);
                transition: all 0.3s ease;
                z-index: 3;
            }
            .product-card:hover .product-card__actions {
                opacity: 1;
                transform: translateY(0);
            }
            .product-card__action-btn {
                background: #fff;
                color: var(--text-dark);
                border: none;
                padding: 10px 25px;
                border-radius: 30px;
                font-size: 0.85rem;
                font-weight: 700;
                text-decoration: none;
                box-shadow: 0 5px 15px rgba(0,0,0,0.2);
                display: flex;
                align-items: center;
                gap: 5px;
            }
            .product-card__action-btn:hover {
                background: var(--primary-color);
                color: #fff;
            }

            .product-card__info {
                padding: 15px 5px;
                text-align: center;
            }
            .product-card__name {
                font-size: 1rem;
                font-weight: 600;
                color: var(--text-dark);
                display: block;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
                margin-bottom: 8px;
            }
            .product-card__name:hover {
                color: var(--primary-color);
            }
            .product-card__price {
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
            }
            .product-card__sale-price {
                font-size: 1.1rem;
                font-weight: 700;
                color: var(--price-red);
            }
            .product-card__original-price {
                font-size: 0.9rem;
                color: #aaa;
                text-decoration: line-through;
            }

            /* Back to Top Button */
            #btn-back-to-top {
                position: fixed;
                bottom: 30px;
                right: 30px;
                display: none;
                background-color: var(--primary-color);
                color: white;
                border: none;
                width: 50px;
                height: 50px;
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

        <div id="page-loader">
            <div class="spinner-box"></div>
        </div>

        <%-- === LOGIC THÔNG BÁO TÙY CHỈNH === --%>
        <c:if test="${not empty sessionScope.successMessage}">

            <c:set var="rawMsg" value="${sessionScope.successMessage}" />
            <c:set var="finalMsg" value="${rawMsg}" />

            <c:choose>
                <c:when test="${fn:containsIgnoreCase(rawMsg, 'log in') || fn:containsIgnoreCase(rawMsg, 'login')}">
                    <c:set var="userName" value="${sessionScope.acc.fullName}" />
                    <c:if test="${empty userName}">
                        <c:set var="userName" value="${sessionScope.acc.username}" />
                    </c:if>
                    <c:if test="${not empty userName}">
                        <c:set var="finalMsg" value="Welcome back, ${userName}!" />
                    </c:if>
                </c:when>

                <c:when test="${fn:containsIgnoreCase(rawMsg, 'logout')}">
                    <c:set var="finalMsg" value="You have been logged out." />
                </c:when>
            </c:choose>

            <div class="toast-alert success" id="toast-alert">
                <i class="bi bi-check-circle-fill status-icon"></i>
                <span class="toast-message">${finalMsg}</span>
                <i class="bi bi-x-lg toast-close" onclick="closeToast()"></i>
            </div>

            <c:remove var="successMessage" scope="session" />
        </c:if>

        <jsp:include page="header.jsp" />

        <main class="main-wrapper container-xxl">

            <section class="hero-section" data-aos="fade-zoom-in" data-aos-easing="ease-in-back" data-aos-delay="100">
                <div id="mainBannerCarousel" class="carousel slide hero-rounded" data-bs-ride="carousel">
                    <div class="carousel-indicators">
                        <button type="button" data-bs-target="#mainBannerCarousel" data-bs-slide-to="0" class="active"></button>
                        <button type="button" data-bs-target="#mainBannerCarousel" data-bs-slide-to="1"></button>
                        <button type="button" data-bs-target="#mainBannerCarousel" data-bs-slide-to="2"></button>
                    </div>
                    <div class="carousel-inner">
                        <div class="carousel-item active" data-bs-interval="6000">
                            <img src="${pageContext.request.contextPath}/images/banner1.jpg" alt="Fashion Collection">
                            <div class="hero-caption">
                                <h2 data-aos="fade-up" data-aos-delay="400">New Summer <br>Collection</h2>
                                <p data-aos="fade-up" data-aos-delay="600">Discover the latest trends in fashion with our exclusive arrivals.</p>
                                <a href="#categories" class="btn-hero" data-aos="fade-up" data-aos-delay="800">Welcome</a>
                            </div>
                        </div>
                        <div class="carousel-item" data-bs-interval="6000">
                            <img src="${pageContext.request.contextPath}/images/banner5.jpg" alt="Modern Style">
                            <div class="hero-caption">
                                <h2>Elegant <br>Lifestyle</h2>
                                <p>Refine your style with our premium selection.</p>
                                <a href="#categories" class="btn-hero">Explore</a>
                            </div>
                        </div>
                        <div class="carousel-item" data-bs-interval="6000">
                            <img src="${pageContext.request.contextPath}/images/banner3.jpg" alt="Urban Trends">
                            <div class="hero-caption">

                            </div>
                        </div>
                    </div>
                    <button class="carousel-control-prev" type="button" data-bs-target="#mainBannerCarousel" data-bs-slide="prev">
                        <span class="carousel-control-prev-icon"></span>
                    </button>
                    <button class="carousel-control-next" type="button" data-bs-target="#mainBannerCarousel" data-bs-slide="next">
                        <span class="carousel-control-next-icon"></span>
                    </button>
                </div>
            </section>

            <section id="categories" class="category-section">
                <div class="row g-4">
                    <div class="col-md-6" data-aos="fade-right">
                        <a href="${pageContext.request.contextPath}/productList/male" class="cat-card cat-male">
                            <div class="cat-card__bg"></div>
                            <div class="cat-overlay">
                                <div class="cat-content">
                                    <h3 class="cat-title">Men's Fashion</h3>
                                    <div class="cat-btn-icon"><i class="bi bi-arrow-right"></i></div>
                                </div>
                            </div>
                        </a>
                    </div>
                    <div class="col-md-6" data-aos="fade-left">
                        <a href="${pageContext.request.contextPath}/productList/female" class="cat-card cat-female">
                            <div class="cat-card__bg"></div>
                            <div class="cat-overlay">
                                <div class="cat-content">
                                    <h3 class="cat-title">Women's Fashion</h3>
                                    <div class="cat-btn-icon"><i class="bi bi-arrow-right"></i></div>
                                </div>
                            </div>
                        </a>
                    </div>
                </div>
            </section>

            <section id="product">
                <div class="section-header" data-aos="fade-up">
                    <span class="section-subtitle">Trending Now</span>
                    <h2 class="section-title">Featured Products</h2>
                </div>

                <div class="product-grid">
                    <c:forEach items="${requestScope.productList}" var="product" varStatus="status">
                        <div class="product-card" data-aos="fade-up" data-aos-delay="${status.index * 50}">
                            <div class="product-card__image-wrapper">

                                <%-- [UPDATED] Lấy giá trị Discount Int trực tiếp --%>
                                <c:set var="discountPercent" value="${product.discount}" />
                                <c:if test="${discountPercent == null}"> <c:set var="discountPercent" value="0"/> </c:if>

                                <%-- Hiển thị badge nếu discount > 0 --%>
                                <c:if test="${discountPercent > 0}">
                                    <div class="product-card__badge">-${discountPercent}%</div>
                                </c:if>

                                <a href="${pageContext.request.contextPath}/productDetail?id=${product.id}">
                                    <img class="product-card__image" src="${product.picURL}" alt="${product.name}" 
                                         onerror="this.src='${pageContext.request.contextPath}/images/default.jpg'">
                                </a>

                                <div class="product-card__actions">
                                    <a href="${pageContext.request.contextPath}/productDetail?id=${product.id}" class="product-card__action-btn">
                                        <i class="bi bi-eye"></i> View Details
                                    </a>
                                </div>
                            </div>

                            <div class="product-card__info">
                                <a href="${pageContext.request.contextPath}/productDetail?id=${product.id}" class="product-card__name" title="${product.name}">
                                    ${product.name}
                                </a>

                                <%-- Tính giá hiển thị --%>
                                <c:set var="finalPrice" value="${product.price}" />
                                <c:if test="${discountPercent > 0}">
                                    <c:set var="finalPrice" value="${product.price - (product.price * discountPercent / 100)}" />
                                </c:if>

                                <div class="product-card__price">
                                    <span class="product-card__sale-price">
                                        <fmt:formatNumber type="number" value="${finalPrice}" pattern="###,###" /> VND
                                    </span>

                                    <%-- Hiển thị giá gốc gạch ngang nếu có discount --%>
                                    <c:if test="${discountPercent > 0}">
                                        <span class="product-card__original-price">
                                            <fmt:formatNumber type="number" value="${product.price}" pattern="###,###" /> VND
                                        </span>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </section>

        </main>

        <button type="button" class="btn" id="btn-back-to-top">
            <i class="bi bi-arrow-up"></i>
        </button>

        <jsp:include page="footer.jsp" />

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>

        <script>
                    // Init Animation
                    AOS.init({
                        duration: 800,
                        once: true,
                        offset: 50
                    });

                    // Smart Loader
                    window.addEventListener('load', function () {
                        const loader = document.getElementById('page-loader');
                        if (loader) {
                            setTimeout(() => {
                                loader.style.opacity = '0';
                                loader.style.visibility = 'hidden';
                            }, 200);
                        }
                    });

                    // --- JS CHO TOAST NOTIFICATION ---
                    function closeToast() {
                        var alert = document.getElementById('toast-alert');
                        if (alert) {
                            alert.classList.add('hide-toast');
                            setTimeout(function () {
                                alert.style.display = 'none';
                            }, 450);
                        }
                    }

                    document.addEventListener('DOMContentLoaded', function () {
                        setTimeout(function () {
                            closeToast();
                        }, 5000);
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