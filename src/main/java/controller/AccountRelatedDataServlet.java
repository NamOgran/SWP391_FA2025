package controller;

import DAO.CartDAO;
import DAO.FeedBackDAO;
import DAO.ImportDAO;
import DAO.OrderDAO;
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

@WebServlet(name = "AccountRelatedDataServlet", urlPatterns = {"/admin/accountRelatedData"})
public class AccountRelatedDataServlet extends HttpServlet {

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
            String type = request.getParameter("type");
            int id = Integer.parseInt(request.getParameter("id"));
            
            Map<String, Object> relatedData = new HashMap<>();
            
            if ("customer".equals(type)) {
                CartDAO cartDAO = new CartDAO();
                FeedBackDAO feedbackDAO = new FeedBackDAO();
                OrderDAO orderDAO = new OrderDAO();
                
                relatedData.put("carts", cartDAO.getAll(id)); // Tái sử dụng
                relatedData.put("feedbacks", feedbackDAO.getFeedbackByCustomerId(id));
                relatedData.put("orders", orderDAO.orderUser(id)); // Tái sử dụng
                
            } else if ("staff".equals(type)) {
                OrderDAO orderDAO = new OrderDAO();
                ImportDAO importDAO = new ImportDAO();
                
                relatedData.put("orders", orderDAO.getOrdersByStaffId(id));
                relatedData.put("imports", importDAO.getImportsByStaffId(id));
            }

            out.print(gson.toJson(relatedData));
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(gson.toJson("Invalid Account ID"));
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson("Server Error: " + e.getMessage()));
        }
        out.flush();
    }
}