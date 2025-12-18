package controller;

import DAO.CartDAO;
import DAO.FeedBackDAO;
import DAO.ImportDetailDAO;
import DAO.OrderDAO;
import DAO.ProductDAO;
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

    private int parseIntSafe(String value, int defaultValue) {
        try {
            return (value == null || value.trim().isEmpty()) ? defaultValue : Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private String encode(String value) {
        if (value == null) {
            return "";
        }
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

    // --- DO POST (ADD / UPDATE) ---
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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

        // [XÓA] VoucherDAO daoVoucher = new VoucherDAO(); // Không cần nữa
        switch (urlPath) {
            case UPDATE_PRODUCT:
                int idInt = parseIntSafe(request.getParameter("id"), 0);
                String name = request.getParameter("name");
                int priceInt = parseIntSafe(request.getParameter("price"), 0);
                int categoryInt = parseIntSafe(request.getParameter("category"), 1);
                String pic = request.getParameter("pic");
                String des = request.getParameter("des");

                // [CẬP NHẬT] Lấy trực tiếp discount từ input (tên input bên frontend vẫn là "voucher")
                int discount = parseIntSafe(request.getParameter("voucher"), 0);

                if (idInt == 0) {
                    response.sendRedirect(buildProductRedirectUrl(request, "update_failed"));
                    return;
                }
                Product existing = daoProduct.getProductById(idInt);
                boolean isActive = (existing != null) ? existing.isIs_active() : true;

                // [CẬP NHẬT] Constructor dùng int discount
                Product p = new Product(idInt, priceInt, categoryInt, discount, name, des, pic, isActive);
                daoProduct.update(p);
                response.sendRedirect(buildProductRedirectUrl(request, "updated"));
                break;

            case ADD_PRODUCT:
                String nameAdd = request.getParameter("name");
                int priceAdd = parseIntSafe(request.getParameter("price"), 0);
                int catAdd = parseIntSafe(request.getParameter("category"), 1);
                String picAdd = request.getParameter("pic");
                String desAdd = request.getParameter("des");

                // [CẬP NHẬT] Lấy trực tiếp discount
                int discountAdd = parseIntSafe(request.getParameter("voucher"), 0);

                // [CẬP NHẬT] Constructor dùng int discount
                Product pAdd = new Product(priceAdd, catAdd, discountAdd, nameAdd, desAdd, picAdd);
                boolean isSuccess = daoProduct.insert(pAdd);
                if (isSuccess) {
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
        Size_detailDAO size_detailDAO = new Size_detailDAO();

        switch (urlPath) {
            case DELETE_PRODUCT:
                // Bảo mật
                HttpSession session = request.getSession(false);
                Staff s = (session != null) ? (Staff) session.getAttribute("staff") : null;
                if (s == null || !"admin".equalsIgnoreCase(s.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/login.jsp");
                    return;
                }

                int id = parseIntSafe(request.getParameter("id"), 0);
                String result = "";

                OrderDAO orderDAO = new OrderDAO();
                CartDAO cartDAO = new CartDAO();
                ImportDetailDAO importDetailDAO = new ImportDetailDAO();
                FeedBackDAO feedBackDAO = new FeedBackDAO();

                boolean hasOrders = !orderDAO.getOrderDetailsByProductId(id).isEmpty();
                boolean hasCarts = !cartDAO.getCartItemsByProductId(id).isEmpty();
                boolean hasImports = !importDetailDAO.getImportDetailsByProductId(id).isEmpty();
                boolean hasFeedbacks = !feedBackDAO.getFeedbackByProductId(id).isEmpty();

                if (hasOrders || hasCarts || hasImports || hasFeedbacks) {
                    result = "Cannot delete: Related data exists.";
                } else {
                    List<Size_detail> sizes = size_detailDAO.getSizesByProductId(id);
                    int totalStock = 0;
                    for (Size_detail sd : sizes) {
                        totalStock += sd.getQuantity();
                    }

                    if (totalStock > 0) {
                        result = "Cannot delete: Product has stock.";
                    } else {
                        try {
                            size_detailDAO.deleteByProductId(id);
                        } catch (Exception e) {
                        }

                        // Delete product
                        result = dao.deleteProductWithChecks(id);
                    }
                }

                response.sendRedirect(buildProductRedirectUrl(request, "success".equals(result) ? "deleted" : result));
                break;

            case SEARCH_PRODUCT:
                String searchName = request.getParameter("search");
                List<Product> productList = dao.search("%" + searchName + "%");
                request.setAttribute("productList", productList);
                request.getRequestDispatcher("productList.jsp").forward(request, response);
                break;

            case SEARCH_PRODUCT_AJAX:
                String txt = request.getParameter("txt");
                List<Product> listAjax = dao.search("%" + txt + "%");
                // [XÓA] VoucherDAO voucherDAO = new VoucherDAO();
                PrintWriter out = response.getWriter();
                NumberFormat numberFormat = NumberFormat.getNumberInstance(Locale.ENGLISH);

                if (listAjax.isEmpty()) {
                    out.println("<div class='no-products-found'>");
                    out.println("<i class='bi bi-box-seam no-products-icon'></i>");
                    out.println("Opps! There are no products that match your needs...");
                    out.println("</div>");
                } else {
                    for (Product o : listAjax) {
                        double originalPrice = o.getPrice();
                        double salePrice = originalPrice;

                        // [CẬP NHẬT] Lấy discount trực tiếp từ Product
                        int discount = o.getDiscount();

                        if (discount > 0) {
                            salePrice = originalPrice * (1 - discount / 100.0);
                        }

                        String formattedSalePrice = numberFormat.format((int) Math.ceil(salePrice));
                        String formattedOriginalPrice = numberFormat.format((int) originalPrice);

                        out.println("<div class=\"search-card\">");
                        out.println("   <a href=\"productDetail?id=" + o.getId() + "\" class=\"search-card-link\">");
                        out.println("       <div class=\"search-card-image\">");
                        out.println("           <img src=\"" + o.getPicURL() + "\" alt=\"" + o.getName() + "\">");
                        if (discount > 0) {
                            out.println("       <span class=\"search-card-badge\">-" + discount + "%</span>");
                        }
                        out.println("       </div>");
                        out.println("       <div class=\"search-card-info\">");
                        out.println("           <div class=\"search-card-name\">" + o.getName() + "</div>");
                        out.println("           <div class=\"search-card-price\">");
                        out.println("               <span class=\"search-card-sale-price\">" + formattedSalePrice + " VND</span>");
                        if (discount > 0) {
                            out.println("           <span class=\"search-card-original-price\">" + formattedOriginalPrice + " VND</span>");
                        }
                        out.println("           </div>");
                        out.println("       </div>");
                        out.println("   </a>");
                        out.println("</div>");
                    }
                }
                break;

            case UPDATE_JSP_PRODUCT:
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
