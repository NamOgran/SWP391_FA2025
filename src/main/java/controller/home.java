/*
 * File: controller/Home.java
 * Updated: Added logic for Product Reviews (Feedback)
 */
package controller;

import DAO.FeedBackDAO;
import DAO.ProductDAO;
import DAO.VoucherDAO;
import DAO.Size_detailDAO;
import entity.Feedback;
import entity.Product;
import entity.Voucher;
import entity.Size_detail;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import static url.ProductURL.URL_PRODUCT_DETAIL;
import static url.ProductURL.URL_PRODUCT_LIST;

@WebServlet(name = "productList", urlPatterns = {URL_PRODUCT_LIST, URL_PRODUCT_DETAIL})
public class Home extends HttpServlet {

    ProductDAO DAOproduct = new ProductDAO();
    VoucherDAO voucher = new VoucherDAO();
    Size_detailDAO sizeDAO = new Size_detailDAO();

    // Phương thức này dùng cho debug hoặc POST mặc định (giữ nguyên từ code cũ)
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet productList</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet productList at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String urlPath = request.getServletPath();
        
        // 1. Lấy danh sách khuyến mãi để tính giá giảm
        List<Voucher> voucherList = voucher.getAll();
        Map<Integer, Integer> voucherMap = new HashMap<>();
        for (Voucher p : voucherList) {
            voucherMap.put(p.getVoucherID(), p.getVoucherPercent());
        }
        
        switch (urlPath) {
            case URL_PRODUCT_DETAIL:
                int id = 0;
                try {
                    // Lấy ID sản phẩm từ URL
                    id = Integer.parseInt(request.getParameter("id"));
                } catch (NumberFormatException e) {
                    // Nếu ID lỗi, quay về trang chủ
                    response.sendRedirect("productList");
                    return;
                }
                
                // 2. Lấy thông tin sản phẩm
                Product p = DAOproduct.getProductById(id);
                
                // 3. Lấy danh sách Size_detail và số lượng tồn kho
                List<Size_detail> sizeList = sizeDAO.getSizesByProductId(id);
                
                // === [THÊM MỚI] 4. LẤY FEEDBACK VÀ TÍNH ĐIỂM ĐÁNH GIÁ ===
                FeedBackDAO feedbackDAO = new FeedBackDAO();
                // Hàm này cần được tạo trong FeedBackDAO (như hướng dẫn trước)
                List<Feedback> feedbackList = feedbackDAO.getFeedbacksByProductID(id);
                
                double averageRating = 0;
                int reviewCount = feedbackList.size();
                
                if (reviewCount > 0) {
                    int totalStars = 0;
                    for (Feedback fb : feedbackList) {
                        totalStars += fb.getRatePoint();
                    }
                    // Tính trung bình cộng (ép kiểu double để lấy số lẻ)
                    averageRating = (double) totalStars / reviewCount;
                }

                // 5. Đẩy dữ liệu sang JSP
                request.setAttribute("voucherMap", voucherMap);
                request.setAttribute("p", p);
                request.setAttribute("sizeList", sizeList);
                
                // Gửi dữ liệu Feedback
                request.setAttribute("feedbackList", feedbackList);
                request.setAttribute("averageRating", averageRating);
                request.setAttribute("reviewCount", reviewCount);
                
                request.getRequestDispatcher("productDetail.jsp").forward(request, response);
                break;
                
            case URL_PRODUCT_LIST:
                // Lấy 8 sản phẩm ngẫu nhiên cho trang chủ
                List<Product> productList = DAOproduct.get8RandomProduct();
                request.setAttribute("voucherMap", voucherMap);
                request.setAttribute("productList", productList);
                request.getRequestDispatcher("index.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Home Controller handling Product List and Detail with Feedback";
    }
}