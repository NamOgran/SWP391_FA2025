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

            /* CSS riêng cho Product Management */
            .filter {
                padding-bottom: 8px;
            }
            .product-table th {
                background-color: #f8f9fa;
            }
            .product-table .td-button {
                width: 1%;
                white-space: nowrap;
                min-width: 140px;
            }
            .table-secondary td, .table-secondary th {
                opacity: 0.6;
                font-style: italic;
                background-color: #e9ecef !important;
            }
            .table-secondary img {
                filter: grayscale(80%);
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
            .admin-form-modal .form-group textarea {
                padding-left: 15px;
                resize: vertical;
            }
            .admin-form-modal .form-group input:focus, .admin-form-modal .form-group select:focus, .admin-form-modal .form-group textarea:focus {
                outline: none;
                background: white;
                transform: translateY(-2px);
            }
            .admin-form-modal .form-group input[type="number"] {
                -moz-appearance: textfield;
            }
            .admin-form-modal .form-group input[type="number"]::-webkit-outer-spin-button, .admin-form-modal .form-group input[type="number"]::-webkit-inner-spin-button {
                -webkit-appearance: none;
                margin: 0;
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
            .admin-form-modal .input-icon.textarea-icon i {
                top: 18px;
                transform: translateY(0);
            }
            .admin-form-modal .input-icon input, .admin-form-modal .input-icon select {
                padding-left: 45px;
            }
            .admin-form-modal .input-icon textarea {
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
            .admin-form-modal input.error, .admin-form-modal select.error, .admin-form-modal textarea.error {
                border-color: #e74c3c !important;
                background: #fffafa !important;
            }
            .admin-form-modal .form-row {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
            }
            .admin-form-modal .product-preview {
                text-align: center;
                margin: 20px 0;
                padding: 20px;
                background: #f8f9fa;
                border-radius: 10px;
                border-width: 2px;
                border-style: dashed;
            }
            .admin-form-modal .product-preview img {
                max-width: 200px;
                max-height: 200px;
                border-radius: 10px;
                margin-bottom: 10px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
                object-fit: contain;
            }
            .admin-form-modal .preview-text {
                color: #666;
                font-style: italic;
            }
            .admin-form-modal .success-message {
                background: #d4edda;
                color: #155724;
                padding: 15px;
                border-radius: 10px;
                margin-bottom: 20px;
                border: 1px solid #c3e6cb;
                display: none;
                text-align: center;
            }
            .admin-form-modal .back-link {
                display: none;
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
            .admin-form-modal-green .product-preview {
                border-color: #198754;
            }
            .admin-form-modal-green .form-group input:focus, .admin-form-modal-green .form-group select:focus, .admin-form-modal-green .form-group textarea:focus {
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
            .admin-form-modal-blue .product-preview {
                border-color: #0d6efd;
            }
            .admin-form-modal-blue .form-group input:focus, .admin-form-modal-blue .form-group select:focus, .admin-form-modal-blue .form-group textarea:focus {
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
        <c:if test="${param.msg == 'deleted'}">
            <div id="toast-message" class="toast-notification toast-danger active">
                <i class="fas fa-trash-alt"></i> Product deleted successfully!
            </div>
        </c:if>
        <c:if test="${param.msg == 'activated'}">
            <div id="toast-message" class="toast-notification toast-success active">
                <i class="fas fa-eye"></i> Product reactivated successfully!
            </div>
        </c:if>
        <c:if test="${param.msg == 'deactivated'}">
            <div id="toast-message" class="toast-notification toast-warning active">
                <i class="fas fa-eye-slash"></i> Product deactivated successfully!
            </div>
        </c:if>

        <%-- HIỂN THỊ CÁC LỖI TÙY CHỈNH (VÍ DỤ: LỖI KHÔNG XÓA ĐƯỢC) --%>
        <c:if test="${not empty param.msg and 
                      param.msg != 'added' and param.msg != 'updated' and param.msg != 'deleted' and 
                      param.msg != 'activated' and param.msg != 'deactivated'}">

              <div id="toast-message" class="toast-notification 
                   toast-danger active">
                  <i class="fas fa-exclamation-triangle"></i> <c:out value="${param.msg}"/>
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
                    <li class="nav-link active" data-target="product-manage"> <a href="${BASE_URL}/admin?tab=product" ><i class="bi bi-box"></i> <span>Product Management</span> </a>
                    </li>
                    <li class="nav-link" data-target="account-manage">
                        <a href="${BASE_URL}/admin?tab=account" 
                           ><i class="bi bi-person-badge-fill"></i> <span>Account management</span> </a>
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

                <div class="product-manage" style="display: block;">
                    <h3 style="font-weight: bold;"><i class="bi bi-box"></i> Product Management</h3>
                    <hr>

                    <div class="filter" style="display: 
                         flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">

                        <form action="${BASE_URL}/admin" method="get" style="display: flex;
                              gap: 10px; align-items: center; flex-wrap: wrap;">
                            <input type="hidden" name="tab" value="product">

                            <div class="input-group" style="width: auto;">
                                <label 
                                     class="input-group-text" for="filter-category"><i class="fas fa-layer-group"></i></label>
                                <select name="category" id="filter-category" class="form-select" onchange="this.form.submit()">
                                    <option value="0">-- All Categories --</option>
                     
                                     <c:forEach var="cate" items="${cateList}">
                                        <option value="${cate.category_id}" ${selectedCategory == cate.category_id ? 'selected' : ''}>
                                   
                                             <c:out value="${cate.type}"/> (<c:out value="${cate.gender}"/>)
                                        </option>
                                    </c:forEach>
            
                                 </select>
                            </div>

                            <div class="input-group" style="width: auto;">
                     
                                 <label class="input-group-text" for="filter-status"><i class="fas fa-toggle-on"></i></label>
                                <select name="status" id="filter-status" class="form-select" onchange="this.form.submit()">
                                    <option value="all" ${selectedStatus == 'all' ?
                                                         'selected' : ''}>All Statuses</option>
                                    <option value="active" ${selectedStatus == 'active' ?
                                                           'selected' : ''}>Active Only</option>
                                    <option value="inactive" ${selectedStatus == 'inactive' ?
                                                             'selected' : ''}>Inactive Only</option>
                                </select>
                            </div>

                            <div class="input-group" style="width: auto;">
      
                                 <label class="input-group-text" for="filter-price"><i class="fas fa-sort"></i></label>
                                <select name="sort" id="filter-price" class="form-select" onchange="this.form.submit()">
                                  
                                     <option value="">-- Sort by --</option>
                                    <option value="price_asc" ${sortBy == 'price_asc' ?
                                                             'selected' : ''}>Price Ascending ↑</option>
                                    <option value="price_desc" ${sortBy == 'price_desc' ?
                                                              'selected' : ''}>Price Descending ↓</option>
                                    <option value="name_asc" ${sortBy == 'name_asc' ?
                                                            'selected' : ''}>Name A-Z</option>
                                    <option value="name_desc" ${sortBy == 'name_desc' ?
                                                             'selected' : ''}>Name Z-A</option>
                                </select>
                            </div>

                            <div class="input-group" style="width: auto;">
      
                                 <input type="text" name="search" placeholder="Search product name" 
                                       value="<c:out value='${searchName}'/>" id="searchInput" class="form-control">
                          
                                 <button type="submit" class="btn btn-secondary">
                                    <i class="fa fa-search"></i>
                                </button>
                     
                            </div>
                        </form>
                        <button type="button" class="btn btn-success" 
                                data-bs-toggle="modal" data-bs-target="#addProductModal">
        
                             <i class="fa fa-plus"></i> Add New Product
                        </button>
                    </div>

                    <div class="product-table table-responsive">
         
                         <table class="table table-striped table-hover table-bordered">
                            <thead>
                                <tr>
                     
                                     <th>Picture</th>
                                    <th>Name</th>
                                    <th>Category</th>
             
                                     <th>Price</th>
                                    <th>Quantity</th>
                                    <th>Promotion</th>
     
                                     <th>Description</th>
                                    <th class="td-button">Actions</th>
                                
                                 </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${list}">
          
                                     <tr class="${p.is_active ?
                                                      '' : 'table-secondary'}">
                                        <td class="align-middle">
                                            <img src="<c:out value='${p.picURL}'/>"
           
                                                   style="width:80px;
                                                          height:80px; object-fit:contain; border-radius:4px;"
                                                 alt="<c:out value='${p.name}'/>">
                                        </td>
        
                                         <td class="align-middle"><strong><c:out value="${p.name}"/></strong></td>
                                        <td class="align-middle">
                         
                                             <c:out value="${categoryMap[p.categoryID]}"/>
                                        </td>
                                        
                                         <td class="align-middle">
                                            <fmt:formatNumber value="${p.price}" type="number" groupingUsed="true"/> ₫
                                        </td>
           
                                         <td class="align-middle"><c:out value="${p.quantity}"/></td>
                                        <td class="align-middle">
                            
                                             <c:choose>
                                                <c:when test="${not empty promoMap[p.promoID]}">
                                 
                                                     <c:out value="${promoMap[p.promoID]}"/>
                                                </c:when>
                                
                                                 <c:otherwise>
                                                    None
                                
                                                 </c:otherwise>
                                            </c:choose>
                                        
                                         </td>
                                        <td class="align-middle" style="max-width: 200px;
                                                                          white-space: pre-wrap; word-break: break-word;">
                                            <c:out value="${p.description}"/>
                                        </td>
            
                                         <td class="align-middle">
                                            <button type="button" class="btn btn-sm btn-primary me-1"
                      
                                                      data-bs-toggle="modal"
                                                    data-bs-target="#updateProductModal"
                  
                                                      data-id="${p.id}"
                                                    data-name="<c:out value='${p.name}'/>"
             
                                                         data-price="${p.price}"
                                                    data-quantity="${p.quantity}"
         
                                                         data-picurl="<c:out value='${p.picURL}'/>"
                                                    data-description="<c:out value='${p.description}'/>"
   
                                                      data-categoryid="${p.categoryID}"
                                                   
                                                        data-promoid="${p.promoID}"
                                                    title="Update">
                                               
                                                 <i class="fas fa-pencil-alt"></i>
                                            </button>

                                            <c:set var="encodedSearch" value="${fn:replace(searchName, ' ', '+')}" />
   
                                            <%-- === BẮT ĐẦU SỬA ĐỔI: Nút Deactivate/Reactivate === --%>
                                            <c:choose>
                                                <c:when test="${p.is_active}">
                                                    <%-- Đổi <a> thành <button> và thêm data-bs-toggle --%>
                                                    <button type="button" class="btn btn-sm btn-success me-1"
                                                            data-bs-toggle="modal"
                                                            data-bs-target="#toggleStatusModal"
                                                            data-action-url="${BASE_URL}/toggleProductStatus?id=${p.id}&page=${currentPage}&sort=${sortBy}&search=${encodedSearch}&category=${selectedCategory}&status=${selectedStatus}&tab=product"
                                                            data-product-name="<c:out value='${p.name}'/>"
                                                            data-action-type="Deactivate"
                                                            title="Deactivate">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <%-- Đổi <a> thành <button> và thêm data-bs-toggle --%>
                                                    <button type="button" class="btn btn-sm btn-warning me-1"
                                                            data-bs-toggle="modal"
                                                            data-bs-target="#toggleStatusModal"
                                                            data-action-url="${BASE_URL}/toggleProductStatus?id=${p.id}&page=${currentPage}&sort=${sortBy}&search=${encodedSearch}&category=${selectedCategory}&status=${selectedStatus}&tab=product"
                                                            data-product-name="<c:out value='${p.name}'/>"
                                                            data-action-type="Reactivate"
                                                            title="Reactivate">
                                                        <i class="fas fa-eye-slash"></i>
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                            <%-- === KẾT THÚC SỬA ĐỔI === --%>
  
                                            <button type="button" class="btn btn-sm btn-danger"
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#deleteConfirmationModal"
                                                    data-product-id="${p.id}"
                                                    data-product-name="<c:out value='${p.name}'/>"
                                                    title="Delete Product">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                            </td>
               
                                     </tr>
                                </c:forEach>

                                <c:if test="${empty list}">
             
                                     <tr>
                                        <td colspan="8" class="text-center text-muted">No products found matching your criteria.</td>
                             
                                     </tr>
                                </c:if>
                            </tbody>
                        </table>
         
                     </div>

                    <c:if test="${totalPages > 1}">
                        <nav aria-label="Product pagination" class="mt-4">
                            <ul class="pagination justify-content-center">
         
                                 <li class="page-item ${currentPage == 1 ?
                                                      'disabled' : ''}">
                                    <a class="page-link" href="${BASE_URL}/admin?page=${currentPage - 1}&sort=${sortBy}&search=${encodedSearch}&category=${selectedCategory}&status=${selectedStatus}&tab=product">Previous</a>
                                </li>
                          
                                 <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${i == currentPage ?
                                                         'active' : ''}">
                                        <a class="page-link" href="${BASE_URL}/admin?page=${i}&sort=${sortBy}&search=${encodedSearch}&category=${selectedCategory}&status=${selectedStatus}&tab=product">${i}</a>
                                    </li>
                    
                                 </c:forEach>
                                <li class="page-item ${currentPage == totalPages ?
                                                     'disabled' : ''}">
                                    <a class="page-link" href="${BASE_URL}/admin?page=${currentPage + 1}&sort=${sortBy}&search=${encodedSearch}&category=${selectedCategory}&status=${selectedStatus}&tab=product">Next</a>
                                </li>
                          
                             </ul>
                        </nav>
                    </c:if>
                </div>
            </div>
        </div>


        <div class="modal fade admin-form-modal admin-form-modal-green" id="addProductModal" tabindex="-1" aria-labelledby="addProductModalLabel" aria-hidden="true">
  
             <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <button type="button" class="btn-close-custom" data-bs-dismiss="modal" aria-label="Close"><i class="fas fa-times"></i></button>
                    <div class="header">
                        
                         <h1><i class="fas fa-plus-circle"></i> Add New Product</h1>
                        <p>Enter product information below</p>
                    </div>
                    <div class="success-message" id="addSuccessMessage">
                        <i class="fas 
                             fa-check-circle"></i> Product add submitted! Redirecting...
                    </div>
                    <div class="product-preview">
                        <img id="addPreviewImage" src="https://via.placeholder.com/200x200?text=Enter+URL" alt="Product Preview">
                        <div class="preview-text">Product Image 
                             Preview</div>
                    </div>
                    <form action="${BASE_URL}/addProduct" method="post" id="addForm">
                        <input type="hidden" name="current_page" value="${currentPage}">
                        <input type="hidden" name="current_sort" value="${sortBy}">
   
                         <input type="hidden" name="current_search" value="${searchName}">
                        <input type="hidden" name="current_category" value="${selectedCategory}">
                        <input type="hidden" name="current_status" value="${selectedStatus}">
                      
                         <div class="form-row">
                            <div class="form-group">
                                <label for="add_name"><i class="fas fa-tag"></i> Product Name</label>
                               
                                 <div class="input-icon">
                                    <i class="fas fa-tag"></i>
                                    <input type="text" id="add_name" name="name" required placeholder="Enter product name">
                 
                                 </div>
                            </div>
                            <div class="form-group">
                            
                                 <label for="add_price"><i class="fas fa-dollar-sign"></i> Price (₫)</label>
                                <div class="input-icon">
                                    <i class="fas fa-dollar-sign"></i>
                    
                                     <input type="number" id="add_price" name="price" min="0" required placeholder="Enter price">
                                </div>
                            </div>
                 
                         </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="add_quantity"><i class="fas fa-boxes"></i> Quantity</label>
   
                                 <div class="input-icon">
                                    <i class="fas fa-boxes"></i>
                                
                                     <input type="number" id="add_quantity" name="quantity" min="0" required placeholder="Enter quantity">
                                </div>
                            </div>
                            <div 
                                 class="form-group">
                                <label for="add_promo"><i class="fas fa-percentage"></i> Promotion</label>
                                <div class="input-icon">
                               
                                     <i class="fas fa-percentage"></i>
                                    <select id="add_promo" name="promo" required>
                                        <option value="">-- Select Promo --</option>
          
                                         <c:forEach var="p" items="${promoList}">
                                            <option value="${p.promoID}">
                       
                                                 <c:out value="${p.promoPercent}"/>% (<fmt:formatDate value="${p.startDate}" pattern="dd/MM"/>-<fmt:formatDate value="${p.endDate}" pattern="dd/MM"/>)
                                            </option>
                         
                                         </c:forEach>
                                        <option value="0">None</option>
                                    </select>
        
                                 </div>
                            </div>
                        </div>
                        
                         <div class="form-row">
                            <div class="form-group">
                                <label for="add_category"><i class="fas fa-layer-group"></i> Category</label>
                                <div class="input-icon">
 
                                     <i class="fas fa-layer-group"></i>
                                    <select id="add_category" name="category" required>
                        
                                         <option value="">-- Select Category --</option>
                                        <c:forEach var="cate" items="${cateList}">
                                      
                                             <option value="${cate.category_id}">
                                                <c:out value="${cate.type}"/> (<c:out value="${cate.gender}"/>)
                                          
                                             </option>
                                        </c:forEach>
                                    </select>
                      
                                 </div>
                            </div>
                            <div class="form-group">
                                <label 
                                     for="add_pic"><i class="fas fa-image"></i> Image URL</label>
                                <div class="input-icon">
                                    <i class="fas fa-image"></i>
                         
                                     <input type="text" name="pic" id="add_pic" required placeholder="Enter image URL" oninput="updateAddPreview()">
                                </div>
                            </div>
                     
                         </div>
                        <div class="form-group">
                            <label for="add_des"><i class="fas fa-align-left"></i> Description</label>
                            <div class="input-icon textarea-icon"> 
         
                                 <i class="fas fa-align-left"></i>
                                <textarea id="add_des" name="des" rows="3" required placeholder="Enter product description"></textarea>
                            </div>
        
                         </div>
                        <button type="submit" class="submit-btn">
                            <i class="fas fa-save"></i> Add Product
                        </button>
  
                     </form>
                </div>
            </div>
        </div>

        <div class="modal fade admin-form-modal admin-form-modal-blue" id="updateProductModal" tabindex="-1" aria-labelledby="updateProductModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                
                 <div class="modal-content">
                    <button type="button" class="btn-close-custom" data-bs-dismiss="modal" aria-label="Close"><i class="fas fa-times"></i></button>
                    <div class="header">
                        <h1><i class="fas fa-edit"></i> Update Product</h1>
                        
                         <p>Modify product information below</p>
                    </div>
                    <div class="success-message" id="updateSuccessMessage">
                        <i class="fas fa-check-circle"></i> Product update submitted!
                         Redirecting...
                    </div>
                    <div class="product-preview">
                        <img id="updatePreviewImage" src="https://via.placeholder.com/200x200?text=Product" alt="Product Preview"
                             onerror="this.src = 
                                    'https://via.placeholder.com/200x200?text=Invalid+URL'">
                        <div class="preview-text">Product Image Preview</div>
                    </div>
                    <form action="${BASE_URL}/updateProduct" method="post" id="updateForm">
                        <input type="hidden" name="id" id="update_id">
   
                         <input type="hidden" name="current_page" value="${currentPage}">
                        <input type="hidden" name="current_sort" value="${sortBy}">
                        <input type="hidden" name="current_search" value="${searchName}">
                      
                         <input type="hidden" name="current_category" value="${selectedCategory}">
                        <input type="hidden" name="current_status" value="${selectedStatus}">
                        <div class="form-row">
                            <div class="form-group">
              
                                 <label for="update_name"><i class="fas fa-tag"></i> Product Name</label>
                                <div class="input-icon">
                                    <i class="fas fa-tag"></i>
      
                                     <input type="text" id="update_name" name="name" required>
                                </div>
                            </div>
      
                             <div class="form-group">
                                <label for="update_price"><i class="fas fa-dollar-sign"></i> Price (₫)</label>
                                <div class="input-icon">
       
                                     <i class="fas fa-dollar-sign"></i>
                                    <input type="number" id="update_price" name="price" min="0" required>
                            
                                 </div>
                            </div>
                        </div>
                        <div class="form-row">
                   
                             <div class="form-group">
                                <label for="update_quantity"><i class="fas fa-boxes"></i> Quantity</label>
                                <div class="input-icon">
                     
                                     <i class="fas fa-boxes"></i>
                                    <input type="number" id="update_quantity" name="quantity" min="0" required>
                                </div>
          
                             </div>
                            <div class="form-group">
                                <label for="update_promo"><i class="fas fa-percentage"></i> Promotion</label>
                 
                                 <div class="input-icon">
                                    <i class="fas fa-percentage"></i>
                                    <select id="update_promo" name="promo" required>
       
                                         <option value="">-- Select Promo --</option>
                                        <c:forEach var="p" items="${promoList}">
                     
                                             <option value="${p.promoID}">
                                                <c:out value="${p.promoPercent}"/>% (<fmt:formatDate value="${p.startDate}" pattern="dd/MM"/>-<fmt:formatDate value="${p.endDate}" pattern="dd/MM"/>)
                      
                                             </option>
                                        </c:forEach>
                                      
                                         <option value="0">None</option>
                                    </select>
                                </div>
                            </div>
 
                         </div>
                        <div class="form-row">
                            <div class="form-group">
                       
                                 <label for="update_category"><i class="fas fa-layer-group"></i> Category</label>
                                <div class="input-icon">
                                    <i class="fas fa-layer-group"></i>
                
                                     <select id="update_category" name="category" required>
                                        <option value="">-- Select Category --</option>
                                 
                                         <c:forEach var="cate" items="${cateList}">
                                            <option value="${cate.category_id}">
                                              
                                                 <c:out value="${cate.type}"/> (<c:out value="${cate.gender}"/>)
                                            </option>
                                        </c:forEach>
           
                                     </select>
                                </div>
                            </div>
               
                             <div class="form-group">
                                <label for="update_pic"><i class="fas fa-image"></i> Image URL</label>
                                <div class="input-icon">
                
                                     <i class="fas fa-image"></i>
                                    <input type="text" name="pic" id="update_pic" required oninput="updateEditPreview()">
                                </div>
     
                             </div>
                        </div>
                        <div class="form-group">
                            
                             <label for="update_des"><i class="fas fa-align-left"></i> Description</label>
                            <div class="input-icon textarea-icon">
                                <i class="fas fa-align-left"></i>
                                
                                 <textarea id="update_des" name="des" rows="3" required style="width:100%;padding:15px;border:2px solid #e0e0e0;border-radius:10px;font-size:1em;background:#fafafa;padding-left: 45px; resize: vertical;"></textarea>
                            </div>
                        </div>
                        <button type="submit" class="submit-btn">
            
                             <i class="fas fa-save"></i> Update Product
                        </button>
                    </form>
                </div>
            </div>
        
         </div>

        <div class="modal fade" id="deleteConfirmationModal" tabindex="-1" aria-labelledby="deleteConfirmationModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-scrollable">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="deleteConfirmationModalLabel">Delete Product: <span>Product Name</span></h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        
                        <div id="deleteWarningMessage" class="alert alert-danger" style="display: none;">
                            <strong>Cannot Delete:</strong> This product has related data and cannot be deleted until all related entries are removed.
                        </div>
                        <div id="deleteSuccessMessage" class="alert alert-success" style="display: none;">
                            <strong>Safe to Delete:</strong> No related data was found. This product can be safely deleted.
                        </div>

                        <div id="relatedDataLoading" class="text-center p-5">
                            <div class="spinner-border text-primary" role="status">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                            <p class="mt-2">Checking for related data...</p>
                        </div>

                        <div id="relatedDataContent" style="display: none;">
                            <p>The following related data was found:</p>
                            <ul class="nav nav-tabs" id="relatedDataTab" role="tablist">
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link active" id="sizes-tab" data-bs-toggle="tab" data-bs-target="#sizes-content" type="button" role="tab">Sizes <span class="badge bg-secondary" id="sizes-count">0</span></button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link" id="carts-tab" data-bs-toggle="tab" data-bs-target="#carts-content" type="button" role="tab">Carts <span class="badge bg-secondary" id="carts-count">0</span></button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link" id="orders-tab" data-bs-toggle="tab" data-bs-target="#orders-content" type="button" role="tab">Orders <span class="badge bg-secondary" id="orders-count">0</span></button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link" id="imports-tab" data-bs-toggle="tab" data-bs-target="#imports-content" type="button" role="tab">Imports <span class="badge bg-secondary" id="imports-count">0</span></button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link" id="feedbacks-tab" data-bs-toggle="tab" data-bs-target="#feedbacks-content" type="button" role="tab">Feedback <span class="badge bg-secondary" id="feedbacks-count">0</span></button>
                                </li>
                            </ul>
                            
                            <div class="tab-content pt-3" id="relatedDataTabContent">
                                
                                <div class="tab-pane fade show active" id="sizes-content" role="tabpanel">
                                    <table class="table table-sm table-bordered">
                                        <thead><tr><th>Size Name</th><th>Quantity</th></tr></thead>
                                        <tbody id="sizes-table-body"></tbody>
                                    </table>
                                    <p id="sizes-none" class="text-muted" style="display: none;">No related data found in 'size_detail'.</p>
                                </div>
                                
                                <div class="tab-pane fade" id="carts-content" role="tabpanel">
                                    <table class="table table-sm table-bordered">
                                        <thead><tr><th>Cart ID</th><th>Customer ID</th><th>Size</th><th>Quantity</th><th>Price</th></tr></thead>
                                        <tbody id="carts-table-body"></tbody>
                                    </table>
                                    <p id="carts-none" class="text-muted" style="display: none;">No related data found in 'cart'.</p>
                                </div>

                                <div class="tab-pane fade" id="orders-content" role="tabpanel">
                                    <table class="table table-sm table-bordered">
                                        <thead><tr><th>Order ID</th><th>Size</th><th>Quantity</th></tr></thead>
                                        <tbody id="orders-table-body"></tbody>
                                    </table>
                                    <p id="orders-none" class="text-muted" style="display: none;">No related data found in 'order_detail'.</p>
                                </div>

                                <div class="tab-pane fade" id="imports-content" role="tabpanel">
                                    <table class="table table-sm table-bordered">
                                        <thead><tr><th>Import ID</th><th>Size</th><th>Quantity</th></tr></thead>
                                        <tbody id="imports-table-body"></tbody>
                                    </table>
                                    <p id="imports-none" class="text-muted" style="display: none;">No related data found in 'importDetails'.</p>
                                </div>

                                <div class="tab-pane fade" id="feedbacks-content" role="tabpanel">
                                    <table class="table table-sm table-bordered">
                                        <thead><tr><th>Feedback ID</th><th>Customer ID</th><th>Rating</th><th>Content</th></tr></thead>
                                        <tbody id="feedbacks-table-body"></tbody>
                                    </table>
                                    <p id="feedbacks-none" class="text-muted" style="display: none;">No related data found in 'feedback'.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <a id="confirmDeleteButton" href="#" class="btn btn-danger" style="display: none;">
                            <i class="fas fa-trash"></i> Confirm Delete
                        </a>
                    </div>
                </div>
            </div>
        </div>
        <div class="modal fade" id="toggleStatusModal" tabindex="-1" aria-labelledby="toggleStatusModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="toggleStatusModalLabel">Confirm Action</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body" id="toggleStatusModalBody">
                        Are you sure you want to perform this action?
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <%-- Nút này sẽ được cập nhật bằng JavaScript --%>
                        <a id="confirmToggleButton" href="#" class="btn btn-primary">
                            Confirm
                        </a>
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
                                         
            // Logic preview ảnh
            function updateAddPreview() {
                const urlInput = document.getElementById('add_pic');
                const img = document.getElementById('addPreviewImage');
                const url = urlInput.value.trim();
                if (url) {
                    img.src = url;
                } else {
                    img.src = "https://via.placeholder.com/200x200?text=Enter+URL";
                }
            }
            document.getElementById('addPreviewImage').onerror = function () {
                this.src = 'https://via.placeholder.com/200x200?text=Invalid+URL';
                $('#add_pic').addClass('error').removeClass('valid');
            };
            function updateEditPreview() {
                const urlInput = document.getElementById('update_pic');
                const img = document.getElementById('updatePreviewImage');
                const url = urlInput.value.trim();
                if (url) {
                    img.src = url;
                } else {
                    img.src = "https://via.placeholder.com/200x200?text=Enter+URL";
                }
            }
            document.getElementById('updatePreviewImage').onerror = function () {
                this.src = 'https://via.placeholder.com/200x200?text=Invalid+URL';
                $('#update_pic').addClass('error').removeClass('valid');
            };

            // Logic validation
            $.validator.addMethod("validProductName", function(value, element) {
                var trimmedValue = $.trim(value);
                return this.optional(element) || /^[a-zA-Z0-9 ,-]{3,100}$/.test(trimmedValue);
            }, "Name 3-100 chars (letters, numbers, comma, dash, space only).");
            
            // ===== BẮT ĐẦU DOMContentLoaded (SỬA LỖI TẠI ĐÂY) =====
            document.addEventListener("DOMContentLoaded", function () {
                
                // Logic cho Toast
                const toast = document.getElementById('toast-message');
                if (toast) {
                    setTimeout(() => { toast.classList.add('active'); }, 300);
                    setTimeout(() => { toast.classList.remove('active'); }, 4000);
                }

                // === JAVASCRIPT ĐIỀU HƯỚNG ===
                const navLinks = document.querySelectorAll('.nav-link');
                const currentTarget = 'product-manage'; // Tab này là 'product-manage'

                navLinks.forEach(link => {
                    const targetId = link.getAttribute('data-target');
                    if (targetId === currentTarget) {
                        link.classList.add('active'); // Đánh dấu tab hiện tại
                    }

                    link.addEventListener('click', function (e) {
                        e.preventDefault();
                        const targetLink = this.querySelector('a');
                        if (targetLink && targetLink.href) {
                            window.location.href = targetLink.href; // Chuyển hướng đến URL trong thẻ <a>
                        }
                    });
                });
                // === KẾT THÚC JAVASCRIPT ĐIỀU HƯỚNG ===


                // === Logic cho Modal Add Product ===
                var addProductModal = document.getElementById('addProductModal');
                if (addProductModal) {
                    addProductModal.addEventListener('show.bs.modal', function (event) {
                        var validator = $("#addForm").validate();
                        validator.resetForm();
                        $('#addForm')[0].reset();
                        updateAddPreview();
                        $('#addSuccessMessage').hide();
                        $('#addForm .submit-btn').prop('disabled', false).html('<i class="fas fa-save"></i> Add Product');
                    });
                }

                $("#addForm").validate({
                    rules: {
                        name: { required: true, validProductName: true },
                        price: { required: true, number: true, min: 1, max: 9999999999 },
                        quantity: { required: true, digits: true, min: 0, max: 9999 },
                        promo: { required: true },
                        category: { required: true },
                        // === SỬA ĐỔI VALIDATION (BỎ MINLENGTH) ===
                        des: { required: true, maxlength: 500 },
                        pic: { required: true, maxlength: 255 }
                    },
                    messages: {
                        name: { required: "Please enter product name" },
                        price: { required: "Please enter price", number: "Price must be a number", min: "Price must be greater than 0", max: "Price is too large (max 10 digits)" },
                        quantity: { required: "Please enter quantity", digits: "Quantity must be an integer", min: "Quantity cannot be negative", max: "Max quantity is 9999" },
                        promo: "Please select a promotion",
                        category: "Please select a category",
                        // === SỬA ĐỔI VALIDATION (BỎ MINLENGTH) ===
                        des: { required: "Please enter description", maxlength: "Description cannot exceed 500 characters" },
                        pic: { required: "Please enter image URL", maxlength: "URL cannot exceed 255 characters" }
                    },
                    errorElement: "label",
                    errorClass: "error",
                    errorPlacement: function (error, element) {
                        error.insertAfter(element.closest('.input-icon'));
                    },
                    submitHandler: function (form) {
                        $('#addSuccessMessage').slideDown();
                        $('#addForm .submit-btn').prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Adding...');
                        setTimeout(function () {
                            form.submit();
                        }, 1500);
                        return false;
                    }
                });

                // === Logic cho Modal Update Product (Sửa lỗi hiển thị thông tin) ===
                var updateProductModal = document.getElementById('updateProductModal');
                if (updateProductModal) {
                    updateProductModal.addEventListener('show.bs.modal', function (event) {
                        var validator = $("#updateForm").validate();
                        validator.resetForm();
                        
                        $('#updateSuccessMessage').hide();
                        $('#updateForm .submit-btn').prop('disabled', false).html('<i class="fas fa-save"></i> Update Product');
                        
                        var button = event.relatedTarget;
                        var id = button.getAttribute('data-id');
                        var name = button.getAttribute('data-name');
                        var price = button.getAttribute('data-price');
                        var quantity = button.getAttribute('data-quantity');
                        var picurl = button.getAttribute('data-picurl');
                        var description = button.getAttribute('data-description');
                        var categoryid = button.getAttribute('data-categoryid');
                        var promoid = button.getAttribute('data-promoid');
                        
                        // ĐÂY LÀ PHẦN QUAN TRỌNG ĐỂ SỬA LỖI CỦA BẠN
                        $('#update_id').val(id);
                        $('#update_name').val(name);
                        $('#update_price').val(price);
                        $('#update_quantity').val(quantity);
                        $('#update_pic').val(picurl);
                        $('#update_des').val(description);
                        $('#update_category').val(categoryid);
                        $('#update_promo').val(promoid);
                        updateEditPreview();
                    });
                }

                $("#updateForm").validate({
                    rules: {
                        name: { required: true, validProductName: true },
                        price: { required: true, number: true, min: 1, max: 9999999999 },
                        quantity: { required: true, digits: true, min: 0, max: 9999 },
                        promo: { required: true },
                        category: { required: true },
                        // === SỬA ĐỔI VALIDATION (BỎ MINLENGTH) ===
                        des: { required: true, maxlength: 500 },
                        pic: { required: true, maxlength: 255 }
                    },
                    messages: {
                        name: { required: "Please enter product name" },
                        price: { required: "Please enter price", number: "Price must be a number", min: "Price must be greater than 0", max: "Price is too large (max 10 digits)" },
                        quantity: { required: "Please enter quantity", digits: "Quantity must be an integer", min: "Quantity cannot be negative", max: "Max quantity is 9999" },
                        promo: "Please select a promotion",
                        category: "Please select a category",
                        // === SỬA ĐỔI VALIDATION (BỎ MINLENGTH) ===
                        des: { required: "Please enter description", maxlength: "Description cannot exceed 500 characters" },
                        pic: { required: "Please enter image URL", maxlength: "URL cannot exceed 255 characters" }
                    },
                    errorElement: "label",
                    errorClass: "error",
                    errorPlacement: function (error, element) {
                        error.insertAfter(element.closest('.input-icon'));
                    },
                    submitHandler: function (form) {
                        $('#updateSuccessMessage').slideDown();
                        $('#updateForm .submit-btn').prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Updating...');
                        setTimeout(function () {
                            form.submit();
                        }, 1500);
                        return false;
                    }
                });
                
                // === LOGIC CHO MODAL TOGGLE STATUS (MỚI) ===
                var toggleStatusModal = document.getElementById('toggleStatusModal');
                if (toggleStatusModal) {
                    toggleStatusModal.addEventListener('show.bs.modal', function (event) {
                        var button = event.relatedTarget;
                        
                        // Lấy dữ liệu từ nút
                        var actionUrl = button.getAttribute('data-action-url');
                        var productName = button.getAttribute('data-product-name');
                        var actionType = button.getAttribute('data-action-type'); // "Deactivate" hoặc "Reactivate"

                        // Lấy các thành phần của modal
                        var modalTitle = toggleStatusModal.querySelector('.modal-title');
                        var modalBody = toggleStatusModal.querySelector('.modal-body');
                        var confirmButton = toggleStatusModal.querySelector('#confirmToggleButton');

                        // Cập nhật nội dung modal
                        modalTitle.textContent = actionType + ' Product';
                        modalBody.textContent = 'Are you sure you want to ' + actionType.toLowerCase() + 
                                                ' the product "' + productName + '"?';
                        
                        // Cập nhật nút Confirm
                        confirmButton.href = actionUrl;
                        confirmButton.textContent = actionType;

                        // Cập nhật màu sắc nút
                        if (actionType === 'Deactivate') {
                            confirmButton.className = 'btn btn-warning'; // Màu vàng cho Deactivate
                        } else {
                            confirmButton.className = 'btn btn-success'; // Màu xanh cho Reactivate
                        }
                    });
                }
                // === KẾT THÚC LOGIC MODAL TOGGLE STATUS ===

                
                // === LOGIC CHO MODAL XÁC NHẬN XÓA (MỚI) ===
                var deleteConfirmationModal = document.getElementById('deleteConfirmationModal');
                if (deleteConfirmationModal) {
                    deleteConfirmationModal.addEventListener('show.bs.modal', function (event) {
                        var button = event.relatedTarget;
                        var productId = button.getAttribute('data-product-id');
                        var productName = button.getAttribute('data-product-name');

                        // Cập nhật tiêu đề modal
                        var modalTitle = deleteConfirmationModal.querySelector('#deleteConfirmationModalLabel span');
                        modalTitle.textContent = productName + " (ID: " + productId + ")";

                        // Reset trạng thái modal
                        $('#relatedDataLoading').show();
                        $('#relatedDataContent').hide();
                        $('#deleteWarningMessage').hide();
                        $('#deleteSuccessMessage').hide();
                        $('#confirmDeleteButton').hide().removeClass('disabled').html('<i class="fas fa-trash"></i> Confirm Delete');
                        
                        // Xóa dữ liệu cũ trong các bảng
                        $('#sizes-table-body, #carts-table-body, #orders-table-body, #imports-table-body, #feedbacks-table-body').empty();
                        
                        // Ẩn các thông báo "No data"
                        $('#sizes-none, #carts-none, #orders-none, #imports-none, #feedbacks-none').hide();
                        
                        // Kích hoạt lại tab đầu tiên
                        $('#relatedDataTab button[data-bs-target="#sizes-content"]').tab('show');


                        // Gọi AJAX đến servlet mới
                        $.ajax({
                            url: '${BASE_URL}/admin/productRelatedData',
                            type: 'GET',
                            data: { productId: productId },
                            dataType: 'json',
                            success: function(data) {
                                var hasRelatedData = false;

                                // 1. Sizes
                                if (data.sizes && data.sizes.length > 0) {
                                    hasRelatedData = true;
                                    $('#sizes-count').text(data.sizes.length).removeClass('bg-secondary').addClass('bg-danger');
                                    $.each(data.sizes, function(i, item) {
                                        $('#sizes-table-body').append('<tr><td>' + item.size_name + '</td><td>' + item.quantity + '</td></tr>');
                                    });
                                } else {
                                    $('#sizes-count').text(0).removeClass('bg-danger').addClass('bg-secondary');
                                    $('#sizes-none').show();
                                }

                                // 2. Carts
                                if (data.carts && data.carts.length > 0) {
                                    hasRelatedData = true;
                                    $('#carts-count').text(data.carts.length).removeClass('bg-secondary').addClass('bg-danger');
                                    $.each(data.carts, function(i, item) {
                                        $('#carts-table-body').append('<tr><td>' + item.cart_id + '</td><td>' + item.customer_id + '</td><td>' + item.size_name + '</td><td>' + item.quantity + '</td><td>' + item.price + '</td></tr>');
                                    });
                                } else {
                                    $('#carts-count').text(0).removeClass('bg-danger').addClass('bg-secondary');
                                    $('#carts-none').show();
                                }

                                // 3. Orders
                                if (data.orders && data.orders.length > 0) {
                                    hasRelatedData = true;
                                    $('#orders-count').text(data.orders.length).removeClass('bg-secondary').addClass('bg-danger');
                                    $.each(data.orders, function(i, item) {
                                        $('#orders-table-body').append('<tr><td>' + item.orderID + '</td><td>' + item.size_name + '</td><td>' + item.quantity + '</td></tr>');
                                    });
                                } else {
                                    $('#orders-count').text(0).removeClass('bg-danger').addClass('bg-secondary');
                                    $('#orders-none').show();
                                }

                                // 4. Imports
                                if (data.imports && data.imports.length > 0) {
                                    hasRelatedData = true;
                                    $('#imports-count').text(data.imports.length).removeClass('bg-secondary').addClass('bg-danger');
                                    $.each(data.imports, function(i, item) {
                                        $('#imports-table-body').append('<tr><td>' + item.importID + '</td><td>' + (item.sizeName || 'N/A') + '</td><td>' + item.quantity + '</td></tr>');
                                    });
                                } else {
                                    $('#imports-count').text(0).removeClass('bg-danger').addClass('bg-secondary');
                                    $('#imports-none').show();
                                }

                                // 5. Feedbacks
                                if (data.feedbacks && data.feedbacks.length > 0) {
                                    hasRelatedData = true;
                                    $('#feedbacks-count').text(data.feedbacks.length).removeClass('bg-secondary').addClass('bg-danger');
                                    $.each(data.feedbacks, function(i, item) {
                                        $('#feedbacks-table-body').append('<tr><td>' + item.feedback_id + '</td><td>' + item.customer_id + '</td><td>' + item.rate_point + '</td><td>' + (item.content || '') + '</td></tr>');
                                    });
                                } else {
                                    $('#feedbacks-count').text(0).removeClass('bg-danger').addClass('bg-secondary');
                                    $('#feedbacks-none').show();
                                }

                                // Ẩn loading
                                $('#relatedDataLoading').hide();
                                
                                // QUAN TRỌNG: Hiển thị/Ẩn nút xóa
                                if (hasRelatedData) {
                                    $('#deleteWarningMessage').show();
                                    $('#relatedDataContent').show(); // Vẫn hiển thị dữ liệu
                                    $('#confirmDeleteButton').hide();
                                } else {
                                    $('#deleteSuccessMessage').show();
                                    $('#relatedDataContent').hide(); // Ẩn các tab đi vì không có dữ liệu
                                    
                                    // Tạo link xóa an toàn
                                    var deleteUrl = '${BASE_URL}/deleteProduct?id=' + productId +
                                                    '&page=${currentPage}&sort=${sortBy}&search=${encodedSearch}' +
                                                    '&category=${selectedCategory}&status=${selectedStatus}&tab=product';
                                    
                                    $('#confirmDeleteButton').attr('href', deleteUrl).show();
                                }

                            },
                            error: function(jqXHR, textStatus, errorThrown) {
                                // Xử lý lỗi
                                $('#relatedDataLoading').html('<div class="alert alert-danger"><strong>Error:</strong> ' + (jqXTTP.responseJSON || errorThrown) + '</div>');
                            }
                        });
                        
                        // Thêm trình xử lý sự kiện cho nút xóa
                        // Cần xóa listener cũ để tránh bị lặp
                        $('#confirmDeleteButton').off('click').on('click', function() {
                            // Hiển thị trạng thái đang xóa
                            $(this).html('<i class="fas fa-spinner fa-spin"></i> Deleting...').addClass('disabled');
                            // Trình duyệt sẽ tự động điều hướng theo href
                        });
                        
                    });
                }
                // === KẾT THÚC LOGIC MODAL XÁC NHẬN XÓA ===
                
            }); // ===== KẾT THÚC DOMContentLoaded =====
        </script>

    </body>

</html>