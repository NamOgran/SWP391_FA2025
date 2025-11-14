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

import static url.CartURL.URL_CART_DECREASE;
import static url.CartURL.URL_CART_DELETE;
import static url.CartURL.URL_CART_INCREASE;
import static url.CartURL.URL_CART_INSERT;
import static url.CartURL.URL_CART_LIST;
import static url.CartURL.URL_PAYMENT;

@WebServlet(name = "cart", urlPatterns = {
    URL_CART_INSERT, URL_CART_LIST, URL_CART_INCREASE, URL_CART_DECREASE, URL_CART_DELETE, URL_PAYMENT
})
public class Cart extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        entity.Customer acc = (session != null) ? (entity.Customer) session.getAttribute("acc") : null;

        if (acc == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        final int customer_id = acc.getCustomer_id();
        final String urlPath = request.getServletPath();

        ProductDAO productDAO = new ProductDAO();
        CartDAO cartDAO = new CartDAO();
        PromoDAO promoDAO = new PromoDAO();
        SizeDAO sizeDAO = new SizeDAO();

        // common params
        String size = request.getParameter("size");
        int productId = parseIntSafe(request.getParameter("id"), 0);
        int quantity = parseIntSafe(request.getParameter("quantity"), 0);

        switch (urlPath) {

            // Thêm vào giỏ
            case URL_CART_INSERT: {
                if (productId <= 0 || quantity <= 0 || size == null || size.isBlank()) {
                    response.sendRedirect(request.getContextPath() + "/error.jsp?message=Missing parameters for insert");
                    return;
                }

                // ADD: kiểm tra nếu hết hàng -> chặn ngay
                int availableQty = sizeDAO.getSizeQuantity(productId, size);
                if (availableQty <= 0) {
                    request.setAttribute("ms", "<script>alert('This product is out of stock!');</script>");
                    request.setAttribute("p", productDAO.getProductById(productId));
                    request.getRequestDispatcher("productDetail.jsp").forward(request, response);
                    return;
                }

                // kiểm kho theo size
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

                // ADD: kiểm tra vượt quá tồn kho
                if (quantity > matched.getQuantity()) {
                    request.setAttribute("ms", "<script>alert('Quantity exceeds inventory (" + matched.getQuantity() + ").');</script>");
                    request.setAttribute("p", productDAO.getProductById(productId));
                    request.getRequestDispatcher("productDetail.jsp").forward(request, response);
                    return;
                }

                // lấy đơn giá (đã áp promo theo product nếu có)
                float unitPrice = calcUnitPriceWithPromo(productDAO, promoDAO, productId);

                // đã có item cùng (product,size) chưa?
                List<entity.Cart> current = cartDAO.getAll(customer_id);
                entity.Cart existed = null;
                for (entity.Cart c : current) {
                    if (c.getProductID() == productId && size.equals(c.getSize_name())) {
                        existed = c;
                        break;
                    }
                }

                if (existed != null) {
                    int newQty = existed.getQuantity() + quantity;
                    // ADD: kiểm tra tồn kho khi tăng số lượng
                    if (newQty > matched.getQuantity()) {
                        request.setAttribute("ms", "<script>alert('Sold out! Only " + matched.getQuantity() + " items left in stock!');</script>");
                        request.setAttribute("p", productDAO.getProductById(productId));
                        request.getRequestDispatcher("productDetail.jsp").forward(request, response);
                        return;
                    }
                    cartDAO.updateCart(customer_id, productId, newQty, unitPrice, size);
                } else {
                    cartDAO.insertCart(quantity, unitPrice, customer_id, productId, size);
                }

                response.sendRedirect("loadCart?size=" + size);
                break;
            }

            // Tăng số lượng (AJAX)
            case URL_CART_INCREASE: {
                response.setContentType("text/plain; charset=UTF-8");

                if (productId <= 0 || quantity <= 0 || size == null || size.isBlank()) {
                    response.getWriter().write("0,0,1");
                    return;
                }

                //ADD: kiểm tra kho thật trước khi tăng
                int stock = sizeDAO.getSizeQuantity(productId, size);
                if (stock == 0 || quantity > stock) {
                    response.getWriter().write("0,0,1"); // temp=1 sold out
                    return;
                }

                cartDAO.updateQuantityOnly(customer_id, productId, size, quantity);

                float unitPrice = calcUnitPriceWithPromo(productDAO, promoDAO, productId);
                int lineTotal = Math.round(unitPrice * quantity);
                int sum = cartDAO.getCartTotal(customer_id);
                response.getWriter().write(lineTotal + "," + sum + ",0");
                break;
            }

            // Giảm số lượng (AJAX)
            case URL_CART_DECREASE: {
                response.setContentType("text/plain; charset=UTF-8");

                if (productId <= 0 || quantity <= 0 || size == null || size.isBlank()) {
                    response.getWriter().write("0,0");
                    return;
                }

                
                if (quantity == 0) {
                    cartDAO.deleteCartBySize(productId, customer_id, size);
                    int sum = cartDAO.getCartTotal(customer_id);
                    response.getWriter().write("0," + sum);
                    return;
                }

                cartDAO.updateQuantityOnly(customer_id, productId, size, quantity);

                float unitPrice = calcUnitPriceWithPromo(productDAO, promoDAO, productId);
                int lineTotal = Math.round(unitPrice * quantity);
                int sum = cartDAO.getCartTotal(customer_id);
                response.getWriter().write(lineTotal + "," + sum);
                break;
            }

            // Xoá 1 item theo (id,size) -> trả "OK,sum,count"
            case URL_CART_DELETE: {
                response.setContentType("text/plain; charset=UTF-8");

                if (productId <= 0 || size == null || size.isBlank()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("ERROR,0,0");
                    return;
                }

                boolean ok = cartDAO.deleteCartBySize(productId, customer_id, size);
                int sum = cartDAO.getCartTotal(customer_id);
                int count = cartDAO.getCartCount(customer_id);

                response.getWriter().write((ok ? "OK" : "ERROR") + "," + sum + "," + count);
                break;
            }

            case URL_PAYMENT: {
                response.sendRedirect("loadPayment?size=" + (size == null ? "" : size));
                break;
            }

            case URL_CART_LIST: {
                response.sendRedirect("loadCart");
                break;
            }

            default: {
                response.sendRedirect(request.getContextPath() + "/error.jsp?message=Unknown cart operation");
                break;
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }

    private static int parseIntSafe(String s, int def) {
        try {
            return (s == null || s.isBlank()) ? def : Integer.parseInt(s);
        } catch (Exception e) {
            return def;
        }
    }

    // Lấy ĐƠN GIÁ sau khuyến mãi theo product.promo (nếu có)
    private static float calcUnitPriceWithPromo(ProductDAO productDAO, PromoDAO promoDAO, int productId) {
        Product p = productDAO.getProductById(productId);
        if (p == null) {
            return 0f;
        }

        int percent = 0;
        int promoId = p.getPromoID();
        if (promoId > 0) {
            List<Promo> promos = promoDAO.getAll();
            int idx = promoId - 1;
            if (promos != null && idx >= 0 && idx < promos.size()) {
                percent = promos.get(idx).getPromoPercent();
            }
        }
        return p.getPrice() - (p.getPrice() * percent / 100.0f);
    }
}
