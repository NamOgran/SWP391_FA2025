<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.text.DecimalFormat"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>  <!-- Thư viện JSTL định dạng số, tiền tệ -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  <!-- JSTL Core (forEach, if, set, v.v.) -->
<fmt:setLocale value="vi_VN"/> <!-- Thiết lập ngôn ngữ/định dạng số Việt Nam -->

<!DOCTYPE html>
<html lang="en">
  <head>
    <!-- ===================== HEADER / CSS / FONT ===================== -->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Bootstrap & icon -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <title>Orders</title>
    <link rel="stylesheet" href="./css/viewOrder.css"> <!-- CSS riêng -->
    <link href='https://fonts.googleapis.com/css?family=Quicksand' rel='stylesheet'> <!-- Font -->
    <link rel="icon" href="/Project_SWP391_Group4/images/LG1.png" type="image/x-icon">
    <script src="https://kit.fontawesome.com/1bd876819f.js" crossorigin="anonymous"></script>

    <!-- ===================== STYLE CỤC BỘ ===================== -->
    <style>
      /* Giữ nguyên toàn bộ style gốc header để đồng nhất giao diện */
      * {
        margin: 0; padding: 0; box-sizing: border-box;
        font-family: 'Quicksand', sans-serif;
        color: rgb(151, 143, 137);
      }
      html, body{ max-width:100%; overflow-x:hidden; }

      /* --- Cấu trúc header, nav, menu thả, searchbox, user info... --- */
      /* ... (phần CSS header giữ nguyên y như code gốc, không thay đổi) ... */

      /* ==== BỔ SUNG STYLE CHO PHẦN ORDER HISTORY ==== */
      .user-info{ border:1px solid #eee; border-radius:.5rem; padding:1rem; margin-bottom:1rem; background:#fff; }
      #header-order{ align-items:center; }
      .status-pill{
        display:inline-block; padding:.25rem .6rem; border-radius:999px;
        background:#f5f5f5; font-weight:600; font-size:.9rem;
      }
      .status-Delivered{ color:#0666cc; }
      .origin-price{ opacity:.6; text-decoration:line-through; }
      .saled-price{ font-weight:700; color:#d33; }
    </style>
  </head>

  <body>
    <!-- ===================== HEADER ===================== -->
    <header class="header">
      <div class="header_title">
        Free shipping with orders from <strong>200,000 VND</strong>
      </div>

      <!-- Thanh điều hướng chính -->
      <div class="headerContent">
        <div class="logo"><a href="/Project_SWP391_Group4/productList">GIO</a></div>

        <nav>
          <!-- Menu chính (Home, Men, Women, Info) -->
          <ul class="headerList">
            <li class="headerListItem"><a href="/Project_SWP391_Group4/productList">Home page</a></li>
            <!-- Menu con: Men's Fashion -->
            <li class="headerListItem">
              <a href="/Project_SWP391_Group4/productList/male">Men's Fashion
                <i class="bi bi-caret-down dropdown-icon"></i></a>
              <ul class="dropdownMenu">
                <li><a href="/Project_SWP391_Group4/productList/male/t_shirt">T-shirt</a></li>
                <li><a href="/Project_SWP391_Group4/productList/male/pant">Long pants</a></li>
                <li><a href="/Project_SWP391_Group4/productList/male/short">Shorts</a></li>
              </ul>
            </li>

            <!-- Menu con: Women's Fashion -->
            <li class="headerListItem">
              <a href="/Project_SWP391_Group4/productList/female">Women's Fashion
                <i class="bi bi-caret-down dropdown-icon"></i></a>
              <ul class="dropdownMenu">
                <li><a href="/Project_SWP391_Group4/productList/female/t_shirt">T-shirt</a></li>
                <li><a href="/Project_SWP391_Group4/productList/female/pant">Long pants</a></li>
                <li><a href="/Project_SWP391_Group4/productList/female/dress">Dress</a></li>
              </ul>
            </li>

            <!-- Menu con: Information -->
            <li class="headerListItem">
              <a href="/Project_SWP391_Group4/aboutUs.jsp">Information
                <i class="bi bi-caret-down dropdown-icon"></i></a>
              <ul class="dropdownMenu">
                <li><a href="/Project_SWP391_Group4/aboutUs.jsp">About Us</a></li>
                <li><a href="/Project_SWP391_Group4/contact.jsp">Contact</a></li>
                <li><a href="/Project_SWP391_Group4/orderView">View order</a></li>
                <li><a href="/Project_SWP391_Group4/policy.jsp">Exchange policy</a></li>
                <li><a href="/Project_SWP391_Group4/orderHistoryView">Order's history</a></li>
              </ul>
            </li>
          </ul>
        </nav>

        <!-- Biểu tượng công cụ: search, profile, cart -->
        <div class="headerTool">
          <!-- Search -->
          <div class="headerToolIcon">
            <i class="bi bi-search icon" onclick="toggleBox('box1')"></i>
            <div class="searchBox box" id="box1">
              <div class="searchBox-content">
                <h2>SEARCH</h2>
                <div class="search-input">
                  <input oninput="searchByName(this)" name="search" type="text" placeholder="Search for products...">
                  <button type="button"><i class="bi bi-search"></i></button>
                </div>
                <div class="search-list" id="search-ajax"></div>
              </div>
            </div>
          </div>

          <!-- Profile -->
          <div class="headerToolIcon">
            <a href="/Project_SWP391_Group4/profile"><i class="bi bi-person icon"></i></a>
          </div>

          <!-- Cart -->
          <div class="headerToolIcon">
            <a href="/Project_SWP391_Group4/loadCart"><i class="bi bi-cart2 icon"></i></a>
          </div>
        </div>
      </div>
      <hr />
    </header>

    <!-- ===================== MAIN CONTENT ===================== -->
    <div class="mid">
      <div class="row">
        <!-- ========== DANH SÁCH ĐƠN HÀNG ========== -->
        <div class="col-md-9 order-box-content">
          <div class="content">
            <h2 id="highlight"><b>List of order history</b></h2>
          </div>

          <!-- Lặp qua danh sách đơn hàng của user -->
          <c:forEach items="${requestScope.ordersUserList}" var="ordersUser">
            <!-- Hiển thị nếu đơn đã giao và không bị hủy -->
            <c:if test="${ordersUser.status eq 'Delivered' && ordersUser.status ne 'Cancelled'}">

              <div class="user-info">
                <!-- Phần tiêu đề đơn hàng -->
                <div id="header-order" class="row">
                  <div class="col-3"><p>ID: ${ordersUser.orderID}</p></div>
                  <div class="col-5"><p>Date: ${ordersUser.date}</p></div>
                  <div class="col-3" id="status">
                    <span class="status-pill status-${ordersUser.status}">
                      ${ordersUser.status}
                    </span>
                  </div>
                  <!-- Nút mở/đóng chi tiết -->
                  <div class="col-1">
                    <div class="dropdown">
                      <div class="edit-info-btn">
                        <button><i class="fa-regular fa-pen-to-square"></i></button>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- Danh sách sản phẩm trong đơn -->
                <div class="dropdown-container">
                  <c:forEach items="${requestScope.orderDetailList}" var="orderDetail">
                    <c:if test="${ordersUser.orderID eq orderDetail.orderID}">
                      <div id="mid-order" class="row">
                        <!-- Ảnh sản phẩm -->
                        <div id="product" class="col-2">
                          <img src="${picUrlMap[orderDetail.productID]}" alt="">
                        </div>

                        <!-- Tên, size, số lượng -->
                        <div class="col-6">
                          <h6 id="proName"><b>${nameProduct[orderDetail.productID]}</b></h6>
                          <p>Size: ${orderDetail.size_name}</p>
                          <p>Quantity: ${orderDetail.quantity}</p>
                        </div>

                        <!-- Giá -->
                        <div class="col-4">
                          <div id="price">
                            <div class="row">
                              <!-- Giá sau giảm -->
                              <c:set var="formattedPrice">
                                <fmt:formatNumber type="number"
                                  value="${(priceP[orderDetail.productID] - (priceP[orderDetail.productID] * promoMap[promoID[orderDetail.productID]])/100) * orderDetail.quantity}"
                                  pattern="###,###"/>
                              </c:set>
                              <!-- Giá gốc -->
                              <c:set var="formattedPrice2">
                                <fmt:formatNumber type="number"
                                  value="${priceP[orderDetail.productID] * orderDetail.quantity}"
                                  pattern="###,###"/>
                              </c:set>
                              <p class="col-md-6 origin-price">${formattedPrice2} VND</p>
                              <p class="col-md-6 saled-price">${formattedPrice} VND</p>
                            </div>
                          </div>

                          <!-- Nút phản hồi -->
                          <div class="feedback">
                            <button class="feedback-btn">Feedback</button>
                          </div>
                        </div>
                      </div>
                    </c:if>
                  </c:forEach>
                </div>

                <!-- Footer hiển thị tổng thông tin -->
                <div class="info">
                  <hr class="hr">
                  <div id="product-bottom" class="row">
                    <div class="col-3"><p>Quantity: ${totalQuantityMap[ordersUser.orderID]}</p></div>
                    <div class="col-5"><p>Address: ${ordersUser.address}</p></div>
                    <div class="col-4">
                      <p id="total">
                        Total:
                        <span>
                          <fmt:formatNumber value="${ordersUser.total}" type="number" maxFractionDigits="0"/> VND
                        </span>
                      </p>
                    </div>
                  </div>
                </div>
              </div>
            </c:if>
          </c:forEach>
        </div>

        <!-- ========== SIDEBAR (Page category) ========== -->
        <div class="col-md-3">
          <div class="page">
            <h5 id="highlight"><b>Page category</b></h5>
            <hr>
            <h6><a href="/Project_SWP391_Group4/contact.jsp">Contact</a></h6>
            <hr>
            <h6><a href="/Project_SWP391_Group4/policy.jsp">Exchange policy</a></h6>
            <hr>
            <h6><a href="/Project_SWP391_Group4/orderHistoryView">Order's history</a></h6>
          </div>
        </div>
      </div>
    </div>

    <!-- ===================== FOOTER ===================== -->
    <footer>
      <div class="content-footer">
        <h3 id="highlight">Follow us on Instagram</h3>
        <p>@GIO.vn & @fired.vn</p>
      </div>

      <!-- Bộ ảnh -->
      <div class="row" id="img-footer">
        <img class="col-md-2" src="https://theme.hstatic.net/...1_img.jpg?v=55" alt="">
        <img class="col-md-2" src="https://theme.hstatic.net/...2_img.jpg?v=55" alt="">
        <img class="col-md-2" src="https://theme.hstatic.net/...3_img.jpg?v=55" alt="">
        <img class="col-md-2" src="https://theme.hstatic.net/...4_img.jpg?v=55" alt="">
        <img class="col-md-2" src="https://theme.hstatic.net/...5_img.jpg?v=55" alt="">
        <img class="col-md-2" src="https://theme.hstatic.net/...6_img.jpg?v=55" alt="">
      </div>

      <!-- Thông tin cửa hàng -->
      <div class="items-footer">
        <div class="row">
          <!-- Giới thiệu -->
          <div class="col-sm-3">
            <h4 id="highlight">About GIO</h4>
            <p>Vintage and basic wardrobe for boys and girls.</p>
            <img src="//theme.hstatic.net/.../footer_logobct_img.png?v=55" alt="..." class="bct">
          </div>

          <!-- Liên hệ -->
          <div class="col-sm-3">
            <h4 id="highlight">Contact</h4>
            <p><b>Address:</b> 100 Nguyen Van Cu, Can Tho</p>
            <p><b>Phone:</b> 0123.456.789 - 0999.999.999</p>
            <p><b>Email:</b> info@GIO.vn</p>
          </div>

          <!-- Hỗ trợ khách hàng -->
          <div class="col-sm-3">
            <h4 id="highlight">Customer support</h4>
            <ul class="CS">
              <li><a href="">Search</a></li>
              <li><a href="">Introduce</a></li>
            </ul>
          </div>

          <!-- Chăm sóc khách hàng -->
          <div class="col-sm-3">
            <h4 id="highlight">Customer care</h4>
            <div class="row phone">
              <div class="col-sm-3"><i class="bi bi-telephone icon"></i></div>
              <div class="col-9">
                <h4 id="highlight">0123.456.789</h4>
                <a href="">info@GIO.vn</a>
              </div>
            </div>
            <h5 id="highlight">Follow Us</h5>
            <div class="contact-item">
              <a href=""><i class="bi bi-facebook contact-icon"></i></a>
              <a href=""><i class="bi bi-instagram contact-icon"></i></a>
            </div>
          </div>
        </div>
      </div>
    </footer>

    <!-- ===================== SCRIPT (ẩn/hiện chi tiết đơn) ===================== -->
    <script src="js/jquery-3.7.0.min.js"></script>
    <script src="js/jquery.validate.min.js"></script>
    <!--<script src="./js/viewOrder.js"></script>-->
    <script>
      // Bật/tắt chi tiết đơn hàng khi nhấn nút edit (bút)
      const editInfoBtn = document.querySelectorAll('.edit-info-btn');
      const dropdownContainer = document.querySelectorAll('.dropdown-container');

      editInfoBtn.forEach(function (edit, i) {
        edit.addEventListener('click', function () {
          if (dropdownContainer[i].style.display === "none" || dropdownContainer[i].style.display === "") {
            dropdownContainer[i].style.display = "block";
          } else {
            dropdownContainer[i].style.display = "none";
          }
        });
      });
    </script>
  </body>
</html>
