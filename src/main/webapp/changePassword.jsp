<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 1. Login Requirement --%>
<c:if test="${empty sessionScope.acc}">
    <c:redirect url="${pageContext.request.contextPath}/login.jsp"/>
</c:if>
<c:set var="acc" value="${sessionScope.acc}" />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password | GIO</title>
    
    <%-- Bootstrap CSS --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <%-- Bootstrap Icons --%>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <%-- Font Family --%>
    <link href='https://fonts.googleapis.com/css?family=Quicksand:400,500,600,700&display=swap' rel='stylesheet'>
    <%-- Font-Awesome --%>
    <script src="https://kit.fontawesome.com/1bd876819f.js" crossorigin="anonymous"></script>

    <link rel="icon" href="${pageContext.request.contextPath}/images/LG2.png" type="image/x-icon">

    <style>
        :root {
            --primary-color: #a0816c;
            --primary-hover: #8c7362;
            --bg-overlay: rgba(255, 255, 255, 0.95);
            --glass-border: 1px solid rgba(255, 255, 255, 0.2);
            --shadow-soft: 0 10px 30px rgba(160, 129, 108, 0.15);
            --text-main: #5a5a5a;
        }

        body {
            font-family: 'Quicksand', sans-serif;
            background-image: url("${pageContext.request.contextPath}/images/BG2.jpeg");
            background-size: cover;
            background-attachment: fixed;
            background-position: center;
            color: var(--text-main);
            min-height: 100vh;
        }

        /* Scrollbar custom */
        body::-webkit-scrollbar { width: 8px; }
        body::-webkit-scrollbar-track { background: #f1f1f1; }
        body::-webkit-scrollbar-thumb { background: var(--primary-color); border-radius: 4px; }

        .main-content-wrapper {
            max-width: 1140px;
            margin: 50px auto;
            padding: 0 15px;
        }

        .page-header {
            text-align: center;
            margin-bottom: 40px;
            color: #fff;
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }
        .page-header h2 { font-weight: 700; letter-spacing: 1px; }

        /* === SIDEBAR (GIỐNG PROFILE) === */
        .account-nav-card {
            background: var(--bg-overlay);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            box-shadow: var(--shadow-soft);
            overflow: hidden;
            border: var(--glass-border);
        }

        .account-user-mini {
            padding: 30px 20px;
            text-align: center;
            background: linear-gradient(135deg, var(--primary-color), #cbb4a3);
            color: white;
        }
        
        .avatar-circle {
            width: 80px;
            height: 80px;
            background: rgba(255,255,255,0.25);
            border-radius: 50%;
            margin: 0 auto 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            border: 2px solid rgba(255,255,255,0.5);
        }

        .account-nav { padding: 10px 0; margin: 0; list-style: none; }

        .account-nav-link {
            display: flex;
            align-items: center;
            padding: 15px 25px;
            color: var(--text-main);
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            border-left: 4px solid transparent;
        }

        .account-nav-link i { margin-right: 15px; width: 20px; text-align: center; font-size: 1.1rem; }
        
        .account-nav-link:hover {
            background-color: #fff8f3;
            color: var(--primary-color);
            padding-left: 30px;
        }

        .account-nav-link.active {
            background-color: #fff8f3;
            color: var(--primary-color);
            border-left-color: var(--primary-color);
        }

        /* === CHANGE PASSWORD CONTENT === */
        .password-card {
            background: var(--bg-overlay);
            border-radius: 15px;
            box-shadow: var(--shadow-soft);
            padding: 40px;
            position: relative;
            min-height: 400px;
            border: var(--glass-border);
        }

        .section-header {
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 2px solid #eee;
        }

        .section-header h4 {
            font-weight: 700;
            color: var(--primary-color);
            margin: 0;
        }

        /* Form Styling */
        .form-floating > .form-control:focus ~ label,
        .form-floating > .form-control:not(:placeholder-shown) ~ label {
            color: var(--primary-color);
            opacity: 0.8;
        }
        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.25rem rgba(160, 129, 108, 0.25);
        }
        .form-control { border-radius: 8px; border: 1px solid #e0e0e0; padding-right: 45px; } /* Space for eye icon */

        .password-input-wrapper { position: relative; }
        
        .toggle-password {
            position: absolute;
            top: 50%;
            right: 15px;
            transform: translateY(-50%);
            cursor: pointer;
            color: #999;
            z-index: 10;
            transition: color 0.3s;
        }
        .toggle-password:hover { color: var(--primary-color); }

        .btn-custom-primary {
            background-color: var(--primary-color);
            color: #fff;
            border: none;
            padding: 12px 30px;
            border-radius: 8px;
            font-weight: 700;
            width: 100%;
            transition: all 0.3s;
            margin-top: 15px;
        }
        .btn-custom-primary:hover {
            background-color: var(--primary-hover);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(160, 129, 108, 0.3);
        }

        /* Alerts */
        .alert-custom { display: none; margin-bottom: 20px; border-radius: 8px; font-weight: 500; font-size: 0.95rem; }

        /* Loading Overlay */
        .loading-overlay {
            position: absolute; inset: 0; background: rgba(255,255,255,0.8);
            z-index: 50; border-radius: 15px;
            display: flex; justify-content: center; align-items: center;
            opacity: 0; pointer-events: none; transition: opacity 0.3s;
        }
        .loading-overlay.active { opacity: 1; pointer-events: all; }
        .spinner-border { color: var(--primary-color); width: 3rem; height: 3rem; }

        /* Validation Error */
        label.error { color: #dc3545; font-size: 0.85rem; margin-top: 5px; display: block; text-align: left; }

    </style>
</head>

<body>
    
    <%@ include file="header.jsp" %>

    <main class="main-content-wrapper">

        <div class="row g-4">
            
            <%-- === CỘT TRÁI: NAVIGATION === --%>
            <div class="col-lg-4 col-md-5">
                <div class="account-nav-card">
                    <div class="account-user-mini">
                        <div class="avatar-circle">
                            <i class="fa-solid fa-user"></i>
                        </div>
                        <h5 class="mb-1 fw-bold text-white">${acc.username}</h5>
                        <small class="text-white-50">Member</small>
                    </div>
                    <ul class="account-nav">
                        <li><a href="${pageContext.request.contextPath}/profile" class="account-nav-link"><i class="fa-solid fa-user-circle"></i> My Profile</a></li>
                        <li><a href="${pageContext.request.contextPath}/changePassword.jsp" class="account-nav-link active"><i class="fa-solid fa-key"></i> Change Password</a></li>
                        <li><a href="${pageContext.request.contextPath}/orderView" class="account-nav-link"><i class="fa-solid fa-box"></i> My Orders</a></li>
                        <li><a href="${pageContext.request.contextPath}/orderHistoryView" class="account-nav-link"><i class="fa-solid fa-clock-rotate-left"></i> Order History</a></li>
                        <li><a href="${pageContext.request.contextPath}/cookieHandle" class="account-nav-link text-danger" onclick="return confirm('Do you want to sign out?')"><i class="fa-solid fa-right-from-bracket"></i> Sign Out</a></li>
                    </ul>
                </div>
            </div>

            <%-- === CỘT PHẢI: CHANGE PASSWORD CONTENT === --%>
            <div class="col-lg-8 col-md-7">
                <div class="password-card">
                    
                    <%-- Loading Overlay --%>
                    <div class="loading-overlay" id="loading-overlay">
                        <div class="spinner-border" role="status">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                    </div>

                    <div class="section-header">
                        <h4>Change Password</h4>
                    </div>

                    <div class="alert alert-danger alert-custom" id="error-alert" role="alert">
                        <i class="fa-solid fa-circle-exclamation me-2"></i> <span id="error-msg"></span>
                    </div>
                    
                    <div class="alert alert-success alert-custom" id="success-alert" role="alert">
                        <i class="fa-solid fa-circle-check me-2"></i> Password changed successfully!
                    </div>

                    <form id="change-password-form">
                        
                        <%-- Current Password --%>
                        <div class="mb-4 password-input-wrapper">
                            <div class="form-floating">
                                <input type="password" class="form-control" id="currentPassword" name="currentPassword" placeholder="Current Password" required>
                                <label for="currentPassword">Current Password</label>
                            </div>
                            <span class="toggle-password" onclick="togglePassword('currentPassword', this)">
                                <i class="fa-regular fa-eye"></i>
                            </span>
                        </div>

                        <%-- New Password --%>
                        <div class="mb-4 password-input-wrapper">
                            <div class="form-floating">
                                <input type="password" class="form-control" id="newPassword1" name="newPassword1" placeholder="New Password" required minlength="6">
                                <label for="newPassword1">New Password</label>
                            </div>
                            <span class="toggle-password" onclick="togglePassword('newPassword1', this)">
                                <i class="fa-regular fa-eye"></i>
                            </span>
                        </div>

                        <%-- Confirm Password --%>
                        <div class="mb-4 password-input-wrapper">
                            <div class="form-floating">
                                <input type="password" class="form-control" id="newPassword2" name="newPassword2" placeholder="Confirm New Password" required>
                                <label for="newPassword2">Confirm New Password</label>
                            </div>
                            <span class="toggle-password" onclick="togglePassword('newPassword2', this)">
                                <i class="fa-regular fa-eye"></i>
                            </span>
                        </div>

                        <div class="mt-4">
                            <button type="submit" class="btn-custom-primary">
                                Change Password
                            </button>
                        </div>

                    </form>
                </div>
            </div>
        </div>
    </main>

    <%@ include file="footer.jsp" %>
    
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.5/dist/jquery.validate.min.js"></script>

    <script>
        // Toggle Show/Hide Password
        function togglePassword(fieldId, iconElement) {
            const input = document.getElementById(fieldId);
            const icon = iconElement.querySelector('i');
            
            if (input.type === "password") {
                input.type = "text";
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                input.type = "password";
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }

        $(document).ready(function() {
            const $form = $('#change-password-form');
            const $loading = $('#loading-overlay');
            const $errorAlert = $('#error-alert');
            const $successAlert = $('#success-alert');
            const $errorMsg = $('#error-msg');

            // Custom Validation Rules
            $.validator.addMethod("notEqual", function(value, element, param) {
                return this.optional(element) || value !== $(param).val();
            }, "New password must be different from current password.");

            $form.validate({
                errorClass: "error",
                validClass: "is-valid",
                errorElement: "label",
                rules: {
                    currentPassword: { required: true },
                    newPassword1: { 
                        required: true, 
                        minlength: 6,
                        notEqual: "#currentPassword" // Không được trùng mk cũ
                    },
                    newPassword2: { 
                        required: true, 
                        equalTo: "#newPassword1" // Phải trùng mk mới
                    }
                },
                messages: {
                    currentPassword: { required: "Please enter your current password." },
                    newPassword1: { 
                        required: "Please enter a new password.",
                        minlength: "Password must be at least 6 characters long.",
                        notEqual: "New password cannot be the same as the old password."
                    },
                    newPassword2: { 
                        required: "Please confirm your new password.",
                        equalTo: "Passwords do not match." 
                    }
                },
                highlight: function(element) {
                    $(element).addClass("is-invalid").removeClass("is-valid");
                },
                unhighlight: function(element) {
                    $(element).removeClass("is-invalid").addClass("is-valid");
                },
                
                // AJAX Submit Handling
                submitHandler: function(form) {
                    $loading.addClass('active');
                    $errorAlert.slideUp();
                    $successAlert.slideUp();

                    $.ajax({
                        type: "POST", // Hoặc "GET" tùy vào Controller của bạn
                        url: "${pageContext.request.contextPath}/changePassword", // Đảm bảo URL này đúng
                        data: $form.serialize(),
                        success: function(response) {
                            $loading.removeClass('active');
                            
                            // Giả sử server trả về String hoặc JSON. 
                            // Bạn cần điều chỉnh logic if/else này dựa trên phản hồi thực tế của Controller.
                            // Ví dụ: response có thể là "Success" hoặc "Incorrect password"
                            
                            if (response.trim().toLowerCase() === "success" || response.status === true) {
                                $successAlert.slideDown();
                                $form[0].reset();
                                $form.find('.is-valid').removeClass('is-valid'); // Reset trạng thái xanh
                            } else {
                                // Hiển thị lỗi từ server trả về
                                $errorMsg.text(response.message || response || "Incorrect current password.");
                                $errorAlert.slideDown();
                            }
                        },
                        error: function() {
                            $loading.removeClass('active');
                            $errorMsg.text("An error occurred connecting to the server. Please try again.");
                            $errorAlert.slideDown();
                        }
                    });
                }
            });
        });
    </script>
</body>
</html>