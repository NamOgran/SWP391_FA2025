<%-- 
    Document   : verify_register
    Created on : Dec 15, 2025, 3:28:48 PM
    Author     : Tran Quang Duyen
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verify Registration | GIO</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <style>
        body { font-family: 'Quicksand', sans-serif; background-color: #f8f9fa; height: 100vh; display: flex; align-items: center; justify-content: center; }
        .verify-container { background: white; padding: 40px; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); max-width: 500px; width: 100%; text-align: center; }
        .btn-primary-custom { background-color: #a0816c; border: none; color: white; padding: 12px; width: 100%; border-radius: 8px; font-weight: 600; margin-top: 20px; }
        .btn-primary-custom:hover { background-color: #8a6d5a; }
        .form-control { height: 50px; text-align: center; letter-spacing: 5px; font-size: 1.5rem; }
    </style>
</head>
<body>
    <div class="verify-container">
        <i class="bi bi-envelope-check" style="font-size: 3rem; color: #a0816c;"></i>
        <h3 class="mt-3">Verify Your Email</h3>
        <p class="text-muted">We have sent a 6-digit code to <strong>${sessionScope.tempCustomer.email}</strong></p>

        <c:if test="${not empty message}">
            <div class="alert alert-danger">${message}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login/verify-signup" method="POST">
            <div class="mb-3">
                <label class="form-label">Enter Verification Code</label>
                <input type="text" name="verifyCode" class="form-control" maxlength="6" required placeholder="XXXXXX">
            </div>
            <button type="submit" class="btn-primary-custom">VERIFY & CREATE ACCOUNT</button>
        </form>
        
        <div class="mt-3">
            <a href="${pageContext.request.contextPath}/signup.jsp" class="text-decoration-none text-muted">Back to Sign Up</a>
        </div>
    </div>
</body>
</html>