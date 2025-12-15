<%-- 
    Document   : admin_PersonalInformation.jsp
    Description: Staff/Admin Personal Info & Change Password (Added Icons)
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="entity.Staff" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="BASE_URL" value="${pageContext.request.contextPath}" />

<%
    // 1. Lấy thông tin Staff từ session
    Staff s = (Staff) session.getAttribute("staff");

    // 2. LOGIC CHẶN TẤT CẢ NGOẠI TRỪ ADMIN
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
    <title>Admin | Personal Information</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://kit.fontawesome.com/1bd876819f.js" crossorigin="anonymous"></script>
    <link href='https://fonts.googleapis.com/css?family=Quicksand:400,500,600,700&display=swap' rel='stylesheet'> 
    <link rel="icon" href="${BASE_URL}/images/LG2.png" type="image/x-icon"> 

    <style>
        :root {
            --primary-color: #4e73df;
            --warning-color: #f6c23e;
            --success-color: #1cc88a;
            --danger-color: #e74a3b;
        }

        body { font-family: 'Quicksand', sans-serif; background-color: #f8f9fa; }

        /* --- Personal Main Card --- */
        .personal-main { 
            width: 90%; 
            max-width: 900px; 
            margin: 20px auto; 
            background: white; 
            box-shadow: 0 0.5rem 1rem rgba(0,0,0,0.08); 
            border-radius: 16px; 
            overflow: hidden; 
        }

        .personal-main table { width: 100%; border-collapse: collapse; }
        .personal-main table th, .personal-main table td { padding: 20px 30px; text-align: left; border-bottom: 1px solid #f0f0f0; }
        
        .personal-main table th { 
            width: 35%; 
            background-color: #f8f9fc; 
            font-weight: 600; 
            color: #555; 
            font-size: 1rem;
        }
        
        .personal-main table td { 
            font-weight: 500; 
            color: #333; 
            font-size: 1rem;
        }
        
        /* Icon styles inside table */
        .info-icon {
            width: 30px;
            height: 30px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background-color: rgba(78, 115, 223, 0.1);
            color: var(--primary-color);
            border-radius: 50%;
            margin-right: 12px;
            font-size: 0.9rem;
        }

        .personal-main table tr:last-child th, .personal-main table tr:last-child td { border-bottom: none; }

        .action-buttons { 
            padding: 25px 30px;
            display: flex; 
            gap: 15px; 
            justify-content: flex-end; 
            border-top: 1px solid #f0f0f0;
            background-color: #fff;
        }
        .action-buttons .btn { border-radius: 10px; font-weight: 600; padding: 10px 25px; display: flex; align-items: center; gap: 8px; }
        
        /* --- Modal & Forms --- */
        .modal-content-modern {
             border-radius: 16px; 
             border: none; 
             position: relative; 
             box-shadow: 0 10px 30px rgba(0,0,0,0.15);
             overflow: hidden;
        }
        
        .modal-header-modern {
            padding: 20px 30px;
            border-bottom: 1px solid #eee;
            background-color: #f8f9fc;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .form-floating > .form-control { border-radius: 10px; border: 1px solid #d1d3e2; }
        .form-floating > .form-control:focus { border-color: var(--primary-color); box-shadow: 0 0 0 0.2rem rgba(78, 115, 223, 0.15); }
        .form-floating.form-group { margin-bottom: 20px; }
        
        /* Readonly input style */
        .form-floating > .form-control[readonly] { background-color: #e9ecef; font-weight: bold; color: #555; }

        .submit-btn { width: 100%; padding: 12px; border: none; border-radius: 10px; font-weight: 700; color: white; margin-top: 10px; transition: all 0.2s; }
        .submit-btn:hover { transform: translateY(-2px); box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        
        .btn-primary-custom { background-color: var(--primary-color); }
        .btn-warning-custom { background-color: var(--warning-color); color: #333; }
        
        label.error { color: #dc3545; font-size: 0.85em; margin-top: 5px; display: block; margin-left: 5px; }

        /* --- Toast Notification --- */
        .toast-notification { 
            position: fixed; top: 20px; left: 50%; transform: translateX(-50%); 
            min-width: 350px; z-index: 2000; padding: 15px 20px; border-radius: 12px; 
            display: none; align-items: center; justify-content: space-between; gap: 15px; 
            font-weight: 600; box-shadow: 0 8px 20px rgba(0,0,0,0.15); border: 1px solid transparent;
        }
        .toast-notification.active { display: flex; animation: slideDown 0.4s ease-out; }
        .toast-success { background: #fff; border-left: 5px solid var(--success-color); color: var(--success-color); }
        .toast-error { background: #fff; border-left: 5px solid var(--danger-color); color: var(--danger-color); }
        .toast-icon { font-size: 1.4rem; }
        .toast-text { color: #333; flex-grow: 1; }
        .toast-close-btn { cursor: pointer; font-size: 1.1rem; color: #aaa; transition: 0.2s; }
        .toast-close-btn:hover { color: #333; }

        @keyframes slideDown { from { top: -60px; opacity: 0; } to { top: 20px; opacity: 1; } }
    </style>
</head>

<body id="admin-body">

    <%-- Toast Message Container --%>
    <div id="toast-message" class="toast-notification"></div>

    <c:if test="${param.msg == 'profile_updated'}">
        <script>window.onload = function() { showToast('Profile updated successfully!', 'success'); };</script>
    </c:if>
    <c:if test="${param.msg == 'pass_changed'}">
        <script>window.onload = function() { showToast('Password changed successfully!', 'success'); };</script>
    </c:if>

    <%-- Include Header --%>
    <jsp:include page="admin_header-sidebar.jsp" />

    <div class="main-content p-4">
        <div class="d-flex align-items-center mb-4">
            <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 50px; height: 50px; font-size: 1.5rem;">
                <i class="bi bi-person-lines-fill"></i>
            </div>
            <div>
                <h3 style="font-weight: bold; margin: 0; color: #333;">My Profile</h3>
                <p class="text-muted m-0 small">Manage your personal information and security.</p>
            </div>
        </div>
        
        <div class="personal-main">
            <table class="table-borderless">
                <tr>
                    <th><span class="info-icon"><i class="bi bi-person-vcard-fill"></i></span> Fullname</th>
                    <td><c:out value="${sessionScope.staff.fullName}"/></td>
                </tr>
                <tr>
                    <th><span class="info-icon"><i class="bi bi-telephone-fill"></i></span> Phone Number</th>
                    <td><c:out value="${sessionScope.staff.phoneNumber}"/></td>
                </tr>
                <tr>
                    <th><span class="info-icon"><i class="bi bi-envelope-at-fill"></i></span> Email Address</th>
                    <td><c:out value="${sessionScope.staff.email}"/></td>
                </tr>
                <tr>
                    <th><span class="info-icon"><i class="bi bi-geo-alt-fill"></i></span> Address</th>
                    <td><c:out value="${sessionScope.staff.address}"/></td>
                </tr>
                <tr>
                    <th><span class="info-icon"><i class="bi bi-person-circle"></i></span> Username</th>
                    <td><span class="badge bg-light text-dark border px-3 py-2"><c:out value="${sessionScope.staff.username}"/></span></td>
                </tr>
                <tr>
                    <th><span class="info-icon"><i class="bi bi-shield-lock-fill"></i></span> Role</th>
                    <td>
                        <span class="badge bg-primary px-3 py-2 text-uppercase">
                            <i class="bi bi-stars me-1"></i> <c:out value="${sessionScope.staff.role}"/>
                        </span>
                    </td>
                </tr>
            </table>
            
            <div class="action-buttons">
                <button type="button" class="btn btn-warning text-dark" data-bs-toggle="modal" data-bs-target="#changePasswordModal">
                    <i class="bi bi-key-fill"></i> Change Password
                </button>
                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#editProfileModal"
                        data-fullname="${sessionScope.staff.fullName}"
                        data-phone="${sessionScope.staff.phoneNumber}"
                        data-email="${sessionScope.staff.email}"
                        data-address="${sessionScope.staff.address}">
                    <i class="bi bi-pencil-square"></i> Edit Profile
                </button> 
            </div>
        </div>
    </div>

    <%-- Modal Edit Profile --%>
    <div class="modal fade" id="editProfileModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content modal-content-modern">
                <div class="modal-header-modern">
                    <h4 class="fw-bold m-0 text-primary"><i class="bi bi-person-gear me-2"></i>Edit Profile</h4>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <form action="${BASE_URL}/admin" method="POST" id="editProfileForm">
                        <input type="hidden" name="action" value="update_profile">
                        
                        <div class="row g-3">
                            <div class="col-md-6">
                                <div class="form-floating form-group">
                                    <input type="text" name="fullName" id="edit_fullName" class="form-control" required maxlength="50" placeholder="Fullname">
                                    <label for="edit_fullName"><i class="bi bi-person me-1"></i> Fullname</label>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-floating form-group">
                                    <input type="text" name="phone" id="edit_phone" class="form-control" required placeholder="Phone">
                                    <label for="edit_phone"><i class="bi bi-telephone me-1"></i> Phone</label>
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="form-floating form-group">
                                    <input type="email" name="email" id="edit_email" class="form-control" required placeholder="Email">
                                    <label for="edit_email"><i class="bi bi-envelope me-1"></i> Email</label>
                                </div>
                            </div>
                            <div class="col-12">
                                <div class="form-floating form-group">
                                    <input type="text" name="address" id="edit_address" class="form-control" required maxlength="255" placeholder="Address">
                                    <label for="edit_address"><i class="bi bi-geo-alt me-1"></i> Address</label>
                                </div>
                            </div>
                        </div>
                        <div class="mt-4 text-end">
                             <button type="button" class="btn btn-light me-2 fw-bold" data-bs-dismiss="modal">Cancel</button>
                             <button type="submit" class="submit-btn btn-primary-custom" style="width: auto; margin-top: 0; padding-left: 30px; padding-right: 30px;">
                                 <i class="bi bi-check-lg me-1"></i> Save Changes
                             </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <%-- Modal Change Password --%>
    <div class="modal fade" id="changePasswordModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content modal-content-modern">
                <div class="modal-header-modern">
                    <h4 class="fw-bold m-0 text-warning"><i class="bi bi-shield-lock me-2"></i>Change Password</h4>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <form action="${BASE_URL}/admin" method="POST" id="changePasswordForm">
                        <input type="hidden" name="action" value="change_password">
                        
                        <div class="form-floating form-group mb-3">
                            <input type="text" value="<c:out value='${sessionScope.staff.username}'/>" class="form-control" readonly>
                            <label><i class="bi bi-person-badge me-1"></i> Username (Read-only)</label>
                        </div>
                        <div class="form-floating form-group mb-3">
                            <input type="password" name="currentPassword" id="cp_current_pass" class="form-control" required placeholder="Old Password">
                            <label for="cp_current_pass"><i class="bi bi-key me-1"></i> Current Password</label>
                        </div>
                        <div class="row g-2">
                            <div class="col-md-6">
                                <div class="form-floating form-group mb-3">
                                    <input type="password" id="cp_new_pass" name="newPassword" class="form-control" required placeholder="New Password">
                                    <label for="cp_new_pass"><i class="bi bi-lock me-1"></i> New Password</label>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-floating form-group mb-3">
                                    <input type="password" name="confirmPassword" class="form-control" required placeholder="Confirm New Password">
                                    <label><i class="bi bi-check-circle me-1"></i> Confirm Password</label>
                                </div>
                            </div>
                        </div>
                        <div class="mt-4 text-end">
                            <button type="button" class="btn btn-light me-2 fw-bold" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="submit-btn btn-warning-custom" style="width: auto; margin-top: 0; padding-left: 30px; padding-right: 30px;">
                                <i class="bi bi-check-lg me-1"></i> Update Password
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.5/dist/jquery.validate.min.js"></script>

    <script>
        // Validation Rules
        $.validator.addMethod("validFullname", function (value, element) { return this.optional(element) || /^[\p{L} ]{2,50}$/u.test(value.trim()); }, "Fullname must contain letters only.");
        $.validator.addMethod("validPhone", function (value, element) { return this.optional(element) || /^(0\d{9,10}|\+84\d{9})$/.test(value); }, "Invalid phone number format.");

        // === TOAST FUNCTION ===
        function showToast(message, type) {
            var toast = $('#toast-message');
            var iconClass = (type === 'success') ? 'bi bi-check-circle-fill' : 'bi bi-exclamation-triangle-fill';
            var toastClass = (type === 'success') ? 'toast-success' : 'toast-error';

            var htmlContent = `
                <div class="d-flex align-items-center gap-3">
                    <i class="${iconClass} toast-icon"></i>
                    <span class="toast-text">${message}</span>
                </div>
                <i class="bi bi-x-lg toast-close-btn" onclick="$('#toast-message').removeClass('active')"></i>
            `;
            
            toast.html(htmlContent);
            toast.removeClass('toast-success toast-error').addClass(toastClass);
            toast.addClass('active');
            
            setTimeout(function() { toast.removeClass('active'); }, 4000);
        }

        $(document).ready(function () {
            
            // --- POPULATE EDIT MODAL DATA ---
            $('#editProfileModal').on('show.bs.modal', function (event) {
                const button = $(event.relatedTarget);
                const modal = $(this);
                
                modal.find('#edit_fullName').val(button.data('fullname'));
                modal.find('#edit_phone').val(button.data('phone'));
                modal.find('#edit_email').val(button.data('email'));
                modal.find('#edit_address').val(button.data('address'));
                
                $("#editProfileForm").validate().resetForm();
                modal.find('.form-control').removeClass('error');
            });
            
            // --- EDIT PROFILE FORM SUBMIT ---
            $("#editProfileForm").validate({
                rules: {
                    fullName: {required: true, validFullname: true, maxlength: 50},
                    phone: {required: true, validPhone: true},
                    email: {required: true, email: true},
                    address: {required: true, maxlength: 255}
                },
                submitHandler: function (form) {
                    var $btn = $(form).find('.submit-btn');
                    $btn.prop('disabled', true).html('<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Saving...');
                    
                    $.ajax({
                        url: $(form).attr('action'), type: 'POST', data: $(form).serialize(), dataType: 'json',
                        success: function (data) {
                            if (data.isSuccess) {
                                showToast('Profile updated!', 'success');
                                setTimeout(() => window.location.reload(), 1000); 
                            } else {
                                showToast(data.description, 'error');
                                $btn.prop('disabled', false).html('<i class="bi bi-check-lg me-1"></i> Save Changes');
                            }
                        },
                        error: function () {
                            showToast('Server error occurred.', 'error');
                            $btn.prop('disabled', false).html('<i class="bi bi-check-lg me-1"></i> Save Changes');
                        }
                    });
                }
            });

            // --- CHANGE PASSWORD FORM SUBMIT ---
            $("#changePasswordForm").validate({
                rules: {
                    currentPassword: {required: true},
                    newPassword: {required: true, minlength: 6},
                    confirmPassword: {required: true, equalTo: "#cp_new_pass"}
                },
                submitHandler: function (form) {
                    var $btn = $(form).find('.submit-btn');
                    $btn.prop('disabled', true).html('<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Updating...');
                    
                    $.ajax({
                        url: $(form).attr('action'), type: 'POST', data: $(form).serialize(), dataType: 'json',
                        success: function (data) {
                            if (data.isSuccess) {
                                showToast(data.description, 'success');
                                $('#changePasswordModal').modal('hide');
                                $(form)[0].reset();
                                $btn.prop('disabled', false).html('<i class="bi bi-check-lg me-1"></i> Update Password');
                            } else {
                                showToast(data.description, 'error');
                                $btn.prop('disabled', false).html('<i class="bi bi-check-lg me-1"></i> Update Password');
                            }
                        },
                        error: function () {
                            showToast('Server error occurred.', 'error');
                            $btn.prop('disabled', false).html('<i class="bi bi-check-lg me-1"></i> Update Password');
                        }
                    });
                }
            });
            
            // Reset form on close
            $('#changePasswordModal').on('hidden.bs.modal', function () {
                $("#changePasswordForm")[0].reset();
                $("#changePasswordForm").validate().resetForm();
            });
        });
    </script>
</body>
</html>