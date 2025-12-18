<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Verify Registration | GIO</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link href='https://fonts.googleapis.com/css?family=Quicksand:400,500,600,700&display=swap' rel='stylesheet'>
        <link rel="icon" href="${pageContext.request.contextPath}/images/LG2.png" type="image/x-icon">

        <style>
            :root {
                --primary-color: #a0816c;
                --primary-hover: #8a6d5a;
                --bg-color: #f4f1ea;
                --text-dark: #333;
            }

            body {
                background-color: var(--bg-color);
                font-family: 'Quicksand', sans-serif;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
            }

            .auth-header {
                padding: 20px 0;
                text-align: center;
            }
            .auth-logo {
                font-size: 2rem;
                font-weight: 800;
                color: var(--primary-color);
                text-decoration: none;
                letter-spacing: 2px;
            }

            .auth-wrapper {
                flex: 1;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 20px;
            }

            .auth-card {
                background: white;
                border: none;
                border-radius: 20px;
                box-shadow: 0 10px 40px rgba(160, 129, 108, 0.15);
                width: 100%;
                max-width: 500px;
                overflow: hidden;
                position: relative;
            }

            .card-body {
                padding: 40px;
            }

            .btn-back {
                position: absolute;
                top: 20px;
                left: 20px;
                color: #999;
                font-size: 1.2rem;
                transition: 0.3s;
                z-index: 10;
            }
            .btn-back:hover {
                color: var(--primary-color);
                transform: translateX(-3px);
            }

            .reset-icon {
                width: 80px;
                height: 80px;
                object-fit: contain;
                margin-bottom: 20px;
                display: block;
                margin-left: auto;
                margin-right: auto;
            }

            .form-title {
                font-weight: 700;
                color: var(--text-dark);
                margin-bottom: 10px;
                text-align: center;
            }
            .form-subtitle {
                color: #888;
                text-align: center;
                margin-bottom: 30px;
                font-size: 0.95rem;
            }

            .otp-container {
                display: flex;
                justify-content: center;
                gap: 8px;
                margin-bottom: 20px;
            }
            .otp-input {
                width: 45px;
                height: 55px;
                text-align: center;
                font-size: 1.5rem;
                font-weight: 700;
                border-radius: 12px;
                border: 1px solid #eee;
                background-color: #fcfcfc;
                transition: all 0.3s;
                color: var(--primary-color);
            }
            .otp-input:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 4px rgba(160, 129, 108, 0.1);
                background-color: #fff;
                outline: none;
                transform: translateY(-2px);
            }

            .btn-primary-custom {
                background-color: var(--primary-color);
                border: none;
                padding: 14px;
                border-radius: 12px;
                font-weight: 600;
                width: 100%;
                margin-top: 10px;
                transition: all 0.3s;
                color: white;
            }
            .btn-primary-custom:hover {
                background-color: var(--primary-hover);
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(160, 129, 108, 0.3);
                color: white;
            }
        </style>
    </head>
    <body>

        <header class="auth-header">
            <a href="<%= request.getContextPath()%>/" class="auth-logo">GIO</a>
        </header>

        <div class="auth-wrapper">
            <div class="auth-card">
                <a href="${pageContext.request.contextPath}/signup.jsp" class="btn-back" title="Back to Sign Up">
                    <i class="bi bi-arrow-left"></i>
                </a>

                <div class="card-body">
                    <div class="text-center mb-4">
                        <i class="bi bi-envelope-check-fill" style="font-size: 4rem; color: var(--primary-color);"></i>
                    </div>

                    <h3 class="form-title">Verify Your Account</h3>
                    <p class="form-subtitle">
                        We have sent a 6-digit code to your email<br>(Please check spam email)<br>
                        <strong>${sessionScope.tempCustomer.email}</strong>
                    </p>

                    <c:if test="${not empty message}">
                        <div class="alert alert-danger text-center small fw-bold mb-4" role="alert">
                            ${message}
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/login/verify-signup" method="POST" id="verifyForm">
                        <div class="otp-container">
                            <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" inputmode="numeric" required>
                            <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" inputmode="numeric" required>
                            <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" inputmode="numeric" required>
                            <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" inputmode="numeric" required>
                            <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" inputmode="numeric" required>
                            <input type="text" class="otp-input" maxlength="1" pattern="[0-9]" inputmode="numeric" required>
                        </div>

                        <input type="hidden" name="verifyCode" id="hiddenVerifyCode">

                        <button type="submit" class="btn btn-primary-custom">
                            VERIFY & CREATE ACCOUNT
                        </button>
                    </form>

                    <div class="text-center mt-4">
                        <span class="text-muted small">Didn't receive the code?</span>
                        <a href="${pageContext.request.contextPath}/signup.jsp" class="fw-bold text-decoration-none" style="color: var(--primary-color);">Resend</a>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
        <script>
            $(document).ready(function () {
                const $otpInputs = $('.otp-input');
                const $hiddenCode = $('#hiddenVerifyCode');

                // Focus first input on load
                setTimeout(() => $otpInputs.first().focus(), 300);

                function updateHiddenCode() {
                    let code = '';
                    $otpInputs.each(function () {
                        code += $(this).val();
                    });
                    $hiddenCode.val(code);
                }

                $otpInputs.on('input', function () {
                    this.value = this.value.replace(/[^0-9]/g, '');
                    updateHiddenCode();

                    if (this.value.length === 1) {
                        $(this).next('.otp-input').focus();
                    }
                });

                $otpInputs.on('keydown', function (e) {
                    if (e.key === 'Backspace' && !this.value) {
                        $(this).prev('.otp-input').focus();
                    }
                });

                $otpInputs.on('paste', function (e) {
                    let pasteData = (e.originalEvent.clipboardData || window.clipboardData).getData('text');
                    pasteData = pasteData.replace(/\D/g, '').substring(0, 6);

                    if (pasteData) {
                        $otpInputs.each(function (index) {
                            if (index < pasteData.length) {
                                $(this).val(pasteData[index]);
                            }
                        });
                        updateHiddenCode();
                        $otpInputs.eq(Math.min(pasteData.length, 5)).focus();
                        e.preventDefault();
                    }
                });

                // Prevent submit if code is incomplete (optional UI enhancement)
                $('#verifyForm').on('submit', function (e) {
                    if ($hiddenCode.val().length < 6) {
                        e.preventDefault();
                        $otpInputs.first().focus();
                        // Optional: Add simple visual shake or alert here
                    }
                });
            });
        </script>
    </body>
</html>