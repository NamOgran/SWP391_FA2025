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

        /* === ORDER MAIN CONTENT === */
        .orders-wrapper {
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

        /* --- SINGLE ORDER CARD (Sửa theo yêu cầu) --- */
        .order-card {
            background: #fff;
            /* Thêm viền xám rõ ràng */
            border: 1px solid #ced4da; 
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
        
        .status-badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            letter-spacing: 0.5px;
            text-transform: uppercase;
        }
        .status-Pending { background-color: #fff8e1; color: #f57c00; border: 1px solid #ffe0b2; }
        .status-Delivering { background-color: #e0f2f1; color: #00897b; border: 1px solid #b2dfdb; }

        /* Order Body (Sửa căn trái) */
        .order-body { padding: 15px 20px; }
        
        /* Căn chỉnh lại Address và Items sát trái */
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
            width: 80px; /* Độ rộng cố định cho nhãn để thẳng hàng */
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

        .btn-received {
            background-color: var(--primary-color);
            color: white;
            border: none;
            border-radius: 6px;
            padding: 6px 15px;
            font-size: 0.9rem;
            transition: all 0.2s;
            font-weight: 500;
        }
        .btn-received:hover { background-color: var(--primary-hover); color: white; transform: translateY(-1px); }

        /* --- Product Dropdown Details (Sửa đổ bóng lỏm sâu) --- */
        .order-details-dropdown {
            background-color: #fafafa;
            border-top: 1px solid #dee2e6;
            padding: 0 20px;
            display: none; /* Mặc định ẩn */
            
            /* Hiệu ứng lỏm sâu (Inset Shadow) */
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

                        <li><a href="${pageContext.request.contextPath}/orderView" class="account-nav-link active"><i class="fa-solid fa-box"></i> My Orders</a></li>
                        <li><a href="${pageContext.request.contextPath}/orderHistoryView" class="account-nav-link"><i class="fa-solid fa-clock-rotate-left"></i> Order History</a></li>
                        <li><a href="${pageContext.request.contextPath}/cookieHandle" class="account-nav-link text-danger" onclick="return confirm('Do you want to sign out?')"><i class="fa-solid fa-right-from-bracket"></i> Sign Out</a></li>
                    </ul>
                </div>
            </div>

            <%-- === RIGHT COLUMN: ORDER CONTENT === --%>
            <div class="col-lg-8 col-md-7">
                <div class="orders-wrapper">
    
    <%-- Header chung --%>
    <div class="section-header">
        <h4><i class="bi bi-list-check"></i> Orders Status</h4>
    </div>

    <div id="loading-indicator" class="loading-container">
        <div class="spinner"></div>
    </div>

    <div id="order-content-area" style="display: none;">

        <%-- 1. ĐẾM SỐ LƯỢNG --%>
        <c:set var="countPending" value="0" />
        <c:set var="countDelivering" value="0" />
        <c:forEach items="${requestScope.ordersUserList}" var="o">
            <c:if test="${o.status eq 'Pending'}"><c:set var="countPending" value="${countPending + 1}" /></c:if>
            <c:if test="${o.status eq 'Delivering'}"><c:set var="countDelivering" value="${countDelivering + 1}" /></c:if>
        </c:forEach>

        <c:choose>
            <%-- 2. KHÔNG CÓ ĐƠN NÀO --%>
            <c:when test="${countPending == 0 && countDelivering == 0}">
                <div class="empty-state">
                    <i class="bi bi-box-seam empty-icon"></i>
                    <p class="empty-text">You have no pending or delivering orders.</p>
                    <a href="${pageContext.request.contextPath}" class="btn btn-outline-secondary mt-2">Go Shopping</a>
                </div>
            </c:when>

            <c:otherwise>
                <%-- 3. LOOP PENDING ORDERS --%>
                <c:if test="${countPending > 0}">
                    <h5 class="text-warning fw-bold mb-3 mt-1"><i class="bi bi-hourglass-split"></i> Pending Orders</h5>
                    <c:forEach items="${requestScope.ordersUserList}" var="o">
                        <c:if test="${o.status eq 'Pending'}">
                            <%-- START CARD --%>
                            <div class="order-card fade-in">
                                <div class="order-header">
                                    <div>
                                        <span class="order-id">Order #${o.orderID}</span>
                                        <div class="order-date"><i class="bi bi-calendar3"></i> ${o.date}</div>
                                    </div>
                                    <span class="status-badge status-${o.status}">${o.status}</span>
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
                                    <button class="btn-detail" id="btn-${o.orderID}" onclick="toggleDetails(${o.orderID})">
                                        Detail <i class="bi bi-chevron-down"></i>
                                    </button>
                                </div>
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
                                                        <img src="${picUrlMap[d.productID]}" class="product-img" alt="Product">
                                                    </div>
                                                    <div class="col">
                                                        <div class="product-name">${nameProduct[d.productID]}</div>
                                                        <div class="product-meta">Size: <strong>${d.size_name}</strong></div>
                                                        <div class="product-meta">Quantity: <strong>${d.quantity}</strong></div>
                                                    </div>
                                                    <div class="col-auto price-group">
                                                        <c:if test="${lineOrig > lineDisc}">
                                                            <span class="price-old"><fmt:formatNumber value="${lineOrig}" type="number"/> VND</span>
                                                        </c:if>
                                                        <span class="price-new"><fmt:formatNumber value="${lineDisc}" type="number"/> VND</span>
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

                <%-- SPACING --%>
                <c:if test="${countPending > 0 && countDelivering > 0}"><div class="mb-5 border-top pt-2"></div></c:if>

                <%-- 4. LOOP DELIVERING ORDERS --%>
                <c:if test="${countDelivering > 0}">
                    <h5 class="text-info fw-bold mb-3 mt-1" style="color: #00897b !important;"><i class="bi bi-truck"></i> Delivering Orders</h5>
                    <c:forEach items="${requestScope.ordersUserList}" var="o">
                        <c:if test="${o.status eq 'Delivering'}">
                            <%-- START CARD --%>
                            <div class="order-card fade-in">
                                <div class="order-header">
                                    <div>
                                        <span class="order-id">Order #${o.orderID}</span>
                                        <div class="order-date"><i class="bi bi-calendar3"></i> ${o.date}</div>
                                    </div>
                                    <span class="status-badge status-${o.status}">${o.status}</span>
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
                                    <button class="btn-received" onclick="markDelivered(${o.orderID})">
                                        <i class="bi bi-check2-circle"></i> Received
                                    </button>
                                    <button class="btn-detail" id="btn-${o.orderID}" onclick="toggleDetails(${o.orderID})">
                                        Detail <i class="bi bi-chevron-down"></i>
                                    </button>
                                </div>
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
                                                        <img src="${picUrlMap[d.productID]}" class="product-img" alt="Product">
                                                    </div>
                                                    <div class="col">
                                                        <div class="product-name">${nameProduct[d.productID]}</div>
                                                        <div class="product-meta">Size: <strong>${d.size_name}</strong></div>
                                                        <div class="product-meta">Quantity: <strong>${d.quantity}</strong></div>
                                                    </div>
                                                    <div class="col-auto price-group">
                                                        <c:if test="${lineOrig > lineDisc}">
                                                            <span class="price-old"><fmt:formatNumber value="${lineOrig}" type="number"/> VND</span>
                                                        </c:if>
                                                        <span class="price-new"><fmt:formatNumber value="${lineDisc}" type="number"/> VND</span>
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

    <%@ include file="footer.jsp" %>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script>
        const BASE = '${pageContext.request.contextPath}';

        // Fake Loading Effect
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

        // AJAX Mark Delivered
        function markDelivered(orderId) {
            if (!confirm('Confirm you have received order #' + orderId + '?')) return;
            
            $.ajax({
                url: BASE + '/orderHistoryView',
                method: 'GET',
                data: { orderId: orderId, status: 'Delivered' },
                success: function () { 
                    // Redirect to Order History after marking as delivered
                    window.location.href = BASE + '/orderHistoryView'; 
                },
                error: function (xhr) { 
                    alert('Error updating status. Please try again.'); 
                }
            });
        }
    </script>
</body>
</html>