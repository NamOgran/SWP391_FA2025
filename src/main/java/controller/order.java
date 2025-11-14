package controller;

import DAO.CartDAO;
import DAO.OrderDAO;
import DAO.ProductDAO;
import DAO.PromoDAO;
import DAO.SizeDAO;
import entity.OrderDetail;
import entity.Orders;
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
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static url.OrderURL.INSERT_ORDERS;
import static url.OrderURL.INSERT_ORDERS_DETAILS; // không dùng, giữ để compat
import static url.OrderURL.URL_HISTORY_ORDERS;
import static url.OrderURL.URL_ORDER_LIST;
import static url.OrderURL.URL_UPDATE_STATUS;
import static url.OrderURL.URL_VIEW_ORDERS;

@WebServlet(name = "order", urlPatterns = {
    INSERT_ORDERS, INSERT_ORDERS_DETAILS, URL_ORDER_LIST, URL_UPDATE_STATUS, URL_VIEW_ORDERS, URL_HISTORY_ORDERS
})
public class Order extends HttpServlet {

    private static final int SHIPPING_FEE = 20000;
    private static final int FREE_SHIP_THRESHOLD = 200000;

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

        int customer_id = acc.getCustomer_id();
        String urlPath = request.getServletPath();

        CartDAO daoCart = new CartDAO();
        OrderDAO daoOrder = new OrderDAO();
        ProductDAO daoProduct = new ProductDAO();
        PromoDAO daoPromo = new PromoDAO();
        SizeDAO daoSize = new SizeDAO();

        List<Orders> orderList = daoOrder.getAllOrders();
        List<OrderDetail> orderDetailList = daoOrder.getAllOrdersDetail();
        List<Product> productList = daoProduct.getAll();
        List<Orders> ordersUserList = daoOrder.orderUser(customer_id);

        Map<Integer, String> nameProduct = new HashMap<>();
        for (Product p : productList) {
            nameProduct.put(p.getId(), p.getName());
        }

        List<Promo> promoList = daoPromo.getAll();
        Map<Integer, Integer> promoMap = new HashMap<>();
        for (Promo pr : promoList) {
            promoMap.put(pr.getPromoID(), pr.getPromoPercent());
        }

        Map<Integer, Integer> priceProduct = new HashMap<>();
        Map<Integer, Integer> promoID = new HashMap<>();
        Map<Integer, String> picUrlMap = new HashMap<>();
        Map<Integer, Integer> priceP = new HashMap<>();
        for (Product p : productList) {
            priceProduct.put(p.getId(), p.getPrice());
            promoID.put(p.getId(), p.getPromoID());
            picUrlMap.put(p.getId(), p.getPicURL());
            priceP.put(p.getId(), p.getPrice());
        }

        Map<Integer, Integer> ordersQuantityMap = new HashMap<>();
        for (OrderDetail od : orderDetailList) {
            ordersQuantityMap.put(od.getOrderID(), od.getQuantity());
        }

        Map<Integer, Integer> totalQuantityMap = new HashMap<>();
        for (Orders od_item : orderList) {
            int q = 0;
            for (OrderDetail d : orderDetailList) {
                if (od_item.getOrderID() == d.getOrderID()) {
                    q += d.getQuantity();
                }
            }
            totalQuantityMap.put(od_item.getOrderID(), q);
        }

