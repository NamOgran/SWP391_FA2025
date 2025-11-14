
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Khôi phục mật khẩu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        body {
            background-color: #f8f9fa;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            font-family: 'Quicksand', sans-serif; /* Giữ font của cậu */
        }
        .form-container {
            width: 100%;
            max-width: 450px;
        }
        .card {
            border: 1px solid #a0816c; /* Giữ màu chủ đạo của cậu */
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }
        .card-header {
            background-color: #a0816c;
            color: white;
            text-align: center;
            font-size: 1.5rem;
            font-weight: 500;
            padding: 1.25rem;
        }
        .btn-primary {
            background-color: #a0816c;
            border-color: #a0816c;
            width: 100%;
            padding: 0.75rem;
            font-size: 1rem;
            font-weight: 600;
        }
        .btn-primary:hover, .btn-primary:focus {
            background-color: #8a6d5a;
            border-color: #8a6d5a;
        }
        .btn-primary:disabled {
            background-color: #ccc;
            border-color: #ccc;
        }
        .form-control:focus {
            border-color: #a0816c;
            box-shadow: 0 0 0 0.25rem rgba(160, 129, 108, 0.25);
        }
        .form-text {
            text-align: center;
            margin-top: 1rem;
        }
        .highlight2 {
            color: #a0816c;
            text-decoration: none;
            font-weight: 500;
        }
        .highlight2:hover {
            text-decoration: underline;
        }
        /* Ẩn các form không cần thiết ban đầu */
        #codeFormCard, #updateFormCard {
            display: none;
        }
    </style>
