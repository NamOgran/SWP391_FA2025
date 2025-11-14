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

            /* CSS cho Modal Validation */
            .modal-body label.error {
                color: #e74c3c;
                font-size: 0.9em;
                margin-top: 5px;
                display: block;
                font-weight: 500;
            }
            .modal-body input.error {
                border-color: #e74c3c !important;
                background: #fffafa !important;
            }
        </style>
    </head>

    <body>

        <c:if test="${param.msg == 'promo_added'}">
            <div id="toast-message" class="toast-notification toast-success active">
                <i class="fas fa-check-circle"></i> Promo added successfully!
            </div>
        </c:if>
        <c:if test="${param.msg == 'promo_updated'}">
            <div id="toast-message" class="toast-notification toast-info active">
                <i class="fas fa-info-circle"></i> Promo updated successfully!
            </div>
        </c:if>
        <c:if test="${param.msg == 'promo_deleted'}">
            <div id="toast-message" class="toast-notification toast-danger active">
                <i class="fas fa-trash-alt"></i> Promo deleted successfully!
            </div>
        </c:if>
        <c:if test="${param.msg == 'promo_invalid_percent'}">
            <div id="toast-message" class="toast-notification toast-danger active">
                <i class="fas fa-exclamation-triangle"></i> Error: Percent must be between 1 and 100.
            </div>
        </c:if>
        <c:if test="${param.msg == 'promo_invalid_date'}">
        
             <div id="toast-message" class="toast-notification toast-danger active">
                <i class="fas fa-exclamation-triangle"></i> Error: End date cannot be before start date.
            </div>
        </c:if>
        <c:if test="${param.msg == 'promo_invalid_date_format'}">
            <div id="toast-message" class="toast-notification toast-danger active">
                <i class="fas fa-exclamation-triangle"></i> Error: Invalid date format.
            </div>
        </c:if>
        
        <%-- === BẮT ĐẦU SỬA ĐỔI: Thêm Toast cho lỗi mới === --%>
        <c:if test="${param.msg == 'promo_in_use'}">
            <div id="toast-message" class="toast-notification toast-danger active">
                <i class="fas fa-exclamation-triangle"></i> Error: Promo is in use by products and cannot be deleted.
            </div>
        </c:if>
        <%-- === KẾT THÚC SỬA ĐỔI === --%>
        
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
                    <li class="nav-link" data-target="account-manage">
                        <a href="${BASE_URL}/admin?tab=account" ><i class="bi bi-person-badge-fill"></i> <span>Account management</span> </a>
             
                     </li>
                    <li class="nav-link active" data-target="promo-manage"> <a href="${BASE_URL}/admin?tab=promo" ><i class="bi bi-tags-fill"></i> <span>Promo Management</span> </a>
                    </li>
                    <li class="nav-link" data-target="personal-info">
                    
                         <a href="${BASE_URL}/admin?tab=personal" ><i class="bi bi-person-fill"></i> <span>Personal information</span> </a>
                    </li>
                </ul>
            </nav>

            <div class="main-content">

                <div class="promo-manage" style="display: block;">
         
                     <h3 style="font-weight: bold;"><i class="bi bi-tags-fill"></i> Promo Management</h3>
                    <hr>
                    <div style="margin-top: 20px;
                         display: flex; justify-content: space-between; align-items: center;">

                        <form action="${BASE_URL}/admin" method="get" style="display: flex;
                              gap:10px;">
                            <input type="hidden" name="tab" value="promo">

                            <div class="input-group" style="width: 250px;">
                                <input type="text" name="promo_search" placeholder="Search promo percent" 
                                     class="form-control" value="<c:out value='${promoSearch}'/>">
                                <button type="submit" class="btn btn-secondary"><i class="bi bi-search"></i></button>
                            </div>
                        </form>
         
                         <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addPromoModal">
                            <i class="bi bi-plus-circle"></i> Add New Promo
                        </button>
                    </div>

    
                     <div style="margin-top: 25px;" class="table-responsive">
                        <table class="table table-bordered table-striped">
                            <thead class="table-dark"> <tr>
                        
                                 <th>ID</th>
                                    <th>Percent (%)</th>
                                    <th>Start Date</th>
              
                                     <th>End Date</th>
                                    <th>Actions</th>
                                </tr>
         
                             </thead>

                            <tbody>
                                <c:forEach var="p" items="${promoList}">
                   
                                     <tr>
                                        <td>${p.promoID}</td>
                                        <td>${p.promoPercent}%</td>
   
                                         <td><fmt:formatDate value="${p.startDate}" pattern="yyyy-MM-dd"/></td>
                                        <td><fmt:formatDate value="${p.endDate}" pattern="yyyy-MM-dd"/></td>
                   
                                         <td>
                                            <button type="button" class="btn btn-sm btn-warning"
                               
                                                     data-bs-toggle="modal" data-bs-target="#editPromoModal"
                                                    data-id="${p.promoID}"
                          
                                                     data-percent="${p.promoPercent}"
                                                    data-start="<fmt:formatDate value='${p.startDate}' pattern='yyyy-MM-dd'/>"
                    
                                                     data-end="<fmt:formatDate value='${p.endDate}' pattern='yyyy-MM-dd'/>">
                                                <i class="bi bi-pencil-square"></i>
                
                                             </button>
                                            
                                            <%-- === BẮT ĐẦU SỬA ĐỔI: Thay thế form bằng button === --%>
                                            <button type="button" class="btn btn-sm btn-danger"
                                                    data-bs-toggle="modal"
                                                    data-bs-target="#deletePromoModal"
                                                    data-promo-id="${p.promoID}"
                                                    data-promo-percent="${p.promoPercent}"
                                                    title="Delete Promo">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                            <%-- === KẾT THÚC SỬA ĐỔI === --%>
                                            
                                         </td>
                                    </tr>
                                </c:forEach> 

           
                                 <c:if test="${empty promoList}">
                                    <tr>
                                        <td 
                                             colspan="5" class="text-center text-muted">No promos found matching your criteria.</td>
                                    </tr>
                                </c:if>
                         
                             </tbody>
                        </table>
                    </div>

                    <c:if test="${promoTotalPages > 1}">
                        <nav aria-label="Promo pagination" class="mt-4">
   
                             <ul class="pagination justify-content-center">
                                <li class="page-item ${promoCurrentPage == 1 ?
                                                        'disabled' : ''}">
                                    <a class="page-link" href="${BASE_URL}/admin?promo_page=${promoCurrentPage - 1}&promo_search=${promoSearch}&tab=promo">Previous</a>
                                </li>
                          
                                 <c:forEach begin="1" end="${promoTotalPages}" var="i">
                                    <li class="page-item ${i == promoCurrentPage ?
                                                         'active' : ''}">
                                        <a class="page-link" href="${BASE_URL}/admin?promo_page=${i}&promo_search=${promoSearch}&tab=promo">${i}</a>
                                    </li>
                    
                                 </c:forEach>

                                <li class="page-item ${promoCurrentPage == promoTotalPages ?
                                                        'disabled' : ''}">
                                    <a class="page-link" href="${BASE_URL}/admin?promo_page=${promoCurrentPage + 1}&promo_search=${promoSearch}&tab=promo">Next</a>
                                </li>
                          
                             </ul>
                        </nav>
                    </c:if>
                </div>
            </div>
        </div>


        <div class="modal fade" id="addPromoModal" tabindex="-1" aria-labelledby="addPromoModalLabel" aria-hidden="true">
    
             <div class="modal-dialog">
                <div class="modal-content">
                    <form action="${BASE_URL}/admin" method="post" id="addPromoForm">
                        <div class="modal-header">
                          
                             <h5 class="modal-title" id="addPromoModalLabel">Add New Promo</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
             
                             <input type="hidden" name="action" value="add">
                            <input type="hidden" name="promo_page" value="${promoCurrentPage}">
                            <input type="hidden" name="promo_search" value="${promoSearch}">

                    
                             <div class="mb-3">
                                <label for="addPercent" class="form-label">Percent (%)</label>
                                <input type="number" name="percent" id="addPercent" class="form-control" placeholder="Percent (1-100)" required>
                 
                             </div>
                            <div class="mb-3">
                                <label for="addStartDate" class="form-label">Start Date</label>
                         
                                 <input type="date" name="startDate" id="addStartDate" class="form-control" required>
                            </div>
                            <div class="mb-3">
                               
                                 <label for="addEndDate" class="form-label">End Date</label>
                                <input type="date" name="endDate" id="addEndDate" class="form-control" required>
                            </div>
                        </div>
       
                         <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            <button type="submit" class="btn btn-success">Add Promo</button>
                  
                         </div>
                    </form>
                </div>
            </div>
        </div>

        <div class="modal fade" id="editPromoModal" tabindex="-1" aria-labelledby="editPromoModalLabel" aria-hidden="true">
            <div class="modal-dialog">
           
                 <div class="modal-content">
                    <form action="${BASE_URL}/admin" method="post" id="editPromoForm">
                        <div class="modal-header">
                            <h5 class="modal-title" id="editPromoModalLabel">Edit Promo</h5>
               
                             <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <input type="hidden" name="action" value="edit">
   
                             <input type="hidden" name="id" id="editPromoID">
                            <input type="hidden" name="promo_page" value="${promoCurrentPage}">
                            <input type="hidden" name="promo_search" value="${promoSearch}">

          
                             <div class="mb-3">
                                <label for="editPercent" class="form-label">Percent (%)</label>
                                <input type="number" name="percent" id="editPercent" class="form-control" required>
         
                             </div>
                            <div class="mb-3">
                                <label for="editStartDate" class="form-label">Start Date</label>
                 
                                 <input type="date" name="startDate" id="editStartDate" class="form-control" required>
                            </div>
                            <div class="mb-3">
                       
                                 <label for="editEndDate" class="form-label">End Date</label>
                                <input type="date" name="endDate" id="editEndDate" class="form-control" required>
                            </div>
                       
                         </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                            <button type="submit" class="btn btn-primary">Save Changes</button>
          
                         </div>
                    </form>
                </div>
            </div>
        </div>
        
        <div class="modal fade" id="deletePromoModal" tabindex="-1" aria-labelledby="deletePromoModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-scrollable">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="deletePromoModalLabel">Delete Promo: <span></span></h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        
                        <div id="deletePromoWarning" class="alert alert-danger" style="display: none;">
                            <strong>Cannot Delete:</strong> This promo is linked to the following products and cannot be deleted.
                        </div>
                        <div id="deletePromoSuccess" class="alert alert-success" style="display: none;">
                            <strong>Safe to Delete:</strong> No related products found. This promo can be safely deleted.
                        </div>

                        <div id="promoDataLoading" class="text-center p-5">
                            <div class="spinner-border text-primary" role="status">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                            <p class="mt-2">Checking for related products...</p>
                        </div>

                        <div id="promoDataContent" style="display: none;">
                            <table class="table table-sm table-bordered">
                                <thead><tr><th>ID</th><th>Product Name</th><th>Status</th></tr></thead>
                                <tbody id="promo-products-table-body"></tbody>
                            </table>
                            <p id="promo-products-none" class="text-muted" style="display: none;">No related products found.</p>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                        <form id="confirmDeletePromoForm" action="${BASE_URL}/admin" method="post" style="display: none;">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" id="confirmDeletePromoId">
                            <input type="hidden" name="promo_page" value="${promoCurrentPage}">
                            <input type="hidden" name="promo_search" value="${promoSearch}">
                            <button type="submit" class="btn btn-danger">
                                <i class="fas fa-trash"></i> Confirm Delete
                            </button>
                        </form>
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
                                                     // Validation rule for Promo End Date
            
                                                           $.validator.addMethod("greaterThanEqual", function (value, element, param) {
                                                      
                                                            var startDate = $(param).val();
                                                         if (!startDate || !value) {
                                                             return true;
                                                             // Don't validate if either field is empty
                                                         }
                                    
                                                          return new Date(value) >= new Date(startDate);
                                                         }, "End date must be on or after start date.");
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

                                                         // === SỬA ĐỔI JAVASCRIPT ĐIỀU HƯỚNG ===
                 
                                                         const navLinks = document.querySelectorAll('.nav-link');
                                                         const currentTarget = 'promo-manage'; // Tab này là 'promo-manage'

                                                         navLinks.forEach(link => {
                                 
                                                             const targetId = link.getAttribute('data-target');
                                                             if (targetId === currentTarget) {
    
                                                                  link.classList.add('active'); // Đánh dấu tab hiện tại
                                 
                                                             }

                                                             link.addEventListener('click', function (e) {
        
                                                                  e.preventDefault();
                                           
                                                                   const targetLink = this.querySelector('a');
                                                                 if (targetLink && targetLink.href) {
      
                                                                       window.location.href = targetLink.href;
                                                                       // Chuyển hướng đến URL trong thẻ <a>
                                                                 }
                            
                                                                 });
                                                         });
                                                         // === KẾT THÚC SỬA ĐỔI ===


                                                         // === VALIDATION CHO ADD PROMO ===
                              
                                                           $("#addPromoForm").validate({
                                                             rules: {
           
                                                                       percent: {
                                             
                                                                     required: true,
                                                                     digits: true,
     
                                                                         min: 1,
                                   
                                                                         max: 100
                                                                 
                                                                 },
                                                                 startDate: {
                                  
                                                                     required: true,
                                                                
                                                                         date: true
                                                                 },
                             
                                                                     endDate: {
                                                               
                                                                         required: true,
                                                                     date: true,
                       
                                                                         greaterThanEqual: "#addStartDate"
                                                     
                                                                 }
                                                             },
                           
                                                                   messages: {
                                                                 
                                                                     percent: {
                                                                     required: "Please enter a percent",
                          
                                                                         digits: "Must be a whole number",
                                                    
                                                                         min: "Percent must be at least 1",
                                                                     max: "Percent cannot exceed 100"
    
                                                                 },
                                       
                                                                   startDate: "Please select a start date",
                                                                 endDate: {
   
                                                                         required: "Please select an end date",
                             
                                                                         greaterThanEqual: "End date must be on or after start date"
                                                   
                                                                 }
                                                             },
                         
                                                                     errorElement: "label",
                                                             errorClass: "error"
 
                                                                         });
                                                         // === VALIDATION CHO EDIT PROMO ===
                                                         $("#editPromoForm").validate({
                                     
                                                                 rules: {
                                                                 percent: {
         
                                                                         required: true,
                                       
                                                                         digits: true,
                                                                     
                                                                         min: 1,
                                                                     max: 100
                             
                                                                     },
                                                                
                                                                   startDate: {
                                                                     required: true,
                            
                                                                         date: true
                                                          
                                                                     },
                                                                 endDate: {
                           
                                                                         required: true,
                                                         
                                                                         date: true,
                                                                     greaterThanEqual: "#editStartDate"
                 
                                                                     }
                                                    
                                                         },
                                                             messages: {
                             
                                                                     percent: {
                                                               
                                                                         required: "Please enter a percent",
                                                                     digits: "Must be a whole number",
                
                                                                         min: "Percent must be at least 1",
                                         
                                                                         max: "Percent cannot exceed 100"
                                                                 },
   
                                                                   startDate: "Please select a start date",
                                 
                                                                   endDate: {
                                                                   
                                                                         required: "Please select an end date",
                                                                     greaterThanEqual: "End date must be on or after start date"
               
                                                                     }
                                                  
                                                         },
                                                             errorElement: "label",
                           
                                                                   errorClass: "error"
                                                         });
                                                         // === LOGIC POPULATE MODAL EDIT PROMO ===
                                                         var editPromoModal = document.getElementById('editPromoModal');
                                                         if (editPromoModal) {
                                                             editPromoModal.addEventListener('show.bs.modal', function (event) {
                                  
                                                                 // Clear previous validation
                                                                 $("#editPromoForm").validate().resetForm();
 
                                                                 $("#editPromoForm .form-control").removeClass("error");

                                   
                                                                   var button = event.relatedTarget;
                                                                 var promoID 
                                                                     = button.getAttribute('data-id');
                                                                 var percent = button.getAttribute('data-percent');
                               
                                                                     var startDate = button.getAttribute('data-start');
                                                               
                                                                     var endDate = button.getAttribute('data-end');
                                                                 var modalPromoIDInput = editPromoModal.querySelector('#editPromoID');
                                                                 var modalPercentInput = editPromoModal.querySelector('#editPercent');
                                                                 var modalStartDateInput = editPromoModal.querySelector('#editStartDate');
                                                                 var modalEndDateInput = editPromoModal.querySelector('#editEndDate');
                                                                 modalPromoIDInput.value = promoID;
                                                                 modalPercentInput.value = percent;
                                                                 modalStartDateInput.value = startDate;
                                                                 modalEndDateInput.value = endDate;
                                                             });
                                                         }
                                                         
                                                        // === LOGIC CHO MODAL XÁC NHẬN XÓA PROMO (MỚI) ===
                                                        var deletePromoModal = document.getElementById('deletePromoModal');
                                                        if (deletePromoModal) {
                                                            deletePromoModal.addEventListener('show.bs.modal', function (event) {
                                                                var button = event.relatedTarget;
                                                                var promoId = button.getAttribute('data-promo-id');
                                                                var promoPercent = button.getAttribute('data-promo-percent');

                                                                // Cập nhật tiêu đề
                                                                var modalTitle = deletePromoModal.querySelector('#deletePromoModalLabel span');
                                                                modalTitle.textContent = promoPercent + "% (ID: " + promoId + ")";

                                                                // Cập nhật ID trong form ẩn
                                                                $('#confirmDeletePromoId').val(promoId);

                                                                // Reset trạng thái modal
                                                                $('#promoDataLoading').show();
                                                                $('#promoDataContent').hide();
                                                                $('#deletePromoWarning').hide();
                                                                $('#deletePromoSuccess').hide();
                                                                $('#confirmDeletePromoForm').hide();
                                                                $('#promo-products-table-body').empty();
                                                                $('#promo-products-none').hide();

                                                                // Gọi AJAX đến servlet mới
                                                                $.ajax({
                                                                    url: '${BASE_URL}/admin/promoRelatedData', // Servlet bạn tạo
                                                                    type: 'GET',
                                                                    data: { promoId: promoId },
                                                                    dataType: 'json',
                                                                    success: function(products) {
                                                                        var hasRelatedData = (products && products.length > 0);

                                                                        $('#promoDataLoading').hide();
                                                                        
                                                                        if (hasRelatedData) {
                                                                            // Hiển thị cảnh báo và danh sách sản phẩm
                                                                            $('#deletePromoWarning').show();
                                                                            $('#promoDataContent').show();
                                                                            $('#confirmDeletePromoForm').hide();
                                                                            
                                                                            $.each(products, function(i, product) {
                                                                                var status = product.is_active ? '<span class="badge bg-success">Active</span>' : '<span class="badge bg-secondary">Inactive</span>';
                                                                                $('#promo-products-table-body').append('<tr><td>' + product.id + '</td><td>' + product.name + '</td><td>' + status + '</td></tr>');
                                                                            });

                                                                        } else {
                                                                            // Hiển thị thông báo an toàn và nút xóa
                                                                            $('#deletePromoSuccess').show();
                                                                            $('#promoDataContent').hide(); // Không cần hiển thị bảng rỗng
                                                                            //$('#promo-products-none').show(); // Bạn có thể bỏ dòng này nếu không muốn thấy "No related data" khi đã an toàn
                                                                            $('#confirmDeletePromoForm').show();
                                                                        }
                                                                    },
                                                                    error: function(jqXHR, textStatus, errorThrown) {
                                                                        $('#promoDataLoading').html('<div class="alert alert-danger"><strong>Error:</strong> ' + (jqXHR.responseJSON || errorThrown) + '</div>');
                                                                    }
                                                                });
                                                            });
                                                        }
                                                        // === KẾT THÚC LOGIC MODAL XÓA PROMO ===
                                                         
                                                     });
        </script>

    </body>

</html>