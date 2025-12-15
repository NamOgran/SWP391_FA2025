<%-- 
    Document    : staff_Dashboard.jsp
    Description: Staff Dashboard - Limited View (Stock, Orders, Status)
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="entity.Staff" %>

<c:set var="BASE_URL" value="${pageContext.request.contextPath}" />

<%
    // SECURITY CHECK: STAFF ONLY
    Staff s = (Staff) session.getAttribute("staff");
    if (s == null || !"staff".equalsIgnoreCase(s.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return; 
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff | Dashboard</title>
    
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

        /* HEADER & FILTER */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .page-title h3 { font-weight: 700; color: #2c3e50; margin: 0; font-size: 1.6rem; }
        .page-title p { margin: 0; color: #888; font-size: 0.85rem; }

        .filter-form {
            background: white; padding: 6px 12px; border-radius: 10px;
            box-shadow: var(--card-shadow); display: flex; align-items: center; gap: 8px;
        }
        .filter-input {
            border: 1px solid #e0e0e0; border-radius: 6px; padding: 5px 10px;
            font-size: 0.85rem; width: 130px; background-color: #fff;
        }
        .btn-filter {
            background: var(--primary-color); color: white; border: none; padding: 5px 12px;
            border-radius: 6px; font-weight: 600; font-size: 0.85rem; transition: 0.3s;
        }
        .btn-filter:hover { background: #2d4187; transform: translateY(-1px); }
        .btn-reset { color: #888; text-decoration: none; font-size: 0.9rem; margin-left: 5px; }
        .btn-reset:hover { color: var(--danger-color); }

        /* STATS CARDS */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 20px;
            margin-bottom: 25px;
        }
        .stat-card {
            background: white; border-radius: 12px; padding: 20px;
            box-shadow: var(--card-shadow); display: flex; align-items: center;
            justify-content: space-between; transition: transform 0.3s ease;
        }
        .stat-card:hover { transform: translateY(-3px); }
        .stat-content h6 { color: #888; font-size: 0.8rem; font-weight: 600; margin-bottom: 4px; text-transform: uppercase; }
        .stat-content h3 { color: #333; font-weight: 700; margin: 0; font-size: 1.5rem; }
        .stat-icon {
            width: 45px; height: 45px; border-radius: 10px; display: flex;
            align-items: center; justify-content: center; font-size: 1.3rem;
        }
        .icon-red { background: rgba(231, 74, 59, 0.1); color: var(--danger-color); }
        .icon-green { background: rgba(28, 200, 138, 0.1); color: var(--success-color); }

        /* CONTENT GRID */
        .content-grid {
            display: grid;
            /* Layout: Cột trái (Chart) nhỏ hơn, Cột phải (Recent Orders) lớn hơn */
            grid-template-columns: 1fr 2fr; 
            gap: 20px;
            margin-bottom: 25px;
        }
        @media (max-width: 992px) { .content-grid { grid-template-columns: 1fr; } }

        .card-box {
            background: white; border-radius: 12px; box-shadow: var(--card-shadow);
            padding: 20px; height: 100%; display: flex; flex-direction: column;
        }
        .card-header-custom {
            display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;
        }
        .card-title { font-weight: 700; color: #333; font-size: 1rem; margin: 0; }

        /* CHART */
        .chart-container-doughnut { 
            position: relative; height: 250px; width: 100%; 
            display: flex; justify-content: center; align-items: center;
        }
        .center-label {
            position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%);
            text-align: center; pointer-events: none;
        }
        .center-label .num { font-size: 1.4rem; font-weight: 800; color: #333; display: block;}
        .center-label .txt { font-size: 0.7rem; color: #888; text-transform: uppercase; display: block;}

        /* TABLE */
        .table-custom { width: 100%; border-collapse: collapse; }
        .table-custom th { 
            text-align: left; padding: 10px; font-size: 0.75rem; color: #888; 
            text-transform: uppercase; background: #f8f9fa; border-radius: 4px; 
        }
        .table-custom td { 
            padding: 10px; font-size: 0.85rem; border-bottom: 1px solid #f0f0f0; vertical-align: middle; 
        }
        .product-rank {
            width: 20px; height: 20px; border-radius: 50%;
            background: #eee; color: #666; font-size: 0.7rem; font-weight: bold;
            display: flex; align-items: center; justify-content: center;
        }
        .rank-1 { background: #ffd700; color: white; }
        .rank-2 { background: #c0c0c0; color: white; }
        .rank-3 { background: #cd7f32; color: white; }

        .legend-grid {
            display: grid; grid-template-columns: 1fr 1fr; gap: 10px; font-size: 0.8rem; color: #6c757d; padding: 0 10px;
        }
        .legend-item { display: flex; align-items: center; gap: 6px; }

        .fade-in { animation: fadeIn 0.6s ease-out forwards; opacity: 0; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(15px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>

<body>

    <jsp:include page="staff_header-sidebar.jsp" /> 

    <div class="main-content">
        
        <div class="page-header fade-in">
            <div class="page-title">
                <h3>Staff Dashboard</h3>
                <p>Overview from <strong class="text-primary">${displayFrom}</strong> to <strong class="text-primary">${displayTo}</strong></p>
            </div>
            
            <form id="filterForm" action="${BASE_URL}/staff" method="get" class="filter-form">
                <div class="d-flex align-items-center gap-2">
                    <span class="text-muted small fw-bold">FROM</span>
                    <input type="text" name="fromDate" value="${displayFrom}" class="filter-input date-picker">
                </div>
                <div class="d-flex align-items-center gap-2">
                    <span class="text-muted small fw-bold">TO</span>
                    <input type="text" name="toDate" value="${displayTo}" class="filter-input date-picker">
                </div>
                <button type="submit" class="btn-filter">Apply</button>
                <a href="${BASE_URL}/staff" class="btn-reset"><i class="bi bi-arrow-counterclockwise"></i></a>
            </form>
        </div>

        <div class="stats-grid fade-in" style="animation-delay: 0.1s;">
            <div class="stat-card">
                <div class="stat-content">
                    <h6>Products in Stock</h6>
                    <h3><fmt:formatNumber type="number" value="${productsInStock}" pattern="###,###" /></h3>
                </div>
                <div class="stat-icon icon-red"><i class="bi bi-box-seam-fill"></i></div>
            </div>

            <div class="stat-card">
                <div class="stat-content">
                    <h6>Total Orders</h6>
                    <h3><fmt:formatNumber type="number" value="${totalOrders}" pattern="###,###" /></h3>
                </div>
                <div class="stat-icon icon-green"><i class="bi bi-cart-check-fill"></i></div>
            </div>
        </div>

        <div class="content-grid fade-in" style="animation-delay: 0.2s;">
            
            <div class="card-box">
                <div class="card-header-custom">
                    <h5 class="card-title">Order Status</h5>
                </div>
                <div class="chart-container-doughnut">
                    <canvas id="orderChart"></canvas>
                    <div class="center-label">
                        <span class="num">${totalOrdersChart}</span>
                        <span class="txt">Orders</span>
                    </div>
                </div>
                <div class="mt-3 legend-grid">
                    <div class="legend-item"><i class="bi bi-circle-fill text-warning"></i> Pending</div>
                    <div class="legend-item"><i class="bi bi-circle-fill text-info"></i> Delivering</div>
                    <div class="legend-item"><i class="bi bi-circle-fill text-success"></i> Delivered</div>
                    <div class="legend-item"><i class="bi bi-circle-fill text-danger"></i> Cancelled</div>
                </div>
            </div>

            <div class="card-box">
                <div class="card-header-custom">
                    <h5 class="card-title">Recent Orders</h5>
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
                            <c:forEach items="${recentOrders}" var="o" begin="0" end="6">
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
                            <c:if test="${empty recentOrders}"><tr><td colspan="5" class="text-center text-muted">No orders found.</td></tr></c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="card-box fade-in" style="animation-delay: 0.3s;">
            <div class="card-header-custom">
                <h5 class="card-title">Top Selling Products</h5>
            </div>
            <div class="table-responsive">
                <table class="table-custom">
                    <thead>
                        <tr>
                            <th style="width: 50px;">Rank</th>
                            <th>Product Name</th>
                            <th>Price</th>
                            <th class="text-end">Sold</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${topProducts}" var="p" varStatus="loop">
                            <tr>
                                <td><div class="product-rank rank-${loop.index + 1}">${loop.index + 1}</div></td>
                                <td class="fw-bold">${p.name}</td>
                                <td><fmt:formatNumber value="${p.price}" pattern="#,###"/> VND</td>
                                <td class="text-end fw-bold text-success">${p.soldCount}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

    </div>

    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script>
        document.addEventListener("DOMContentLoaded", function() {
            // Flatpickr init
            flatpickr(".date-picker", { dateFormat: "Y-m-d", altInput: true, altFormat: "d/m/Y", allowInput: true });
            
            // Chart init
            initChart();
        });

        // jQuery Logic for Sidebar Active State
        $(document).ready(function() {
            // Force "Dashboard" to be active based on data-target
            $('.nav-list li').removeClass('active');
            $('.nav-list li[data-target="dashboard"]').addClass('active');
        });

        function initChart() {
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
        }
    </script>
</body>
</html>