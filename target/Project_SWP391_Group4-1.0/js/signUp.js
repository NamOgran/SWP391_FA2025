/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

$(document).ready(function () {
//       $('.btn-register').click(function (e) {
//        e.preventDefault();
////        var id = $(this).attr("id-role")
////        var row = $(this).closest('tenClass'); di ra the to tien cua no
//        var username = document.getElementById("username").value;
//        var password = document.getElementById("password").value;
//        var email = document.getElementById("email").value;
//        var address = document.getElementById("address").value;
//        var phoneNumber = document.getElementById("phoneNumber").value;
//        var fullName = document.getElementById("fullName").value;
//        $.ajax({
//            method: "POST",
//            url: "http://localhost:8080/Project_SWP_Group2/login/signup",
//            data: {
//                username: username,
//                password: password,
//                email: email,
//                address: address,
//                phoneNumber: phoneNumber,
//                fullName: fullName
//            }
//
//        })
//                .done(function (data) {
//                    var data1 = JSON.parse(data);
//                    if (data1.isSuccess) {
//                        alert('Create account successfully');
//
//                    } else {
//                        alert('Your username is existed');
//                    }
//                });
//    })

    $.validator.addMethod("phone_valid", function (value, element) {
        return this.optional(element) || /^[0]{1}[0-9]{9}$/i.test(value);
    });

    $.validator.addMethod("username_valid", function (value, element) {
        return this.optional(element) || /^[a-zA-Z]([._-](?![._])|[a-zA-Z0-9]){3,18}[a-zA-Z0-9]$/i.test(value);
        //bat dau = ki tu hoac chu so, ki tu tiep theo co the la ._ nhung k the la lien tiep, ki tu cuoi cung la ki tu hoac so

    });

    $.validator.addMethod("password_valid", function (value, element) {
        return this.optional(element) || /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$/.test(value);
        //it nhat 6 ki tu chua it nhat 1 so, 1 ki tu dac biet va 1 chu hoa
    });

    $("#signUp-form").validate({
        rules: {
            "password": {
                minlength: 6,
                password_valid: true
            },
            "phoneNumber": {
                minlength: 10,
                phone_valid: true
            },
            "username": {
                minlength: 5,
                username_valid: true
            }
        },
        messages: {
            "username": {
                minlength: "Please enter username more than 5 character",
                required: "*This field is required! (Please enter your Username)",
                username_valid: "Username can not have special character except ._ or start/end with special character"
            },
            "password": {
                minlength: "Please enter password more than 6 character",
                required: "*This field is required! (Please enter your Password)",
                password_valid: "Password contain at least one uppercase letter, one number and one special character"
            },
            "phoneNumber": {
                minlength: "Please enter phone number have 10 character",
                required: "*This field is required! (Please enter your phone number)",
                phone_valid: "Incorrect phone number! (Enter all 10 digits 0xxxxxxxxx)"
            },
            "address": {
                required: "*This field is required! (Please enter your address)"
            },
            "email": {
                required: "*This field is required! (Please enter your email)"
            },
            "fullName": {
                required: "*This field is required! (Please enter your full name)"
            }
        },
        submitHandler: function (form) {
            // Form is valid, trigger AJAX call
            var username = document.getElementById("username").value;
            var password = document.getElementById("password").value;
            var email = document.getElementById("email").value;
            var address = document.getElementById("address").value;
            var phoneNumber = document.getElementById("phoneNumber").value;
            var fullName = document.getElementById("fullName").value;

            $.ajax({
                method: "POST",
                url: "http://localhost:8080/Project_SWP_Group2/login/signup",
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
                        window.location.href = "login.jsp";
                    } else {
//                        alert('Your username or email is already exists');
                        $("#message").html("Your username or email is already exists");
                        document.getElementById("message").style.color = "red";

                    }
                },
                error: function (xhr, textStatus, errorThrown) {
                    console.log("AJAX Error: " + textStatus + " (" + errorThrown + ")");
                }
            });
        }
    });


})
