/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
$(document).ready(function () {
    // Initialize form elements
    const $emailForm = $('#emailForm');
    const $codeForm = $('#codeForm');
    const $updateForm = $('#updateForm');
    const $message = $('#message');
    const $messageUpdate = $('#messageUpdate');

    // Send verification code
    $('.btn-send').click(function (e) {
        e.preventDefault();
        
        const email = $("#email").val().trim();
        
        // Validation
        if (!email) {
            showMessage($message, "Please enter your email", "red");
            return;
        }
        
        if (!isValidEmail(email)) {
            showMessage($message, "Please enter a valid email address", "red");
            return;
        }

        // Show loading state
        const $btn = $(this);
        const originalText = $btn.text();
        $btn.prop('disabled', true).text('Sending...');

        $.ajax({
            method: "POST",
            url: "http://localhost:8080/Project_SWP391_Group4/login/forgot",
            data: { email: email },
            dataType: "json" // Expect JSON response
        })
        .done(function (data) {
            // No need to parse, jQuery handles it with dataType: "json"
            if (data.isSuccess) {
                showMessage($message, "Verification code has been sent to your email. Please check your inbox and spam folder.", "#009900");
                $emailForm.hide();
                $codeForm.show();
            } else {
                showMessage($message, data.description || "Your email does not exist or there was an error sending the email.", "red");
            }
        })
        .fail(function (xhr, status, error) {
            console.error("AJAX Error:", status, error);
            let errorMsg = "Error occurred. Please try again.";
            
            if (xhr.responseJSON && xhr.responseJSON.description) {
                errorMsg = xhr.responseJSON.description;
            } else if (xhr.status === 0) {
                errorMsg = "Cannot connect to server. Please check your connection.";
            }
            
            showMessage($message, errorMsg, "red");
        })
        .always(function () {
            // Reset button state
            $btn.prop('disabled', false).text(originalText);
        });
    });

    // Verify code
    $('.btn-submit').click(function (e) {
        e.preventDefault();
        
        const code = $("#code").val().trim();

        if (!code) {
            showMessage($message, "Please enter the verification code", "red");
            return;
        }

        // Show loading state
        const $btn = $(this);
        const originalText = $btn.text();
        $btn.prop('disabled', true).text('Verifying...');

        $.ajax({
            method: "POST",
            url: "http://localhost:8080/Project_SWP391_Group4/verifyCode",
            data: { code: code },
            dataType: "json"
        })
        .done(function (data) {
            if (data.isSuccess) {
                $codeForm.hide();
                $updateForm.show();
                $messageUpdate.text(""); // Clear previous messages
            } else {
                showMessage($message, data.description || "Invalid code!", "red");
            }
        })
        .fail(function (xhr, status, error) {
            console.error("AJAX Error:", status, error);
            showMessage($message, "Error verifying code. Please try again.", "red");
        })
        .always(function () {
            // Reset button state
            $btn.prop('disabled', false).text(originalText);
        });
    });

    // Change password
    $('.btn-changePass').click(function (e) {
        e.preventDefault();
        
        const pass1 = $("#password1").val();
        const pass2 = $("#password2").val();

        // Validation
        if (!pass1 || !pass2) {
            showMessage($messageUpdate, "Please enter both password fields", "red");
            return;
        }

        if (pass1.length < 6) {
            showMessage($messageUpdate, "Password must be at least 6 characters long", "red");
            return;
        }

        if (pass1 !== pass2) {
            showMessage($messageUpdate, "Passwords do not match!", "red");
            return;
        }

        // Show loading state
        const $btn = $(this);
        const originalText = $btn.text();
        $btn.prop('disabled', true).text('Changing...');

        $.ajax({
            method: "POST",
            url: "http://localhost:8080/Project_SWP391_Group4/login/update",
            data: { password: pass1 },
            dataType: "json"
        })
        .done(function (data) {
            if (data.isSuccess) {
                alert("Password changed successfully!");
                window.location.href = "login.jsp";
            } else {
                showMessage($messageUpdate, data.description || "Failed to update password", "red");
            }
        })
        .fail(function (xhr, status, error) {
            console.error("AJAX Error:", status, error);
            showMessage($messageUpdate, "Error updating password. Please try again.", "red");
        })
        .always(function () {
            // Reset button state
            $btn.prop('disabled', false).text(originalText);
        });
    });

    // Helper function to show messages
    function showMessage($element, message, color) {
        $element.text(message).css('color', color);
    }

    // Helper function to validate email format
    function isValidEmail(email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }

    // Enter key support for forms
    $('#email').keypress(function (e) {
        if (e.which === 13) { // Enter key
            $('.btn-send').click();
        }
    });

    $('#code').keypress(function (e) {
        if (e.which === 13) { // Enter key
            $('.btn-submit').click();
        }
    });

    $('#password1, #password2').keypress(function (e) {
        if (e.which === 13) { // Enter key
            $('.btn-changePass').click();
        }
    });
});