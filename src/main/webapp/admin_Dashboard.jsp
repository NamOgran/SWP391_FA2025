<%-- 
    Document   : admin_Dashboard.jsp
    Description: Dashboard Final (All-time Stats, Monthly/Quarterly Charts, Clean Layout)
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
    <title>Admin | Statistic</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://kit.fontawesome.com/1bd876819f.js" crossorigin="anonymous"></script>
    <link href='https://fonts.googleapis.com/css?family=Quicksand:400,600,700&display=swap' rel='stylesheet'>
    <link rel="icon" href="${BASE_URL}/images/LG2.png" type="image/x-icon"> 

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

        /* --- DASHBOARD HEADER --- */
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
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

        /* --- LAYOUT UTILS --- */
        .card-box {
            background: white;
            border-radius: 12px;
            box-shadow: var(--card-shadow);
            padding: 20px;
            height: 100%;
            display: flex;
            flex-direction: column;
            width: 100%;
            margin-bottom: 25px;
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
        .chart-wrapper-sm {
            position: relative;
            width: 100%;
            height: 250px; 
        }

        /* --- GRID FOR SPLIT CHARTS --- */
        .split-charts-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 25px;
        }
        @media (max-width: 992px) { .split-charts-grid { grid-template-columns: 1fr; } }

        /* Loading Animation */
        .fade-in { animation: fadeIn 0.6s ease-out forwards; opacity: 0; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(15px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>

<body id="admin-body">

    <jsp:include page="admin_header-sidebar.jsp" />

    <div class="main-content">
        
        <div class="page-header fade-in" style="animation-delay: 0.1s;">
            <div class="page-title">
                <h3><i class="fa-solid fa-chart-line"></i> Statistic</h3>
            </div>
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
                    <%-- Hiển thị biến numberOfOrder (Tổng toàn bộ) --%>
                    <h3><fmt:formatNumber type="number" value="${numberOfOrder}" pattern="###,###" /></h3>
                </div>
                <div class="stat-icon icon-green"><i class="bi bi-cart-check-fill"></i></div>
            </div>

            <%-- 4. Total Revenue (YELLOW) --%>
            <div class="stat-card">
                <div class="stat-content">
                    <h6>Total Revenue</h6>
                    <%-- Hiển thị biến revenue (Tổng toàn bộ) --%>
                    <h3 class="text-warning"><fmt:formatNumber type="number" value="${revenue}" pattern="###,###" /> VND</h3>
                </div>
                <div class="stat-icon icon-yellow"><i class="bi bi-currency-dollar"></i></div>
            </div>
        </div>

        <div class="fade-in" style="animation-delay: 0.3s;">
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
        </div>

        <div class="split-charts-grid fade-in" style="animation-delay: 0.4s;">
            <div class="card-box" style="margin-bottom: 0;">
                <div class="card-header-custom">
                    <h5 class="card-title">Monthly Revenue Chart</h5>
                </div>
                <div class="chart-wrapper-sm">
                    <canvas id="monthlyChart"></canvas>
                </div>
            </div>

            <div class="card-box" style="margin-bottom: 0;">
                <div class="card-header-custom">
                    <h5 class="card-title">Quarterly Revenue Chart</h5>
                </div>
                <div class="chart-wrapper-sm">
                    <canvas id="quarterChart"></canvas>
                </div>
            </div>
        </div>

    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script>
        let revenueChart = null;    // Main Mixed Chart
        let monthlyChart = null;    // New Monthly Line Chart
        let quarterChart = null;    // New Quarterly Bar Chart

        // Access server-side data
        let currentRevenueData = ${chartRevenue}; // Array of 12 months revenue
        let currentOrdersData = ${chartOrders};   // Array of 12 months orders

        document.addEventListener("DOMContentLoaded", function() {
            initCharts();
        });

        // --- CHART CALCULATIONS ---
        function calculateQuarterlyData(monthlyData) {
            // Aggregate 12 months into 4 quarters
            let q1 = (monthlyData[0] || 0) + (monthlyData[1] || 0) + (monthlyData[2] || 0);
            let q2 = (monthlyData[3] || 0) + (monthlyData[4] || 0) + (monthlyData[5] || 0);
            let q3 = (monthlyData[6] || 0) + (monthlyData[7] || 0) + (monthlyData[8] || 0);
            let q4 = (monthlyData[9] || 0) + (monthlyData[10] || 0) + (monthlyData[11] || 0);
            return [q1, q2, q3, q4];
        }

        // --- CHART INIT ---
        function initCharts() {
            const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
            
            // 1. Mixed Chart
            const mixedCtx = document.getElementById('mixedChart');
            if(mixedCtx) {
                revenueChart = new Chart(mixedCtx, {
                    type: 'bar',
                    data: {
                        labels: months,
                        datasets: [
                            { label: 'Revenue', data: currentRevenueData, backgroundColor: '#f6c23e', borderRadius: 4, order: 2, yAxisID: 'y' },
                            { label: 'Orders', data: currentOrdersData, borderColor: '#1cc88a', backgroundColor: '#1cc88a', type: 'line', tension: 0.4, order: 1, yAxisID: 'y1' }
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

            // 2. Monthly Revenue Chart (Line)
            const monthlyCtx = document.getElementById('monthlyChart');
            if(monthlyCtx) {
                monthlyChart = new Chart(monthlyCtx, {
                    type: 'line',
                    data: {
                        labels: months,
                        datasets: [{
                            label: 'Monthly Revenue',
                            data: currentRevenueData,
                            borderColor: '#435ebe',
                            backgroundColor: 'rgba(67, 94, 190, 0.1)',
                            borderWidth: 2,
                            fill: true,
                            tension: 0.3
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: { legend: { display: false } },
                        scales: {
                            y: { beginAtZero: true, ticks: { callback: function(value) { return value.toLocaleString(); } } },
                            x: { grid: { display: false } }
                        }
                    }
                });
            }

            // 3. Quarterly Revenue Chart (Bar)
            const quarterCtx = document.getElementById('quarterChart');
            if(quarterCtx) {
                const quarterData = calculateQuarterlyData(currentRevenueData);
                quarterChart = new Chart(quarterCtx, {
                    type: 'bar',
                    data: {
                        labels: ['Q1 (Jan-Mar)', 'Q2 (Apr-Jun)', 'Q3 (Jul-Sep)', 'Q4 (Oct-Dec)'],
                        datasets: [{
                            label: 'Quarterly Revenue',
                            data: quarterData,
                            backgroundColor: ['#4e73df', '#1cc88a', '#36b9cc', '#f6c23e'],
                            borderRadius: 5
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: { legend: { display: false } },
                        scales: {
                            y: { beginAtZero: true },
                            x: { grid: { display: false } }
                        }
                    }
                });
            }
        }

        // --- UPDATE DATA WHEN YEAR CHANGED ---
        function updateChartData(year) {
            fetch('${BASE_URL}/admin?tab=api_chart_data&year=' + year)
                .then(response => response.json())
                .then(data => {
                    // Update variables
                    currentRevenueData = data.revenue;
                    currentOrdersData = data.orders;

                    // 1. Update Mixed Chart
                    if (revenueChart) {
                        revenueChart.data.datasets[0].data = currentRevenueData;
                        revenueChart.data.datasets[1].data = currentOrdersData;
                        revenueChart.update();
                    }

                    // 2. Update Monthly Chart
                    if (monthlyChart) {
                        monthlyChart.data.datasets[0].data = currentRevenueData;
                        monthlyChart.update();
                    }

                    // 3. Update Quarterly Chart
                    if (quarterChart) {
                        const newQuarterData = calculateQuarterlyData(currentRevenueData);
                        quarterChart.data.datasets[0].data = newQuarterData;
                        quarterChart.update();
                    }
                })
                .catch(error => console.error('Error:', error));
        }
    </script>
</body>
</html>