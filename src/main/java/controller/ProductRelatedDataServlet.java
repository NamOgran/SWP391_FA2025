package controller;

import DAO.CartDAO;
import DAO.FeedbackDAO;
import DAO.ImportDetailDAO;
import DAO.OrderDAO;
import DAO.SizeDAO;
import com.google.gson.Gson;
import entity.Staff;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ProductRelatedDataServlet", urlPatterns = {"/admin/productRelatedData"})
public class ProductRelatedDataServlet extends HttpServlet {

    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Bảo mật: Chỉ admin mới được xem
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
            int productId = Integer.parseInt(request.getParameter("productId"));

            // Gọi tất cả các DAO
            SizeDAO sizeDAO = new SizeDAO();
            CartDAO cartDAO = new CartDAO();
            OrderDAO orderDAO = new OrderDAO();
            ImportDetailDAO importDetailDAO = new ImportDetailDAO();
            FeedbackDAO feedbackDAO = new FeedbackDAO();
            
            // Tạo một Map để chứa tất cả các danh sách
            Map<String, Object> relatedData = new HashMap<>();
            relatedData.put("sizes", sizeDAO.getSizesByProductId(productId));
            relatedData.put("carts", cartDAO.getCartItemsByProductId(productId));
            relatedData.put("orders", orderDAO.getOrderDetailsByProductId(productId));
            relatedData.put("imports", importDetailDAO.getImportDetailsByProductId(productId));
            relatedData.put("feedbacks", feedbackDAO.getFeedbackByProductId(productId));

            // Chuyển Map thành JSON và gửi về
            out.print(gson.toJson(relatedData));
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(gson.toJson("Invalid Product ID"));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson("Server Error: " + e.getMessage()));
        }
        out.flush();
    }
}