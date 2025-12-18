/*
 * File: controller/Home.java
 */
package controller;

import DAO.CategoryDAO; // [MỚI] Import DAO Category
import DAO.FeedBackDAO;
import DAO.ProductDAO;
import DAO.VoucherDAO;
import DAO.Size_detailDAO;
import entity.Category; // [MỚI] Import Entity Category
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
public class HomeController extends HttpServlet {

    ProductDAO DAOproduct = new ProductDAO();
    VoucherDAO voucher = new VoucherDAO();
    Size_detailDAO sizeDAO = new Size_detailDAO();
    CategoryDAO catDao = new CategoryDAO(); // [MỚI] Khởi tạo CategoryDAO

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

        // [FIX] Map key changed to String for VoucherID
        Map<String, Integer> voucherMap = new HashMap<>();
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

                // === [LOGIC MỚI: BREADCRUMBS] ===
                // Xác định pageContext dựa trên Category của sản phẩm
                if (p != null) {
                    Category cat = catDao.getCategoryById(p.getCategoryID());
                    String contextString = "";

                    if (cat != null) {
                        String gender = cat.getGender().trim().toLowerCase(); // "male" hoặc "female"
                        String type = cat.getType().trim().toLowerCase();     // "t-shirt", "dress", "pant", "short"

                        if (gender.equals("male")) {
                            if (type.contains("t-shirt")) {
                                contextString = "male_tshirt";
                            } else if (type.contains("pant")) {
                                contextString = "male_pant";
                            } else if (type.contains("short")) {
                                contextString = "male_short";
                            } else {
                                contextString = "all_male";
                            }
                        } else if (gender.equals("female")) {
                            if (type.contains("t-shirt")) {
                                contextString = "female_tshirt";
                            } else if (type.contains("pant")) {
                                contextString = "female_pant";
                            } else if (type.contains("dress")) {
                                contextString = "female_dress";
                            } else {
                                contextString = "all_female";
                            }
                        }
                    }
                    // Gửi biến này sang JSP để <c:choose> trong breadcrumb hoạt động
                    request.setAttribute("pageContext", contextString);
                }
                // ===================================

                // 3. Lấy danh sách Size_detail và số lượng tồn kho
                List<Size_detail> sizeList = sizeDAO.getSizesByProductId(id);

                // 4. Lấy Feedback và tính điểm đánh giá
                FeedBackDAO feedbackDAO = new FeedBackDAO();
                List<Feedback> feedbackList = feedbackDAO.getFeedbacksByProductID(id);
                double averageRating = 0;
                int reviewCount = feedbackList.size();

                if (reviewCount > 0) {
                    int totalStars = 0;
                    for (Feedback fb : feedbackList) {
                        totalStars += fb.getRatePoint();
                    }
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
        return "Home Controller handling Product List and Detail with Feedback and Breadcrumbs";
    }
}
