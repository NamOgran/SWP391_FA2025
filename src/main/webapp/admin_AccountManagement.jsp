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
            .nav-list li.active {
                background-color: rgb(122, 117, 120);
            } /* Đánh dấu tab đang active */
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

            /* CSS riêng cho Account Management */
            .account-search {
                width: 30%;
                margin-bottom: 15px;
            }
            .phoneNum-col {
                width: 15%;
            }
            .product-table .td-button {
                width: 1%;
                white-space: nowrap;
                min-width: 110px;
            }
            .product-table > .table > thead > tr > th {
                background-color: #000000 !important;
                color: #ffffff !important;
                border-color: #454d55;
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
            .toast-danger {
                background: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }
            .toast-warning {
                background: #fff3cd;
                color: #856404;
                border: 1px solid #ffeeba;
            }

            /* CSS cho Modal (Đã sao chép từ admin.jsp) */
            .modal-body .form-control {
                padding: 8px 12px;
                font-size: 1em;
            }
            .admin-form-modal .modal-content {
                background: white;
                border-radius: 15px;
                box-shadow: 0 20px 40px rgba(0,0,0,0.1);
                padding: 40px;
                border: none;
                animation: fadeIn 0.6s ease-out;
                position: relative;
            }
            .admin-form-modal .modal-dialog {
                max-width: 650px;
            }
            .admin-form-modal .btn-close-custom {
                position: absolute;
                top: 25px;
                right: 25px;
                z-index: 10;
                background: none;
                border: none;
                font-size: 1.5rem;
                color: #888;
                opacity: 0.7;
            }
            .admin-form-modal .btn-close-custom:hover {
                opacity: 1;
                color: #000;
            }
            .admin-form-modal .header {
                text-align: center;
                margin-bottom: 30px;
            }
            .admin-form-modal .header h1 {
                font-size: 2.5em;
                margin-bottom: 10px;
                font-weight: 600;
            }
            .admin-form-modal .header p {
                color: #666;
                font-size: 1.1em;
            }
            .admin-form-modal .form-group {
                margin-bottom: 25px;
                position: relative;
            }
            .admin-form-modal .form-group label {
                display: block;
                margin-bottom: 8px;
                font-weight: 600;
                font-size: 1.1em;
            }
            .admin-form-modal .form-group input, .admin-form-modal .form-group select, .admin-form-modal .form-group textarea {
                width: 100%;
                padding: 15px;
                border: 2px solid #e0e0e0;
                border-radius: 10px;
                font-size: 1em;
                transition: all 0.3s ease;
                background: #fafafa;
            }
            .admin-form-modal .form-group input:focus, .admin-form-modal .form-group select:focus {
                outline: none;
                background: white;
                transform: translateY(-2px);
            }
            .admin-form-modal .input-icon {
                position: relative;
            }
            .admin-form-modal .input-icon i {
                position: absolute;
                left: 15px;
                top: 50%;
                transform: translateY(-50%);
                font-size: 1.2em;
                pointer-events: none;
            }
            .admin-form-modal .input-icon input, .admin-form-modal .input-icon select {
                padding-left: 45px;
            }
            .admin-form-modal .submit-btn {
                width: 100%;
                padding: 15px;
                color: white;
                border: none;
                border-radius: 10px;
                font-size: 1.2em;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                text-transform: uppercase;
                letter-spacing: 1px;
            }
            .admin-form-modal .submit-btn:hover {
                transform: translateY(-3px);
            }
            .admin-form-modal .submit-btn:active {
                transform: translateY(-1px);
            }
            .admin-form-modal label.error {
                color: #e74c3c;
                font-size: 0.9em;
                margin-top: 5px;
                display: block;
                font-weight: 500;
            }
            .admin-form-modal input.error, .admin-form-modal select.error {
                border-color: #e74c3c !important;
                background: #fffafa !important;
            }
            .admin-form-modal .form-row {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
            }

            @media (max-width: 768px) {
                .admin-form-modal .form-row {
                    grid-template-columns: 1fr;
                }
                .admin-form-modal .modal-content {
                    padding: 20px;
                    margin: 10px;
                }
                .admin-form-modal .header h1 {
                    font-size: 2em;
                }
            }
            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            .admin-form-modal-green .header h1, .admin-form-modal-green .form-group label, .admin-form-modal-green .input-icon i {
                color: #198754;
            }
            .admin-form-modal-green .form-group input:focus, .admin-form-modal-green .form-group select:focus {
                border-color: #198754;
                box-shadow: 0 0 0 3px rgba(25, 135, 84, 0.2);
            }
            .admin-form-modal-green .submit-btn {
                background: linear-gradient(135deg, #198754 0%, #157347 100%);
            }
            .admin-form-modal-green .submit-btn:hover {
                background: linear-gradient(135deg, #157347 0%, #198754 100%);
                box-shadow: 0 10px 20px rgba(25, 135, 84, 0.3);
            }
            .admin-form-modal-blue .header h1, .admin-form-modal-blue .form-group label, .admin-form-modal-blue .input-icon i {
                color: #0d6efd;
            }
            .admin-form-modal-blue .form-group input:focus, .admin-form-modal-blue .form-group select:focus {
                border-color: #0d6efd;
                box-shadow: 0 0 0 3px rgba(13, 110, 253, 0.2);
            }
            .admin-form-modal-blue .submit-btn {
                background: linear-gradient(135deg, #0d6efd 0%, #0b5ed7 100%);
            }
            .admin-form-modal-blue .submit-btn:hover {
                background: linear-gradient(135deg, #0b5ed7 0%, #0d6efd 100%);
                box-shadow: 0 10px 20px rgba(13, 110, 253, 0.3);
            }
        </style>
    </head>

    <body>

        <c:if test="${param.msg == 'staff_added'}">
            <div id="toast-message" class="toast-notification toast-success active">
                <i class="fas fa-user-plus"></i> Staff account added successfully!
            </div>
        </c:if>
        <c:if test="${param.msg == 'account_updated'}">
            <div id="toast-message" class="toast-notification toast-info active">
                <i class="fas fa-user-edit"></i> Account updated successfully!
            </div>
        </c:if>
        <c:if test="${param.msg == 'account_deleted'}">
            <div id="toast-message" class="toast-notification toast-danger active">
                <i class="fas fa-user-times"></i> Account deleted successfully!
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
          
                     <li class="nav-link" data-target="statistic">
                        <a href="${BASE_URL}/admin?tab=dashboard"><i class="fa-solid fa-chart-line"></i> <span>Dashboard</span> </a>
                    </li>
                    <li class="nav-link" data-target="product-manage">
                 
                         <a href="${BASE_URL}/admin?tab=product" ><i class="bi bi-box"></i> <span>Product Management</span> </a>
                    </li>
                    <li class="nav-link active" data-target="account-manage"> <a href="${BASE_URL}/admin?tab=account" ><i class="bi bi-person-badge-fill"></i> <span>Account management</span> </a>
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

                <div class="account-manage" style="display: block;">
         
                     <h3 style="font-weight: bold;"><i class="bi bi-person-badge-fill"></i> Account Management</h3>
                    <hr>
                    <div class="filter" style="display: flex;
                         justify-content: space-between; align-items: center; margin-bottom: 20px;">

                        <form action="${BASE_URL}/admin" method="GET" style="display: flex;
                              gap: 10px; align-items: center;">
                            <input type="hidden" name="tab" value="account">
                            <div class="input-group" style="width: auto;">
                                <label class="input-group-text" for="roleFilter"><i 
                                     class="fas fa-filter"></i></label>
                                <select name="roleFilter" id="roleFilter" class="form-select" onchange="this.form.submit()">
                                    <option value="all" ${accountRoleFilter == 'all' ? 'selected' : ''}>All Accounts</option>
                  
                                     <option value="customer" ${accountRoleFilter == 'customer' ? 'selected' : ''}>Customers Only</option>
                                    <option value="staff" ${accountRoleFilter == 'staff' ? 'selected' : ''}>Staff Only</option>
                            
                                 </select>
                            </div>

                            <div class="input-group" style="width: auto;">
                                <input type="text" 
   
                                         name="search_account" 
                                       placeholder="Search Username"
                       
                                         class="form-control" 
                                       value="${accountSearch}">
                                <button class="btn btn-secondary" type="submit" title="Search">
        
                                     <i class="fas fa-search"></i>
                                </button>
                            </div>
          
                         </form>
                        <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addStaffModal">
                            <i class="fa fa-plus"></i> Add New Staff Account
                       
                         </button>
                    </div>


                    <div class="product-table table-responsive">
                        <table class="table table-striped table-hover table-bordered">
                            <thead>
 
                                 <tr>
                                    <th scope="col">ID</th>
                                
                                     <th scope="col">Username</th>
                                    <th scope="col">Fullname</th>
                                    <th scope="col" class="phoneNum-col">Phone</th>
                    
                                     <th scope="col">Email</th>
                                    <th scope="col">Address</th>
                                    <th scope="col">Role</th>
         
                                     <th scope="col" class="td-button">Actions</th>
                                </tr>
                            </thead>
           
                             <tbody>
                                <c:set var="accountFound" value="false" />

                                <c:forEach var="staff" items="${staffList}">
              
                                     <c:set var="accountFound" value="true" />
                                    <tr>
                                       
                                         <td>S-${staff.staff_id}</td>
                                        <td id="staff-username-${staff.staff_id}"><strong><c:out value="${staff.username}"/></strong></td>
                                        <td id="staff-fullname-${staff.staff_id}"><c:out value="${staff.fullName}"/></td>
               
                                         <td id="staff-phone-${staff.staff_id}"><c:out value="${staff.phoneNumber}"/></td>
                                        <td id="staff-email-${staff.staff_id}"><c:out value="${staff.email}"/></td>
                               
                                         <td id="staff-address-${staff.staff_id}"><c:out value="${staff.address}"/></td>
                                        <td style="${staff.role == 'admin' ?
                                                       'color: red; font-weight: bold;' : ''}">${staff.role == 'admin' ? 'Admin' : 'Staff'}</td>
                                        <td class="align-middle">
                                            <c:choose>
    
                                                 <c:when test="${staff.role == 'admin'}">
                                                    <button 
                                                         type="button" class="btn btn-sm btn-primary me-1" disabled title="Admin accounts cannot be edited">
                                                        <i class="fas fa-pencil-alt"></i>
                                
                                                     </button>
                                                    <button type="button" class="btn btn-sm btn-danger" disabled title="Admin accounts cannot be deleted">
                  
                                                         <i class="fas fa-trash"></i>
                                                    </button>
        
                                                 </c:when>
                                                <c:otherwise>
            
                                                     <button type="button" class="btn btn-sm btn-primary me-1"
                                                       
                                                          data-bs-toggle="modal"
                                                            data-bs-target="#updateAccountModal"
                                   
                                                              data-id="${staff.staff_id}"
                                                            data-type="staff"
               
                                                                 data-username="${staff.username}"
                                                       
                                                          data-email="${staff.email}"
                                                            data-fullname="${staff.fullName}"
                                   
                                                              data-phone="${staff.phoneNumber}"
                                                            data-address="${staff.address}"
               
                                                                 title="Update Staff">
                                                      
                                                       <i class="fas fa-pencil-alt"></i>
                                                    </button>
                                            
                                                    <%-- === BẮT ĐẦU SỬA ĐỔI: Nút Xóa Staff === --%>
                                                    <button type="button" class="btn btn-sm btn-danger"
                                                            data-bs-toggle="modal" 
                                                            data-bs-target="#deleteAccountModal"
                                                            data-username="${staff.username}"
                                                            data-type="staff"
                                                            data-id="${staff.staff_id}"
                                                            title="Delete Staff">
                                                        <i class="fas fa-trash"></i>
                                                    </button>
                                                    <%-- === KẾT THÚC SỬA ĐỔI === --%>
                                                </c:otherwise>
                                            </c:choose>
    
                                         </td>
                                    </tr>
                            
                                 </c:forEach>

                                <c:forEach var="customer" items="${customerList}">
                                    <c:set var="accountFound" value="true" />
                       
                                     <tr>
                                        <td>C-${customer.customer_id}</td>
                                        <td id="customer-username-${customer.customer_id}"><strong><c:out value="${customer.username}"/></strong></td>
     
                                         <td id="customer-fullname-${customer.customer_id}"><c:out value="${customer.fullName}"/></td>
                                        <td id="customer-phone-${customer.customer_id}"><c:out value="${customer.phoneNumber}"/></td>
                     
                                         <td id="customer-email-${customer.customer_id}"><c:out value="${customer.email}"/></td>
                                        <td id="customer-address-${customer.customer_id}"><c:out value="${customer.address}"/></td>
                                     
                                         <td>Customer</td>
                                        <td class="align-middle">
                                            <button type="button" class="btn btn-sm btn-primary me-1"
       
                                                          data-bs-toggle="modal"
                                                    data-bs-target="#updateAccountModal"
   
                                                          data-id="${customer.customer_id}"
                                                   
                                                            data-type="customer"
                                                    data-username="${customer.username}"
                                               
                                                          data-email="${customer.email}"
                                                    data-fullname="${customer.fullName}"
                                           
                                                          data-phone="${customer.phoneNumber}"
                                                    data-address="${customer.address}"
                                       
                                                          title="Update Customer">
                                                <i class="fas fa-pencil-alt"></i>
                                    
                                             </button>
                                            
                                            <%-- === BẮT ĐẦU SỬA ĐỔI: Nút Xóa Customer === --%>
                                            <button type="button" class="btn btn-sm btn-danger"
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#deleteAccountModal"
                                                    data-username="${customer.username}"
                                                    data-type="customer"
                                                    data-id="${customer.customer_id}"
                                                    title="Delete Customer">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                            <%-- === KẾT THÚC SỬA ĐỔI === --%>
                                        </td>
                                    </tr>
                
                                 </c:forEach>

                                <c:if test="${accountFound == false}">
                                    <tr>
             
                                         <td colspan="8" class="text-center text-muted">No accounts found matching your criteria.</td>
                                    </tr>
                             
                                 </c:if>
                            </tbody>
                        </table>
                    </div>

                    <c:if test="${accountTotalPages > 1}">
  
                         <nav aria-label="Account pagination" class="mt-4">
                            <ul class="pagination justify-content-center">
                                <li class="page-item ${accountCurrentPage == 1 ?
                                                        'disabled' : ''}">
                                    <a class="page-link" href="${BASE_URL}/admin?account_page=${accountCurrentPage - 1}&search_account=${accountSearch}&roleFilter=${accountRoleFilter}&tab=account">Previous</a>
                                </li>
                          
                                 <c:forEach begin="1" end="${accountTotalPages}" var="i">
                                    <li class="page-item ${i == accountCurrentPage ?
                                                         'active' : ''}">
                                        <a class="page-link" href="${BASE_URL}/admin?account_page=${i}&search_account=${accountSearch}&roleFilter=${accountRoleFilter}&tab=account">${i}</a>
                                    </li>
                    
                                 </c:forEach>

                                <li class="page-item ${accountCurrentPage == accountTotalPages ?
                                                        'disabled' : ''}">
                                    <a class="page-link" href="${BASE_URL}/admin?account_page=${accountCurrentPage + 1}&search_account=${accountSearch}&roleFilter=${accountRoleFilter}&tab=account">Next</a>
                                </li>
                          
                             </ul>
                        </nav>
                    </c:if>
                </div>
            </div>
        </div>


        <div class="modal fade admin-form-modal admin-form-modal-green" id="addStaffModal" tabindex="-1" aria-labelledby="addStaffModalLabel" aria-hidden="true">
  
             <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <button type="button" class="btn-close-custom" data-bs-dismiss="modal" aria-label="Close"><i class="fas fa-times"></i></button>
                    <div class="header">
                        
                         <h1><i class="fas fa-user-plus"></i> Add New Staff Account</h1>
                    </div>
                    <form action="${BASE_URL}/staff/account/add" method="POST" id="addStaffForm">
                        <input type="hidden" name="account_page" value="${accountCurrentPage}">
                        
                         <input type="hidden" name="search_account" value="${accountSearch}">
                        <input type="hidden" name="roleFilter" value="${accountRoleFilter}">

                        <div class="form-row">
                            <div class="form-group">
                
                                 <label for="add_staff_username"><i class="fas fa-user"></i> Username</label>
                                <div class="input-icon">
                                    <i class="fas fa-user"></i>
         
                                     <input type="text" id="add_staff_username" name="username" required placeholder="Enter username">
                                </div>
                                <label id="add_staff_username_error" class="error" 
                                       style="display: none;"></label>
                            </div>
                            <div class="form-group">
                                <label for="add_staff_email"><i class="fas fa-envelope"></i> Email</label>
      
                                 <div class="input-icon">
                                    <i class="fas fa-envelope"></i>
                                   
                                     <input type="email" id="add_staff_email" name="email" required placeholder="Enter email">
                                </div>
                            </div>
                        </div>

         
                         <div class="form-row">
                            <div class="form-group">
                                <label for="add_staff_password"><i class="fas fa-lock"></i> Password</label>
                   
                                 <div class="input-icon">
                                    <i class="fas fa-lock"></i>
                                    <input type="password" id="add_staff_password" name="password" required placeholder="Enter password (min 6 chars)">
   
                                 </div>
                            </div>
                            <div class="form-group">
              
                                 <label for="add_staff_confirm_pass"><i class="fas fa-check-circle"></i> Confirm Password</label>
                                <div class="input-icon">
                                    <i class="fas fa-check-circle"></i>
      
                                     <input type="password" id="add_staff_confirm_pass" name="confirmPassword" required placeholder="Confirm password">
                                </div>
                            </div>
    
                         </div>

                        <div class="form-row">
                            <div class="form-group">
                          
                                 <label for="add_staff_fullName"><i class="fas fa-user-circle"></i> Fullname</label>
                                <div class="input-icon">
                                    <i class="fas fa-user-circle"></i>
                   
                                     <input type="text" id="add_staff_fullName" name="fullName" required placeholder="Enter full name">
                                </div>
                            </div>
                
                             <div class="form-group">
                                <label for="add_staff_phone"><i class="fas fa-phone"></i> Phone</label>
                                <div class="input-icon">
                  
                                     <i class="fas fa-phone"></i>
                                    <input type="text" id="add_staff_phone" name="phone" required placeholder="Enter phone number">
                                </div>
     
                             </div>
                        </div>

                        <div class="form-group">
                            
                             <label for="add_staff_address"><i class="fas fa-map-marker-alt"></i> Address</label>
                            <div class="input-icon">
                                <i class="fas fa-map-marker-alt"></i>
                                <input 
                                     type="text" id="add_staff_address" name="address" required placeholder="Enter address">
                            </div>
                        </div>

                        <div class="form-group">
                  
                             <label for="add_staff_role"><i class="fas fa-user-tag"></i> Role</label>
                            <div class="input-icon">
                                <i class="fas fa-user-tag"></i>
                       
                                 <input type="text" id="add_staff_role" name="role" value="staff" 
                                       readonly style="font-weight: bold;
                                                      background-color: #e9ecef;">
                            </div>
                        </div>
                        <button type="submit" class="submit-btn">
                     
                             <i class="fas fa-plus-circle"></i> Add Staff
                        </button>
                    </form>
                </div>
            </div>
        </div>


        <div 
             class="modal fade admin-form-modal admin-form-modal-blue" id="updateAccountModal" tabindex="-1" aria-labelledby="updateAccountModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <button type="button" class="btn-close-custom" data-bs-dismiss="modal" aria-label="Close"><i class="fas fa-times"></i></button>
                    <div class="header">
               
                         <h1><i class="fas fa-user-edit"></i> Update Account</h1>
                    </div>
                    <form action="${BASE_URL}/staff/account/update" method="POST" id="updateAccountForm">
                        <input type="hidden" id="update_acc_id" name="id">
                 
                         <input type="hidden" id="update_acc_type" name="type">
                        <div class="form-row">
                            <div class="form-group">
                                <label for="update_acc_fullName"><i class="fas fa-user"></i> 
                                     Fullname</label>
                                <div class="input-icon">
                                    <i class="fas fa-user"></i>
                             
                                     <input type="text" id="update_acc_fullName" name="fullName" required>
                                </div>
                            </div>
                            <div 
                                 class="form-group">
                                <label for="update_acc_phone"><i class="fas fa-phone"></i> Phone</label>
                                <div class="input-icon">
                               
                                     <i class="fas fa-phone"></i>
                                    <input type="text" id="update_acc_phone" name="phone" required>
                                </div>
                     
                             </div>
                        </div>
                        <div class="form-group">
                            <label for="update_acc_email"><i class="fas fa-envelope"></i> Email</label>
            
                             <div class="input-icon">
                                <i class="fas fa-envelope"></i>
                                <input type="email" id="update_acc_email" name="email" required>
             
                             </div>
                        </div>
                        <div class="form-group">
                            <label for="update_acc_address"><i class="fas fa-map-marker-alt"></i> Address</label>
    
                             <div class="input-icon">
                                <i class="fas fa-map-marker-alt"></i>
                                <input type="text" id="update_acc_address" name="address" required>
     
                             </div>
                        </div>
                        <div class="form-row">
                            
                             <div class="form-group">
                                <label for="update_acc_username"><i class="fas fa-user-shield"></i> Username</label>
                                <div class="input-icon">
                              
                                     <i class="fas fa-user-shield"></i>
                                    <input type="text" id="update_acc_username" name="username" 
                                           readonly style="font-weight: bold;
                                                          background-color: #e9ecef;">
                                </div>
                            </div>
                            <div class="form-group">
          
                                 <label for="update_acc_role"><i class="fas fa-user-tag"></i> Role</label>
                                <div class="input-icon">
                                    <i class="fas fa-user-tag"></i>
   
                                     <input type="text" id="update_acc_role" name="role"
                                           readonly style="font-weight: bold;
                                                          background-color: #e9ecef;">
                                </div>
                            </div>
                        </div>
               
                         <button type="submit" class="submit-btn">
                            <i class="fas fa-save"></i> Save Changes
                        </button>
                    </form>
             
                 </div>
            </div>
        </div>

        <div class="modal fade" id="deleteAccountModal" tabindex="-1" aria-labelledby="deleteAccountModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-scrollable">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="deleteAccountModalLabel">Delete Account: <span>Username</span></h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        
                        <div id="deleteAccountWarning" class="alert alert-danger" style="display: none;">
                            <strong>Cannot Delete:</strong> This account has related data and cannot be deleted.
                        </div>
                        <div id="deleteAccountSuccess" class="alert alert-success" style="display: none;">
                            <strong>Safe to Delete:</strong> No related data was found. This account can be safely deleted.
                        </div>

                        <div id="accountDataLoading" class="text-center p-5">
                            <div class="spinner-border text-primary" role="status">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                            <p class="mt-2">Checking for related data...</p>
                        </div>

                        <div id="accountDataContent" style="display: none;">
                            
                            <div id="customerDataView" style="display: none;">
                                <p>The following related data was found for this <strong>Customer</strong>:</p>
                                <ul class="nav nav-tabs" id="customerDataTab" role="tablist">
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link active" id="cart-tab" data-bs-toggle="tab" data-bs-target="#cart-content" type="button" role="tab">Carts <span class="badge bg-secondary" id="cart-count">0</span></button>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link" id="feedback-tab" data-bs-toggle="tab" data-bs-target="#feedback-content" type="button" role="tab">Feedback <span class="badge bg-secondary" id="feedback-count">0</span></button>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link" id="cust-orders-tab" data-bs-toggle="tab" data-bs-target="#cust-orders-content" type="button" role="tab">Orders <span class="badge bg-secondary" id="cust-orders-count">0</span></button>
                                    </li>
                                </ul>
                                <div class="tab-content pt-3" id="customerDataTabContent">
                                    <div class="tab-pane fade show active" id="cart-content" role="tabpanel">
                                        <table class="table table-sm table-bordered">
                                            <thead><tr><th>Cart ID</th><th>Product ID</th><th>Size</th><th>Qty</th></tr></thead>
                                            <tbody id="cart-table-body"></tbody>
                                        </table>
                                        <p id="cart-none" class="text-muted" style="display: none;">No data found in 'cart'.</p>
                                    </div>
                                    <div class="tab-pane fade" id="feedback-content" role="tabpanel">
                                        <table class="table table-sm table-bordered">
                                            <thead><tr><th>ID</th><th>Rating</th><th>Content</th></tr></thead>
                                            <tbody id="feedback-table-body"></tbody>
                                        </table>
                                        <p id="feedback-none" class="text-muted" style="display: none;">No data found in 'feedback'.</p>
                                    </div>
                                    <div class="tab-pane fade" id="cust-orders-content" role="tabpanel">
                                        <table class="table table-sm table-bordered">
                                            <thead><tr><th>Order ID</th><th>Date</th><th>Total</th><th>Status</th></tr></thead>
                                            <tbody id="cust-orders-table-body"></tbody>
                                        </table>
                                        <p id="cust-orders-none" class="text-muted" style="display: none;">No data found in 'orders'.</p>
                                    </div>
                                </div>
                            </div>
                            
                            <div id="staffDataView" style="display: none;">
                                <p>The following related data was found for this <strong>Staff</strong>:</p>
                                <ul class="nav nav-tabs" id="staffDataTab" role="tablist">
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link active" id="staff-orders-tab" data-bs-toggle="tab" data-bs-target="#staff-orders-content" type="button" role="tab">Orders Handled <span class="badge bg-secondary" id="staff-orders-count">0</span></button>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link" id="imports-tab" data-bs-toggle="tab" data-bs-target="#imports-content" type="button" role="tab">Imports <span class="badge bg-secondary" id="imports-count">0</span></button>
                                    </li>
                                </ul>
                                <div class="tab-content pt-3" id="staffDataTabContent">
                                    <div class="tab-pane fade show active" id="staff-orders-content" role="tabpanel">
                                        <table class="table table-sm table-bordered">
                                            <thead><tr><th>Order ID</th><th>Date</th><th>Total</th><th>Status</th></tr></thead>
                                            <tbody id="staff-orders-table-body"></tbody>
                                        </table>
                                        <p id="staff-orders-none" class="text-muted" style="display: none;">No orders handled found.</p>
                                    </div>
                                    <div class="tab-pane fade" id="imports-content" role="tabpanel">
                                        <table class="table table-sm table-bordered">
                                            <thead><tr><th>Import ID</th><th>Date</th><th>Total</th><th>Status</th></tr></thead>
                                            <tbody id="imports-table-body"></tbody>
                                        </table>
                                        <p id="imports-none" class="text-muted" style="display: none;">No data found in 'import'.</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <button id="confirmAccountDeleteButton" type="button" class="btn btn-danger" style="display: none;">
                            <i class="fas fa-trash"></i> Confirm Delete
                        </button>
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
                  
                                     // Các hàm validation (được sao chép từ admin.jsp)
                                    $.validator.addMethod("validUsername", function (value, element) {
                                  
                                         return this.optional(element) || /^[a-zA-Z0-9_]{3,20}$/.test(value);
                                     }, "Username must be 3-20 chars (letters, numbers, or underscore _).");
                                     $.validator.addMethod("validFullname", function (value, element) {
                                        return this.optional(element) || /^[\p{L} ]{2,30}$/u.test(value.trim());
                                    }, "Fullname must be 2-30 chars and letters/spaces only.");
                                     $.validator.addMethod("validPhone", function (value, element) {
                                        return this.optional(element) || /^(0\d{9,10}|\+84\d{9})$/.test(value);
                                    }, "Invalid phone (e.g., 0912345678 or +84912345678).");
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
                                        const currentTarget = 'account-manage'; // Tab này là account-manage

             
                                         navLinks.forEach(link => {
                                            const targetId = link.getAttribute('data-target');
                                            if (targetId === currentTarget) {
                                                link.classList.add('active');
                                                 // Đánh dấu tab hiện tại
                                            }

                                            link.addEventListener('click', function (e) {
    
                                                 e.preventDefault();
                                                const targetLink = this.querySelector('a');
     
                                                 if (targetLink && targetLink.href) {
                                                    window.location.href 
                                                         = targetLink.href; // Chuyển hướng đến URL trong thẻ <a>
                                                }
                                           
                                             });
                                        });
                                        // === KẾT THÚC SỬA ĐỔI JS ĐIỀU HƯỚNG ===

                                        // === Logic cho Modal Update Account ===
                                        var 
                                             updateAccountModal = document.getElementById('updateAccountModal');
                                        if (updateAccountModal) {
                                            updateAccountModal.addEventListener('show.bs.modal', function (event) {
                                                
                                                 var button = event.relatedTarget;
                                                var id = button.getAttribute('data-id');
                                              
                                                  var type = button.getAttribute('data-type');
                                                var username = button.getAttribute('data-username');
                                            
                                                 var email = button.getAttribute('data-email');
                                                var fullname = button.getAttribute('data-fullname');
                                          
                                                  var phone = button.getAttribute('data-phone');
                                                var address = button.getAttribute('data-address');

                                        
                                                 $('#update_acc_id').val(id);
                                                $('#update_acc_type').val(type);
                                                 $('#update_acc_username').val(username);
                                                $('#update_acc_email').val(email);
                                                $('#update_acc_fullName').val(fullname);
                                                $('#update_acc_phone').val(phone);
                                                $('#update_acc_address').val(address);
                                                $('#update_acc_role').val(type.charAt(0).toUpperCase() + type.slice(1));
                                            });
                                        }

                                        // === VALIDATION CHO ADD STAFF ===
                                        $("#addStaffForm").validate({
     
                                             rules: {
                                                username: {required: true, validUsername: true}, // Bắt buộc
     
                                                 email: {required: true, email: true, minlength: 5, maxlength: 100},
                                                password: 
                                                     {required: true, minlength: 6},
                                                confirmPassword: {required: true, minlength: 6, equalTo: "#add_staff_password"},
                                           
                                                  fullName: {required: true, validFullname: true}, // Bắt buộc
                                                phone: {required: true, validPhone: true}, // Bắt buộc
                                 
                                                 address: {required: true, maxlength: 255} // Bắt buộc
                                            },
                                  
                                             messages: {
                                                username: {required: "Please enter a username"},
                                    
                                                 email: {required: "Please enter a valid email", email: "Invalid email format", minlength: "Email must be 5-100 chars", maxlength: "Email must be 5-100 chars"},
                                                password: {required: "Please provide a password", minlength: "Password must be at least 6 characters"},
     
                                                 confirmPassword: {required: "Please confirm the password", equalTo: "Passwords do not match"},
                                               
                                                 fullName: {required: "Please enter a full name"},
                                                phone: {required: "Please enter a phone number"},
                                       
                                                 address: {required: "Please enter an address", maxlength: "Address cannot exceed 255 characters"}
                                            },
                                    
                                             errorElement: "label",
                                            errorClass: "error",
                                            errorPlacement: function 
                                                 (error, element) {
                                                if (element.attr("name") === "username") {
                                              
                                                     $("#add_staff_username_error").html(error).show();
                                                } else {
                                                    error.insertAfter(element.closest('.input-icon'));
                                                }
                                            },
                                            submitHandler: function (form) {
         
                                                 var $form = $(form);
                                                 var $btn = $form.find('.submit-btn');
                                                $btn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Adding...');
                                                $("#add_staff_username_error").hide();
                                                 // Hide old server errors

                                                $.ajax({
                                                
                                                     url: $form.attr('action'),
                                                    type: 'POST',
                                          
                                                     data: $form.serialize(),
                                                    dataType: 'json',
                                    
                                                     success: function (data) {
                                                        if (data.isSuccess) {
                       
                                                              // Sửa: Chuyển hướng đến trang AccountManagement với tham số
                                                      
                                                               window.location.href = "${BASE_URL}/admin?tab=account&msg=staff_added";
                                                        } else {
                                  
                                                             if (data.description && data.description.includes("Username")) {
                                                                $("#add_staff_username_error").text(data.description).show();
                                                                $("#add_staff_username").addClass("error");
                                                            } else {
                                                                alert('Error: ' + (data.description || 'Could not add staff.'));
                                                            }
                                                            $btn.prop('disabled', false).html('<i class="fas fa-plus-circle"></i> Add Staff');
                                                        }
                                                    },
                                                
                                                     error: function () {
                                                        alert('Server error. Could not add staff.');
                                                        $btn.prop('disabled', false).html('<i class="fas fa-plus-circle"></i> Add Staff');
                                                    }
                                                });
                                             }
                                        });
                                         // === VALIDATION CHO UPDATE ACCOUNT ===
                                        $("#updateAccountForm").validate({
                                            rules: {
         
                                                 fullName: {required: true, validFullname: true}, // Bắt buộc
                                                phone: {required: true, validPhone: true}, // 
                                                     //Bắt buộc
                                                email: {required: true, email: true, minlength: 5, maxlength: 100},
                                           
                                                 address: {required: true, maxlength: 255} // Bắt buộc
                                            },
                                            
                                             messages: {
                                                fullName: {required: "Please enter a full name"},
                                             
                                                  phone: {required: "Please enter a phone number"},
                                                email: {required: "Please enter a valid email", email: "Invalid email format", minlength: "Email must be 5-100 chars", maxlength: "Email must be 5-100 chars"},
                     
                                                 address: {required: "Please enter an address", maxlength: "Address cannot exceed 255 characters"}
                                            },
                  
                                             errorElement: "label",
                                            errorClass: "error",
                            
                                                 errorPlacement: function (error, element) {
                                                error.insertAfter(element.closest('.input-icon'));
                                             },
                                            submitHandler: function (form) {
                                                var $form = $(form);
                                                var $btn = $form.find('.submit-btn');
                                                $btn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Updating...');
                                                var id = $form.find('input[name="id"]').val();
                                                var type = $form.find('input[name="type"]').val();
                                                var newFullName = $form.find('input[name="fullName"]').val();
                                                var newPhone = $form.find('input[name="phone"]').val();
                                                var newEmail = $form.find('input[name="email"]').val();
                                                var newAddress = $form.find('input[name="address"]').val();
                                                $.ajax({
                                                    url: $form.attr('action'),
                                               
                                                     type: 'POST',
                                                    data: $form.serialize(),
                                         
                                                     dataType: 'json',
                                                    success: function (data) {
                                 
                                                         if (data.isSuccess) {
                                                            // Cập nhật UI ngay trên bảng
         
                                                             $('#' + type + '-fullname-' + id).text(newFullName);
                                           
                                                                 $('#' + type + '-phone-' + id).text(newPhone);
                                                            $('#' + type + '-email-' + id).text(newEmail);
           
                                                                 $('#' + type + '-address-' + id).text(newAddress);

                                             
                                                             // Nếu admin tự sửa thông tin của mình
                                                            var adminUsername = '${sessionScope.staff.username}';
                                                            var editedUsername = $form.find('input[name="username"]').val();
                                                            if (type === 'staff' && editedUsername === adminUsername) {
                                                                // Tải lại trang để cập nhật session
                 
                                                                 window.location.href = "${BASE_URL}/admin?tab=account&msg=account_updated";
                                                                 return;
                                                            }

                                                            $('#updateAccountModal').modal('hide');
                                                             // Hiển thị toast
                                                            var toastHTML = '<div id="toast-message" class="toast-notification toast-info active">' +
                             
                                                                         '<i class="fas fa-user-edit"></i> Account updated successfully!</div>';
                                                             $('body').append(toastHTML);
                                                            setTimeout(function () {
                                                                $('#toast-message').remove(); // Xóa toast sau 4s
                            
                                                                 }, 4000);
                                                         } else {
                                                            alert('Error updating account: ' + (data.description || 'Email may already exist.'));
                                                         }
                                                        $btn.prop('disabled', false).html('<i class="fas fa-save"></i> Save Changes');
                                                     },
                                                    error: function () {
                                             
                                                         alert('Server error. Could not update account.');
                                                         $btn.prop('disabled', false).html('<i class="fas fa-save"></i> Save Changes');
                                                    }
                                                });
                                             }
                                        });
                                        
                                        // === LOGIC MỚI CHO MODAL XÁC NHẬN XÓA TÀI KHOẢN ===
                                        var deleteAccountModal = document.getElementById('deleteAccountModal');
                                        var confirmDeleteButton = document.getElementById('confirmAccountDeleteButton');

                                        if (deleteAccountModal) {
                                            deleteAccountModal.addEventListener('show.bs.modal', function (event) {
                                                var button = event.relatedTarget;
                                                var accountId = button.getAttribute('data-id');
                                                var accountUsername = button.getAttribute('data-username');
                                                var accountType = button.getAttribute('data-type');
                                                
                                                // Lưu trữ thông tin vào nút Confirm để sử dụng sau
                                                $(confirmDeleteButton).data('username', accountUsername);
                                                $(confirmDeleteButton).data('type', accountType);

                                                // Cập nhật tiêu đề modal
                                                var modalTitle = deleteAccountModal.querySelector('#deleteAccountModalLabel span');
                                                modalTitle.textContent = accountUsername + " (ID: " + accountId + ", Type: " + accountType + ")";

                                                // Reset trạng thái modal
                                                $('#accountDataLoading').show();
                                                $('#accountDataContent, #customerDataView, #staffDataView').hide();
                                                $('#deleteAccountWarning, #deleteAccountSuccess').hide();
                                                $(confirmDeleteButton).hide().removeClass('disabled').html('<i class="fas fa-trash"></i> Confirm Delete');
                                                
                                                // Xóa dữ liệu cũ
                                                $('#cart-table-body, #feedback-table-body, #cust-orders-table-body, #staff-orders-table-body, #imports-table-body').empty();
                                                $('#cart-none, #feedback-none, #cust-orders-none, #staff-orders-none, #imports-none').hide();

                                                // Hiển thị view phù hợp (Customer/Staff)
                                                if (accountType === 'customer') {
                                                    $('#customerDataView').show();
                                                    // Kích hoạt tab đầu tiên
                                                    $('#customerDataTab button[data-bs-target="#cart-content"]').tab('show');
                                                } else {
                                                    $('#staffDataView').show();
                                                    // Kích hoạt tab đầu tiên
                                                    $('#staffDataTab button[data-bs-target="#staff-orders-content"]').tab('show');
                                                }

                                                // Gọi AJAX để lấy dữ liệu liên quan
                                                $.ajax({
                                                    url: '${BASE_URL}/admin/accountRelatedData',
                                                    type: 'GET',
                                                    data: { id: accountId, type: accountType },
                                                    dataType: 'json',
                                                    success: function(data) {
                                                        var hasRelatedData = false;

                                                        if (accountType === 'customer') {
                                                            // 1. Carts
                                                            if (data.carts && data.carts.length > 0) {
                                                                hasRelatedData = true;
                                                                $('#cart-count').text(data.carts.length).removeClass('bg-secondary').addClass('bg-danger');
                                                                $.each(data.carts, function(i, item) {
                                                                    $('#cart-table-body').append('<tr><td>' + item.cart_id + '</td><td>' + item.product_id + '</td><td>' + item.size_name + '</td><td>' + item.quantity + '</td></tr>');
                                                                });
                                                            } else {
                                                                $('#cart-count').text(0).removeClass('bg-danger').addClass('bg-secondary');
                                                                $('#cart-none').show();
                                                            }
                                                            // 2. Feedbacks
                                                            if (data.feedbacks && data.feedbacks.length > 0) {
                                                                hasRelatedData = true;
                                                                $('#feedback-count').text(data.feedbacks.length).removeClass('bg-secondary').addClass('bg-danger');
                                                                $.each(data.feedbacks, function(i, item) {
                                                                    $('#feedback-table-body').append('<tr><td>' + item.feedback_id + '</td><td>' + item.rate_point + '</td><td>' + (item.content || '') + '</td></tr>');
                                                                });
                                                            } else {
                                                                $('#feedback-count').text(0).removeClass('bg-danger').addClass('bg-secondary');
                                                                $('#feedback-none').show();
                                                            }
                                                            // 3. Customer Orders
                                                            if (data.orders && data.orders.length > 0) {
                                                                hasRelatedData = true;
                                                                $('#cust-orders-count').text(data.orders.length).removeClass('bg-secondary').addClass('bg-danger');
                                                                $.each(data.orders, function(i, item) {
                                                                    $('#cust-orders-table-body').append('<tr><td>' + item.orderID + '</td><td>' + (item.date ? new Date(item.date).toLocaleDateString() : 'N/A') + '</td><td>' + item.total + '</td><td>' + item.status + '</td></tr>');
                                                                });
                                                            } else {
                                                                $('#cust-orders-count').text(0).removeClass('bg-danger').addClass('bg-secondary');
                                                                $('#cust-orders-none').show();
                                                            }
                                                        } else { // staff
                                                            // 1. Staff Orders
                                                            if (data.orders && data.orders.length > 0) {
                                                                hasRelatedData = true;
                                                                $('#staff-orders-count').text(data.orders.length).removeClass('bg-secondary').addClass('bg-danger');
                                                                $.each(data.orders, function(i, item) {
                                                                    $('#staff-orders-table-body').append('<tr><td>' + item.orderID + '</td><td>' + (item.date ? new Date(item.date).toLocaleDateString() : 'N/A') + '</td><td>' + item.total + '</td><td>' + item.status + '</td></tr>');
                                                                });
                                                            } else {
                                                                $('#staff-orders-count').text(0).removeClass('bg-danger').addClass('bg-secondary');
                                                                $('#staff-orders-none').show();
                                                            }
                                                            // 2. Imports
                                                            if (data.imports && data.imports.length > 0) {
                                                                hasRelatedData = true;
                                                                $('#imports-count').text(data.imports.length).removeClass('bg-secondary').addClass('bg-danger');
                                                                $.each(data.imports, function(i, item) {
                                                                    $('#imports-table-body').append('<tr><td>' + item.id + '</td><td>' + (item.date ? new Date(item.date).toLocaleDateString() : 'N/A') + '</td><td>' + item.total + '</td><td>' + item.status + '</td></tr>');
                                                                });
                                                            } else {
                                                                $('#imports-count').text(0).removeClass('bg-danger').addClass('bg-secondary');
                                                                $('#imports-none').show();
                                                            }
                                                        }

                                                        // Ẩn loading, hiển thị nội dung
                                                        $('#accountDataLoading').hide();
                                                        $('#accountDataContent').show();
                                                        
                                                        // Hiển thị/Ẩn nút xóa
                                                        if (hasRelatedData) {
                                                            $('#deleteAccountWarning').show();
                                                            $(confirmDeleteButton).hide();
                                                        } else {
                                                            $('#deleteAccountSuccess').show();
                                                            $(confirmDeleteButton).show();
                                                        }
                                                    },
                                                    error: function(jqXHR, textStatus, errorThrown) {
                                                        $('#accountDataLoading').html('<div class="alert alert-danger"><strong>Error:</strong> ' + (jqXHR.responseJSON || errorThrown) + '</div>');
                                                    }
                                                });
                                            });
                                        }

                                        // Thêm trình xử lý click cho nút xác nhận xóa (Sử dụng logic từ code cũ của bạn)
                                        $(confirmDeleteButton).on('click', function () {
                                            var btn = $(this);
                                            var username = btn.data('username');
                                            var type = btn.data('type');
                                            var url = '';

                                            if (type === 'staff') {
                                                url = '${BASE_URL}/staff/product/delete-staff';
                                            } else {
                                                url = '${BASE_URL}/staff/account/delete-customer';
                                            }

                                            // Vô hiệu hóa nút để tránh click đúp
                                            btn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Deleting...');

                                            $.ajax({
                                                url: url,
                                                type: 'POST',
                                                data: {username: username},
                                                dataType: 'json',
                                                success: function (data) {
                                                    if (data.isSuccess) {
                                                        // Tải lại trang với thông báo thành công
                                                        window.location.href = "${BASE_URL}/admin?tab=account&msg=account_deleted";
                                                    } else {
                                                        // Hiển thị lỗi nếu backend (vì lý do nào đó) vẫn báo lỗi
                                                        alert('Error deleting account: ' + (data.description || 'An unknown error occurred.'));
                                                        btn.prop('disabled', false).html('<i class="fas fa-trash"></i> Confirm Delete');
                                                    }
                                                },
                                                error: function (jqXHR, textStatus, errorThrown) {
                                                    alert('Server error. Could not delete account. Status: ' + textStatus);
                                                    btn.prop('disabled', false).html('<i class="fas fa-trash"></i> Confirm Delete');
                                                }
                                            });
                                        });
                                        // === KẾT THÚC LOGIC MODAL XÁC NHẬN XÓA ===

                                     }); // <-- Đóng DOMContentLoaded
        </script>

    </body>

</html>