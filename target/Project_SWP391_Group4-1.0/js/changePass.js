/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


$(document).ready(function () {
    $('.btn-changePass').click(function (e) {
        e.preventDefault();
        var currentPass = document.getElementById("currentPassword").value;
        var newPassword1 = document.getElementById("newPassword1").value;
        var newPassword2 = document.getElementById("newPassword2").value;
        var input = getCookie("input");
        if (newPassword1 === newPassword2) {
            $.ajax({
                method: "Get",
                url: "http://localhost:8080/Project_SWP_Group2/profile/changePassword",
                data: {
                    input: input,
                    currentPassword: currentPass,
                    newPassword: newPassword2
                }
            })
                    .done(function (data) {
                        var data1 = JSON.parse(data);
                        console.log(data1);
                        if (data1.isSuccess) {

                            $("#message").html("Change password successfully");
                            document.getElementById("message").style.color = "#009900";
////                     
                        } else {
                            $("#message").html("Your current password is incorrect");
                            document.getElementById("message").style.color = "red";



                        }
                    });
        } else {
            $("#message").html("Password is not match!");
            document.getElementById("message").style.color = "red";
//            alert('alo')
        }
//         

    })
})

function getCookie(name) {
    var cookieName = name + "=";
    var decodedCookie = decodeURIComponent(document.cookie);
    var cookieArray = decodedCookie.split(';');

    for (var i = 0; i < cookieArray.length; i++) {
        var cookie = cookieArray[i].trim();
        if (cookie.indexOf(cookieName) === 0) {
            return cookie.substring(cookieName.length, cookie.length);
        }
    }
    return "";
}