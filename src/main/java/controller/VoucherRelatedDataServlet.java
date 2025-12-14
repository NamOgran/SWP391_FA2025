package controller;

import DAO.ProductDAO;
import entity.Product;
import entity.Staff;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "VoucherRelatedDataServlet", urlPatterns = {"/admin/voucherRelatedData"})
public class VoucherRelatedDataServlet extends HttpServlet {
    
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Bảo mật
        HttpSession session = request.getSession(false);
        Staff s = (session != null) ? (Staff) session.getAttribute("staff") : null;
        if (s == null || !"admin".equalsIgnoreCase(s.getRole())) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write(gson.toJson("Access Denied"));
            return;
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            int voucherId = Integer.parseInt(request.getParameter("voucherId"));
            ProductDAO productDAO = new ProductDAO();
            
            // Lấy danh sách sản phẩm liên quan
            List<Product> products = productDAO.getProductsByVoucherId(voucherId); 
            
            // Trả về danh sách (ngay cả khi rỗng)
            out.print(gson.toJson(products));
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(gson.toJson("Invalid Voucher ID"));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson("Server Error: " + e.getMessage()));
        }
        out.flush();
    }
}