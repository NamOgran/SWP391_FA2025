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

            /* CSS riêng cho Personal Info */
            .personal-main {
                width: 60%;
                margin: 30px auto;
                box-shadow: rgba(0, 0, 0, 0.15) 0px 5px 15px 0px;
                border: 1px solid #ddd;
                border-radius: 8px;
                overflow: hidden;
            }
            .personal-main table {
                width: 100%;
                border-collapse: collapse;
            }
            .personal-main table th, .personal-main table td {
                padding: 12px 15px;
                text-align: left;
                border-bottom: 1px solid #eee;
            }
            .personal-main table th {
                width: 30%;
                background-color: #f8f9fa;
                font-weight: 600;
                color: #555;
            }
            .personal-main table tr:last-child th, .personal-main table tr:last-child td {
                border-bottom: none;
            }
            .personal-main button {
                margin: 20px 10px 20px 15px;
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
            .admin-form-modal input.error, .admin-form-modal select.error, .admin-form-modal textarea.error {
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
            .admin-form-modal-blue .header h1, .admin-form-modal-blue .form-group label, .admin-form-modal-blue .input-icon i {
                color: #0d6efd;
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
            .admin-form-modal-yellow .header h1, .admin-form-modal-yellow .form-group label, .admin-form-modal-yellow .input-icon i {
                color: #ffc107;
            }
            .admin-form-modal-yellow .form-group input:focus, .admin-form-modal-yellow .form-group select:focus, .admin-form-modal-yellow .form-group textarea:focus {
                border-color: #ffc107;
                box-shadow: 0 0 0 3px rgba(255, 193, 7, 0.2);
            }
            .admin-form-modal-yellow .submit-btn {
                background: linear-gradient(135deg, #ffc107 0%, #e0a800 100%);
                color: #212529;
            }
            .admin-form-modal-yellow .submit-btn:hover {
                background: linear-gradient(135deg, #e0a800 0%, #ffc107 100%);
                box-shadow: 0 10px 20px rgba(255, 193, 7, 0.3);
                color: #212529;
            }
        </style>
    </head>

    <body>

        <c:if test="${param.msg == 'profile_updated'}">
            <div id="toast-message" class="toast-notification toast-info active">
                <i class="fas fa-user-edit"></i> Your profile has been updated!
            </div>
        </c:if>
        <c:if test="${param.msg == 'pass_changed'}">
            <div id="toast-message" class="toast-notification toast-success active">
                <i class="fas fa-check-circle"></i> Password changed successfully!
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
                    <li class="nav-link" data-target="account-manage">
                        <a href="${BASE_URL}/admin?tab=account" ><i class="bi bi-person-badge-fill"></i> <span>Account management</span> </a>
                    </li>
                    <li class="nav-link" data-target="promo-manage">
                        <a href="${BASE_URL}/admin?tab=promo" ><i class="bi bi-tags-fill"></i> <span>Promo Management</span> </a>
                    </li>
                    <li class="nav-link active" data-target="personal-info"> <a href="${BASE_URL}/admin?tab=personal" ><i class="bi bi-person-fill"></i> <span>Personal information</span> </a>
                    </li>
                </ul>
            </nav>

            <div class="main-content">

                <div class="personal-info" style="display: block;">
                    <h3 style="font-weight: bold;"><i class="bi bi-person-fill"></i> Personal Information</h3>
                    <hr>
                    <div class="personal-main">
                        <table>
                            <tr><th>Fullname:</th><td id="info-fullname"><c:out value="${sessionScope.staff.fullName}"/></td></tr>
                            <tr><th>Phone:</th><td id="info-phone"><c:out value="${sessionScope.staff.phoneNumber}"/></td></tr>
                            <tr><th>Email:</th><td id="info-email"><c:out value="${sessionScope.staff.email}"/></td></tr>
                            <tr><th>Address:</th><td id="info-address"><c:out value="${sessionScope.staff.address}"/></td></tr>
                            <tr><th>Username:</th><td id="info-username"><c:out value="${sessionScope.staff.username}"/></td></tr>
                            <tr><th>Role:</th><td><c:out value="${sessionScope.staff.role}"/></td></tr>
                        </table>
                        <button type="button" class="btn btn-primary mt-3" data-bs-toggle="modal" data-bs-target="#editProfileModal">
                            <i class="fas fa-user-edit"></i> Edit Profile
                        </button> 
                        <button type="button" class="btn btn-warning mt-3" data-bs-toggle="modal" data-bs-target="#changePasswordModal">
                            <i class="fas fa-key"></i> Change Password
                        </button> 
                    </div>
                </div>
            </div>
        </div>


        <div class="modal fade admin-form-modal admin-form-modal-blue" id="editProfileModal" tabindex="-1" aria-labelledby="editProfileModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <button type="button" class="btn-close-custom" data-bs-dismiss="modal" aria-label="Close"><i class="fas fa-times"></i></button>
                    <div class="header">
                        <h1><i class="fas fa-user-edit"></i> Edit Profile</h1>
                    </div>
                    <form action="${BASE_URL}/staff/profile/update" method="POST" id="editProfileForm">
                        <div class="form-row">
                            <div class="form-group">
                                <label for="edit_fullName"><i class="fas fa-user"></i> Fullname</label>
                                <div class="input-icon">
                                    <i class="fas fa-user"></i>
                                    <input type="text" id="edit_fullName" name="fullName" value="<c:out value='${sessionScope.staff.fullName}'/>" required>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="edit_phone"><i class="fas fa-phone"></i> Phone</label>
                                <div class="input-icon">
                                    <i class="fas fa-phone"></i>
                                    <input type="text" id="edit_phone" name="phone" value="<c:out value='${sessionScope.staff.phoneNumber}'/>" required>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit_email"><i class="fas fa-envelope"></i> Email</label>
                            <div class="input-icon">
                                <i class="fas fa-envelope"></i>
                                <input type="email" id="edit_email" name="email" value="<c:out value='${sessionScope.staff.email}'/>" required>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit_address"><i class="fas fa-map-marker-alt"></i> Address</label>
                            <div class="input-icon">
                                <i class="fas fa-map-marker-alt"></i>
                                <input type="text" id="edit_address" name="address" value="<c:out value='${sessionScope.staff.address}'/>" required>
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="edit_username"><i class="fas fa-user-shield"></i> Username</label>
                                <div class="input-icon">
                                    <i class="fas fa-user-shield"></i>
                                    <input type="text" id="edit_username" name="username" value="<c:out value='${sessionScope.staff.username}'/>" 
                                           readonly style="font-weight: bold; background-color: #e9ecef;">
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="edit_role"><i class="fas fa-user-tag"></i> Role</label>
                                <div class="input-icon">
                                    <i class="fas fa-user-tag"></i>
                                    <input type="text" id="edit_role" name="role" value="<c:out value='${sessionScope.staff.role}'/>" 
                                           readonly style="font-weight: bold; background-color: #e9ecef;">
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

        <div class="modal fade admin-form-modal admin-form-modal-yellow" id="changePasswordModal" tabindex="-1" aria-labelledby="changePasswordModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <button type="button" class="btn-close-custom" data-bs-dismiss="modal" aria-label="Close"><i class="fas fa-times"></i></button>
                    <div class="header">
                        <h1><i class="fas fa-key"></i> Change Password</h1>
                    </div>
                    <form action="${BASE_URL}/staff/profile/changepass" method="POST" id="changePasswordForm">
                        <div class="form-group">
                            <label for="cp_username"><i class="fas fa-user-shield"></i> Username</label>
                            <div class="input-icon">
                                <i class="fas fa-user-shield"></i>
                                <input type="text" id="cp_username" name="input" value="<c:out value='${sessionScope.staff.username}'/>" 
                                       readonly style="font-weight: bold; background-color: #e9ecef;">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="cp_old_pass"><i class="fas fa-lock"></i> Old Password</label>
                            <div class="input-icon">
                                <i class="fas fa-lock"></i>
                                <input type="password" id="cp_old_pass" name="currentPassword" required placeholder="Enter your current password">
                            </div>
                            <label id="cp_old_pass_error" class="error" style="display: none;"></label>
                        </div>
                        <div class="form-group">
                            <label for="cp_new_pass"><i class="fas fa-key"></i> Create New Password</label>
                            <div class="input-icon">
                                <i class="fas fa-key"></i>
                                <input type="password" id="cp_new_pass" name="newPassword" required placeholder="Enter a new password">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="cp_confirm_pass"><i class="fas fa-check-circle"></i> Confirm New Password</label>
                            <div class="input-icon">
                                <i class="fas fa-check-circle"></i>
                                <input type="password" id="cp_confirm_pass" name="confirmPassword" required placeholder="Confirm your new password">
                            </div>
                        </div>
                        <button type="submit" class="submit-btn">
                            <i class="fas fa-exchange-alt"></i> Change Password
                        </button>
                    </form>
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

                // === SỬA ĐỔI JAVASCRIPT ĐIỀU HƯỚNG ===
                const navLinks = document.querySelectorAll('.nav-link');
                const currentTarget = 'personal-info'; // Tab này là 'personal-info'

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
                // === KẾT THÚC SỬA ĐỔI ===

                // === VALIDATION CHO EDIT PROFILE ===
                $("#editProfileForm").validate({
                    rules: {
                        fullName: {required: true, validFullname: true},
                        phone: {required: true, validPhone: true},
                        email: {required: true, email: true, minlength: 5, maxlength: 100},
                        address: {required: true, maxlength: 255}
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
                        $btn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Saving...');
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
                                    // Cập nhật thông tin trên trang
                                    $('#info-fullname').text(newFullName);
                                    $('#info-phone').text(newPhone);
                                    $('#info-email').text(newEmail);
                                    $('#info-address').text(newAddress);

                                    // Cập nhật giá trị mặc định trong modal (cho lần mở sau)
                                    $('#edit_fullName').val(newFullName);
                                    $('#edit_phone').val(newPhone);
                                    $('#edit_email').val(newEmail);
                                    $('#edit_address').val(newAddress);

                                    $('#editProfileModal').modal('hide');

                                    // Hiển thị toast (vì trang không tải lại)
                                    var toastHTML = '<div id="toast-message" class="toast-notification toast-info active">' +
                                            '<i class="fas fa-user-edit"></i> Your profile has been updated!</div>';
                                    $('body').append(toastHTML);
                                    setTimeout(function () {
                                        $('#toast-message').remove();
                                    }, 4000);
                                } else {
                                    alert('Error updating profile: ' + (data.description || 'Email may already exist.'));
                                }
                                $btn.prop('disabled', false).html('<i class="fas fa-save"></i> Save Changes');
                            },
                            error: function () {
                                alert('Server error. Could not update profile.');
                                $btn.prop('disabled', false).html('<i class="fas fa-save"></i> Save Changes');
                            }
                        });
                    }
                });

                // === VALIDATION CHO CHANGE PASSWORD ===
                $('#cp_old_pass').on('keyup', function () {
                    $('#cp_old_pass_error').hide();
                });

                var changePasswordModal = document.getElementById('changePasswordModal');
                if (changePasswordModal) {
                    changePasswordModal.addEventListener('show.bs.modal', function (event) {
                        var validator = $("#changePasswordForm").validate();
                        validator.resetForm();
                        $('#changePasswordForm')[0].reset();
                        $('#cp_old_pass_error').hide().text('');
                        $('#cp_username').val('${sessionScope.staff.username}');
                    });
                }

                $("#changePasswordForm").validate({
                    rules: {
                        currentPassword: {required: true},
                        newPassword: {required: true, minlength: 6},
                        confirmPassword: {required: true, equalTo: "#cp_new_pass"}
                    },
                    messages: {
                        currentPassword: "Please enter your current password",
                        newPassword: {
                            required: "Please provide a new password",
                            minlength: "Password must be at least 6 characters"
                        },
                        confirmPassword: {
                            required: "Please confirm the new password",
                            equalTo: "Passwords do not match"
                        }
                    },
                    errorElement: "label",
                    errorClass: "error",
                    errorPlacement: function (error, element) {
                        if (element.attr("name") == "currentPassword") {
                            // Hiển thị lỗi này trong thẻ label tùy chỉnh
                            $('#cp_old_pass_error').html(error).show();
                        } else {
                            error.insertAfter(element.closest('.input-icon'));
                        }
                    },
                    submitHandler: function (form) {
                        var $form = $(form);
                        var $btn = $form.find('.submit-btn');
                        $btn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Changing...');
                        $('#cp_old_pass_error').hide();

                        $.ajax({
                            url: $form.attr('action'),
                            type: 'POST',
                            data: $form.serialize(),
                            dataType: 'json',
                            success: function (data) {
                                if (data.isSuccess) {
                                    // SỬA ĐỔI: Chuyển hướng với thông báo
                                    window.location.href = "${BASE_URL}/admin?tab=personal&msg=pass_changed";
                                } else {
                                    $('#cp_old_pass_error').text('Wrong old password!').show();
                                    $btn.prop('disabled', false).html('<i class="fas fa-exchange-alt"></i> Change Password');
                                    $('#cp_old_pass').val('').focus();
                                }
                            },
                            error: function () {
                                alert('Server error. Could not change password.');
                                $btn.prop('disabled', false).html('<i class="fas fa-exchange-alt"></i> Change Password');
                            }
                        });
                    }
                });

            });
        </script>

    </body>

</html>