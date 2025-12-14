/*
 * File: js/googleLogin.js
 * Updated: Removed obsolete getURL logic causing "null" error
 */

function loginWithGoogle() {
    console.log("loginWithGoogle function called!");

    // CẤU HÌNH GOOGLE OAUTH
    const clientId = '374822286993-ui3durfgknmnkvpb6jhllng951hnvmb8.apps.googleusercontent.com';
    const redirectUri = 'http://localhost:8080/Project_SWP391_Group4/google-callback';
    const scope = 'email profile';

    const googleAuthUrl = `https://accounts.google.com/o/oauth2/v2/auth?client_id=${clientId}&redirect_uri=${encodeURIComponent(redirectUri)}&response_type=code&scope=${encodeURIComponent(scope)}&access_type=offline&prompt=consent`;

    window.location.href = googleAuthUrl;
}

// Hàm tiện ích cho UI (Header)
function toggleBox(boxId) {
    var box = document.getElementById(boxId);
    if (box) {
        if (box.style.display === "block") {
            box.style.display = "none";
        } else {
            box.style.display = "block";
        }
    }
}

// ĐÃ XÓA: getURL() và document.addEventListener('DOMContentLoaded'...)