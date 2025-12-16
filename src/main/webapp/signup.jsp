<%-- 
    Document    : signup.jsp
    Updated     : Validation Rules Updated per Requirements
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Sign Up | GIO</title>

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
            .signup-image-side {
                background-image: url('${pageContext.request.contextPath}/images/BG3.jpeg');
                background-size: cover;
                background-position: center;
                position: relative;
                height: 100%;
            }
            .signup-image-side::before {
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
            .signup-form-side {
                height: 100%;
                display: flex;
                align-items: center;
                justify-content: center;
                position: relative;
                background: #fff;
                overflow-y: auto;
                padding: 40px 0;
            }

            .signup-container {
                width: 100%;
                max-width: 650px;
                padding: 20px 40px;
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
                margin-bottom: 30px;
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
            .form-floating label i {
                margin-right: 5px;
                color: var(--primary-color);
            }

            /* === VALIDATION ERROR STYLES === */
            label.error {
                color: #dc3545;
                font-size: 0.85rem;
                margin-top: 5px;
                margin-left: 5px;
                display: block;
                font-weight: 600;
                white-space: normal;
                overflow: visible;
                text-overflow: clip;
                height: auto;
                width: 100%;
                line-height: 1.2;
            }

            .form-floating label.error {
                position: static;
                transform: none;
                opacity: 1;
                padding-top: 5px;
            }
            .form-control.error {
                border-color: #dc3545;
                background-image: none !important;
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
                margin-top: 20px;
            }
            .btn-primary-custom:hover {
                background-color: var(--primary-hover);
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(160, 129, 108, 0.3);
            }

            /* Back Button */
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

            /* === TOAST NOTIFICATION === */
            .toast-alert {
                position: fixed;
                top: 20px;
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
                from { transform: translateX(120%); opacity: 0; }
                to { transform: translateX(0); opacity: 1; }
            }
            @keyframes slideOutRight {
                from { opacity: 1; transform: translateX(0); }
                to { opacity: 0; transform: translateX(120%); }
            }
            .toast-alert.hide-toast {
                animation: slideOutRight 0.5s ease-in forwards;
            }
            .toast-alert.danger {
                border-color: #dc3545;
            }
            .toast-alert.danger i {
                color: #dc3545;
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

            /* Responsive */
            @media (max-width: 992px) {
                .signup-image-side {
                    display: none;
                }
                .signup-form-side {
                    justify-content: center;
                    height: 100vh;
                }
                .signup-container {
                    padding: 80px 20px 40px 20px;
                }
                .btn-back-home {
                    top: 20px;
                    left: 20px;
                }
            }
        </style>
    </head>
    <body>

        <c:if test="${not empty message}">
            <div class="toast-alert danger" id="toast-alert">
                <i class="bi bi-exclamation-circle-fill"></i>
                <div class="toast-message">${message}</div>
                <i class="bi bi-x-lg toast-close" onclick="closeToast()"></i>
            </div>
        </c:if>

        <div class="modal fade" id="successModal" tabindex="-1" aria-labelledby="successModalLabel" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content text-center p-4 border-0 shadow">
                    <div class="modal-body">
                        <div class="mb-3">
                            <i class="bi bi-check-circle-fill text-success" style="font-size: 4rem;"></i>
                        </div>
                        <h3 class="fw-bold mb-2">Sign Up Successful!</h3>
                        <p class="text-muted mb-4">Your account has been created successfully.<br>Welcome to GIO Shop.</p>
                        <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary-custom w-100">
                            OK, Go to Login
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <a href="${pageContext.request.contextPath}" class="btn-back-home">
            <i class="bi bi-arrow-left"></i> Back to Home
        </a>

        <div class="container-fluid login-wrapper g-0">
            <div class="row g-0 h-100">

                <div class="col-lg-5 signup-image-side" data-aos="fade-right" data-aos-duration="1000">
                    <div class="brand-caption">
                        <h1>Join GIO</h1>
                        <p>Experience the art of timeless fashion.</p>
                    </div>
                </div>

                <div class="col-lg-7 signup-form-side">
                    <div class="signup-container" data-aos="fade-up" data-aos-duration="800" data-aos-delay="200">

                        <h2 class="page-title">Create Account</h2>
                        <p class="page-subtitle">Fill in the details below to become a member.</p>

                        <form action="${pageContext.request.contextPath}/login/signup" method="POST" id="signUp-form">
                            <div class="row g-3">
                                
                                <div class="col-md-6">
                                    <div class="form-floating">
                                        <input type="text" class="form-control" id="username" name="username" placeholder="Username" 
                                               minlength="6" maxlength="20" value="${inputUsername}">
                                        <label for="username"><i class="bi bi-person"></i> Username</label>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-floating">
                                        <input type="text" class="form-control" id="fullName" name="fullName" placeholder="Full Name" 
                                               minlength="2" maxlength="100" style="text-transform: capitalize;" value="${inputFullName}">
                                        <label for="fullName"><i class="bi bi-card-text"></i> Full Name</label>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-floating">
                                        <input type="password" class="form-control" id="password" name="password" placeholder="Password" 
                                               minlength="8" maxlength="24">
                                        <label for="password"><i class="bi bi-lock"></i> Password</label>
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="form-floating">
                                        <input type="password" class="form-control" id="rePassword" name="rePassword" placeholder="Confirm Password" 
                                               minlength="8" maxlength="24">
                                        <label for="rePassword"><i class="bi bi-check2-circle"></i> Confirm Password</label>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="form-floating">
                                        <input type="email" class="form-control" id="email" name="email" placeholder="Email" 
                                               maxlength="50" value="${inputEmail}">
                                        <label for="email"><i class="bi bi-envelope"></i> Email</label>
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="form-floating">
                                        <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber" placeholder="Phone" 
                                               maxlength="10" value="${inputPhone}">
                                        <label for="phoneNumber"><i class="bi bi-telephone"></i> Phone</label>
                                    </div>
                                </div>

                                <div class="col-12">
                                    <div class="form-floating">
                                        <input type="text" class="form-control" id="address" name="address" placeholder="Address" 
                                               maxlength="255" value="${inputAddress}">
                                        <label for="address"><i class="bi bi-geo-alt"></i> Address</label>
                                    </div>
                                </div>
                            </div>

                            <button type="submit" class="btn-primary-custom btn-register">SIGN UP</button>
                        </form>

                        <p class="text-center mt-4 text-muted">
                            Already have an account? <a href="${pageContext.request.contextPath}/login.jsp" class="fw-bold text-decoration-none" style="color: var(--primary-color);">Log in</a>
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/js/jquery-3.7.0.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery.validate.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>

        <script type="text/javascript">
            // Init Animation
            AOS.init();

            // Toast Logic
            function closeToast() {
                var alert = document.getElementById('toast-alert');
                if (alert) {
                    alert.classList.add('hide-toast');
                    alert.addEventListener('animationend', function() {
                        alert.style.display = 'none';
                    });
                }
            }

            // Hàm viết hoa chữ cái đầu mỗi từ (Hỗ trợ tiếng Việt)
            function toTitleCase(str) {
                return str.toLowerCase().replace(/(^|\s)\S/g, function(l) {
                    return l.toUpperCase();
                });
            }

            $(document).ready(function() {
                // Auto close toast
                setTimeout(function() { closeToast(); }, 5000);

                // --- 1. TỰ ĐỘNG VIẾT HOA TÊN KHI RỜI Ô NHẬP (BLUR) ---
                $('#fullName').on('blur', function() {
                    var val = $(this).val();
                    if(val) {
                        $(this).val(toTitleCase(val));
                    }
                });

                // --- 2. ĐỊNH NGHĨA CÁC RULE VALIDATION ---

                // Rule Regex: Username (Chỉ chữ cái và số)
                $.validator.addMethod("validUsernameRegex", function(value, element) {
                    return this.optional(element) || /^[a-zA-Z0-9]+$/.test(value);
                }, "Username must contain only letters and numbers (no special characters).");

                // Rule Regex: Full Name (Chữ cái và khoảng trắng, không số)
                $.validator.addMethod("validNameRegex", function(value, element) {
                    return this.optional(element) || /^[a-zA-ZÀ-ỹ\s]+$/.test(value);
                }, "Name cannot contain numbers or special characters.");

                // Rule Regex: Password (Ít nhất 1 hoa, 1 đặc biệt)
                $.validator.addMethod("complexPassword", function(value, element) {
                    return this.optional(element) || /^(?=.*[A-Z])(?=.*[!@#$%^&*(),.?":{}|<>_+\-=\[\]{};':"\\|\/]).*$/.test(value);
                }, "Password needs 1 uppercase letter & 1 special character.");

                // Rule Regex: Phone (Bắt đầu bằng 0, đúng 10 số)
                $.validator.addMethod("validPhoneRegex", function(value, element) {
                    return this.optional(element) || /^0\d{9}$/.test(value);
                }, "Phone must start with 0 and have exactly 10 digits.");

                // Rule Regex: Address (Cho phép chữ, số, khoảng trắng và , . / -)
                $.validator.addMethod("validAddressRegex", function(value, element) {
                    return this.optional(element) || /^[a-zA-Z0-9À-ỹ\s,\/.-]+$/.test(value);
                }, "Address cannot contain special characters (except comma, dot, slash, hyphen).");


                // --- 3. CẤU HÌNH VALIDATE FORM ---
                $("#signUp-form").validate({
                    rules: {
                        username: {
                            required: true,
                            minlength: 6,
                            maxlength: 20,
                            validUsernameRegex: true
                        },
                        fullName: {
                            required: true,
                            minlength: 2,
                            maxlength: 100,
                            validNameRegex: true
                        },
                        password: {
                            required: true,
                            minlength: 8,
                            maxlength: 24,
                            complexPassword: true
                        },
                        rePassword: {
                            required: true,
                            minlength: 8,
                            maxlength: 24,
                            equalTo: "#password"
                        },
                        email: {
                            required: true,
                            email: true,
                            maxlength: 50
                        },
                        phoneNumber: {
                            required: true,
                            digits: true, // Chỉ chấp nhận số
                            minlength: 10,
                            maxlength: 10,
                            validPhoneRegex: true
                        },
                        address: {
                            required: true,
                            maxlength: 255,
                            validAddressRegex: true
                        }
                    },
                    messages: {
                        username: {
                            required: "Please enter your username",
                            minlength: "Username must be at least 6 characters.",
                            maxlength: "Username cannot exceed 20 characters.",
                            validUsernameRegex: "Username must contain only letters and numbers (no special characters)."
                        },
                        fullName: {
                            required: "Please enter your full name",
                            minlength: "Name must be at least 2 characters.",
                            maxlength: "Name cannot exceed 100 characters.",
                            validNameRegex: "Name cannot contain numbers or special characters."
                        },
                        password: {
                            required: "Please provide a password",
                            minlength: "Password must be at least 8 characters.",
                            maxlength: "Password cannot exceed 24 characters.",
                            complexPassword: "Password must have at least 1 Uppercase & 1 Special char."
                        },
                        rePassword: {
                            required: "Please confirm your password",
                            minlength: "Password must be at least 8 characters.",
                            maxlength: "Password cannot exceed 24 characters.",
                            equalTo: "Passwords do not match."
                        },
                        email: {
                            required: "Please enter your email",
                            email: "Please enter a valid email format (e.g., abc@domain.com).",
                            maxlength: "Email cannot exceed 50 characters."
                        },
                        phoneNumber: {
                            required: "Please enter your phone number",
                            digits: "Only digits allowed.",
                            minlength: "Phone number must have exactly 10 digits.",
                            maxlength: "Phone number must have exactly 10 digits.",
                            validPhoneRegex: "Phone must start with 0 and have exactly 10 digits."
                        },
                        address: {
                            required: "Please enter your address",
                            maxlength: "Address cannot exceed 255 characters.",
                            validAddressRegex: "Address cannot contain special characters (except comma, dot, slash, hyphen)."
                        }
                    },
                    
                    errorElement: "label",
                    errorPlacement: function(error, element) {
                        error.insertAfter(element.next("label"));
                    },
                    highlight: function(element) {
                        $(element).addClass("error").removeClass("valid");
                    },
                    unhighlight: function(element) {
                        $(element).removeClass("error").addClass("valid");
                    },
                    submitHandler: function(form) {
                        $('.btn-register').html('<span class="spinner-border spinner-border-sm"></span> Processing...').prop('disabled', true);
                        form.submit();
                    }
                });

                // Popup Success Logic
                <c:if test="${not empty registerSuccess}">
                    new bootstrap.Modal(document.getElementById('successModal')).show();
                </c:if>
            });
        </script>
    </body>
</html>