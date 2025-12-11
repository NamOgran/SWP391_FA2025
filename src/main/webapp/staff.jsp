<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.text.DecimalFormat"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="entity.Staff" %>
<%-- === BỔ SUNG BASE_URL === --%>
<c:set var="BASE_URL" value="${pageContext.request.contextPath}" />

<%
    // Lấy session
    Staff s = (Staff) session.getAttribute("staff");
    // Object c = session.getAttribute("acc"); // Dòng này không cần thiết cho logic chặn, nhưng giữ lại nếu bạn cần dùng bên dưới

    // 1. Kiểm tra đăng nhập (Chặn khách vãng lai và Customer)
    // Nếu s == null nghĩa là chưa đăng nhập vào tài khoản thuộc bảng Staff
    if (s == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // 2. Kiểm tra quyền hạn (Role)
    // Yêu cầu: CHỈ Staff được vào. Admin không được vào.
    String role = s.getRole();
    
    // Nếu role KHÔNG PHẢI là "staff" (ví dụ là "admin") thì chuyển hướng
    if (!"staff".equalsIgnoreCase(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); 
        // Hoặc bạn có thể redirect về trang thông báo lỗi 403 (Access Denied) nếu muốn rõ ràng hơn
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-iYQeCzEYFbKjA/T2uDLTpkwGzCiq6soy8tYaI1GyVh/UjpbCx/TYkiZhlZB6+fzT" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link href='https://fonts.googleapis.com/css?family=Quicksand' 
              rel='stylesheet'> <link rel="icon" href="${BASE_URL}/images/LG2.png" type="image/x-icon"> <%-- SỬA ĐƯỜNG DẪN --%>
        <script src="https://kit.fontawesome.com/1bd876819f.js" crossorigin="anonymous"></script>
        <style>
            /* ===== BASE LAYOUT & FONTS ===== */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: "Quicksand", sans-serif;
            }

            html, body {
                height: 100%;
                overflow: hidden; /* Ngăn cuộn trang chính khi sidebar trượt */
            }

            body {
                display: flex;
                flex-direction: column;
            }

            /* ===== HEADER (LAYOUT MỚI) ===== */
            header {
                height: 50px;
                background-color: #a0816c;
                padding: 0 20px; /* Thêm padding 2 bên */
                flex-shrink: 0;
            }

            .header-top {
                width: 100%;
                height: 100%;
                display: flex;
                justify-content: space-between; /* Đẩy 2 nhóm sang 2 bên */
                align-items: center;
            }

            /* Nhóm bên TRÁI: Nút Toggle + Logo */
            .header-left {
                display: flex;
                align-items: center;
                gap: 15px;
            }


            .header-top * {
                color: white; /* Đảm bảo text trong header màu trắng */
            }

            /* Nhóm bên PHẢI: Info + Signout */
            .admin-info {
                display: flex;
                align-items: center;
            }

            .admin-name,
            .signout {
                margin: 0 10px;
            }

            .signout a {
                text-decoration: none;
                color: white;
            }
            .signout a:hover {
                color: #f3eae5;
            }

            /* ===== MAIN CONTAINER ===== */
            .main {
                display: flex;
                flex: 1;
                height: calc(100vh - 50px); /* Chiều cao còn lại sau khi trừ header */
                position: relative;
            }

            /* ===== SIDEBAR NAV (COLLAPSIBLE) ===== */
            /* Dùng .main > nav để chỉ tác động vào menu trái, TRÁNH ảnh hưởng đến phân trang */
            .main > nav {
                width: 250px; /* Độ rộng mặc định */
                background-color: #b4acac;
                flex-shrink: 0;
                transition: width 0.3s ease; /* Hiệu ứng trượt */
                overflow: hidden;
                height: 100%;
            }

            /* Class thu nhỏ */
            .main > nav.collapsed {
                width: 60px;
            }

            .nav-list {
                list-style-type: none;
                padding: 0;
                margin: 0;
                height: 100%;
                width: 250px; /* Giữ nguyên độ rộng list để chữ không bị xuống dòng */
            }

            .nav-list li {
                border-bottom: 1px solid rgba(0, 0, 0, 0.06);
            }

            /* --- SỬA/THÊM: Hiệu ứng nhấn cho Sidebar Links --- */
            .nav-list li a {
                text-decoration: none;
                color: white;
                display: flex;
                align-items: center;
                padding: 12px 20px;
                gap: 15px;
                white-space: nowrap;
                transition: background-color 0.2s, transform 0.1s; /* Thêm transition transform */
            }

            /* Hiệu ứng khi nhấn chuột vào menu sidebar */
            .nav-list li a:active {
                background-color: rgba(255, 255, 255, 0.1);
                transform: scale(0.96); /* Thu nhỏ lại tạo cảm giác nhấn */
            }

            .nav-list li:hover, .nav-list li a.active {
                background-color: rgb(122, 117, 120);
            }

            .nav-list li i {
                font-size: 1.2em;
                width: 25px;
                text-align: center;
            }

            /* Ẩn chữ trong menu khi thu nhỏ */
            .main > nav.collapsed .nav-list li a span {
                opacity: 0;
                visibility: hidden;
                transition: opacity 0.2s;
            }

            /* RESPONSIVE TRÊN ĐIỆN THOẠI */
            @media (max-width: 768px) {
                .main > nav {
                    width: 100%;
                    height: auto;
                }
                .main > nav.collapsed {
                    width: 100%; /* Trên mobile không thu nhỏ kiểu này */
                }
                .nav-list {
                    width: 100%;
                }
            }

            /* ===== MAIN CONTENT WRAPPER ===== */
            .main-content {
                flex: 1; /* Tự động chiếm hết khoảng trống còn lại */
                padding: 30px 40px;
                overflow-y: auto; /* Cho phép cuộn nội dung chính */
                background: radial-gradient(circle at top left, #ffffff 0, #f6f7fb 55%, #eceef3 100%);
            }

            .main-content > div {
                display: none; /* Ẩn các tab chưa active */
            }

            .main-content h3 {
                margin-bottom: 12px;
                color: #1f2933;
                font-size: 1.3rem;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .main-content hr {
                margin-bottom: 20px;
                border-color: rgba(0, 0, 0, 0.06);
            }

            /* ===== PRODUCT MANAGEMENT ===== */
            .product-manage .filter {
                display: flex;
                gap: 10px;
                margin-bottom: 15px;
            }

            .product-manage select,
            .product-manage input[type="text"] {
                padding: 6px 10px;
                border-radius: 4px;
                border: 1px solid #ccc;
                outline: none;
            }

            .product-table .table tbody tr th {
                width: 6%;
            }

            .product-table .table tbody tr th img {
                width: 100%;
                height: 100px;
                object-fit: cover;
            }

            .product-table .td-button {
                width: 15%;
            }

            /* ===== ADD / EDIT BOX (FORM) ===== */
            .add-box {
                max-width: 50%;
                margin: 0 auto;
                padding: 20px;
                border: 1px solid #a0816c;
                border-radius: 5px;
                background-color: #fff;
            }

            .add-box h1 {
                text-align: center;
                color: #a0816c;
                font-size: 1.5rem;
                margin-bottom: 10px;
            }

            .add-box input {
                width: 100%;
                border: none;
                border-bottom: 1px solid #a0816c;
                margin: 15px 0;
                padding: 10px 5px;
                outline: none;
            }

            .add-box .row button {
                background-color: #a0816c;
                width: 100%;
                color: white;
                border: none;
                height: 35px;
                border-radius: 4px;
            }

            .add-box select {
                width: 100%;
                border: 1px solid #a0816c;
                margin: 15px 0;
                padding: 10px 5px;
                outline: none;
                border-radius: 4px;
                background-color: #fff;
            }

            .add-box select option {
                border: none;
            }

            /* ===== PERSONAL INFO ===== */
            .personal-main {
                width: 50%;
                margin: 30px auto;
                box-shadow: rgba(0, 0, 0, 0.3) 0px 19px 38px,
                    rgba(0, 0, 0, 0.22) 0px 15px 12px;
                background-color: #fff;
            }

            .personal-main table {
                width: 100%;
                border-collapse: collapse;
            }

            .personal-main table th,
            .personal-main table td {
                padding: 8px 12px;
                text-align: left;
                border-bottom: 1px solid #ddd;
            }

            .personal-btn {
                text-align: center;
                margin: 20px 0;
            }

            .personal-btn button {
                border: none;
                background-color: #a0816c;
                color: white;
                padding: 6px 14px;
                border-radius: 5px;
                transition: all 0.3s ease;
            }

            .personal-btn button:hover {
                background-color: #af907b;
            }

            #edit-personal {
                display: none;
            }

            /* ===== ACCOUNT MANAGE (BASIC) ===== */
            .account-search {
                padding: 5px;
                outline: none;
                width: 20%;
            }

            .phoneNum-col {
                width: 12%;
            }

            /* ===== DASHBOARD (STATISTIC) ===== */
            .statistic {
                max-width: 100%;
                width: auto;
                margin: 0 auto;
                padding: 0 10px;
            }

            .btn-search-icon {
                background-color: #a0816c;
                color: white;
                border: none;
                padding: 6px 12px;
                border-radius: 4px;
                margin-left: 5px;
                cursor: pointer;
                transition: background 0.3s;
                height: 38px;
            }
            .btn-search-icon:hover {
                background-color: #af907b;
            }

            .card-container {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
                gap: 22px;
                margin: 16px 0 14px;
            }

            .card {
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                padding: 18px 22px;
                color: white;
                border-radius: 16px;
                box-shadow: 0 12px 24px rgba(15, 23, 42, 0.18);
                min-height: 110px;
                position: relative;
                overflow: hidden;
            }

            .card::after {
                content: "";
                position: absolute;
                right: -25px;
                top: -25px;
                width: 90px;
                height: 90px;
                border-radius: 50%;
                background: rgba(255, 255, 255, 0.18);
            }

            .card:first-child {
                background: linear-gradient(135deg, #ff4b5c 0%, #dc3545 100%);
            }
            .card:nth-child(2) {
                background: linear-gradient(135deg, #198754 0%, #26b36b 100%);
            }
            .card:nth-child(3) {
                background: linear-gradient(135deg, #ffc107 0%, #f7b924 100%);
                color: #333;
            }
            .card:nth-child(4) {
                background: linear-gradient(135deg, #0d6efd 0%, #2563eb 100%);
            }

            .card-inner {
                display: flex;
                align-items: center;
                justify-content: space-between;
                margin-bottom: 6px;
            }

            .card-inner h2 {
                font-size: 1.02em;
                margin: 0;
                font-weight: 500;
            }

            .card-inner > span {
                font-size: 2.3em;
                opacity: 0.9;
            }

            .card h1 {
                font-size: 1.9em;
                margin: 0;
                font-weight: 600;
                letter-spacing: 0.02em;
            }

            /* ===== YEAR FILTER (STAFF) ===== */
            .year-filter {
                display: flex;
                align-items: center;
                gap: 12px;
                margin: 8px 0 20px;
            }

            #mySelect {
                border-radius: 999px !important;
                border: 1px solid #e0e3eb;
                background-color: #ffffff;
                padding: 6px 20px;
                font-size: 0.9rem;
                color: #6b7280;
                outline: none;
                box-shadow: 0 4px 10px rgba(15, 23, 42, 0.08);
                appearance: none;
                -webkit-appearance: none;
                -moz-appearance: none;
            }

            #mySelect:hover {
                box-shadow: 0 6px 14px rgba(15, 23, 42, 0.12);
            }

            #date {
                border: none;
                border-radius: 999px !important;
                padding: 6px 22px;
                font-size: 0.9rem;
                font-weight: 500;
                background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
                color: #ffffff;
                cursor: pointer;
                box-shadow: 0 8px 18px rgba(37, 99, 235, 0.45);
                transition: all 0.18s ease-in-out;
            }

            #date:hover {
                transform: translateY(-1px);
                box-shadow: 0 10px 24px rgba(37, 99, 235, 0.55);
                filter: brightness(1.03);
            }

            #date:active {
                transform: translateY(0);
                box-shadow: 0 6px 14px rgba(37, 99, 235, 0.4);
            }

            /* Chart layout */
            .chart {
                margin-top: 4px;
                display: grid;
                grid-template-columns: minmax(260px, 330px) minmax(0, 1fr);
                gap: 22px;
                align-items: stretch;
            }

            @media (max-width: 992px) {
                .chart {
                    grid-template-columns: 1fr;
                }
            }

            .chart-container,
            .chart-container-col {
                background: rgba(255, 255, 255, 0.95);
                border-radius: 18px;
                padding: 14px 18px 16px;
                box-shadow: 0 10px 22px rgba(15, 23, 42, 0.14);
            }

            .chart-heading {
                font-family: "Quicksand", sans-serif;
                color: #023047;
                text-transform: uppercase;
                font-size: 0.9rem;
                font-weight: 600;
                margin-bottom: 8px;
                letter-spacing: 0.06em;
                text-align: center;
            }

            .my-chart,
            .my-chart-line {
                width: 100% !important;
                max-width: 100%;
            }

            .my-chart-line {
                max-height: 240px;
            }

            /* ===== ORDER TABLE / ORDER MANAGE ===== */
            .order-main {
                border-radius: 0.8rem;
                overflow: auto;
                box-shadow: 0 .4rem .8rem #0005;
                background-color: #fff;
            }

            .order-table {
                width: 100%;
                border-collapse: collapse;
            }

            .order-table th,
            .order-table td {
                padding: 1rem;
            }

            .order-table td {
                border: none;
            }

            .order-table thead {
                background-color: #7a777ffe;
                color: #fff;
            }

            .order-table tbody {
                background-color: #eff2f5;
            }

            .order-table tbody tr:hover {
                background-color: #fff6;
            }

            .tb-address {
                max-width: 300px;
            }

            .th-status, .cell-status {
                text-align: center !important;
            }

            .action-btn {
                text-align: right;
            }

            .status {
                padding: 0.4rem 0.9rem;
                border-radius: 2rem;
                text-align: center;
                background-color: #ebc474;
                margin: 0;
                display: inline-block;
                min-width: 110px;
            }

            .red {
                background-color: #d893a3;
                color: #b30021;
            }
            .green {
                background-color: #6fcaea;
            }
            .blue {
                background-color: #86e49d;
                color: #006b21;
            }

            .stt-Cancelled {
                background-color: #d893a3 !important;
                color: #b30021 !important;
            }
            .stt-Delivering {
                background-color: #6fcaea !important;
            }
            .stt-Completed {
                background-color: #86e49d !important;
                color: #006b21 !important;
            }
            .stt-Pending {
                background-color: #ebc474 !important;
            }

            .order-table button {
                height: 37px;
                width: 37px;
                border: none;
                border-radius: 6px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                cursor: pointer;
            }

            .accept-btn {
                background-color: rgb(59, 245, 59);
            }
            .reject-btn {
                background-color: red;
                color: white;
            }
            .view-btn {
                background-color: #7a777ffe;
                color: white;
            }

            .item {
                display: none;
            }

            /* ===== DROPDOWN CHI TIẾT ĐƠN HÀNG ===== */
            .order-detail-cell {
                padding: 0 !important;
                background-color: #f8f9fa;
            }

            .detail-table {
                width: 100%;
                margin: 0;
                border: none;
                border-collapse: collapse;
                background-color: #fff;
            }

            .detail-table th {
                padding: 10px 15px;
                background-color: #e9ecef;
                color: #333;
                text-align: left;
                border-bottom: 2px solid #dee2e6;
            }

            .detail-table td {
                padding: 10px 15px;
                border-top: 1px solid #e0e0e0;
                text-align: left;
            }

            .detail-table th:last-child,
            .detail-table td:last-child {
                text-align: right;
            }

            .view-btn i.bi-eye-slash {
                display: none;
            }
            .view-btn.active i.bi-eye {
                display: none;
            }
            .view-btn.active i.bi-eye-slash {
                display: inline-block;
            }

            /* ===== SEARCH FORM (ORDER) ===== */
            .search-form {
                display: flex;
                margin-bottom: 15px;
                max-width: 400px;
            }

            .search-input {
                flex-grow: 1;
                padding: 8px 12px;
                border: 1px solid #ccc;
                border-radius: 5px 0 0 5px;
                outline: none;
                font-size: 0.95rem;
            }

            .search-btn {
                border: none;
                background-color: #a0816c;
                color: white;
                padding: 0 12px;
                border-radius: 0 5px 5px 0;
                cursor: pointer;
            }

            .search-btn:hover {
                background-color: #af907b;
            }

            /* ===== CUSTOMER MANAGE ===== */
            .customer-manage .order-main {
                margin-top: 10px;
            }
            #customer-total {
                font-weight: 600;
            }
            .error {
                color: red;
            }

            /* ===== RESPONSIVE ===== */
            @media (max-width: 1100px) {
                .card-container {
                    grid-template-columns: repeat(2, minmax(0, 1fr));
                }
                .personal-main {
                    width: 70%;
                }
            }

            @media (max-width: 768px) {
                /* Trên Mobile thì chuyển thành cột dọc */
                .main {
                    flex-direction: column;
                    height: auto;
                }

                nav {
                    width: 100%;
                    height: auto;
                }
                nav.collapsed {
                    width: 100%;
                }

                .nav-list {
                    width: 100%;
                }

                .main-content {
                    padding: 20px;
                }
                .personal-main {
                    width: 90%;
                }
            }

            /* --- CSS NÂNG CẤP CHO MODAL IMPORT --- */
            .modal-content {
                border: none;
                border-radius: 12px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                overflow: hidden;
            }

            /* Header Modal: Màu chủ đạo, chữ trắng, bo góc trên */
            .modal-header {
                background-color: #a0816c;
                color: white;
                padding: 15px 25px;
                border-bottom: none;
            }

            .modal-header .modal-title {
                font-weight: 700;
                font-size: 1.2rem;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .modal-header .btn-close {
                filter: invert(1) grayscale(100%) brightness(200%); /* Làm nút đóng màu trắng */
                opacity: 0.8;
            }

            /* Khu vực Form nhập liệu */
            .import-form-container {
                background-color: #f8f9fa;
                padding: 20px;
                border-radius: 8px;
                border: 1px solid #e9ecef;
                margin-bottom: 20px;
            }

            .import-form-label {
                font-size: 0.85rem;
                font-weight: 600;
                color: #555;
                margin-bottom: 6px;
                text-transform: uppercase;
            }

            .form-control:focus, .form-select:focus {
                border-color: #a0816c;
                box-shadow: 0 0 0 0.25rem rgba(160, 129, 108, 0.25);
            }

            /* Nút Add Item */
            .btn-add-item {
                background-color: #2c3e50;
                color: white;
                border: none;
                width: 100%;
                height: 42px; /* Cao bằng input để thẳng hàng */
                margin-top: 29px; /* Căn chỉnh với label */
                border-radius: 6px;
                font-weight: 600;
                transition: all 0.2s;
            }

            .btn-add-item:hover {
                background-color: #1a252f;
                transform: translateY(-1px);
            }

            /* Bảng danh sách Item */
            .import-table-wrapper {
                border: 1px solid #e9ecef;
                border-radius: 8px;
                overflow: hidden;
                max-height: 300px; /* Scroll nếu dài quá */
                overflow-y: auto;
            }

            .import-table thead {
                background-color: #e9ecef;
                color: #495057;
                position: sticky;
                top: 0;
                z-index: 1;
            }

            .import-table th {
                font-weight: 600;
                font-size: 0.9rem;
                padding: 12px 15px;
                border: none;
            }

            .import-table td {
                padding: 10px 15px;
                vertical-align: middle;
                border-bottom: 1px solid #f1f1f1;
                font-size: 0.95rem;
            }

            /* Nút xóa dòng */
            .btn-remove-row {
                color: #dc3545;
                background: rgba(220, 53, 69, 0.1);
                border: none;
                width: 30px;
                height: 30px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: all 0.2s;
            }

            .btn-remove-row:hover {
                background: #dc3545;
                color: white;
            }

            /* Footer: Nút Submit to */
            .modal-footer-custom {
                padding: 20px;
                border-top: 1px solid #e9ecef;
                background-color: #fff;
                text-align: right;
            }

            .btn-submit-import {
                background: linear-gradient(135deg, #a0816c 0%, #8c6b5d 100%);
                color: white;
                padding: 10px 30px;
                font-size: 1rem;
                font-weight: 600;
                border: none;
                border-radius: 50px; /* Bo tròn kiểu viên thuốc */
                box-shadow: 0 4px 10px rgba(160, 129, 108, 0.3);
                transition: all 0.3s;
            }

            .btn-submit-import:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 15px rgba(160, 129, 108, 0.4);
                color: white;
            }

            /* STATUS CHO IMPORT */
            .stt-Pending {
                background-color: #fec81c !important;
                color: #856404 !important;
                border: 1px solid #ffeeba;
            }
            .stt-Completed, .stt-Delivered, .stt-Done {
                background-color: #39d12a !important;
                color: #0f5132 !important;
                border: 1px solid #badbcc;
            }
            .stt-delivered, .stt-Delivered {
                background-color: #86e49d !important;
                color: #006b21 !important;
                border: none;
            }

            /* IMPORT FORM ADD ITEM */
            .import-input-group {
                background-color: #f8f9fa;
                padding: 20px;
                border-radius: 10px;
                border: 1px dashed #a0816c;
                margin-bottom: 20px;
            }

            .import-input-group label {
                font-weight: 600;
                color: #495057;
                margin-bottom: 5px;
                display: block;
            }

            .import-input-group .form-control,
            .import-input-group .form-select {
                border: 1px solid #ced4da;
                padding: 10px;
                border-radius: 6px;
            }

            .import-input-group .btn-add {
                height: 45px;
                font-weight: bold;
                text-transform: uppercase;
                margin-top: 28px;
            }

            /* === CSS PHÂN TRANG (PAGINATION) === */
            .pagination-wrapper {
                display: flex;
                justify-content: center;
                align-items: center;
                margin-top: 30px;
                margin-bottom: 20px;
                width: 100%;
            }

            /* Reset style cho thẻ nav của phân trang để không bị xung đột */
            .pagination-wrapper nav,
            nav[aria-label="Import pagination"] {
                width: auto !important;
                background-color: transparent !important;
                height: auto !important;
            }

            .pagination {
                display: flex;
                padding-left: 0;
                list-style: none;
                gap: 5px;
                margin: 0;
                flex-wrap: wrap; /* Tránh vỡ khi màn hình nhỏ */
                justify-content: center;
            }

            .page-item .page-link {
                border: none;
                border-radius: 8px !important;
                color: #555;
                font-weight: 600;
                padding: 8px 16px;
                background-color: #fff;
                box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
                transition: all 0.3s ease-in-out;
            }

            .page-item:not(.active):not(.disabled) .page-link:hover {
                background-color: #a0816c;
                color: white;
                transform: translateY(-3px);
            }

            .page-item.active .page-link {
                background: linear-gradient(135deg, #a0816c 0%, #8c6b5d 100%);
                color: white;
                box-shadow: 0 4px 10px rgba(160, 129, 108, 0.4);
                pointer-events: none;
            }

            .page-item.disabled .page-link {
                background-color: #f1f3f5;
                color: #adb5bd;
                box-shadow: none;
                cursor: not-allowed;
            }

            .page-link i {
                font-size: 0.9rem;
            }

            /* Style cho đường dẫn trong Logo */
            .logo {
                font-size: 1.5em;
                font-weight: 600;
                color: white;
            }
            .logo a {
                text-decoration: none; /* Bỏ gạch chân */
                color: white;          /* Giữ chữ màu trắng */
                display: block;        /* Giúp bấm dễ hơn */
            }

            .logo a:hover {
                color: #f3eae5;        /* (Tùy chọn) Đổi màu nhẹ khi di chuột vào */
            }
            /* Nút 3 gạch (Hamburger) - Có hiệu ứng */
            .btn-toggle-sidebar {
                background: none;
                border: none;
                color: white;
                font-size: 1.5rem;
                cursor: pointer;

                /* Định hình kích thước để tạo hiệu ứng tròn */
                width: 40px;
                height: 40px;
                border-radius: 50%; /* Bo tròn hoàn toàn */

                /* Căn giữa icon */
                display: flex;
                align-items: center;
                justify-content: center;

                /* Hiệu ứng mượt mà */
                transition: all 0.2s ease;
            }

            /* Hiệu ứng khi di chuột vào (Hover) */
            .btn-toggle-sidebar:hover {
                background-color: rgba(255, 255, 255, 0.2); /* Nền trắng mờ 20% */
                transform: scale(1.1); /* Phóng to nhẹ 10% */
            }

            /* Hiệu ứng khi nhấn chuột (Active) */
            .btn-toggle-sidebar:active {
                background-color: rgba(255, 255, 255, 0.3); /* Nền sáng hơn chút */
                transform: scale(0.95); /* Thu nhỏ lại tạo cảm giác nhấn */
            }
            /* --- STAFF PROFILE DROPDOWN STYLES (FIXED) --- */
            .admin-info {
                position: relative;
                height: 100%;
                display: flex;
                align-items: center;
                gap: 15px;
            }

            /* Container cho tên và ảnh đại diện */
            .staff-profile-box {
                display: flex;
                align-items: center;
                gap: 8px;
                color: white;
                cursor: pointer;
                padding: 10px;
                border-radius: 4px;
                position: relative;
                transition: background-color 0.2s;
                user-select: none;
            }

            .staff-profile-box:hover {
                background-color: rgba(255, 255, 255, 0.1);
            }

            /* ĐÃ XÓA: .staff-profile-box:active (Hiệu ứng nhấn gây lỗi) */

            .staff-avatar {
                font-size: 1.5rem;
            }

            .staff-name-text {
                font-weight: 600;
                font-size: 0.95rem;
                max-width: 150px;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }

            /* Dropdown Menu Box */
            .staff-dropdown-menu {
                display: none;
                position: absolute;
                
                /* Vị trí hiển thị: Nâng lên một chút để dễ di chuột */
                top: 90%; 
                right: 0;
                
                background-color: #fff;
                min-width: 220px;
                box-shadow: 0 8px 24px rgba(0,0,0,0.15);
                border-radius: 8px;
                padding: 8px 0;
                list-style: none;
                z-index: 1001;
                transform-origin: top right;
                animation: fadeInDrop 0.2s ease-in-out;
            }

            /* Giữ menu hiển thị khi hover vào box hoặc chính menu */
            .staff-profile-box:hover .staff-dropdown-menu,
            .staff-dropdown-menu:hover {
                display: block;
            }

            .staff-dropdown-menu li a {
                display: flex;
                align-items: center;
                gap: 10px;
                padding: 10px 20px;
                text-decoration: none;
                color: #333;
                font-size: 14px;
                font-weight: 500;
                transition: background-color 0.2s;
            }

            .staff-dropdown-menu li a i {
                width: 20px;
                text-align: center;
                font-size: 1.1em;
                color: #777;
            }

            .staff-dropdown-menu li a:hover {
                background-color: #f4f7f6;
                color: #a0816c;
            }
            
            .staff-dropdown-menu li a:hover i {
                color: #a0816c;
            }

            .dropdown-divider {
                height: 1px;
                background-color: #eee;
                margin: 5px 0;
            }

            @keyframes fadeInDrop {
                from { opacity: 0; transform: translateY(10px); }
                to { opacity: 1; transform: translateY(0); }
            }
        </style>

    </head>

    <body>
        <header>
            <div class="header-top">
                <div class="header-left">
                    <button class="btn-toggle-sidebar" id="sidebarToggle">
                        <i class="bi bi-list"></i>
                    </button>
                    <div class="logo">
                        <a href="${BASE_URL}/staff">GIO Staff</a>
                    </div>
                </div>

                <div class="admin-info">
                    <div class="staff-profile-box">
                        <i class="bi bi-person-circle staff-avatar"></i>
                        <span class="staff-name-text">
                            Hello, <c:out value="${sessionScope.staff.fullName != null ? sessionScope.staff.fullName : sessionScope.staff.username}" default="Staff"/>
                        </span>
                        <i class="bi bi-caret-down-fill" style="font-size: 0.8em; margin-left: 5px;"></i>

                        <ul class="staff-dropdown-menu">
                            <li>
                                <a href="${BASE_URL}/cookieHandle" onclick="return confirm('Are you sure you want to Sign out?')">
                                    <i class="bi bi-box-arrow-right"></i> Sign Out
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </header>

        <div class="main">
            <nav>
                <ul class="nav-list">
                    <li class="nav-link" data-target="statistic">
                        <a href="#"><i class="fa-solid fa-chart-line"></i> <span>Statistic</span> </a>
                    </li>

                    <li class="nav-link" data-target="product-manage">
                        <a href="#" ><i class="bi bi-box"></i> <span>Products Management</span> </a>
                    </li>
                    <li class="nav-link" data-target="customer-manage">
                        <a href="#"><i class="bi bi-people"></i> <span>Customer Management</span></a>
                    </li>
                    <li class="nav-link" data-target="order-manage">
                        <a href="#" ><i class="bi bi-cart-fill"></i> <span>Orders Management</span> </a>
                    </li>
                    <li class="nav-link" data-target="import-goods">
                        <a href="#"><i class="fa-solid fa-truck-ramp-box"></i> <span>Import Products</span> </a>
                    </li>

                    <li class="nav-link" data-target="personal-info">
                        <a href="#" ><i class="bi bi-person-fill"></i> <span>Personal Information</span> </a>
                    </li>


                </ul>
            </nav>

            <div class="main-content">
                <div class="product-manage">
                    <h3 style="font-weight: bold;"><i class="bi bi-box"></i> Products Management</h3>
                    <hr style="border: 0; border-top: 1px solid #333; margin: 15px 0;" />

                    <div class="filter">
                        <select id="sortID" onchange="sort()"> <option value="Increase">Sort by price ascending</option>
                            <option value="Decrease">Sort by price in descending</option>
                        </select>

                        <div style="display: flex; align-items: center;">
                            <input id="search" type="text" placeholder="Search" oninput="search()">
                            <button type="button" class="btn-search-icon" onclick="search()">
                                <i class="bi bi-search"></i>
                            </button>
                        </div>
                    </div>
                    <div class="product-table">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th scope="col">Picture</th>
                                    <th scope="col">Name</th>
                                    <th scope="col">Category ID</th>
                                    <th scope="col">Price</th>
                                    <th scope="col">Quantity</th>
                                </tr>
                            </thead>
                            <tbody>

                            </tbody>
                        </table>
                    </div><div id="product-pagination" class="pagination-wrapper mt-3"></div>
                </div>

                <div class="statistic" style="display: block;">
                    <h3 style="font-weight: bold;"><i class="fa-solid fa-chart-line"></i> Statistic</h3> 
                    <hr style="border: 0; border-top: 1px solid #333; margin: 15px 0;" />
                    <div class="card-container">
                        <div class="card">
                            <div class="card-inner">
                                <h2>Products</h2>
                                <span><i class="bi bi-box"></i></span>
                            </div>
                            <h1>${numberOfProduct}</h1>
                        </div>

                        <div class="card">
                            <div class="card-inner">
                                <h2>Orders</h2>
                                <span><i class="bi bi-cart-fill"></i></span>
                            </div>
                            <h1>${numberOfOrder}</h1>
                        </div>

                        <div class="card">
                            <div class="card-inner">
                                <h2>Revenue</h2>
                                <span><i class="bi bi-currency-dollar"></i></span>
                            </div>
                            <h1>
                                <fmt:formatNumber type="number" value="${revenue}" pattern="###,###" />
                            </h1>
                        </div>

                        <div class="card">
                            <div class="card-inner">
                                <h2>Customers</h2>
                                <span><i class="bi bi-people"></i></span>
                            </div>
                            <h1>${numberOfCustomer}</h1>
                        </div>
                    </div>
                    <%-- ====== STAFF STATISTIC: CHỌN NĂM ====== --%>
                    <form action="${BASE_URL}/staff" method="get">
                        <select id="mySelect" name="year">
                            <option value="">--Select Year--</option>
                            <option value="2025" ${year == 2025 ? 'selected="selected"' : ''}>2025</option>
                            <option value="2024" ${year == 2024 ? 'selected="selected"' : ''}>2024</option>
                            <option value="2023" ${year == 2023 ? 'selected="selected"' : ''}>2023</option>
                            <option value="2022" ${year == 2022 ? 'selected="selected"' : ''}>2022</option>
                            <option value="2021" ${year == 2021 ? 'selected="selected"' : ''}>2021</option>
                        </select>
                        <button id="date" type="submit">Submit</button>
                    </form>


                    <div class="chart">
                        <!-- QUARTERLY REVENUE -->
                        <div class="chart-container">
                            <div class="chart-heading">
                                Quarterly Revenue
                            </div>
                            <canvas class="my-chart"></canvas>
                        </div>

                        <!-- MONTHLY REVENUE -->
                        <div class="chart-container-col">
                            <div class="chart-heading">
                                Monthly Revenue
                            </div>
                            <canvas class="my-chart-line" width="1000" height="900"></canvas>
                        </div>
                    </div>


                </div>


                <div class="order-manage">
                    <h3 style="font-weight: bold;"><i class="bi bi-cart-fill"></i> Order Management</h3>
                    <hr style="border: 0; border-top: 1px solid #333; margin: 15px 0;" />

                    <%-- FORM TÌM KIẾM (LIVE SEARCH) --%>
                    <div class="search-form" style="display: flex; margin-bottom: 15px; max-width: 400px;">
                        <input type="text" id="order-search-input" class="search-input"
                               style="flex-grow: 1; padding: 8px 12px; border: 1px solid #ccc; border-radius: 5px 0 0 5px; outline: none;"
                               placeholder="Search by Customer Name..."
                               onkeyup="searchOrderTable()">

                        <button type="button" class="search-btn" style="border-radius: 0 5px 5px 0;">
                            <i class="bi bi-search"></i>
                        </button>
                    </div>

                    <div class="order-main">
                        <table class="order-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Address</th>
                                    <th>Order Date</th>
                                    <th class="th-status">Status</th>
                                    <th>Amounts</th>
                                    <th></th> <%-- Cột Action --%>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${requestScope.orderList}" var="order">

                                    <%-- 1. HÀNG CHÍNH CỦA ĐƠN HÀNG --%>
                                    <tr class="order-summary-row">
                                        <td>${order.orderID}</td>
                                        <td style="font-weight: bold;">${customerUsernameMap[order.customer_id]}</td>
                                        <td class="tb-address">${order.address}</td>
                                        <td><fmt:formatDate value="${order.date}" pattern="yyyy-MM-dd" /></td>

                                        <td class="cell-status">
                                            <p class="status stt-${order.status}" id="id${order.orderID}">${order.status}</p>
                                        </td>

                                        <c:set var="formattedPrice">
                                            <fmt:formatNumber type="number" value="${order.total}" pattern="###,###" />
                                        </c:set>
                                        <td><strong>${formattedPrice} VND</strong></td>

                                        <td class="action-btn" id="action-cell-${order.orderID}">
                                            <c:if test="${order.status eq 'Pending' or order.status eq 'Processing'}">
                                                <button class="accept-btn" onclick="updateOrderStatus(${order.orderID}, 'Delivering')" title="Approve">
                                                    <i class="bi bi-check-lg"></i>
                                                </button>
                                                <button class="reject-btn" onclick="updateOrderStatus(${order.orderID}, 'Cancelled')" title="Cancel">
                                                    <i class="bi bi-x-lg"></i>
                                                </button>
                                            </c:if>
                                            <c:if test="${order.status eq 'Delivering' or order.status eq 'Shipped'}">
                                                <button class="accept-btn" onclick="updateOrderStatus(${order.orderID}, 'Completed')" title="Complete">
                                                    <i class="bi bi-truck"></i>
                                                </button>
                                            </c:if>
                                            <button class="view-btn"><i class="bi bi-eye"></i></button>
                                        </td>
                                    </tr>

                                    <%-- 2. HÀNG CHI TIẾT (DROPDOWN) --%>
                                    <tr class="order-detail-row" style="display: none;">
                                        <td colspan="7" class="order-detail-cell">
                                            <table class="detail-table">
                                                <thead>
                                                    <tr>
                                                        <th>Product ID</th>
                                                        <th>Product Name</th>
                                                        <th>Size</th>
                                                        <th>Quantity</th>
                                                        <th>Total Price</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${requestScope.orderDetailList}" var="orderDetail">
                                                        <c:if test="${order.orderID eq orderDetail.orderID}">
                                                            <tr>
                                                                <td>${orderDetail.productID}</td>
                                                                <td>${nameProduct[orderDetail.productID]}</td>
                                                                <td>${orderDetail.size_name}</td>
                                                                <td>${orderDetail.quantity}</td>

                                                                <c:set var="itemPrice" value="${priceProduct[orderDetail.productID]}" />
                                                                <c:set var="voucherPercent" value="${voucherMap[voucherID[orderDetail.productID]]}" />
                                                                <c:set var="finalPrice" value="${(itemPrice - (itemPrice * (voucherPercent != null ? voucherPercent : 0) / 100)) * orderDetail.quantity}" />

                                                                <c:set var="formattedDetailPrice">
                                                                    <fmt:formatNumber type="number" value="${finalPrice}" pattern="###,###" />
                                                                </c:set>

                                                                <td>${formattedDetailPrice} VND</td>
                                                            </tr>
                                                        </c:if>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                    <%-- === PHÂN TRANG ORDER (CLIENT SIDE) === --%>
                    <div id="order-pagination" class="pagination-wrapper mt-3">
                    </div>
                    <%-- ====================================== --%>
                </div>




                <div class="personal-info">
                    <h3 style="font-weight: bold;"><i class="bi bi-person-fill"></i> Personal Information</h3>
                    <hr style="border: 0; border-top: 1px solid #333; margin: 15px 0;" />
                    <div class="personal-box" id="personal-box">

                        <div class="personal-main">
                            <table class="profile-info">
                                <tr id="fullName">
                                    <th>Fullname:</th>
                                </tr>
                                <tr id="phoneNumber">
                                    <th>Phone number:</th>
                                </tr>
                                <tr id="email">
                                    <th>Email:</th>
                                </tr>
                                <tr id="address">
                                    <th>Address:</th>
                                </tr>
                            </table>
                        </div>
                        <div class="personal-btn">
                            <button id="update-pro-btn" onclick="toggleEditPersonal(this)" data-name="" data-phone="" data-email="" data-address="">Edit personal information</button>

                            <button onclick="toggleChangePassword()">Change password</button>
                        </div>
                    </div>

                    <div class="add-box container" id="edit-personal">
                        <h1>Edit information</h1>
                        <hr>
                        <div class="row">
                            <div class="col-md-12">
                                <input type="text" id="update-profile-name" placeholder="Fullname" >
                            </div>
                            <div class="col-md-12">
                                <input type="text" placeholder="Phone number" id="update-profile-phone">
                            </div>
                            <div class="col-md-12">
                                <input type="email" placeholder="Email" id="update-profile-email">
                            </div>
                            <div class="col-md-12">
                                <input type="text" placeholder="Address" id="update-profile-address">
                            </div>
                            <div class="col-md-6">
                                <button onclick="toggleEditPersonal(this)">CANCEL</button>
                            </div>
                            <div class="col-md-6">
                                <button id="edit-profile-btn" onclick="updateProfile(this)" data-id="">UPDATE</button>
                            </div>
                        </div>
                    </div>

                    <div class="add-box container" id="change-password" style="display: none">
                        <form action="" method="">

                            <h1>Change password</h1>
                            <hr>                           
                            <div class="row">
                                <div class="col-md-12">
                                    <input type="password" placeholder="Current password" id="currentPassword">
                                </div>
                                <div class="col-md-12">
                                    <input type="password" placeholder="New password" id="newPassword1">
                                </div>

                                <div class="col-md-12">
                                    <input type="password" placeholder="Confirm password" id="newPassword2">
                                </div>

                                <div id="message-changepass" class="message"></div>


                                <div class="col-md-6">
                                    <button id="cancel-changepass-btn">CANCEL</button>
                                </div>
                                <div class="col-md-6">
                                    <button class="btn-changePass" >CHANGE</button>
                                </div>
                            </div>
                        </form>

                    </div>
                </div>

                <!-- dis customer -->
                <div class="customer-manage">
                    <h3 style="font-weight: bold;"><i class="bi bi-people"></i> Customers Management</h3>
                    <hr style="border: 0; border-top: 1px solid #333; margin: 15px 0;" />

                    <!-- Toolbar tìm kiếm giống import: gọn, không submit/clear -->
                    <div class="d-flex align-items-center justify-content-between mb-3">
                        <div class="input-group" style="max-width: 320px;">
                            <input id="customer-search" class="form-control" type="text" 
                                   placeholder="Search username..."
                                   oninput="searchCustomers(this.value)"> <button class="btn btn-secondary" type="button" 
                                   style="background-color: #a0816c; border-color: #a0816c;"
                                   onclick="searchCustomers(document.getElementById('customer-search').value)">
                                <i class="bi bi-search"></i>
                            </button>
                        </div>

                        <div class="ms-3 text-muted small">Total: <strong id="customer-total">0</strong></div>
                    </div>

                    <div class="order-main">
                        <table class="order-table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Username</th>
                                    <th>Full name</th>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th class="tb-address">Address</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody id="customer-list">
                                <!-- JS sẽ đổ dữ liệu vào đây -->
                            </tbody>
                        </table>
                    </div>
                    <div id="customer-pagination" class="pagination-wrapper mt-3"></div>
                </div>

                <!-- dis customer -->


                <div class="import-goods">
                    <h3 style="font-weight: bold;"><i class="fa-solid fa-truck-ramp-box"></i> Import Product</h3>
                    <hr style="border: 0; border-top: 1px solid #333; margin: 15px 0;" />

                    <%-- === THANH CÔNG CỤ: SEARCH + NÚT MỞ MODAL === --%>
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div class="input-group" style="max-width: 350px;">
                            <input type="text" id="import-search-input" class="form-control" 
                                   placeholder="Search by Staff Name..." onkeyup="searchImportTable()">
                            <button class="btn btn-secondary" type="button" style="background-color: #a0816c; border: none;">
                                <i class="bi bi-search"></i>
                            </button>
                        </div>

                        <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#createImportModal">
                            <i class="fa fa-plus"></i> Create New Import
                        </button>
                    </div>

                    <%-- === 2. BẢNG HIỂN THỊ LỊCH SỬ IMPORT (Màn hình chính) === --%>
                    <div class="order-main">
                        <table class="order-table" >
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Quantity</th>
                                    <th>Order date</th>
                                    <th class="th-status">Status</th>
                                    <th>Total price</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody id="import-list">
                            </tbody>
                        </table>
                    </div>

                    <div id="import-pagination-controls" class="mt-3">
                    </div>
                </div>

                <div class="modal fade" id="createImportModal" tabindex="-1" aria-labelledby="createImportModalLabel" aria-hidden="true">
                    <div class="modal-dialog modal-lg modal-dialog-centered"> <div class="modal-content">

                            <div class="modal-header">
                                <h5 class="modal-title" id="createImportModalLabel">
                                    <i class="fa-solid fa-truck-ramp-box"></i> Create New Import Request
                                </h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>

                            <div class="modal-body">
                                <form id="createImportForm">

                                    <div class="import-form-container">
                                        <div class="row g-3"> <div class="col-md-5">
                                                <label for="import_product" class="import-form-label">Product Name</label>
                                                <select id="import_product" class="form-select">
                                                    <option value="">-- Select Product --</option>
                                                </select>
                                            </div>

                                            <div class="col-md-3">
                                                <label for="import_size" class="import-form-label">Size</label>
                                                <select id="import_size" class="form-select" disabled>
                                                    <option value="">-- Size --</option>
                                                </select>
                                            </div>

                                            <div class="col-md-2">
                                                <label for="import_qty" class="import-form-label">Quantity</label>
                                                <input type="number" id="import_qty" class="form-control text-center" min="1" value="1">
                                            </div>

                                            <div class="col-md-2">
                                                <button type="button" class="btn-add-item" id="btn-add-item-to-import">
                                                    <i class="fa fa-plus"></i> ADD
                                                </button>
                                            </div>
                                        </div>
                                        <div id="import-item-error" class="text-danger mt-2 small fw-bold text-center" style="display: none;"></div>
                                    </div>

                                    <h6 class="mb-3 fw-bold text-secondary"><i class="bi bi-list-check"></i> Items to Import</h6>
                                    <div class="import-table-wrapper">
                                        <table class="table table-hover import-table mb-0">
                                            <thead>
                                                <tr>
                                                    <th>Product Name</th>
                                                    <th class="text-center">Size</th>
                                                    <th class="text-center">Quantity</th>
                                                    <th class="text-center" style="width: 60px;">Action</th>
                                                </tr>
                                            </thead>
                                            <tbody id="import-items-list">
                                                <tr>
                                                    <td colspan="4" class="text-center text-muted py-4">
                                                        <i class="bi bi-basket3 fs-1 d-block mb-2 opacity-25"></i>
                                                        Your import list is empty. Add items above.
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>

                                </form>
                            </div>

                            <div class="modal-footer-custom">
                                <button type="button" class="btn btn-light me-2" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" form="createImportForm" class="btn-submit-import">
                                    <i class="fas fa-paper-plane me-2"></i> Submit Request
                                </button>
                            </div>

                        </div>
                    </div>
                </div>

                <%-- ===  kết thúc tạo import === --%>

            </div>
        </div>

        <script src="${BASE_URL}/js/jquery-3.7.0.min.js"></script>
        <script src="${BASE_URL}/js/jquery.validate.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

        <script>
    const BASE_URL = "${pageContext.request.contextPath}";

    const chartData = {
        labels: ["quarter 1", "quarter 2", "quarter 3", "quarter 4"],
        data: [
            ${empty quarter1 ? 0 : quarter1},
            ${empty quarter2 ? 0 : quarter2},
            ${empty quarter3 ? 0 : quarter3},
            ${empty quarter4 ? 0 : quarter4}
        ]
    };
    const myChart = document.querySelector(".my-chart");
    if (myChart && typeof Chart !== "undefined") {
        new Chart(myChart, {
            type: "doughnut",
            data: {
                labels: chartData.labels,
                datasets: [{
                    label: "Quarter revenue (${year})",
                    data: chartData.data
                }]
            }
        });
    }

    const ctx = document.querySelector('.my-chart-line');
    if (ctx && typeof Chart !== "undefined") {
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'],
                datasets: [{
                    label: 'monthly revenue (${year})',
                    data: [
                        ${empty revenue1 ? 0 : revenue1},
                        ${empty revenue2 ? 0 : revenue2},
                        ${empty revenue3 ? 0 : revenue3},
                        ${empty revenue4 ? 0 : revenue4},
                        ${empty revenue5 ? 0 : revenue5},
                        ${empty revenue6 ? 0 : revenue6},
                        ${empty revenue7 ? 0 : revenue7},
                        ${empty revenue8 ? 0 : revenue8},
                        ${empty revenue9 ? 0 : revenue9},
                        ${empty revenue10 ? 0 : revenue10},
                        ${empty revenue11 ? 0 : revenue11},
                        ${empty revenue12 ? 0 : revenue12}
                    ],
                    borderWidth: 1,
                    backgroundColor: 'rgba(231, 189, 111, 0.799)',
                    barThickness: 30
                }]
            },
            options: {
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    }

    let allProductData = [];
    let currentProdPage = 1;
    const prodPerPage = 10;

    function productList() {
        $.ajax({
            method: "POST",
            url: "${BASE_URL}/staff/product",
            data: {}
        }).done(function(data) {
            var data1 = JSON.parse(data);
            if (data1.isSuccess) {
                allProductData = data1.data || [];
                currentProdPage = 1;
                renderProductPage();
            } else {
                alert('Load product fail');
            }
        });
    }

    function search(e) {
        var input = document.getElementById('search').value;
        $.ajax({
            method: "POST",
            url: "${BASE_URL}/staff/product/search",
            data: {
                input: input
            }
        }).done(function(data) {
            var data1 = JSON.parse(data);
            if (data1.isSuccess) {
                allProductData = data1.data || [];
                currentProdPage = 1;
                renderProductPage();
            } else {
                allProductData = [];
                renderProductPage();
            }
        });
    }

    function sort(e) {
        var option = document.getElementById('sortID').value;
        $.ajax({
            method: "POST",
            url: "${BASE_URL}/staff/product/sort",
            data: {
                option: option
            }
        }).done(function(data) {
            var data1 = JSON.parse(data);
            if (data1.isSuccess) {
                allProductData = data1.data || [];
                currentProdPage = 1;
                renderProductPage();
            } else {
                alert("Sort fail");
            }
        });
    }

    function renderProductPage() {
        const tbody = document.querySelector(".product-table table tbody");
        tbody.innerHTML = "";
        const totalItems = allProductData.length;

        if (totalItems === 0) {
            tbody.innerHTML = '<tr><td colspan="5" class="text-center text-muted p-3">No products found.</td></tr>';
            const paginationDiv = document.getElementById("product-pagination");
            if (paginationDiv)
                paginationDiv.innerHTML = "";
            return;
        }

        const startIndex = (currentProdPage - 1) * prodPerPage;
        const endIndex = startIndex + prodPerPage;
        const pageData = allProductData.slice(startIndex, endIndex);
        pageData.forEach(function(product) {
            var newRow = document.createElement("tr");
            var pictureCell = document.createElement("td");
            var nameCell = document.createElement("td");
            var categoryIdCell = document.createElement("td");
            var priceCell = document.createElement("td");
            var quantityCell = document.createElement("td");

            pictureCell.innerHTML = '<img style="width: 100px; height: 100px; object-fit: cover;" src="' + product.picURL + '" alt="Product Picture">';
            nameCell.textContent = product.name;
            categoryIdCell.textContent = product.categoryID;
            priceCell.textContent = product.price.toLocaleString('vi-VN') + ' VND';
            quantityCell.textContent = product.quantity;
            newRow.appendChild(pictureCell);
            newRow.appendChild(nameCell);
            newRow.appendChild(categoryIdCell);
            newRow.appendChild(priceCell);
            newRow.appendChild(quantityCell);
            tbody.appendChild(newRow);
        });

        renderProductPaginationControls(totalItems);
    }

    function renderProductPaginationControls(totalItems) {
        const container = document.getElementById("product-pagination");
        if (!container)
            return;
        const totalPages = Math.ceil(totalItems / prodPerPage);

        if (totalPages <= 1) {
            container.innerHTML = "";
            return;
        }

        let html = '<nav aria-label="Product pagination"><ul class="pagination justify-content-center">';
        const prevDisabled = (currentProdPage === 1) ? "disabled" : "";
        html += '<li class="page-item ' + prevDisabled + '"><button class="page-link" onclick="changeProductPage(' + (currentProdPage - 1) + ')"><i class="bi bi-chevron-left"></i></button></li>';
        for (let i = 1; i <= totalPages; i++) {
            if (i === 1 || i === totalPages || (i >= currentProdPage - 1 && i <= currentProdPage + 1)) {
                const activeClass = (i === currentProdPage) ? "active" : "";
                html += '<li class="page-item ' + activeClass + '"><button class="page-link" onclick="changeProductPage(' + i + ')">' + i + '</button></li>';
            } else if (i === currentProdPage - 2 || i === currentProdPage + 2) {
                html += '<li class="page-item disabled"><span class="page-link">...</span></li>';
            }
        }

        const nextDisabled = (currentProdPage === totalPages) ? "disabled" : "";
        html += '<li class="page-item ' + nextDisabled + '"><button class="page-link" onclick="changeProductPage(' + (currentProdPage + 1) + ')"><i class="bi bi-chevron-right"></i></button></li>';
        html += '</ul></nav>';
        container.innerHTML = html;
    }

    function changeProductPage(newPage) {
        currentProdPage = newPage;
        renderProductPage();
    }

    let allCustomersData = [];
    let currentCustPage = 1;
    const custPerPage = 10;

    function listCustomers() {
        $.ajax({
            method: "POST",
            url: "${BASE_URL}/staff/customer",
            dataType: "json"
        }).done(function(resp) {
            if (!resp || !resp.isSuccess) {
                return;
            }
            allCustomersData = resp.data || [];
            currentCustPage = 1;
            renderCustomerPage();
        });
    }

    function searchCustomers(q) {
        q = (q || "").trim();
        if (q.length === 0) {
            listCustomers();
            return;
        }
        $.ajax({
            method: "POST",
            url: "${BASE_URL}/staff/customer/search",
            data: {
                input: q
            },
            dataType: "json"
        }).done(function(resp) {
            if (!resp || !resp.isSuccess) {
                return;
            }
            allCustomersData = resp.data || [];
            currentCustPage = 1;
            renderCustomerPage();
        });
    }

    function renderCustomerPage() {
        const totalItems = allCustomersData.length;
        const totalLabel = document.querySelector("#customer-total");
        if (totalLabel)
            totalLabel.textContent = totalItems;
        const startIndex = (currentCustPage - 1) * custPerPage;
        const endIndex = startIndex + custPerPage;
        const pageData = allCustomersData.slice(startIndex, endIndex);
        renderCustomerRows(pageData, startIndex);
        renderCustomerPaginationControls(totalItems);
    }

    function renderCustomerRows(list, startIndex) {
        const tbody = document.querySelector("#customer-list");
        tbody.innerHTML = "";

        if (!list.length) {
            tbody.innerHTML = '<tr><td colspan="7"><div class="empty text-center text-muted p-3">No customers found.</div></td></tr>';
            return;
        }

        let i = startIndex;
        list.forEach(function(cst) {
            const tr = document.createElement("tr");
            tr.innerHTML =
                '<td>' + (++i) + '</td>' +
                '<td style="font-weight: bold;">' + (cst.username || '') + '</td>' +
                '<td>' + (cst.fullName || '') + '</td>' +
                '<td>' + (cst.email || '') + '</td>' +
                '<td>' + (cst.phoneNumber || '') + '</td>' +
                '<td>' + (cst.address || '') + '</td>' +
                '<td class="action-btn">' +
                '<button class="view-btn" data-id="' + cst.customer_id + '"><i class="bi bi-eye"></i></button>' +
                '</td>';
            tbody.appendChild(tr);

            const subBody = document.createElement("tbody");
            subBody.classList.add("item");
            subBody.setAttribute("data-customer", cst.customer_id);
            tbody.appendChild(subBody);
        });

        tbody.querySelectorAll(".view-btn").forEach(function(btn) {
            btn.addEventListener("click", function() {
                const id = this.getAttribute("data-id");
                toggleCustomerOrders(this, id);
            });
        });
    }

    function renderCustomerPaginationControls(totalItems) {
        const container = document.getElementById("customer-pagination");
        if (!container)
            return;
        const totalPages = Math.ceil(totalItems / custPerPage);

        if (totalPages <= 1) {
            container.innerHTML = "";
            return;
        }

        let html = '<nav aria-label="Customer pagination"><ul class="pagination justify-content-center">';
        const prevDisabled = (currentCustPage === 1) ? "disabled" : "";
        html += '<li class="page-item ' + prevDisabled + '"><button class="page-link" onclick="changeCustomerPage(' + (currentCustPage - 1) + ')"><i class="bi bi-chevron-left"></i></button></li>';
        for (let i = 1; i <= totalPages; i++) {
            if (i === 1 || i === totalPages || (i >= currentCustPage - 1 && i <= currentCustPage + 1)) {
                const activeClass = (i === currentCustPage) ? "active" : "";
                html += '<li class="page-item ' + activeClass + '"><button class="page-link" onclick="changeCustomerPage(' + i + ')">' + i + '</button></li>';
            } else if (i === currentCustPage - 2 || i === currentCustPage + 2) {
                html += '<li class="page-item disabled"><span class="page-link">...</span></li>';
            }
        }

        const nextDisabled = (currentCustPage === totalPages) ? "disabled" : "";
        html += '<li class="page-item ' + nextDisabled + '"><button class="page-link" onclick="changeCustomerPage(' + (currentCustPage + 1) + ')"><i class="bi bi-chevron-right"></i></button></li>';
        html += '</ul></nav>';
        container.innerHTML = html;
    }

    function changeCustomerPage(newPage) {
        currentCustPage = newPage;
        renderCustomerPage();
    }

    function toggleCustomerOrders(button, customerId) {
        const tr = button.closest("tr");
        const next = tr.nextElementSibling;
        if (!next || !next.classList.contains("item"))
            return;
        if (next.style.display === "" || next.style.display === "none") {
            if (!next.hasChildNodes() || next.innerHTML.trim() === "") {
                loadCustomerOrders(customerId, next, function() {
                    next.style.display = "contents";
                });
            } else {
                next.style.display = "contents";
            }
        } else {
            next.style.display = "none";
        }
    }

    function loadCustomerOrders(customerId, containerTbody, cb) {
        $.ajax({
            method: "POST",
            url: "${BASE_URL}/staff/customer/detail",
            data: {
                id: customerId
            },
            dataType: "json"
        }).done(function(resp) {
            if (!resp || !resp.isSuccess) {
                cb && cb();
                return;
            }
            const orders = (resp.data && resp.data.orders) ? resp.data.orders : [];
            containerTbody.innerHTML = "";
            orders.sort(function(a, b) {
                const idA = parseInt(a.orderID ?? a.order_id ?? 0, 10);
                const idB = parseInt(b.orderID ?? b.order_id ?? 0, 10);
                return idB - idA;
            });
            if (!orders.length) {
                const empty = document.createElement("tr");
                empty.style.backgroundColor = "white";
                empty.innerHTML = '<td colspan="7" class="text-muted">No orders.</td>';
                containerTbody.appendChild(empty);
                cb && cb();
                return;
            }

            orders.forEach(function(o) {
                const row = document.createElement("tr");
                row.style.backgroundColor = "white";
                row.innerHTML =
                    '<td>' + (o.orderID ?? o.order_id ?? '') + '</td>' +
                    '<td>' + formatDateForTable(o.date) + '</td>' +
                    '<td>' + (o.address || '') + '</td>' +
                    '<td>' + (o.phone_number || o.phoneNumber || '') + '</td>' +
                    '<td><p class="status">' + (o.status || '') + '</p></td>' +
                    '<td>' + formatCurrencyVND(o.total) + '</td>' +
                    '<td></td>';
                containerTbody.appendChild(row);
            });
            handleColor();
            cb && cb();
        });
    }

    let allOrderData = [];
    let filteredOrderData = [];
    let currentOrderPage = 1;
    const orderPerPage = 10;

    function initOrderPagination() {
        const tbody = document.querySelector(".order-table tbody");
        if (!tbody) return;

        const rows = tbody.querySelectorAll(".order-summary-row");
        if (rows.length === 0) return;

        allOrderData = [];
        rows.forEach(row => {
            const detailRow = row.nextElementSibling;
            
            // --- SỬA ĐỔI: Lấy thêm ID để sắp xếp ---
            let idCell = row.cells[0]; // Cột đầu tiên là ID
            let orderId = parseInt(idCell.innerText.trim()) || 0; 
            // ----------------------------------------

            let nameCell = row.cells[1];
            let searchName = nameCell ? nameCell.innerText : "";

            allOrderData.push({
                summaryRow: row,
                detailRow: detailRow,
                searchText: searchName.toUpperCase().trim(),
                id: orderId // Lưu ID vào object
            });
        });

        // --- SỬA ĐỔI: Sắp xếp giảm dần theo ID ---
        allOrderData.sort((a, b) => b.id - a.id);
        // ----------------------------------------

        filteredOrderData = allOrderData;
        renderOrderPage();
    }

    function renderOrderPage() {
        const tbody = document.querySelector(".order-table tbody");
        if (!tbody)
            return;
        tbody.innerHTML = "";

        const totalItems = filteredOrderData.length;
        if (totalItems === 0) {
            tbody.innerHTML = '<tr><td colspan="7"><div class="empty text-center text-muted p-3">No orders found.</div></td></tr>';
            const pageDiv = document.getElementById("order-pagination");
            if (pageDiv)
                pageDiv.innerHTML = "";
            return;
        }

        const startIndex = (currentOrderPage - 1) * orderPerPage;
        const endIndex = startIndex + orderPerPage;
        const pageItems = filteredOrderData.slice(startIndex, endIndex);
        pageItems.forEach(item => {
            tbody.appendChild(item.summaryRow);
            if (item.detailRow) {
                tbody.appendChild(item.detailRow);
            }
        });
        renderOrderPaginationControls(totalItems);
    }

    function searchOrderTable() {
        const input = document.getElementById("order-search-input");
        const filter = input.value.toUpperCase().trim();

        if (filter === "") {
            filteredOrderData = allOrderData;
        } else {
            filteredOrderData = allOrderData.filter(item => {
                return item.searchText.includes(filter);
            });
        }
        currentOrderPage = 1;
        renderOrderPage();
    }

    function renderOrderPaginationControls(totalItems) {
        const container = document.getElementById("order-pagination");
        if (!container)
            return;
        const totalPages = Math.ceil(totalItems / orderPerPage);

        if (totalPages <= 1) {
            container.innerHTML = "";
            return;
        }

        let html = '<nav aria-label="Order pagination"><ul class="pagination justify-content-center">';
        const prevDisabled = (currentOrderPage === 1) ? "disabled" : "";
        html += '<li class="page-item ' + prevDisabled + '"><button class="page-link" onclick="changeOrderPage(' + (currentOrderPage - 1) + ')"><i class="bi bi-chevron-left"></i></button></li>';
        for (let i = 1; i <= totalPages; i++) {
            if (i === 1 || i === totalPages || (i >= currentOrderPage - 1 && i <= currentOrderPage + 1)) {
                const activeClass = (i === currentOrderPage) ? "active" : "";
                html += '<li class="page-item ' + activeClass + '"><button class="page-link" onclick="changeOrderPage(' + i + ')">' + i + '</button></li>';
            } else if (i === currentOrderPage - 2 || i === currentOrderPage + 2) {
                html += '<li class="page-item disabled"><span class="page-link">...</span></li>';
            }
        }

        const nextDisabled = (currentOrderPage === totalPages) ? "disabled" : "";
        html += '<li class="page-item ' + nextDisabled + '"><button class="page-link" onclick="changeOrderPage(' + (currentOrderPage + 1) + ')"><i class="bi bi-chevron-right"></i></button></li>';
        html += '</ul></nav>';
        container.innerHTML = html;
    }

    function changeOrderPage(newPage) {
        currentOrderPage = newPage;
        renderOrderPage();
    }

    function getCookie(name) {
        var cookies = document.cookie.split(';');
        for (var i = 0; i < cookies.length; i++) {
            var cookie = cookies[i].trim();
            if (cookie.indexOf(name + '=') === 0) {
                return cookie.substring(name.length + 1);
            }
        }
        return null;
    }

    function profile() {
        var input = getCookie("input");
        $.ajax({
            method: "POST",
            url: "${BASE_URL}/staff/profile",
            data: {
                input: input
            }
        }).done(function(data) {
            var data1 = JSON.parse(data);
            var cells = document.querySelectorAll(".profile-info td");
            cells.forEach(function(cell) {
                cell.remove();
            });
            console.log(data1.data);
            if (data1.isSuccess) {
                var trName = document.getElementById("fullName");
                var trEmail = document.getElementById("email");
                var trAddress = document.getElementById("address");
                var trPhone = document.getElementById("phoneNumber");
                var info = data1.data;
                var fullName = document.createElement("td");
                var phoneNumber = document.createElement("td");
                var address = document.createElement("td");
                var email = document.createElement("td");

                document.getElementById('update-pro-btn').setAttribute('data-name', info.fullName);
                document.getElementById('update-pro-btn').setAttribute('data-phone', info.phoneNumber);
                document.getElementById('update-pro-btn').setAttribute('data-email', info.email);
                document.getElementById('update-pro-btn').setAttribute('data-address', info.address);
                document.getElementById('update-pro-btn').setAttribute('data-id', info.username);

                fullName.textContent = info.fullName;
                phoneNumber.textContent = info.phoneNumber;
                address.textContent = info.address;
                email.textContent = info.email;
                trName.appendChild(fullName);
                trEmail.appendChild(email);
                trAddress.appendChild(address);
                trPhone.appendChild(phoneNumber);
            }
        });
    }

    function updateProfile(pro) {
        var username = pro.getAttribute('data-id');
        var email = document.getElementById('update-profile-email').value;
        var address = document.getElementById('update-profile-address').value;
        var fullName = document.getElementById('update-profile-name').value;
        var phone = document.getElementById('update-profile-phone').value;

        $.ajax({
                method: "POST",
                url: "${BASE_URL}/staff/profile/update",
                data: {
                    username: username,
                    fullName: fullName,
                    fullname: fullName,
                    phoneNumber: phone,
                    phone: phone,
                    email: email,
                    address: address
                }
            })
            .done(function(data) {
                console.log("updateProfile response:", data);
                try {
                    var data1 = JSON.parse(data);
                    if (data1.isSuccess) {
                        alert("Update successfully");
                        profile();
                        document.getElementById('edit-personal').style.display = "none";
                        document.getElementById('personal-box').style.display = "block";
                    } else {
                        alert("Update failed from server.");
                    }
                } catch (e) {
                    console.error("JSON parse error:", e);
                    alert("Server did not return valid JSON, check servlet /staff/profile/update.");
                }
            })
            .fail(function(xhr, status, error) {
                console.error("AJAX error:", status, error);
                alert("Request error: " + status);
            });
    }

    function toggleEditPersonal(profile) {
        var edit = document.getElementById('edit-personal');
        var personal = document.getElementById('personal-box');

        if (edit.style.display === "none") {
            edit.style.display = "block";
            personal.style.display = "none";
        } else {
            edit.style.display = "none";
            personal.style.display = "block";
        }
        var id = profile.getAttribute('data-id');
        document.getElementById('edit-profile-btn').setAttribute('data-id', id);

        var email = document.getElementById('update-profile-email');
        email.value = profile.getAttribute('data-email');

        var address = document.getElementById('update-profile-address');
        address.value = profile.getAttribute('data-address');

        var fullName = document.getElementById('update-profile-name');
        fullName.value = profile.getAttribute('data-name');

        var phone = document.getElementById('update-profile-phone');
        phone.value = profile.getAttribute('data-phone');
    }

    function toggleChangePassword() {
        var edit = document.getElementById('change-password');
        var personal = document.getElementById('personal-box');

        if (edit.style.display === "none") {
            edit.style.display = "block";
            personal.style.display = "none";
        } else {
            edit.style.display = "none";
            personal.style.display = "block";
        }
    }

    function hideButtons1(button) {
        var id = button.getAttribute("data-id");
        $.ajax({
            method: "POST",
            url: "${BASE_URL}/staff/import/update",
            data: {
                id: id
            }
        }).done(function(data) {
            var data1 = JSON.parse(data);
            if (data1.isSuccess) {
                button.classList.add('d-n');
                listImport();
            } else {
                console.error('Error updating status.');
            }
        });
    }

    function listImport(page) {
        if (!page)
            page = 1;
        $.ajax({
            method: "POST",
            url: "${BASE_URL}/staff/import",
            data: {
                page: page
            }
        }).done(function(data) {
            var data1 = JSON.parse(data);
            if (data1.isSuccess) {
                const tbody = document.querySelector("table #import-list");
                tbody.innerHTML = "";
                var importList = data1.data.list;
                var importDetailList = data1.data.listDetail;
                var currentPage = data1.data.currentPage || 1;
                var totalPages = data1.data.totalPages || 1;
                var i = (currentPage - 1) * 10;

                importList.forEach(function(item) {
                    var newTr = document.createElement("tr");
                    newTr.classList.add("import-row-main");
                    var numCell = document.createElement("td");
                    var nameCell = document.createElement("td");
                    var quantityCell = document.createElement("td");
                    var dateCell = document.createElement("td");
                    var statusCell = document.createElement("td");
                    var priceCell = document.createElement("td");
                    var btnCell = document.createElement("td");

                    numCell.textContent = ++i;
                    nameCell.textContent = item.username;
                    quantityCell.textContent = item.quantity;
                    dateCell.textContent = item.date;
                    priceCell.textContent = item.total.toLocaleString('vi-VN')+ ' VND';
                    statusCell.classList.add("cell-status");
                    statusCell.innerHTML = '<p class="status stt-' + item.status + '">' + item.status + '</p>';
                    btnCell.classList.add('action-btn');
                    var actionHtml = '';
                    actionHtml += '<button class="view-btn me-2" onclick="toggleImportDetail(' + item.id + ')"><i class="bi bi-eye"></i></button>';
                    if (item.status === 'Pending') {
                        actionHtml += '<button class="accept-btn ' + item.status + '" data-id="' + item.id + '" onclick="hideButtons1(this)" title="Confirm Import"><i class="bi bi-check-lg"></i></button>';
                    } else {
                        actionHtml += '<span style="color: #398754; font-weight: bold; font-size: 0.9rem; margin-left: 5px;"><i class="bi bi-check-circle-fill"></i> Delivered</span>';
                    }
                    btnCell.innerHTML = actionHtml;
                    newTr.appendChild(numCell);
                    newTr.appendChild(nameCell);
                    newTr.appendChild(quantityCell);
                    newTr.appendChild(dateCell);
                    newTr.appendChild(statusCell);
                    newTr.appendChild(priceCell);
                    newTr.appendChild(btnCell);
                    tbody.appendChild(newTr);

                    var detailTr = document.createElement("tr");
                    detailTr.id = "import-detail-" + item.id;
                    detailTr.style.display = "none";
                    detailTr.style.backgroundColor = "#f9f9f9";
                    var detailTd = document.createElement("td");
                    detailTd.colSpan = 7;
                    detailTd.style.padding = "10px 20px";
                    var subTable = document.createElement("table");
                    subTable.classList.add("detail-table");
                    subTable.style.width = "100%";
                    var subThead = document.createElement("thead");
                    subThead.innerHTML = `<tr><th>Product ID</th><th>Product Name</th><th>Quantity</th><th>Size</th><th>Price</th></tr>`;
                    subTable.appendChild(subThead);
                    var subTbody = document.createElement("tbody");
                    var hasDetail = false;

                    importDetailList.forEach(function(detail) {
                        if (item.id === detail.importID) {
                            hasDetail = true;
                            var dId = detail.productID;
                            var dName = detail.productName;
                            var dQty = detail.quantity;
                            var dSize = detail.sizeName;
                            var dPrice = detail.price;
                            var subRow = document.createElement("tr");
                            subRow.innerHTML = `<td>` + dId + `</td><td>` + (dName ? dName : "Unknown") + `</td><td>` + dQty + `</td><td>` + (dSize ? dSize : "-") + `</td><td>` + (dPrice ? dPrice.toLocaleString('vi-VN') : 0) + ` VND</td>`;
                            subTbody.appendChild(subRow);
                        }
                    });
                    if (!hasDetail) {
                        subTbody.innerHTML = "<tr><td colspan='5' style='text-align:center; color:#999;'>No details found for Import ID " + item.id + "</td></tr>";
                    }

                    subTable.appendChild(subTbody);
                    detailTd.appendChild(subTable);
                    detailTr.appendChild(detailTd);
                    tbody.appendChild(detailTr);
                });

                renderImportPagination(currentPage, totalPages);
            }
        });
    }

    function toggleImportDetail(id) {
        var detailRow = document.getElementById("import-detail-" + id);
        if (detailRow) {
            if (detailRow.style.display === "none") {
                $(detailRow).fadeIn(200);
            } else {
                $(detailRow).fadeOut(200);
            }
        }
    }

    function searchImportTable() {
        var input = document.getElementById("import-search-input");
        var filter = input.value.toUpperCase();
        var tbody = document.getElementById("import-list");
        var tr = tbody.getElementsByClassName("import-row-main");
        for (var i = 0; i < tr.length; i++) {
            var tdName = tr[i].getElementsByTagName("td")[1];
            var detailRow = tr[i].nextElementSibling;
            if (tdName) {
                var txtValue = tdName.textContent || tdName.innerText;
                if (txtValue.toUpperCase().indexOf(filter) > -1) {
                    tr[i].style.display = "";
                } else {
                    tr[i].style.display = "none";
                    if (detailRow)
                        detailRow.style.display = "none";
                }
            }
        }
    }


    function renderImportPagination(currentPage, totalPages) {
        var paginationContainer = document.getElementById("import-pagination-controls");
        if (totalPages <= 1) {
            paginationContainer.innerHTML = "";
            return;
        }

        var html = '<nav aria-label="Import pagination"><ul class="pagination justify-content-center">';
        var prevDisabled = (currentPage === 1) ? "disabled" : "";
        html += '<li class="page-item ' + prevDisabled + '"><button class="page-link" onclick="listImport(' + (currentPage - 1) + ')">Previous</button></li>';
        for (var i = 1; i <= totalPages; i++) {
            var activeClass = (i === currentPage) ? "active" : "";
            html += '<li class="page-item ' + activeClass + '"><button class="page-link" onclick="listImport(' + i + ')">' + i + '</button></li>';
        }

        var nextDisabled = (currentPage === totalPages) ? "disabled" : "";
        html += '<li class="page-item ' + nextDisabled + '"><button class="page-link" onclick="listImport(' + (currentPage + 1) + ')">Next</button></li>';
        html += '</ul></nav>';
        paginationContainer.innerHTML = html;
    }

    function hideButtons(event) {
        var clickedBtn = event.target;
        var tdElement = clickedBtn.closest('.action-btn');
        var acceptBtn = tdElement.querySelector('.accept-btn');
        var rejectBtn = tdElement.querySelector('.reject-btn');
        acceptBtn.style.display = 'none';
        rejectBtn.style.display = 'none';
    }

    function updateOrderStatus(orderId, status) {
        let id = document.querySelector(`#id` + orderId);
        $.ajax({
            url: '${BASE_URL}/staff/order/update',
            method: 'POST',
            dataType: 'json',
            data: {
                orderId: orderId,
                status: status
            },
            success: function(response) {
                if (response.isSuccess) {
                    let statusText = document.querySelector(`#id` + orderId);
                    statusText.innerHTML = status;
                    statusText.className = "status stt-" + status;
                    let actionCell = document.querySelector(`#action-cell-` + orderId);
                    let viewButtonHTML = actionCell.querySelector('.view-btn').outerHTML;
                    let newButtonHTML = "";
                    if (status === 'Delivering') {
                        newButtonHTML = `<button class="accept-btn" onclick="updateOrderStatus(${orderId}, 'Completed')" title="Complete"><i class="bi bi-truck"></i></button>`;
                    } else if (status === 'Completed' || status === 'Cancelled') {
                        newButtonHTML = "";
                    }
                    actionCell.innerHTML = newButtonHTML + viewButtonHTML;
                } else {
                    alert("Update failed from server.");
                }
            },
            error: function(xhr, status, error) {
                alert("Error sending update request.");
            }
        });
    }

    function formatCurrencyVND(n) {
        try {
            return (n ?? 0).toLocaleString('vi-VN');
        } catch (e) {
            return n;
        }
    }

    function formatDateForTable(d) {
        try {
            const date = new Date(d);
            if (isNaN(date.getTime()))
                return d || "";
            return date.toLocaleDateString('vi-VN');
        } catch (e) {
            return d || "";
        }
    }

    const handleColor = () => {
        let status = document.querySelectorAll('.status');
        status.forEach(element => {
            if (element.innerHTML === 'Cancelled') {
                element.classList.add('red');
            } else if (element.innerHTML === 'Delivering') {
                element.classList.add('green');
            } else if (element.innerHTML === 'Delivered' || element.innerHTML === 'Completed') {
                element.classList.add('blue');
            }
        });
    };

    document.addEventListener('DOMContentLoaded', function() {
        const links = document.querySelectorAll('.nav-link');
        const contentDivs = document.querySelectorAll('.main-content > div');

        function activateTab(target) {
            contentDivs.forEach(function(div) {
                if (div.classList.contains(target)) {
                    div.style.display = 'block';
                } else {
                    div.style.display = 'none';
                }
            });

            links.forEach(function(link) {
                if (link.getAttribute('data-target') === target) {
                    link.classList.add('active');
                    link.style.backgroundColor = "rgb(122, 117, 120)";
                } else {
                    link.classList.remove('active');
                    link.style.backgroundColor = "";
                }
            });
            switch (target) {
                case 'product-manage':
                    productList();
                    break;
                case 'personal-info':
                    profile();
                    break;
                case 'import-goods':
                    listImport();
                    break;
                case 'customer-manage':
                    listCustomers();
                    break;
            }
        }

        links.forEach(function(link) {
            link.addEventListener('click', function(e) {
                e.preventDefault();
                const target = this.getAttribute('data-target');
                activateTab(target);
            });
        });
        const initialTab = "${activeTab}" || "${param.activeTab}" || "statistic";
        activateTab(initialTab);
        initOrderPagination();

        let status = document.querySelectorAll('.status');
        status.forEach(element => {
            if (element.innerHTML === 'Cancelled') {
                element.classList.add('red');
            } else if (element.innerHTML === 'Delivering') {
                element.classList.add('green');
            } else if (element.innerHTML === 'Delivered' || element.innerHTML === 'Completed') {
                element.classList.add('blue');
            }
        });
        var acceptBtns = document.querySelectorAll('.accept-btn');
        var rejectBtns = document.querySelectorAll('.reject-btn');
        acceptBtns.forEach(function(btn) {
            btn.addEventListener('click', hideButtons);
        });
        rejectBtns.forEach(function(btn) {
            btn.addEventListener('click', hideButtons);
        });
        const toggleBtn = document.getElementById("sidebarToggle");
        const nav = document.querySelector("nav");
        if (toggleBtn && nav) {
            toggleBtn.addEventListener("click", function() {
                nav.classList.toggle("collapsed");
            });
        }
    });
    $(document).on('click', '.view-btn', function() {
        var detailRow = $(this).closest('tr').next('.order-detail-row');
        detailRow.slideToggle(200);
        $(this).toggleClass('active');
        if ($(this).find('.bi-eye-slash').length === 0) {
            $(this).append('<i class="bi bi-eye-slash"></i>');
        }
    });
    // Hàm hỗ trợ kích hoạt tab từ Dropdown Menu
    function triggerTab(targetId) {
        // Tìm link trong sidebar tương ứng với targetId và kích hoạt click
        const sidebarLink = document.querySelector(`.nav-link[data-target="${targetId}"]`);
        if (sidebarLink) {
            sidebarLink.click(); // Giả lập click vào sidebar để chạy logic ẩn/hiện div có sẵn
        }
    }
</script>
        <script src="${BASE_URL}/js/staff-import.js"></script>

    </body>

</html>