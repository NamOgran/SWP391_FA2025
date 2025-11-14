<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="entity.Staff" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="BASE_URL" value="${pageContext.request.contextPath}" />

<%
    Staff s = (Staff) session.getAttribute("staff");
    if (s == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    if (!"admin".equalsIgnoreCase(s.getRole())) {
        response.sendRedirect(request.getContextPath() + "/staff.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

    <head> 
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Dashboard - GIO</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-iYQeCzEYFbKjA/T2uDLTpkwGzCiq6soy8tYaI1GyVh/UjpbCx/TYkiZhlZB6+fzT" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link href='https://fonts.googleapis.com/css?family=Quicksand' rel='stylesheet'> <link rel="icon" href="${BASE_URL}/images/LG1.png" type="image/x-icon"> 

        <script src="https://kit.fontawesome.com/1bd876819f.js" crossorigin="anonymous"></script>



        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Quicksand', sans-serif;
            }
            html, body {
                height: 100%;
            }
            body {
                display: flex;
                flex-direction: column;
            }
            .main {
                display: flex;
                flex-grow: 1;
                min-height: calc(100vh - 50px);
            }
            nav {
                width: 17%;
                flex-shrink: 0;
                background-color: #2f2b2b;
            }
            .nav-list {
                list-style-type: none;
                padding: 0;
                height: 100%;
            }
            header {
                height: 50px;
                background-color: #2f2b2b;
                flex-shrink: 0;
            }
            .header-top, .admin-info {
                display: flex;
                align-items: center;
            }
            .header-top {
                max-width: 1200px;
                height: 100%;
                margin: 0 auto;
                justify-content: space-between;
                padding: 0 15px;
            }
            .header-top * {
                color: white;
            }
            .logo {
                font-size: 1.5em;
                font-weight: bold;
            }
            .admin-name, .signout {
                margin: 0 10px;
            }
            .signout a {
                text-decoration: none;
            }
            .signout a:hover {
                color: #ddd;
            }
            .nav-list li {
                padding: 15px 10px;
                cursor: pointer;
                border-bottom: 1px solid #444;
            }
            .nav-list li:last-child {
                border-bottom: none;
            }
            .nav-list li:hover {
                background-color: rgb(122, 117, 120);
            }
            /* Đánh dấu tab đang active */
            .nav-list li.active {
                background-color: rgb(122, 117, 120);
            }
            .nav-list li a {
                text-decoration: none;
                color: white;
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .nav-list li a span {
                color: white;
            }
            .nav-list li i {
                font-size: 1.1em;
                width: 20px;
                text-align: center;
            }
            .main-content {
                width: 83%;
                padding: 30px 40px;
                overflow-y: auto;
            }
            .main-content h3 {
                margin-bottom: 15px;
                color: #333;
            }
            .main-content hr {
                margin-bottom: 25px;
            }

            /* CSS riêng cho Dashboard */
            .card-container {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
                gap: 25px;
                margin-bottom: 30px;
            }
            .card {
                display: flex;
                flex-direction: column;
                justify-content: space-around;
                padding: 20px 25px;
                color: white;
                border-radius: 10px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
                min-height: 120px;
            }
            .card:nth-child(1) {
                background-color: #dc3545;
            }
            .card:nth-child(2) {
                background-color: #198754;
            }
            .card:nth-child(3) {
                background-color: #ffc107;
                color: #333;
            }
            .card:nth-child(4) {
                background-color: #0d6efd;
            }
            .card-inner {
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-bottom: 10px;
            }
            .card-inner h2 {
                font-size: 1.1em;
                margin: 0;
                font-weight: 500;
            }
            .card-inner > span i {
                font-size: 2.5em;
                opacity: 0.8;
            }
            .card > h1 {
                font-size: 2.2em;
                margin: 0;
                font-weight: 600;
            }
            input[type="month"] {
                border-radius: 5px;
                padding: 8px 12px;
                font-size: 1em;
                color: #333;
                background-color: #fff;
                border: 1px solid #ccc;
                outline: none;
            }
            ::-webkit-calendar-picker-indicator {
                cursor: pointer;
                padding: 5px;
                background-color: #eee;
                border-radius: 3px;
                opacity: 0.7;
            }
            ::-webkit-calendar-picker-indicator:hover {
                opacity: 1;
            }

            /* CSS cho Toast */
            .toast-notification {
                position: fixed;
                top: 0;
                left: 50%;
                transform: translate(-50%, -150%);
                min-width: 300px;
                max-width: 90%;
                z-index: 1050;
                padding: 15px 20px;
                border-radius: 0 0 8px 8px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
                text-align: center;
                font-size: 1.1em;
                opacity: 0;
                transition: transform 0.5s ease-out, opacity 0.5s ease-out;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
            }
            .toast-notification.active {
                transform: translate(-50%, 20px);
                opacity: 1;
            }
            .toast-success {
                background: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }
            .toast-info {
                background: #d1ecf1;
                color: #0c5460;
                border: 1px solid #bee5eb;
            }
        </style>
    </head>

    <body>

        <c:if test="${param.msg == 'added'}">
            <div id="toast-message" class="toast-notification toast-success active">
                <i class="fas fa-check-circle"></i> Product added successfully!
            </div>
        </c:if>
        <c:if test="${param.msg == 'updated'}">
            <div id="toast-message" class="toast-notification toast-info active">
                <i class="fas fa-info-circle"></i> Product updated successfully!
            </div>
        </c:if>
        <header>
            <div class="header-top">
                <div class="logo">GIO Admin</div> 

                <div class="admin-info">
                    <div class="admin-name"><i class="bi bi-person-fill"></i>: <c:out value="${sessionScope.staff.username}"/></div>

                    <div class="signout"><a href="${BASE_URL}/cookieHandle"><i class="bi bi-box-arrow-right"></i> Sign out</a></div>
                </div>
            </div>
        </header>

        <div class="main">
            <nav>
                <ul class="nav-list">

                    <li class="nav-link active" data-target="statistic">
                        <a href="${BASE_URL}/admin?tab=dashboard"><i class="fa-solid fa-chart-line"></i> <span>Dashboard</span> </a>
                    </li>
                    <li class="nav-link" data-target="product-manage">
                        <a href="${BASE_URL}/admin?tab=product" ><i class="bi bi-box"></i> <span>Product Management</span> </a>
                    </li>
                    <li class="nav-link" data-target="account-manage">
                        <a href="${BASE_URL}/admin?tab=account" ><i class="bi bi-person-badge-fill"></i> <span>Account management</span> </a>
                    </li>
                    <li class="nav-link" data-target="promo-manage">
                        <a href="${BASE_URL}/admin?tab=promo" ><i class="bi bi-tags-fill"></i> <span>Promo Management</span> </a>
                    </li>
                    <li class="nav-link" data-target="personal-info">
                        <a href="${BASE_URL}/admin?tab=personal" ><i class="bi bi-person-fill"></i> <span>Personal information</span> </a>
                    </li>
                </ul>
            </nav>

            <div class="main-content">

                <div class="statistic" style="display: block;">
                    <h3 style="font-weight: bold;"><i class="fa-solid fa-chart-line"></i> Dashboard</h3>

                    <hr>

                    <div class="card-container">
                        <div class="card">
                            <div class="card-inner"><h2>Products</h2><span><i class="bi bi-box"></i></span></div>
                            <h1>${stats.totalProducts}</h1>
                        </div>
                        <div class="card">
                            <div class="card-inner"><h2>Orders</h2><span><i class="bi bi-cart-fill"></i></span></div>
                            <h1>${stats.totalOrders}</h1>
                        </div>
                        <div class="card">
                            <div class="card-inner"><h2>Revenue</h2><span><i class="bi bi-currency-dollar"></i></span></div>
                            <h1><fmt:formatNumber value="${stats.totalRevenue}" type="currency" currencySymbol="₫" groupingUsed="true" maxFractionDigits="0"/></h1>
                        </div>
                        <div class="card">
                            <div class="card-inner"><h2>Customers</h2><span><i class="bi bi-people"></i></span></div>
                            <h1>${stats.totalCustomers}</h1>
                        </div>
                    </div>

                    <div>
                        <input type="month" class="form-control" style="width: auto;">
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"
                integrity="sha384-u1OknCvxWvY5kfmNBILK2hRnQC3Pr17a+RTT6rIHI7NnikvbZlHgTPOOmMi466C8"
        crossorigin="anonymous"></script>

        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.5/dist/jquery.validate.min.js"></script>

        <script>
            document.addEventListener("DOMContentLoaded", function () {
                // Logic cho Toast
                const toast = document.getElementById('toast-message');
                if (toast) {
                    setTimeout(() => {
                        toast.classList.add('active');
                    }, 300);
                    setTimeout(() => {
                        toast.classList.remove('active');
                    }, 4000);
                }

                // === JAVASCRIPT ĐIỀU HƯỚNG ĐÃ SỬA ===
                const navLinks = document.querySelectorAll('.nav-link');

                navLinks.forEach(link => {
                    link.addEventListener('click', function (e) {
                        e.preventDefault();
                        const targetLink = this.querySelector('a');
                        if (targetLink && targetLink.href) {
                            window.location.href = targetLink.href; // Chuyển hướng đến URL trong thẻ <a>
                        }
                    });
                });
                // === KẾT THÚC SỬA ĐỔI ===
            });
        </script>

    </body>

</html>