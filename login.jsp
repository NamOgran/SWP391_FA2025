<%-- 
    Document    : login.jsp
    Updated     : Toast Position Fixed (Top-Right)
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login | GIO</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

        <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">

        <link href='https://fonts.googleapis.com/css?family=Quicksand:300,400,500,600,700&display=swap' rel='stylesheet'>
        <link rel="icon" href="${pageContext.request.contextPath}/images/LG2.png" type="image/x-icon">

        <style>
            :root {
                --primary-color: #a0816c;
                --primary-hover: #8a6d5a;
                --text-dark: #333;
                --text-muted: #666;
                --border-color: #e0e0e0;
            }

            body {
                font-family: 'Quicksand', sans-serif;
                background-color: #fff;
                height: 100vh;
                overflow: hidden;
            }

            /* --- LAYOUT --- */
            .login-wrapper {
                height: 100vh;
                width: 100%;
            }

            /* LEFT SIDE - IMAGE */
            .login-image-side {
                background-image: url('${pageContext.request.contextPath}/images/BG2.jpeg');
                background-size: cover;
                background-position: center;
                position: relative;
                height: 100%;
            }
            .login-image-side::before {
                content: '';
                position: absolute;
                inset: 0;
                background: rgba(0,0,0,0.3);
            }
            .brand-caption {
                position: absolute;
                bottom: 50px;
                left: 50px;
                color: #fff;
                z-index: 2;
            }
            .brand-caption h1 {
                font-weight: 700;
                letter-spacing: 2px;
                margin-bottom: 10px;
            }
            .brand-caption p {
                font-size: 1.1rem;
                opacity: 0.9;
                font-weight: 300;
            }

            /* RIGHT SIDE - FORM */
            .login-form-side {
                height: 100%;
                display: flex;
                align-items: center;
                justify-content: center;
                position: relative;
                background: #fff;
                overflow-y: auto;
            }

            .login-container {
                width: 100%;
                max-width: 420px;
                padding: 40px;
            }

            /* --- FORM ELEMENTS --- */
            .page-title {
                font-size: 2rem;
                font-weight: 700;
                color: var(--text-dark);
                margin-bottom: 10px;
            }
            .page-subtitle {
                color: var(--text-muted);
                margin-bottom: 40px;
                font-size: 0.75rem
            }

            .form-floating > .form-control {
                border: 1px solid var(--border-color);
                border-radius: 12px;
                height: 55px;
            }
            .form-floating > .form-control:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 4px rgba(160, 129, 108, 0.1);
            }
            .form-floating label {
                color: #999;
            }

            .btn-primary-custom {
                background-color: var(--primary-color);
                border: none;
                color: white;
                padding: 15px;
                width: 100%;
                font-weight: 700;
                border-radius: 12px;
                font-size: 1rem;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(160, 129, 108, 0.2);
            }
            .btn-primary-custom:hover {
                background-color: var(--primary-hover);
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(160, 129, 108, 0.3);
            }

            /* Google Button */
            .btn-google {
                display: flex;
                align-items: center;
                justify-content: center;
                width: 100%;
                padding: 12px;
                background: #fff;
                border: 1px solid var(--border-color);
                border-radius: 12px;
                font-weight: 600;
                color: var(--text-dark);
                transition: all 0.3s;
                margin-bottom: 25px;
            }
            .btn-google:hover {
                background-color: #f8f9fa;
                border-color: #ccc;
            }
            .btn-google img {
                width: 22px;
                margin-right: 10px;
            }

            .divider {
                display: flex;
                align-items: center;
                color: #999;
                margin: 20px 0;
                font-size: 0.85rem;
                text-transform: uppercase;
            }
            .divider::before, .divider::after {
                content: '';
                flex: 1;
                border-bottom: 1px solid #eee;
            }
            .divider span {
                padding: 0 15px;
            }

            .form-links {
                display: flex;
                justify-content: space-between;
                align-items: center;
                font-size: 0.9rem;
                margin-bottom: 20px;
            }
            .form-links a {
                color: var(--text-muted);
                text-decoration: none;
                transition: 0.2s;
            }
            .form-links a:hover {
                color: var(--primary-color);
            }

            /* --- UPDATED BACK BUTTON --- */
            .btn-back-home {
                position: absolute;
                top: 30px;
                left: 30px;
                text-decoration: none;
                color: var(--text-dark);
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 8px;
                padding: 10px 20px;
                border-radius: 30px;
                transition: all 0.3s ease;
                z-index: 10;
            }
            .btn-back-home:hover {
                color: #fff !important;
                background-color: var(--primary-color);
                transform: translateX(-5px);
                box-shadow: 0 4px 10px rgba(160, 129, 108, 0.3);
            }

            /* Error Alert In Form */
            .alert-custom-danger {
                background-color: #fff2f2;
                color: #842029;
                border: 1px solid #ffcccc;
                border-radius: 8px;
                font-size: 0.95rem;
                margin-bottom: 20px;
            }

            /* === TOAST STYLES (UPDATED POSITION) === */
            .toast-alert {
                position: fixed;
                top: 20px; /* Đã sửa: Đẩy sát lên trên (cách 20px) */
                right: 20px;
                z-index: 9999;
                padding: 15px 20px;
                background: white;
                border-radius: 12px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.15);
                display: flex;
                align-items: center;
                gap: 12px;
                animation: slideInRight 0.5s cubic-bezier(0.68, -0.55, 0.27, 1.55) forwards;
                border-left: 5px solid;
                max-width: 350px;
            }
            @keyframes slideInRight {
                from {
                    transform: translateX(120%);
                    opacity: 0;
                }
                to {
                    transform: translateX(0);
                    opacity: 1;
                }
            }
            @keyframes slideOutRight {
                from {
                    opacity: 1;
                    transform: translateX(0);
                }
                to {
                    opacity: 0;
                    transform: translateX(120%);
                }
            }
            .toast-alert.hide-toast {
                animation: slideOutRight 0.5s ease-in forwards;
            }
            .toast-alert.success {
                border-color: #28a745;
            }
            .toast-alert.success i {
                color: #28a745;
                font-size: 1.5rem;
            }
            .toast-alert.info {
                border-color: #17a2b8;
            }
            .toast-alert.info i {
                color: #17a2b8;
                font-size: 1.5rem;
            }
            .toast-message {
                font-weight: 600;
                color: #333;
                font-size: 15px;
            }
            .toast-close {
                margin-left: auto;
                cursor: pointer;
                color: #999;
            }
            .toast-close:hover {
                color: #333;
            }

            /* Responsive */
            @media (max-width: 992px) {
                .login-image-side {
                    display: none;
                }
                .login-form-side {
                    justify-content: center;
                }
                .btn-back-home {
                    top: 20px;
                    left: 20px;
                }
            }
        </style>
    </head>
    <body>

        <c:choose>
            <c:when test="${not empty sessionScope.successMessage}">
                <div class="toast-alert success" id="toast-alert">
                    <i class="bi bi-check-circle-fill"></i>
                    <div class="toast-message">${sessionScope.successMessage}</div>
                    <i class="bi bi-x-lg toast-close" onclick="closeToast()"></i>
                </div>
                <c:remove var="successMessage" scope="session" />
            </c:when>
            <c:when test="${empty message}">
                <div class="toast-alert info" id="toast-alert">
                    <i class="bi bi-info-circle-fill"></i>
                    <div class="toast-message">Please Log in to continue!</div>
                    <i class="bi bi-x-lg toast-close" onclick="closeToast()"></i>
                </div>
            </c:when>
        </c:choose>

        <a href="${pageContext.request.contextPath}" class="btn-back-home">
            <i class="bi bi-arrow-left"></i> Back to Home
        </a>

        <div class="container-fluid login-wrapper g-0">
            <div class="row g-0 h-100">

                <div class="col-lg-6 login-image-side" data-aos="fade-right" data-aos-duration="1000">
                    <div class="brand-caption">
                        <h1>GIO FASHION</h1>
                        <p>Simplicity is the essence of elegance.</p>
                    </div>
                </div>

                <div class="col-lg-6 login-form-side">
                    <div class="login-container" data-aos="fade-up" data-aos-duration="800" data-aos-delay="200">

                        <h2 class="page-title">Welcome Back</h2>
                        <p class="page-subtitle">Please enter your login information to access your account.</p>

                        <button type="button" class="btn-google" onclick="loginWithGoogle()">
                            <img src="https://developers.google.com/identity/images/g-logo.png" alt="Google">
                            Sign in with Google
                        </button>

                        <div class="divider"><span>or</span></div>

                        <c:if test="${not empty message}">
                            <div class="alert alert-custom-danger d-flex align-items-center mb-4" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i> ${message}
                            </div>
                        </c:if>

                        <form id="loginForm" action="loginProcess" method="POST">
                            <div class="form-floating mb-3">
                                <input type="text" class="form-control" name="input" id="input" placeholder="Username" required>
                                <label for="input">Username or Email</label>
                            </div>

                            <div class="form-floating mb-3">
                                <input type="password" class="form-control" name="password" id="password" placeholder="Password" required>
                                <label for="password">Password</label>
                            </div>

                            <div class="form-links">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="rememberMe">
                                    <label class="form-check-label text-muted" for="rememberMe">Remember me</label>
                                </div>
                                <a href="${pageContext.request.contextPath}/forgot.jsp">Forgot Password?</a>
                            </div>

                            <button type="submit" class="btn-primary-custom">LOG IN</button>
                        </form>

                        <p class="text-center mt-4 text-muted">
                            Don't have an account? <a href="${pageContext.request.contextPath}/signup.jsp" class="fw-bold text-decoration-none" style="color: var(--primary-color);">Sign up</a>
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery.validate.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/googleLogin.js"></script>
        <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>

        <script type="text/javascript">
                            // Init Animation
                            AOS.init();

                            // --- ORIGINAL TOAST LOGIC ---
                            function closeToast() {
                                var alert = document.getElementById('toast-alert');
                                if (alert) {
                                    alert.classList.add('hide-toast');
                                    alert.addEventListener('animationend', function () {
                                        alert.style.display = 'none';
                                    });
                                }
                            }

                            $(document).ready(function () {
                                // Auto close toast after 5s
                                setTimeout(function () {
                                    closeToast();
                                }, 5000);

                                // Validation
                                $("#loginForm").validate({
                                    errorClass: "text-danger small mt-1",
                                    errorElement: "div",
                                    rules: {
                                        input: {required: true},
                                        password: {required: true}
                                    },
                                    messages: {
                                        input: {required: "Please enter your username or email"},
                                        password: {required: "Please enter your password"}
                                    },
                                    submitHandler: function (form) {
                                        $('.btn-primary-custom').html('<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Processing...').prop('disabled', true);
                                        form.submit();
                                    }
                                });
                            });
        </script>

    </body>
</html>