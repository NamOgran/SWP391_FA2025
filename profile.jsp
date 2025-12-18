<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%-- [MỚI] IMPORT DAO ĐỂ LẤY DỮ LIỆU ĐƠN HÀNG CHO SIDEBAR --%>
<%@page import="DAO.OrderDAO"%>
<%@page import="entity.Orders"%>
<%@page import="java.util.List"%>
<%@page import="entity.Customer"%>

<%-- 1. Login Requirement --%>
<c:if test="${empty sessionScope.acc}">
    <c:redirect url="${pageContext.request.contextPath}/login.jsp"/>
</c:if>
<c:set var="acc" value="${sessionScope.acc}" />

<%
    // [MỚI] LOGIC TỰ ĐỘNG LẤY DANH SÁCH ĐƠN HÀNG
    // Giúp Sidebar hiển thị số lượng badge ngay cả khi vào trang Profile trực tiếp
    if (session.getAttribute("acc") != null) {
        Customer currentAcc = (Customer) session.getAttribute("acc");
        OrderDAO orderDAO = new OrderDAO();
        List<Orders> listOrders = orderDAO.orderUser(currentAcc.getCustomer_id());
        request.setAttribute("ordersUserList", listOrders);
    }
%>

<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>My Profile | GIO</title>

        <%-- Bootstrap CSS --%>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-iYQeCzEYFbKjA/T2uDLTpkwGzCiq6soy8tYaI1GyVh/UjpbCx/TYkiZhlZB6+fzT" crossorigin="anonymous">
        <%-- Bootstrap Icons --%>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <%-- Font Family --%>
        <link href='https://fonts.googleapis.com/css?family=Quicksand:400,500,600,700&display=swap' rel='stylesheet'>
        <%-- Font-Awesome --%>
        <script src="https://kit.fontawesome.com/1bd876819f.js" crossorigin="anonymous"></script>

        <link rel="icon" href="${pageContext.request.contextPath}/images/LG2.png" type="image/x-icon">

        <style>
            :root {
                --primary-color: #a0816c;
                --primary-hover: #8c7362;
                --bg-overlay: rgba(255, 255, 255, 0.95);
                --glass-border: 1px solid rgba(255, 255, 255, 0.2);
                --shadow-soft: 0 10px 30px rgba(160, 129, 108, 0.15);
                --text-main: #5a5a5a;
            }

            body {
                font-family: 'Quicksand', sans-serif;
                background-image: url("${pageContext.request.contextPath}/images/BG2.jpeg");
                background-size: cover;
                background-attachment: fixed;
                background-position: center;
                color: var(--text-main);
                min-height: 100vh;
            }

            /* Scrollbar custom */
            body::-webkit-scrollbar {
                width: 8px;
            }
            body::-webkit-scrollbar-track {
                background: #f1f1f1;
            }
            body::-webkit-scrollbar-thumb {
                background: var(--primary-color);
                border-radius: 4px;
            }

            .main-content-wrapper {
                max-width: 1140px;
                margin: 50px auto;
                padding: 0 15px;
            }

            .page-header {
                text-align: center;
                margin-bottom: 40px;
                color: #fff;
                text-shadow: 0 2px 4px rgba(0,0,0,0.3);
            }
            .page-header h2 {
                font-weight: 700;
                letter-spacing: 1px;
            }

            /* === NAVIGATION SIDEBAR (STICKY) === */
            .account-nav-card {
                background: var(--bg-overlay);
                backdrop-filter: blur(10px);
                border-radius: 15px;
                box-shadow: var(--shadow-soft);
                overflow: hidden;
                border: var(--glass-border);

                position: -webkit-sticky;
                position: sticky;
                top: 150px;
                z-index: 90;
            }

            .account-user-mini {
                padding: 30px 20px;
                text-align: center;
                background: linear-gradient(135deg, var(--primary-color), #cbb4a3);
                color: white;
            }

            .avatar-circle {
                width: 80px;
                height: 80px;
                background: rgba(255,255,255,0.25);
                border-radius: 50%;
                margin: 0 auto 15px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 32px;
                border: 2px solid rgba(255,255,255,0.5);
            }

            .account-nav {
                padding: 10px 0;
                margin: 0;
                list-style: none;
            }

            .account-nav-link {
                display: flex;
                align-items: center;
                padding: 15px 25px;
                color: var(--text-main);
                text-decoration: none;
                font-weight: 600;
                transition: all 0.3s ease;
                border-left: 4px solid transparent;
                justify-content: space-between; /* Đẩy badge sang phải */
            }

            .account-nav-link > div {
                display: flex;
                align-items: center;
            } /* Wrapper text + icon */
            .account-nav-link i {
                margin-right: 15px;
                width: 20px;
                text-align: center;
                font-size: 1.1rem;
            }

            .account-nav-link:hover {
                background-color: #fff8f3;
                color: var(--primary-color);
                padding-left: 30px;
            }

            .account-nav-link.active {
                background-color: #fff8f3;
                color: var(--primary-color);
                border-left-color: var(--primary-color);
            }

            .badge-sidebar {
                background-color: #dc3545;
                color: white;
                border-radius: 50%;
                padding: 2px 8px;
                font-size: 0.8rem;
            }

            /* === PROFILE MAIN CONTENT === */
            .profile-card {
                background: var(--bg-overlay);
                border-radius: 15px;
                box-shadow: var(--shadow-soft);
                padding: 40px;
                position: relative;
                min-height: 500px;
                border: var(--glass-border);
            }

            .section-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 30px;
                padding-bottom: 15px;
                border-bottom: 2px solid #eee;
            }

            .section-header h4 {
                font-weight: 700;
                color: var(--primary-color);
                margin: 0;
            }

            .btn-icon-edit {
                background: none;
                border: none;
                color: #aaa;
                font-size: 1.4rem;
                transition: color 0.3s;
            }
            .btn-icon-edit:hover {
                color: var(--primary-color);
            }

            /* View Mode Styling */
            .info-grid {
                display: grid;
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .info-item {
                display: flex;
                align-items: center;
                padding: 15px;
                background: #fff;
                border-radius: 10px;
                border: 1px solid #eee;
                transition: transform 0.2s;
            }
            .info-item:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            }

            .info-icon {
                width: 45px;
                height: 45px;
                background-color: #f8f5f2;
                border-radius: 10px;
                display: flex;
                align-items: center;
                justify-content: center;
                color: var(--primary-color);
                margin-right: 15px;
                font-size: 1.2rem;
            }

            .info-content small {
                display: block;
                font-weight: 600;
                color: #999;
                text-transform: uppercase;
                font-size: 0.75rem;
                margin-bottom: 3px;
            }
            .info-content span {
                font-size: 1.05rem;
                font-weight: 500;
                color: #333;
            }

            /* Edit Form Styling - Transitions */
            .edit-form-wrapper {
                max-height: 0;
                opacity: 0;
                overflow: hidden;
                transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
            }

            .edit-form-wrapper.active {
                max-height: 800px; /* Đủ lớn để chứa form */
                opacity: 1;
                margin-top: 20px;
            }

            /* Bootstrap Floating Labels Customization */
            .form-floating > .form-control:focus ~ label,
            .form-floating > .form-control:not(:placeholder-shown) ~ label {
                color: var(--primary-color);
                opacity: 0.8;
            }
            .form-control:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 0.25rem rgba(160, 129, 108, 0.25);
            }
            .form-control {
                border-radius: 8px;
                border: 1px solid #e0e0e0;
            }

            /* Buttons */
            .action-buttons {
                display: flex;
                gap: 15px;
                margin-top: 25px;
                justify-content: flex-end;
            }
            .btn-custom-primary {
                background-color: var(--primary-color);
                color: #fff;
                border: none;
                padding: 10px 30px;
                border-radius: 8px;
                font-weight: 600;
                transition: all 0.3s;
            }
            .btn-custom-primary:hover {
                background-color: var(--primary-hover);
                transform: translateY(-2px);
            }
            .btn-custom-secondary {
                background-color: #f1f1f1;
                color: #555;
                border: none;
                padding: 10px 25px;
                border-radius: 8px;
                font-weight: 600;
                transition: all 0.3s;
            }
            .btn-custom-secondary:hover {
                background-color: #e2e2e2;
            }

            /* Error Messages */
            label.error {
                color: #dc3545;
                font-size: 0.85rem;
                margin-top: 5px;
                display: block;
            }
            .server-error {
                color: #dc3545;
                background: #ffe6e6;
                padding: 10px;
                border-radius: 8px;
                text-align: center;
                margin-bottom: 20px;
            }

            /* Loading */
            .loading-overlay {
                position: absolute;
                inset: 0;
                background: rgba(255,255,255,0.9);
                z-index: 50;
                border-radius: 15px;
                display: flex;
                justify-content: center;
                align-items: center;
                transition: opacity 0.4s;
            }
            .loading-overlay.hidden {
                opacity: 0;
                pointer-events: none;
            }
            .spinner-border {
                color: var(--primary-color);
                width: 3rem;
                height: 3rem;
            }
            /* Back to Top Button */
            #btn-back-to-top {
                position: fixed;
                bottom: 30px;
                right: 30px;
                display: none;
                background-color: var(--primary-color);
                color: white;
                border: none;
                width: 50px;
                height: 50px;
                border-radius: 50%;
                font-size: 1.5rem;
                z-index: 100;
                cursor: pointer;
                box-shadow: 0 4px 10px rgba(0,0,0,0.3);
                transition: all 0.3s;
            }
            #btn-back-to-top:hover {
                background-color: var(--primary-color);
                transform: translateY(-5px);
            }

        </style>
    </head>

    <body>

        <%@ include file="header.jsp" %>

        <main class="main-content-wrapper">

            <%-- 
                1. TÍNH TOÁN SỐ LƯỢNG CHO SIDEBAR 
                (Sử dụng danh sách ordersUserList được lấy tự động ở đầu trang)
            --%>
            <c:set var="countPending" value="0" />
            <c:set var="countDelivering" value="0" />
            <c:set var="countDelivered" value="0" />
            <c:set var="countCancelled" value="0" />

            <c:if test="${not empty requestScope.ordersUserList}">
                <c:forEach items="${requestScope.ordersUserList}" var="o">
                    <c:if test="${o.status eq 'Pending'}"><c:set var="countPending" value="${countPending + 1}" /></c:if>
                    <c:if test="${o.status eq 'Delivering'}"><c:set var="countDelivering" value="${countDelivering + 1}" /></c:if>
                    <c:if test="${o.status eq 'Delivered' || o.status eq 'Completed'}"><c:set var="countDelivered" value="${countDelivered + 1}" /></c:if>
                    <c:if test="${o.status eq 'Cancelled'}"><c:set var="countCancelled" value="${countCancelled + 1}" /></c:if>
                </c:forEach>
            </c:if>

            <c:set var="totalActive" value="${countPending + countDelivering}" />
            <c:set var="totalHistory" value="${countDelivered + countCancelled}" />

            <div class="row g-4">

                <%-- === LEFT COLUMN: NAVIGATION (STICKY) === --%>
                <div class="col-lg-4 col-md-5">
                    <div class="account-nav-card">
                        <div class="account-user-mini">
                            <div class="avatar-circle">
                                <i class="fa-solid fa-user"></i>
                            </div>
                            <h5 class="mb-1 fw-bold text-white">${acc.username}</h5>
                            <small class="text-white-50">Member</small>
                        </div>
                        <ul class="account-nav">
                            <li>
                                <a href="${pageContext.request.contextPath}/profile" class="account-nav-link active">
                                    <div><i class="fa-solid fa-user-circle"></i> My Profile</div>
                                </a>
                            </li>

                            

                            <c:if test="${empty acc.google_id}">
                                <li>
                                    <a href="${pageContext.request.contextPath}/changePassword.jsp" class="account-nav-link">
                                        <div><i class="fa-solid fa-key"></i> Change Password</div>
                                    </a>
                                </li>
                            </c:if>

                            <li>
                                <a href="${pageContext.request.contextPath}/orderView" class="account-nav-link">
                                    <div><i class="fa-solid fa-box"></i> My Orders</div>
                                    <%-- SIDEBAR COUNT (ACTIVE) --%>
                                    <c:if test="${totalActive > 0}">
                                        <span class="badge-sidebar">${totalActive}</span>
                                    </c:if>
                                </a>
                            </li>
                            <li>
                                <a href="${pageContext.request.contextPath}/orderHistoryView" class="account-nav-link">
                                    <div><i class="fa-solid fa-clock-rotate-left"></i> Order History</div>
                                </a>
                            </li>
                            <li>
                            <a href="${pageContext.request.contextPath}/my-feedback" class="account-nav-link">
                                <div><i class="fa-solid fa-star"></i> My Feedbacks</div>
                            </a>
                        </li>
                            <li>
                                <a href="${pageContext.request.contextPath}/cookieHandle" class="account-nav-link text-danger" onclick="return confirm('Do you want to sign out?')">
                                    <div><i class="fa-solid fa-right-from-bracket"></i> Sign Out</div>
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>

                <%-- === RIGHT COLUMN: CONTENT === --%>
                <div class="col-lg-8 col-md-7">
                    <div class="profile-card">

                        <%-- Loading Overlay --%>
                        <div class="loading-overlay" id="loading-overlay">
                            <div class="spinner-border" role="status">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                        </div>

                        <%-- Header Section inside Card --%>
                        <div class="section-header">
                            <h4>Profile Information</h4>
                            <button type="button" class="btn-icon-edit" id="btn-toggle-edit" title="Edit Profile">
                                <i class="fa-regular fa-pen-to-square"></i>
                            </button>
                        </div>

                        <%-- Server Error Message --%>
                        <c:if test="${not empty errorMessage}">
                            <div class="server-error"><i class="fa-solid fa-triangle-exclamation"></i> ${errorMessage}</div>
                        </c:if>

                        <div id="main-content-area">

                            <%-- VIEW MODE: INFO LIST --%>
                            <div class="info-grid" id="view-mode">
                                <div class="info-item">
                                    <div class="info-icon"><i class="fa-regular fa-user"></i></div>
                                    <div class="info-content">
                                        <small>Full Name</small>
                                        <span data-field="fullName">${fullName}</span>
                                    </div>
                                </div>

                                <div class="info-item">
                                    <div class="info-icon"><i class="fa-regular fa-envelope"></i></div>
                                    <div class="info-content">
                                        <small>Email Address</small>
                                        <span data-field="email">${email}</span>
                                    </div>
                                </div>

                                <div class="info-item">
                                    <div class="info-icon"><i class="fa-solid fa-phone"></i></div>
                                    <div class="info-content">
                                        <small>Phone Number</small>
                                        <span data-field="phoneNumber">${phoneNumber}</span>
                                    </div>
                                </div>

                                <div class="info-item">
                                    <div class="info-icon"><i class="fa-solid fa-location-dot"></i></div>
                                    <div class="info-content">
                                        <small>Address</small>
                                        <span data-field="address">${address}</span>
                                    </div>
                                </div>
                            </div>

                            <%-- EDIT MODE: FORM --%>
                            <div class="edit-form-wrapper" id="edit-mode">
                                <form action="${pageContext.request.contextPath}/profile/update" method="GET" id="edit-profile-form">

                                    <div class="row g-3">
                                        <%-- Full Name --%>
                                        <div class="col-md-12">
                                            <div class="form-floating">
                                                <input type="text" class="form-control" id="fullName" name="fullName" placeholder="Full Name" value="${fullName}" required maxlength="100">
                                                <label for="fullName">Full Name</label>
                                            </div>
                                        </div>

                                        <%-- Email (Readonly) --%>
                                        <div class="col-md-6">
                                            <div class="form-floating">
                                                <input type="email" class="form-control" id="email" name="email" placeholder="name@example.com" value="${email}" readonly style="background-color: #f8f9fa;">
                                                <label for="email">Email (Readonly)</label>
                                            </div>
                                        </div>

                                        <%-- Phone --%>
                                        <div class="col-md-6">
                                            <div class="form-floating">
                                                <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber" placeholder="Phone Number" value="${phoneNumber}" required>
                                                <label for="phoneNumber">Phone Number</label>
                                            </div>
                                        </div>

                                        <%-- Address --%>
                                        <div class="col-12">
                                            <div class="form-floating">
                                                <input type="text" class="form-control" id="address" name="address" placeholder="Address" value="${address}" required maxlength="255">
                                                <label for="address">Address</label>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="action-buttons">
                                        <button type="button" class="btn-custom-secondary" id="btn-cancel">Cancel</button>
                                        <button type="submit" class="btn-custom-primary">Save Changes</button>
                                    </div>
                                </form>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </main>

        <button type="button" class="btn" id="btn-back-to-top">
            <i class="bi bi-arrow-up"></i>
        </button>

        <%@ include file="footer.jsp" %>

        <%-- SCRIPT --%>
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.5/dist/jquery.validate.min.js"></script>

        <script>
                                    $(document).ready(function () {
                                        // Elements
                                        const $viewMode = $('#view-mode');
                                        const $editMode = $('#edit-mode');
                                        const $btnToggle = $('#btn-toggle-edit');
                                        const $btnCancel = $('#btn-cancel');
                                        const $loadingOverlay = $('#loading-overlay');
                                        const $form = $('#edit-profile-form');

                                        // Initial Data Storage (to revert on Cancel)
                                        let initialData = {};
                                        $form.find('input').each(function () {
                                            initialData[this.name] = $(this).val();
                                        });

                                        // Loading Simulation
                                        setTimeout(function () {
                                            $loadingOverlay.addClass('hidden');
                                            setTimeout(() => $loadingOverlay.hide(), 400);
                                        }, 500);

                                        // Validation Setup
                                        $.validator.addMethod("vietnamesePhone", function (value, element) {
                                            return this.optional(element) || /^0[0-9]{9,10}$/.test(value);
                                        }, "Phone number must start with 0 and have 10-11 digits.");

                                        $form.validate({
                                            errorClass: "error",
                                            validClass: "is-valid",
                                            errorElement: "label",
                                            rules: {
                                                fullName: {required: true, maxlength: 100},
                                                address: {required: true, maxlength: 255},
                                                phoneNumber: {required: true, vietnamesePhone: true}
                                            },
                                            messages: {
                                                fullName: {required: "Please enter your full name."},
                                                address: {required: "Please enter your address."},
                                                phoneNumber: {required: "Please enter your phone number."}
                                            },
                                            highlight: function (element) {
                                                $(element).addClass("is-invalid").removeClass("is-valid");
                                            },
                                            unhighlight: function (element) {
                                                $(element).removeClass("is-invalid").addClass("is-valid");
                                            }
                                        });

                                        // Functions to Switch Modes
                                        function showEdit() {
                                            $viewMode.slideUp(300);
                                            $editMode.addClass('active');
                                            $btnToggle.hide(); // Hide the pen icon when editing
                                        }

                                        function hideEdit() {
                                            $editMode.removeClass('active');
                                            setTimeout(function () {
                                                $viewMode.slideDown(300);
                                                $btnToggle.fadeIn();
                                            }, 300);

                                            // Reset Form
                                            $form.validate().resetForm();
                                            $form.find('.is-invalid, .is-valid').removeClass('is-invalid is-valid');

                                            // Restore values
                                            $form.find('input').each(function () {
                                                $(this).val(initialData[this.name]);
                                            });
                                        }

                                        // Events
                                        $btnToggle.on('click', showEdit);
                                        $btnCancel.on('click', hideEdit);

                                        // Logic: If Server returned error, stay in Edit mode
            <c:if test="${not empty errorMessage}">
                                        setTimeout(showEdit, 600); // Wait for loading to finish then show form
            </c:if>
                                    });
                                    // --- 2. BACK TO TOP BUTTON ---
                                    let mybutton = document.getElementById("btn-back-to-top");

                                    window.onscroll = function () {
                                        scrollFunction();
                                    };

                                    function scrollFunction() {
                                        if (document.body.scrollTop > 300 || document.documentElement.scrollTop > 300) {
                                            mybutton.style.display = "block";
                                        } else {
                                            mybutton.style.display = "none";
                                        }
                                    }

                                    mybutton.addEventListener("click", backToTop);

                                    function backToTop() {
                                        document.body.scrollTop = 0;
                                        document.documentElement.scrollTop = 0;
                                    }
        </script>
    </body>
</html>