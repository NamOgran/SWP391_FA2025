package controller;

import DAO.CartDAO;
import DAO.ProductDAO;
import DAO.PromoDAO;
import DAO.SizeDAO;
import entity.Product;
import entity.Promo;
import entity.Size;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

import static url.CartURL.*;

/**
 * Controller xử lý tất cả thao tác liên quan đến giỏ hàng (Cart):
 * - Thêm sản phẩm
 * - Tăng / giảm số lượng
 * - Xóa sản phẩm
 * - Xem giỏ hàng
 * - Chuyển sang thanh toán
 * 
 * @author duyentq
 */
@WebServlet(name = "cart", urlPatterns = {
    URL_CART_INSERT, URL_CART_LIST, URL_CART_INCREASE,
    URL_CART_DECREASE, URL_CART_DELETE, URL_PAYMENT
})
public class Cart extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Đặt mã hóa UTF-8 cho request & response
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Kiểm tra session và người dùng đăng nhập
        HttpSession session = request.getSession(false);
        entity.Customer acc = (session != null) ? (entity.Customer) session.getAttribute("acc") : null;

        if (acc == null) {
            // Nếu chưa đăng nhập, quay lại trang login
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Lấy id khách hàng từ session
        final int customer_id = acc.getCustomer_id();
        // Xác định servlet path để switch-case đúng URL
        final String urlPath = request.getServletPath();

        // Khởi tạo DAO
        ProductDAO productDAO = new ProductDAO();
        CartDAO cartDAO = new CartDAO();
        PromoDAO promoDAO = new PromoDAO();
        SizeDAO sizeDAO = new SizeDAO();

        // Đọc tham số chung từ request
        String size = request.getParameter("size");
        int productId = parseIntSafe(request.getParameter("id"), 0);
        int quantity = parseIntSafe(request.getParameter("quantity"), 0);

        switch (urlPath) {

            /* ==========================
             *  CASE 1: THÊM SẢN PHẨM VÀO GIỎ
             * ========================== */
            case URL_CART_INSERT: {
                // Kiểm tra tham số đầu vào
                if (productId <= 0 || quantity <= 0 || size == null || size.isBlank()) {
                    response.sendRedirect(request.getContextPath() + "/error.jsp?message=Missing parameters for insert");
                    return;
                }

                // Kiểm tra tồn kho theo size
                List<Size> sizes = sizeDAO.getAll();
                Size matched = null;
                for (Size s : sizes) {
                    if (s.getProduct_id() == productId && size.equals(s.getSize_name())) {
                        matched = s;
                        break;
                    }
                }
                if (matched == null) {
                    response.sendRedirect(request.getContextPath() + "/error.jsp?message=Size not found for product");
                    return;
                }

                // Lấy đơn giá sau khi áp dụng khuyến mãi (nếu có)
                float unitPrice = calcUnitPriceWithPromo(productDAO, promoDAO, productId);

                // Kiểm tra xem item này đã có trong giỏ chưa (product + size)
                List<entity.Cart> current = cartDAO.getAll(customer_id);
                entity.Cart existed = null;
                for (entity.Cart c : current) {
                    if (c.getProductID() == productId && size.equals(c.getSize_name())) {
                        existed = c;
                        break;
                    }
                }

                // Nếu đã có -> cộng dồn số lượng
                if (existed != null) {
                    int newQty = existed.getQuantity() + quantity;
                    // Nếu vượt tồn kho thì báo lỗi
                    if (newQty > matched.getQuantity()) {
                        request.setAttribute("ms", "<script>alert('Sold out! Only " + matched.getQuantity() + " available.');</script>");
                        request.setAttribute("p", productDAO.getProductById(productId));
                        request.getRequestDispatcher("productDetail.jsp").forward(request, response);
                        return;
                    }
                    // Cập nhật số lượng mới, giữ nguyên đơn giá
                    cartDAO.updateCart(customer_id, productId, newQty, unitPrice, size);
                } else {
                    // Nếu sản phẩm chưa có trong giỏ
                    if (quantity > matched.getQuantity()) {
                        request.setAttribute("ms", "<script>alert('Sold out! Only " + matched.getQuantity() + " available.');</script>");
                        request.setAttribute("p", productDAO.getProductById(productId));
                        request.getRequestDispatcher("productDetail.jsp").forward(request, response);
                        return;
                    }
                    // Thêm mới vào giỏ hàng
                    cartDAO.insertCart(quantity, unitPrice, customer_id, productId, size);
                }

                // Load lại giỏ hàng
                response.sendRedirect("loadCart?size=" + size);
                break;
            }

            /* ==========================
             *  CASE 2: TĂNG SỐ LƯỢNG (AJAX)
             * ========================== */
            case URL_CART_INCREASE: {
                response.setContentType("text/plain; charset=UTF-8");

                // Kiểm tra input
                if (productId <= 0 || quantity <= 0 || size == null || size.isBlank()) {
                    response.getWriter().write("0,0,1"); // lỗi dữ liệu
                    return;
                }

                // Kiểm tra tồn kho
                int stock = 0;
                for (Size s : sizeDAO.getAll()) {
                    if (s.getProduct_id() == productId && size.equals(s.getSize_name())) {
                        stock = s.getQuantity();
                        break;
                    }
                }
                if (stock == 0 || quantity > stock) {
                    response.getWriter().write("0,0,1"); // temp=1 = hết hàng
                    return;
                }

                // Cập nhật số lượng mới trong giỏ
                cartDAO.updateQuantityOnly(customer_id, productId, size, quantity);

                // Tính lại lineTotal và sum tổng
                float unitPrice = calcUnitPriceWithPromo(productDAO, promoDAO, productId);
                int lineTotal = Math.round(unitPrice * quantity);
                int sum = cartDAO.getCartTotal(customer_id);

                // Gửi kết quả về client
                response.getWriter().write(lineTotal + "," + sum + ",0");
                break;
            }

            /* ==========================
             *  CASE 3: GIẢM SỐ LƯỢNG (AJAX)
             * ========================== */
            case URL_CART_DECREASE: {
                response.setContentType("text/plain; charset=UTF-8");

                if (productId <= 0 || quantity <= 0 || size == null || size.isBlank()) {
                    response.getWriter().write("0,0");
                    return;
                }

                // Cập nhật lại số lượng
                cartDAO.updateQuantityOnly(customer_id, productId, size, quantity);

                // Tính lineTotal và sum
                float unitPrice = calcUnitPriceWithPromo(productDAO, promoDAO, productId);
                int lineTotal = Math.round(unitPrice * quantity);
                int sum = cartDAO.getCartTotal(customer_id);

                response.getWriter().write(lineTotal + "," + sum);
                break;
            }

            /* ==========================
             *  CASE 4: XÓA 1 ITEM TRONG GIỎ
             * ========================== */
            case URL_CART_DELETE: {
                response.setContentType("text/plain; charset=UTF-8");

                if (productId <= 0 || size == null || size.isBlank()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("ERROR,0,0");
                    return;
                }

                // Xóa theo (product_id, size_name, customer_id)
                boolean ok = cartDAO.deleteCartBySize(productId, customer_id, size);
                int sum = cartDAO.getCartTotal(customer_id);
                int count = cartDAO.getCartCount(customer_id);

                // Trả kết quả cho AJAX
                response.getWriter().write((ok ? "OK" : "ERROR") + "," + sum + "," + count);
                break;
            }

            /* ==========================
             *  CASE 5: CHUYỂN ĐẾN THANH TOÁN
             * ========================== */
            case URL_PAYMENT: {
                response.sendRedirect("loadPayment?size=" + (size == null ? "" : size));
                break;
            }

            /* ==========================
             *  CASE 6: XEM GIỎ HÀNG
             * ========================== */
            case URL_CART_LIST: {
                response.sendRedirect("loadCart");
                break;
            }

            /* ==========================
             *  CASE MẶC ĐỊNH: URL KHÔNG HỢP LỆ
             * ========================== */
            default: {
                response.sendRedirect(request.getContextPath() + "/error.jsp?message=Unknown cart operation");
                break;
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // POST gọi lại GET (giữ logic thống nhất)
        doGet(req, resp);
    }

    /** 
     * Chuyển chuỗi thành int an toàn (tránh NumberFormatException)
     */
    private static int parseIntSafe(String s, int def) {
        try {
            return (s == null || s.isBlank()) ? def : Integer.parseInt(s);
        } catch (Exception e) {
            return def;
        }
    }

    /**
     * Tính đơn giá sau khi áp dụng khuyến mãi (nếu có)
     * Lấy promo_id từ Product, tra trong bảng promo để trừ phần trăm giảm giá
     */
    private static float calcUnitPriceWithPromo(ProductDAO productDAO, PromoDAO promoDAO, int productId) {
        Product p = productDAO.getProductById(productId);
        if (p == null) {
            return 0f;
        }

        int percent = 0;
        int promoId = p.getPromoID();
        if (promoId > 0) {
            List<Promo> promos = promoDAO.getAll();
            int idx = promoId - 1; // ⚠ Giả định promo_id bắt đầu từ 1, liên tục
            if (promos != null && idx >= 0 && idx < promos.size()) {
                percent = promos.get(idx).getPromoPercent();
            }
        }

        // Tính giá sau giảm
        return p.getPrice() - (p.getPrice() * percent / 100.0f);
    }
}
