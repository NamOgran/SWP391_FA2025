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

import static url.CartURL.URL_CART_CHANGE_SIZE;
import static url.CartURL.URL_CART_DECREASE;
import static url.CartURL.URL_CART_DELETE;
import static url.CartURL.URL_CART_INCREASE;
import static url.CartURL.URL_CART_INSERT;
import static url.CartURL.URL_CART_LIST;
import static url.CartURL.URL_PAYMENT;

@WebServlet(name = "cart", urlPatterns = {
    URL_CART_INSERT, URL_CART_LIST, URL_CART_INCREASE, URL_CART_DECREASE,
    URL_CART_DELETE, URL_PAYMENT, URL_CART_CHANGE_SIZE
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
            // Nếu chưa đăng nhập → redirect login (AJAX phía client sẽ detect redirect)
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

            // === Add to Cart (AJAX) ===
            case URL_CART_INSERT: {
                // Trả plain text cho AJAX
                response.setContentType("text/plain; charset=UTF-8");

                // Check param cơ bản
                if (productId <= 0 || quantity <= 0 || size == null || size.isBlank()) {
                    response.getWriter().write("ERROR: Missing parameters.");
                    return;
                }

                // 1. Kiểm tra sản phẩm tồn tại & còn active
                Product product = productDAO.getProductById(productId);
                if (product == null) {
                    response.getWriter().write("ERROR: Product not found.");
                    return;
                }
                if (!product.isIs_active()) {
                    response.getWriter().write("ERROR: This product is no longer available.");
                    return;
                }

                // 2. Kiểm tra tồn kho size (tổng theo size)
                int availableQty = sizeDAO.getSizeQuantity(productId, size);
                if (availableQty <= 0) {
                    response.getWriter().write("ERROR: This size is out of stock.");
                    return;
                }

                // 3. Tìm Size_detail cụ thể
                List<Size_detail> sizes = sizeDAO.getAll();
                Size_detail matched = null;
                for (Size_detail s : sizes) {
                    if (s.getProduct_id() == productId && size.equals(s.getSize_name())) {
                        matched = s;
                        break;
                    }
                }
                if (matched == null) {
                    response.getWriter().write("ERROR: Size not found.");
                    return;
                }

                int stockQty = matched.getQuantity();

                // Nếu số muốn thêm > tồn kho -> chặn luôn
                if (quantity > stockQty) {
                    response.getWriter().write(
                            "ERROR: Quantity exceeds inventory (" + stockQty + ")."
                    );
                    return;
                }

                // 4. Tính giá đơn vị sau voucher (INT)
                int unitPrice = calcUnitPriceWithVoucher(productDAO, voucherDAO, productId);

                // 5. Lấy giỏ hàng hiện tại của user, tìm xem đã có cùng product + size chưa
                List<entity.Cart> current = cartDAO.getAll(customer_id);
                entity.Cart existed = null;
                int currentQty = 0;
                for (entity.Cart c : current) {
                    if (c.getProductID() == productId && size.equals(c.getSize_name())) {
                        existed = c;
                        currentQty = c.getQuantity();
                        break;
                    }
                }

                int totalRequested = currentQty + quantity; // ĐÃ CÓ + MUỐN THÊM

                // Nghiệp vụ: nếu tổng > tồn kho thì không cho thêm
                if (totalRequested > stockQty) {
                    int maxCanAdd = stockQty - currentQty;

                    if (maxCanAdd <= 0) {
                        response.getWriter().write(
                                "ERROR: You already have the maximum stock (" + stockQty + ") for this size in your cart."
                        );
                    } else {
                        response.getWriter().write(
                                "ERROR: You already have " + currentQty + " item(s) in your cart. "
                                        + "You can only add " + maxCanAdd + " more (stock: " + stockQty + ")."
                        );
                    }
                    return;
                }

                // 6. Nếu ok → update / insert
                if (existed != null) {
                    int newQty = currentQty + quantity;
                    cartDAO.updateCart(customer_id, productId, newQty, unitPrice, size);
                } else {
                    cartDAO.insertCart(quantity, unitPrice, customer_id, productId, size);
                }

                // 7. Thành công
                response.getWriter().write("OK");
                break;
            }

            // === Increase Quantity (AJAX) ===
            case URL_CART_INCREASE: {
                response.setContentType("text/plain; charset=UTF-8");
                if (productId <= 0 || quantity <= 0 || size == null || size.isBlank()) {
                    response.getWriter().write("0,0,1");
                    return;
                }

                // CHECK PRODUCT EXIST & ACTIVE
                Product product = productDAO.getProductById(productId);
                if (product == null || !product.isIs_active()) {
                    // Tạm dùng cùng mã lỗi với "hết hàng" (1) để không phải sửa JS
                    response.getWriter().write("0,0,1");
                    return;
                }

                int size_detail = sizeDAO.getSizeQuantity(productId, size);
                if (size_detail == 0 || quantity > size_detail) {
                    response.getWriter().write("0,0,1"); // temp=1 sold out
                    return;
                }

                cartDAO.updateQuantityOnly(customer_id, productId, size, quantity);

                // Tính lại tổng tiền với giá INT
                int unitPrice = calcUnitPriceWithVoucher(productDAO, voucherDAO, productId);
                int lineTotal = unitPrice * quantity;
                int sum = cartDAO.getCartTotal(customer_id);

                response.getWriter().write(lineTotal + "," + sum + ",0");
                break;
            }

            // === Decrease Quantity (AJAX) ===
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

                int unitPrice = calcUnitPriceWithVoucher(productDAO, voucherDAO, productId);
                int lineTotal = unitPrice * quantity;
                int sum = cartDAO.getCartTotal(customer_id);

                response.getWriter().write(lineTotal + "," + sum);
                break;
            }

            // === Delete Item (AJAX) ===
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

            // === Change Size in Cart (AJAX) ===
            case URL_CART_CHANGE_SIZE: {
                response.setContentType("text/plain; charset=UTF-8");

                String oldSize = request.getParameter("oldSize");
                String newSize = request.getParameter("newSize");

                if (productId <= 0
                        || oldSize == null || oldSize.isBlank()
                        || newSize == null || newSize.isBlank()) {
                    response.getWriter().write("ERROR");
                    return;
                }

                if (oldSize.equals(newSize)) {
                    response.getWriter().write("OK");
                    return;
                }

                // kiểm tra tồn kho size mới
                int newSizeQty = sizeDAO.getSizeQuantity(productId, newSize);
                if (newSizeQty <= 0) {
                    response.getWriter().write("OUT_OF_STOCK");
                    return;
                }

                // lấy giỏ hàng hiện tại
                List<entity.Cart> carts = cartDAO.getAll(customer_id);
                entity.Cart oldItem = null;
                entity.Cart sameNew = null;

                for (entity.Cart c : carts) {
                    if (c.getProductID() == productId && oldSize.equals(c.getSize_name())) {
                        oldItem = c;
                    }
                    if (c.getProductID() == productId && newSize.equals(c.getSize_name())) {
                        sameNew = c;
                    }
                }

                if (oldItem == null) {
                    response.getWriter().write("ERROR");
                    return;
                }

                int qtyToMove = oldItem.getQuantity();

                // nếu đã có dòng cùng product + newSize thì gộp quantity
                if (sameNew != null) {
                    int merged = sameNew.getQuantity() + qtyToMove;
                    if (merged > newSizeQty) {
                        response.getWriter().write("NOT_ENOUGH_STOCK");
                        return;
                    }

                    cartDAO.updateQuantityOnly(customer_id, productId, newSize, merged);
                    cartDAO.deleteCartBySize(productId, customer_id, oldSize);
                } else {
                    if (qtyToMove > newSizeQty) {
                        response.getWriter().write("NOT_ENOUGH_STOCK");
                        return;
                    }
                    // chèn dòng mới với size mới, xoá dòng size cũ
                    cartDAO.insertCart(qtyToMove, oldItem.getPrice(), customer_id, productId, newSize);
                    cartDAO.deleteCartBySize(productId, customer_id, oldSize);
                }

                int sum = cartDAO.getCartTotal(customer_id);
                response.getWriter().write("OK," + sum);
                break;
            }

            // === Payment redirect ===
            case URL_PAYMENT: {
                response.sendRedirect("loadPayment?size=" + (size == null ? "" : size));
                break;
            }

            // === Cart list redirect ===
            case URL_CART_LIST: {
                response.sendRedirect("loadCart");
                break;
            }

            default: {
                response.sendRedirect(request.getContextPath()
                        + "/error.jsp?message=Unknown cart operation");
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

    // Tính giá đơn vị sau voucher, trả về int để đồng bộ DB
    private static int calcUnitPriceWithVoucher(ProductDAO productDAO, VoucherDAO voucherDAO, int productId) {
        Product p = productDAO.getProductById(productId);
        if (p == null) {
            return 0;
        }

        int percent = 0;
        int voucherId = p.getVoucherID();
        if (voucherId > 0) {
            Integer vPercent = voucherDAO.getPercentById(voucherId);
            if (vPercent != null) {
                percent = vPercent;
            }
        }

        float originalPrice = (float) p.getPrice();
        float discountedPrice = originalPrice - (originalPrice * percent / 100.0f);

        return Math.round(discountedPrice);
    }
}
