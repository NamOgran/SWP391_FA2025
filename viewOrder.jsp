<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>   <!-- JSTL format: formatNumber, date -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    <!-- JSTL core: forEach, if, choose, set -->

<!DOCTYPE html>
<html lang="en">
  <head>
    <!-- ========== META, CSS, LIBRARIES ========== -->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://fonts.googleapis.com/css?family=Quicksand" rel="stylesheet">

    <title>Orders</title>
    <!-- favicon -->
    <link rel="icon" href="${pageContext.request.contextPath}/images/LG1.png" type="image/x-icon">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/viewOrder.css">

    <!-- ========== STYLE NỘI TUYẾN: header + layout + responsive giống HistoryView ========== -->
    <style>
      /* Reset chung + tránh tràn ngang */
      * { box-sizing: border-box; font-family: 'Quicksand', sans-serif; color: rgb(151,143,137); }
      html, body { max-width: 100%; overflow-x: hidden; }
      img { max-width: 100%; height: auto; display: block; }

      :root {
        --logo-color: #a0816c;
        --text-color: #a0816c;
        --bg-color: #a0816c;
      }

      /* === HEADER === */
      .header_title {
        background: #f5f5f5;
        font-size: .8125rem;
        font-weight: 500;
        height: 30px;
        display: flex; justify-content: center; align-items: center;
      }
      .headerContent { max-width:1200px; margin:0 auto; padding:10px 0; display:flex; justify-content:space-between; align-items:center; }
      .logo a { text-decoration:none; color:var(--logo-color); font-size:1.5em; font-weight:bold; }

      /* Menu chính */
      .headerList { display:flex; gap:28px; list-style:none; margin:0; padding:0; }
      .headerListItem { position:relative; }
      .headerListItem>a { text-decoration:none; color:var(--text-color); padding:22px 0; display:inline-block; }

      /* Dropdown Menu */
      .dropdownMenu {
        position:absolute; top:100%; left:0;
        width:200px; background:#fff; border:1px solid #eee;
        border-radius:8px; list-style:none;
        box-shadow:0 8px 20px rgba(0,0,0,.12);
        display:none; margin-top:17px; z-index:1000;
      }
      .dropdownMenu li { border-bottom:1px solid rgb(235,202,178); }
      .dropdownMenu li:last-child{ border-bottom:0; }
      .dropdownMenu li a { display:block; padding:8px 14px; text-decoration:none; color:var(--text-color); font-size:.9em; }
      .dropdownMenu li:hover{ background:#f1f1f1; }
      .headerListItem:hover>.dropdownMenu{ display:block; }

      /* Icon Tool: Search, Profile, Cart */
      .headerTool { display:flex; align-items:center; gap:12px; }
      .icon { cursor:pointer; font-size:26px; }

      /* === SEARCH BOX === */
      .searchBox {
        width:min(420px,calc(100vw - 32px));
        position:absolute; top:100px; right:13%;
        background:#fff; box-shadow:0 10px 24px rgba(0,0,0,.15);
        display:none; z-index:990;
      }
      .search-input { position:relative; }
      .search-input input {
        width:100%; border:1px solid #e7e7e7; background:#f6f6f6;
        height:44px; padding:8px 50px 8px 20px; font-size:1em;
      }

      /* === SIDEBAR (Page category) === */
      .cat-card { border:1px solid #eee; border-radius:.5rem; padding:1rem; background:#fff; position:sticky; top:96px; }
      .cat-link { display:block; padding:.55rem 0; border-top:1px solid #eee; text-decoration:none; color:#3a3a3a; }

      /* === ORDER CARD === */
      .user-info { border:1px solid #eee; border-radius:.5rem; padding:1rem; background:#fff; margin-bottom:1rem; }
      #header-order { align-items:center; }
      .status-pill {
        display:inline-block; padding:.25rem .6rem; border-radius:999px;
        background:#f5f5f5; font-weight:600; font-size:.9rem;
      }
      .status-Pending { color:#b57600; }
      .status-Delivering { color:#0aa77a; }
      .status-Delivered { color:#0666cc; }

      .origin-price { opacity:.6; text-decoration:line-through; }
      .saled-price { font-weight:700; color:#d33; }

      /* Nút xem chi tiết & xác nhận */
      .detail-btn, .feedback-btn {
        border:1px solid #a0816c; border-radius:.4rem;
        padding:.35rem .7rem; background:#fff; font-size:.9em;
      }
      .detail-btn:hover, .feedback-btn:hover { background:#a0816c; color:#fff; }

      .dropdown-container { display:none; }

      /* FOOTER */
      footer { background:#f5f5f5; }
      .content-footer { text-align:center; padding:30px; }
    </style>
  </head>

  <body>
    <!-- ========== HEADER ========== -->
    <header class="header">
      <div class="header_title">Free shipping with orders from <strong>200,000 VND</strong></div>

      <div class="headerContent">
        <!-- Logo -->
        <div class="logo"><a href="${pageContext.request.contextPath}/productList">GIO</a></div>

        <!-- Menu -->
        <nav>
          <ul class="headerList">
            <!-- Trang chủ -->
            <li class="headerListItem"><a href="${pageContext.request.contextPath}/productList">Home page</a></li>

            <!-- Men -->
            <li class="headerListItem">
              <a href="${pageContext.request.contextPath}/productList/male">Men's Fashion <i class="bi bi-caret-down"></i></a>
              <ul class="dropdownMenu">
                <li><a href="${pageContext.request.contextPath}/productList/male/t_shirt">T-shirt</a></li>
                <li><a href="${pageContext.request.contextPath}/productList/male/pant">Long pants</a></li>
                <li><a href="${pageContext.request.contextPath}/productList/male/short">Shorts</a></li>
              </ul>
            </li>

            <!-- Women -->
            <li class="headerListItem">
              <a href="${pageContext.request.contextPath}/productList/female">Women's Fashion <i class="bi bi-caret-down"></i></a>
              <ul class="dropdownMenu">
                <li><a href="${pageContext.request.contextPath}/productList/female/t_shirt">T-shirt</a></li>
                <li><a href="${pageContext.request.contextPath}/productList/female/pant">Long pants</a></li>
                <li><a href="${pageContext.request.contextPath}/productList/female/dress">Dress</a></li>
              </ul>
            </li>

            <!-- Info -->
            <li class="headerListItem">
              <a href="${pageContext.request.contextPath}/aboutUs.jsp">Information <i class="bi bi-caret-down"></i></a>
              <ul class="dropdownMenu">
                <li><a href="${pageContext.request.contextPath}/contact.jsp">Contact</a></li>
                <li><a href="${pageContext.request.contextPath}/orderView">View order</a></li>
                <li><a href="${pageContext.request.contextPath}/policy.jsp">Exchange policy</a></li>
                <li><a href="${pageContext.request.contextPath}/orderHistoryView">Order's history</a></li>
              </ul>
            </li>
          </ul>
        </nav>

        <!-- Icon Tool -->
        <div class="headerTool">
          <a href="${pageContext.request.contextPath}/profile"><i class="bi bi-person icon"></i></a>
          <a href="${pageContext.request.contextPath}/loadCart"><i class="bi bi-cart2 icon"></i></a>
        </div>
      </div>
      <hr/>
    </header>

    <!-- ========== NỘI DUNG CHÍNH: Danh sách đơn hàng đang giao ========== -->
    <div class="container py-4" id="page-wrap">
      <div class="row g-3">
        <!-- Bên trái: danh sách đơn hàng -->
        <div class="col-lg-9 order-box-content">
          <h2 id="highlight"><b>List of orders</b></h2>

          <c:choose>
            <!-- Nếu chưa có đơn -->
            <c:when test="${empty ordersUserList}">
              <div class="alert alert-info">You have no orders yet.</div>
            </c:when>

            <!-- Có đơn -->
            <c:otherwise>
              <c:forEach items="${ordersUserList}" var="o">
                <!-- Chỉ hiển thị đơn chưa giao hoặc đang giao -->
                <c:if test="${o.status ne 'Delivered' && o.status ne 'Cancelled'}">
                  <div class="user-info" id="user${o.orderID}">
                    <!-- Header đơn -->
                    <div id="header-order" class="row">
                      <div class="col-md-3"><p>ID: <b>${o.orderID}</b></p></div>
                      <div class="col-md-5"><p>Date: <b>${o.date}</b></p></div>
                      <div class="col-md-2"><span class="status-pill status-${o.status}">${o.status}</span></div>
                      <div class="col-md-2 text-end">
                        <button class="detail-btn" type="button" id="btn-${o.orderID}" onclick="toggleDetails(${o.orderID})">
                          Detail <i class="bi bi-chevron-down"></i>
                        </button>
                      </div>
                    </div>

                    <!-- Chi tiết sản phẩm -->
                    <div class="dropdown-container mt-2" id="dd-${o.orderID}">
                      <c:set var="hasItem" value="false"/>
                      <c:forEach items="${orderDetailList}" var="d">
                        <c:if test="${d.orderID eq o.orderID}">
                          <c:set var="hasItem" value="true"/>
                          <div id="mid-order" class="row">
                            <!-- Ảnh -->
                            <div class="col-md-2"><img src="${picUrlMap[d.productID]}" alt=""></div>
                            <!-- Tên + size -->
                            <div class="col-md-6">
                              <h6><b>${nameProduct[d.productID]}</b></h6>
                              <p>Size: ${d.size_name}</p>
                              <p>Quantity: ${d.quantity}</p>
                            </div>
                            <!-- Giá -->
                            <div class="col-md-4">
                              <c:set var="unitDisc" value="${priceP[d.productID] - (priceP[d.productID] * promoMap[promoID[d.productID]])/100}"/>
                              <c:set var="lineDisc" value="${unitDisc * d.quantity}"/>
                              <c:set var="lineOrig" value="${priceP[d.productID] * d.quantity}"/>
                              <p class="origin-price"><fmt:formatNumber value="${lineOrig}" pattern="###,###"/> VND</p>
                              <p class="saled-price"><fmt:formatNumber value="${lineDisc}" pattern="###,###"/> VND</p>
                            </div>
                          </div>
                          <hr class="hr">
                        </c:if>
                      </c:forEach>
                      <!-- Nếu đơn không có item -->
                      <c:if test="${hasItem eq false}">
                        <div class="text-muted py-2">No order items found.</div>
                      </c:if>
                    </div>

                    <!-- Footer đơn -->
                    <div class="info">
                      <div id="product-bottom" class="row align-items-center">
                        <div class="col-md-3"><p>Items: <b>${totalQuantityMap[o.orderID]}</b></p></div>
                        <div class="col-md-5"><p>Ship to: <b>${o.address}</b></p></div>
                        <div class="col-md-2"><p>Total: <b><fmt:formatNumber value="${o.total}" pattern="###,###"/> VND</b></p></div>
                        <div class="col-md-2 text-end">
                          <!-- Nếu đơn đang giao thì cho nút "Order Received" -->
                          <c:if test="${o.status eq 'Delivering'}">
                            <button class="feedback-btn" onclick="markDelivered(${o.orderID})">Order Received</button>
                          </c:if>
                        </div>
                      </div>
                    </div>
                  </div>
                </c:if>
              </c:forEach>
            </c:otherwise>
          </c:choose>
        </div>

        <!-- Bên phải: Page Category -->
        <div class="col-lg-3">
          <aside class="cat-card">
            <h5><b>Page category</b></h5>
            <a class="cat-link" href="${pageContext.request.contextPath}/contact.jsp">Contact</a>
            <a class="cat-link" href="${pageContext.request.contextPath}/policy.jsp">Exchange policy</a>
            <a class="cat-link" href="${pageContext.request.contextPath}/orderHistoryView">Order's history</a>
          </aside>
        </div>
      </div>
    </div>

    <!-- ========== FOOTER ========== -->
    <footer class="mt-4">
      <div class="content-footer">
        <h3 id="highlight">Follow us on Instagram</h3>
        <p>@GIO.vn & @fired.vn</p>
      </div>
    </footer>

    <!-- ========== SCRIPT ========== -->
    <script src="${pageContext.request.contextPath}/js/jquery-3.7.0.min.js"></script>
    <script>
      const BASE = '${pageContext.request.contextPath}';
      // Toggle hiển thị chi tiết từng đơn
      function toggleDetails(orderId){
        const box = document.getElementById('dd-' + orderId);
        const btn = document.getElementById('btn-' + orderId);
        if(!box || !btn) return;
        const show = (box.style.display !== 'block');
        box.style.display = show ? 'block' : 'none';
        btn.innerHTML = show ? 'Shorten <i class="bi bi-chevron-up"></i>' : 'Detail <i class="bi bi-chevron-down"></i>';
      }

      // Đánh dấu đơn "Delivered" (cập nhật trạng thái)
      function markDelivered(orderId){
        $.ajax({
          url: BASE + '/orderHistoryView',
          method: 'GET',
          data: { orderId: orderId, status: 'Delivered' },
          success: function(){
            window.location.href = BASE + '/orderHistoryView';
          },
          error: function(xhr){
            alert('Update failed: ' + (xhr.status || '') + ' ' + (xhr.statusText || ''));
          }
        });
      }
    </script>
  </body>
</html>
