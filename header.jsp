<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="DAO.CartDAO" %>
<%@ page import="DAO.ProductDAO" %>
<%@ page import="DAO.VoucherDAO" %>
<%@ page import="DAO.OrderDAO" %> 
<%@ page import="entity.Cart" %>
<%@ page import="entity.Product" %>
<%@ page import="entity.Voucher" %>
<%@ page import="entity.Orders" %> 
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"
      integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA=="
      crossorigin="anonymous"
      referrerpolicy="no-referrer" />

<%
    // --- Logic Java (Cart & Voucher) ---
    CartDAO headerCartDAO = new CartDAO();
    ProductDAO headerProductDAO = new ProductDAO();
    VoucherDAO headerVoucherDAO = new VoucherDAO(); // Giữ lại nếu cần cho Voucher Tổng Đơn

    List<Cart> headerCartList = new ArrayList<>();
    int headerCartItemCount = 0;

    // Map chứa thông tin sản phẩm để hiển thị trong Cart Preview
    Map<Integer, Product> headerProductMap = new HashMap<>();

    // [UPDATE] Map này để lưu Discount Int (ID Product -> Discount %)
    Map<Integer, Integer> headerDiscountMap = new HashMap<>();

    // [OPTIONAL] Map Voucher Tổng Đơn (nếu web có tính năng này)
    Map<String, Integer> headerVoucherMap = new HashMap<>();
    List<Voucher> voucherList = headerVoucherDAO.getAll();
    for (Voucher p : voucherList) {
        headerVoucherMap.put(p.getVoucherID(), p.getVoucherPercent());
    }
    pageContext.setAttribute("headerVoucherMap", headerVoucherMap);

    entity.Customer headerCustomer = (entity.Customer) session.getAttribute("acc");

    // --- Logic Java (Order Counts for Dropdown) ---
    int headerTotalActive = 0;
    int headerTotalHistory = 0;

    if (headerCustomer != null) {
        try {
            int customerId = headerCustomer.getCustomer_id();

            // 1. Get Cart Data
            headerCartList = headerCartDAO.getAll(customerId);
            headerCartItemCount = headerCartList.size();

            for (Cart item : headerCartList) {
                if (!headerProductMap.containsKey(item.getProductID())) {
                    Product p = headerProductDAO.getProductById(item.getProductID());
                    headerProductMap.put(item.getProductID(), p);

                    // [UPDATE] Lưu discount int vào map
                    if (p != null) {
                        headerDiscountMap.put(p.getId(), p.getDiscount());
                    }
                }
            }

            // 2. Get Order Data (Check if already in request, else query DAO)
            List<Orders> headerOrderList = (List<Orders>) request.getAttribute("ordersUserList");
            if (headerOrderList == null) {
                OrderDAO headerOrderDAO = new OrderDAO();
                headerOrderList = headerOrderDAO.orderUser(customerId);
            }

            if (headerOrderList != null) {
                for (Orders o : headerOrderList) {
                    if ("Pending".equals(o.getStatus()) || "Delivering".equals(o.getStatus())) {
                        headerTotalActive++;
                    } else if ("Delivered".equals(o.getStatus()) || "Completed".equals(o.getStatus()) || "Cancelled".equals(o.getStatus())) {
                        headerTotalHistory++;
                    }
                }
            }

        } catch (Exception e) {
            headerCartList = new ArrayList<>();
            headerCartItemCount = 0;
            headerTotalActive = 0;
            headerTotalHistory = 0;
        }
    }

    pageContext.setAttribute("headerCartList", headerCartList);
    pageContext.setAttribute("headerCartItemCount", headerCartItemCount);
    pageContext.setAttribute("headerProductMap", headerProductMap);
    pageContext.setAttribute("headerDiscountMap", headerDiscountMap); // [NEW]
    pageContext.setAttribute("headerTotalActive", headerTotalActive);
    pageContext.setAttribute("headerTotalHistory", headerTotalHistory);
%>

