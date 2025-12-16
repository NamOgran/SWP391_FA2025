<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
    <title>My Orders | GIO</title>

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

        /* === SIDEBAR STYLE (STICKY) === */
        .account-nav-card {
            background: var(--bg-overlay);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            box-shadow: var(--shadow-soft);
            overflow: hidden;
            border: var(--glass-border);
            
            position: -webkit-sticky;
            position: sticky;
            top: 150px;
            z-index: 90;
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
            justify-content: space-between; /* Đẩy badge sang phải */
        }

        .account-nav-link > div { display: flex; align-items: center; } /* Wrapper cho icon + text */
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

        /* Badge trong Sidebar */
        .badge-sidebar {
            background-color: #dc3545;
            color: white;
            border-radius: 50%;
            padding: 2px 8px;
            font-size: 0.8rem;
        }

        /* === ORDER MAIN CONTENT === */
        .orders-wrapper {
            background: var(--bg-overlay);
            border-radius: 15px;
            box-shadow: var(--shadow-soft);
            padding: 20px;
            min-height: 500px;
            border: var(--glass-border);
        }

        /* TABS STYLE */
        .nav-tabs { border-bottom: 2px solid #eee; }
        .nav-link {
            color: #777;
            font-weight: 600;
            border: none;
            background: transparent;
            padding: 15px 20px;
            font-size: 1.05rem;
            transition: 0.3s;
        }
        .nav-link:hover { color: var(--primary-color); }
        .nav-link.active {
            color: var(--primary-color) !important;
            border-bottom: 3px solid var(--primary-color) !important;
            background: transparent !important;
        }

        /* FILTER BAR */
        .filter-bar {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            align-items: center;
        }
        .search-input-group { flex-grow: 1; position: relative; }
        .search-input-group i { position: absolute; left: 15px; top: 50%; transform: translateY(-50%); color: #999; }
        .form-control-search {
            padding-left: 40px;
            border-radius: 20px;
            border: 1px solid #ddd;
        }
        .form-control-date { border-radius: 20px; border: 1px solid #ddd; width: auto; }

        /* === OLD ORDER CARD STYLE === */
        .order-card {
            background: #fff;
            border: 1px solid #ced4da; /* Viền xám rõ ràng */
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
        }
        .order-id { font-weight: 700; color: #333; font-size: 1.05rem; }
        .order-date { font-size: 0.9rem; color: #888; margin-top: 2px; }
        
        .status-badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
        }
        .status-Pending { background-color: #fff8e1; color: #f57c00; border: 1px solid #ffe0b2; }
        .status-Delivering { background-color: #e0f2f1; color: #00897b; border: 1px solid #b2dfdb; }

        /* Order Body (Giao diện cũ) */
        .order-body { padding: 15px 20px; }
        .info-row { display: flex; margin-bottom: 8px; font-size: 0.95rem; }
        .info-label { color: #888; font-weight: 500; width: 80px; flex-shrink: 0; }
        .info-value { color: #333; font-weight: 600; }
        .total-price { color: #d32f2f; font-size: 1.1rem; font-weight: 700; }

        /* Order Actions */
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
        
        /* STYLE CHO NÚT CANCEL */
        .btn-cancel {
            border: 1px solid #dc3545;
            background: white;
            color: #dc3545;
            border-radius: 6px;
            padding: 6px 15px;
            font-size: 0.9rem;
            transition: all 0.2s;
            text-decoration: none; /* Vì là thẻ a */
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        .btn-cancel:hover {
            background: #dc3545;
            color: white;
        }

        .btn-received {
            background-color: var(--primary-color);
            color: white;
            border: none;
            border-radius: 6px;
            padding: 6px 15px;
            font-size: 0.9rem;
            font-weight: 500;
            transition: all 0.2s;
        }
        .btn-received:hover { background-color: var(--primary-hover); color: white; }

        /* Dropdown Details */
        .order-details-dropdown {
            background-color: #fafafa;
            border-top: 1px solid #dee2e6;
            padding: 0 20px;
            display: none;
            box-shadow: inset 0 6px 8px -5px rgba(0,0,0,0.15);
        }
        .product-item { padding: 15px 0; border-bottom: 1px dashed #e0e0e0; }
        .product-item:last-child { border-bottom: none; }
        .product-img { width: 60px; height: 75px; object-fit: cover; border-radius: 6px; border: 1px solid #eee; }
        .product-name { font-weight: 700; color: #444; margin-bottom: 4px; font-size: 0.95rem; }
        .product-meta { font-size: 0.85rem; color: #777; margin-bottom: 2px; }
        .price-new { color: #d32f2f; font-weight: 600; font-size: 1rem; }
        .price-old { text-decoration: line-through; color: #999; font-size: 0.85rem; }

        /* Empty State */
        .empty-state { text-align: center; padding: 60px 20px; }
        .empty-icon { font-size: 4rem; color: #ddd; margin-bottom: 20px; }
        .empty-text { font-size: 1.1rem; color: #777; font-weight: 500; }

        /* Back to Top */
        #btn-back-to-top {
            position: fixed; bottom: 30px; right: 30px; display: none;
            background-color: var(--primary-color); color: white; border: none;
            width: 50px; height: 50px; border-radius: 50%; font-size: 1.5rem;
            z-index: 100; cursor: pointer; box-shadow: 0 4px 10px rgba(0,0,0,0.3);
            transition: all 0.3s;
        }
        #btn-back-to-top:hover { background-color: var(--primary-color); transform: translateY(-5px); }
    </style>
</head>

<body>

    <%@ include file="header.jsp" %>

    <main class="main-content-wrapper">
        
        <%-- POPUP MESSAGE (nếu có từ controller trả về) --%>
        <c:if test="${not empty sessionScope.popupMessage}">
            <div class="alert alert-info alert-dismissible fade show mb-4" role="alert">
                ${sessionScope.popupMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <%-- Xóa session message sau khi hiển thị --%>
            <c:remove var="popupMessage" scope="session"/>
        </c:if>

        <%-- 1. PRE-CALCULATE COUNTS --%>
        <c:set var="countPending" value="0" />
        <c:set var="countDelivering" value="0" />
        <c:set var="countDelivered" value="0" /> 
        <c:set var="countCancelled" value="0" /> 

        <c:forEach items="${requestScope.ordersUserList}" var="o">
            <c:if test="${o.status eq 'Pending'}"><c:set var="countPending" value="${countPending + 1}" /></c:if>
            <c:if test="${o.status eq 'Delivering'}"><c:set var="countDelivering" value="${countDelivering + 1}" /></c:if>
            
            <c:if test="${o.status eq 'Delivered' || o.status eq 'Completed'}"><c:set var="countDelivered" value="${countDelivered + 1}" /></c:if>
            <c:if test="${o.status eq 'Cancelled'}"><c:set var="countCancelled" value="${countCancelled + 1}" /></c:if>
        </c:forEach>
        
        <%-- TÍNH TỔNG ĐƠN ĐANG XỬ LÝ (MY ORDERS) --%>
        <c:set var="totalActive" value="${countPending + countDelivering}" />
        
        <%-- TÍNH TỔNG ĐƠN LỊCH SỬ (ORDER HISTORY) --%>
        <c:set var="totalHistory" value="${countDelivered + countCancelled}" />

        <div class="row g-4">
            
            <%-- === LEFT COLUMN: SIDEBAR (STICKY) === --%>
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
                        <li>
                            <a href="${pageContext.request.contextPath}/profile" class="account-nav-link">
                                <div><i class="fa-solid fa-user-circle"></i> My Profile</div>
                            </a>
                        </li>
                        
                        <c:if test="${empty acc.google_id}">
                            <li>
                                <a href="${pageContext.request.contextPath}/changePassword.jsp" class="account-nav-link">
                                    <div><i class="fa-solid fa-key"></i> Change Password</div>
                                </a>
                            </li>
                        </c:if>

                        <li>
                            <a href="${pageContext.request.contextPath}/orderView" class="account-nav-link active">
                                <div><i class="fa-solid fa-box"></i> My Orders</div>
                                <%-- SIDEBAR COUNT (ACTIVE) --%>
                                <c:if test="${totalActive > 0}">
                                    <span class="badge-sidebar">${totalActive}</span>
                                </c:if>
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/orderHistoryView" class="account-nav-link">
                                <div><i class="fa-solid fa-clock-rotate-left"></i> Order History</div>
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/cookieHandle" class="account-nav-link text-danger" onclick="return confirm('Do you want to sign out?')">
                                <div><i class="fa-solid fa-right-from-bracket"></i> Sign Out</div>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>

            <%-- === RIGHT COLUMN: ORDER CONTENT === --%>
            <div class="col-lg-8 col-md-7">
                <div class="orders-wrapper">
                    
                    <%-- TABS HEADER --%>
                    <ul class="nav nav-tabs nav-fill" id="orderTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="pending-tab" data-bs-toggle="tab" data-bs-target="#pending" type="button" role="tab" aria-controls="pending" aria-selected="true">
                                <i class="bi bi-hourglass-split"></i> Pending (${countPending})
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="delivering-tab" data-bs-toggle="tab" data-bs-target="#delivering" type="button" role="tab" aria-controls="delivering" aria-selected="false">
                                <i class="bi bi-truck"></i> Delivering (${countDelivering})
                            </button>
                        </li>
                    </ul>

                    <div class="tab-content pt-4" id="orderTabsContent">
                        
                        <%-- TAB 1: PENDING --%>
                        <div class="tab-pane fade show active" id="pending" role="tabpanel" aria-labelledby="pending-tab">
                            
                            <%-- SEARCH BAR PENDING --%>
                            <div class="filter-bar">
                                <div class="search-input-group">
                                    <i class="bi bi-search"></i>
                                    <input type="text" id="searchPending" class="form-control form-control-search" placeholder="Search by Order ID or Product Name...">
                                </div>
                                <input type="date" id="datePending" class="form-control form-control-date">
                            </div>

                            <div id="pending-list">
                                <c:if test="${countPending == 0}">
                                    <div class="empty-state">
                                        <i class="bi bi-clipboard-x empty-icon"></i>
                                        <p class="empty-text">No pending orders found.</p>
                                        <a href="${pageContext.request.contextPath}" class="btn btn-outline-secondary mt-2">Go Shopping</a>
                                    </div>
                                </c:if>

                                <c:forEach items="${requestScope.ordersUserList}" var="o">
                                    <c:if test="${o.status eq 'Pending'}">
                                        <%-- DATA ATTRIBUTE ĐỂ SEARCH: ID + TÊN SP --%>
                                        <c:set var="searchString" value="${o.orderID}" />
                                        <c:forEach items="${orderDetailList}" var="d">
                                            <c:if test="${d.orderID eq o.orderID}">
                                                <c:set var="searchString" value="${searchString} ${nameProduct[d.productID]}" />
                                            </c:if>
                                        </c:forEach>

                                        <div class="order-card order-item-pending" data-search="${searchString.toLowerCase()}" data-date="${o.date}">
                                            <div class="order-header">
                                                <div>
                                                    <span class="order-id"><i class="fa-solid fa-box"></i> Order #${o.orderID}</span>
                                                    <div class="order-date"><i class="bi bi-calendar3"></i> ${o.date}</div>
                                                </div>
                                                <span class="status-badge status-Pending">
                                                    <i class="bi bi-hourglass-split"></i> Pending
                                                </span>
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
                                                        <span class="total-price">${formattedTotal} VND</span>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="order-actions">
                                                <%-- [ADDED] BUTTON CANCEL FOR PENDING --%>
                                                <a href="${pageContext.request.contextPath}/cancelOrder?orderId=${o.orderID}" 
                                                   class="btn-cancel" 
                                                   onclick="return confirm('Are you sure you want to cancel Order #${o.orderID}?');">
                                                    <i class="bi bi-x-circle"></i> Cancel Order
                                                </a>

                                                <button class="btn-detail" id="btn-${o.orderID}" onclick="toggleDetails(${o.orderID})">
                                                    Detail <i class="bi bi-chevron-down"></i>
                                                </button>
                                            </div>

                                            <%-- Dropdown Details --%>
                                            <div class="order-details-dropdown" id="dd-${o.orderID}">
                                                <c:forEach items="${orderDetailList}" var="d">
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
                                                                    <img src="${picUrlMap[pId]}" class="product-img" alt="Product">
                                                                </div>
                                                                <div class="col">
                                                                    <div class="product-name">${nameProduct[pId]}</div>
                                                                    <div class="product-meta">Size: <strong>${d.size_name}</strong> | Qty: <strong>${d.quantity}</strong></div>
                                                                </div>
                                                                <div class="col-auto text-end">
                                                                    <c:if test="${lineOrig > lineDisc}">
                                                                        <span class="price-old"><fmt:formatNumber value="${lineOrig}" type="number"/> VND</span>
                                                                    </c:if>
                                                                    <div class="price-new"><fmt:formatNumber value="${lineDisc}" type="number"/> VND</div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:if>
                                                </c:forEach>
                                                <div class="pb-3"></div>
                                            </div>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </div>

                        <%-- TAB 2: DELIVERING --%>
                        <div class="tab-pane fade" id="delivering" role="tabpanel" aria-labelledby="delivering-tab">
                            
                            <%-- SEARCH BAR DELIVERING --%>
                            <div class="filter-bar">
                                <div class="search-input-group">
                                    <i class="bi bi-search"></i>
                                    <input type="text" id="searchDelivering" class="form-control form-control-search" placeholder="Search by Order ID or Product Name...">
                                </div>
                                <input type="date" id="dateDelivering" class="form-control form-control-date">
                            </div>

                            <div id="delivering-list">
                                <c:if test="${countDelivering == 0}">
                                    <div class="empty-state">
                                        <i class="bi bi-truck empty-icon"></i>
                                        <p class="empty-text">No orders are currently being delivered.</p>
                                        <a href="${pageContext.request.contextPath}" class="btn btn-outline-secondary mt-2">Go Shopping</a>
                                    </div>
                                </c:if>

                                <c:forEach items="${requestScope.ordersUserList}" var="o">
                                    <c:if test="${o.status eq 'Delivering'}">
                                        <%-- DATA ATTRIBUTE ĐỂ SEARCH --%>
                                        <c:set var="searchStringDel" value="${o.orderID}" />
                                        <c:forEach items="${orderDetailList}" var="d">
                                            <c:if test="${d.orderID eq o.orderID}">
                                                <c:set var="searchStringDel" value="${searchStringDel} ${nameProduct[d.productID]}" />
                                            </c:if>
                                        </c:forEach>

                                        <div class="order-card order-item-delivering" data-search="${searchStringDel.toLowerCase()}" data-date="${o.date}">
                                            <div class="order-header">
                                                <div>
                                                    <span class="order-id"><i class="fa-solid fa-box"></i> Order #${o.orderID}</span>
                                                    <div class="order-date"><i class="bi bi-calendar3"></i> ${o.date}</div>
                                                </div>
                                                <span class="status-badge status-Delivering">
                                                    <i class="bi bi-truck"></i> Delivering
                                                </span>
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
                                                        <span class="total-price">${formattedTotal} VND</span>
                                                    </div>
                                                </div>
                                            </div>

                                            <div class="order-actions">
                                                <%-- [REMOVED] Nút Received đã bị xóa theo yêu cầu --%>
                                                
                                                <button class="btn-detail" id="btn-${o.orderID}" onclick="toggleDetails(${o.orderID})">
                                                    Detail <i class="bi bi-chevron-down"></i>
                                                </button>
                                            </div>

                                            <%-- Dropdown Details --%>
                                            <div class="order-details-dropdown" id="dd-${o.orderID}">
                                                <c:forEach items="${orderDetailList}" var="d">
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
                                                                    <img src="${picUrlMap[pId]}" class="product-img" alt="Product">
                                                                </div>
                                                                <div class="col">
                                                                    <div class="product-name">${nameProduct[pId]}</div>
                                                                    <div class="product-meta">Size: <strong>${d.size_name}</strong> | Qty: <strong>${d.quantity}</strong></div>
                                                                </div>
                                                                <div class="col-auto text-end">
                                                                    <c:if test="${lineOrig > lineDisc}">
                                                                        <span class="price-old"><fmt:formatNumber value="${lineOrig}" type="number"/> VND</span>
                                                                    </c:if>
                                                                    <div class="price-new"><fmt:formatNumber value="${lineDisc}" type="number"/> VND</div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:if>
                                                </c:forEach>
                                                <div class="pb-3"></div>
                                            </div>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </main>
        
    <button type="button" class="btn" id="btn-back-to-top">
        <i class="bi bi-arrow-up"></i>
    </button>

    <%@ include file="footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script>
        const BASE = '${pageContext.request.contextPath}';

        // Toggle Details Function
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

        // --- FILTER FUNCTION (Client-Side) ---
        function filterOrders(searchInputId, dateInputId, itemClass) {
            const searchText = $(searchInputId).val().toLowerCase();
            const searchDate = $(dateInputId).val(); // yyyy-mm-dd

            $(itemClass).each(function() {
                const card = $(this);
                const dataSearch = card.attr('data-search'); // ID + Product Names
                const dataDate = card.attr('data-date'); // yyyy-mm-dd

                let matchText = dataSearch.includes(searchText);
                let matchDate = true;

                if (searchDate) {
                    matchDate = (dataDate === searchDate);
                }

                if (matchText && matchDate) {
                    card.show();
                } else {
                    card.hide();
                }
            });
        }

        // Attach Events for Pending Tab
        $('#searchPending, #datePending').on('input change', function() {
            filterOrders('#searchPending', '#datePending', '.order-item-pending');
        });

        // Attach Events for Delivering Tab
        $('#searchDelivering, #dateDelivering').on('input change', function() {
            filterOrders('#searchDelivering', '#dateDelivering', '.order-item-delivering');
        });

        // Back to Top
        let mybutton = document.getElementById("btn-back-to-top");
        window.onscroll = function () {
            if (document.body.scrollTop > 300 || document.documentElement.scrollTop > 300) {
                mybutton.style.display = "block";
            } else {
                mybutton.style.display = "none";
            }
        };
        mybutton.addEventListener("click", function() {
            document.body.scrollTop = 0;
            document.documentElement.scrollTop = 0;
        });
    </script>
</body>
</html>