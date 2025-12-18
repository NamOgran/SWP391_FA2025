<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- IMPORTS --%>
<%@page import="DAO.OrderDAO"%>
<%@page import="entity.Orders"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="entity.Customer"%>

<%-- 1. LOGIN CHECK --%>
<c:if test="${empty sessionScope.acc}">
    <c:redirect url="${pageContext.request.contextPath}/login.jsp"/>
</c:if>
<c:set var="acc" value="${sessionScope.acc}" />

<%
    // Sidebar data (kept here for backwards compat). Recommended: move to Servlet.
    if (session.getAttribute("acc") != null) {
        Customer currentAcc = (Customer) session.getAttribute("acc");
        OrderDAO orderDAO = new OrderDAO();
        List<Orders> listOrders = orderDAO.orderUser(currentAcc.getCustomer_id());
        if(listOrders == null) listOrders = new ArrayList<>();
        request.setAttribute("ordersUserList", listOrders);
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Feedbacks | GIO</title>

    <!-- Assets (kept consistent with profile.jsp) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-iYQeCzEYFbKjA/T2uDLTpkwGzCiq6soy8tYaI1GyVh/UjpbCx/TYkiZhlZB6+fzT" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href='https://fonts.googleapis.com/css?family=Quicksand:400,500,600,700&display=swap' rel='stylesheet'>
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

        .main-content-wrapper {
            max-width: 1140px;
            margin: 50px auto;
            padding: 0 15px;
        }

        /* Sidebar (copied styling for consistency) */
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
            justify-content: space-between;
        }

        .account-nav-link > div { display: flex; align-items: center; }
        .account-nav-link i { margin-right: 15px; width: 20px; text-align: center; font-size: 1.1rem; }

        .account-nav-link:hover { background-color: #fff8f3; color: var(--primary-color); padding-left: 30px; }
        .account-nav-link.active { background-color: #fff8f3; color: var(--primary-color); border-left-color: var(--primary-color); }

        .badge-sidebar { background-color: #dc3545; color: white; border-radius: 50%; padding: 2px 8px; font-size: 0.8rem; }

        /* Card & content styles (match profile) */
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

        .section-header h4 { font-weight: 700; color: var(--primary-color); margin: 0; }

        /* Feedback item */
        .feedback-item { background: #fff; border-radius: 10px; border: 1px solid #eee; padding: 20px; margin-bottom: 15px; transition: all 0.3s; }
        .feedback-item:hover { transform: translateY(-2px); box-shadow: 0 4px 10px rgba(0,0,0,0.05); }

        .product-thumb { width: 70px; height: 70px; object-fit: cover; border-radius: 8px; margin-right: 20px; border: 1px solid #eee; }

        .star-rating i { color: #ffc107; margin-right: 2px; }

        /* Responsive tweaks */
        @media (max-width: 767px) {
            .account-nav-card { position: static; top: auto; }
        }
    </style>
</head>

<body>
    <jsp:include page="header.jsp" />

    <main class="main-content-wrapper">

        <!-- Calculate active orders for badge (kept in JSP for now) -->
        <c:set var="totalActive" value="0" />
        <c:if test="${not empty requestScope.ordersUserList}">
            <c:forEach items="${requestScope.ordersUserList}" var="o">
                <c:if test="${o.status eq 'Pending' || o.status eq 'Delivering'}">
                    <c:set var="totalActive" value="${totalActive + 1}" />
                </c:if>
            </c:forEach>
        </c:if>

        <div class="row g-4">
            <!-- SIDEBAR -->
            <div class="col-lg-4 col-md-5">
                <div class="account-nav-card">
                    <div class="account-user-mini">
                        <div class="avatar-circle"><i class="fa-solid fa-user"></i></div>
                        <h5 class="mb-1 fw-bold text-white"><c:out value="${acc.username}"/></h5>
                        <small class="text-white-50">Member</small>
                    </div>

                    <ul class="account-nav">
                        <li>
                            <a href="${pageContext.request.contextPath}/profile" class="account-nav-link">
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
                                <c:if test="${totalActive > 0}"><span class="badge-sidebar">${totalActive}</span></c:if>
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/orderHistoryView" class="account-nav-link">
                                <div><i class="fa-solid fa-clock-rotate-left"></i> Order History</div>
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/my-feedback" class="account-nav-link active">
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

            <!-- CONTENT: FEEDBACK LIST -->
            <div class="col-lg-8 col-md-7">
                <div class="profile-card">
                    <div class="section-header">
                        <h4>My Reviews History</h4>
                    </div>

                    <div class="feedback-list">
                        <c:if test="${empty myFeedbacks}">
                            <div class="text-center py-5">
                                <i class="fa-regular fa-comment-dots fa-3x text-muted mb-3"></i>
                                <p class="text-muted">You haven't written any reviews yet.</p>
                                <a href="${pageContext.request.contextPath}/orderView" class="btn btn-outline-primary btn-sm" style="border-color: var(--primary-color); color: var(--primary-color);">Review purchased products</a>
                            </div>
                        </c:if>

                        <c:forEach items="${myFeedbacks}" var="fb">
                            <div class="feedback-item d-flex">
                                <img src="<c:out value='${fb.productImage}'/>" 
                                     onerror="this.src='https://placehold.co/70x70?text=No+Img'" 
                                     class="product-thumb" alt="Product">

                                <div class="flex-grow-1">
                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                        <h6 class="mb-0 fw-bold" style="color: #333;"><c:out value="${fb.productName}"/></h6>
                                        <small class="text-muted" style="font-size: 0.8rem;"><fmt:formatDate value="${fb.createdAt}" pattern="dd MMM yyyy HH:mm"/></small>
                                    </div>

                                    <div class="star-rating mb-2">
                                        <c:forEach begin="1" end="5" var="i">
                                            <c:choose>
                                                <c:when test="${i <= fb.ratePoint}">
                                                    <i class="fa-solid fa-star"></i>
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fa-regular fa-star"></i>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                    </div>

                                    <p class="mb-0 text-secondary" style="font-size: 0.95rem; line-height: 1.5;"><c:out value="${fb.content}"/></p>
                                </div>
                            </div>
                        </c:forEach>

                    </div>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="footer.jsp" />

    <!-- Optional scripts (kept consistent) -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
