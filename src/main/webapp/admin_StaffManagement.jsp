<%-- 
    Document    : admin_StaffManagement.jsp
    Description: Staff Management (Validated with Strict Rules & Ajax)
    Updated     : Validation Rules per Requirements
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="entity.Staff" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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

<!DOCTYPE html>
<html lang="en">

    <head> 
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin | Staff Management</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <script src="https://kit.fontawesome.com/1bd876819f.js" crossorigin="anonymous"></script>

        <link href='https://fonts.googleapis.com/css?family=Quicksand:400,500,600,700&display=swap' rel='stylesheet'> 
        <link rel="icon" href="${pageContext.request.contextPath}/images/LG2.png" type="image/x-icon"> 

        <style>
            :root {
                --primary-color: #4e73df;
                --secondary-color: #858796;
                --success-color: #1cc88a;
                --info-color: #36b9cc;
                --warning-color: #f6c23e;
                --danger-color: #e74a3b;
                --light-bg: #f8f9fc;
                --card-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
            }

            body {
                font-family: 'Quicksand', sans-serif;
                background-color: var(--light-bg);
                color: #5a5c69;
            }

            /* --- CARD & GENERAL --- */
            .main-content {
                padding: 20px;
            }
            .card-modern {
                background: #fff;
                border: none;
                border-radius: 15px;
                box-shadow: var(--card-shadow);
                margin-bottom: 25px;
                overflow: hidden;
            }
            .card-header-modern {
                background: #fff;
                padding: 20px 25px;
                border-bottom: 1px solid #e3e6f0;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }
            .page-title {
                font-weight: 700;
                color: var(--primary-color);
                font-size: 1.5rem;
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .stat-badge {
                background: rgba(78, 115, 223, 0.1);
                color: var(--primary-color);
                padding: 5px 12px;
                border-radius: 20px;
                font-weight: 600;
                font-size: 0.9rem;
            }

            /* --- FILTER --- */
            .filter-container {
                padding: 20px 25px;
                background-color: #fff;
                border-bottom: 1px solid #f0f0f0;
            }
            .search-input-group .input-group-text {
                background: transparent;
                border-right: none;
                color: #aaa;
            }
            .search-input-group .form-control {
                border-left: none;
                box-shadow: none;
            }
            .search-input-group .form-control:focus {
                border-color: #ced4da;
            }

            /* --- TABLE STYLES --- */
            .table-modern {
                width: 100%;
                margin-bottom: 0;
                table-layout: fixed;
            }
            .table-modern thead th {
                background-color: #f8f9fc;
                color: #858796;
                font-weight: 700;
                text-transform: uppercase;
                font-size: 0.85rem;
                border-bottom: 2px solid #e3e6f0;
                padding: 15px;
                border-top: none;
            }
            .table-modern tbody td {
                padding: 15px;
                vertical-align: middle;
                border-bottom: 1px solid #e3e6f0;
                color: #5a5c69;
                font-size: 0.95rem;
            }
            .table-modern tbody tr:hover {
                background-color: #fcfcfc;
            }

            /* Blur Effect for Data Loading */
            .table-blur {
                opacity: 0.5;
                pointer-events: none;
                transition: opacity 0.2s ease;
            }

            /* --- TRUNCATION HELPERS --- */
            .cell-truncate {
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
                display: block;
                max-width: 100%;
            }

            /* Address max 2 lines */
            .text-truncate-2 {
                display: -webkit-box;
                -webkit-line-clamp: 2;
                -webkit-box-orient: vertical;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: normal;
                line-height: 1.4;
            }

            /* --- AVATAR & INFO --- */
            .avatar-circle {
                width: 45px;
                height: 45px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                color: white;
                font-weight: bold;
                font-size: 1.2rem;
                margin-right: 15px;
                text-transform: uppercase;
                flex-shrink: 0;
            }
            .user-profile {
                display: flex;
                align-items: center;
                overflow: hidden;
            }
            .user-info {
                overflow: hidden;
                width: 100%;
            }
            .user-info .name {
                font-weight: 700;
                color: #4e73df;
                font-size: 1rem;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }
            .user-info .sub-text {
                font-size: 0.85rem;
                color: #858796;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

            /* --- BUTTONS --- */
            .action-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(32px, 1fr));
                gap: 5px;
                max-width: 120px;
                margin: 0 auto;
            }
            .btn-soft {
                border: none;
                border-radius: 6px;
                width: 100%;
                height: 32px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                transition: all 0.2s;
            }

            .btn-soft-primary {
                background: rgba(78, 115, 223, 0.1);
                color: #4e73df;
            }
            .btn-soft-primary:hover {
                background: #4e73df;
                color: #fff;
            }

            .btn-soft-info {
                background: rgba(54, 185, 204, 0.1);
                color: #36b9cc;
            }
            .btn-soft-info:hover {
                background: #36b9cc;
                color: #fff;
            }

            .btn-soft-danger {
                background: rgba(231, 74, 59, 0.1);
                color: #e74a3b;
            }
            .btn-soft-danger:hover {
                background: #e74a3b;
                color: #fff;
            }

            .btn-add-new {
                background: linear-gradient(45deg, #1cc88a, #13855c);
                border: none;
                box-shadow: 0 4px 10px rgba(28, 200, 138, 0.3);
                color: white;
                padding: 10px 20px;
                border-radius: 10px;
                font-weight: 600;
                transition: transform 0.2s;
            }
            .btn-add-new:hover {
                transform: translateY(-2px);
                color: whitesmoke !important;
            }

            /* --- MODAL --- */
            .modal-content-modern {
                border-radius: 15px;
                border: none;
                overflow: hidden;
            }
            .modal-header-modern {
                padding: 15px 20px;
                border-bottom: 1px solid #eee;
            }
            .modal-header-modern.bg-green {
                background: #d4edda;
                color: #155724;
            }
            .modal-header-modern.bg-blue {
                background: #d1ecf1;
                color: #0c5460;
            }

            /* Input Groups & Floating Labels */
            .input-group .form-floating {
                flex-grow: 1;
            }
            .input-group .form-floating > .form-control {
                border-radius: 0 10px 10px 0;
                border-left: none;
            }
            .input-group .input-group-text {
                border-radius: 10px 0 0 10px;
                background-color: #f8f9fc;
                border-right: none;
                color: var(--primary-color);
                min-width: 45px;
                justify-content: center;
            }

            /* [UPDATED] Validation Error Style */
            label.error {
                color: #e74a3b;
                font-size: 0.85rem;
                margin-top: 5px;
                display: block;
                margin-left: 5px;
                font-weight: 600;
                white-space: normal;
                line-height: 1.2;
            }
            .form-control.error {
                border-color: #e74a3b !important;
                background-color: #fff8f8 !important;
            }
            .input-group > .form-floating > .form-control.error {
                z-index: 3;
            }

            /* Delete Modal List */
            .list-group-item {
                border: 1px solid #e3e6f0;
                font-size: 0.95rem;
            }
            .list-group-item span.badge {
                font-size: 0.85rem;
            }

            /* --- TOAST & PAGINATION --- */
            .toast-notification {
                position: fixed;
                top: 20px;
                left: 50%;
                transform: translateX(-50%);
                z-index: 1060;
                padding: 12px 20px;
                border-radius: 10px;
                background: #fff;
                box-shadow: 0 5px 15px rgba(0,0,0,0.15);
                display: none;
                align-items: center;
                gap: 10px;
                border-left: 4px solid #4e73df;
                animation: slideDown 0.4s ease;
            }
            @keyframes slideDown {
                from {
                    top: -50px;
                    opacity: 0;
                }
                to {
                    top: 20px;
                    opacity: 1;
                }
            }

            .pagination-wrapper {
                margin-top: 20px;
                display: flex;
                justify-content: flex-end;
            }
            .custom-pagination {
                display: flex;
                list-style: none;
                gap: 5px;
                padding: 0;
            }
            .custom-page-link {
                width: 35px;
                height: 35px;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 8px;
                background: #fff;
                border: 1px solid #e3e6f0;
                color: #858796;
                text-decoration: none;
                transition: all 0.2s;
                cursor: pointer;
            }
            .custom-page-link:hover {
                background: #f8f9fc;
            }
            .custom-page-item.active .custom-page-link {
                background: var(--primary-color);
                color: white;
                border-color: var(--primary-color);
            }

            #table-loader {
                min-height: 200px;
                display: flex;
                align-items: center;
                justify-content: center;
            }
        </style>
    </head>

    <body id="admin-body">

        <div id="toast-message" class="toast-notification">
            <i class="bi bi-info-circle-fill text-primary"></i>
            <span id="toast-text" class="fw-bold text-dark">Notification</span>
        </div>

        <jsp:include page="admin_header-sidebar.jsp" />

        <div class="main-content">

            <div class="card-modern">
                <div class="card-header-modern">
                    <div class="page-title">
                        <i class="bi bi-person-badge-fill"></i> Staff Management
                        <span class="stat-badge"><c:out value="${fn:length(staffList)}"/> Staffs</span>
                    </div>
                    <button type="button" class="btn btn-add-new" data-bs-toggle="modal" data-bs-target="#addStaffModal">
                        <i class="bi bi-plus-lg me-1"></i> New Staff
                    </button>
                </div>

                <div class="filter-container">
                    <div class="row g-2">
                        <div class="col-md-3">
                            <div class="input-group search-input-group">
                                <span class="input-group-text"><i class="bi bi-search"></i></span>
                                <input type="text" id="sUser" class="form-control" placeholder="Search Username...">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="input-group search-input-group">
                                <span class="input-group-text"><i class="bi bi-person"></i></span>
                                <input type="text" id="sName" class="form-control" placeholder="Search Name...">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="input-group search-input-group">
                                <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                                <input type="text" id="sEmail" class="form-control" placeholder="Search Email...">
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="input-group search-input-group">
                                <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                                <input type="text" id="sPhone" class="form-control" placeholder="Phone...">
                            </div>
                        </div>
                        <div class="col-md-1 text-end">
                            <button class="btn btn-light w-100 text-muted border" onclick="resetFilters()" title="Reset">
                                <i class="bi bi-arrow-counterclockwise"></i>
                            </button>
                        </div>
                    </div>
                </div>

                <div id="table-loader">
                    <div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div>
                </div>

                <div id="account-content-container" style="display: none;">
                    <div class="table-responsive">
                        <table class="table table-modern align-middle" id="accountTableMain">
                            <thead>
                                <tr>
                                    <th style="width: 8%">ID</th>
                                    <th style="width: 25%">Staff Profile</th>
                                    <th style="width: 25%">Contact Info</th>
                                    <th style="width: 27%">Address</th>
                                    <th style="width: 15%" class="text-center">Actions</th> 
                                </tr>
                            </thead>
                            <tbody id="staff-table-body">
                                <c:forEach var="staff" items="${staffList}">
                                    <tr class="staff-row">
                                        <td class="text-muted fw-bold">S-${staff.staff_id}</td>
                                        <td>
                                            <div class="user-profile">
                                                <div class="avatar-circle" data-name="${staff.username}"></div>
                                                <div class="user-info">
                                                    <div class="name cell-truncate" title="${staff.username}"><c:out value="${staff.username}"/></div>
                                                    <div class="sub-text cell-truncate" title="${staff.fullName}"><c:out value="${staff.fullName}"/></div>
                                                    <c:if test="${staff.role == 'admin'}">
                                                        <span class="badge bg-danger rounded-pill px-2 mt-1" style="font-size: 0.7rem;">Admin</span>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="d-flex flex-column" style="max-width: 100%;">
                                                <small class="cell-truncate text-muted" title="${staff.email}">
                                                    <i class="bi bi-envelope me-2"></i>${staff.email}
                                                </small>
                                                <small class="cell-truncate text-muted" title="${staff.phoneNumber}">
                                                    <i class="bi bi-telephone me-2"></i>${staff.phoneNumber}
                                                </small>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="text-truncate-2 text-muted small" title="${staff.address}">
                                                ${staff.address}
                                            </div>
                                        </td>
                                        <td class="text-center">
                                            <div class="action-grid">
                                                <c:if test="${staff.role != 'admin'}">
                                                    <button type="button" class="btn-soft btn-soft-primary btn-edit"
                                                            data-bs-toggle="modal" data-bs-target="#updateAccountModal"
                                                            data-id="${staff.staff_id}" data-type="staff"
                                                            data-username="${staff.username}" data-email="${staff.email}"
                                                            data-fullname="${staff.fullName}" data-phone="${staff.phoneNumber}"
                                                            data-address="${staff.address}" title="Edit">
                                                        <i class="bi bi-pencil-fill"></i>
                                                    </button>

                                                    <button type="button" class="btn-soft btn-soft-danger"
                                                            data-bs-toggle="modal" data-bs-target="#deleteAccountModal"
                                                            data-username="${staff.username}" data-type="staff"
                                                            data-id="${staff.staff_id}" title="Delete">
                                                        <i class="bi bi-trash-fill"></i>
                                                    </button>
                                                </c:if>

                                                <button type="button" class="btn-soft btn-soft-info"
                                                        data-bs-toggle="modal" data-bs-target="#viewStaffModal"
                                                        data-id="${staff.staff_id}" data-username="${staff.username}"
                                                        data-email="${staff.email}" data-fullname="${staff.fullName}"
                                                        data-phone="${staff.phoneNumber}" data-address="${staff.address}"
                                                        data-role="${staff.role}" title="View Details">
                                                    <i class="bi bi-info-circle-fill"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                    <div id="staff-pagination" class="pagination-wrapper px-4 pb-3"></div>
                </div> 
            </div>
        </div>

        <%-- MODAL ADD --%>
        <div class="modal fade" id="addStaffModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content modal-content-modern">
                    <div class="modal-header-modern bg-green d-flex justify-content-between">
                        <h5 class="fw-bold mb-0"><i class="bi bi-person-plus-fill me-2"></i> Add New Staff</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <form action="${BASE_URL}/admin" method="POST" id="addStaffForm">
                            <input type="hidden" name="action" value="add_staff">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="bi bi-person"></i></span>
                                        <div class="form-floating">
                                            <%-- Validation: 6-20 chars --%>
                                            <input type="text" class="form-control" name="username" placeholder="Username" required minlength="6" maxlength="20">
                                            <label>Username</label>
                                        </div>
                                    </div>
                                    <label id="add_staff_username_error" class="error text-danger small mt-1" style="display: none;"></label>
                                </div>
                                <div class="col-md-6">
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="bi bi-card-text"></i></span>
                                        <div class="form-floating">
                                            <%-- Validation: 2-100 chars, capitalize --%>
                                            <input type="text" class="form-control capitalize-input" name="fullName" placeholder="Full Name" required minlength="2" maxlength="100" style="text-transform: capitalize;">
                                            <label>Full Name</label>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="bi bi-key"></i></span>
                                        <div class="form-floating">
                                            <%-- Validation: 8-24 chars for pass --%>
                                            <input type="password" class="form-control" id="add_staff_password" name="password" placeholder="Password" required minlength="8" maxlength="24">
                                            <label>Password</label>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="bi bi-check2-circle"></i></span>
                                        <div class="form-floating">
                                            <input type="password" class="form-control" name="confirmPassword" placeholder="Confirm Password" required minlength="8" maxlength="24">
                                            <label>Confirm Password</label>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                                        <div class="form-floating">
                                            <input type="email" class="form-control" id="add_email" name="email" placeholder="Email" required maxlength="50">
                                            <label>Email</label>
                                        </div>
                                    </div>
                                    <label id="add_staff_email_error" class="error text-danger small mt-1" style="display: none;"></label>
                                </div>
                                <div class="col-md-6">
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                                        <div class="form-floating">
                                            <input type="text" class="form-control" id="add_phone" name="phone" placeholder="Phone" required maxlength="10">
                                            <label>Phone</label>
                                        </div>
                                    </div>
                                    <label id="add_staff_phone_error" class="error text-danger small mt-1" style="display: none;"></label>
                                </div>
                                <div class="col-12">
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="bi bi-geo-alt"></i></span>
                                        <div class="form-floating">
                                            <input type="text" class="form-control" name="address" placeholder="Address" required maxlength="255">
                                            <label>Address</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="mt-4 text-end">
                                <button type="button" class="btn btn-light me-2" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="submit-btn btn btn-success px-4 fw-bold">Add Staff</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <%-- MODAL UPDATE --%>
        <div class="modal fade" id="updateAccountModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content modal-content-modern">
                    <div class="modal-header-modern bg-blue d-flex justify-content-between">
                        <h5 class="fw-bold mb-0"><i class="bi bi-pencil-square me-2"></i> Update Staff</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <form action="${BASE_URL}/admin" method="POST" id="updateAccountForm">
                            <input type="hidden" name="action" value="update_account">
                            <input type="hidden" id="upd_id" name="id">
                            <input type="hidden" id="upd_type" name="type" value="staff"> 

                            <div class="row g-3">
                                <div class="col-md-6">
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="bi bi-person-lock"></i></span>
                                        <div class="form-floating">
                                            <input type="text" class="form-control bg-light" id="upd_username" name="username" readonly>
                                            <label>Username (Read-only)</label>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="bi bi-card-text"></i></span>
                                        <div class="form-floating">
                                            <input type="text" class="form-control capitalize-input" id="upd_fullName" name="fullName" required minlength="2" maxlength="100" placeholder="Name" style="text-transform: capitalize;">
                                            <label>Full Name</label>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                                        <div class="form-floating">
                                            <input type="email" class="form-control" id="upd_email" name="email" required maxlength="50" placeholder="Email">
                                            <label>Email</label>
                                        </div>
                                    </div>
                                    <label id="upd_staff_email_error" class="error text-danger small mt-1" style="display: none;"></label>
                                </div>
                                <div class="col-md-6">
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                                        <div class="form-floating">
                                            <input type="text" class="form-control" id="upd_phone" name="phone" required placeholder="Phone" maxlength="10">
                                            <label>Phone</label>
                                        </div>
                                    </div>
                                    <label id="upd_staff_phone_error" class="error text-danger small mt-1" style="display: none;"></label>
                                </div>
                                <div class="col-12">
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="bi bi-geo-alt"></i></span>
                                        <div class="form-floating">
                                            <input type="text" class="form-control" id="upd_address" name="address" required maxlength="255" placeholder="Address">
                                            <label>Address</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="mt-4 text-end">
                                <button type="button" class="btn btn-light me-2" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="submit-btn btn btn-primary px-4 fw-bold">Save Changes</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <%-- MODAL VIEW INFO --%>
        <div class="modal fade" id="viewStaffModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content modal-content-modern shadow-lg">
                    <div class="modal-body p-0">
                        <div class="bg-primary p-4 text-white text-center position-relative" style="background: linear-gradient(135deg, #4e73df 0%, #224abe 100%);">
                            <button type="button" class="btn-close btn-close-white position-absolute top-0 end-0 m-3" data-bs-dismiss="modal"></button>
                            <div class="avatar-circle mx-auto mb-3 border border-3 border-white" id="view_avatar" style="width: 80px; height: 80px; font-size: 2.5rem; background: rgba(255,255,255,0.2);"></div>
                            <h4 id="view_staff_username" class="fw-bold mb-1"></h4>
                            <p id="view_staff_role" class="badge bg-light text-primary rounded-pill px-3"></p>
                        </div>
                        <div class="p-4">
                            <div class="d-flex justify-content-between border-bottom py-2"><span class="text-muted fw-bold">ID:</span> <span id="view_staff_id" class="text-dark"></span></div>
                            <div class="d-flex justify-content-between border-bottom py-2"><span class="text-muted fw-bold">Full Name:</span> <span id="view_staff_fullname" class="text-dark"></span></div>
                            <div class="d-flex justify-content-between border-bottom py-2"><span class="text-muted fw-bold">Email:</span> <span id="view_staff_email" class="text-dark"></span></div>
                            <div class="d-flex justify-content-between border-bottom py-2"><span class="text-muted fw-bold">Phone:</span> <span id="view_staff_phone" class="text-dark"></span></div>
                            <div class="py-2"><span class="text-muted fw-bold d-block mb-1">Address:</span> <span id="view_staff_address" class="text-dark d-block bg-light p-2 rounded text-break"></span></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <%-- MODAL DELETE --%>
        <div class="modal fade" id="deleteAccountModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content modal-content-modern border-danger border-top border-5">
                    <div class="modal-header border-0">
                        <h5 class="modal-title text-danger fw-bold">Delete Staff</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <p class="text-center mb-4">Checking dependencies for staff: <strong id="del_user_display" class="text-dark bg-light px-2 py-1 rounded"></strong></p>

                        <div id="accountDataLoading" class="text-center py-3">
                            <div class="spinner-border text-danger"></div>
                            <div class="small mt-2 text-muted">Scanning orders & imports...</div>
                        </div>

                        <div id="accountDataContent" style="display: none;">
                            <ul class="list-group mb-3">
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    <span><i class="bi bi-box-seam me-2 text-primary"></i> Orders Handled</span>
                                    <span class="badge rounded-pill" id="staff-orders-count">0</span>
                                </li>
                                <li class="list-group-item d-flex justify-content-between align-items-center">
                                    <span><i class="bi bi-file-earmark-arrow-down me-2 text-warning"></i> Imports Created</span>
                                    <span class="badge rounded-pill" id="imports-count">0</span>
                                </li>
                            </ul>

                            <div id="deleteAccountWarning" class="alert alert-danger" role="alert" style="display: none;">
                                <div class="d-flex align-items-center">
                                    <i class="bi bi-exclamation-circle-fill fs-4 me-2"></i>
                                    <div><strong>Cannot Delete!</strong> Staff has associated data.</div>
                                </div>
                            </div>
                            <div id="deleteAccountSuccess" class="alert alert-success" role="alert" style="display: none;">
                                <div class="d-flex align-items-center">
                                    <i class="bi bi-check-circle-fill fs-4 me-2"></i>
                                    <div><strong>Safe to Delete.</strong> No dependencies found.</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0 justify-content-center pt-0 pb-4">
                        <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">Close</button>
                        <button id="confirmAccountDeleteButton" type="button" class="btn btn-danger px-4" disabled>Confirm Delete</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.5/dist/jquery.validate.min.js"></script>

        <script>
                                // --- UTILS ---
                                function showToast(msg, type = 'success') {
                                    const toast = $('#toast-message');
                                    const icon = toast.find('i');
                                    toast.find('#toast-text').text(msg);
                                    toast.css('border-left-color', type === 'error' ? '#e74a3b' : '#1cc88a');
                                    icon.attr('class', type === 'error' ? 'bi bi-exclamation-circle-fill text-danger' : 'bi bi-check-circle-fill text-success');
                                    toast.fadeIn().delay(3000).fadeOut();
                                }

                                function stringToColor(str) {
                                    var hash = 0;
                                    for (var i = 0; i < str.length; i++) {
                                        hash = str.charCodeAt(i) + ((hash << 5) - hash);
                                    }
                                    var c = (hash & 0x00FFFFFF).toString(16).toUpperCase();
                                    return "#" + "00000".substring(0, 6 - c.length) + c;
                                }

                                function initAvatars() {
                                    $('.avatar-circle').each(function () {
                                        var name = $(this).data('name') || "U";
                                        var initial = name.charAt(0).toUpperCase();
                                        $(this).css('background-color', stringToColor(name)).text(initial);
                                    });
                                }

                                // Hàm viết hoa chữ cái đầu (Auto-capitalize)
                                function toTitleCase(str) {
                                    return str.toLowerCase().replace(/(^|\s)\S/g, function (l) {
                                        return l.toUpperCase();
                                    });
                                }

                                // Toggle table blur effect
                                function toggleTableBlur(active) {
                                    if (active)
                                        $('#accountTableMain tbody').addClass('table-blur');
                                    else
                                        $('#accountTableMain tbody').removeClass('table-blur');
                                }

                                // --- VALIDATION SETUP ---
                                const validationConfig = {
                                    errorElement: "label",
                                    errorClass: "error",
                                    errorPlacement: function (error, element) {
                                        if (element.closest('.input-group').length) {
                                            error.insertAfter(element.closest('.input-group'));
                                        } else {
                                            error.insertAfter(element);
                                        }
                                    }
                                };

                                // Rule 1: Username (Letters & Numbers only)
                                $.validator.addMethod("validUsername", function (value, element) {
                                    return this.optional(element) || /^[a-zA-Z0-9]+$/.test(value);
                                }, "Username must contain only letters and numbers (no special characters).");

                                // Rule 2: Fullname (Letters, Spaces, Vietnamese Chars)
                                $.validator.addMethod("validName", function (value, element) {
                                    return this.optional(element) || /^[a-zA-ZÀ-ỹ\s]+$/.test(value);
                                }, "Name cannot contain numbers or special characters.");

                                // Rule 3: Phone (Start with 0, Exactly 10 digits)
                                $.validator.addMethod("validPhone", function (value, element) {
                                    return this.optional(element) || /^0\d{9}$/.test(value);
                                }, "Phone must start with 0 and have exactly 10 digits.");

                                // Rule 4: Address (Alphanumeric + , . / -)
                                $.validator.addMethod("validAddress", function (value, element) {
                                    return this.optional(element) || /^[a-zA-Z0-9À-ỹ\s,\/.-]+$/.test(value);
                                }, "Address cannot contain special characters (except comma, dot, slash, hyphen).");

                                // Rule 5: Password Complexity (1 Upper, 1 Special)
                                $.validator.addMethod("complexPassword", function (value, element) {
                                    return this.optional(element) || /^(?=.*[A-Z])(?=.*[!@#$%^&*(),.?":{}|<>_+\-=\[\]{};':"\\|\/]).*$/.test(value);
                                }, "Password must have at least 1 Uppercase & 1 Special char.");


                                // --- SEARCH & PAGINATION & LOCAL DATA ---
                                let allStaffData = [], filteredStaff = [], currentPage = 1, perPage = 8;

                                $(document).ready(function () {
                                    setTimeout(function () {
                                        $('#table-loader').fadeOut(200, function () {
                                            $('#account-content-container').fadeIn(200);
                                            initStaffPagination();
                                        });
                                    }, 400);

                                    // Auto Capitalize on Blur
                                    $('.capitalize-input').on('blur', function () {
                                        var val = $(this).val();
                                        if (val) {
                                            $(this).val(toTitleCase(val));
                                        }
                                    });

                                    $('#sUser, #sName, #sEmail, #sPhone').on('input', function () {
                                        toggleTableBlur(true);
                                        setTimeout(() => {
                                            applyStaffFilters();
                                            toggleTableBlur(false);
                                        }, 200);
                                    });
                                });

                                function initStaffPagination() {
                                    let rows = document.querySelectorAll('.staff-row');
                                    allStaffData = [];

                                    rows.forEach(r => {
                                        let cols = r.querySelectorAll('td');
                                        let dID = cols[0].innerText.replace('S-', '').toLowerCase();
                                        let dUser = r.querySelector('.name').innerText;
                                        let dName = r.querySelector('.sub-text').innerText;
                                        let contactDiv = cols[2];
                                        let dEmail = contactDiv.innerText.toLowerCase();
                                        let dPhone = contactDiv.innerText.toLowerCase();
                                        let dAddr = cols[3].innerText.toLowerCase();
                                        let dRole = r.querySelector('.badge.bg-danger') ? 'admin' : 'staff';

                                        let cleanEmail = r.querySelector('.bi-envelope').nextSibling.nodeValue.trim();
                                        let cleanPhone = r.querySelector('.bi-telephone').nextSibling.nodeValue.trim();
                                        let cleanAddr = r.querySelector('.text-truncate-2').innerText.trim();

                                        allStaffData.push({
                                            data: {id: dID, user: dUser, name: dName, email: cleanEmail, phone: cleanPhone, addr: cleanAddr, role: dRole}
                                        });
                                    });

                                    allStaffData.sort((a, b) => a.data.user.localeCompare(b.data.user));
                                    filteredStaff = allStaffData;
                                    renderStaffPage(1);
                                }

                                function applyStaffFilters() {
                                    let vUser = $('#sUser').val().toLowerCase();
                                    let vName = $('#sName').val().toLowerCase();
                                    let vEmail = $('#sEmail').val().toLowerCase();
                                    let vPhone = $('#sPhone').val().toLowerCase();

                                    filteredStaff = allStaffData.filter(item => {
                                        let d = item.data;
                                        return (!vUser || d.user.toLowerCase().includes(vUser)) &&
                                                (!vName || d.name.toLowerCase().includes(vName)) &&
                                                (!vEmail || d.email.toLowerCase().includes(vEmail)) &&
                                                (!vPhone || d.phone.includes(vPhone));
                                    });
                                    renderStaffPage(1);
                                }

                                function resetFilters() {
                                    toggleTableBlur(true);
                                    setTimeout(() => {
                                        $('.filter-container input').val('');
                                        applyStaffFilters();
                                        toggleTableBlur(false);
                                    }, 200);
                                }

                                function renderStaffPage(page) {
                                    currentPage = page;
                                    let start = (page - 1) * perPage;
                                    let end = start + perPage;
                                    let pageItems = filteredStaff.slice(start, end);

                                    let tbody = $('#staff-table-body');
                                    tbody.empty();

                                    if (pageItems.length > 0) {
                                        pageItems.forEach(item => {
                                            tbody.append(renderRowHtml(item.data));
                                        });
                                        initAvatars();
                                    }

                                    let total = Math.ceil(filteredStaff.length / perPage);
                                    let html = '<ul class="custom-pagination">';

                                    if (total > 1) {
                                        if (page > 1)
                                            html += `<li class="custom-page-item"><a class="custom-page-link" onclick="changePage(\${page-1})"><i class="bi bi-chevron-left"></i></a></li>`;
                                        for (let i = 1; i <= total; i++) {
                                            if (i === 1 || i === total || (i >= page - 1 && i <= page + 1)) {
                                                html += `<li class="custom-page-item \${i===currentPage?'active':''}"><a class="custom-page-link" onclick="changePage(\${i})">\${i}</a></li>`;
                                            } else if (i === page - 2 || i === page + 2) {
                                                html += `<li class="custom-page-item"><span class="custom-page-link border-0">...</span></li>`;
                                            }
                                        }
                                        if (page < total)
                                            html += `<li class="custom-page-item"><a class="custom-page-link" onclick="changePage(\${page+1})"><i class="bi bi-chevron-right"></i></a></li>`;
                                    }
                                    html += '</ul>';
                                    if (filteredStaff.length === 0)
                                        html = '<div class="text-center text-muted w-100 py-3">No results found.</div>';
                                    document.getElementById('staff-pagination').innerHTML = html;
                                }

                                function changePage(page) {
                                    toggleTableBlur(true);
                                    setTimeout(() => {
                                        renderStaffPage(page);
                                        toggleTableBlur(false);
                                    }, 150);
                                }

                                function renderRowHtml(d) {
                                    let adminBadge = d.role === 'admin' ? '<span class="badge bg-danger rounded-pill px-2 mt-1" style="font-size: 0.7rem;">Admin</span>' : '';
                                    let actions = '';

                                    if (d.role !== 'admin') {
                                        actions += `
                        <button type="button" class="btn-soft btn-soft-primary btn-edit"
                                data-bs-toggle="modal" data-bs-target="#updateAccountModal"
                                data-id="\${d.id}" data-type="staff"
                                data-username="\${d.user}" data-email="\${d.email}"
                                data-fullname="\${d.name}" data-phone="\${d.phone}"
                                data-address="\${d.addr}" title="Edit">
                            <i class="bi bi-pencil-fill"></i>
                        </button>
                        <button type="button" class="btn-soft btn-soft-danger"
                                data-bs-toggle="modal" data-bs-target="#deleteAccountModal"
                                data-username="\${d.user}" data-type="staff"
                                data-id="\${d.id}" title="Delete">
                            <i class="bi bi-trash-fill"></i>
                        </button>
                    `;
                                    }

                                    return `
                    <tr class="staff-row">
                        <td class="text-muted fw-bold">S-\${d.id}</td>
                        <td>
                            <div class="user-profile">
                                <div class="avatar-circle" data-name="\${d.user}"></div>
                                <div class="user-info">
                                    <div class="name cell-truncate" title="\${d.user}">\${d.user}</div>
                                    <div class="sub-text cell-truncate" title="\${d.name}">\${d.name}</div>
                                    \${adminBadge}
                                </div>
                            </div>
                        </td>
                        <td>
                            <div class="d-flex flex-column" style="max-width: 100%;">
                                <small class="cell-truncate text-muted" title="\${d.email}">
                                    <i class="bi bi-envelope me-2"></i>\${d.email}
                                </small>
                                <small class="cell-truncate text-muted" title="\${d.phone}">
                                    <i class="bi bi-telephone me-2"></i>\${d.phone}
                                </small>
                            </div>
                        </td>
                        <td>
                            <div class="text-truncate-2 text-muted small" title="\${d.addr}">\${d.addr}</div>
                        </td>
                        <td class="text-center">
                            <div class="action-grid">
                                \${actions}
                                <button type="button" class="btn-soft btn-soft-info"
                                        data-bs-toggle="modal" data-bs-target="#viewStaffModal"
                                        data-id="\${d.id}" data-username="\${d.user}"
                                        data-email="\${d.email}" data-fullname="\${d.name}"
                                        data-phone="\${d.phone}" data-address="\${d.addr}"
                                        data-role="\${d.role}" title="View Details">
                                    <i class="bi bi-info-circle-fill"></i>
                                </button>
                            </div>
                        </td>
                    </tr>
                `;
                                }

                                function updateLocalData(action, data) {
                                    if (action === 'add') {
                                        // Force reload for Add to sync IDs
                                        location.reload();
                                    } else if (action === 'update') {
                                        let idx = allStaffData.findIndex(i => i.data.id == data.id);
                                        if (idx !== -1) {
                                            allStaffData[idx].data.name = data.fullName;
                                            allStaffData[idx].data.email = data.email;
                                            allStaffData[idx].data.phone = data.phone;
                                            allStaffData[idx].data.addr = data.address;
                                            applyStaffFilters();
                                        }
                                    } else if (action === 'delete') {
                                        allStaffData = allStaffData.filter(i => i.data.id != data.id);
                                        applyStaffFilters();
                                    }
                                }

                                // --- MODALS ---
                                var viewStaffModal = document.getElementById('viewStaffModal');
                                if (viewStaffModal) {
                                    viewStaffModal.addEventListener('show.bs.modal', function (event) {
                                        var button = event.relatedTarget;
                                        var name = button.getAttribute('data-username');

                                        document.getElementById('view_staff_id').textContent = 'S-' + button.getAttribute('data-id');
                                        document.getElementById('view_staff_username').textContent = name;
                                        document.getElementById('view_staff_fullname').textContent = button.getAttribute('data-fullname');
                                        document.getElementById('view_staff_email').textContent = button.getAttribute('data-email');
                                        document.getElementById('view_staff_phone').textContent = button.getAttribute('data-phone');
                                        document.getElementById('view_staff_address').textContent = button.getAttribute('data-address');
                                        document.getElementById('view_staff_role').textContent = button.getAttribute('data-role');

                                        var avatar = document.getElementById('view_avatar');
                                        avatar.textContent = name.charAt(0).toUpperCase();
                                        avatar.style.backgroundColor = stringToColor(name);
                                    });
                                }

                                var updateAccountModal = document.getElementById('updateAccountModal');
                                if (updateAccountModal) {
                                    updateAccountModal.addEventListener('show.bs.modal', function (event) {
                                        var button = event.relatedTarget;
                                        $('#upd_id').val(button.getAttribute('data-id'));
                                        $('#upd_username').val(button.getAttribute('data-username'));
                                        $('#upd_email').val(button.getAttribute('data-email'));
                                        $('#upd_fullName').val(button.getAttribute('data-fullname'));
                                        $('#upd_phone').val(button.getAttribute('data-phone'));
                                        $('#upd_address').val(button.getAttribute('data-address'));
                                    });
                                }

                                // Add Staff Form (Validation Configured)
                                $("#addStaffForm").validate({
                                    ...validationConfig,
                                    rules: {
                                        username: {
                                            required: true,
                                            minlength: 6,
                                            maxlength: 20,
                                            validUsername: true
                                        },
                                        fullName: {
                                            required: true,
                                            minlength: 2,
                                            maxlength: 100,
                                            validName: true
                                        },
                                        password: {
                                            required: true,
                                            minlength: 8,
                                            maxlength: 24,
                                            complexPassword: true
                                        },
                                        confirmPassword: {
                                            required: true,
                                            minlength: 8,
                                            maxlength: 24,
                                            equalTo: "#add_staff_password"
                                        },
                                        email: {
                                            required: true,
                                            email: true,
                                            maxlength: 50
                                        },
                                        phone: {
                                            required: true,
                                            digits: true,
                                            minlength: 10,
                                            maxlength: 10,
                                            validPhone: true
                                        },
                                        address: {
                                            required: true,
                                            maxlength: 255,
                                            validAddress: true
                                        }
                                    },
                                    messages: {
                                        username: {
                                            required: "Please enter a username",
                                            minlength: "Username must be 6-20 characters",
                                            maxlength: "Username must be 6-20 characters",
                                            validUsername: "Username must contain only letters and numbers (no special characters)."
                                        },
                                        fullName: {
                                            required: "Please enter full name",
                                            minlength: "Name must be 2-100 characters",
                                            maxlength: "Name must be 2-100 characters",
                                            validName: "Name cannot contain numbers or special characters."
                                        },
                                        password: {
                                            required: "Please provide a password",
                                            minlength: "Password must be 8-24 characters",
                                            maxlength: "Password must be 8-24 characters",
                                            complexPassword: "Password must have at least 1 Uppercase & 1 Special char."
                                        },
                                        confirmPassword: {
                                            required: "Please confirm password",
                                            equalTo: "Passwords do not match"
                                        },
                                        email: {
                                            required: "Please enter an email",
                                            maxlength: "Email cannot exceed 50 characters",
                                            email: "Please enter a valid email address (e.g. abc@domain.com)"
                                        },
                                        phone: {
                                            required: "Please enter phone number",
                                            digits: "Only digits allowed",
                                            minlength: "Phone number must have exactly 10 digits",
                                            maxlength: "Phone number must have exactly 10 digits",
                                            validPhone: "Phone must start with 0 and have exactly 10 digits."
                                        },
                                        address: {
                                            required: "Please enter an address",
                                            maxlength: "Address cannot exceed 255 characters",
                                            validAddress: "Address cannot contain special characters (except comma, dot, slash, hyphen)."
                                        }
                                    },
                                    submitHandler: function (form) {
                                        var $btn = $(form).find('.submit-btn');
                                        $btn.prop('disabled', true).html('<span class="spinner-border spinner-border-sm"></span> Processing...');

                                        // Reset thông báo lỗi
                                        $(".error.text-danger").hide();
                                        $(".form-control").removeClass("is-invalid");

                                        $.ajax({
                                            url: $(form).attr('action'),
                                            type: 'POST',
                                            data: $(form).serialize(),
                                            dataType: 'json',
                                            success: function (data) {
                                                if (data.isSuccess) {
                                                    showToast('Staff added successfully!');
                                                    $('#addStaffModal').modal('hide');
                                                    setTimeout(() => location.reload(), 800);
                                                } else {
                                                    // Bắt lỗi trùng từ Backend trả về
                                                    if (data.description.includes("Username")) {
                                                        $("#add_staff_username_error").text(data.description).show();
                                                    } else if (data.description.includes("Email")) {
                                                        $("#add_staff_email_error").text(data.description).show();
                                                        $("#add_email").addClass("is-invalid");
                                                    } else {
                                                        showToast(data.description, 'error');
                                                    }
                                                }
                                            },
                                            error: function () {
                                                showToast('Server connection error', 'error');
                                            },
                                            complete: function () {
                                                $btn.prop('disabled', false).html('Add Staff');
                                            }
                                        });
                                    }
                                });


                                // Update Form (Validation Configured)
                                $("#updateAccountForm").validate({
                                    ...validationConfig,
                                    rules: {
                                        fullName: {
                                            required: true,
                                            minlength: 2,
                                            maxlength: 100,
                                            validName: true
                                        },
                                        email: {
                                            required: true,
                                            email: true,
                                            maxlength: 50
                                        },
                                        phone: {
                                            required: true,
                                            digits: true,
                                            minlength: 10,
                                            maxlength: 10,
                                            validPhone: true
                                        },
                                        address: {
                                            required: true,
                                            maxlength: 255,
                                            validAddress: true
                                        }
                                    },
                                    messages: {
                                        fullName: {
                                            required: "Please enter full name",
                                            minlength: "Name must be 2-100 characters",
                                            maxlength: "Name must be 2-100 characters",
                                            validName: "Name cannot contain numbers or special characters."
                                        },
                                        email: {
                                            required: "Please enter an email",
                                            maxlength: "Email cannot exceed 50 characters",
                                            email: "Please enter a valid email address"
                                        },
                                        phone: {
                                            required: "Please enter phone number",
                                            digits: "Only digits allowed",
                                            minlength: "Phone number must have exactly 10 digits",
                                            maxlength: "Phone number must have exactly 10 digits",
                                            validPhone: "Phone must start with 0 and have exactly 10 digits."
                                        },
                                        address: {
                                            required: "Please enter an address",
                                            maxlength: "Address cannot exceed 255 characters",
                                            validAddress: "Address cannot contain special characters (except comma, dot, slash, hyphen)."
                                        }
                                    },
                                    submitHandler: function (form) {
                                        var $btn = $(form).find('.submit-btn');
                                        $btn.prop('disabled', true).html('<span class="spinner-border spinner-border-sm"></span> Saving...');

                                        // Reset lỗi
                                        $("#upd_staff_email_error, #upd_staff_phone_error").hide();
                                        $("#upd_email, #upd_phone").removeClass("is-invalid");

                                        $.ajax({
                                            url: $(form).attr('action'),
                                            type: 'POST',
                                            data: $(form).serialize(),
                                            dataType: 'json',
                                            success: function (data) {
                                                if (data.isSuccess) {
                                                    showToast('Staff information updated!');
                                                    $('#updateAccountModal').modal('hide');
                                                    // Cập nhật dữ liệu tại chỗ hoặc reload
                                                    setTimeout(() => location.reload(), 800);
                                                } else {
                                                    // Xử lý lỗi trùng lặp email/phone từ handleAccountAction
                                                    if (data.description.includes("Email")) {
                                                        $("#upd_staff_email_error").text(data.description).show();
                                                        $("#upd_email").addClass("is-invalid");
                                                    } else if (data.description.includes("Phone")) {
                                                        $("#upd_staff_phone_error").text(data.description).show();
                                                        $("#upd_phone").addClass("is-invalid");
                                                    } else {
                                                        showToast(data.description, 'error');
                                                    }
                                                }
                                            },
                                            error: function () {
                                                showToast('Could not connect to server', 'error');
                                            },
                                            complete: function () {
                                                $btn.prop('disabled', false).html('Save Changes');
                                            }
                                        });
                                    }
                                });

                                // Delete Logic
                                var deleteAccountModal = document.getElementById('deleteAccountModal');
                                var confirmDeleteButton = document.getElementById('confirmAccountDeleteButton');

                                if (deleteAccountModal) {
                                    deleteAccountModal.addEventListener('show.bs.modal', function (event) {
                                        var button = event.relatedTarget;
                                        var accountId = button.getAttribute('data-id');
                                        var username = button.getAttribute('data-username');

                                        $('#del_user_display').text(username);
                                        $(confirmDeleteButton).data('id', accountId).data('username', username);

                                        $('#accountDataLoading').show();
                                        $('#accountDataContent, #deleteAccountWarning, #deleteAccountSuccess').hide();
                                        $(confirmDeleteButton).prop('disabled', true);

                                        $.ajax({
                                            url: '${BASE_URL}/admin', // Sửa lại URL trỏ về Servlet Admin
                                            type: 'GET',
                                            data: {
                                                action: 'get_account_related_data', // Thêm tham số action để Controller nhận diện
                                                id: accountId,
                                                type: 'staff'
                                            },
                                            dataType: 'json',
                                            success: function (data) {
                                                $('#accountDataLoading').hide();

                                                // Logic xử lý dữ liệu trả về giữ nguyên
                                                var orders = (data.orders && data.orders.length > 0) ? data.orders.length : 0;
                                                var imports = (data.imports && data.imports.length > 0) ? data.imports.length : 0;

                                                $('#staff-orders-count').text(orders).attr('class', 'badge rounded-pill ' + (orders > 0 ? 'bg-danger' : 'bg-secondary'));
                                                $('#imports-count').text(imports).attr('class', 'badge rounded-pill ' + (imports > 0 ? 'bg-danger' : 'bg-secondary'));

                                                $('#accountDataContent').fadeIn();

                                                if (orders > 0 || imports > 0) {
                                                    $('#deleteAccountSuccess').hide();
                                                    $('#deleteAccountWarning').fadeIn();
                                                    $(confirmDeleteButton).prop('disabled', true);
                                                } else {
                                                    $('#deleteAccountWarning').hide();
                                                    $('#deleteAccountSuccess').fadeIn();
                                                    $(confirmDeleteButton).prop('disabled', false);
                                                }
                                            },
                                            error: function (xhr, status, error) {
                                                console.error("AJAX Error:", error);
                                                // Tắt loading nếu lỗi để tránh treo modal
                                                $('#accountDataLoading').hide();
                                                alert("Error loading data check console.");
                                            }
                                        });
                                    });
                                }

                                $(confirmDeleteButton).on('click', function () {
                                    var btn = $(this);
                                    btn.prop('disabled', true).html('<span class="spinner-border spinner-border-sm"></span> Deleting...');
                                    toggleTableBlur(true);

                                    $.ajax({
                                        url: '${BASE_URL}/admin', type: 'POST',
                                        data: {action: 'delete_account', id: btn.data('id'), username: btn.data('username'), type: 'staff'},
                                        dataType: 'json',
                                        success: function (data) {
                                            if (data.isSuccess) {
                                                showToast('Staff deleted!');
                                                updateLocalData('delete', {id: btn.data('id')});
                                                $('#deleteAccountModal').modal('hide');
                                            } else {
                                                showToast(data.description, 'error');
                                            }
                                        },
                                        complete: function () {
                                            btn.prop('disabled', false).html('Confirm Delete');
                                            toggleTableBlur(false);
                                        }
                                    });
                                });
        </script>
    </body>
</html>