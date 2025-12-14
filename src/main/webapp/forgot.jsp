<%-- 
    Document    : forgot.jsp
    Updated     : Modern UI, Stepper, Floating Labels
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password | GIO</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href='https://fonts.googleapis.com/css?family=Quicksand:400,500,600,700&display=swap' rel='stylesheet'>
    <link rel="icon" href="${pageContext.request.contextPath}/images/LG2.png" type="image/x-icon">

    <style>
        :root {
            --primary-color: #a0816c;
            --primary-hover: #8a6d5a;
            --bg-color: #f4f1ea; /* Màu nền kem nhẹ hợp với tông nâu */
            --text-dark: #333;
        }

        body {
            background-color: var(--bg-color);
            font-family: 'Quicksand', sans-serif;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        /* --- Header Minimal --- */
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

        /* --- Main Card --- */
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

        /* --- Back Button --- */
        .btn-back {
            position: absolute;
            top: 20px;
            left: 20px;
            color: #999;
            font-size: 1.2rem;
            transition: 0.3s;
            z-index: 10;
        }
        .btn-back:hover { color: var(--primary-color); transform: translateX(-3px); }

        /* --- Stepper (Thanh tiến trình) --- */
        .stepper-wrapper {
            display: flex;
            justify-content: center;
            margin-bottom: 30px;
            position: relative;
        }
        .stepper-item {
            position: relative;
            display: flex;
            flex-direction: column;
            align-items: center;
            flex: 1;
            max-width: 80px;
        }
        .stepper-item::before {
            content: '';
            position: absolute;
            top: 15px;
            left: -50%;
            width: 100%;
            height: 2px;
            background: #e0e0e0;
            z-index: 1;
        }
        .stepper-item:first-child::before { content: none; }
        
        .step-counter {
            width: 30px;
            height: 30px;
            display: flex;
            justify-content: center;
            align-items: center;
            background: #fff;
            border: 2px solid #e0e0e0;
            border-radius: 50%;
            color: #ccc;
            font-weight: 600;
            z-index: 2;
            transition: 0.3s;
        }
        .stepper-item.active .step-counter {
            border-color: var(--primary-color);
            background: var(--primary-color);
            color: white;
        }
        .stepper-item.completed .step-counter {
            border-color: var(--primary-color);
            background: var(--primary-color);
            color: white;
        }
        .stepper-item.completed::before { background: var(--primary-color); }
        .stepper-item.active::before { background: var(--primary-color); }

        /* --- Images & Typography --- */
        .reset-icon {
            width: 80px;
            height: 80px;
            object-fit: contain;
            margin-bottom: 20px;
            display: block;
            margin-left: auto;
            margin-right: auto;
        }
        .form-title { font-weight: 700; color: var(--text-dark); margin-bottom: 10px; text-align: center; }
        .form-subtitle { color: #888; text-align: center; margin-bottom: 30px; font-size: 0.95rem; }

        /* --- Inputs --- */
        .form-floating > .form-control {
            border-radius: 12px;
            border: 1px solid #eee;
            background-color: #fcfcfc;
        }
        .form-floating > .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 4px rgba(160, 129, 108, 0.1);
            background-color: #fff;
        }
        .form-floating label { color: #999; }

        /* --- Buttons --- */
        .btn-primary-custom {
            background-color: var(--primary-color);
            border: none;
            padding: 14px;
            border-radius: 12px;
            font-weight: 600;
            width: 100%;
            margin-top: 10px;
            transition: all 0.3s;
        }
        .btn-primary-custom:hover {
            background-color: var(--primary-hover);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(160, 129, 108, 0.3);
            color: white;
        }
        .btn-primary-custom:disabled {
            background-color: #ccc;
            transform: none;
            box-shadow: none;
        }

        /* --- Step Visibility --- */
        .step-content { display: none; animation: fadeIn 0.5s ease-in-out; }
        .step-content.active { display: block; }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

    <header class="auth-header">
        <a href="<%= request.getContextPath()%>/" class="auth-logo">GIO</a>
    </header>

    <div class="auth-wrapper">
        <div class="auth-card">
            <a href="<%= request.getContextPath()%>/login.jsp" class="btn-back" title="Back to Login">
                <i class="bi bi-arrow-left"></i>
            </a>

            <div class="card-body">
                <div class="stepper-wrapper">
                    <div class="stepper-item active" id="step1-indicator">
                        <div class="step-counter">1</div>
                    </div>
                    <div class="stepper-item" id="step2-indicator">
                        <div class="step-counter">2</div>
                    </div>
                    <div class="stepper-item" id="step3-indicator">
                        <div class="step-counter">3</div>
                    </div>
                </div>

                <div id="step-email" class="step-content active">
                    <img src="${pageContext.request.contextPath}/images/email-otp-1.png" alt="Email" class="reset-icon">
                    <h3 class="form-title">Forgot Password?</h3>
                    <p class="form-subtitle">Enter your registered email address to receive a verification code.</p>
                    
                    <form id="emailForm">
                        <div class="form-floating mb-3">
                            <input type="email" class="form-control" id="email" name="email" placeholder="name@example.com" required>
                            <label for="email"><i class="bi bi-envelope"></i> Email Address</label>
                        </div>
                        <div id="messageEmail" class="text-center mb-3 small fw-bold"></div>
                        <button type="submit" class="btn btn-primary-custom" id="btn-send-email">
                            <span class="spinner-border spinner-border-sm d-none me-2"></span>
                            <span class="btn-text">Send Code</span>
                        </button>
                    </form>
                </div>

                <div id="step-otp" class="step-content">
                    <img src="${pageContext.request.contextPath}/images/phone-otp-2.png" alt="OTP" class="reset-icon">
                    <h3 class="form-title">Enter OTP</h3>
                    <p class="form-subtitle">We have sent a 6-digit code to your email.</p>
                    
                    <form id="codeForm">
                        <div class="form-floating mb-3">
                            <input type="text" class="form-control text-center fw-bold letter-spacing-2" id="code" name="code" placeholder="OTP" maxlength="6" required style="letter-spacing: 5px; font-size: 1.2rem;">
                            <label for="code"><i class="bi bi-shield-lock"></i> Verification Code</label>
                        </div>
                        <div id="messageCode" class="text-center mb-3 small fw-bold"></div>
                        <button type="submit" class="btn btn-primary-custom" id="btn-verify-code">
                            <span class="spinner-border spinner-border-sm d-none me-2"></span>
                            <span class="btn-text">Verify Code</span>
                        </button>
                    </form>
                </div>

                <div id="step-password" class="step-content">
                    <img src="${pageContext.request.contextPath}/images/verification-code-3.png" alt="Success" class="reset-icon">
                    <h3 class="form-title">Reset Password</h3>
                    <p class="form-subtitle">Create a new secure password for your account.</p>
                    
                    <form id="updateForm">
                        <div class="form-floating mb-3">
                            <input type="password" class="form-control" id="password" name="password" placeholder="New Password" required>
                            <label for="password"><i class="bi bi-lock"></i> New Password</label>
                        </div>
                        <div class="form-floating mb-3">
                            <input type="password" class="form-control" id="passwordConfirm" name="passwordConfirm" placeholder="Confirm Password" required>
                            <label for="passwordConfirm"><i class="bi bi-check-circle"></i> Confirm Password</label>
                        </div>
                        <div id="messageUpdate" class="text-center mb-3 small fw-bold"></div>
                        <button type="submit" class="btn btn-primary-custom" id="btn-update-pass">
                            <span class="spinner-border spinner-border-sm d-none me-2"></span>
                            <span class="btn-text">Change Password</span>
                        </button>
                    </form>
                </div>

            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

    <script>
        $(document).ready(function () {
            
            // Helper: Manage Steps
            function goToStep(stepNumber) {
                // Hide all steps
                $('.step-content').removeClass('active');
                
                // Show target step
                if(stepNumber === 1) $('#step-email').addClass('active');
                if(stepNumber === 2) $('#step-otp').addClass('active');
                if(stepNumber === 3) $('#step-password').addClass('active');

                // Update Stepper UI
                updateStepper(stepNumber);
            }

            function updateStepper(step) {
                // Reset styling
                $('.stepper-item').removeClass('active completed');

                if (step >= 1) {
                    $('#step1-indicator').addClass('active');
                    if(step > 1) $('#step1-indicator').addClass('completed');
                }
                if (step >= 2) {
                    $('#step2-indicator').addClass('active');
                    if(step > 2) $('#step2-indicator').addClass('completed');
                }
                if (step >= 3) {
                    $('#step3-indicator').addClass('active');
                }
            }

            // Helper: Button Loading State
            function setButtonLoading($btn, isLoading, defaultText) {
                if (isLoading) {
                    $btn.prop('disabled', true);
                    $btn.find('.spinner-border').removeClass('d-none');
                    $btn.find('.btn-text').text('Processing...');
                } else {
                    $btn.prop('disabled', false);
                    $btn.find('.spinner-border').addClass('d-none');
                    $btn.find('.btn-text').text(defaultText);
                }
            }

            // Helper: Message Display
            function showMessage($element, message, isSuccess) {
                $element.text(message)
                        .removeClass(isSuccess ? 'text-danger' : 'text-success')
                        .addClass(isSuccess ? 'text-success' : 'text-danger');
            }

            // --- STEP 1: SEND EMAIL ---
            $('#emailForm').submit(function (e) {
                e.preventDefault();
                const $btn = $('#btn-send-email');
                const $message = $('#messageEmail');
                const email = $('#email').val().trim();

                if (!email) {
                    showMessage($message, 'Please enter your email.', false);
                    return;
                }

                const url = "<%= request.getContextPath()%>/login/forgot";
                setButtonLoading($btn, true, 'Send Code');
                
                $.ajax({method: "POST", url: url, data: {email: email}, dataType: "json"})
                        .done(function (data) {
                            if (data.isSuccess) {
                                showMessage($message, 'Code sent successfully!', true);
                                setTimeout(function () {
                                    goToStep(2); // Move to Step 2
                                }, 1000);
                            } else {
                                showMessage($message, data.description || 'Email not found.', false);
                            }
                        })
                        .fail(function () {
                            showMessage($message, 'Server error, please try again.', false);
                        })
                        .always(function () {
                            setButtonLoading($btn, false, 'Send Code');
                        });
            });

            // --- STEP 2: VERIFY OTP ---
            $('#codeForm').submit(function (e) {
                e.preventDefault();
                const $btn = $('#btn-verify-code');
                const $message = $('#messageCode');
                const code = $('#code').val().trim();

                if (!code) {
                    showMessage($message, 'Please enter the OTP code.', false);
                    return;
                }

                const url = "<%= request.getContextPath()%>/login/verifyCode";
                setButtonLoading($btn, true, 'Verify Code');

                $.ajax({method: "POST", url: url, data: {code: code}, dataType: "json"})
                        .done(function (data) {
                            if (data.isSuccess) {
                                showMessage($message, 'Verification successful!', true);
                                setTimeout(function () {
                                    goToStep(3); // Move to Step 3
                                }, 1000);
                            } else {
                                showMessage($message, data.description || 'Invalid OTP.', false);
                            }
                        })
                        .fail(function () {
                            showMessage($message, 'Server error, please try again.', false);
                        })
                        .always(function () {
                            setButtonLoading($btn, false, 'Verify Code');
                        });
            });

            // --- STEP 3: UPDATE PASSWORD ---
            $('#updateForm').submit(function (e) {
                e.preventDefault();
                const $btn = $('#btn-update-pass');
                const $message = $('#messageUpdate');
                const pass1 = $('#password').val();
                const pass2 = $('#passwordConfirm').val();

                if (!pass1 || !pass2) {
                    showMessage($message, 'Please fill in all fields.', false);
                    return;
                }
                if (pass1.length < 6) {
                    showMessage($message, 'Password must be at least 6 characters.', false);
                    return;
                }
                if (pass1 !== pass2) {
                    showMessage($message, 'Passwords do not match.', false);
                    return;
                }

                const url = "<%= request.getContextPath()%>/login/update";
                setButtonLoading($btn, true, 'Change Password');

                $.ajax({method: "POST", url: url, data: {password: pass1}, dataType: "json"})
                        .done(function (data) {
                            if (data.isSuccess) {
                                showMessage($message, 'Success! Redirecting to login...', true);
                                // Show checkmark animation or similar here if desired
                                setTimeout(function () {
                                    window.location.href = "<%= request.getContextPath()%>/login.jsp";
                                }, 2000);
                            } else {
                                showMessage($message, data.description || 'Update failed.', false);
                            }
                        })
                        .fail(function () {
                            showMessage($message, 'Server error, please try again.', false);
                        })
                        .always(function () {
                            setButtonLoading($btn, false, 'Change Password');
                        });
            });
        });
    </script>

</body>
</html>