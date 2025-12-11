package controller;

import DAO.CartDAO;
import DAO.ProductDAO;
import DAO.VoucherDAO;
import DAO.Size_detailDAO;
import entity.Product;
import entity.Voucher;
import entity.Size_detail;
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
public class CartControlller extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        entity.Customer acc = (session != null) ? (entity.Customer) session.getAttribute("acc") : null;
        if (acc == null) {
            // Nếu là AJAX gọi, frontend sẽ xử lý redirect
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        final int customer_id = acc.getCustomer_id();
        final String urlPath = request.getServletPath();
        ProductDAO productDAO = new ProductDAO();
        CartDAO cartDAO = new CartDAO();
        VoucherDAO voucherDAO = new VoucherDAO();
        Size_detailDAO sizeDAO = new Size_detailDAO();
        
        // Common params
        String size = request.getParameter("size");
        int productId = parseIntSafe(request.getParameter("id"), 0);
        int quantity = parseIntSafe(request.getParameter("quantity"), 0);

        switch (urlPath) {

            // === Add to Cart ===
            case URL_CART_INSERT: {
                if (productId <= 0 || quantity <= 0 || size == null || size.isBlank()) {
                    response.sendRedirect(request.getContextPath() + "/error.jsp?message=Missing parameters");
                    return;
                }

                // 1. Kiểm tra tồn kho tổng
                int availableQty = sizeDAO.getSizeQuantity(productId, size);
                if (availableQty <= 0) {
                    request.setAttribute("ms", "<script>alert('This product is out of size_detail!');</script>");
                    request.setAttribute("p", productDAO.getProductById(productId));
                    request.getRequestDispatcher("productDetail.jsp").forward(request, response);
                    return;
                }

                // 2. Kiểm tra tồn kho chi tiết
                List<Size_detail> sizes = sizeDAO.getAll();
                Size_detail matched = null;
                for (Size_detail s : sizes) {
                    if (s.getProduct_id() == productId && size.equals(s.getSize_name())) {
                        matched = s;
                        break;
                    }
                }
                if (matched == null) {
                    response.sendRedirect(request.getContextPath() + "/error.jsp?message=Size not found");
                    return;
                }

                if (quantity > matched.getQuantity()) {
                    request.setAttribute("ms", "<script>alert('Quantity exceeds inventory (" + matched.getQuantity() + ").');</script>");
                    request.setAttribute("p", productDAO.getProductById(productId));
                    request.getRequestDispatcher("productDetail.jsp").forward(request, response);
                    return;
                }

                // [FIX] Tính giá đơn vị (INT)
                int unitPrice = calcUnitPriceWithVoucher(productDAO, voucherDAO, productId);

                // Kiểm tra giỏ hàng hiện tại
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
                    if (newQty > matched.getQuantity()) {
                        request.setAttribute("ms", "<script>alert('Sold out! Only " + matched.getQuantity() + " items left!');</script>");
                        request.setAttribute("p", productDAO.getProductById(productId));
                        request.getRequestDispatcher("productDetail.jsp").forward(request, response);
                        return;
                    }
                    // [FIX] Truyền int price
                    cartDAO.updateCart(customer_id, productId, newQty, unitPrice, size);
                } else {
                    // [FIX] Truyền int price
                    cartDAO.insertCart(quantity, unitPrice, customer_id, productId, size);
                }

                response.setContentType("text/plain");
                response.getWriter().write("OK");
                break;
            }

            // Increase Quantity (AJAX)
            case URL_CART_INCREASE: {
                response.setContentType("text/plain; charset=UTF-8");
                if (productId <= 0 || quantity <= 0 || size == null || size.isBlank()) {
                    response.getWriter().write("0,0,1");
                    return;
                }

                int size_detail = sizeDAO.getSizeQuantity(productId, size);
                if (size_detail == 0 || quantity > size_detail) {
                    response.getWriter().write("0,0,1"); // temp=1 sold out
                    return;
                }

                cartDAO.updateQuantityOnly(customer_id, productId, size, quantity);
                
                // [FIX] Tính lại tổng tiền với giá INT
                int unitPrice = calcUnitPriceWithVoucher(productDAO, voucherDAO, productId);
                int lineTotal = unitPrice * quantity;
                int sum = cartDAO.getCartTotal(customer_id);
                
                response.getWriter().write(lineTotal + "," + sum + ",0");
                break;
            }

            // Decrease Quantity (AJAX)
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
                
                // [FIX] Tính lại tổng tiền với giá INT
                int unitPrice = calcUnitPriceWithVoucher(productDAO, voucherDAO, productId);
                int lineTotal = unitPrice * quantity;
                int sum = cartDAO.getCartTotal(customer_id);
                
                response.getWriter().write(lineTotal + "," + sum);
                break;
            }

            // Delete Item (AJAX)
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

    // [FIX] Đổi kiểu trả về từ float sang int để đồng bộ với DB
    private static int calcUnitPriceWithVoucher(ProductDAO productDAO, VoucherDAO voucherDAO, int productId) {
        Product p = productDAO.getProductById(productId);
        if (p == null) {
            return 0;
        }

        int percent = 0;
        int voucherId = p.getVoucherID();
        if (voucherId > 0) {
            // Lấy thông tin voucher
            Integer vPercent = voucherDAO.getPercentById(voucherId);
            if(vPercent != null) {
                percent = vPercent;
            }
        }
        
        // Tính giá sau giảm và làm tròn
        float originalPrice = (float) p.getPrice();
        float discountedPrice = originalPrice - (originalPrice * percent / 100.0f);
        
        return Math.round(discountedPrice);
    }
}