/*
 * File: controller (java).txt
 * Nội dung: ToggleProductStatusServlet.java (ĐÃ CẬP NHẬT)
 */
package controller;

// NEW IMPORTS
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
// (Keep your existing imports)
import DAO.ProductDAO;
import entity.Product;
import entity.Staff;
// Import Staff
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
// Import HttpSession

@WebServlet(name = "ToggleProductStatusServlet", urlPatterns = {"/toggleProductStatus"})
public class ToggleProductStatusServlet extends HttpServlet {

    // NEW: Utility method to encode URL parameters
    private String encode(String value) {
        if (value == null) return "";
        try {
            return URLEncoder.encode(value, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            return value;
        }
    }

    // UPDATED doGet METHOD
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Staff s = (session != null) ? (Staff) session.getAttribute("staff") : null;
        if (s == null || !"admin".equalsIgnoreCase(s.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        
        int id = 0;
        try {
            id = Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            // === SỬA ĐỔI TẠI ĐÂY ===
            // Thêm "?tab=product"
            response.sendRedirect(request.getContextPath() + "/admin?tab=product&msg=invalid_id");
            return;
        }

        ProductDAO dao = new ProductDAO();
        Product p = dao.getProductById(id);
        if (p == null) {
            // === SỬA ĐỔI TẠI ĐÂY ===
            // Thêm "?tab=product"
            response.sendRedirect(request.getContextPath() + "/admin?tab=product&msg=not_found");
            return;
        }

        boolean newStatus = !p.isIs_active();
        boolean success = dao.toggleActiveStatus(id, newStatus);
        
        // --- UPDATED FOR STICKY STATE ---
        String page = request.getParameter("page");
        String sort = request.getParameter("sort");
        String search = request.getParameter("search");
        String category = request.getParameter("category");
        String status = request.getParameter("status");
        String msg = "toggle_failed";
        if (success) {
            msg = newStatus ? "activated" : "deactivated";
        }
        
        StringBuilder redirectUrl = new StringBuilder(request.getContextPath() + "/admin");
        
        // === SỬA ĐỔI TẠI ĐÂY ===
        // Thay "activeTab=product-manage" bằng "tab=product"
        redirectUrl.append("?tab=product&msg=").append(encode(msg));
        // === KẾT THÚC SỬA ĐỔI ===
        
        if (page != null && !page.isEmpty()) {
            redirectUrl.append("&page=").append(encode(page));
        }
        if (sort != null && !sort.isEmpty()) {
            redirectUrl.append("&sort=").append(encode(sort));
        }
        if (search != null && !search.isEmpty()) {
            redirectUrl.append("&search=").append(encode(search));
        }
        if (category != null && !category.isEmpty() && !category.equals("0")) {
            redirectUrl.append("&category=").append(encode(category));
        }
        if (status != null && !status.isEmpty() && !status.equals("all")) {
            redirectUrl.append("&status=").append(encode(status));
        }
        
        response.sendRedirect(redirectUrl.toString());
        // --- END OF UPDATE ---
    }
}