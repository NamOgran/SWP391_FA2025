<%--
    Document    : productList.jsp
    Updated     : UI Fixes (Align Left, Price Color, Divider, VND)
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

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-iYQeCzEYFbKjA/T2uDLTpkwGzCiq6soy8tYaI1GyVh/UjpbCx/TYkiZhlZB6+fzT" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link href='https://fonts.googleapis.com/css?family=Quicksand:300,400,500,600,700&display=swap' rel='stylesheet'> 
        <link rel="icon" href="${pageContext.request.contextPath}/images/LG2.png" type="image/x-icon">

        <title>Products | GIO</title>

        <style>
            /* --- VARIABLES & GLOBAL --- */
            :root {
                --primary-color: #a0816c;
                --primary-hover: #8a6d5a;
                --text-dark: #2d2d2d;
                --text-light: #6c757d;
                --bg-light: #f8f9fa;
                --price-red: #d0021b; /* Màu đỏ cho giá */
                --hover-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            }

            * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Quicksand', sans-serif; }
            body { background-color: #fff; color: var(--text-light); }
            a { text-decoration: none; transition: all 0.3s ease; }
            img { width: 100%; display: block; }

            /* --- LAYOUT --- */
            .main-content-wrapper {
                max-width: 1320px;
                margin: 20px auto 80px auto;
                padding: 0 20px;
                min-height: 60vh;
            }

            /* --- BREADCRUMBS (Đã sửa lỗi sát trái) --- */
            .breadcrumb-container {
                margin-bottom: 20px;
                padding: 10px 0;
                display: flex;
                justify-content: flex-start;
                width: 100%;
            }
            .breadcrumb {
                display: flex;
                align-items: center;
                gap: 8px;
                font-size: 0.95rem;
                font-weight: 500;
                list-style: none;
                margin: 0; 
                padding-left: 0 !important; /* Bắt buộc xóa padding mặc định của bootstrap */
            }
            .breadcrumb-item a { color: #888; }
            .breadcrumb-item a:hover { color: var(--primary-color); }
            .breadcrumb-item.active { color: var(--text-dark); font-weight: 700; pointer-events: none; }
            .breadcrumb-separator { color: #ccc; font-size: 0.8rem; }

            /* --- FILTER TOOLBAR --- */
            .filter-container {
                background: #fff;
                padding: 15px 0; 
                margin-bottom: 30px;
                border-bottom: 1px solid #f0f0f0;
            }

            .toolbar-row {
                display: flex;
                flex-wrap: wrap;
                align-items: center;
                justify-content: space-between;
                gap: 20px;
            }

            /* Categories Pills */
            .category-pills { display: flex; gap: 10px; }
            .pill-btn {
                padding: 8px 20px; border-radius: 50px; font-size: 0.95rem; font-weight: 600;
                color: #555; background-color: #f8f9fa; border: 1px solid #eee;
                transition: all 0.2s ease; display: inline-block;
            }
            .pill-btn:hover { background-color: #e9ecef; color: #333; transform: translateY(-1px); }
            .pill-btn.active {
                background-color: var(--text-dark); color: #fff; border-color: var(--text-dark);
                box-shadow: 0 4px 10px rgba(0,0,0,0.15);
            }

            /* Filter Group Right */
            .filter-group-right { display: flex; align-items: center; gap: 12px; }

            /* Sort Buttons */
            .sort-btn {
                padding: 8px 16px; border-radius: 50px; font-size: 0.9rem; font-weight: 600;
                background-color: #fff; color: #555; border: 1px solid transparent; cursor: pointer;
                display: inline-flex; align-items: center; gap: 5px;
            }
            .sort-btn:hover { color: var(--primary-color); }
            .sort-btn.active { background-color: #f1f1f1; color: var(--text-dark); font-weight: 700; }

            /* Vertical Divider (Đường dọc) */
            .vertical-divider {
                width: 1px;
                height: 20px;
                background-color: #ddd;
                margin: 0 5px;
            }

            /* Select Price */
            .custom-select-wrapper { position: relative; }
            .form-control-custom {
                padding: 8px 30px 8px 15px; border-radius: 50px; border: 1px solid #ddd;
                background-color: #fff; font-size: 0.9rem; color: #555; font-weight: 500;
                cursor: pointer; appearance: none; -webkit-appearance: none; min-width: 140px;
                background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' fill='%23555' viewBox='0 0 16 16'%3E%3Cpath fill-rule='evenodd' d='M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708z'/%3E%3C/svg%3E");
                background-repeat: no-repeat; background-position: right 12px center;
            }
            .form-control-custom:focus { outline: none; border-color: var(--primary-color); }

            /* --- PRODUCT GRID --- */
            .product-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 25px; }
            @media (max-width: 992px) { .product-grid { grid-template-columns: repeat(3, 1fr); } }
            @media (max-width: 768px) { .product-grid { grid-template-columns: repeat(2, 1fr); gap: 15px; } }

            .product-card { background: #fff; border-radius: 12px; overflow: hidden; transition: all 0.3s ease; position: relative; }
            .product-card:hover { box-shadow: var(--hover-shadow); transform: translateY(-5px); }
            .product-card__image-wrapper { position: relative; overflow: hidden; border-radius: 12px; padding-top: 130%; }
            .product-card__image { position: absolute; top: 0; left: 0; width: 100%; height: 100%; object-fit: cover; transition: transform 0.5s ease; }
            .product-card:hover .product-card__image { transform: scale(1.08); }
            
            /* Badge màu đỏ */
            .product-card__badge { position: absolute; top: 15px; left: 15px; background: #e74c3c; color: #fff; padding: 4px 10px; border-radius: 20px; font-size: 0.75rem; font-weight: 700; z-index: 2; }
            
            .product-card__actions { position: absolute; bottom: 15px; left: 0; right: 0; display: flex; justify-content: center; opacity: 0; transform: translateY(10px); transition: all 0.3s ease; z-index: 3; }
            .product-card:hover .product-card__actions { opacity: 1; transform: translateY(0); }
            .product-card__action-btn { background: #fff; color: var(--text-dark); border: none; padding: 10px 25px; border-radius: 30px; font-size: 0.85rem; font-weight: 700; text-decoration: none; box-shadow: 0 5px 15px rgba(0,0,0,0.2); display: flex; align-items: center; gap: 5px; }
            .product-card__action-btn:hover { background: var(--primary-color); color: #fff; }

            .product-card__info { padding: 15px 5px; text-align: center; }
            .product-card__name { font-size: 1rem; font-weight: 600; color: var(--text-dark); display: block; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-bottom: 8px; }
            .product-card__name:hover { color: var(--primary-color); }
            .product-card__price { display: flex; align-items: center; justify-content: center; gap: 10px; }
            
            /* Sửa màu giá thành đỏ */
            .product-card__sale-price { font-size: 1.1rem; font-weight: 700; color: var(--price-red); }
            
            .product-card__original-price { font-size: 0.9rem; color: #aaa; text-decoration: line-through; }

            /* Utils */
            .initial-loader { display: flex; justify-content: center; align-items: center; min-height: 400px; width: 100%; }
            .spinner { width: 50px; height: 50px; border: 4px solid #f3f3f3; border-top: 4px solid var(--primary-color); border-radius: 50%; animation: spin 1s linear infinite; }
            @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
            .no-products-found { text-align: center; padding: 80px 0; grid-column: 1 / -1; color: #999; }
            .no-products-icon { font-size: 4rem; margin-bottom: 15px; color: #ddd; display: block;}
            .fade-in-grid { animation: fadeInMove 0.6s ease-out forwards; }
            @keyframes fadeInMove { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        </style>
    </head>

    <body>

        <%@ include file="header.jsp" %>
        
        <main class="main-content-wrapper">

            <%-- === 1. BREADCRUMBS LOGIC === --%>
            <c:set var="ctx" value="${requestScope.pageContext}" />
            <c:if test="${empty ctx}"><c:set var="ctx" value=""/></c:if>

            <%-- Class breadcrumb có padding-left: 0 để sát trái --%>
            <div class="breadcrumb-container">
                <nav aria-label="breadcrumb">
                    <ul class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}">Home</a></li>
                        <li class="breadcrumb-separator"><i class="bi bi-chevron-right"></i></li>

                        <c:choose>
                            <c:when test="${fn:contains(ctx, 'male') && !fn:contains(ctx, 'female')}">
                                <c:choose>
                                    <c:when test="${ctx != 'all_male'}">
                                        <li class="breadcrumb-item">
                                            <a href="${pageContext.request.contextPath}/productList/male">Men's Fashion</a>
                                        </li>
                                        <li class="breadcrumb-separator"><i class="bi bi-chevron-right"></i></li>
                                    </c:when>
                                    <c:otherwise>
                                        <li class="breadcrumb-item active" aria-current="page">Men's Fashion</li>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:when test="${fn:contains(ctx, 'female')}">
                                <c:choose>
                                    <c:when test="${ctx != 'all_female'}">
                                        <li class="breadcrumb-item">
                                            <a href="${pageContext.request.contextPath}/productList/female">Women's Fashion</a>
                                        </li>
                                        <li class="breadcrumb-separator"><i class="bi bi-chevron-right"></i></li>
                                    </c:when>
                                    <c:otherwise>
                                        <li class="breadcrumb-item active" aria-current="page">Women's Fashion</li>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                        </c:choose>

                        <c:if test="${ctx == 'male_tshirt'}"><li class="breadcrumb-item active">T-shirt</li></c:if>
                        <c:if test="${ctx == 'male_pant'}"><li class="breadcrumb-item active">Long Pants</li></c:if>
                        <c:if test="${ctx == 'male_short'}"><li class="breadcrumb-item active">Shorts</li></c:if>
                        
                        <c:if test="${ctx == 'female_tshirt'}"><li class="breadcrumb-item active">T-shirt</li></c:if>
                        <c:if test="${ctx == 'female_pant'}"><li class="breadcrumb-item active">Long Pants</li></c:if>
                        <c:if test="${ctx == 'female_dress'}"><li class="breadcrumb-item active">Dresses</li></c:if>
                    </ul>
                </nav>
            </div>

            <%-- === 2. FILTER TOOLBAR & BUTTONS === --%>
            <c:set var="currentSort1" value="${empty param.sort1 ? 'New' : param.sort1}" />
            <c:set var="currentSort2" value="${param.sort2}" />
            <c:set var="currentPrice" value="${param.priceRange}" />
            
            <c:set var="priceSortClass" value="" />
            <c:set var="priceSortIcon" value="bi-arrow-down-up" />
            <c:set var="nextPriceSort" value="Decrease" />
            
            <c:if test="${currentSort2 == 'Decrease'}">
                <c:set var="priceSortClass" value="active" />
                <c:set var="priceSortIcon" value="bi-sort-numeric-down-alt" />
                <c:set var="nextPriceSort" value="Increase" />
            </c:if>
            <c:if test="${currentSort2 == 'Increase'}">
                <c:set var="priceSortClass" value="active" />
                <c:set var="priceSortIcon" value="bi-sort-numeric-down" />
                <c:set var="nextPriceSort" value="" />
            </c:if>

            <div class="filter-container">
                <div class="toolbar-row">
                    
                    <%-- LEFT: CATEGORY PILLS --%>
                    <div class="category-pills">
                        <c:choose>
                            <c:when test="${fn:contains(ctx, 'male') && !fn:contains(ctx, 'female')}">
                                <a href="${pageContext.request.contextPath}/productList/male/t_shirt" 
                                   class="pill-btn ${ctx == 'male_tshirt' ? 'active' : ''}">T-shirt</a>
                                <a href="${pageContext.request.contextPath}/productList/male/pant" 
                                   class="pill-btn ${ctx == 'male_pant' ? 'active' : ''}">Long Pants</a>
                                <a href="${pageContext.request.contextPath}/productList/male/short" 
                                   class="pill-btn ${ctx == 'male_short' ? 'active' : ''}">Shorts</a>
                            </c:when>

                            <c:when test="${fn:contains(ctx, 'female')}">
                                <a href="${pageContext.request.contextPath}/productList/female/t_shirt" 
                                   class="pill-btn ${ctx == 'female_tshirt' ? 'active' : ''}">T-shirt</a>
                                <a href="${pageContext.request.contextPath}/productList/female/pant" 
                                   class="pill-btn ${ctx == 'female_pant' ? 'active' : ''}">Long Pants</a>
                                <a href="${pageContext.request.contextPath}/productList/female/dress" 
                                   class="pill-btn ${ctx == 'female_dress' ? 'active' : ''}">Dresses</a>
                            </c:when>
                        </c:choose>
                    </div>

                    <%-- RIGHT: SORTING --%>
                    <div class="filter-group-right">
                        <form action="${pageContext.request.contextPath}/sortProduct" method="get" id="filterForm" class="d-flex align-items-center gap-2">
                            <input type="hidden" name="context" value="${ctx}" id="inputContext" />
                            <input type="hidden" name="sort1" id="inputSort1" value="${currentSort1}" />
                            <input type="hidden" name="sort2" id="inputSort2" value="${currentSort2}" />
                            <input type="hidden" name="priceRange" id="inputPrice" value="${currentPrice}" />

                            <%-- New --%>
                            <a href="javascript:void(0)" onclick="applySort('sort1', 'New')" class="sort-btn ${currentSort1 == 'New' ? 'active' : ''}">New</a>
                            <%-- Best Seller --%>
                            <a href="javascript:void(0)" onclick="applySort('sort1', 'BestSeller')" class="sort-btn ${currentSort1 == 'BestSeller' ? 'active' : ''}">Best Seller</a>
                            
                            <%-- Đường dọc ngăn cách --%>
                            <span class="vertical-divider"></span>

                            <%-- Price Toggle --%>
                            <a href="javascript:void(0)" onclick="applySort('sort2', '${nextPriceSort}')" class="sort-btn ${priceSortClass}">
                                Price <i class="bi ${priceSortIcon}"></i>
                            </a>

                            <%-- Price Range Dropdown --%>
                            <div class="custom-select-wrapper">
                                <select id="priceSelect" class="form-control-custom" onchange="applySort('price', this.value)">
                                    <option value="" ${empty currentPrice ? 'selected' : ''}>All Prices (VND)</option>
                                    <option value="0-100000" ${currentPrice == '0-100000' ? 'selected' : ''}>&lt; 100.000</option>
                                    <option value="200000-300000" ${currentPrice == '200000-300000' ? 'selected' : ''}>200.000 - 300.000</option>
                                    <option value="300000-400000" ${currentPrice == '300000-400000' ? 'selected' : ''}>300.000 - 400.000</option>
                                    <option value="400000-500000" ${currentPrice == '400000-500000' ? 'selected' : ''}>400.000 - 500.000</option>
                                    <option value="500000+" ${currentPrice == '500000+' ? 'selected' : ''}>&gt; 500.000</option>
                                </select>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <%-- === 3. PRODUCT GRID === --%>
            <div id="page-loader" class="initial-loader">
                <div class="spinner"></div>
            </div>

            <div class="product-grid" id="product" style="display: none;">
                <c:choose>
                    <c:when test="${empty requestScope.productList}">
                        <div class="no-products-found">
                            <i class="bi bi-box2 no-products-icon"></i>
                            <p>Opps! There are no products that you are looking for...</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${requestScope.productList}" var="product">
                            <div class="product-card">
                                <div class="product-card__image-wrapper">
                                    <c:if test="${voucherMap[product.voucherID] > 0}">
                                        <div class="product-card__badge">-${voucherMap[product.voucherID]}%</div>
                                    </c:if>
                                    <a href="${pageContext.request.contextPath}/productDetail?id=${product.id}">
                                        <img class="product-card__image" src="${product.picURL}" alt="${product.name}">
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
                                    
                                    <c:set var="formattedPrice"><fmt:formatNumber type="number" value="${product.price}" pattern="###,###" /></c:set>
                                    <c:set var="formattedPrice2"><fmt:formatNumber type="number" value="${product.price - ((product.price * voucherMap[product.voucherID])/100)}" pattern="###,###" /></c:set>

                                    <div class="product-card__price">
                                        <%-- Đổi đơn vị tiền tệ --%>
                                        <span class="product-card__sale-price">${formattedPrice2} VND</span>
                                        <c:if test="${voucherMap[product.voucherID] > 0}">
                                            <span class="product-card__original-price">${formattedPrice} VND</span>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>

        </main>

        <%@ include file="footer.jsp" %>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        
        <script type="text/javascript">
            function applySort(key, value) {
                const form = document.getElementById('filterForm');
                
                if (value === 'New' || value === 'BestSeller') {
                    document.getElementById('inputSort1').value = value;
                    document.getElementById('inputSort2').value = ""; 
                    document.getElementById('inputPrice').value = "";
                }
                else if (key === 'sort2') { 
                    document.getElementById('inputSort2').value = value; 
                }
                else if (key === 'price') { 
                    document.getElementById('inputPrice').value = value; 
                }

                form.submit();
            }

            document.addEventListener("DOMContentLoaded", function() {
                var loader = document.getElementById('page-loader');
                var productGrid = document.getElementById('product');
                setTimeout(function() {
                    if (loader && productGrid) {
                        loader.style.display = 'none';
                        productGrid.style.display = 'grid';
                        productGrid.classList.add('fade-in-grid');
                    }
                }, 700); 
            });
        </script>
    </body>
</html>