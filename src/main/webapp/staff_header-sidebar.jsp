<%@page import="entity.Staff"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="BASE_URL" value="${pageContext.request.contextPath}" />
<%
    String currentPath = request.getServletPath();
%>

<%
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

<style>
    * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Quicksand', sans-serif; }
    html, body { height: 100%; background-color: #f4f7f6; overflow: hidden; }
    body {font-size: 0.9rem;}
    
    :root {
        --header-bg: #a0816c;       
        --sidebar-bg: #4d4d4d;      
        --sidebar-hover: #5e5e5e;   
        --active-bg: rgba(160, 129, 108, 0.2); 
        --text-white: #f0f0f0;
    }

    header { 
        height: 50px; 
        background-color: var(--header-bg); 
        flex-shrink: 0; 
        display: flex; 
        align-items: center; 
        justify-content: space-between; 
        padding: 0 15px; 
        position: relative; 
        z-index: 1000; 
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2); 
    }
    
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
    .nav-toggle-btn:active { transform: scale(0.90); background-color: rgba(255, 255, 255, 0.3); }

    .logo { font-size: 1.5em; font-weight: 600; color: white; }
    .logo a { text-decoration: none; color: white; display: block; }
    
    .header-right { display: flex; align-items: center; }
    .staff-info { display: flex; align-items: center; gap: 15px; color: white; font-size: 0.95em; position: relative; }
    
    .staff-name { 
        display: flex; align-items: center; gap: 8px; color: white; cursor: pointer; 
        padding: 8px 12px; border-radius: 6px; position: relative; transition: background-color 0.2s;
    }
    .staff-name:hover { background-color: rgba(255, 255, 255, 0.15); }
    .staff-name:active { transform: translateY(1px); background-color: rgba(255, 255, 255, 0.2); }

    .staff-dropdown {
        display: none; position: absolute; top: 100%; right: 0;
        background-color: #fff; min-width: 200px;
        box-shadow: 0 8px 24px rgba(0,0,0,0.15); border-radius: 8px;
        padding: 8px 0; list-style: none; z-index: 1001;
        animation: fadeInDrop 0.2s ease-in-out;
    }
    .staff-name:hover .staff-dropdown { display: block; }

    .staff-dropdown li a {
        display: flex; align-items: center; gap: 10px; padding: 10px 20px;
        text-decoration: none; color: #333; font-size: 14px; font-weight: 500;
        transition: all 0.2s;
    }
    .staff-dropdown li a:hover { background-color: #f8f9fa; color: var(--header-bg); padding-left: 25px; }
    .staff-dropdown li a i { width: 20px; text-align: center; }

    .main { display: flex; height: calc(100vh - 50px); }
    
    .sidebar { 
        width: 250px; 
        background-color: var(--sidebar-bg); 
        transition: width 0.3s cubic-bezier(0.4, 0, 0.2, 1); 
        flex-shrink: 0; overflow-y: auto; overflow-x: hidden; 
        box-shadow: 2px 0 5px rgba(0,0,0,0.05);
    }
    
    .main-content { 
        flex-grow: 1; transition: width 0.3s ease; padding: 30px 40px; 
        overflow-y: auto; background-color: #f4f7f6; width: calc(100% - 250px); 
    }
    
    body.collapsed .sidebar { width: 60px; }
    body.collapsed .main-content { width: calc(100% - 60px); }
    body.collapsed .nav-list li a span { opacity: 0; visibility: hidden; width: 0; display: inline-block; }
    body.collapsed .nav-list li a { justify-content: center; padding: 15px 0; }
    body.collapsed .nav-list li a i { margin: 0; font-size: 1.3em; }

    .nav-list { list-style-type: none; padding: 0; margin: 0; }
    .nav-list li { padding: 0; border-bottom: 1px solid rgba(255,255,255,0.05); transition: all 0.2s; }
    
    .nav-list li a { 
        padding: 15px 20px; display: flex; align-items: center; justify-content: flex-start; 
        text-decoration: none; color: #d1d1d1; 
        transition: all 0.2s ease; 
        overflow: hidden; white-space: nowrap; height: 55px; 
        border-left: 4px solid transparent; 
    }
    
    .nav-list li a i { min-width: 30px; font-size: 1.1em; text-align: left; transition: transform 0.2s; }
    .nav-list li a span { margin-left: 10px; opacity: 1; transition: opacity 0.2s ease; font-weight: 500;}
    
    .nav-list li:hover { background-color: var(--sidebar-hover); }
    .nav-list li:hover a { color: white; }
    .nav-list li:hover a i { transform: translateX(3px); } 

    .nav-list li.active { background-color: rgba(0, 0, 0, 0.25); }
    .nav-list li.active a { 
        color: white; 
        font-weight: 600; 
        border-left: 4px solid var(--header-bg); 
        background: linear-gradient(90deg, rgba(160, 129, 108, 0.15) 0%, transparent 100%);
    }
    
    .nav-list li a:active {
        background-color: rgba(255, 255, 255, 0.1);
        transform: scale(0.98); 
    }

    @keyframes fadeInDrop { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
    
    .staff-avatar { font-size: 1.5rem; }
    .staff-name-text { font-weight: 600; font-size: 0.95rem; max-width: 150px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
</style>

<header>
    <div class="header-left">
        <button id="sidebar-toggle" class="nav-toggle-btn" title="Toggle Sidebar"><i class="bi bi-list"></i></button>
        <div class="logo">
            <a href="${BASE_URL}/staff">GIO Staff</a>
        </div>
    </div>
    <div class="header-right">
        <div class="staff-info">
            <div class="staff-name">
                <i class="bi bi-person-circle staff-avatar"></i>
                <span class="staff-name-text">
                    Hello, <c:out value="${sessionScope.staff.fullName != null ? sessionScope.staff.fullName : sessionScope.staff.username}" default="Staff"/>
                </span>
                <i class="bi bi-caret-down-fill" style="font-size: 0.8em; margin-left: 5px;"></i>
                
                <ul class="staff-dropdown">
                    <li>
                        <a href="${BASE_URL}/staff/profile">
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
            <li class="<%= currentPath.equals("/staff") ? "active" : "" %>" data-target="dashboard">
                <a href="${BASE_URL}/staff">
                    <i class="bi bi-speedometer2"></i> <span>Dashboard</span>
                </a>
            </li>

            <li class="<%= currentPath.contains("/staff/product") ? "active" : "" %>" data-target="product-list">
                <a href="${BASE_URL}/staff/product">
                    <i class="bi bi-box-seam"></i> <span>Product List</span>
                </a>
            </li>
            
            <li class="<%= currentPath.contains("/staff/customer") ? "active" : "" %>" data-target="customer-list">
                <a href="${BASE_URL}/staff/customer">
                    <i class="bi bi-people"></i> <span>Customer List</span>
                </a>
            </li>

            <li class="<%= currentPath.contains("/staff/order") ? "active" : "" %>" data-target="order-manage">
                <a href="${BASE_URL}/staff/order">
                    <i class="bi bi-cart-check"></i> <span>Order Management</span>
                </a>
            </li>

            <li class="<%= currentPath.contains("/staff/import") ? "active" : "" %>" data-target="import-manage">
                <a href="${BASE_URL}/staff/import">
                    <i class="bi bi-box-arrow-in-down"></i> <span>Import Management</span>
                </a>
            </li>
            
            <li class="<%= currentPath.contains("/staff/voucher") ? "active" : "" %>" data-target="voucher-list">
                <a href="${BASE_URL}/staff/voucher">
                    <i class="bi bi-tags"></i> <span>Voucher List</span>
                </a>
            </li>

            <li class="<%= currentPath.contains("/staff/profile") ? "active" : "" %>" data-target="my-profile">
                <a href="${BASE_URL}/staff/profile">
                    <i class="bi bi-person"></i> <span>My Profile</span>
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
            
            const navLinks = document.querySelectorAll('.nav-list li');
            navLinks.forEach(li => {
                li.addEventListener('click', function () {
                    navLinks.forEach(item => item.classList.remove('active'));
                    this.classList.add('active');
                });
            });
        });
    </script>