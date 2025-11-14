/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

function loginWithGoogle() {
    console.log("loginWithGoogle function called!");

    // Đảm bảo Client ID này khớp với Client ID từ Google Cloud Console của bạn
    const clientId = '374822286993-ui3durfgknmnkvpb6jhllng951hnvmb8.apps.googleusercontent.com';

    // Đảm bảo Redirect URI này khớp với URI trong Google Cloud Console và trong Servlet của bạn
    const redirectUri = 'http://localhost:8080/Project_SWP391_Group4/google-callback';

    const scope = 'email profile'; // Các thông tin bạn muốn lấy từ Google

    // Cẩn thận với cú pháp template literal: chỉ một cặp backtick cho toàn bộ chuỗi
    const googleAuthUrl = `https://accounts.google.com/o/oauth2/v2/auth?client_id=${clientId}&redirect_uri=${encodeURIComponent(redirectUri)}&response_type=code&scope=${encodeURIComponent(scope)}&access_type=offline&prompt=consent`;

    // Chuyển hướng trình duyệt đến URL của Google
    window.location.href = googleAuthUrl;
}

// Nếu bạn có các hàm JavaScript khác (như getURL, toggleBox) không liên quan trực tiếp đến login Google,
// bạn có thể giữ chúng trong file JSP hoặc tách ra các file JS khác.
// Tuy nhiên, để tiện cho việc debug và thống nhất, tôi sẽ giả định bạn muốn giữ các hàm
// đã có của bạn cùng với hàm loginWithGoogle trong cùng một file này.

// Ví dụ các hàm khác từ JSP của bạn (nếu bạn muốn di chuyển chúng vào đây):
function getURL() {
    var accountType = document.getElementById("account").value;
    var form = document.getElementById("loginForm");

    if (accountType === "customer") {
        form.action = "http://localhost:8080/Project_SWP391_Group4/login/customer";
    } else if (accountType === "staff") {
        form.action = "http://localhost:8080/Project_SWP391_Group4/login/staff";
    }
}

document.addEventListener('DOMContentLoaded', function () {
    getURL(); // Gọi hàm getURL khi DOM đã tải xong
});

function toggleBox(boxId) {
    var box = document.getElementById(boxId);
    if (box.style.display === "block") {
        box.style.display = "none";
    } else {
        box.style.display = "block";
    }
}

