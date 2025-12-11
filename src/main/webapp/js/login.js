/*
 * File: js/login.js
 * Updated: Removed reCAPTCHA logic causing "not defined" error
 */

document.addEventListener("DOMContentLoaded", function () {
    const loginForm = document.getElementById("loginForm");

    // 1. Xóa cookie cũ (Giữ nguyên logic của bạn)
    document.cookie = "code=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
    // document.cookie = "input=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;"; // Bỏ comment nếu muốn xóa user cũ
    document.cookie = "email=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";

    if (loginForm) {
        loginForm.addEventListener("submit", function (e) {
            // Không preventDefault nữa để form tự submit về Server
            
            const inputElement = document.getElementById('input');
            const errorElement = document.getElementById("error");

            // Validate cơ bản (Tùy chọn)
            if (!inputElement.value.trim()) {
                e.preventDefault(); // Chặn nếu rỗng
                if(errorElement) {
                    errorElement.innerHTML = "Please enter username or email";
                    errorElement.style.color = "red";
                    errorElement.style.display = "block";
                }
                return;
            }

            // Lưu cookie input để tiện cho lần sau (nếu cần)
            document.cookie = "input=" + encodeURIComponent(inputElement.value) + "; path=/";
            
            // ĐÃ XÓA: Logic grecaptcha.getResponse()
        });
    }
});