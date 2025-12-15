<%@page import="entity.Staff"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="BASE_URL" value="${pageContext.request.contextPath}" />

<%
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

<style>
    * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Quicksand', sans-serif; }
    html, body { height: 100%; background-color: #f4f7f6; overflow: hidden; }
    body {font-size: 0.9rem;}
    
    header { height: 50px; background-color: #2f2b2b; flex-shrink: 0; display: flex; align-items: center; justify-content: space-between; padding: 0 15px; position: relative; z-index: 1000; box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3); }
    .header-left { display: flex; align-items: center; gap: 15px; }
    
    .nav-toggle-btn { 
        background: none; 
        border: none; 
        color: white; 
        font-size: 1.5em; 
        cursor: pointer; 
        display: flex; 
        align-items: center; 
        justify-content: center; 
        width: 40px; 
        height: 40px; 
        border-radius: 50%; 
        transition: all 0.2s ease;
    }
    .nav-toggle-btn:hover { background-color: rgba(255, 255, 255, 0.15); }
    .nav-toggle-btn:active { background-color: rgba(255, 255, 255, 0.3); transform: scale(0.90); }

    .logo { font-size: 1.5em; font-weight: 600; color: white; }
    .logo a { text-decoration: none; color: white; display: block; transition: transform 0.1s; }
    .logo a:active { transform: scale(0.95); opacity: 0.8; }
    
    .header-right { display: flex; align-items: center; }
    .admin-info { display: flex; align-items: center; gap: 15px; color: white; font-size: 0.95em; position: relative; }
    
    .admin-name { 
        display: flex; 
        align-items: center; 
        gap: 8px; 
        color: white; 
        cursor: pointer; 
        padding: 8px 12px; 
        border-radius: 6px;
        position: relative; 
        transition: background-color 0.2s;
    }
    
    .admin-name:hover {
        background-color: rgba(255, 255, 255, 0.15);
    }
    .admin-name:active { 
        transform: translateY(1px); 
        background-color: rgba(255, 255, 255, 0.2); 
    }

    .admin-dropdown {
        display: none; 
        position: absolute;
        top: 100%; 
        right: 0;
        background-color: #fff;
        min-width: 200px;
        box-shadow: 0 8px 24px rgba(0,0,0,0.15);
        border-radius: 8px;
        padding: 8px 0;
        list-style: none;
        z-index: 1001;
        transform-origin: top right;
        animation: fadeInDrop 0.2s ease-in-out;
    }

    .admin-name:hover .admin-dropdown {
        display: block;
    }

    .admin-dropdown li a {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 10px 20px;
        text-decoration: none;
        color: #333;
        font-size: 14px;
        font-weight: 500;
        transition: all 0.2s;
    }

    .admin-dropdown li a i {
        font-size: 1.1em;
        color: #777;
        width: 20px;
        text-align: center;
    }

    .admin-dropdown li a:hover {
        background-color: #f8f9fa;
        color: #2f2b2b;
        padding-left: 25px;
    }
    
    .admin-dropdown li a:hover i {
        color: #2f2b2b;
    }

    @keyframes fadeInDrop {
        from { opacity: 0; transform: translateY(10px); }
        to { opacity: 1; transform: translateY(0); }
    }

    .main { display: flex; height: calc(100vh - 50px); }
    .sidebar { width: 250px; background-color: #2f2b2b; transition: width 0.3s ease; flex-shrink: 0; overflow-y: auto; overflow-x: hidden; }
    .main-content { flex-grow: 1; transition: width 0.3s ease; padding: 30px 40px; overflow-y: auto; background-color: #f4f7f6; width: calc(100% - 250px); }
    
    body.collapsed .sidebar { width: 60px; }
    body.collapsed .main-content { width: calc(100% - 60px); }
    body.collapsed .nav-list li a span { opacity: 0; visibility: hidden; width: 0; display: inline-block; }
    body.collapsed .nav-list li a { justify-content: flex-start; padding: 15px 20px; }
    body.collapsed .nav-list li a i { margin: 0; min-width: 20px; text-align: center; }

    .nav-list { list-style-type: none; padding: 0; margin: 0; }
    .nav-list li { padding: 0; border-bottom: 1px solid #444; }
    .nav-list li:last-child { border-bottom: none; }
    
    .nav-list li a { 
        padding: 15px 20px; 
        display: flex; 
        align-items: center; 
        justify-content: flex-start; 
        text-decoration: none; 
        color: #bbb; 
        transition: background-color 0.2s, color 0.2s, transform 0.1s; 
        overflow: hidden; 
        white-space: nowrap; 
        height: 55px; 
    }
    
    .nav-list li a i { 
        min-width: 30px; 
        font-size: 1.1em; 
        text-align: left; 
        transition: transform 0.2s; /* Added transition */
    }
    .nav-list li a span { margin-left: 10px; opacity: 1; transition: opacity 0.2s ease; }
    
    .nav-list li:hover { background-color: rgba(255, 255, 255, 0.05); }
    .nav-list li:hover a { color: white; }
    .nav-list li:hover a i { transform: translateX(3px); } /* Added hover effect */
    
    .nav-list li a:active { background-color: rgba(255, 255, 255, 0.1); transform: scale(0.98); }

    .nav-list li.active { border-left: 4px solid #0d6efd; background-color: rgba(0, 0, 0, 0.2); }
    .nav-list li.active a { color: white; }
    
    .main-content h3 { margin-bottom: 15px; color: #333; }
    .main-content hr { margin-bottom: 25px; border-top: 1px solid #ddd; }
    .admin-avatar { font-size: 1.5rem; }
    .staff-name-text { font-weight: 600; font-size: 0.95rem; max-width: 150px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
</style>

<header>
    <div class="header-left">
        <button id="sidebar-toggle" class="nav-toggle-btn"><i class="bi bi-list"></i></button>
        <div class="logo">
            <a href="${BASE_URL}/admin">GIO Admin</a>
        </div>
    </div>
    <div class="header-right">
        <div class="admin-info">
            <div class="admin-name">
                <i class="bi bi-person-circle admin-avatar"></i>
                <span class="admin-name-text">
            Hello, <c:out value="${sessionScope.staff.fullName != null ? sessionScope.staff.fullName : sessionScope.staff.username}" default="Staff"/>
        </span>
                <i class="bi bi-caret-down-fill" style="font-size: 0.8em; margin-left: 5px;"></i>
                
                <ul class="admin-dropdown">
                    <li>
                        <a href="${BASE_URL}/admin?tab=personal">
                            <i class="bi bi-person"></i> My Profile
                        </a>
                    </li>
                    <li style="border-top: 1px solid #eee; margin-top: 5px; padding-top: 5px;">
                        <a href="${BASE_URL}/cookieHandle" onclick="return confirm('Are you sure you want to Sign out?')">
                            <i class="bi bi-box-arrow-right text-danger"></i> <span class="text-danger">Sign Out</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</header>

<div class="main">
    <nav class="sidebar">
        <ul class="nav-list">
            <li class="nav-link ${param.tab == 'dashboard' || param.tab == null ? 'active' : ''}" data-target="dashboard">
                <a href="${BASE_URL}/admin?tab=dashboard">
                    <i class="fa-solid fa-chart-line"></i> <span>Dashboard</span>
                </a>
            </li>

            <li class="nav-link ${param.tab == 'product' ? 'active' : ''}" data-target="product-manage">
                <a href="${BASE_URL}/admin?tab=product">
                    <i class="bi bi-box"></i> <span>Product Management</span>
                </a>
            </li>

            <li class="nav-link ${param.tab == 'staff_account' ? 'active' : ''}" data-target="account-manage">
                <a href="${BASE_URL}/admin?tab=staff_account">
                    <i class="bi bi-person-badge-fill"></i> <span>Staff Management</span>
                </a>
            </li>
            
            <li class="nav-link ${param.tab == 'customer_manage' ? 'active' : ''}" data-target="customer-manage">
                <a href="${BASE_URL}/admin?tab=customer_manage">
                    <i class="bi bi-people-fill"></i> <span>Customer Management</span>
                </a>
            </li>
            
            <li class="nav-link ${param.tab == 'order' ? 'active' : ''}" data-target="order-manage">
                <a href="${BASE_URL}/admin?tab=order">
                    <i class="bi bi-cart-check-fill"></i> <span>Order Management</span>
                </a>
            </li>
            
            <li class="nav-link ${param.tab == 'import' ? 'active' : ''}" data-target="import-manage">
                <a href="${BASE_URL}/admin?tab=import">
                    <i class="bi bi-box-arrow-in-down"></i> <span>Import Management</span>
                </a>
            </li>

            <li class="nav-link ${param.tab == 'voucher' ? 'active' : ''}" data-target="voucher-manage">
                <a href="${BASE_URL}/admin?tab=voucher">
                    <i class="bi bi-tags-fill"></i> <span>Voucher Management</span>
                </a>
            </li>

            <li class="nav-link ${param.tab == 'personal' ? 'active' : ''}" data-target="personal-info">
                <a href="${BASE_URL}/admin?tab=personal">
                    <i class="bi bi-person-fill"></i> <span>My Profile</span>
                </a>
            </li>
        </ul>
    </nav>
    
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const adminBody = document.body; 
            const toggleButton = document.getElementById('sidebar-toggle');
            if(toggleButton){
                toggleButton.addEventListener('click', function () { 
                    adminBody.classList.toggle('collapsed'); 
                });
            }
            const navLinks = document.querySelectorAll('.nav-link');
            navLinks.forEach(link => {
                link.addEventListener('click', function (e) {
                    const targetLink = this.querySelector('a');
                    if (targetLink && targetLink.href && targetLink.getAttribute('href') !== '#') { 
                        window.location.href = targetLink.href; 
                    }
                });
            });
        });
    </script>