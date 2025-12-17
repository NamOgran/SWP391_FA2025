package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.BufferedReader;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// Import đầy đủ các thư viện cần thiết
import DAO.FeedBackDAO;
import entity.Feedback;
import entity.Customer;
import org.json.JSONObject;

/**
 * Controller xử lý tất cả các tác vụ liên quan đến Feedback
 * - GET: Xem lịch sử đánh giá
 * - POST: Gửi đánh giá mới
 */
@WebServlet(name = "FeedBackController", urlPatterns = {"/feedback", "/my-feedback"})
public class FeedBackController extends HttpServlet {

    private FeedBackDAO feedbackDAO;

    @Override
    public void init() {
        feedbackDAO = new FeedBackDAO();
    }

    /**
     * Xử lý GET: Hiển thị trang lịch sử đánh giá (Logic từ MyFeedbackController cũ)
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Lấy thông tin session
        HttpSession session = request.getSession();
        Customer acc = (Customer) session.getAttribute("acc");

        // 2. Kiểm tra đăng nhập
        if (acc == null) {
            // Nếu chưa đăng nhập thì chuyển về trang login
            response.sendRedirect("login.jsp");
            return;
        }

        // 3. Lấy danh sách feedback của user (Logic hiển thị lịch sử)
        // Lưu ý: Đảm bảo DAO đã có hàm getFeedbackByCustomerId như chúng ta đã sửa ở bước trước
        List<Feedback> myFeedbacks = feedbackDAO.getFeedbackByCustomerId(acc.getCustomer_id());

        // 4. Đẩy dữ liệu ra view
        request.setAttribute("myFeedbacks", myFeedbacks);
        
        // 5. Forward sang trang JSP hiển thị danh sách
        request.getRequestDispatcher("my_feedback.jsp").forward(request, response);
    }

    /**
     * Xử lý POST: Nhận JSON để tạo đánh giá mới (Logic từ FeedBackController cũ)
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JSONObject jsonResponse = new JSONObject();

        // 1. Kiểm tra session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("acc") == null) {
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "You need to log in to leave a review.");
            out.print(jsonResponse.toString());
            out.flush();
            return;
        }
        
        int customerId;
        try {
            Customer loggedInCustomer = (Customer) session.getAttribute("acc");
            customerId = loggedInCustomer.getCustomer_id(); 
        } catch (Exception e) {
             e.printStackTrace();
             jsonResponse.put("status", "error");
            jsonResponse.put("message", "Session error (Cannot read Customer data).");
            out.print(jsonResponse.toString());
            out.flush();
            return;
        }

        // 2. Đọc dữ liệu JSON từ request body
        StringBuilder sb = new StringBuilder();
        String line;
        try (BufferedReader reader = request.getReader()) {
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        
        // 3. Xử lý logic nghiệp vụ
        try {
            JSONObject jsonRequest = new JSONObject(sb.toString());
            
            int productId = jsonRequest.getInt("productId");
            int orderId = jsonRequest.getInt("orderId");
            int rating = jsonRequest.getInt("rating");
            String comment = jsonRequest.getString("comment");

            // 4. Kiểm tra điều kiện (Business Logic)
            
            // 4.1. Đã mua hàng chưa?
            if (!feedbackDAO.hasPurchased(customerId, productId, orderId)) {
                jsonResponse.put("status", "error");
                jsonResponse.put("message", "You can only review products that have been purchased and delivered.");
                out.print(jsonResponse.toString());
                out.flush();
                return;
            }

            // 4.2. Đã đánh giá đơn này chưa?
            if (feedbackDAO.hasAlreadyReviewed(customerId, productId, orderId)) {
                jsonResponse.put("status", "error");
                jsonResponse.put("message", "You have already reviewed this product for this order.");
                out.print(jsonResponse.toString());
                out.flush();
                return;
            }

            // 5. Insert vào Database
            Feedback fb = new Feedback(); 
            fb.setCustomerId(customerId);
            fb.setProductId(productId);
            fb.setOrderId(orderId);
            fb.setRatePoint(rating);
            fb.setContent(comment);
            
            boolean insertSuccess = feedbackDAO.insertFeedback(fb);

            if (insertSuccess) {
                jsonResponse.put("status", "success");
            } else {
                jsonResponse.put("status", "error");
                jsonResponse.put("message", "Could not save feedback. Please try again.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "Server error while processing data: " + e.getMessage());
        }

        // 6. Trả về kết quả JSON
        out.print(jsonResponse.toString());
        out.flush();
    }

    @Override
    public String getServletInfo() {
        return "Feedback Controller handles both viewing history and submitting reviews";
    }
}