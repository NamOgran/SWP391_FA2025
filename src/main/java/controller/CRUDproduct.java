package controller;

import DAO.ProductDAO;
import DAO.VoucherDAO;
import DAO.Size_detailDAO;
import entity.Product;
import entity.Staff;
import entity.Size_detail;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.text.NumberFormat;
import java.util.List;
import java.util.Locale;
import static url.ProductURL.*;

@WebServlet({UPDATE_JSP_PRODUCT, DELETE_PRODUCT, UPDATE_PRODUCT, ADD_PRODUCT, SEARCH_PRODUCT, SEARCH_PRODUCT_AJAX})
public class CRUDproduct extends HttpServlet {

    // --- HELPER METHODS ---
    private int parseIntSafe(String value, int defaultValue) {
        try {
            return (value == null || value.trim().isEmpty()) ? defaultValue : Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private String encode(String value) {
        if (value == null) return "";
        try {
            return URLEncoder.encode(value, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            return value;
        }
    }

    private String buildProductRedirectUrl(HttpServletRequest request, String msg) {
        String page = request.getParameter("current_page");
        String sort = request.getParameter("current_sort");
        String search = request.getParameter("current_search");
        String category = request.getParameter("current_category");
        String status = request.getParameter("current_status");
        
        StringBuilder url = new StringBuilder(request.getContextPath() + "/admin");
        url.append("?tab=product&msg=").append(encode(msg));
        
        if (page != null && !page.isEmpty()) url.append("&page=").append(encode(page));
        if (sort != null && !sort.isEmpty()) url.append("&sort=").append(encode(sort));
        if (search != null && !search.isEmpty()) url.append("&search=").append(encode(search));
        if (category != null && !category.isEmpty() && !category.equals("0")) url.append("&category=").append(encode(category));
        if (status != null && !status.isEmpty() && !status.equals("all")) url.append("&status=").append(encode(status));
        
        return url.toString();
    }

    // --- DO POST (ADD / UPDATE) ---
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. KIỂM TRA QUYỀN ADMIN
        HttpSession session = request.getSession(false);
        Staff s = (session != null) ? (Staff) session.getAttribute("staff") : null;
        if (s == null || !"admin".equalsIgnoreCase(s.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        
        request.setCharacterEncoding("UTF-8");
        String urlPath = request.getServletPath();
        
        ProductDAO daoProduct = new ProductDAO();
        Size_detailDAO daoSize_detail = new Size_detailDAO();
        VoucherDAO daoVoucher = new VoucherDAO();

        switch (urlPath) {
            case UPDATE_PRODUCT:
                int idInt = parseIntSafe(request.getParameter("id"), 0);
                String name = request.getParameter("name");
                int priceInt = parseIntSafe(request.getParameter("price"), 0);
                int categoryInt = parseIntSafe(request.getParameter("category"), 1);
                String pic = request.getParameter("pic");
                String des = request.getParameter("des");
                int voucherInt = parseIntSafe(request.getParameter("voucher"), 0);
                int voucherId = 0;

                if (voucherInt > 0) {
                    daoVoucher.addIfNotExist(voucherInt);
                    voucherId = daoVoucher.getIdVoucher(voucherInt);
                }

                if (idInt == 0) {
                    response.sendRedirect(buildProductRedirectUrl(request, "update_failed"));
                    return;
                }

                Product existing = daoProduct.getProductById(idInt);
                boolean isActive = (existing != null) ? existing.isIs_active() : true;
                
                // Constructor mới (không có quantity)
                Product p = new Product(idInt, priceInt, categoryInt, voucherId, name, des, pic, isActive);
                daoProduct.update(p);
                
                response.sendRedirect(buildProductRedirectUrl(request, "updated"));
                break;

            case ADD_PRODUCT:
                String nameAdd = request.getParameter("name");
                int priceAdd = parseIntSafe(request.getParameter("price"), 0);
                int catAdd = parseIntSafe(request.getParameter("category"), 1);
                String picAdd = request.getParameter("pic");
                String desAdd = request.getParameter("des");
                int voucherValAdd = parseIntSafe(request.getParameter("voucher"), 0);
                int voucherIdAdd = 0;

                if (voucherValAdd > 0) {
                    daoVoucher.addIfNotExist(voucherValAdd);
                    voucherIdAdd = daoVoucher.getIdVoucher(voucherValAdd);
                }

                Product pAdd = new Product(priceAdd, catAdd, voucherIdAdd, nameAdd, desAdd, picAdd);
                boolean isSuccess = daoProduct.insert(pAdd);

                if (isSuccess) {
                    // [QUAN TRỌNG] Tự động tạo size S, M, L trong bảng Size_detail cho sản phẩm mới
                    List<Product> newProducts = daoProduct.sortNew();
                    if (newProducts != null && !newProducts.isEmpty()) {
                        int newId = newProducts.get(0).getId();
                        daoSize_detail.insert(new Size_detail("S", newId, 0));
                        daoSize_detail.insert(new Size_detail("M", newId, 0));
                        daoSize_detail.insert(new Size_detail("L", newId, 0));
                    }
                }
                response.sendRedirect(buildProductRedirectUrl(request, "added"));
                break;
        }
    }

    // --- DO GET (SEARCH / DELETE / VIEW UPDATE) ---
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        String urlPath = request.getServletPath();
        ProductDAO dao = new ProductDAO();
        
        switch (urlPath) {
            case DELETE_PRODUCT:
                // Bảo mật: Chỉ Admin mới xóa được
                HttpSession session = request.getSession(false);
                Staff s = (session != null) ? (Staff) session.getAttribute("staff") : null;
                if (s == null || !"admin".equalsIgnoreCase(s.getRole())) {
                     response.sendRedirect(request.getContextPath() + "/login.jsp");
                     return;
                }

                int id = parseIntSafe(request.getParameter("id"), 0);
                String result = dao.deleteProductWithChecks(id); 
                response.sendRedirect(buildProductRedirectUrl(request, "success".equals(result) ? "deleted" : result));
                break;

            case SEARCH_PRODUCT:
                // Case này dùng cho trang productList.jsp (nếu có form submit search thông thường)
                String searchName = request.getParameter("search");
                List<Product> productList = dao.search("%" + searchName + "%");
                request.setAttribute("productList", productList);
                request.getRequestDispatcher("productList.jsp").forward(request, response);
                break;

            case SEARCH_PRODUCT_AJAX:
                String txt = request.getParameter("txt");
                List<Product> listAjax = dao.search("%" + txt + "%");
                VoucherDAO voucherDAO = new VoucherDAO();
                PrintWriter out = response.getWriter();
                NumberFormat numberFormat = NumberFormat.getNumberInstance(Locale.ENGLISH);

                if (listAjax.isEmpty()) {
                     out.println("<div class='no-products-found'>");
                     out.println("<i class='bi bi-box-seam no-products-icon'></i>");
                     out.println("Opps! There are no products that match your needs...");
                     out.println("</div>");
                } else {
                    for (Product o : listAjax) {
                        // Tính toán giá
                        double originalPrice = o.getPrice();
                        double salePrice = originalPrice;
                        int voucherPercent = 0;
                        
                        if(o.getVoucherID() > 0){
                            voucherPercent = voucherDAO.getPercentById(o.getVoucherID());
                            if(voucherPercent > 0){
                                salePrice = originalPrice * (1 - voucherPercent / 100.0);
                            }
                        }
                        
                        String formattedSalePrice = numberFormat.format((int)Math.ceil(salePrice));
                        String formattedOriginalPrice = numberFormat.format((int)originalPrice); 

                        // Sinh HTML
                        out.println("<div class=\"search-card\">");
                        out.println("   <a href=\"productDetail?id=" + o.getId() + "\" class=\"search-card-link\">");
                        
                        // Ảnh + Badge giảm giá
                        out.println("       <div class=\"search-card-image\">");
                        out.println("           <img src=\"" + o.getPicURL() + "\" alt=\"" + o.getName() + "\">");
                        if (voucherPercent > 0) {
                            out.println("       <span class=\"search-card-badge\">-" + voucherPercent + "%</span>");
                        }
                        out.println("       </div>");
                        
                        // Thông tin + Giá
                        out.println("       <div class=\"search-card-info\">");
                        out.println("           <div class=\"search-card-name\">" + o.getName() + "</div>");
                        out.println("           <div class=\"search-card-price\">");
                        
                        // Giá bán hiện tại (Màu đỏ)
                        out.println("               <span class=\"search-card-sale-price\">" + formattedSalePrice + " VND</span>");
                        
                        // Giá gốc gạch ngang (chỉ hiện nếu có giảm giá)
                        if (voucherPercent > 0) {
                            out.println("           <span class=\"search-card-original-price\">" + formattedOriginalPrice + " VND</span>");
                        }
                        
                        out.println("           </div>"); // end price
                        out.println("       </div>"); // end info
                        
                        out.println("   </a>");
                        out.println("</div>");
                    }
                }
                break;

            case UPDATE_JSP_PRODUCT:
                // Case này ít dùng nếu đã dùng Modal, nhưng giữ lại để tương thích
                int idUpdate = parseIntSafe(request.getParameter("id"), 0);
                Product p = dao.getProductById(idUpdate);
                request.setAttribute("product", p);
                request.getRequestDispatcher("updateProduct.jsp").forward(request, response);
                break;
        }
    }
    
    @Override
    public String getServletInfo() {
        return "CRUD Product Controller";
    }
}