<style>
    /* ===== RESET & BASIC SETUP ===== */
    :root {
        --logo-color: #a0816c;
        --text-color: #333;
        --header-height: 80px;
    }

    /* ===== HEADER CONTAINER ===== */
    .header {
        position: sticky;
        top: 0;
        z-index: 9985;
        background-color: #fff;
    }

    .header_title {
        background-color: #f5f5f5;
        font-size: 0.8125rem;
        font-weight: 500;
        height: 30px;
        overflow: hidden;
        position: relative;
        display: flex;
        align-items: center;
        /* justify-content: center; <-- Bỏ cái này để text chạy từ lề */
    }

    .main-header-bar {
        background-color: #fff;
        height: var(--header-height);
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
        transition: all 0.3s ease;
    }
    .main-header-bar.is-sticky {
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    }

    /* ===== FLEXBOX LAYOUT ===== */
    .headerContent {
        max-width: 1320px;
        margin: 0 auto;
        height: 100%;
        padding: 0 20px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        position: relative;
    }

    /* 1. Logo Section */
    .logo {
        flex-shrink: 0;
        width: 150px;
    }
    .logo a {
        text-decoration: none;
        color: var(--logo-color);
        font-size: 1.8em;
        font-weight: bold;
    }

    /* 2. Navigation Section */
    nav {
        flex: 1;
        display: flex;
        justify-content: center;
        height: 100%;
    }
    .headerList {
        margin: 0;
        padding: 0;
        list-style: none;
        display: flex;
        align-items: center;
        height: 100%;
    }

    /* 3. Tools Section */
    .headerTool {
        display: flex;
        align-items: center;
        justify-content: flex-end;
        gap: 15px;
        flex-shrink: 0;
        min-width: 150px;
        height: 100%;
    }

    /* ===== MENU STYLES & EFFECTS ===== */
    .headerListItem {
        height: 100%;
        display: flex;
        align-items: center;
        position: relative;
        margin: 0 5px;
    }

    .headerListItem > a {
        text-decoration: none;
        color: #a0816c;
        font-weight: 600;
        padding: 8px 15px;
        border-radius: 30px;
        white-space: nowrap;
        transition: all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94);
        transform: scale(1);
    }

    .headerListItem:hover > a {
        color: #c69c6d;
        transform: scale(1.1);
        background-color: rgba(255, 255, 255, 0.5);
        text-shadow: 0 0 5px rgba(255, 255, 255, 0.8), 0 0 10px rgba(255, 204, 153, 0.6);
    }

    .headerListItem > a:active {
        transform: scale(0.95) !important;
        background-color: rgba(0,0,0,0.08) !important;
        transition: all 0.05s ease !important;
    }

    .dropdown-icon {
        font-size: 0.75em;
        margin-left: 5px;
    }

    /* Dropdown Menu Cấp 1 */
    .headerListItem .dropdownMenu {
        position: absolute;
        top: 100%;
        left: 50%;
        transform: translateX(-50%) translateY(10px);
        background: #fff;
        width: 180px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.15);
        border-radius: 0 0 8px 8px;
        visibility: hidden;
        opacity: 0;
        transition: all 0.3s ease;
        z-index: 1000;
        padding: 10px 0;
    }
    .headerListItem:hover .dropdownMenu {
        visibility: visible;
        opacity: 1;
        transform: translateX(-50%) translateY(0);
    }
    .dropdownMenu li {
        list-style: none;
    }
    .dropdownMenu li a {
        display: block;
        padding: 8px 20px;
        color: #555;
        text-decoration: none;
        transition: background 0.2s, color 0.2s, padding 0.2s;
    }
    .dropdownMenu li a:hover {
        background-color: #f9f9f9;
        color: var(--logo-color);
        padding-left: 25px;
    }

    /* ===== TOOL ICONS EFFECTS ===== */
    .headerToolIcon {
        position: relative;
        height: 40px;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .headerToolIcon > a {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 40px;
        height: 40px;
        border-radius: 50%;
        color: #333;
        text-decoration: none;
        transition: all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94);
        transform: scale(1);
    }
    .headerToolIcon > a .icon {
        font-size: 22px;
        transition: transform 0.3s;
    }

    .headerToolIcon:not(#profile-icon-container):hover > a .icon {
        transform: scale(1.2);
        color: var(--logo-color);
    }
    .headerToolIcon:not(#profile-icon-container):hover > a {
        background-color: rgba(0,0,0,0.03);
    }

    .headerToolIcon:not(#profile-icon-container) > a:active {
        transform: scale(0.9) !important;
        background-color: rgba(0,0,0,0.1) !important;
        transition: all 0.05s ease !important;
    }
    .headerToolIcon:not(#profile-icon-container) > a:active .icon {
        transform: scale(0.9) !important;
        color: #8a6d58 !important;
    }

    /* ===== DROPDOWNS (CART & PROFILE) ===== */
    .cart-preview-dropdown, .profile-dropdown {
        position: absolute;
        top: 100%;
        right: 0;
        left: auto;
        background-color: #fff;
        box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        border-radius: 8px;
        z-index: 9999;
        visibility: hidden;
        opacity: 0;
        transform: scale(0.8);
        transform-origin: top right;
        transition: all 0.3s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        margin-top: 10px;
        list-style: none;
        padding: 0;
    }
    .cart-preview-dropdown::before, .profile-dropdown::before {
        content: "";
        position: absolute;
        top: -15px;
        right: 0;
        width: 100%;
        height: 20px;
        background: transparent;
    }
    .headerToolIcon:hover .cart-preview-dropdown, .headerToolIcon:hover .profile-dropdown {
        visibility: visible;
        opacity: 1;
        transform: scale(1);
    }

    /* ============================================================= */
    /* CART STYLES                                                   */
    /* ============================================================= */
    .cart-preview-dropdown {
        width: 400px;
        padding: 10px;
        border-radius: 8px;
        box-shadow: 0 10px 25px rgba(0,0,0,0.15);
        border-top: 3px solid #a0816c;
    }

    .cart-badge {
        position: absolute;
        top: -2px;
        right: -2px;
        background: #d70000;
        color: #fff;
        border-radius: 50%;
        width: 18px;
        height: 18px;
        font-size: 11px;
        font-weight: bold;
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 2;
    }

    .cart-preview-list {
        list-style: none;
        padding: 0;
        margin: 0;
        max-height: 300px;
        overflow-y: auto;
        scrollbar-width: thin;
    }
    .cart-preview-list::-webkit-scrollbar {
        width: 5px;
    }
    .cart-preview-list::-webkit-scrollbar-thumb {
        background-color: #ddd;
        border-radius: 5px;
    }

    .cart-preview-item {
        margin: 0;
        padding: 0;
        border-bottom: 1px solid #f0f0f0;
    }
    .cart-preview-item:last-child {
        border-bottom: none;
    }

    .cart-preview-item a {
        display: flex;
        align-items: center;
        padding: 10px 5px !important;
        margin: 0 !important;
        text-decoration: none;
        width: 100%;
        background-color: transparent !important;
        border-radius: 0 !important;
        transition: background-color 0.2s;
    }
    .cart-preview-item a:hover {
        background-color: #f9f9f9 !important;
    }
    .cart-preview-item a:active {
        background-color: #f0f0f0 !important;
        transform: scale(0.99);
        transition: 0.05s;
    }

    .cart-preview-image {
        width: 60px;
        height: 60px;
        object-fit: cover;
        margin-right: 10px;
        border: 1px solid #eee;
    }
    .cart-preview-info {
        flex: 1;
        overflow: hidden;
    }

    .cart-preview-name {
        font-size: 14px;
        color: #333;
        font-weight: 500;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        margin-bottom: 5px;
    }
    .cart-preview-price {
        font-size: 15px;
        font-weight: 600;
        color: #d70000;
    }
    .cart-preview-header {
        padding: 5px 5px 10px 5px;
        margin-bottom: 5px;
        border-bottom: 1px solid #eee;
        color: #777;
        font-size: 0.9rem;
        font-weight: 600;
    }
    .cart-preview-footer {
        border-top: 1px solid #eee;
        padding-top: 10px;
        margin-top: 5px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }
    .cart-preview-count {
        font-size: 13px;
        color: #555;
    }

    .btn-view-cart {
        background-color: var(--logo-color, #a0816c);
        color: white;
        padding: 8px 20px !important;
        text-decoration: none;
        border-radius: 8px !important;
        font-size: 13px;
        font-weight: 600;
        transition: all 0.2s ease;
        display: inline-block !important;
    }
    .btn-view-cart:hover {
        background-color: #7a5d48 !important;
        color: white !important;
        box-shadow: 0 4px 8px rgba(122, 93, 72, 0.4);
        transform: translateY(-2px);
    }
    .btn-view-cart:active {
        transform: scale(0.95) translateY(0) !important;
        background-color: #634b3a !important;
        box-shadow: none !important;
        transition: 0.05s !important;
    }

    /* ========================================================== */
    /* [FIXED] PROFILE STYLES                                   */
    /* ========================================================== */
    #profile-icon-container {
        width: auto;
        padding: 0 10px;
        border-radius: 30px;
        cursor: pointer;
        transition: background 0.3s;
    }
    #profile-icon-container:hover {
        background-color: #f5f5f5;
    }

    #profile-icon-container:active {
        transform: none !important;
        background-color: #f5f5f5;
    }

    #profile-icon-container > a {
        width: auto;
        gap: 10px;
    }
    .profile-text-block {
        display: flex;
        flex-direction: column;
        line-height: 1.2;
        text-align: left;
    }
    .profile-greeting {
        font-size: 0.85rem;
        font-weight: 700;
        color: var(--logo-color);
    }
    .profile-welcome-msg {
        font-size: 0.75rem;
        color: #888;
    }
    .profile-dropdown {
        width: 220px;
        padding: 5px 0;
    }
    .profile-dropdown li {
        list-style: none !important;
    }

    .profile-dropdown li a {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 10px 20px;
        color: #333;
        text-decoration: none;
        transition: 0.2s;
    }
    .profile-dropdown li a div {
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .profile-dropdown li a:hover {
        background-color: #f9f9f9;
        color: var(--logo-color);
    }
    .menu-divider {
        margin: 5px 0;
        border-top: 1px dashed #eee;
    }

    .badge-dropdown {
        background-color: #dc3545;
        color: white;
        border-radius: 50%;
        padding: 2px 6px;
        font-size: 0.75rem;
        min-width: 18px;
        text-align: center;
    }

    /* ========================================================== */
    /* SEARCH BOX & HOVER ZOOM EFFECTS                            */
    /* ========================================================== */
    .search-overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
        z-index: 9990;
        opacity: 0;
        visibility: hidden;
        transition: opacity 0.4s ease-in-out, visibility 0.4s ease-in-out;
    }
    .search-overlay.is-visible {
        opacity: 1;
        visibility: visible;
    }

    .searchBox {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: auto;
        background-color: #fff;
        box-shadow: 0 8px 20px rgba(0,0,0,0.12);
        z-index: 9995;
        transform: translateY(-100%);
        transition: transform 0.4s ease-in-out;
        display: block !important;
    }
    .searchBox.is-open {
        transform: translateY(0);
    }

    .searchBox-content {
        width: 80%;
        max-width: 80vw;
        margin: 0 auto;
        padding: 30px;
        padding-top: 50px;
        position: relative;
        display: flex;
        flex-direction: column;
    }

    .search-close-btn {
        position: absolute;
        top: 25px;
        right: 30px;
        font-size: 28px;
        color: #888;
        cursor: pointer;
        transition: color 0.2s ease;
    }
    .search-close-btn:hover {
        color: #333;
    }
    .search-close-btn:active {
        transform: scale(0.9);
        color: var(--logo-color);
        transition: 0.05s;
    }

    .searchBox-content h2 {
        font-size: 14px;
        font-weight: 600;
        color: #777;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        margin-bottom: 15px;
    }

    .search-input {
        position: relative;
        flex-shrink: 0;
        display: block;
    }
    .search-input input {
        width: 100%;
        border: 1px solid #ddd;
        background-color: #fff;
        height: 44px;
        padding: 8px 45px 8px 20px;
        font-size: 15px;
        border-radius: 50px;
        transition: all 0.3s ease;
    }
    .search-input input:focus {
        outline: none;
        border-color: var(--logo-color);
        box-shadow: 0 0 10px rgba(160, 129, 108, 0.4);
    }

    .search-input button {
        position: absolute;
        right: 5px;
        top: 0;
        height: 100%;
        width: 45px;
        border: none;
        background-color: transparent;
        color: #a0816c;
        font-size: 18px;
        cursor: pointer;
        transition: transform 0.2s ease;
    }
    .search-input button:hover {
        transform: scale(1.1);
        color: #8a6d58;
    }
    .search-input button:active {
        transform: scale(0.9);
        transition: 0.05s;
    }

    #search-clear-btn {
        position: absolute;
        right: 45px;
        top: 50%;
        transform: translateY(-50%);
        color: #aaa;
        cursor: pointer;
        font-size: 16px;
        display: none;
    }
    #search-clear-btn:hover {
        color: #333;
    }

    .search-list {
        height: 0px;
        opacity: 0;
        visibility: hidden;
        overflow-y: hidden;
        overflow-x: hidden;
        transition: height 0.5s cubic-bezier(0.25, 0.8, 0.25, 1), opacity 0.4s ease;
        margin-top: 0;
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
        gap: 20px;
        width: 100%;
    }
    .search-list.active {
        opacity: 1;
        visibility: visible;
        margin-top: 20px;
        padding-bottom: 5px;
    }

    .search-footer {
        text-align: center;
        margin-top: 20px;
        display: none;
        width: fit-content;
        min-width: 100px;
        margin-left: auto;
        margin-right: auto;
        flex-shrink: 0;
    }
    .search-footer.show {
        display: block;
        animation: fadeInUp 0.4s ease;
    }

    .btn-close-search {
        background-color: #fff;
        border: 1px solid #ccc;
        color: #555;
        padding: 8px 35px;
        border-radius: 25px;
        font-size: 13px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.2s ease;
        text-transform: uppercase;
        letter-spacing: 1px;
        box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        white-space: nowrap;
    }
    .btn-close-search:hover {
        background-color: #a0816c;
        border-color: #a0816c;
        color: white;
        box-shadow: 0 4px 8px rgba(0,0,0,0.15);
    }
    .btn-close-search:active {
        transform: scale(0.95);
        background-color: #8a6d58;
        color: white;
        transition: 0.05s;
    }

    @keyframes fadeInUp {
        from {
            opacity: 0;
            transform: translateY(10px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    /* CARD SẢN PHẨM TRONG SEARCH */
    .search-card {
        border: 1px solid #f0f0f0;
        border-radius: 8px;
        overflow: hidden;
        background: #fff;
        min-height: 250px;
        cursor: pointer;
        transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
        transform: scale(1);
    }
    .search-card:hover {
        transform: scale(1.03);
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.12);
        z-index: 2;
        border-color: #e0e0e0;
    }
    .search-card:active {
        transform: scale(0.98);
        box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        transition: 0.05s ease;
    }

    .search-card-link {
        text-decoration: none;
        display: block;
        height: 100%;
    }
    .search-card-image {
        position: relative;
    }
    .search-card-image img {
        width: 100%;
        height: 180px;
        object-fit: cover;
        display: block;
    }
    .search-card-badge {
        position: absolute;
        top: 8px;
        left: 8px;
        background: #d70000;
        color: #fff;
        padding: 2px 6px;
        border-radius: 4px;
        font-size: 11px;
        font-weight: 600;
    }
    .search-card-info {
        padding: 12px;
        text-align: left;
    }
    .search-card-name {
        font-size: 14px;
        font-weight: 600;
        color: #333;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        margin-bottom: 8px;
    }
    .search-card-price {
        display: flex;
        align-items: center;
        gap: 8px;
        flex-wrap: wrap;
    }
    .search-card-sale-price {
        font-size: 15px;
        font-weight: 700;
        color: #d70000;
    }
    .search-card-original-price {
        font-size: 13px;
        color: #888;
        text-decoration: line-through;
        margin-left: 5px;
    }

    /* ========================================================== */
    /* [FIXED] MARQUEE ANIMATION (RIGHT TO LEFT)                  */
    /* ========================================================== */
    .marquee-text {
        display: inline-block;
        white-space: nowrap;
        animation: scrollLeft 20s linear infinite;
        padding-left: 100%;
        color: #aaa
    }

    @keyframes scrollLeft {
        0% {
            transform: translateX(0);
        }
        100% {
            transform: translateX(-100%);
        }
    }

    .no-products-found {
        text-align: center;
        font-size: 1.2em;
        color: #777;
        padding: 50px 0;
        font-weight: 500;
        grid-column: 1 / -1;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        width: 100%;
    }
    .no-products-found .no-products-icon {
        font-size: 5rem;
        color: #ccc;
        display: block;
        margin-bottom: 15px;
    }
</style>

<header class="header">
    <div class="header_title">
        <span class="marquee-text"><strong>Free shipping</strong> on all orders!!!</span>
    </div>

    <div class="main-header-bar">
        <div class="headerContent">

            <div class="logo"><a href="${pageContext.request.contextPath}/">GIO</a></div>

            <nav>
                <ul class="headerList">
                    <li class="headerListItem"><a href="${pageContext.request.contextPath}/">Home Page</a></li>

                    <li class="headerListItem">
                        <a href="${pageContext.request.contextPath}/productList/male">Men's Fashion<i class="bi bi-caret-down dropdown-icon"></i></a>
                        <ul class="dropdownMenu">
                            <li><a href="${pageContext.request.contextPath}/productList/male/t_shirt">T-shirt</a></li>
                            <li><a href="${pageContext.request.contextPath}/productList/male/pant">Long pants</a></li>
                            <li><a href="${pageContext.request.contextPath}/productList/male/short">Shorts</a></li>
                        </ul>
                    </li>

                    <li class="headerListItem">
                        <a href="${pageContext.request.contextPath}/productList/female">Women's Fashion<i class="bi bi-caret-down dropdown-icon"></i></a>
                        <ul class="dropdownMenu">
                            <li><a href="${pageContext.request.contextPath}/productList/female/t_shirt">T-shirt</a></li>
                            <li><a href="${pageContext.request.contextPath}/productList/female/pant">Long pants</a></li>
                            <li><a href="${pageContext.request.contextPath}/productList/female/dress">Dress</a></li>
                        </ul>
                    </li>
                    <li class="headerListItem">
                        <a href="${pageContext.request.contextPath}/aboutUs.jsp">Information<i class="bi bi-caret-down dropdown-icon"></i></a>
                        <ul class="dropdownMenu">
                            <li><a href="${pageContext.request.contextPath}/aboutUs.jsp">About Us</a></li>
                            <li><a href="${pageContext.request.contextPath}/contact.jsp">Contact Us</a></li>
                            <li><a href="${pageContext.request.contextPath}/policy.jsp">Exchange policy</a></li>
                        </ul>
                    </li>
                </ul>
            </nav>

            <div class="headerTool">
                <div class="headerToolIcon">
                    <a href="javascript:void(0)" onclick="openSearchDrawer()">
                        <i class="bi bi-search icon"></i>
                    </a>
                </div>

                <div class="headerToolIcon">
                    <a href="${pageContext.request.contextPath}/loadCart">
                        <i class="bi bi-cart2 icon"></i>
                        <c:if test="${headerCartItemCount > 0}">
                            <span class="cart-badge">${headerCartItemCount}</span>
                        </c:if>
                    </a>

                    <c:if test="${not empty headerCartList}">
                        <div class="cart-preview-dropdown">
                            <div class="cart-preview-header">Products you've added:</div>
                            <ul class="cart-preview-list">
                                <c:forEach var="item" items="${headerCartList}">
                                    <c:set var="product" value="${headerProductMap[item.productID]}" />
                                    <c:if test="${not empty product}">
                                        <li class="cart-preview-item">
                                            <a href="${pageContext.request.contextPath}/productDetail?id=${product.id}">
                                                <img src="${product.picURL}" alt="${product.name}" class="cart-preview-image" onerror="this.src='${pageContext.request.contextPath}/images/default.jpg'"/>
                                                <div class="cart-preview-info">
                                                    <span class="cart-preview-name">${product.name}</span>

                                                    <div style="font-size: 0.8rem; color: #777; margin-bottom: 2px;">
                                                        Size: <strong>${item.size_name}</strong> | Quantity: ${item.quantity}
                                                    </div>

                                                    <div class="cart-preview-price">
                                                        <%-- Hiển thị giá trong Cart (giá tại thời điểm thêm) --%>
                                                        <fmt:formatNumber value="${item.price * item.quantity}" type="number" groupingUsed="true" /> VND
                                                    </div>
                                                </div>
                                            </a>
                                        </li>
                                    </c:if>
                                </c:forEach>
                            </ul>
                            <div class="cart-preview-footer">
                                <span class="cart-preview-count">${headerCartItemCount} Product(s)</span>
                                <a href="${pageContext.request.contextPath}/loadCart" class="btn-view-cart">View Cart</a>
                            </div>
                        </div>
                    </c:if>
                </div>

                <c:choose>
                    <c:when test="${not empty sessionScope.acc}">
                        <div class="headerToolIcon" id="profile-icon-container">
                            <a href="${pageContext.request.contextPath}/profile"> 
                                <i class="bi bi-person-circle icon" style="font-size: 28px;"></i>
                                <div class="profile-text-block">
                                    <span class="profile-greeting">${sessionScope.acc.username}</span>
                                    <span class="profile-welcome-msg">Welcome to GIO Shop!</span>
                                </div>
                            </a>

                            <ul class="profile-dropdown">
                                <li>
                                    <a href="${pageContext.request.contextPath}/profile">
                                        <div><i class="bi bi-person"></i> My Profile</div>
                                    </a>
                                </li>

                                <c:if test="${empty acc.google_id}">
                                    <li>
                                        <a href="${pageContext.request.contextPath}/changePassword.jsp">
                                            <div><i class="bi bi-key"></i> Change Password</div>
                                        </a>
                                    </li>
                                </c:if>


                                <li>
                                    <a href="${pageContext.request.contextPath}/orderView">
                                        <div><i class="bi bi-box-seam"></i> My Orders</div>
                                        <c:if test="${headerTotalActive > 0}">
                                            <span class="badge-dropdown">${headerTotalActive}</span>
                                        </c:if>
                                    </a>
                                </li>
                                <li>
                                    <a href="${pageContext.request.contextPath}/orderHistoryView">
                                        <div><i class="bi bi-clock-history"></i> Order History</div>
                                    </a>
                                </li>
                                <li>
                                    <a href="${pageContext.request.contextPath}/my-feedback">
                                        <div><i class="fa-regular fa-star"></i> My Feedbacks</div>
                                    </a>
                                </li>
                                <li class="menu-divider"></li>
                                <li>
                                    <a href="${pageContext.request.contextPath}/cookieHandle" onclick="return confirm('Are you sure you want to Sign out?')">
                                        <div>
                                            <i class="bi bi-box-arrow-right"></i> Sign Out
                                        </div>
                                    </a>
                                </li>
                            </ul>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <div class="headerToolIcon">
                            <a href="${pageContext.request.contextPath}/login.jsp"><i class="bi bi-person icon"></i></a>
                        </div>
                    </c:otherwise>
                </c:choose>

            </div> 
        </div> 
    </div> 
</header>

<div class="search-overlay" id="search-overlay" onclick="closeSearchDrawer()"></div>
<div class="searchBox" id="box1">
    <div class="searchBox-content">
        <i class="bi bi-x-lg search-close-btn" onclick="closeSearchDrawer()"></i>
        <h2>SEARCH</h2>
        <div class="search-input">
            <input oninput="searchByName(this)" name="search" type="text" size="20" placeholder="Search for products..." id="search-input-field">
            <button><i class="bi bi-search"></i></button>
            <span id="search-clear-btn" onclick="clearSearch()">
                <i class="bi bi-x-circle-fill"></i>
            </span>
        </div>

        <div class="search-list" id="search-ajax">
        </div>

        <div id="search-footer" class="search-footer">
            <button class="btn-close-search" onclick="clearSearch()">CLOSE</button>
        </div>
    </div>
</div>

<script type="text/javascript">
    var contextPath = "${pageContext.request.contextPath}";

    // --- Sticky Header ---
    window.addEventListener("scroll", function () {
        const headerBar = document.querySelector(".main-header-bar");
        if (window.scrollY > 20) {
            headerBar.classList.add("is-sticky");
        } else {
            headerBar.classList.remove("is-sticky");
        }
    });

    // --- Search Functionality ---
    function openSearchDrawer() {
        document.getElementById('box1').classList.add('is-open');
        document.getElementById('search-overlay').classList.add('is-visible');
        document.getElementById('search-input-field').focus();
    }

    function closeSearchDrawer() {
        document.getElementById('box1').classList.remove('is-open');
        document.getElementById('search-overlay').classList.remove('is-visible');
    }

    function clearSearch() {
        var input = document.getElementById('search-input-field');
        var clearBtn = document.getElementById('search-clear-btn');
        var results = document.getElementById('search-ajax');
        var footer = document.getElementById('search-footer');

        input.value = "";
        results.style.height = "0px";
        results.classList.remove("active");
        footer.classList.remove("show");
        clearBtn.style.display = 'none';
        input.focus();
        setTimeout(function () {
            results.innerHTML = "";
            results.style.overflowY = "hidden";
        }, 500);
    }

    var searchTimeout = null;

    function searchByName(name) {
        var search = name.value;
        var clearBtn = document.getElementById('search-clear-btn');
        var row = document.getElementById("search-ajax");
        var footer = document.getElementById('search-footer');

        if (search.length > 0) {
            clearBtn.style.display = 'block';
        } else {
            clearSearch();
            return;
        }

        if (searchTimeout) {
            clearTimeout(searchTimeout);
        }

        row.style.height = "0px";
        row.classList.remove("active");
        footer.classList.remove("show");

        searchTimeout = setTimeout(function () {
            $.ajax({
                url: contextPath + "/searchProductByAJAX",
                type: "get",
                data: {txt: search},
                success: function (data) {
                    var contentHTML;
                    if (data && data.trim().length > 0) {
                        contentHTML = data;
                    } else {
                        contentHTML = '<div class="no-products-found">' +
                                '<i class="bi bi-box-seam no-products-icon"></i>' +
                                ' Opps! There are no products that you are looking for...' +
                                '</div>';
                    }

                    row.innerHTML = contentHTML;

                    var productLinks = row.querySelectorAll('a');
                    productLinks.forEach(function (link) {
                        var href = link.getAttribute('href');
                        if (href && href.indexOf('productDetail') === 0) {
                            link.setAttribute('href', contextPath + '/' + href);
                        }
                    });

                    row.classList.add("active");
                    footer.classList.add("show");

                    var contentHeight = row.scrollHeight;
                    var maxHeight = window.innerHeight * 0.6;
                    var targetHeight = Math.min(contentHeight, maxHeight);

                    row.style.height = targetHeight + "px";
                    if (contentHeight > maxHeight) {
                        row.style.overflowY = "auto";
                    } else {
                        row.style.overflowY = "hidden";
                    }
                },
                error: function (xhr) {
                    row.innerHTML = "<div class='no-products-found'>" +
                            "<i class='bi bi-exclamation-triangle-fill' style='font-size: 4rem; margin-bottom: 10px; color: #dc3545;'></i>" +
                            "Error loading results. Please try again." +
                            "</div>";
                    row.classList.add("active");
                    footer.classList.add("show");
                    var contentHeight = row.scrollHeight;
                    row.style.height = contentHeight + "px";
                    row.style.overflowY = "hidden";
                }
            });
        }, 300);
    }
</script>