        switch (urlPath) {

            // ===== TẠO ĐƠN HÀNG =====
            case INSERT_ORDERS: {
                String size = request.getParameter("size");
                String address = request.getParameter("address");
                String newaddress = request.getParameter("newaddress");
                String phoneNumber = request.getParameter("phoneNumber");
                String status = "Pending";
                Date currentDate = new Date(System.currentTimeMillis());

                int staffRaw = parseIntSafe(request.getParameter("staff_id"), 0);
                Integer staffId = (staffRaw > 0) ? Integer.valueOf(staffRaw) : null;

                // ===== BUY NOW =====
                String idParam = request.getParameter("id");
                if (idParam != null && !idParam.trim().isEmpty()) {
                    int productId = parseIntSafe(idParam, 0);
                    int quantity = Math.max(1, parseIntSafe(request.getParameter("quantity"), 1));
                    if (productId <= 0 || size == null || size.isBlank()) {
                        response.sendRedirect(request.getContextPath() + "/error.jsp?message=Missing parameters for single buy");
                        return;
                    }

                    // ADD: Chặn ngay trên server — product inactive / hết tổng tồn → popup + REDIRECT về Home
                    Product pCheck = daoProduct.getProductById(productId);
                    if (pCheck == null || !pCheck.isIs_active() || daoSize.getTotalQuantityByProductId(productId) <= 0) {
                        // CHANGE: dùng session + redirect để rời buyNow (PRG), tránh ở lại trang và bấm lần 2
                        if (session != null) session.setAttribute("popupMessage", "This product is out of stock!");
                        response.sendRedirect("productList"); // ← về Home page
                        return;
                    }

                    // ADD: Kiểm tra theo size (không đủ số lượng hoặc size hết) → popup + REDIRECT về Home
                    Size s = daoSize.getSizeByProductIdAndName(productId, size);
                    if (s == null || s.getQuantity() <= 0 || s.getQuantity() < quantity) {
                        if (session != null) session.setAttribute("popupMessage", "This size is out of stock!");
                        response.sendRedirect("productList"); // ← về Home page
                        return;
                    }

                    // ===== Hợp lệ → tạo đơn =====
                    float unitPriceF = calcUnitPriceWithPromoSafe(daoProduct, daoPromo, productId);
                    int unitPrice = Math.max(0, Math.round(unitPriceF));
                    int subtotal = unitPrice * quantity;
                    int shipping = (subtotal > 0 && subtotal < FREE_SHIP_THRESHOLD) ? SHIPPING_FEE : 0;

                    int promoIdFromReq = parseIntSafe(request.getParameter("promoId"), 0);
                    int promoPctFromReq = parseIntSafe(request.getParameter("promoPct"), 0);
                    int promoPercent = (promoIdFromReq > 0)
                            ? findPromoPercentById(daoPromo, promoIdFromReq)
                            : Math.max(0, promoPctFromReq);

                    int discount = Math.round(subtotal * (promoPercent / 100.0f));
                    int grand = Math.max(0, subtotal + shipping - discount);
                    String addr = (newaddress != null && !newaddress.trim().isEmpty()) ? newaddress : address;

                    int orderID = daoOrder.insertOrder(addr, currentDate, status, phoneNumber, customer_id, staffId, grand);
                    if (orderID <= 0) {
                        response.sendRedirect(request.getContextPath() + "/error.jsp?message=Cannot create order");
                        return;
                    }

                    daoOrder.insertOrderDetail(quantity, size, productId, orderID);

                    //  ADD: Trừ kho size & cập nhật tổng tồn product
                    int newQty = s.getQuantity() - quantity;
                    daoSize.updateQuanSize(newQty, productId, size);
                    int totalAfter = daoSize.getTotalQuantityByProductId(productId);
                    daoProduct.updateQuan(totalAfter, productId);

                    //  ADD: Popup đặt hàng thành công + REDIRECT Home (PRG)
                    if (session != null) session.setAttribute("popupMessage", "Order placed successfully! Thank you for shopping at GIO Shop!");
                    response.sendRedirect("productList");
                    return;
                }

                // ===== MUA TỪ GIỎ =====
                List<entity.Cart> cartList = daoCart.getAll(customer_id);
                if (cartList == null || cartList.isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/error.jsp?message=Cart is empty");
                    return;
                }

                // Kiểm kho từng item trong giỏ
                StringBuilder issue = new StringBuilder();
                boolean hasIssue = false;
                for (entity.Cart c : cartList) {
                    Size sz = daoSize.getSizeByProductIdAndName(c.getProductID(), c.getSize_name());
                    if (sz == null || sz.getQuantity() <= 0 || c.getQuantity() > sz.getQuantity()) {
                        Product p = daoProduct.getProductById(c.getProductID());
                        String pname = (p != null) ? p.getName() : ("ID " + c.getProductID());
                        hasIssue = true;
                        issue.append("Sold out! '").append(pname).append("' (")
                                .append(c.getSize_name()).append(") only ")
                                .append((sz != null) ? sz.getQuantity() : 0)
                                .append(" left.\\n");
                    }
                }
                if (hasIssue) {
                    // ADD: Báo popup & forward về giỏ (giữ nguyên hành vi cart)
                    request.setAttribute("popupMessage", "Some products are out of stock!");
                    request.setAttribute("productList", productList);
                    request.getRequestDispatcher("cart.jsp").forward(request, response);
                    return;
                }

                // Tính tiền giỏ
                int subtotal = daoCart.getCartTotal(customer_id);
                int promoPercent = 0;
                Object sessPromo = (session != null) ? session.getAttribute("promoPercent") : null;
                if (sessPromo instanceof Integer) promoPercent = (Integer) sessPromo;
                int discount = Math.round(subtotal * (promoPercent / 100.0f));
                int shipping = (subtotal > 0 && subtotal < FREE_SHIP_THRESHOLD) ? SHIPPING_FEE : 0;
                int finalTotal = Math.max(0, subtotal + shipping - discount);
                String addr = (newaddress != null && !newaddress.trim().isEmpty()) ? newaddress : address;

                int orderID = daoOrder.insertOrder(addr, currentDate, status, phoneNumber, customer_id, staffId, finalTotal);
                if (orderID <= 0) {
                    response.sendRedirect(request.getContextPath() + "/error.jsp?message=Cannot create order");
                    return;
                }

                // Lưu chi tiết + trừ kho size + cập nhật tổng product + xoá giỏ
                for (entity.Cart c : cartList) {
                    daoOrder.insertOrderDetail(c.getQuantity(), c.getSize_name(), c.getProductID(), orderID);
                    Size cur = daoSize.getSizeByProductIdAndName(c.getProductID(), c.getSize_name());
                    if (cur != null) {
                        int newQty = cur.getQuantity() - c.getQuantity();
                        daoSize.updateQuanSize(newQty, c.getProductID(), c.getSize_name());
                        daoProduct.updateQuan(daoSize.getTotalQuantityByProductId(c.getProductID()), c.getProductID());
                    }
                    daoCart.deleteCartBySize(c.getProductID(), customer_id, c.getSize_name());
                }

                // Clear promo session của giỏ (nếu có)
                if (session != null) {
                    session.removeAttribute("promoPercent");
                    session.removeAttribute("promoCode");
                    session.removeAttribute("promoType");
                    session.removeAttribute("promoValue");
                }

                //ADD: Popup đặt hàng thành công (giỏ) + REDIRECT Home
                if (session != null) session.setAttribute("popupMessage", "Order placed successfully! Thank you for shopping at GIO Shop!");
                response.sendRedirect("productList");
                return;
            }

            // ===== Dashboard staff (thống kê) =====
            case URL_ORDER_LIST: {
                int numberOfOrder;
                int numberOfProduct;
                int revenue;
                int numberOfCustomer;

                String date = request.getParameter("date");
                if ("date".equals(date)) {
                    int yearInt = parseIntSafe(request.getParameter("year"),
                            java.time.Year.now().getValue());

                    numberOfOrder = daoProduct.getNumberOfOrderByYear(yearInt);
                    numberOfProduct = daoProduct.getNumberOfProductByYear(yearInt);
                    revenue = daoProduct.getRevenueByYear(yearInt);
                    numberOfCustomer = daoProduct.getNumberOfCustomerByYear(yearInt);

                    int r1 = 0, r2 = 0, r3 = 0, r4 = 0, r5 = 0, r6 = 0, r7 = 0, r8 = 0, r9 = 0, r10 = 0, r11 = 0, r12 = 0;
                    r1 = daoProduct.getRevenueByMonth(1, yearInt);
                    r2 = daoProduct.getRevenueByMonth(2, yearInt);
                    r3 = daoProduct.getRevenueByMonth(3, yearInt);
                    r4 = daoProduct.getRevenueByMonth(4, yearInt);
                    r5 = daoProduct.getRevenueByMonth(5, yearInt);
                    r6 = daoProduct.getRevenueByMonth(6, yearInt);
                    r7 = daoProduct.getRevenueByMonth(7, yearInt);
                    r8 = daoProduct.getRevenueByMonth(8, yearInt);
                    r9 = daoProduct.getRevenueByMonth(9, yearInt);
                    r10 = daoProduct.getRevenueByMonth(10, yearInt);
                    r11 = daoProduct.getRevenueByMonth(11, yearInt);
                    r12 = daoProduct.getRevenueByMonth(12, yearInt);

                    request.setAttribute("revenue1", r1);
                    request.setAttribute("revenue2", r2);
                    request.setAttribute("revenue3", r3);
                    request.setAttribute("revenue4", r4);
                    request.setAttribute("revenue5", r5);
                    request.setAttribute("revenue6", r6);
                    request.setAttribute("revenue7", r7);
                    request.setAttribute("revenue8", r8);
                    request.setAttribute("revenue9", r9);
                    request.setAttribute("revenue10", r10);
                    request.setAttribute("revenue11", r11);
                    request.setAttribute("revenue12", r12);

                    request.setAttribute("quarter1", r1 + r2 + r3);
                    request.setAttribute("quarter2", r4 + r5 + r6);
                    request.setAttribute("quarter3", r7 + r8 + r9);
                    request.setAttribute("quarter4", r10 + r11 + r12);

                    request.setAttribute("numberOfProduct", numberOfProduct);
                    request.setAttribute("numberOfOrder", numberOfOrder);
                    request.setAttribute("revenue", revenue);
                    request.setAttribute("numberOfCustomer", numberOfCustomer);
                } else {
                    int currentYear = java.time.Year.now().getValue();

                    numberOfProduct = daoProduct.getNumberOfProduct();
                    numberOfOrder = daoProduct.getNumberOfOrder();
                    revenue = daoProduct.getRevenue();
                    numberOfCustomer = daoProduct.getNumberOfCustomer();

                    int r1 = 0, r2 = 0, r3 = 0, r4 = 0, r5 = 0, r6 = 0, r7 = 0, r8 = 0, r9 = 0, r10 = 0, r11 = 0, r12 = 0;
                    r1 = daoProduct.getRevenueByMonth(1, currentYear);
                    r2 = daoProduct.getRevenueByMonth(2, currentYear);
                    r3 = daoProduct.getRevenueByMonth(3, currentYear);
                    r4 = daoProduct.getRevenueByMonth(4, currentYear);
                    r5 = daoProduct.getRevenueByMonth(5, currentYear);
                    r6 = daoProduct.getRevenueByMonth(6, currentYear);
                    r7 = daoProduct.getRevenueByMonth(7, currentYear);
                    r8 = daoProduct.getRevenueByMonth(8, currentYear);
                    r9 = daoProduct.getRevenueByMonth(9, currentYear);
                    r10 = daoProduct.getRevenueByMonth(10, currentYear);
                    r11 = daoProduct.getRevenueByMonth(11, currentYear);
                    r12 = daoProduct.getRevenueByMonth(12, currentYear);

                    request.setAttribute("revenue1", r1);
                    request.setAttribute("revenue2", r2);
                    request.setAttribute("revenue3", r3);
                    request.setAttribute("revenue4", r4);
                    request.setAttribute("revenue5", r5);
                    request.setAttribute("revenue6", r6);
                    request.setAttribute("revenue7", r7);
                    request.setAttribute("revenue8", r8);
                    request.setAttribute("revenue9", r9);
                    request.setAttribute("revenue10", r10);
                    request.setAttribute("revenue11", r11);
                    request.setAttribute("revenue12", r12);

                    request.setAttribute("quarter1", r1 + r2 + r3);
                    request.setAttribute("quarter2", r4 + r5 + r6);
                    request.setAttribute("quarter3", r7 + r8 + r9);
                    request.setAttribute("quarter4", r10 + r11 + r12);

                    request.setAttribute("numberOfOrder", numberOfOrder);
                    request.setAttribute("numberOfProduct", numberOfProduct);
                    request.setAttribute("revenue", revenue);
                    request.setAttribute("numberOfCustomer", numberOfCustomer);
                }

                request.setAttribute("orderDetailList", orderDetailList);
                request.setAttribute("orderList", daoOrder.getAllOrdersSort());
                request.setAttribute("nameProduct", nameProduct);
                request.setAttribute("priceProduct", priceProduct);
                request.setAttribute("promoMap", promoMap);
                request.setAttribute("promoID", promoID);
                request.getRequestDispatcher("staff.jsp").forward(request, response);
                break;
            }

            // ===== Cập nhật trạng thái đơn =====
            case URL_UPDATE_STATUS: {
                int orderId = parseIntSafe(request.getParameter("orderId"), 0);
                String newStatus = request.getParameter("status");
                daoOrder.updateStatus(newStatus, orderId);

                if ("Delivering".equals(newStatus)) {
                    List<OrderDetail> details = daoOrder.getAllOrdersDetailByID(orderId);
                    if (details != null) {
                        for (OrderDetail od : details) {
                            Size cur = daoSize.getSizeByProductIdAndName(od.getProductID(), od.getSize_name());
                            if (cur != null) {
                                int newQty = cur.getQuantity() - od.getQuantity();
                                daoSize.updateQuanSize(newQty, od.getProductID(), cur.getSize_name());
                            }
                        }
                    }
                    for (Product p : daoProduct.getAll()) {
                        int total = daoSize.getTotalQuantityByProductId(p.getId());
                        daoProduct.updateQuan(total, p.getId());
                    }
                }
                response.getWriter().write("success");
                break;
            }

            // ===== Xem chi tiết đơn của user =====
            case URL_VIEW_ORDERS: {
                request.setAttribute("totalQuantityMap", totalQuantityMap);
                request.setAttribute("promoID", promoID);
                request.setAttribute("promoMap", promoMap);
                request.setAttribute("priceP", priceP);
                request.setAttribute("picUrlMap", picUrlMap);
                request.setAttribute("nameProduct", nameProduct);
                request.setAttribute("orderDetailList", orderDetailList);
                request.setAttribute("ordersQuantityMap", ordersQuantityMap);
                request.setAttribute("ordersUserList", ordersUserList);
                request.getRequestDispatcher("viewOrder.jsp").forward(request, response);
                break;
            }

            // ===== Lịch sử đơn của user + đổi trạng thái từ lịch sử =====
            case URL_HISTORY_ORDERS: {
                String orderIdStr = request.getParameter("orderId");
                String newStatus2 = request.getParameter("status");
                if (newStatus2 != null && !newStatus2.trim().isEmpty()) {
                    int orderId3 = parseIntSafe(orderIdStr, 0);
                    daoOrder.updateStatus(newStatus2, orderId3);
                    response.getWriter().write("success");
                } else {
                    ordersUserList = daoOrder.orderUser(customer_id);
                    request.setAttribute("totalQuantityMap", totalQuantityMap);
                    request.setAttribute("promoID", promoID);
                    request.setAttribute("promoMap", promoMap);
                    request.setAttribute("priceP", priceP);
                    request.setAttribute("picUrlMap", picUrlMap);
                    request.setAttribute("nameProduct", nameProduct);
                    request.setAttribute("orderDetailList", orderDetailList);
                    request.setAttribute("ordersQuantityMap", ordersQuantityMap);
                    request.setAttribute("ordersUserList", ordersUserList);
                    request.getRequestDispatcher("ordersHistory.jsp").forward(request, response);
                }
                break;
            }

            default:
                response.sendRedirect(request.getContextPath() + "/error.jsp?message=Unknown order operation");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private static int parseIntSafe(String s, int def) {
        try { return (s == null || s.isBlank()) ? def : Integer.parseInt(s); }
        catch (Exception e) { return def; }
    }

    private static int findPromoPercentById(PromoDAO daoPromo, int promoId) {
        List<Promo> promos = daoPromo.getAll();
        if (promos == null) return 0;
        for (Promo pr : promos) {
            if (pr != null && pr.getPromoID() == promoId) return Math.max(0, pr.getPromoPercent());
        }
        return 0;
    }

    private static float calcUnitPriceWithPromoSafe(ProductDAO productDAO, PromoDAO promoDAO, int productId) {
        Product p = productDAO.getProductById(productId);
        if (p == null) return 0f;
        int percent = (p.getPromoID() > 0) ? findPromoPercentById(promoDAO, p.getPromoID()) : 0;
        return p.getPrice() - (p.getPrice() * (percent / 100.0f));
    }

    private static float calcUnitPriceWithPromo(ProductDAO productDAO, PromoDAO promoDAO, int productId) {
        return calcUnitPriceWithPromoSafe(productDAO, promoDAO, productId);
    }
}
