/*
 * File: controller (java).txt
 * Nội dung: CRUDproduct.java (ĐÃ CẬP NHẬT)
 */
package controller;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import DAO.ProductDAO;
import entity.Product;
import entity.Staff; // Thêm import này để kiểm tra session
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; // Thêm import này để kiểm tra session
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.NumberFormat;
import java.util.List;
import java.util.Locale;
import java.util.Random;
import static url.ProductURL.DELETE_PRODUCT;
import static url.ProductURL.UPDATE_JSP_PRODUCT;
import static url.ProductURL.ADD_PRODUCT;
import static url.ProductURL.UPDATE_PRODUCT;
import static url.ProductURL.SEARCH_PRODUCT;
import static url.ProductURL.SEARCH_PRODUCT_AJAX;

/**
 *
 * @author LENOVO
 */
@WebServlet({UPDATE_JSP_PRODUCT, DELETE_PRODUCT, UPDATE_PRODUCT, ADD_PRODUCT, SEARCH_PRODUCT, SEARCH_PRODUCT_AJAX})
public class CRUDproduct extends HttpServlet {

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
            /* TODO output your page here.
             You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CRUDproduct</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CRUDproduct at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }
    
    /**
     * Chuyển đổi một chuỗi thành số nguyên một cách an toàn.
     * Nếu chuỗi rỗng hoặc không hợp lệ, trả về một giá trị mặc định.
     */
    private int parseIntSafe(String value, int defaultValue) {
        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            // Log lỗi nếu cần
            System.err.println("NumberFormatException: " + e.getMessage());
            return defaultValue; 
        }
    }

    // Utility method to encode URL parameters
    private String encode(String value) {
        if (value == null) return "";
        try {
            return URLEncoder.encode(value, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            return value;
        }
    }
    
    // === START: UPDATED buildProductRedirectUrl METHOD ===
    private String buildProductRedirectUrl(HttpServletRequest request, String msg) {
        // Read page/filter parameters from the form (must be sent as hidden inputs)
        String page = request.getParameter("current_page");
        String sort = request.getParameter("current_sort");
        String search = request.getParameter("current_search");
        String category = request.getParameter("current_category");
        String status = request.getParameter("current_status");
        
        StringBuilder url = new StringBuilder(request.getContextPath() + "/admin");
        
        // Thay "activeTab=product-manage" bằng "tab=product"
        url.append("?tab=product&msg=").append(encode(msg));

        if (page != null && !page.isEmpty()) {
            url.append("&page=").append(encode(page));
        }
        if (sort != null && !sort.isEmpty()) {
            url.append("&sort=").append(encode(sort));
        }
        if (search != null && !search.isEmpty()) {
            url.append("&search=").append(encode(search));
        }
        if (category != null && !category.isEmpty() && !category.equals("0")) {
            url.append("&category=").append(encode(category));
        }
        if (status != null && !status.isEmpty() && !status.equals("all")) {
            url.append("&status=").append(encode(status));
        }
        
        return url.toString();
    }
    // === END: UPDATED buildProductRedirectUrl METHOD ===


    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String urlPath = request.getServletPath();
        String msg = ""; // Biến msg gốc, được khai báo MỘT LẦN
        
        // Khai báo các biến DAO và ID ở đây để dùng chung
        ProductDAO dao = new ProductDAO();
        int id;
        List<Product> productList;
        String name;
        
        switch (urlPath) {
            case UPDATE_JSP_PRODUCT:
                // (No changes needed)
                id = Integer.parseInt(request.getParameter("id"));
                Product c = dao.getProductById(id);
                request.setAttribute("product", c);
                request.getRequestDispatcher("updateProduct.jsp").forward(request, response);
                break;
                
            case DELETE_PRODUCT:
                id = Integer.parseInt(request.getParameter("id"));
                
                // Logic xóa an toàn từ yêu cầu trước
                // (Giả sử bạn đã thêm ProductDAO.deleteProductWithChecks)
                String deleteResult = dao.deleteProductWithChecks(id);
                
                if ("success".equals(deleteResult)) {
                    msg = "deleted"; // Thông báo thành công
                } else {
                    msg = encode(deleteResult); // Mã hóa thông báo lỗi để truyền qua URL
                }
                
                // --- UPDATED FOR STICKY STATE ---
                // Read filter/page parameters from the URL
                String page = request.getParameter("page");
                String sort = request.getParameter("sort");
                String search = request.getParameter("search");
                String category = request.getParameter("category");
                String status = request.getParameter("status");
                
                // Build the redirect URL
                StringBuilder redirectUrl = new StringBuilder(request.getContextPath() + "/admin");
                
                // Thay "activeTab=product-manage" bằng "tab=product"
                redirectUrl.append("?tab=product&msg=").append(msg); // Dùng biến msg đã gán
                
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
                break;
                
            case SEARCH_PRODUCT:
                // (No changes needed, this logic seems unused by admin.jsp)
                name = request.getParameter("search");
                productList = dao.search("%" + name + "%");

                request.setAttribute("productList", productList);
                request.getRequestDispatcher("productList.jsp").forward(request, response);
                break;
                
            case SEARCH_PRODUCT_AJAX:
                // (No changes needed)
                dao = new ProductDAO();
                name = request.getParameter("txt");
                productList = dao.search("%" + name + "%");
                PrintWriter out = response.getWriter();
                for (Product o : productList) {
                    NumberFormat numberFormat = NumberFormat.getNumberInstance(Locale.ENGLISH);
                    String formattedNumber = numberFormat.format(o.getPrice());
                    out.println(" <div class=\"search-product\">\n"
                            + "                                            <div class=\"search-info\">\n"
                            + "                                                <div class=\"title\">\n"
                            + "                                                    <a href=\"/Project_SWP_Group2/productDetail?id=" + o.getId() + "\">" + o.getName() + "</a>\n"
                            + "                                                    <p>" + formattedNumber + " VND</p>\n"
                            + "                                                </div>\n"
                            + "                                                <div class=\"search-img\">\n"
                            + "                                                    <a href=\"\">\n"
                            + "                                                        <img src=\"" + o.getPicURL() + "\" alt=\"img\">\n"
                            + "                                                    </a>\n"
                            + "                                                </div>\n"
                            + "                                            </div>\n"
                            + "                                            <hr>");
                }
                break;
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     * (Used for Add and Update from Modal)
     */
    // UPDATED doPost METHOD
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // <<< QUAN TRỌNG: THÊM KIỂM TRA BẢO MẬT >>>
        // Bạn PHẢI thêm logic kiểm tra session và vai trò admin ở đây
         HttpSession session = request.getSession(false);
         Staff s = (session != null) ? (Staff) session.getAttribute("staff") : null;
         if (s == null || !"admin".equalsIgnoreCase(s.getRole())) {
             response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
             return;
         }
        // <<< KẾT THÚC KIỂM TRA BẢO MẬT >>>
        
        request.setCharacterEncoding("UTF-8");
        String urlPath = request.getServletPath();
        
        switch (urlPath) {
            case UPDATE_PRODUCT:
                String quantity = request.getParameter("quantity");
                String productId = request.getParameter("id");
                String categoryId = request.getParameter("category");
                String promoId = request.getParameter("promo");
                String name = request.getParameter("name");
                String price = request.getParameter("price");
                String pic = request.getParameter("pic");
                String des = request.getParameter("des");

                ProductDAO DAOproduct = new ProductDAO();

                // === SỬA ĐỔI TẠI ĐÂY ===
                // Sử dụng hàm an toàn với giá trị mặc định hợp lý
                int quanInt = parseIntSafe(quantity, 0);  // Mặc định là 0
                int priceInt = parseIntSafe(price, 0); // Mặc định là 0
                int idInt = parseIntSafe(productId, 0);  // Mặc định là 0 (quan trọng)
                int categoryInt = parseIntSafe(categoryId, 1); // Giả sử 1 là ID hợp lệ (hoặc 0 nếu DB cho phép)
                int promoInt = parseIntSafe(promoId, 0);      // 0 thường là "None"
                // === KẾT THÚC SỬA ĐỔI ===
                
                // THÊM KIỂM TRA QUAN TRỌNG:
                // Nếu ID bằng 0, nghĩa là trường ẩn 'id' không được gửi,
                // chúng ta không thể thực hiện cập nhật.
                if (idInt == 0) {
                    // Chuyển hướng với thông báo lỗi
                    response.sendRedirect(buildProductRedirectUrl(request, "update_failed_missing_id"));
                    return;
                }

                Product existingProduct = DAOproduct.getProductById(idInt);
                boolean currentStatus = (existingProduct != null) ? existingProduct.isIs_active() : true;
                Product product = new Product(idInt, quanInt, priceInt, categoryInt, promoInt, name, des, pic, currentStatus);
                
                DAOproduct.update(product);
                response.sendRedirect(buildProductRedirectUrl(request, "updated"));
                break;
                
            case ADD_PRODUCT:
                quantity = request.getParameter("quantity");
                categoryId = request.getParameter("category");
                promoId = request.getParameter("promo");
                name = request.getParameter("name");
                price = request.getParameter("price");
                pic = request.getParameter("pic");
                des = request.getParameter("des");
                
                DAOproduct = new ProductDAO();

                // ÁP DỤNG HÀM AN TOÀN Ở ĐÂY
                quanInt = parseIntSafe(quantity, 0);
                priceInt = parseIntSafe(price, 0);
                categoryInt = parseIntSafe(categoryId, 1); // Giả sử 1 là ID hợp lệ
                promoInt = parseIntSafe(promoId, 0);
                
                product = new Product(quanInt, priceInt, categoryInt, promoInt, name, des, pic);
                DAOproduct.insert(product);
                response.sendRedirect(buildProductRedirectUrl(request, "added"));
                break;
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}