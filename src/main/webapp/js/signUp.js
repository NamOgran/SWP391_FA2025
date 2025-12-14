/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

$(document).ready(function () {
    // ... các validator của bạn ...

    $("#signUp-form").validate({
        // ... rules và messages ...
        submitHandler: function (form) {
            var username = document.getElementById("username").value;
            var password = document.getElementById("password").value;
            var email = document.getElementById("email").value;
            var address = document.getElementById("address").value;
            var phoneNumber = document.getElementById("phoneNumber").value;
            var fullName = document.getElementById("fullName").value;

            $.ajax({
                method: "POST",
                // SỬA DÒNG NÀY
                url: contextPath + "/login/signup", 
                data: {
                    username: username,
                    password: password,
                    email: email,
                    address: address,
                    phoneNumber: phoneNumber,
                    fullName: fullName
                },
                success: function (data) {
                    var data1 = JSON.parse(data);
                    if (data1.isSuccess) {
                        alert('Create account successfully');
                        window.location.href = contextPath + "/login.jsp"; // Chuyển hướng cũng dùng contextPath
                    } else {
                        $("#message").html("Your username or email is already exists");
                        document.getElementById("message").style.color = "red";
                    }
                },
                error: function (xhr, textStatus, errorThrown) {
                    console.log("AJAX Error: " + textStatus + " (" + errorThrown + ")");
                    // Xử lý lỗi AJAX ở đây, ví dụ: hiển thị thông báo chung
                    $("#message").html("An error occurred during registration. Please try again.");
                    document.getElementById("message").style.color = "red";
                }
            });
        }
    });
});