</head>
<body>

    <div class="form-container">
        
        <div class="card" id="emailFormCard">
            <div class="card-header">
                Khôi phục mật khẩu
            </div>
            <div class="card-body p-4 p-md-5">
                <p class="text-center text-muted mb-4">Vui lòng nhập email của bạn để nhận mã xác thực.</p>
                <form id="emailForm">
                    <div class="mb-3">
                        <label for="email" class="form-label">Email</label>
                        <input type="email" class="form-control" id="email" name="email" placeholder="Email của bạn" required>
                    </div>
                    <div id="messageEmail" class="text-center mb-3"></div>
                    <button type="submit" class="btn btn-primary" id="btn-send-email">
                        <span class="spinner-border spinner-border-sm d-none" role="status" aria-hidden="true"></span>
                        <span class="btn-text">Gửi mã</span>
                    </button>
                </form>
            </div>
            <div class="card-footer text-center p-3">
                <a href="login.jsp" class="highlight2">Quay lại Đăng nhập</a>
            </div>
        </div>

        <div class="card" id="codeFormCard">
            <div class="card-header">
                Xác thực OTP
            </div>
            <div class="card-body p-4 p-md-5">
                <p class="text-center text-muted mb-4">Mã OTP (gồm 6 chữ số) đã được gửi đến email của bạn. Vui lòng kiểm tra (cả thư mục spam).</p>
                <form id="codeForm">
                    <div class="mb-3">
                        <label for="code" class="form-label">Mã OTP</label>
                        <input type="text" class="form-control" id="code" name="code" placeholder="Nhập mã OTP" required>
                    </div>
                    <div id="messageCode" class="text-center mb-3"></div>
                    <button type="submit" class="btn btn-primary" id="btn-verify-code">
                        <span class="spinner-border spinner-border-sm d-none" role="status" aria-hidden="true"></span>
                        <span class="btn-text">Xác nhận</span>
                    </button>
                </form>
            </div>
            <div class="card-footer text-center p-3">
                <a href="login.jsp" class="highlight2">Quay lại Đăng nhập</a>
            </div>
        </div>

        <div class="card" id="updateFormCard">
            <div class="card-header">
                Tạo mật khẩu mới
            </div>
            <div class="card-body p-4 p-md-5">
                <p class="text-center text-muted mb-4">Mã đã được xác thực. Vui lòng tạo mật khẩu mới.</p>
                <form id="updateForm">
                    <div class="mb-3">
                        <label for="password" class="form-label">Mật khẩu mới</label>
                        <input type="password" class="form-control" id="password" name="password" required>
                    </div>
                    <div class="mb-3">
                        <label for="passwordConfirm" class="form-label">Xác nhận mật khẩu</label>
                        <input type="password" class="form-control" id="passwordConfirm" name="passwordConfirm" required>
                    </div>
                    <div id="messageUpdate" class="text-center mb-3"></div>
                    <button type="submit" class="btn btn-primary" id="btn-update-pass">
                        <span class="spinner-border spinner-border-sm d-none" role="status" aria-hidden="true"></span>
                        <span class="btn-text">Đổi mật khẩu</span>
                    </button>
                </form>
            </div>
            <div class="card-footer text-center p-3">
                <a href="login.jsp" class="highlight2">Quay lại Đăng nhập</a>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    
    <script>
        $(document).ready(function () {
            const $emailCard = $('#emailFormCard');
            const $codeCard = $('#codeFormCard');
            const $updateCard = $('#updateFormCard');

            // Hàm helper để quản lý trạng thái loading của button
            function setButtonLoading($btn, isLoading) {
                if (isLoading) {
                    $btn.prop('disabled', true);
                    $btn.find('.spinner-border').removeClass('d-none');
                    $btn.find('.btn-text').text('Đang xử lý...');
                } else {
                    $btn.prop('disabled', false);
                    $btn.find('.spinner-border').addClass('d-none');
                    // Reset text
                    if ($btn.attr('id') === 'btn-send-email') $btn.find('.btn-text').text('Gửi mã');
                    if ($btn.attr('id') === 'btn-verify-code') $btn.find('.btn-text').text('Xác nhận');
                    if ($btn.attr('id') === 'btn-update-pass') $btn.find('.btn-text').text('Đổi mật khẩu');
                }
            }

            // Hàm helper để hiển thị thông báo
            function showMessage($element, message, isSuccess) {
                $element.text(message)
                        .removeClass(isSuccess ? 'text-danger' : 'text-success')
                        .addClass(isSuccess ? 'text-success' : 'text-danger');
            }
            
            // Xử lý Gửi Email (Bước 1)
            $('#emailForm').submit(function (e) {
                e.preventDefault();
                const $btn = $('#btn-send-email');
                const $message = $('#messageEmail');
                const email = $('#email').val().trim();

                if (!email) {
                    showMessage($message, 'Vui lòng nhập email.', false);
                    return;
                }
                
                // Giả sử cậu có 1 servlet context path là /Project_SWP391_Group4
                // Nếu không, hãy đổi URL này cho đúng
                const url = "<%= request.getContextPath() %>/login/forgot";

                setButtonLoading($btn, true);
                
                $.ajax({
                    method: "POST",
                    url: url,
                    data: { email: email },
                    dataType: "json"
                })
                .done(function (data) {
                    if (data.isSuccess) {
                        showMessage($message, 'Gửi mã thành công!', true);
                        // Chuyển sang form OTP sau 1 giây
                        setTimeout(function() {
                            $emailCard.hide();
                            $codeCard.show();
                        }, 1000);
                    } else {
                        showMessage($message, data.description || 'Email không tồn tại hoặc có lỗi.', false);
                    }
                })
                .fail(function (xhr, status, error) {
                    console.error("AJAX Error:", status, error);
                    showMessage($message, 'Lỗi máy chủ, vui lòng thử lại.', false);
                })
                .always(function () {
                    setButtonLoading($btn, false);
                });
            });

            // Xử lý Xác thực OTP (Bước 2)
            $('#codeForm').submit(function (e) {
                e.preventDefault();
                const $btn = $('#btn-verify-code');
                const $message = $('#messageCode');
                const code = $('#code').val().trim();

                if (!code) {
                    showMessage($message, 'Vui lòng nhập mã OTP.', false);
                    return;
                }
                
                const url = "<%= request.getContextPath() %>/login/verifyCode";
                
                setButtonLoading($btn, true);

                $.ajax({
                    method: "POST",
                    url: url,
                    data: { code: code },
                    dataType: "json"
                })
                .done(function (data) {
                    if (data.isSuccess) {
                        showMessage($message, 'Xác thực thành công!', true);
                        // Chuyển sang form đổi mật khẩu
                        setTimeout(function() {
                            $codeCard.hide();
                            $updateCard.show();
                        }, 1000);
                    } else {
                        showMessage($message, data.description || 'Mã không hợp lệ hoặc đã hết hạn.', false);
                    }
                })
                .fail(function (xhr, status, error) {
                    console.error("AJAX Error:", status, error);
                    showMessage($message, 'Lỗi máy chủ, vui lòng thử lại.', false);
                })
                .always(function () {
                    setButtonLoading($btn, false);
                });
            });

            // Xử lý Đổi mật khẩu (Bước 3)
            $('#updateForm').submit(function (e) {
                e.preventDefault();
                const $btn = $('#btn-update-pass');
                const $message = $('#messageUpdate');
                const pass1 = $('#password').val();
                const pass2 = $('#passwordConfirm').val();

                if (!pass1 || !pass2) {
                    showMessage($message, 'Vui lòng nhập đầy đủ mật khẩu.', false);
                    return;
                }
                if (pass1.length < 6) {
                    showMessage($message, 'Mật khẩu phải có ít nhất 6 ký tự.', false);
                    return;
                }
                if (pass1 !== pass2) {
                    showMessage($message, 'Mật khẩu xác nhận không khớp.', false);
                    return;
                }
                
                const url = "<%= request.getContextPath() %>/login/update";

                setButtonLoading($btn, true);

                $.ajax({
                    method: "POST",
                    url: url,
                    data: { password: pass1 },
                    dataType: "json"
                })
                .done(function (data) {
                    if (data.isSuccess) {
                        showMessage($message, 'Đổi mật khẩu thành công! Đang chuyển về trang đăng nhập...', true);
                        // Chuyển về trang login
                        setTimeout(function() {
                            window.location.href = "login.jsp";
                        }, 2000);
                    } else {
                        showMessage($message, data.description || 'Lỗi khi cập nhật mật khẩu.', false);
                    }
                })
                .fail(function (xhr, status, error) {
                    console.error("AJAX Error:", status, error);
                    showMessage($message, 'Lỗi máy chủ, vui lòng thử lại.', false);
                })
                .always(function () {
                    setButtonLoading($btn, false);
                });
            });
        });
    </script>
</body>
</html>
