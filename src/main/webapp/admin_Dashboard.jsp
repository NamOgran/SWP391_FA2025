<%-- 
    Document   : admin_Dashboard.jsp
    Description: Dashboard Fixed (Validation, Reordered Stats, Custom Legend Layout)
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="entity.Staff" %>

<c:set var="BASE_URL" value="${pageContext.request.contextPath}" />

<%
    // SECURITY CHECK
    Staff s = (Staff) session.getAttribute("staff");
    if (s == null || !"admin".equalsIgnoreCase(s.getRole())) {
        if (s == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/"); 
        }
        return; 
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin | Dashboard</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://kit.fontawesome.com/1bd876819f.js" crossorigin="anonymous"></script>
    <link href='https://fonts.googleapis.com/css?family=Quicksand:400,600,700&display=swap' rel='stylesheet'>
    <link rel="icon" href="${BASE_URL}/images/LG2.png" type="image/x-icon"> 

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>

    <style>
        :root {
            --primary-color: #435ebe;
            --secondary-color: #858796;
            --success-color: #1cc88a;
            --info-color: #36b9cc;
            --warning-color: #f6c23e;
            --danger-color: #e74a3b;
            --light-bg: #f2f7ff;
            --card-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }

        body {
            font-family: 'Quicksand', sans-serif;
            background-color: var(--light-bg);
            color: #5a5c69;
            font-size: 0.9rem;
        }

        .main-content { padding: 20px; }

        /* --- DASHBOARD HEADER & FILTER --- */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .page-title h3 {
            font-weight: 700;
            color: #2c3e50;
            margin: 0;
            font-size: 1.6rem;
        }
        .page-title p {
            margin: 0;
            color: #888;
            font-size: 0.85rem;
        }

        .filter-form {
            background: white;
            padding: 6px 12px;
            border-radius: 10px;
            box-shadow: var(--card-shadow);
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .filter-input {
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            padding: 5px 10px;
            font-size: 0.85rem;
            width: 130px;
            background-color: #fff;
        }
        .btn-filter {
            background: var(--primary-color);
            color: white;
            border: none;
            padding: 5px 12px;
            border-radius: 6px;
            font-weight: 600;
            font-size: 0.85rem;
            transition: 0.3s;
        }
        .btn-filter:hover { background: #2d4187; transform: translateY(-1px); }
        .btn-reset { color: #888; text-decoration: none; font-size: 0.9rem; margin-left: 5px; }
        .btn-reset:hover { color: var(--danger-color); }

        /* --- STATS CARDS --- */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            margin-bottom: 25px;
        }

        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: var(--card-shadow);
            display: flex;
            align-items: center;
            justify-content: space-between;
            transition: transform 0.3s ease;
        }
        .stat-card:hover { transform: translateY(-3px); }
        
        .stat-content h6 { color: #888; font-size: 0.8rem; font-weight: 600; margin-bottom: 4px; text-transform: uppercase; }
        .stat-content h3 { color: #333; font-weight: 700; margin: 0; font-size: 1.5rem; }
        
        .stat-icon {
            width: 45px; height: 45px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.3rem;
        }
        .icon-blue { background: rgba(67, 94, 190, 0.1); color: var(--primary-color); }
        .icon-green { background: rgba(28, 200, 138, 0.1); color: var(--success-color); }
        .icon-yellow { background: rgba(246, 194, 62, 0.1); color: var(--warning-color); }
        .icon-red { background: rgba(231, 74, 59, 0.1); color: var(--danger-color); }

        /* --- LAYOUT GRID FIX --- */
        .content-grid {
            display: grid;
            grid-template-columns: minmax(0, 3fr) minmax(0, 1fr); 
            gap: 20px;
            margin-bottom: 25px;
            width: 100%;
        }
        @media (max-width: 992px) { .content-grid { grid-template-columns: 1fr; } }

        .card-box {
            background: white;
            border-radius: 12px;
            box-shadow: var(--card-shadow);
            padding: 20px;
            height: 100%;
            display: flex;
            flex-direction: column;
            width: 100%;
        }

        .card-header-custom {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        .card-title { font-weight: 700; color: #333; font-size: 1rem; margin: 0; }
        
        .year-select {
            border: 1px solid #ddd;
            border-radius: 6px;
            padding: 3px 8px;
            outline: none;
            font-size: 0.85rem;
        }

        /* --- CHART CONTAINER --- */
        .chart-wrapper-bar {
            position: relative;
            width: 100%;
            height: 300px; 
        }
        
        .chart-container-doughnut { 
            position: relative; 
            height: 220px; 
            width: 100%; 
            display: flex; 
            justify-content: center;
            align-items: center;
        }
        .center-label {
            position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%);
            text-align: center; pointer-events: none;
        }
        .center-label .num { font-size: 1.4rem; font-weight: 800; color: #333; display: block;}
        .center-label .txt { font-size: 0.7rem; color: #888; text-transform: uppercase; display: block;}

        /* --- COMPACT TABLES --- */
        .table-custom { width: 100%; border-collapse: collapse; }
        .table-custom th { 
            text-align: left; 
            padding: 8px 6px; 
            font-size: 0.75rem; 
            color: #888; 
            text-transform: uppercase; 
            background: #f8f9fa; 
            border-radius: 4px; 
        }
        .table-custom td { 
            padding: 8px 6px; 
            font-size: 0.85rem; 
            border-bottom: 1px solid #f0f0f0; 
            vertical-align: middle; 
        }
        .table-custom tr:last-child td { border-bottom: none; }
        
        .product-rank {
            width: 20px; height: 20px; border-radius: 50%;
            background: #eee; color: #666; font-size: 0.7rem; font-weight: bold;
            display: flex; align-items: center; justify-content: center;
        }
        .rank-1 { background: #ffd700; color: white; box-shadow: 0 2px 4px rgba(255, 215, 0, 0.4); }
        .rank-2 { background: #c0c0c0; color: white; }
        .rank-3 { background: #cd7f32; color: white; }

        .btn-view-all { font-size: 0.8rem; color: var(--primary-color); text-decoration: none; font-weight: 600; cursor: pointer; background: none; border: none;}
        .btn-view-all:hover { text-decoration: underline; }

        /* --- PAGINATION STYLE --- */
        .modal-pagination {
            display: flex;
            justify-content: center;
            gap: 5px;
            margin-top: 10px;
            padding: 5px;
        }
        .page-btn {
            border: 1px solid #dee2e6;
            background: white;
            color: #5a5c69;
            padding: 4px 10px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 0.85rem;
            transition: all 0.2s;
        }
        .page-btn:hover { background: #f8f9fa; }
        .page-btn.active {
            background: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
        }

        /* --- LEGEND GRID STYLE --- */
        .legend-grid {
            display: grid;
            grid-template-columns: 1fr 1fr; /* 2 Cột */
            gap: 10px;
            font-size: 0.8rem;
            color: #6c757d;
            justify-items: start;
            padding: 0 10px;
        }
        .legend-item { display: flex; align-items: center; gap: 6px; }

        /* Loading */
        .fade-in { animation: fadeIn 0.6s ease-out forwards; opacity: 0; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(15px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>

<body id="admin-body">

    <jsp:include page="admin_header-sidebar.jsp" />

    <div class="main-content">
        
        <div class="page-header fade-in" style="animation-delay: 0.1s;">
            <div class="page-title">
                <h3>Dashboard Overview</h3>
                <p>Statistics from <strong class="text-primary">${displayFrom}</strong> to <strong class="text-primary">${displayTo}</strong></p>
            </div>
            
            <%-- [FIX] Added id="filterForm" for JS validation --%>
            <form id="filterForm" action="${BASE_URL}/admin" method="get" class="filter-form">
                <input type="hidden" name="tab" value="dashboard">
                <div class="d-flex align-items-center gap-2">
                    <span class="text-muted small fw-bold">FROM</span>
                    <input type="text" name="fromDate" value="${displayFrom}" class="filter-input date-picker" placeholder="Start Date">
                </div>
                <div class="d-flex align-items-center gap-2">
                    <span class="text-muted small fw-bold">TO</span>
                    <input type="text" name="toDate" value="${displayTo}" class="filter-input date-picker" placeholder="End Date">
                </div>
                <button type="submit" class="btn-filter">Apply</button>
                <a href="${BASE_URL}/admin?tab=dashboard" class="btn-reset" title="Reset Filters"><i class="bi bi-arrow-counterclockwise"></i></a>
            </form>
        </div>

        <div class="stats-grid fade-in" style="animation-delay: 0.2s;">
            
            <%-- 1. Products in Stock (RED) --%>
            <div class="stat-card">
                <div class="stat-content">
                    <h6>Products in Stock</h6>
                    <h3><fmt:formatNumber type="number" value="${numberOfProduct}" pattern="###,###" /></h3>
                </div>
                <div class="stat-icon icon-red"><i class="bi bi-box-seam-fill"></i></div>
            </div>

            <%-- 2. Total Customers (BLUE) --%>
            <div class="stat-card">
                <div class="stat-content">
                    <h6>Total Customers</h6>
                    <h3><fmt:formatNumber type="number" value="${numberOfCustomer}" pattern="###,###" /></h3>
                </div>
                <div class="stat-icon icon-blue"><i class="bi bi-people-fill"></i></div>
            </div>

            <%-- 3. Total Orders (GREEN) --%>
            <div class="stat-card">
                <div class="stat-content">
                    <h6>Total Orders</h6>
                    <h3><fmt:formatNumber type="number" value="${numberOfOrder}" pattern="###,###" /></h3>
                </div>
                <div class="stat-icon icon-green"><i class="bi bi-cart-check-fill"></i></div>
            </div>

            <%-- 4. Total Revenue (YELLOW) --%>
            <div class="stat-card">
                <div class="stat-content">
                    <h6>Total Revenue</h6>
                    <h3 class="text-warning"><fmt:formatNumber type="number" value="${revenue}" pattern="###,###" /> VND</h3>
                </div>
                <div class="stat-icon icon-yellow"><i class="bi bi-currency-dollar"></i></div>
            </div>
        </div>

        <div class="content-grid fade-in" style="animation-delay: 0.3s;">
            <div class="card-box">
                <div class="card-header-custom">
                    <h5 class="card-title">Analytics (Revenue & Orders)</h5>
                    <select id="chartYearSelect" class="year-select" onchange="updateChartData(this.value)">
                        <c:forEach var="y" begin="2020" end="${currentYear}">
                            <option value="${y}" ${y == currentYear ? 'selected' : ''}>Year ${y}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="chart-wrapper-bar">
                    <canvas id="mixedChart"></canvas>
                </div>
            </div>

            <div class="card-box">
                <div class="card-header-custom">
                    <h5 class="card-title">Order Status</h5>
                    <button type="button" class="btn-view-all" data-bs-toggle="modal" data-bs-target="#orderListModal">View List</button>
                </div>
                <div class="chart-container-doughnut">
                    <canvas id="orderChart"></canvas>
                    <div class="center-label">
                        <span class="num">${totalOrdersChart}</span>
                        <span class="txt">Orders</span>
                    </div>
                </div>
                <%-- [FIX] New Legend Layout --%>
                <div class="mt-3 legend-grid">
                    <%-- Row 1 --%>
                    <div class="legend-item"><i class="bi bi-circle-fill text-warning"></i> Pending</div>
                    <div class="legend-item"><i class="bi bi-circle-fill text-info"></i> Delivering</div>
                    <%-- Row 2 --%>
                    <div class="legend-item"><i class="bi bi-circle-fill text-success"></i> Delivered</div>
                    <div class="legend-item"><i class="bi bi-circle-fill text-danger"></i> Cancelled</div>
                </div>
            </div>
        </div>

        <div class="content-grid fade-in" style="animation-delay: 0.4s;">
            
            <div class="card-box">
                <div class="card-header-custom">
                    <h5 class="card-title">Recent Orders (Top 5)</h5>
                </div>
                <div class="table-responsive">
                    <table class="table-custom">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Customer</th>
                                <th>Date</th>
                                <th>Status</th>
                                <th class="text-end">Total</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${popupList}" var="o" begin="0" end="4">
                                <tr>
                                    <td class="fw-bold">#${o.orderId}</td>
                                    <td>${o.customerName}</td>
                                    <td><fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy" /></td>
                                    <td>
                                        <span class="badge rounded-pill ${o.status == 'Delivered' ? 'bg-success' : (o.status == 'Cancelled' ? 'bg-danger' : 'bg-warning text-dark')}">
                                            ${o.status}
                                        </span>
                                    </td>
                                    <td class="text-end fw-bold text-primary"><fmt:formatNumber value="${o.totalAmount}" pattern="#,###"/> VND</td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty popupList}"><tr><td colspan="5" class="text-center text-muted">No recent orders.</td></tr></c:if>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="card-box">
                <div class="card-header-custom">
                    <h5 class="card-title">Top Products</h5>
                    <button type="button" class="btn-view-all" data-bs-toggle="modal" data-bs-target="#bestSellerModal">View All</button>
                </div>
                <div class="table-responsive">
                    <table class="table-custom">
                        <tbody>
                            <c:forEach items="${bestSellers}" var="p" varStatus="loop">
                                <tr>
                                    <td style="width: 30px;">
                                        <div class="product-rank rank-${loop.index + 1}">${loop.index + 1}</div>
                                    </td>
                                    <td>
                                        <div class="fw-bold text-dark" style="max-width: 120px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">${p.name}</div>
                                        <div class="small text-muted"><fmt:formatNumber value="${p.price}" pattern="#,###"/> VND</div>
                                    </td>
                                    <td class="text-end">
                                        <div class="fw-bold text-success">${p.soldCount}</div>
                                        <div class="small text-muted" style="font-size: 0.65rem;">SOLD</div>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty bestSellers}"><tr><td colspan="3" class="text-center text-muted">No data available.</td></tr></c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

    </div>

    <%-- MODAL: FULL ORDER LIST (WITH CLIENT-SIDE PAGINATION) --%>
    <div class="modal fade" id="orderListModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content border-0 shadow-lg rounded-4">
                <div class="modal-header bg-light py-2">
                    <h5 class="modal-title fw-bold fs-6">Full Order List</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover table-sm mb-0 align-middle">
                            <thead class="bg-light sticky-top">
                                <tr>
                                    <th class="ps-3 py-2 text-secondary text-uppercase small">ID</th>
                                    <th class="py-2 text-secondary text-uppercase small">Customer</th>
                                    <th class="py-2 text-secondary text-uppercase small">Date</th>
                                    <th class="py-2 text-secondary text-uppercase small">Status</th>
                                    <th class="text-end pe-3 py-2 text-secondary text-uppercase small">Total</th>
                                </tr>
                            </thead>
                            <tbody id="fullOrderTableBody">
                                <c:forEach items="${popupList}" var="o">
                                    <tr class="order-row-item">
                                        <td class="fw-bold ps-3">#${o.orderId}</td>
                                        <td>${o.customerName}</td>
                                        <td><fmt:formatDate value="${o.orderDate}" pattern="dd/MM/yyyy" /></td>
                                        <td>
                                            <span class="badge rounded-pill ${o.status == 'Delivered' ? 'bg-success' : (o.status == 'Cancelled' ? 'bg-danger' : 'bg-warning text-dark')}">
                                                ${o.status}
                                            </span>
                                        </td>
                                        <td class="text-end pe-3 fw-bold"><fmt:formatNumber value="${o.totalAmount}" pattern="#,###"/> VND</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="modal-footer bg-white border-top-0 justify-content-center py-2">
                    <div id="modalPagination" class="modal-pagination"></div>
                </div>
            </div>
        </div>
    </div>

    <%-- MODAL: BEST SELLERS --%>
    <div class="modal fade" id="bestSellerModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content border-0 shadow-lg rounded-4">
                <div class="modal-header bg-light py-2">
                    <h5 class="modal-title fw-bold fs-6">Top Best Selling Products</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-0">
                    <table class="table table-striped table-sm mb-0 align-middle">
                        <thead class="bg-light sticky-top">
                            <tr><th class="text-center py-2 text-secondary small">#</th><th class="py-2 text-secondary small">Product Name</th><th class="py-2 text-secondary small">Price</th><th class="text-center py-2 text-secondary small">Sold</th></tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${allBestSellers}" var="p" varStatus="loop">
                                <tr>
                                    <td class="text-center fw-bold small">${loop.index + 1}</td>
                                    <td class="small">${p.name}</td>
                                    <td class="small"><fmt:formatNumber value="${p.price}" pattern="#,###"/> VND</td>
                                    <td class="text-center fw-bold text-success small">${p.soldCount}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script>
        let revenueChart = null;

        document.addEventListener("DOMContentLoaded", function() {
            flatpickr(".date-picker", { dateFormat: "Y-m-d", altInput: true, altFormat: "d/m/Y", allowInput: true });
            initCharts();
            initModalPagination(); 
            initValidation(); // [FIX] Initialize Validation
        });

        // [FIX] FROM > TO VALIDATION
        function initValidation() {
            const form = document.getElementById('filterForm');
            if(form) {
                form.addEventListener('submit', function(e) {
                    const fromInput = document.querySelector('input[name="fromDate"]');
                    const toInput = document.querySelector('input[name="toDate"]');
                    
                    // Flatpickr might put the actual value in hidden inputs or keep it in the input depending on config.
                    // Assuming 'Y-m-d' format from flatpickr config.
                    const fromVal = fromInput.value; 
                    const toVal = toInput.value;

                    if(fromVal && toVal) {
                        if(fromVal > toVal) {
                            e.preventDefault();
                            alert('"From" day must be <= "To" day');
                        }
                    }
                });
            }
        }

        // --- CLIENT SIDE PAGINATION FOR ORDER LIST MODAL (FIXED) ---
        function initModalPagination() {
            const rowsPerPage = 10;
            const rows = document.querySelectorAll('.order-row-item');
            const totalRows = rows.length;
            const totalPages = Math.ceil(totalRows / rowsPerPage);
            const paginationContainer = document.getElementById('modalPagination');
            
            if (totalRows === 0) return;

            function showPage(page) {
                const start = (page - 1) * rowsPerPage;
                const end = start + rowsPerPage;

                rows.forEach((row, index) => {
                    row.style.display = (index >= start && index < end) ? '' : 'none';
                });

                renderButtons(page);
            }

            function renderButtons(activePage) {
                let html = '';
                // Prev
                if(totalPages > 1) {
                    html += `<button type="button" class="page-btn" onclick="changeModalPage(event, \${activePage > 1 ? activePage - 1 : 1})"><i class="bi bi-chevron-left"></i></button>`;
                }
                
                let startPage = Math.max(1, activePage - 2);
                let endPage = Math.min(totalPages, activePage + 2);

                if (startPage > 1) html += `<button type="button" class="page-btn" onclick="changeModalPage(event, 1)">1</button>`;
                if (startPage > 2) html += `<span class="px-2 text-muted">...</span>`;

                for (let i = startPage; i <= endPage; i++) {
                    html += `<button type="button" class="page-btn \${i === activePage ? 'active' : ''}" onclick="changeModalPage(event, \${i})">\${i}</button>`;
                }

                if (endPage < totalPages - 1) html += `<span class="px-2 text-muted">...</span>`;
                if (endPage < totalPages) html += `<button type="button" class="page-btn" onclick="changeModalPage(event, \${totalPages})">\${totalPages}</button>`;

                // Next
                if(totalPages > 1) {
                    html += `<button type="button" class="page-btn" onclick="changeModalPage(event, \${activePage < totalPages ? activePage + 1 : totalPages})"><i class="bi bi-chevron-right"></i></button>`;
                }

                paginationContainer.innerHTML = html;
            }

            // Expose function globally
            window.changeModalPage = function(event, page) {
                event.preventDefault(); 
                event.stopPropagation();
                showPage(page);
            };

            // Init
            showPage(1);
        }

        // --- CHART JS ---
        function initCharts() {
            // Doughnut Chart (Status)
            const orderCtx = document.getElementById('orderChart');
            if(orderCtx) {
                new Chart(orderCtx, {
                    type: 'doughnut',
                    data: {
                        labels: ${orderStatsLabels},
                        datasets: [{
                            data: ${orderStatsData},
                            backgroundColor: ['#5a8dee', '#696cff', '#03c3ec', '#71dd37', '#ff3e1d', '#20c997'],
                            borderWidth: 0,
                            hoverOffset: 5
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        cutout: '75%',
                        plugins: { legend: { display: false } }
                    }
                });
            }

            // Mixed Chart (Bar + Line)
            const mixedCtx = document.getElementById('mixedChart');
            if(mixedCtx) {
                revenueChart = new Chart(mixedCtx, {
                    type: 'bar',
                    data: {
                        labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                        datasets: [
                            { label: 'Revenue', data: ${chartRevenue}, backgroundColor: '#f6c23e', borderRadius: 4, order: 2, yAxisID: 'y' },
                            { label: 'Orders', data: ${chartOrders}, borderColor: '#1cc88a', backgroundColor: '#1cc88a', type: 'line', tension: 0.4, order: 1, yAxisID: 'y1' }
                        ]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        interaction: { mode: 'index', intersect: false },
                        scales: {
                            y: { beginAtZero: true, display: true, position: 'left', grid: { borderDash: [2, 2] } },
                            y1: { beginAtZero: true, display: false, position: 'right', grid: { display: false } },
                            x: { grid: { display: false } }
                        },
                        plugins: { legend: { display: true, position: 'top' } }
                    }
                });
            }
        }

        function updateChartData(year) {
            if (!revenueChart) return;
            fetch('${BASE_URL}/admin?tab=api_chart_data&year=' + year)
                .then(response => response.json())
                .then(data => {
                    revenueChart.data.datasets[0].data = data.revenue;
                    revenueChart.data.datasets[1].data = data.orders;
                    revenueChart.update();
                })
                .catch(error => console.error('Error:', error));
        }
    </script>
</body>
</html>