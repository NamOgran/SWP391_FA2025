<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.text.DecimalFormat"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<fmt:setLocale value="vi_VN"/>

<%-- 1. Login Requirement --%>
<c:if test="${empty sessionScope.acc}">
    <c:redirect url="${pageContext.request.contextPath}/login.jsp"/>
</c:if>
<c:set var="acc" value="${sessionScope.acc}" />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order History | GIO</title>

    <%-- Bootstrap CSS --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <%-- Bootstrap Icons --%>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <%-- Font Family --%>
    <link href='https://fonts.googleapis.com/css?family=Quicksand:400,500,600,700&display=swap' rel='stylesheet'>
    <%-- Font-Awesome --%>
    <script src="https://kit.fontawesome.com/1bd876819f.js" crossorigin="anonymous"></script>

    <link rel="icon" href="${pageContext.request.contextPath}/images/LG2.png" type="image/x-icon">

    <style>
        :root {
            --primary-color: #a0816c;
            --primary-hover: #8c7362;
            --bg-overlay: rgba(255, 255, 255, 0.95);
            --glass-border: 1px solid rgba(255, 255, 255, 0.2);
            --shadow-soft: 0 10px 30px rgba(160, 129, 108, 0.15);
            --text-main: #5a5a5a;
        }

        body {
            font-family: 'Quicksand', sans-serif;
            background-image: url("${pageContext.request.contextPath}/images/BG2.jpeg");
            background-size: cover;
            background-attachment: fixed;
            background-position: center;
            color: var(--text-main);
            min-height: 100vh;
        }

        /* Footer fix */
        footer { background-color: #f8f9fa; position: relative; z-index: 10; }

        /* Scrollbar custom */
        body::-webkit-scrollbar { width: 8px; }
        body::-webkit-scrollbar-track { background: #f1f1f1; }
        body::-webkit-scrollbar-thumb { background: var(--primary-color); border-radius: 4px; }

        .main-content-wrapper {
            max-width: 1140px;
            margin: 50px auto;
            padding: 0 15px;
        }

        .page-header {
            text-align: center;
            margin-bottom: 40px;
            color: #fff;
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }
        .page-header h2 { font-weight: 700; letter-spacing: 1px; }

        /* === SIDEBAR STYLE === */
        .account-nav-card {
            background: var(--bg-overlay);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            box-shadow: var(--shadow-soft);
            overflow: hidden;
            border: var(--glass-border);
        }

        .account-user-mini {
            padding: 30px 20px;
            text-align: center;
            background: linear-gradient(135deg, var(--primary-color), #cbb4a3);
            color: white;
        }
        
        .avatar-circle {
            width: 80px;
            height: 80px;
            background: rgba(255,255,255,0.25);
            border-radius: 50%;
            margin: 0 auto 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            border: 2px solid rgba(255,255,255,0.5);
        }

        .account-nav { padding: 10px 0; margin: 0; list-style: none; }

        .account-nav-link {
            display: flex;
            align-items: center;
            padding: 15px 25px;
            color: var(--text-main);
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            border-left: 4px solid transparent;
        }

        .account-nav-link i { margin-right: 15px; width: 20px; text-align: center; font-size: 1.1rem; }
        
        .account-nav-link:hover {
            background-color: #fff8f3;
            color: var(--primary-color);
            padding-left: 30px;
        }

        .account-nav-link.active {
            background-color: #fff8f3;
            color: var(--primary-color);
            border-left-color: var(--primary-color);
        }

        /* === HISTORY MAIN CONTENT === */
        .history-wrapper {
            background: var(--bg-overlay);
            border-radius: 15px;
            box-shadow: var(--shadow-soft);
            padding: 30px;
            position: relative;
            min-height: 500px;
            border: var(--glass-border);
        }

        .section-header {
            border-bottom: 2px solid #eee;
            margin-bottom: 25px;
            padding-bottom: 10px;
        }
        .section-header h4 { font-weight: 700; color: var(--primary-color); margin: 0; }

        /* --- ORDER CARD --- */
        .order-card {
            background: #fff;
            border: 1px solid #ced4da; /* Viền xám */
            border-radius: 12px;
            margin-bottom: 20px;
            overflow: hidden;
            transition: box-shadow 0.3s, transform 0.2s;
        }
        .order-card:hover {
            box-shadow: 0 8px 20px rgba(0,0,0,0.08);
            transform: translateY(-3px);
            border-color: #b0b0b0;
        }

        /* Order Header */
        .order-header {
            background-color: #f8f9fa;
            padding: 15px 20px;
            border-bottom: 1px solid #e9ecef;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 10px;
        }
        
        .order-id { font-weight: 700; color: #333; font-size: 1.05rem; }
        .order-date { font-size: 0.9rem; color: #888; }
        
        /* Status Badges */
        .status-badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            letter-spacing: 0.5px;
            text-transform: uppercase;
        }
        .status-Delivered { background-color: #d1e7dd; color: #0f5132; border: 1px solid #badbcc; }
        .status-Cancelled { background-color: #f8d7da; color: #842029; border: 1px solid #f5c2c7; }

        /* Order Body - Căn Trái */
        .order-body { padding: 15px 20px; }
        .info-row { 
            display: flex; 
            justify-content: flex-start; /* Sát trái */
            align-items: baseline;
            margin-bottom: 8px; 
            font-size: 0.95rem; 
        }
        .info-label { 
            color: #888; 
            font-weight: 500;
            width: 80px; /* Độ rộng cố định */
            flex-shrink: 0;
            text-align: left;
        }
        .info-value { 
            color: #333; 
            font-weight: 600;
            text-align: left;
        }
        .total-price { color: #d32f2f; font-size: 1.1rem; font-weight: 700; }

        /* Actions */
        .order-actions {
            padding: 0 20px 15px;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }
        .btn-detail {
            border: 1px solid #ddd;
            background: white;
            color: #555;
            border-radius: 6px;
            padding: 6px 15px;
            font-size: 0.9rem;
            transition: all 0.2s;
        }
        .btn-detail:hover { background: #f5f5f5; color: var(--primary-color); border-color: var(--primary-color); }

        /* --- Product Dropdown Details (Inset Shadow) --- */
        .order-details-dropdown {
            background-color: #fafafa;
            border-top: 1px solid #dee2e6;
            padding: 0 20px;
            display: none; 
            /* Hiệu ứng lỏm sâu */
            box-shadow: inset 0 6px 8px -5px rgba(0,0,0,0.15);
        }
        
        .product-item {
            padding: 15px 0;
            border-bottom: 1px dashed #e0e0e0;
        }
        .product-item:last-child { border-bottom: none; }
        
        .product-img {
            width: 70px;
            height: 90px;
            object-fit: cover;
            border-radius: 6px;
            border: 1px solid #eee;
        }
        
        .product-name { font-weight: 700; color: #444; margin-bottom: 4px; font-size: 0.95rem; }
        .product-meta { font-size: 0.85rem; color: #777; margin-bottom: 2px; }
        
        .price-group { text-align: right; }
        .price-old { text-decoration: line-through; color: #999; font-size: 0.85rem; display: block; }
        .price-new { color: #d32f2f; font-weight: 600; font-size: 1rem; }

        /* Feedback Button in Detail List */
        .btn-feedback-sm {
            font-size: 0.8rem;
            padding: 4px 10px;
            border-radius: 4px;
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeeba;
            transition: all 0.2s;
            display: inline-block;
            margin-top: 5px;
            text-decoration: none;
        }
        .btn-feedback-sm:hover {
            background-color: #ffecb5;
            color: #6d5200;
        }

        /* Empty State */
        .empty-state { text-align: center; padding: 60px 20px; }
        .empty-icon { font-size: 4rem; color: #ddd; margin-bottom: 20px; }
        .empty-text { font-size: 1.1rem; color: #777; font-weight: 500; }

        /* Loading */
        .loading-container { display: flex; justify-content: center; align-items: center; min-height: 200px; width: 100%; }
        .spinner { width: 40px; height: 40px; border: 4px solid #f3f3f3; border-top: 4px solid var(--primary-color); border-radius: 50%; animation: spin 1s linear infinite; }
        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
        .fade-in { animation: fadeIn 0.4s ease-in-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

        /* Modal Rating */
        .star-rating { 
            display: flex;
            flex-direction: row-reverse; 
            justify-content: flex-end;   
            font-size: 1.8em; 
            cursor: pointer; 
            margin: 5px 0;
        }
        .star-rating input[type="radio"] { display: none; }
        .star-rating label { color: #ddd; padding: 0 5px; transition: color 0.2s; }
        .star-rating:not(:hover) input[type="radio"]:checked ~ label, 
        .star-rating:hover label:hover ~ label,
        .star-rating:hover label:hover { color: #ffc107; }
        .star-rating input[type="radio"]:checked ~ label { color: #ffc107; }
    </style>
</head>

<body>

    <%@ include file="header.jsp" %>

    <main class="main-content-wrapper">

        <div class="row g-4">
            
            <%-- === LEFT COLUMN: SIDEBAR === --%>
            <div class="col-lg-4 col-md-5">
                <div class="account-nav-card">
                    <div class="account-user-mini">
                        <div class="avatar-circle">
                            <i class="fa-solid fa-user"></i>
                        </div>
                        <h5 class="mb-1 fw-bold text-white">${acc.username}</h5>
                        <small class="text-white-50">Member</small>
                    </div>
                    <ul class="account-nav">
                        <li><a href="${pageContext.request.contextPath}/profile" class="account-nav-link"><i class="fa-solid fa-user-circle"></i> My Profile</a></li>
                        
                        <c:if test="${empty acc.google_id}">
                            <li><a href="${pageContext.request.contextPath}/changePassword.jsp" class="account-nav-link"><i class="fa-solid fa-key"></i> Change Password</a></li>
                        </c:if>

                        <li><a href="${pageContext.request.contextPath}/orderView" class="account-nav-link"><i class="fa-solid fa-box"></i> My Orders</a></li>
                        <li><a href="${pageContext.request.contextPath}/orderHistoryView" class="account-nav-link active"><i class="fa-solid fa-clock-rotate-left"></i> Order History</a></li>
                        <li><a href="${pageContext.request.contextPath}/cookieHandle" class="account-nav-link text-danger" onclick="return confirm('Do you want to sign out?')"><i class="fa-solid fa-right-from-bracket"></i> Sign Out</a></li>
                    </ul>
                </div>
            </div>

            <%-- === RIGHT COLUMN: CONTENT === --%>
            <div class="col-lg-8 col-md-7">
                <div class="history-wrapper">
    
    <%-- HEADER CHUNG --%>
    <div class="section-header">
        <h4><i class="bi bi-clock-history"></i> Order History</h4>
    </div>

    <%-- LOADING SPINNER --%>
    <div id="loading-indicator" class="loading-container">
        <div class="spinner"></div>
    </div>

    <%-- CONTENT AREA --%>
    <div id="order-content-area" style="display: none;">

        <%-- A. ĐẾM SỐ LƯỢNG (Chỉ đếm Delivered và Cancelled) --%>
        <c:set var="countDelivered" value="0" />
        <c:set var="countCancelled" value="0" />

        <c:forEach items="${requestScope.ordersUserList}" var="o">
            <%-- CHỈ NHẬN TRẠNG THÁI 'Delivered' --%>
            <c:if test="${o.status eq 'Delivered'}">
                <c:set var="countDelivered" value="${countDelivered + 1}" />
            </c:if>
            <c:if test="${o.status eq 'Cancelled'}">
                <c:set var="countCancelled" value="${countCancelled + 1}" />
            </c:if>
        </c:forEach>

        <%-- B. KIỂM TRA EMPTY STATE --%>
        <c:choose>
            <c:when test="${countDelivered == 0 && countCancelled == 0}">
                <div class="empty-state">
                    <i class="bi bi-inbox empty-icon"></i>
                    <p class="empty-text">You have no order history yet.</p>
                    <a href="${pageContext.request.contextPath}/menu" class="btn btn-outline-secondary mt-2">Start Shopping</a>
                </div>
            </c:when>

            <c:otherwise>
                
                <%-- C. SECTION: DELIVERED ORDERS --%>
                <c:if test="${countDelivered > 0}">
                    <%-- SỬA TIÊU ĐỀ THÀNH DELIVERED --%>
                    <h5 class="text-success fw-bold mb-3 mt-2 border-bottom pb-2">
                        <i class="bi bi-check-circle-fill"></i> Delivered Orders (${countDelivered})
                    </h5>
                    
                    <c:forEach items="${requestScope.ordersUserList}" var="o">
                        <%-- CHỈ HIỂN THỊ NẾU STATUS LÀ 'Delivered' --%>
                        <c:if test="${o.status eq 'Delivered'}">
                            
                            <%-- START CARD (DELIVERED) --%>
                            <div class="order-card fade-in">
                                <div class="order-header">
                                    <div>
                                        <span class="order-id">Order #${o.orderID}</span>
                                        <div class="order-date"><i class="bi bi-calendar-check"></i> ${o.date}</div>
                                    </div>
                                    <span class="status-badge status-Delivered">Delivered</span>
                                </div>
                                <div class="order-body">
                                    <div class="row">
                                        <div class="col-md-7">
                                            <div class="info-row">
                                                <span class="info-label">Address:</span>
                                                <span class="info-value text-truncate" style="max-width: 80%;" title="${o.address}">${o.address}</span>
                                            </div>
                                            <div class="info-row">
                                                <span class="info-label">Items:</span>
                                                <span class="info-value">${totalQuantityMap[o.orderID]} product(s)</span>
                                            </div>
                                        </div>
                                        <div class="col-md-5 text-md-end text-start mt-2 mt-md-0">
                                            <span class="info-label d-block w-100 text-md-end text-start mb-1">Total Amount</span>
                                            <c:set var="formattedTotal"><fmt:formatNumber value="${o.total}" type="number"/></c:set>
                                            <span class="total-price text-success">${formattedTotal} VND</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="order-actions">
                                    <button class="btn-detail" id="btn-${o.orderID}" onclick="toggleDetails(${o.orderID})">
                                        Detail <i class="bi bi-chevron-down"></i>
                                    </button>
                                </div>
                                
                                <%-- Dropdown Details --%>
                                <div class="order-details-dropdown" id="dd-${o.orderID}">
                                    <c:forEach items="${requestScope.orderDetailList}" var="d">
                                        <c:if test="${d.orderID eq o.orderID}">
                                            <c:set var="pId" value="${d.productID}"/>
                                            <c:set var="pPrice" value="${priceP[pId]}"/>
                                            <c:set var="pVoucherId" value="${voucherID[pId]}"/>
                                            <c:set var="pVoucherPct" value="${voucherMap[pVoucherId] != null ? voucherMap[pVoucherId] : 0}"/>
                                            <c:set var="unitDisc" value="${pPrice - (pPrice * pVoucherPct)/100}"/>
                                            <c:set var="lineDisc" value="${unitDisc * d.quantity}"/>
                                            <c:set var="lineOrig" value="${pPrice * d.quantity}"/>

                                            <div class="product-item">
                                                <div class="row align-items-center">
                                                    <div class="col-auto">
                                                        <img src="${picUrlMap[d.productID]}" class="product-img" alt="Product">
                                                    </div>
                                                    <div class="col">
                                                        <div class="product-name">${nameProduct[d.productID]}</div>
                                                        <div class="product-meta">Size: <strong>${d.size_name}</strong> | Qty: <strong>${d.quantity}</strong></div>
                                                    </div>
                                                    <div class="col-auto price-group text-end">
                                                        <c:if test="${lineOrig > lineDisc}">
                                                            <span class="price-old"><fmt:formatNumber value="${lineOrig}" type="number"/> VND</span>
                                                        </c:if>
                                                        <span class="price-new d-block"><fmt:formatNumber value="${lineDisc}" type="number"/> VND</span>
                                                        
                                                        <%-- Feedback Button Logic --%>
                                                        <div class="mt-2">
                                                            <c:set var="mapKey" value="${o.orderID}_${d.productID}" />
                                                            <c:choose>
                                                                <c:when test="${reviewedMap[mapKey]}">
                                                                    <button class="btn btn-secondary btn-sm" disabled style="font-size: 0.75rem; opacity: 0.7;">
                                                                        <i class="bi bi-check-all"></i> Reviewed
                                                                    </button>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <button class="btn-feedback-sm" 
                                                                            type="button"
                                                                            data-bs-toggle="modal" 
                                                                            data-bs-target="#feedbackModal" 
                                                                            data-product-id="${d.productID}" 
                                                                            data-order-id="${o.orderID}"
                                                                            data-product-name="${nameProduct[d.productID]}">
                                                                        <i class="bi bi-star-fill"></i> Review
                                                                    </button>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                    <div class="pb-3"></div>
                                </div>
                            </div>
                            <%-- END CARD --%>
                        </c:if>
                    </c:forEach>
                </c:if>

                <%-- KHOẢNG CÁCH GIỮA 2 MỤC --%>
                <c:if test="${countDelivered > 0 && countCancelled > 0}">
                    <div class="mb-5"></div>
                </c:if>

                <%-- D. SECTION: CANCELLED ORDERS --%>
                <c:if test="${countCancelled > 0}">
                    <h5 class="text-danger fw-bold mb-3 mt-2 border-bottom pb-2">
                        <i class="bi bi-x-circle-fill"></i> Cancelled Orders (${countCancelled})
                    </h5>

                    <c:forEach items="${requestScope.ordersUserList}" var="o">
                        <c:if test="${o.status eq 'Cancelled'}">
                            <%-- START CARD (CANCELLED) --%>
                            <div class="order-card fade-in" style="border-color: #f5c2c7;">
                                <div class="order-header" style="background-color: #fff5f5;">
                                    <div>
                                        <span class="order-id text-muted">Order #${o.orderID}</span>
                                        <div class="order-date"><i class="bi bi-calendar-x"></i> ${o.date}</div>
                                    </div>
                                    <span class="status-badge status-Cancelled">Cancelled</span>
                                </div>
                                <div class="order-body" style="opacity: 0.8;">
                                    <div class="row">
                                        <div class="col-md-7">
                                            <div class="info-row">
                                                <span class="info-label">Address:</span>
                                                <span class="info-value text-truncate" style="max-width: 80%;" title="${o.address}">${o.address}</span>
                                            </div>
                                            <div class="info-row">
                                                <span class="info-label">Items:</span>
                                                <span class="info-value">${totalQuantityMap[o.orderID]} product(s)</span>
                                            </div>
                                        </div>
                                        <div class="col-md-5 text-md-end text-start mt-2 mt-md-0">
                                            <span class="info-label d-block w-100 text-md-end text-start mb-1">Total Amount</span>
                                            <c:set var="formattedTotal"><fmt:formatNumber value="${o.total}" type="number"/></c:set>
                                            <span class="total-price text-muted" style="text-decoration: line-through;">${formattedTotal} VND</span>
                                        </div>
                                    </div>
                                </div>
                                <div class="order-actions">
                                    <button class="btn-detail" id="btn-${o.orderID}" onclick="toggleDetails(${o.orderID})">
                                        Detail <i class="bi bi-chevron-down"></i>
                                    </button>
                                </div>
                                
                                <div class="order-details-dropdown" id="dd-${o.orderID}">
                                    <c:forEach items="${requestScope.orderDetailList}" var="d">
                                        <c:if test="${d.orderID eq o.orderID}">
                                            <c:set var="pId" value="${d.productID}"/>
                                            <c:set var="pPrice" value="${priceP[pId]}"/>
                                            <c:set var="pVoucherId" value="${voucherID[pId]}"/>
                                            <c:set var="pVoucherPct" value="${voucherMap[pVoucherId] != null ? voucherMap[pVoucherId] : 0}"/>
                                            <c:set var="unitDisc" value="${pPrice - (pPrice * pVoucherPct)/100}"/>
                                            <c:set var="lineDisc" value="${unitDisc * d.quantity}"/>
                                            
                                            <div class="product-item">
                                                <div class="row align-items-center">
                                                    <div class="col-auto">
                                                        <img src="${picUrlMap[d.productID]}" class="product-img" alt="Product" style="filter: grayscale(100%);">
                                                    </div>
                                                    <div class="col">
                                                        <div class="product-name text-muted">${nameProduct[d.productID]}</div>
                                                        <div class="product-meta">Size: ${d.size_name} | Qty: ${d.quantity}</div>
                                                    </div>
                                                    <div class="col-auto text-end">
                                                        <span class="price-new text-muted"><fmt:formatNumber value="${lineDisc}" type="number"/> VND</span>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:if>
                                    </c:forEach>
                                    <div class="pb-3"></div>
                                </div>
                            </div>
                            <%-- END CARD --%>
                        </c:if>
                    </c:forEach>
                </c:if>

            </c:otherwise>
        </c:choose>
    </div>
</div>
            </div>
        </div>
    </main>

    <%-- FEEDBACK MODAL --%>
    <div class="modal fade" id="feedbackModal" tabindex="-1" aria-labelledby="feedbackModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered"> 
            <div class="modal-content border-0 shadow-lg">
                <div class="modal-header bg-light">
                    <h5 class="modal-title fw-bold" id="feedbackModalLabel" style="color: var(--primary-color);">Product Feedback</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <form id="feedbackForm">
                        <input type="hidden" id="modal_product_id" name="productId">
                        <input type="hidden" id="modal_order_id" name="orderId">
                        
                        <div class="form-group mb-4 text-center">
                            <label class="mb-2 fw-bold text-muted">Rate this product</label>
                            <div class="star-rating justify-content-center">
                                <input type="radio" id="star5" name="rating" value="5"><label for="star5" class="fas fa-star" title="Excellent"></label>
                                <input type="radio" id="star4" name="rating" value="4"><label for="star4" class="fas fa-star" title="Good"></label>
                                <input type="radio" id="star3" name="rating" value="3"><label for="star3" class="fas fa-star" title="Average"></label>
                                <input type="radio" id="star2" name="rating" value="2"><label for="star2" class="fas fa-star" title="Poor"></label>
                                <input type="radio" id="star1" name="rating" value="1" required><label for="star1" class="fas fa-star" title="Terrible"></label>
                            </div>
                        </div>
                        
                        <div class="form-group mb-3">
                            <label for="comment" class="fw-bold text-muted mb-2">Your Review</label>
                            <textarea id="comment" name="comment" class="form-control" rows="3" placeholder="Share your experience..."></textarea>
                        </div>
                        <div id="feedbackMessage" class="mt-2 text-center fw-bold"></div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" id="submitFeedbackBtn" class="btn" style="background-color: var(--primary-color); color: white;">Submit Feedback</button>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="footer.jsp" %>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>

    <script type="text/javascript">
        // Loading
        $(document).ready(function() {
            setTimeout(function() {
                $('#loading-indicator').hide();
                $('#order-content-area').fadeIn(400);
            }, 600);
        });

        // Toggle Details
        function toggleDetails(orderId) {
            const box = $('#dd-' + orderId);
            const btn = $('#btn-' + orderId);
            
            box.slideToggle(300);
            
            if (btn.html().includes('chevron-down')) {
                btn.html('Hide <i class="bi bi-chevron-up"></i>');
            } else {
                btn.html('Detail <i class="bi bi-chevron-down"></i>');
            }
        }

        // Feedback Logic
        const feedbackModal = document.getElementById('feedbackModal');
        const feedbackForm = document.getElementById('feedbackForm');
        const submitFeedbackBtn = document.getElementById('submitFeedbackBtn');
        const feedbackMessage = document.getElementById('feedbackMessage');
        const feedbackModalLabel = document.getElementById('feedbackModalLabel');

        feedbackModal.addEventListener('show.bs.modal', function (event) {
            const button = event.relatedTarget;
            const productId = button.getAttribute('data-product-id');
            const orderId = button.getAttribute('data-order-id');
            const productName = button.getAttribute('data-product-name');
            
            feedbackModalLabel.innerText = "Feedback: " + productName;
            document.getElementById('modal_product_id').value = productId;
            document.getElementById('modal_order_id').value = orderId;
            
            // Reset Form
            feedbackForm.reset();
            feedbackMessage.innerHTML = '';
            submitFeedbackBtn.disabled = false;
        });

        submitFeedbackBtn.addEventListener('click', function () {
            const productId = document.getElementById('modal_product_id').value;
            const orderId = document.getElementById('modal_order_id').value;
            const comment = document.getElementById('comment').value;
            const ratingInput = document.querySelector('input[name="rating"]:checked');

            if (!ratingInput) {
                feedbackMessage.innerHTML = '<span class="text-danger">Please select a star rating.</span>';
                return;
            }

            const rating = ratingInput.value;
            const data = { productId: parseInt(productId), orderId: parseInt(orderId), rating: parseInt(rating), comment: comment };

            submitFeedbackBtn.disabled = true;
            feedbackMessage.innerHTML = '<span class="text-primary">Sending...</span>';

            fetch('${pageContext.request.contextPath}/feedback', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(data)
            })
            .then(response => response.json())
            .then(result => {
                if (result.status === "success") {
                    feedbackMessage.innerHTML = '<span class="text-success">Thank you for your feedback!</span>';
                    setTimeout(() => {
                        const modalInstance = bootstrap.Modal.getInstance(feedbackModal);
                        modalInstance.hide();
                    }, 2000);
                } else {
                    feedbackMessage.innerHTML = '<span class="text-danger">' + result.message + '</span>';
                    submitFeedbackBtn.disabled = false;
                }
            })
            .catch(error => {
                console.error('Error:', error);
                feedbackMessage.innerHTML = '<span class="text-danger">Server connection error.</span>';
                submitFeedbackBtn.disabled = false;
            });
        });
    </script>
</body>
</html>