/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
// === TASK 3: THÊM IMPORT SESSION ===
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author thinh
 */
@WebServlet(name = "cookieHandle", urlPatterns = {"/cookieHandle"})
public class CookieHandle extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet cookieHandle</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet cookieHandle at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    private void deleteCookie(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Cookie[] cookies = request.getCookies();
        // === SỬA LỖI: Kiểm tra null an toàn ===
        if (cookies != null) {
            for (int i = 0; i < cookies.length; i++) {
                Cookie cookie = cookies[i];
                // Xóa các cookie cụ thể, không xóa JSESSIONID
                if (!cookie.getName().equalsIgnoreCase("JSESSIONID")) {
                    cookie.setMaxAge(0);
                    response.addCookie(cookie);
                }
            }
        }

        // === SỬA LỖI: Hủy session phía server ===
        HttpSession session = request.getSession(false); // Lấy session (không tạo mới)
        if (session != null) {
            session.invalidate(); // Hủy session
        }
    }

    // Trong CookieHandle.java
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Cookie[] cookies = request.getCookies();
        String input = "";
        if (cookies != null) {
            for (Cookie cooky : cookies) {
                if (cooky.getName().equals("input")) {
                    input = cooky.getValue();
                }
            }
        }

        deleteCookie(request, response);

        // ======================================================
        // === THAY ĐỔI LOGIC ĐĂNG XUẤT VÀ THÊM THÔNG BÁO ===
        // 1. Hủy phiên làm việc cũ (nếu có)
        HttpSession oldSession = request.getSession(false);
        if (oldSession != null) {
            oldSession.invalidate();
        }

        // 2. Tạo một phiên làm việc MỚI chỉ để chứa thông báo
        HttpSession newSession = request.getSession(true);
        newSession.setAttribute("successMessage", "Logout successful!");
        // ======================================================

        // (Logic chuyển hướng cũ của bạn)
        if (input.equals("admin")) { // Bạn có chắc đây là 'admin' không hay là 'staff'?
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        } else {
            // Chuyển hướng đến trang chủ (nơi sẽ hiển thị thông báo)
            response.sendRedirect(request.getContextPath() + "/");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
