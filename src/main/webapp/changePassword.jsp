<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="DAO.OrderDAO"%>
<%@page import="entity.Orders"%>
<%@page import="java.util.List"%>
<%@page import="entity.Customer"%>

<%-- 1. Login Requirement --%>
<c:if test="${empty sessionScope.acc}">
    <c:redirect url="${pageContext.request.contextPath}/login.jsp"/>
</c:if>
<c:set var="acc" value="${sessionScope.acc}" />

<%
    // Logic lấy sidebar orders
    if (session.getAttribute("acc") != null) {
        Customer currentAcc = (Customer) session.getAttribute("acc");
        OrderDAO orderDAO = new OrderDAO();
        List<Orders> listOrders = orderDAO.orderUser(currentAcc.getCustomer_id());
        request.setAttribute("ordersUserList", listOrders);
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password | GIO</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href='https://fonts.googleapis.com/css?family=Quicksand:400,500,600,700&display=swap' rel='stylesheet'>
    <script src="https://kit.fontawesome.com/1bd876819f.js" crossorigin="anonymous"></script>
    <link rel="icon" href="${pageContext.request.contextPath}/images/LG2.png" type="image/x-icon">

    <style>
        :root { --primary-color: #a0816c; --primary-hover: #8c7362; --bg-overlay: rgba(255, 255, 255, 0.95); --glass-border: 1px solid rgba(255, 255, 255, 0.2); --shadow-soft: 0 10px 30px rgba(160, 129, 108, 0.15); --text-main: #5a5a5a; }
        
        body { font-family: 'Quicksand', sans-serif; background-image: url("${pageContext.request.contextPath}/images/BG2.jpeg"); background-size: cover; background-attachment: fixed; background-position: center; color: var(--text-main); min-height: 100vh; }
        
        /* Scrollbar custom */
        body::-webkit-scrollbar { width: 8px; }
        body::-webkit-scrollbar-track { background: #f1f1f1; }
        body::-webkit-scrollbar-thumb { background: var(--primary-color); border-radius: 4px; }

        .main-content-wrapper { max-width: 1140px; margin: 50px auto; padding: 0 15px; }
        
        /* === SIDEBAR STYLES === */
        .account-nav-card { background: var(--bg-overlay); backdrop-filter: blur(10px); border-radius: 15px; box-shadow: var(--shadow-soft); overflow: hidden; border: var(--glass-border); position: sticky; top: 150px; z-index: 90; }
        
        .account-user-mini { padding: 30px 20px; text-align: center; background: linear-gradient(135deg, var(--primary-color), #cbb4a3); color: white; }
        
        .avatar-circle { width: 80px; height: 80px; background: rgba(255,255,255,0.25); border-radius: 50%; margin: 0 auto 15px; display: flex; align-items: center; justify-content: center; font-size: 32px; border: 2px solid rgba(255,255,255,0.5); }
        
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
            justify-content: space-between;
        }
        
        .account-nav-link > div { display: flex; align-items: center; } 
        .account-nav-link i { margin-right: 15px; width: 20px; text-align: center; font-size: 1.1rem; }
        
        .account-nav-link:hover { background-color: #fff8f3; color: var(--primary-color); padding-left: 30px; }
        .account-nav-link.active { background-color: #fff8f3; color: var(--primary-color); border-left-color: var(--primary-color); }
        .badge-sidebar { background-color: #dc3545; color: white; border-radius: 50%; padding: 2px 8px; font-size: 0.8rem; }
        
        /* === MAIN PASSWORD CARD === */
        .password-card { background: var(--bg-overlay); border-radius: 15px; box-shadow: var(--shadow-soft); padding: 40px; position: relative; min-height: 400px; border: var(--glass-border); }
        .section-header { margin-bottom: 30px; padding-bottom: 15px; border-bottom: 2px solid #eee; }
        .section-header h4 { font-weight: 700; color: var(--primary-color); margin: 0; }
        
        /* Form Styles */
        .form-floating > .form-control:focus ~ label, .form-floating > .form-control:not(:placeholder-shown) ~ label { color: var(--primary-color); opacity: 0.8; }
        .form-control:focus { border-color: var(--primary-color); box-shadow: 0 0 0 0.25rem rgba(160, 129, 108, 0.25); }
        .form-control { border-radius: 8px; border: 1px solid #e0e0e0; padding-right: 45px; }
        
        /* Ẩn con mắt mặc định của trình duyệt */
        input::-ms-reveal, input::-ms-clear { display: none; }
        
        /* [QUAN TRỌNG] Xóa background icon (cả tích xanh và chấm than đỏ) để không đè lên nút mắt */
        .form-control.is-valid, 
        .form-control.is-invalid { 
            background-image: none !important; 
        }
        
        /* Giữ viền xanh khi đúng, đỏ khi sai (tùy chọn, nếu muốn bỏ thì set border-color về mặc định) */
        .form-control.is-valid { border-color: var(--primary-color); }
        /* .form-control.is-invalid { border-color: #dc3545; } (Mặc định bootstrap đã có màu đỏ) */

        .password-input-wrapper { position: relative; margin-bottom: 25px; }
        .toggle-password { position: absolute; top: 28px; right: 15px; transform: translateY(-50%); cursor: pointer; color: #999; z-index: 10; transition: color 0.3s; }
        .toggle-password:hover { color: var(--primary-color); }
        
        .btn-custom-primary { background-color: var(--primary-color); color: #fff; border: none; padding: 12px 30px; border-radius: 8px; font-weight: 700; width: 100%; transition: all 0.3s; margin-top: 15px; }
        .btn-custom-primary:hover { background-color: var(--primary-hover); transform: translateY(-2px); box-shadow: 0 5px 15px rgba(160, 129, 108, 0.3); }
        
        .alert-custom { display: none; margin-bottom: 20px; border-radius: 8px; font-weight: 500; font-size: 0.95rem; }
        
        .loading-overlay { position: absolute; inset: 0; background: rgba(255,255,255,0.8); z-index: 50; border-radius: 15px; display: flex; justify-content: center; align-items: center; opacity: 0; pointer-events: none; transition: opacity 0.3s; }
        .loading-overlay.active { opacity: 1; pointer-events: all; }
        .spinner-border { color: var(--primary-color); width: 3rem; height: 3rem; }
        
        /* Định vị lại label error */
        label.error { 
            color: #dc3545; 
            font-size: 0.85rem; 
            margin-top: 5px; 
            display: block; 
            text-align: left; 
            width: 100%;
            position: relative;
        }
        
        .security-notice {
            background-color: #fff8f3;
            border-left: 4px solid var(--primary-color);
            padding: 15px;
            border-radius: 4px;
            font-size: 0.95rem;
            color: #666;
            margin-bottom: 25px;
        }
        
        #step2-change { display: none; }
    </style>
</head>

<body>
    
    <%@ include file="header.jsp" %>

    <main class="main-content-wrapper">
        <%-- Logic tính toán Badge --%>
        <c:set var="countPending" value="0" />
        <c:set var="countDelivering" value="0" />
        <c:set var="countDelivered" value="0" />
        <c:set var="countCancelled" value="0" />
        <c:if test="${not empty requestScope.ordersUserList}">
            <c:forEach items="${requestScope.ordersUserList}" var="o">
                <c:if test="${o.status eq 'Pending'}"><c:set var="countPending" value="${countPending + 1}" /></c:if>
                <c:if test="${o.status eq 'Delivering'}"><c:set var="countDelivering" value="${countDelivering + 1}" /></c:if>
                <c:if test="${o.status eq 'Delivered' || o.status eq 'Completed'}"><c:set var="countDelivered" value="${countDelivered + 1}" /></c:if>
                <c:if test="${o.status eq 'Cancelled'}"><c:set var="countCancelled" value="${countCancelled + 1}" /></c:if>
            </c:forEach>
        </c:if>
        <c:set var="totalActive" value="${countPending + countDelivering}" />

        <div class="row g-4">
            <%-- === SIDEBAR === --%>
            <div class="col-lg-4 col-md-5">
                <div class="account-nav-card">
                    <div class="account-user-mini">
                        <div class="avatar-circle"><i class="fa-solid fa-user"></i></div>
                        <h5 class="mb-1 fw-bold text-white">${acc.username}</h5>
                        <small class="text-white-50">Member</small>
                    </div>
                    <ul class="account-nav">
                        <li>
                            <a href="${pageContext.request.contextPath}/profile" class="account-nav-link">
                                <div><i class="fa-solid fa-user-circle"></i> My Profile</div>
                            </a>
                        </li>
                        
                        <c:if test="${empty acc.google_id}">
                            <li>
                                <a href="${pageContext.request.contextPath}/changePassword.jsp" class="account-nav-link active">
                                    <div><i class="fa-solid fa-key"></i> Change Password</div>
                                </a>
                            </li>
                        </c:if>
                        
                        <li>
                            <a href="${pageContext.request.contextPath}/orderView" class="account-nav-link">
                                <div><i class="fa-solid fa-box"></i> My Orders</div>
                                <c:if test="${totalActive > 0}"><span class="badge-sidebar">${totalActive}</span></c:if>
                            </a>
                        </li>
                        
                        <li>
                            <a href="${pageContext.request.contextPath}/orderHistoryView" class="account-nav-link">
                                <div><i class="fa-solid fa-clock-rotate-left"></i> Order History</div>
                            </a>
                        </li>
                        
                        <li>
                            <a href="${pageContext.request.contextPath}/cookieHandle" class="account-nav-link text-danger" onclick="return confirm('Do you want to sign out?')">
                                <div><i class="fa-solid fa-right-from-bracket"></i> Sign Out</div>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>

            <%-- === MAIN CONTENT === --%>
            <div class="col-lg-8 col-md-7">
                <div class="password-card">
                    
                    <div class="loading-overlay" id="loading-overlay">
                        <div class="spinner-border" role="status"><span class="visually-hidden">Loading...</span></div>
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
                    
                    <div class="alert alert-info alert-custom" id="verify-success-alert" role="alert">
                        <i class="fa-solid fa-shield-halved me-2"></i> Current password verified! Please enter your new password.
                    </div>

                    <form id="change-password-form">
                        
                        <%-- STEP 1: VERIFY CURRENT PASSWORD --%>
                        <div id="step1-verify">
                            <div class="security-notice">
                                <i class="fa-solid fa-shield-halved me-2"></i>
                                To enhance the security of your account, please verify it by your current password.
                            </div>

                            <div class="password-input-wrapper">
                                <div class="form-floating">
                                    <input type="password" class="form-control" id="currentPassword" name="currentPassword" placeholder="Current Password">
                                    <label for="currentPassword">Current Password</label>
                                </div>
                                <span class="toggle-password" onclick="togglePassword('currentPassword', this)"><i class="fa-regular fa-eye"></i></span>
                            </div>

                            <div class="mt-4">
                                <button type="button" id="btn-verify" class="btn-custom-primary">Verify & Continue</button>
                            </div>
                        </div>

                        <%-- STEP 2: NEW PASSWORD --%>
                        <div id="step2-change">
                            
                            <div class="password-input-wrapper">
                                <div class="form-floating">
                                    <input type="password" class="form-control" id="newPassword1" name="newPassword1" placeholder="New Password">
                                    <label for="newPassword1">New Password</label>
                                </div>
                                <span class="toggle-password" onclick="togglePassword('newPassword1', this)"><i class="fa-regular fa-eye"></i></span>
                            </div>

                            <div class="password-input-wrapper">
                                <div class="form-floating">
                                    <input type="password" class="form-control" id="newPassword2" name="newPassword2" placeholder="Confirm New Password">
                                    <label for="newPassword2">Confirm New Password</label>
                                </div>
                                <span class="toggle-password" onclick="togglePassword('newPassword2', this)"><i class="fa-regular fa-eye"></i></span>
                            </div>

                            <div class="mt-4">
                                <button type="submit" class="btn-custom-primary">Change Password</button>
                            </div>
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
            const $verifySuccessAlert = $('#verify-success-alert'); 
            const $errorMsg = $('#error-msg');
            const $step1 = $('#step1-verify');
            const $step2 = $('#step2-change');

            $.validator.addMethod("strongPassword", function(value, element) {
                return this.optional(element) || /^(?=.*[A-Z])(?=.*[!@#$%^&*(),.?":{}|<>]).{8,24}$/.test(value);
            }, "Password must be 8-24 chars, contain at least 1 uppercase letter and 1 special character.");

            $.validator.addMethod("notEqual", function(value, element, param) {
                return this.optional(element) || value !== $(param).val();
            }, "New password must be different from current password.");

            $form.validate({
                errorClass: "error", 
                validClass: "is-valid", 
                errorElement: "label",
                rules: {
                    currentPassword: { required: true },
                    newPassword1: { required: true, strongPassword: true, notEqual: "#currentPassword" },
                    newPassword2: { required: true, equalTo: "#newPassword1" }
                },
                messages: {
                    currentPassword: { required: "Please enter your current password." },
                    newPassword1: { required: "Please enter a new password." },
                    newPassword2: { required: "Please confirm your new password.", equalTo: "Passwords do not match." }
                },
                errorPlacement: function(error, element) {
                    error.appendTo(element.closest(".password-input-wrapper"));
                },
                highlight: function(element) { 
                    $(element).addClass("is-invalid").removeClass("is-valid"); 
                },
                unhighlight: function(element) {
                    if ($(element).attr('id') === 'currentPassword') {
                        $(element).removeClass("is-invalid");
                    } else {
                        $(element).removeClass("is-invalid").addClass("is-valid");
                    }
                }
            });

            // === STEP 1: XỬ LÝ NÚT VERIFY ===
            $('#btn-verify').click(function() {
                if ($('#currentPassword').valid()) {
                    $loading.addClass('active');
                    $errorAlert.slideUp();
                    $verifySuccessAlert.slideUp();

                    $.ajax({
                        type: "POST",
                        url: "${pageContext.request.contextPath}/changePassword",
                        data: {
                            action: "verify",
                            currentPassword: $('#currentPassword').val()
                        },
                        success: function(response) {
                            $loading.removeClass('active');
                            if (response.isSuccess) {
                                $step1.slideUp(400, function(){
                                    $verifySuccessAlert.slideDown(); 
                                    $step2.slideDown();
                                });
                            } else {
                                $errorMsg.text(response.description || "Incorrect current password.");
                                $errorAlert.slideDown();
                            }
                        },
                        error: function(xhr, status, error) {
                            $loading.removeClass('active');
                            $errorMsg.text("Server error occurred.");
                            $errorAlert.slideDown();
                        }
                    });
                }
            });

            // === STEP 2: SUBMIT FORM (CHANGE PASSWORD) ===
            $form.on('submit', function(e) {
                e.preventDefault();
                let isValid = $('#newPassword1').valid() && $('#newPassword2').valid();

                if (isValid) {
                    $loading.addClass('active');
                    $errorAlert.slideUp();
                    $successAlert.slideUp();
                    $verifySuccessAlert.slideUp();

                    $.ajax({
                        type: "POST",
                        url: "${pageContext.request.contextPath}/changePassword",
                        data: {
                            action: "change",
                            newPassword: $('#newPassword1').val()
                        },
                        success: function(response) {
                            $loading.removeClass('active');
                            if (response.isSuccess) {
                                $successAlert.slideDown();
                                $step2.slideUp();
                                $form[0].reset();
                                
                                $form.find('.is-valid').removeClass('is-valid');
                                $form.find('.is-invalid').removeClass('is-invalid');
                                
                                setTimeout(function() {
                                    $successAlert.slideUp();
                                    $step1.slideDown();
                                }, 3000);
                            } else {
                                $errorMsg.text(response.description || "Update failed.");
                                $errorAlert.slideDown();
                            }
                        },
                        error: function() {
                            $loading.removeClass('active');
                            $errorMsg.text("Server connection error.");
                            $errorAlert.slideDown();
                        }
                    });
                }
            });
        });
    </script>
</body>
</html>