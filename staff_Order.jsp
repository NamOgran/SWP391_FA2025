<%-- 
    Document   : staff_Order.jsp
    Description: Order Management for Staff (Full Functionality)
--%>
<%@page import="entity.Staff"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="BASE_URL" value="${pageContext.request.contextPath}" />

<%
    // SECURITY CHECK: STAFF ONLY
    Staff s = (Staff) session.getAttribute("staff");
    if (s == null || !"staff".equalsIgnoreCase(s.getRole())) {
        if (s == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        } else {
            if("admin".equalsIgnoreCase(s.getRole())){
                 response.sendRedirect(request.getContextPath() + "/admin");
            } else {
                 response.sendRedirect(request.getContextPath() + "/"); 
            }
        }
        return; 
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff | Order Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://kit.fontawesome.com/1bd876819f.js" crossorigin="anonymous"></script>
    <link href='https://fonts.googleapis.com/css?family=Quicksand:400,500,600,700&display=swap' rel='stylesheet'>
    <link rel="icon" href="${BASE_URL}/images/LG2.png" type="image/x-icon">

    <style>
        /* --- STAFF THEME (Milky Brown) --- */
        :root {
            --primary-color: #795548;       /* Staff Brown */
            --primary-light: rgba(121, 85, 72, 0.1);
            --secondary-color: #858796;
            --success-color: #1cc88a;
            --info-color: #36b9cc;
            --warning-color: #f6c23e;
            --danger-color: #e74a3b;
            --light-bg: #f4f7f6;
            --card-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.1);
        }

        body { font-family: 'Quicksand', sans-serif; background-color: var(--light-bg); color: #5a5c69; }

        /* --- CARD & GENERAL --- */
        .card-modern { background: #fff; border: none; border-radius: 15px; box-shadow: var(--card-shadow); margin-bottom: 25px; overflow: hidden; }
        .card-header-modern { background: #fff; padding: 20px 25px; border-bottom: 1px solid #e3e6f0; display: flex; justify-content: space-between; align-items: center; }
        .page-title { font-weight: 700; color: var(--primary-color); font-size: 1.5rem; display: flex; align-items: center; gap: 10px; }
        .stat-badge { background: var(--primary-light); color: var(--primary-color); padding: 5px 12px; border-radius: 20px; font-weight: 600; font-size: 0.9rem; }
        .filter-container { padding: 20px 25px; background-color: #fff; border-bottom: 1px solid #f0f0f0; }
        .search-input-group .input-group-text { background: transparent; border-right: none; color: #aaa; }
        .search-input-group .form-control { border-left: none; box-shadow: none; }
        .search-input-group .form-control:focus { border-color: #d1d1d1; }
        .form-label-small { font-size: 0.8rem; font-weight: 700; color: #b7b9cc; text-transform: uppercase; margin-bottom: 5px; display: block; }

        /* --- TABLE STYLES --- */
        .table-modern { width: 100%; margin-bottom: 0; }
        .table-modern thead th { background-color: #f8f9fc; color: #858796; font-weight: 700; text-transform: uppercase; font-size: 0.85rem; border-bottom: 2px solid #e3e6f0; padding: 15px; border-top: none; }
        .table-modern tbody td { padding: 15px; vertical-align: middle; border-bottom: 1px solid #e3e6f0; color: #5a5c69; font-size: 0.95rem; }
        .table-modern tbody tr:hover { background-color: #fcfcfc; }
        .table-blur { opacity: 0.4; pointer-events: none; filter: blur(1.5px); transition: all 0.2s ease; }
        
        /* Expanded Row Style */
        .table-modern tr.selected-row td { background-color: #efebe9 !important; border-top: 2px solid var(--primary-color); border-bottom: none; } /* Brown tint */
        .table-modern tr.selected-row td:first-child { border-left: 2px solid var(--primary-color); }
        .table-modern tr.selected-row td:last-child { border-right: 2px solid var(--primary-color); }

        /* --- INSET DETAIL STYLE --- */
        .detail-row-container { background-color: #f5f5f5; padding: 25px; box-shadow: inset 0 0 15px rgba(0,0,0,0.05); border-bottom: 1px solid #e3e6f0; }
        .detail-card { background: #fff; border-radius: 12px; border: 1px solid #d1d3e2; box-shadow: 0 5px 15px rgba(0,0,0,0.05); overflow: hidden; }
        .detail-header { background: linear-gradient(45deg, #795548, #5D4037); color: white; padding: 12px 20px; font-weight: 600; display: flex; align-items: center; gap: 10px; }

        /* --- AVATAR & INFO --- */
        .avatar-circle { width: 40px; height: 40px; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-weight: bold; font-size: 1rem; margin-right: 12px; text-transform: uppercase; flex-shrink: 0; }
        .user-cell { display: flex; align-items: center; }
        .user-info .name { font-weight: 700; color: #333; font-size: 0.95rem; }
        .user-info .sub-text { font-size: 0.8rem; color: #858796; max-width: 200px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; display: block; }

        /* --- STATUS BADGES --- */
        .status-badge { padding: 5px 12px; border-radius: 20px; font-size: 0.85rem; font-weight: 700; }
        .badge-pending { background: #fff3cd; color: #856404; }
        .badge-delivering { background: #cff4fc; color: #055160; }
        .badge-delivered { background: #d1e7dd; color: #0f5132; } 
        .badge-cancelled { background: #f8d7da; color: #842029; }

        /* --- BUTTONS --- */
        .btn-soft { border: none; border-radius: 8px; width: 32px; height: 32px; display: inline-flex; align-items: center; justify-content: center; transition: all 0.2s; margin: 0 2px; cursor: pointer; }
        .btn-soft:hover { transform: translateY(-2px); }
        .btn-soft-success { background: rgba(28, 200, 138, 0.15); color: #1cc88a; } .btn-soft-success:hover { background: #1cc88a; color: #fff; }
        .btn-soft-danger { background: rgba(231, 74, 59, 0.15); color: #e74a3b; } .btn-soft-danger:hover { background: #e74a3b; color: #fff; }
        /* Brown Secondary Button for Staff */
        .btn-soft-secondary { background: rgba(121, 85, 72, 0.15); color: #795548; } 
        .btn-soft-secondary:hover { background: #795548; color: #fff; }
        .btn-soft-secondary.active { background: #795548; color: #fff; transform: rotate(180deg); }

        .pagination-wrapper { margin-top: 20px; display: flex; justify-content: flex-end; }
        .custom-pagination { display: flex; list-style: none; gap: 5px; padding: 0; }
        .custom-page-link { width: 35px; height: 35px; display: flex; align-items: center; justify-content: center; border-radius: 8px; background: #fff; border: 1px solid #e3e6f0; color: #858796; text-decoration: none; transition: all 0.2s; cursor: pointer; }
        .custom-page-link:hover { background: #f8f9fc; }
        .custom-page-item.active .custom-page-link { background: var(--primary-color); color: white; border-color: var(--primary-color); box-shadow: 0 3px 8px rgba(121, 85, 72, 0.3); }
        #table-loader { display: flex; justify-content: center; height: 200px; align-items: center; }
    </style>
</head>

<body id="staff-body">
    <jsp:include page="staff_header-sidebar.jsp" />

    <div class="main-content p-4">
        
        <div class="card-modern">
            <div class="card-header-modern">
                <div class="page-title">
                    <i class="bi bi-cart-check-fill"></i> Order Management
                    <span class="stat-badge ms-2"><c:out value="${totalOrders}" default="${fn:length(orderList)}"/> Orders</span>
                </div>
            </div>

            <div class="filter-container">
                <div class="row g-3">
                    <div class="col-md-4">
                        <span class="form-label-small">Search</span>
                        <div class="input-group search-input-group">
                            <span class="input-group-text"><i class="bi bi-search"></i></span>
                            <input type="text" id="filterSearch" class="form-control" placeholder="Search ID, Customer Name, Address...">
                        </div>
                    </div>
                    <div class="col-md-2">
                        <span class="form-label-small">Date</span>
                        <input type="date" id="filterDate" class="form-control">
                    </div>
                    <div class="col-md-2">
                        <span class="form-label-small">Status</span>
                        <select id="filterStatus" class="form-select">
                            <option value="">All Status</option>
                            <option value="Pending">Pending</option>
                            <option value="Delivering">Delivering</option>
                            <option value="Delivered">Delivered</option>
                            <option value="Cancelled">Cancelled</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <span class="form-label-small">Price Range</span>
                        <div class="input-group">
                            <input type="number" id="filterPriceMin" class="form-control" placeholder="Min">
                            <span class="input-group-text bg-white">-</span>
                            <input type="number" id="filterPriceMax" class="form-control" placeholder="Max">
                        </div>
                    </div>
                    <div class="col-md-1 d-flex align-items-end">
                        <button class="btn btn-light border w-100 text-muted" onclick="resetFilters()" title="Reset Filters">
                            <i class="bi bi-arrow-counterclockwise"></i>
                        </button>
                    </div>
                </div>
            </div>

            <div id="table-loader"><div class="spinner-border text-secondary"></div></div>

            <div id="order-content-container" style="display: none;">
                <div class="table-responsive">
                    <table class="table table-modern align-middle" id="orderTableMain">
                        <thead>
                            <tr>
                                <th style="width: 10%">Order ID</th>
                                <th style="width: 30%">Customer Info</th>
                                <th style="width: 15%" class="text-center">Date</th>
                                <th style="width: 15%" class="text-center">Status</th>
                                <th style="width: 15%" class="text-end">Total Amount</th>
                                <th style="width: 15%" class="text-center">Actions</th>
                            </tr>
                        </thead>
                        <tbody id="order-table-body">
                            <c:forEach items="${orderList}" var="order" varStatus="loop">
                                <tr class="order-summary-row" id="row-${order.orderID}">
                                    <td class="fw-bold text-dark">#${order.orderID}</td>
                                    <td>
                                        <div class="user-cell">
                                            <div class="avatar-circle" data-name="${customerMap[order.customer_id]}"></div>
                                            <div class="user-info">
                                                <div class="name">${customerMap[order.customer_id]}</div>
                                                <span class="sub-text" title="${order.address}"><i class="bi bi-geo-alt me-1"></i>${order.address}</span>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="text-center"><fmt:formatDate value="${order.date}" pattern="dd/MM/yyyy" /></td>
                                    <td class="text-center status-cell">
                                        <span class="status-badge badge-${fn:toLowerCase(order.status)}">${order.status}</span>
                                    </td>
                                    <td class="text-end fw-bold" style="color: var(--primary-color);">
                                        <fmt:formatNumber value="${order.total}" pattern="###,###" /> <small class="text-muted">VND</small>
                                    </td>
                                    <td class="text-center action-cell">
                                        <div class="d-inline-flex">
                                            <c:if test="${order.status eq 'Pending'}">
                                                <button class="btn-soft btn-soft-success btn-action" onclick="updateStatus(${order.orderID}, 'Delivering')" title="Approve/Deliver"><i class="bi bi-truck"></i></button>
                                                <button class="btn-soft btn-soft-danger btn-action" onclick="updateStatus(${order.orderID}, 'Cancelled')" title="Reject"><i class="bi bi-x-lg"></i></button>
                                            </c:if>
                                            <c:if test="${order.status eq 'Delivering'}">
                                                <button class="btn-soft btn-soft-success btn-action" onclick="updateStatus(${order.orderID}, 'Delivered')" title="Mark as Delivered"><i class="bi bi-check-lg"></i></button>
                                            </c:if>
                                            <button class="btn-soft btn-soft-secondary view-btn" onclick="toggleDetail(this)" title="View Details"><i class="bi bi-chevron-down"></i></button>
                                        </div>
                                    </td>
                                </tr>

                                <tr class="order-detail-row" style="display: none;">
                                    <td colspan="6" class="p-0 border-0">
                                        <div class="detail-row-container">
                                            <div class="detail-card">
                                                <div class="detail-header">
                                                    <i class="bi bi-box-seam"></i> Products in Order #${order.orderID}
                                                </div>
                                                <div class="table-responsive">
                                                    <table class="table table-sm table-striped mb-0">
                                                        <thead class="bg-light text-secondary">
                                                            <tr>
                                                                <th class="ps-3" style="width: 60px;">Img</th>
                                                                <th>Product</th>
                                                                <th class="text-center">Size</th>
                                                                <th class="text-center">Quantity</th>
                                                                <th class="text-end pe-3">Subtotal</th>
                                                            </tr>
                                                        </thead>
                                                        <tbody>
                                                            <c:forEach items="${orderDetailList}" var="d">
                                                                <c:if test="${d.orderID eq order.orderID}">
                                                                    
                                                                    <%-- CALCULATE UNIT PRICE & DISCOUNT (For display only) --%>
                                                                    <c:set var="pPrice" value="${productPriceMap[d.productID]}" />
                                                                    <c:set var="vID" value="${productVoucherMap[d.productID]}" />
                                                                    <c:set var="percent" value="${vID != null ? voucherMap[vID] : 0}" />
                                                                    <c:if test="${percent == null}"><c:set var="percent" value="0"/></c:if>
                                                                    <c:set var="finalP" value="${pPrice - (pPrice * percent / 100)}" />

                                                                    <tr>
                                                                        <td class="ps-3 align-middle">
                                                                            <img src="${picUrlMap[d.productID]}" style="width: 40px; height: 40px; object-fit: cover; border-radius: 4px; border: 1px solid #ddd;" onerror="this.src='${BASE_URL}/images/default-product.png'">
                                                                        </td>
                                                                        <td class="align-middle">
                                                                            <span class="fw-bold text-dark">${productNameMap[d.productID]}</span>
                                                                            <br>
                                                                            <small class="badge bg-light text-secondary border text-uppercase me-1" style="font-size: 0.7rem;">
                                                                                ${productCategoryMap[d.productID]}
                                                                            </small>
                                                                            
                                                                            <small class="ms-1">
                                                                                <c:choose>
                                                                                    <c:when test="${percent > 0}">
                                                                                        <span class="text-decoration-line-through text-muted me-1">
                                                                                            <fmt:formatNumber value="${pPrice}" pattern="###,###"/>
                                                                                        </span>
                                                                                        <span class="text-danger fw-bold">
                                                                                            <fmt:formatNumber value="${finalP}" pattern="###,###"/> VND
                                                                                        </span>
                                                                                        <span class="badge bg-danger text-white" style="font-size: 0.65rem;">-${percent}%</span>
                                                                                    </c:when>
                                                                                    <c:otherwise>
                                                                                        <span class="text-muted">
                                                                                            <fmt:formatNumber value="${pPrice}" pattern="###,###"/> VND
                                                                                        </span>
                                                                                    </c:otherwise>
                                                                                </c:choose>
                                                                            </small>
                                                                        </td>
                                                                        <td class="text-center align-middle"><span class="badge bg-light text-dark border">${d.size_name}</span></td>
                                                                        <td class="text-center align-middle fw-bold">x${d.quantity}</td>
                                                                        <td class="text-end align-middle pe-3">
                                                                            <fmt:formatNumber value="${finalP * d.quantity}" pattern="###,###"/> VND
                                                                        </td>
                                                                    </tr>
                                                                </c:if>
                                                            </c:forEach>
                                                        </tbody>
                                                    </table>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <div id="order-pagination" class="pagination-wrapper px-4 pb-3"></div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>

    <script>
        function stringToColor(str) {
            let hash = 0;
            for (let i = 0; i < str.length; i++) { hash = str.charCodeAt(i) + ((hash << 5) - hash); }
            let c = (hash & 0x00FFFFFF).toString(16).toUpperCase();
            return "#" + "00000".substring(0, 6 - c.length) + c;
        }

        function initAvatars() {
            $('.avatar-circle').each(function() {
                let name = $(this).data('name') || "?";
                let initial = name.charAt(0).toUpperCase();
                $(this).css('background-color', stringToColor(name)).text(initial);
            });
        }

        function toggleTableBlur(active) {
            if(active) $('#orderTableMain tbody').addClass('table-blur');
            else $('#orderTableMain tbody').removeClass('table-blur');
        }

        document.addEventListener("DOMContentLoaded", function() {
            setTimeout(() => {
                $('#table-loader').fadeOut(200, () => {
                    $('#order-content-container').fadeIn(200);
                    initPagination();
                });
            }, 500);

            $('#filterSearch, #filterDate, #filterStatus, #filterPriceMin, #filterPriceMax').on('input change', function() {
                toggleTableBlur(true);
                setTimeout(() => {
                    applyFilters();
                    toggleTableBlur(false);
                }, 200);
            });
        });

        function toggleDetail(btn) {
            let row = $(btn).closest('tr'); 
            let detail = row.next('.order-detail-row');
            
            if ($(btn).hasClass('active')) {
                detail.hide();
                $(btn).removeClass('active');
                row.removeClass('selected-row');
            } else {
                detail.show();
                $(btn).addClass('active');
                row.addClass('selected-row');
            }
        }

        // [FIX] Update URL for Staff
        function updateStatus(id, status) {
            if(!confirm('Are you sure you want to update order #' + id + ' to ' + status + '?')) return;
            toggleTableBlur(true);
            $.post('${BASE_URL}/staff/order/update', { orderId: id, status: status }, function(res) {
                if(res.isSuccess) {
                    let row = $('#row-' + id);
                    let badgeClass = 'badge-' + status.toLowerCase();
                    row.find('.status-cell').html(`<span class="status-badge \${badgeClass}">\${status}</span>`);
                    
                    let actionHtml = '';
                    if (status === 'Delivering') {
                        actionHtml = `<button class="btn-soft btn-soft-success btn-action" onclick="updateStatus(\${id}, 'Delivered')" title="Mark as Delivered"><i class="bi bi-check-lg"></i></button>`;
                    }
                    actionHtml += `<button class="btn-soft btn-soft-secondary view-btn \${row.find('.view-btn').hasClass('active') ? 'active' : ''}" onclick="toggleDetail(this)" title="View Details"><i class="bi bi-chevron-down"></i></button>`;
                    row.find('.action-cell .d-inline-flex').html(actionHtml);
                    
                    let rowData = allRowsData.find(r => r.data.fullText.includes(id.toString()));
                    if(rowData) rowData.data.status = status;
                } else {
                    alert(res.description);
                }
            }, 'json')
            .always(function() {
                toggleTableBlur(false);
            });
        }

        let allRowsData = [], filteredRows = [], currentPage = 1, perPage = 8;

        function initPagination() {
            let tbody = document.getElementById('order-table-body');
            let rows = tbody.querySelectorAll('.order-summary-row');
            allRowsData = [];

            rows.forEach(r => {
                let cols = r.querySelectorAll('td');
                let idText = cols[0].innerText.replace('#', '').trim();
                let nameText = r.querySelector('.name').innerText.toLowerCase();
                let addrText = r.querySelector('.sub-text').innerText.toLowerCase();
                let dateStr = cols[2].innerText.trim();
                let statusText = cols[3].innerText.trim();
                let priceRaw = cols[4].innerText.replace(/[^\d]/g, '');

                let parts = dateStr.split('/');
                let isoDate = parts.length === 3 ? parts[2] + '-' + parts[1] + '-' + parts[0] : '';

                allRowsData.push({
                    el: r,
                    detail: r.nextElementSibling,
                    data: {
                        fullText: (idText + ' ' + nameText + ' ' + addrText).toLowerCase(),
                        date: isoDate,
                        status: statusText,
                        price: parseInt(priceRaw) || 0
                    }
                });
            });
            
            filteredRows = allRowsData;
            initAvatars();
            renderPage(1);
        }

        function applyFilters() {
            let sText = $('#filterSearch').val().toLowerCase();
            let sDate = $('#filterDate').val();
            let sStatus = $('#filterStatus').val();
            let pMin = parseInt($('#filterPriceMin').val());
            let pMax = parseInt($('#filterPriceMax').val());

            filteredRows = allRowsData.filter(item => {
                let d = item.data;
                let matchText = !sText || d.fullText.includes(sText);
                let matchDate = !sDate || d.date === sDate;
                let matchStatus = !sStatus || d.status === sStatus;
                let matchMin = isNaN(pMin) || d.price >= pMin;
                let matchMax = isNaN(pMax) || d.price <= pMax;
                return matchText && matchDate && matchStatus && matchMin && matchMax;
            });
            renderPage(1);
        }

        function resetFilters() {
            toggleTableBlur(true);
            setTimeout(() => {
                $('.filter-container input, .filter-container select').val('');
                applyFilters();
                toggleTableBlur(false);
            }, 200);
        }

        function renderPage(page) {
            currentPage = page;
            allRowsData.forEach(item => { 
                item.el.style.display = 'none'; 
                item.detail.style.display = 'none';
                item.el.classList.remove('selected-row');
                let btn = item.el.querySelector('.view-btn');
                if(btn && btn.classList.contains('active')) {
                    btn.classList.remove('active');
                }
            });

            let start = (page - 1) * perPage, end = start + perPage;
            let pageItems = filteredRows.slice(start, end);
            
            pageItems.forEach(item => item.el.style.display = 'table-row');

            let total = Math.ceil(filteredRows.length / perPage);
            let html = '<ul class="custom-pagination">';
            
            if(total > 1) {
                if(page > 1) html += `<li class="custom-page-item"><a class="custom-page-link" onclick="changePage(\${page-1})"><i class="bi bi-chevron-left"></i></a></li>`;
                for(let i=1; i<=total; i++) {
                    if (i === 1 || i === total || (i >= page - 1 && i <= page + 1)) {
                        html += `<li class="custom-page-item \${i===currentPage?'active':''}"><a class="custom-page-link" onclick="changePage(\${i})">\${i}</a></li>`;
                    } else if (i === page - 2 || i === page + 2) {
                        html += `<li class="custom-page-item"><span class="custom-page-link border-0">...</span></li>`;
                    }
                }
                if(page < total) html += `<li class="custom-page-item"><a class="custom-page-link" onclick="changePage(\${page+1})"><i class="bi bi-chevron-right"></i></a></li>`;
            }
            html += '</ul>';
            
            if(filteredRows.length === 0) {
                html = '<div class="text-center text-muted py-3 w-100">No orders match criteria.</div>';
            }
            
            document.getElementById('order-pagination').innerHTML = html;
        }

        function changePage(page) {
            toggleTableBlur(true);
            setTimeout(() => {
                renderPage(page);
                toggleTableBlur(false);
            }, 150);
        }
                    $(document).ready(function() {
                // 1. Xóa class active ở các li khác (nếu cần thiết, để tránh duplicate)
                $('.nav-list li').removeClass('active');
                
                // 2. Tìm thẻ li có data-target='product-manage' và thêm class active
                $('.nav-list li[data-target="order-manage"]').addClass('active');
            });
    </script>
</body>
</html>