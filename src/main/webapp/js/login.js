/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */
const loginForm = document.getElementById("loginForm");

// Xóa cookie cũ
document.cookie = "code=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
document.cookie = "input=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
document.cookie = "email=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";

function getURL() {
    const type = document.getElementById("account").value;
    let url = "";

    if (type === "customer") {
        url = "http://localhost:8080/Project_SWP391_Group4/login/customer";
    } else if (type === "staff") {
        url = "http://localhost:8080/Project_SWP391_Group4/login/staff";
    }

    loginForm.action = url;
}

// Xử lý reCAPTCHA và gửi form
window.onload = function () {
    const error = document.getElementById("error");

    loginForm.addEventListener("submit", function (e) {
        e.preventDefault();

        const res = grecaptcha.getResponse();
        if (res) {
            const input = document.getElementById('input').value;
            document.cookie = "input=" + input;
            loginForm.submit();
        } else {
            error.innerHTML = "Please check";
            error.style.color = "red";
        }
    });
};
