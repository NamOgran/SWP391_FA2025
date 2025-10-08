/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

        document.addEventListener("DOMContentLoaded", function() {
        const editInfoBtn = document.querySelector('.edit-info-btn');
                const dropdownContainer = document.querySelector('.dropdown-container');
                const userInfo = document.querySelector('.info');
                editInfoBtn.addEventListener('click', function() {
                if (dropdownContainer.style.display === "none") {
                dropdownContainer.style.display = "block";
                        userInfo.style.display = "none";
                } else {
                dropdownContainer.style.display = "none";
                        userInfo.style.display = "block";
                }
                });
                });

