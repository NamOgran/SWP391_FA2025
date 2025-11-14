<%-- 
    Document   : login (UPGRADED - Yody Style)
    Created on : Feb 28, 2024, 5:18:02 PM
    Author     : duyentq
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login - GIO</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-iYQeCzEYFbKjA/T2uDLTpkwGzCiq6soy8tYaI1GyVh/UjpbCx/TYkiZhlZB6+fzT" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link href='https://fonts.googleapis.com/css?family=Quicksand' rel='stylesheet'>
        <link rel="icon" href="/Project_SWP391_Group4/images/LG1.png" type="image/x-icon">

        <script src="https://www.google.com/recaptcha/api.js" async defer></script>
        <style>
            /* === CSS GỐC (GIỮ NGUYÊN) === */
            * {
                margin: 0;
                padding: 0;
                font-family: 'Quicksand', sans-serif;
                box-sizing: border-box;
                color: rgb(151, 143, 137);
            }
            img {
                width: 100%;
            }
            :root {
                --logo-color: #a0816c;
                --nav-list-color: #a0816c;
                --icon-color: #a0816c;
                --text-color: #a0816c;
                --bg-color: #a0816c;
            }
            body {
                background-color: #f8f9fa;
            } /* Nền xám nhạt */
            body::-webkit-scrollbar {
                width: 0.5em;
            }
            body::-webkit-scrollbar-track {
                box-shadow: inset 0 0 6px rgba(0, 0, 0, 0.3);
            }
            body::-webkit-scrollbar-thumb {
                border-radius: 50px;
                background-color: var(--bg-color);
                outline: 1px solid slategrey;
            }
            nav {
                height: 70px;
                justify-content: center;
                display: flex;
            }
            .header_title {
                display: flex;
                text-align: center;
                justify-content: center;
                align-items: center;
                background-color: #f5f5f5;
                font-size: 0.8125rem;
                font-weight: 500;
                height: 30px;
            }
            .headerContent {
                max-width: 1200px;
                margin: 0 auto;
            }
            .headerContent, .headerList, .headerTool {
                display: flex;
                align-items: center;
            }
            .headerContent {
                justify-content: space-around;
            }
            .logo a {
                text-decoration: none;
                color: var(--logo-color);
                font-size: 1.5em;
                font-weight: bold;
            }
            .headerList {
                margin: 0;
                list-style-type: none;
            }
            .headerListItem {
                transition: font-size 0.3s ease;
                height: 24px;
            }
            .headerListItem a {
                margin: 0 10px;
                padding: 22px 0;
                text-decoration: none;
                color: var(--text-color);
            }
            .dropdown-icon {
                margin-left: 2px;
                font-size: 0.7500em;
            }
            .dropdownMenu {
                position: absolute;
                width: 200px;
                padding: 0;
                margin-top: 17px;
                background-color: #fff;
                display: none;
                z-index: 1;
                box-shadow: rgba(0, 0, 0, 0.35) 0px 5px 15px;
            }
            .dropdownMenu li {
                list-style-type: none;
                margin: 0;
                border-bottom: 1px solid rgb(235 202 178);
            }
            .dropdownMenu li a {
                text-decoration: none;
                padding: 5px 15px;
                margin: 0;
                width: 100%;
                display: flex;
                font-size: 0.9em;
                color: var(--text-color);
            }
            .dropdownMenu li:hover {
                background-color: #f1f1f1;
            }
            .headerListItem:hover .dropdownMenu {
                display: block;
            }
            .headerTool a {
                padding: 5px;
            }
            .headerToolIcon {
                width: 45px;
                justify-content: center;
                display: flex;
            }
            .icon {
                cursor: pointer;
                font-size: 26px;
            }
            .searchBox {
                width: 420px;
                position: absolute;
                top: 100px;
                right: 13%;
                left: auto;
                z-index: 990;
                background-color: #fff;
                box-shadow: rgba(0, 0, 0, 0.35) 0px 5px 15px;
                display: none;
            }
            .search-input {
                position: relative;
            }
            .search-input input {
                width: 100%;
                border: 1px solid #e7e7e7;
                background-color: #f6f6f6;
                height: 44px;
                padding: 8px 50px 8px 20px;
                font-size: 1em;
            }
            .search-input button {
                position: absolute;
                right: 1px;
                top: 1px;
                height: 42px;
                width: 15%;
                border: none;
                background-color: #f6f6f6;
            }
            .search-input input:focus {
                outline: none;
                border-color: var(--bg-color);
            }
            hr {
                margin-top: 0;
                margin-bottom: 10px;
            }
            footer {
                background-color: #f5f5f5;
            }
            .content-footer {
                text-align: center;
                padding: 30px;
            }
            .items-footer {
                margin: 5% 5% 0 5%;
            }
            body {
                margin-bottom: 0;
                padding-bottom: 0;
            }
            footer {
                margin-bottom: 0;
                padding-bottom: 0;
            }
            #highlight {
                color: #a0816c;
            }
            #img-footer img {
                padding: 0;
            }
            #img-footer {
                margin: 0 auto;
            }
            .phone {
                position: relative;
            }
            .bi-telephone {
                cursor: pointer;
                font-size: 3em;
                position: absolute;
                top: -16%;
                left: 15px;
            }
            .contact-item {
                display: flex;
            }
            .contact-link {
                margin-right: 10px;
                border: 1px solid #a0816c;
                border-radius: 5px;
                padding: 5px;
                width: 35.6px;
                justify-content: center;
                display: flex;
            }
            .contact-link:hover {
                background-color: var(--bg-color);
            }
            .contact-link:hover .bi-facebook::before,
            .contact-link:hover .bi-instagram::before {
                color: white;
            }
            .search-info {
                display: flex;
                margin: 10px 0;
            }
            .title {
                width: 88%;
            }
            .search-img {
                width: 12%;
            }
            .search-info a {
                padding: 0;
            }
            .search-img a img {
                width: 100%;
            }
            .title a {
                text-decoration: none;
                color: #cfb997;
            }
            .title p {
                margin: 0;
                margin-top: 14px;
                font-size: .8em;
            }
            .search-list {
                max-height: 280px;
                overflow-y: scroll;
                scrollbar-width: none;
            }
            @media (max-width: 1024px) {
                .infoBox, .searchBox, .cartBox {
                    right: 0;
                }
            }

            /* === STYLE MỚI CHO TRANG LOGIN.JSP === */

            .main-content-wrapper {
                max-width: 1200px;
                margin: 40px auto;
                padding: 0 15px;
            }

            .login-card {
                max-width: 480px; /* Độ rộng card */
                margin: 0 auto;
                background: #fff;
                border: 1px solid #f0f0f0;
                border-radius: 12px;
                box-shadow: 0 8px 24px rgba(18, 38, 63, .05);
                padding: 30px 35px;
            }

            .login-card h2 {
                color: #a0816c;
                margin-top: 0;
                margin-bottom: 10px;
                font-size: 26px;
                font-weight: 700;
                font-family: "Quicksand", sans-serif;
                text-align: center;
            }
            .login-card h3 {
                font-size: 16px;
                color: #9E9E9E;
                margin-top: 0;
                margin-bottom: 25px;
                font-family: "Quicksand", sans-serif;
                text-align: center;
                font-weight: 500;
            }

            /* Google Login (Style từ file gốc) */
            .google-login-btn {
                display: flex;
                align-items: center;
                justify-content: center;
                width: 100%;
                padding: 10px 20px;
                background-color: #fff;
                border: 2px solid #ddd;
                border-radius: 8px;
                font-size: 15px;
                font-weight: 600;
                color: #333;
                cursor: pointer;
                transition: all 0.3s ease;
            }
            .google-login-btn:hover {
                background-color: #f5f5f5;
                border-color: #ccc;
            }
            .google-login-btn img {
                width: 20px;
                height: 20px;
                margin-right: 10px;
            }

            /* Dải phân cách "or" */
            .divider {
                display: flex;
                align-items: center;
                margin: 25px 0;
                color: #999;
                font-weight: 500;
            }
            .divider::before,
            .divider::after {
                content: "";
                flex: 1;
                border-bottom: 1px solid #ddd;
            }
            .divider span {
                padding: 0 15px;
            }

            /* Form Input hiện đại */
            .form-label {
                font-weight: 600;
                color: #444;
            }
            .form-control, .form-select {
                height: 48px;
                padding: 10px 15px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 15px;
            }
            .form-control:focus, .form-select:focus {
                border-color: var(--bg-color, #a0816c);
                box-shadow: 0 0 0 2px rgba(160, 129, 108, 0.2);
            }

            /* Căn giữa reCAPTCHA */
            .g-recaptcha-wrapper {
                display: flex;
                justify-content: center;
                margin-bottom: 20px;
                transform: scale(0.95);
                transform-origin: center;
            }

            /* Nút Login */
            .btn-login-submit {
                background: var(--bg-color, #a0816c);
                color: #fff;
                padding: 12px 0;
                outline: none;
                width: 100%;
                font-size: 16px;
                font-weight: 700;
                border: none;
                border-radius: 8px;
                transition: opacity 0.3s ease;
            }
            .btn-login-submit:hover {
                opacity: 0.85;
            }

            /* Links (Forgot/Signup) */
            .login-links {
                padding-top: 20px;
                text-align: center;
            }
            .login-links p {
                margin: 8px 0;
                font-size: 15px;
                color: #555;
            }
            .login-links a {
                color: var(--text-color, #a0816c);
                font-weight: 600;
                text-decoration: none;
            }
            .login-links a:hover {
                text-decoration: underline;
            }

            /* === CSS CHO THÔNG BÁO MỚI === */
            .toast-alert {
                position: fixed;
                top: 80px; /* Dưới header */
                right: 20px;
                padding: 15px 20px;
                background-color: #fff;
                border: 1px solid #f0f0f0;
                border-left: 5px solid #28a745; /* Green for success */
                border-radius: 8px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
                z-index: 9999;
                display: flex;
                align-items: center;
                gap: 10px;
                opacity: 1;
                transition: opacity 0.5s ease-in-out;
            }
            .toast-alert.success i.bi-check-circle-fill {
                color: #28a745;
            }
            .toast-alert .toast-message {
                color: #333;
                font-weight: 600;
            }
            .toast-alert .toast-close {
                cursor: pointer;
                color: #aaa;
                margin-left: 15px;
            }
            .toast-alert .toast-close:hover {
                color: #333;
            }
            /* Tạo hiệu ứng phát sáng nâu */
            .glow-brown {
                border: 1px solid #8B4513; /* màu nâu */
                box-shadow: 0 0 10px #8B4513;
                transition: box-shadow 0.3s ease, border-color 0.3s ease;
            }

            /* Khi hover hoặc focus thì sáng mạnh hơn */
            .glow-brown:hover,
            .glow-brown:focus {
                border-color: #A0522D;
                box-shadow: 0 0 5px #A0522D;
                outline: none;
            }
        </style>
    </head>

    <body>
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="toast-alert success" id="toast-alert">
                <i class="bi bi-check-circle-fill"></i>
                <span class="toast-message">${sessionScope.successMessage}</span>
                <i class="bi bi-x-lg toast-close" onclick="document.getElementById('toast-alert').style.display = 'none';"></i>
            </div>

            <script>
                // Tự động ẩn sau 5 giây
                setTimeout(function () {
                    var alert = document.getElementById('toast-alert');
                    if (alert) {
                        alert.style.opacity = '0';
                        setTimeout(function () {
                            alert.style.display = 'none';
                        }, 600);
                    }
                }, 5000);
            </script>

            <%-- RẤT QUAN TRỌNG: Xóa attribute để không hiện lại --%>
            <c:remove var="successMessage" scope="session" />
        </c:if>
        <header class="header">
            <div class="header_title">Free shipping with orders from&nbsp;<strong>200,000 VND </strong></div>
            <div class="headerContent">
                <div class="logo"><a href="productList">GIO</a></div>
                <nav>
                    <ul class="headerList">
                        <li class="headerListItem"><a href="productList">Home page</a></li>
                        <li class="headerListItem">
                            <a href="http://localhost:8080/Project_SWP391_Group4/productList/male">Men's Fashion<i class="bi bi-caret-down dropdown-icon"></i></a>
                            <ul class="dropdownMenu">
                                <li><a href="http://localhost:8080/Project_SWP391_Group4/productList/male/t_shirt">T-shirt</a></li>
                                <li><a href="http://localhost:8080/Project_SWP391_Group4/productList/male/pant">Long pants</a></li>
                                <li><a href="http://localhost:8080/Project_SWP391_Group4/productList/male/short">Shorts</a></li>
                            </ul>
                        </li>
                        <li class="headerListItem">
                            <a href="http://localhost:8080/Project_SWP391_Group4/productList/female">Women's Fashion<i class="bi bi-caret-down dropdown-icon"></i></a>
                            <ul class="dropdownMenu">
                                <li><a href="http://localhost:8080/Project_SWP391_Group4/productList/female/t_shirt">T-shirt</a></li>
                                <li><a href="http://localhost:8080/Project_SWP391_Group4/productList/female/pant">Long pants</a></li>
                                <li><a href="http://localhost:8080/Project_SWP391_Group4/productList/female/dress">Dress</a></li>
                            </ul>
                        </li>
                        <li class="headerListItem">
                            <a href="./aboutUs.jsp">Information<i class="bi bi-caret-down dropdown-icon"></i></a>
                            <ul class="dropdownMenu">
                                <li><a href="/Project_SWP391_Group4/aboutUs.jsp">About Us</a></li>
                                <li><a href="/Project_SWP391_Group4/contact.jsp">Contact</a></li>
                                <li><a href="/Project_SWP391_Group4/viewOrder.jsp">View order</a></li>
                                <li><a href="/Project_SWP391_Group4/policy.jsp">Exchange policy</a></li>
                                <li><a href="/Project_SWP391_Group4/orderHistoryView">Order's history</a></li>
                            </ul>
                        </li>
                    </ul>
                </nav>
                <div class="headerTool">
                    <div class="headerToolIcon">
                        <i class="bi bi-search icon" onclick="toggleBox('box1')"></i>
                        <div class="searchBox box" id="box1">
                            <div class="searchBox-content">
                                <h2>SEARCH</h2>
                                <div class="search-input">
                                    <input oninput="searchByName(this)" name="search" type="text" size="20" placeholder="Search for products...">
                                    <button><i class="bi bi-search"></i></button>
                                </div>
                                <div class="search-list" id="search-ajax"></div>
                            </div>
                        </div>
                    </div>
                    <div class="headerToolIcon">
                        <a href="http://localhost:8080/Project_SWP391_Group4/profile"><i class="bi bi-person icon"></i></a>
                    </div>
                    <div class="headerToolIcon">
                        <a href="${pageContext.request.contextPath}/loadCart"><i class="bi bi-cart2 icon"></i></a>
                    </div>
                </div>
            </div>
            <hr width="100%" , color="#d0a587" />
        </header>
        <main class="main-content-wrapper">
            <div class="row">
                <div class="col-lg-7 col-md-9 mx-auto"> 

                    <div class="login-card">
                        <h2>LOG IN</h2>
                        <h3>Enter your email and password</h3>

                        <div class="google-login-section">
                            <button type="button" class="google-login-btn" onclick="loginWithGoogle()">
                                <img src="https://developers.google.com/identity/images/g-logo.png" alt="Google logo">
                                Continue with Google
                            </button>
                        </div>

                        <div class="divider">
                            <span>or</span>
                        </div>

                        <c:if test="${not empty message}">
                            <div class="alert alert-danger p-2 text-center" id="error">${message}</div>
                        </c:if>

                        <form id="loginForm" action="loginProcess" method="POST">

                            <div class="mb-3">
                                <label for="input" class="form-label">Username or Email</label>
                                <input type="text" class="form-control" name="input" id="input" required>
                            </div>

                            <div class="mb-3">
                                <label for="password" class="form-label">Password</label>
                                <input type="password" class="form-control" name="password" id="password" required>
                            </div>
                            <div class="policyText">
                                <small class="text-muted d-block mb-2" style="margin-top: -10px;">This site is protected by reCAPTCHA and the Google <a href="#" class="highlight">Privacy Policy</a> and <a href="#" class="highlight">Terms of Service</a> apply.</small>
                            </div>
                            <div class="g-recaptcha-wrapper">
                                <div class="g-recaptcha" data-sitekey="6LdZuIkpAAAAAJkyWF_aBPQcctXb-PqjyNorBG28"></div>
                            </div>

                            <button class="btn-login-submit login" type="submit">Log In</button>

                            <div class="login-links">
                                <p>Create new account? <a href="http://localhost:8080/Project_SWP391_Group4/signup.jsp"> Join with us</a></p>
                                <p>Forgotten password? <a href="http://localhost:8080/Project_SWP391_Group4/forgot.jsp"> Reset Password</a></p>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </main>

        <footer>
            <div class="content-footer">
                <h3 id="highlight">Follow us on Instagram</h3>
                <p>@gio.vn & @fired.vn</p>
            </div>

            <div class="row" id="img-footer">
                <img class="col-md-2" src="https://theme.hstatic.net/1000296747/1000891809/14/gallery_item_1_img.jpg?v=55" alt="">
                <img class="col-md-2" src="https://theme.hstatic.net/1000296747/1000891809/14/gallery_item_2_img.jpg?v=55" alt="">
                <img class="col-md-2" src="https://theme.hstatic.net/1000296747/1000891809/14/gallery_item_3_img.jpg?v=55" alt="">
                <img class="col-md-2" src="https://theme.hstatic.net/1000296747/1000891809/14/gallery_item_4_img.jpg?v=55" alt="">
                <img class="col-md-2" src="https://theme.hstatic.net/1000296747/1000891809/14/gallery_item_5_img.jpg?v=55" alt="">
                <img class="col-md-2" src="https://theme.hstatic.net/1000296747/1000891809/14/gallery_item_6_img.jpg?v=55" alt="">
            </div>

            <div class="items-footer">
                <div class="row">
                    <div class="col-sm-3">
                        <h4 id="highlight">About GIO</h4>
                        <p>Vintage and basic wardrobe for boys and girls.Vintage and basic wardrobe for boys and girls.</p>
                        <img src="//theme.hstatic.net/1000296747/1000891809/14/footer_logobct_img.png?v=55" alt="..." class="bct">
                    </div>
                    <div class="col-sm-3">
                        <h4 id="highlight">Contact</h4>
                        <p><b>Address:</b> 100 Nguyen Van Cu, An Khanh Ward, Ninh Kieu District, City. Can Tho</p>
                        <p><b>Phone:</b> 0123.456.789 - 0999.999.999</p>
                        <p><b>Email:</b> info@gio.vn</p>
                    </div>
                    <div class="col-sm-3">
                        <h4 id="highlight">Customer support</h4>
                        <ul class="CS">
                            <li><a href="">Search</a></li>
                            <li><a href="">Introduce</a></li>
                        </ul>
                    </div>
                    <div class="col-sm-3">
                        <h4 id="highlight">Customer care</h4>
                        <div class="row phone">
                            <div class="col-sm-3"><i class="bi bi-telephone icon"></i></div>
                            <div class="col-9"> 
                                <h4 id="highlight">0123.456.789</h4>
                                <a href="">info@gio.vn</a>
                            </div>
                        </div>
                        <h5 id="highlight">Follow Us</h5>
                        <div class="contact-item">
                            <a href="" class="contact-link"><i class="bi bi-facebook contact-icon"></i></a>
                            <a href="" class="contact-link"><i class="bi bi-instagram contact-icon"></i></a>
                        </div>
                    </div>
                </div>
            </div>
        </footer>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <script src="/Project_SWP391_Group4/js/jquery-3.7.0.min.js"></script>
        <script src="/Project_SWP391_Group4/js/jquery.validate.min.js"></script>

        <script src="/Project_SWP391_Group4/js/login.js"></script> 
        <script src="/Project_SWP391_Group4/js/googleLogin.js"></script>   

        <script type="text/javascript">
      function toggleBox(id) {
          const el = document.getElementById(id);
          if (el) {
              el.style.display = (el.style.display === 'block') ? 'none' : 'block';
          }
      }
      function searchByName(name) {
          var search = name.value;
          $.ajax({
              url: "${pageContext.request.contextPath}/searchProductByAJAX",
              type: "get",
              data: {txt: search},
              success: function (data) {
                  var row = document.getElementById("search-ajax");
                  if (row)
                      row.innerHTML = data;
              },
              error: function (xhr) { }
          });
      }
        </script>
    </body>
</html>