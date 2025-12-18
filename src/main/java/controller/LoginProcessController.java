/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.CustomerDAO;
import DAO.StaffDAO;
import entity.Customer;
import entity.Staff;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

@WebServlet(name = "LoginProcessController", urlPatterns = {"/loginProcess"})
public class LoginProcessController extends HttpServlet {

    // Khởi tạo cả 2 DAO
    CustomerDAO daoCustomer = new CustomerDAO();
    StaffDAO daoStaff = new StaffDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String input = request.getParameter("input");
        String password = request.getParameter("password");
        String hashedPassword = getMd5(password); // Mã hóa mật khẩu

        HttpSession session = request.getSession();

        // 1. ƯU TIÊN KIỂM TRA STAFF (Admin/Staff)
        // (Sử dụng logic từ StaffController của bạn)
        Staff staff = daoStaff.getStaffByEmailOrUsernameAndPassword(input, hashedPassword);

        if (staff != null) {
            session.setAttribute("staff", staff); // Đặt session "staff"

            if ("admin".equalsIgnoreCase(staff.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin?tab=dashboard");
            } else if ("staff".equalsIgnoreCase(staff.getRole())) {
                response.sendRedirect(request.getContextPath() + "/staff");
            } else {
                // Đề phòng trường hợp role không xác định
                request.setAttribute("message", "<div style='color:red'>Invalid staff role!</div>");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
            return; // Quan trọng: Dừng xử lý
        }

        // 2. NẾU KHÔNG PHẢI STAFF, KIỂM TRA CUSTOMER
        // (Sử dụng logic từ CustomerController của bạn)
        boolean isCustomer = daoCustomer.checkLogin(input, hashedPassword);

        if (isCustomer) {
            // === ĐĂNG NHẬP THÀNH CÔNG VỚI TƯ CÁCH CUSTOMER ===
            Customer customer = daoCustomer.getCustomerByEmailOrUsername(input);
            if (customer != null) {
                session.setAttribute("acc", customer); // Đặt session "acc"
                session.setAttribute("successMessage", "Login successful!");
                response.sendRedirect(request.getContextPath());
            } else {
                // Lỗi hiếm gặp: checkLogin() true nhưng không lấy được data
                request.setAttribute("message", "<div style='color:red'>Cannot load customer data!</div>");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
            return; // Quan trọng: Dừng xử lý
        }

        // 3. NẾU SAI CẢ HAI
        // === ĐĂNG NHẬP THẤT BẠI ===
        request.setAttribute("message", "<div style='color:red'>Wrong username or password!</div>");
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    // Copy hàm getMd5 từ Controller cũ của bạn
    public static String getMd5(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] messageDigest = md.digest(input.getBytes());
            BigInteger no = new BigInteger(1, messageDigest);
            String hashtext = no.toString(16);
            while (hashtext.length() < 32) {
                hashtext = "0" + hashtext;
            }
            return hashtext;
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Handles unified login for Staff and Customer";
    }
}
