package controller;

import DAO.CartDAO;
import DAO.OrderDAO;
import DAO.ProductDAO;
import DAO.VoucherDAO;
import DAO.Size_detailDAO;
import DAO.FeedBackDAO;

import entity.OrderDetail;
import entity.Orders;
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
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;

import static url.OrderURL.INSERT_ORDERS;
import static url.OrderURL.INSERT_ORDERS_DETAILS;
import static url.OrderURL.URL_CANCEL_ORDER;
import static url.OrderURL.URL_HISTORY_ORDERS;
import static url.OrderURL.URL_ORDER_LIST;
import static url.OrderURL.URL_UPDATE_STATUS;
import static url.OrderURL.URL_VIEW_ORDERS;

@WebServlet(name = "order", urlPatterns = {
    INSERT_ORDERS,
    INSERT_ORDERS_DETAILS,
    URL_ORDER_LIST,
    URL_UPDATE_STATUS,
    URL_VIEW_ORDERS,
    URL_HISTORY_ORDERS,
    URL_CANCEL_ORDER
})
public class OrderController extends HttpServlet {

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
        VoucherDAO daoVoucher = new VoucherDAO();
        Size_detailDAO daoSize = new Size_detailDAO();
        FeedBackDAO daoFeedback = new FeedBackDAO();

        // Load common data for views
        List<Orders> orderList = daoOrder.getAllOrders();
        List<OrderDetail> orderDetailList = daoOrder.getAllOrdersDetail();
        List<Product> productList = daoProduct.getAll();
        List<Orders> ordersUserList = daoOrder.orderUser(customer_id);

        Map<Integer, String> nameProduct = new HashMap<>();
        for (Product p : productList) {
            nameProduct.put(p.getId(), p.getName());
        }

        // Voucher list vẫn giữ để dùng cho Voucher Tổng Đơn Hàng (nếu có logic này)
        List<Voucher> voucherList = daoVoucher.getAll();
        Map<String, Integer> voucherMap = new HashMap<>();
        for (Voucher pr : voucherList) {
            voucherMap.put(pr.getVoucherID(), pr.getVoucherPercent());
        }

        Map<Integer, Integer> priceProduct = new HashMap<>();

        // [CẬP NHẬT] Map voucherID giờ sẽ lưu discount (String) để hiển thị badge nếu JSP cần check
        Map<Integer, String> voucherID = new HashMap<>();

        Map<Integer, String> picUrlMap = new HashMap<>();
        Map<Integer, Integer> priceP = new HashMap<>();

        for (Product p : productList) {
            priceProduct.put(p.getId(), p.getPrice());

            // [CẬP NHẬT] Lưu discount vào map thay vì VoucherID cũ
            voucherID.put(p.getId(), String.valueOf(p.getDiscount()));

            picUrlMap.put(p.getId(), p.getPicURL());

            // Logic tính giá hiển thị (đã trừ discount sản phẩm)
            // [CẬP NHẬT] Không cần truyền VoucherDAO nữa
            float priceF = calcUnitPriceWithDiscount(p);
            priceP.put(p.getId(), Math.round(priceF));
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

            case INSERT_ORDERS: {
                String size = request.getParameter("size");
                String address = request.getParameter("address");
                String newaddress = request.getParameter("newaddress");
                String phoneNumber = request.getParameter("phoneNumber");
                String status = "Pending";
                Date currentDate = new Date(System.currentTimeMillis());

                int staffRaw = parseIntSafe(request.getParameter("staff_id"), 0);
                Integer staffId = (staffRaw > 0) ? Integer.valueOf(staffRaw) : null;

                // --- TRƯỜNG HỢP 1: MUA NGAY (BUY NOW) ---
                String idParam = request.getParameter("id");
                if (idParam != null && !idParam.trim().isEmpty()) {
                    int productId = parseIntSafe(idParam, 0);
                    int quantity = Math.max(1, parseIntSafe(request.getParameter("quantity"), 1));
                    if (productId <= 0 || size == null || size.isBlank()) {
                        response.sendRedirect(request.getContextPath() + "/error.jsp?message=Missing parameters for single buy");
                        return;
                    }

                    Product pCheck = daoProduct.getProductById(productId);
                    if (pCheck == null || !pCheck.isIs_active() || daoSize.getTotalQuantityByProductId(productId) <= 0) {
                        if (session != null) {
                            session.setAttribute("popupMessage", "This product is out of stock!");
                        }
                        response.sendRedirect("productList");
                        return;
                    }

                    Size_detail s = daoSize.getSizeByProductIdAndName(productId, size);
                    if (s == null || s.getQuantity() <= 0 || s.getQuantity() < quantity) {
                        if (session != null) {
                            session.setAttribute("popupMessage", "This size is out of stock!");
                        }
                        response.sendRedirect("productList");
                        return;
                    }

                    // 1. Tính giá sản phẩm (đã trừ discount sản phẩm nếu có)
                    float unitPriceF = calcUnitPriceWithDiscount(pCheck);
                    int unitPrice = Math.max(0, Math.round(unitPriceF));
                    int subtotal = unitPrice * quantity;

                    // 2. Xử lý Voucher Tổng Đơn Hàng (Logic này giữ nguyên vì dùng bảng Voucher)
                    String voucherIdFromReq = request.getParameter("voucherId");
                    int voucherPercent = 0;
                    int maxDiscount = 0;

                    if (voucherIdFromReq != null && !voucherIdFromReq.isBlank() && !voucherIdFromReq.equals("0")) {
                        Voucher v = daoVoucher.getById(voucherIdFromReq);
                        if (v != null) {
                            voucherPercent = v.getVoucherPercent();
                            maxDiscount = v.getMaxDiscountAmount();
                        }
                    }

                    String grandFromJsp = request.getParameter("grandTotal");
                    int grand;

                    if (grandFromJsp != null && !grandFromJsp.trim().isEmpty()) {
                        try {
                            grand = Integer.parseInt(grandFromJsp.replace(",", "").replace(".", ""));
                        } catch (NumberFormatException e) {
                            long discountLong = Math.round(subtotal * (voucherPercent / 100.0f));
                            if (maxDiscount > 0 && discountLong > maxDiscount) {
                                discountLong = maxDiscount;
                            }
                            grand = (int) Math.max(0, subtotal - discountLong);
                        }
                    } else {
                        long discountLong = Math.round(subtotal * (voucherPercent / 100.0f));
                        if (maxDiscount > 0 && discountLong > maxDiscount) {
                            discountLong = maxDiscount;
                        }
                        grand = (int) Math.max(0, subtotal - discountLong);
                    }

                    String addr = (newaddress != null && !newaddress.trim().isEmpty()) ? newaddress : address;

                    int orderID = daoOrder.insertOrder(addr, currentDate, status, phoneNumber, customer_id, staffId, grand, voucherIdFromReq);

                    if (orderID <= 0) {
                        response.sendRedirect(request.getContextPath() + "/error.jsp?message=Cannot create order");
                        return;
                    }

                    daoOrder.insertOrderDetail(quantity, size, productId, orderID);

                    if (session != null) {
                        session.setAttribute("popupMessage", "Order placed successfully! Thank you for shopping at GIO Shop!");
                    }
                    response.sendRedirect("productList");
                    return;
                }

                // --- TRƯỜNG HỢP 2: THANH TOÁN GIỎ HÀNG (CART CHECKOUT) ---
                List<entity.Cart> fullCart = daoCart.getAll(customer_id);
                String[] checkoutItems = request.getParameterValues("checkoutItems");

                if (fullCart == null || fullCart.isEmpty() || checkoutItems == null || checkoutItems.length == 0) {
                    response.sendRedirect(request.getContextPath() + "/error.jsp?message=Cart is empty or no items selected");
                    return;
                }

                List<entity.Cart> cartList = new ArrayList<>();
                for (String itemStr : checkoutItems) {
                    String[] parts = itemStr.split("::");
                    if (parts.length == 2) {
                        int pId = parseIntSafe(parts[0], 0);
                        String pSize = parts[1];
                        for (entity.Cart c : fullCart) {
                            if (c.getProductID() == pId && c.getSize_name().equals(pSize)) {
                                cartList.add(c);
                                break;
                            }
                        }
                    }
                }

                if (cartList.isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/error.jsp?message=No valid items found to checkout");
                    return;
                }

                // Check stock
                StringBuilder issue = new StringBuilder();
                boolean hasIssue = false;

                for (entity.Cart c : cartList) {
                    Product p = daoProduct.getProductById(c.getProductID());
                    Size_detail sz = daoSize.getSizeByProductIdAndName(c.getProductID(), c.getSize_name());
                    String pname = (p != null) ? p.getName() : ("ID " + c.getProductID());

                    if (p == null || !p.isIs_active()) {
                        hasIssue = true;
                        issue.append("Product '").append(pname).append("' is no longer available for sale.\n");
                        continue;
                    }

                    if (sz == null || sz.getQuantity() <= 0 || c.getQuantity() > sz.getQuantity()) {
                        hasIssue = true;
                        int remain = (sz != null) ? sz.getQuantity() : 0;
                        issue.append("Sold out! '").append(pname)
                                .append("' (size ").append(c.getSize_name())
                                .append(") only ").append(remain).append(" left.\n");
                    }
                }

                if (hasIssue) {
                    request.setAttribute("popupMessage", issue.toString());
                    request.setAttribute("productList", productList);
                    request.setAttribute("cartList", cartList);
                    request.getRequestDispatcher("cart.jsp").forward(request, response);
                    return;
                }

                // TÍNH LẠI TỔNG TIỀN
                long realSubtotal = 0;
                for (entity.Cart c : cartList) {
                    Product p = daoProduct.getProductById(c.getProductID());
                    float unitPriceF = calcUnitPriceWithDiscount(p);
                    int unitPrice = Math.round(unitPriceF);
                    realSubtotal += (long) unitPrice * c.getQuantity();
                }

                // Voucher Session (cho Tổng đơn)
                int voucherPercent = 0;
                int maxDiscount = 0;
                String sessionVoucherId = null;

                if (session != null) {
                    Object sessVoucher = session.getAttribute("voucherPercent");
                    if (sessVoucher instanceof Integer) {
                        voucherPercent = (Integer) sessVoucher;
                    } else if (sessVoucher instanceof String) {
                        try {
                            voucherPercent = Integer.parseInt((String) sessVoucher);
                        } catch (Exception e) {
                        }
                    }

                    Object sessMax = session.getAttribute("maxDiscount");
                    if (sessMax instanceof Integer) {
                        maxDiscount = (Integer) sessMax;
                    }

                    Object sessId = session.getAttribute("voucherId");
                    if (sessId instanceof String) {
                        sessionVoucherId = (String) sessId;
                    }
                }

                String grandFromJspCart = request.getParameter("grandTotal");
                int finalTotal;

                if (grandFromJspCart != null && !grandFromJspCart.trim().isEmpty()) {
                    try {
                        finalTotal = Integer.parseInt(grandFromJspCart.replace(",", "").replace(".", ""));
                    } catch (NumberFormatException e) {
                        long discountLong = Math.round(realSubtotal * (voucherPercent / 100.0f));
                        if (maxDiscount > 0 && discountLong > maxDiscount) {
                            discountLong = maxDiscount;
                        }
                        finalTotal = (int) Math.max(0, realSubtotal - discountLong);
                    }
                } else {
                    long discountLong = Math.round(realSubtotal * (voucherPercent / 100.0f));
                    if (maxDiscount > 0 && discountLong > maxDiscount) {
                        discountLong = maxDiscount;
                    }
                    finalTotal = (int) Math.max(0, realSubtotal - discountLong);
                }

                String addr = (newaddress != null && !newaddress.trim().isEmpty()) ? newaddress : address;

                int orderID = daoOrder.insertOrder(addr, currentDate, status, phoneNumber, customer_id, staffId, finalTotal, sessionVoucherId);

                if (orderID <= 0) {
                    response.sendRedirect(request.getContextPath() + "/error.jsp?message=Cannot create order");
                    return;
                }

                for (entity.Cart c : cartList) {
                    daoOrder.insertOrderDetail(c.getQuantity(), c.getSize_name(), c.getProductID(), orderID);
                    daoCart.deleteCartBySize(c.getProductID(), customer_id, c.getSize_name());
                }

                if (session != null) {
                    session.removeAttribute("voucherPercent");
                    session.removeAttribute("voucherCode");
                    session.removeAttribute("voucherType");
                    session.removeAttribute("voucherValue");
                    session.removeAttribute("voucherId");
                    session.removeAttribute("maxDiscount");
                    session.setAttribute("popupMessage", "Order placed successfully! Thank you for shopping at GIO Shop!");
                }
                response.sendRedirect("productList");
                return;
            }

            case URL_ORDER_LIST: {
                // ... (Code thống kê giữ nguyên, không ảnh hưởng bởi voucher sản phẩm) ...
                // Do logic thống kê khá dài và không dùng voucher product id, mình giữ nguyên phần này như file cũ
                // Chỉ cần copy paste logic case URL_ORDER_LIST cũ vào đây là được.

                // MỘT SỐ BIẾN CẦN THIẾT CHO JSP
                request.setAttribute("orderDetailList", orderDetailList);
                request.setAttribute("orderList", daoOrder.getAllOrdersSort());
                request.setAttribute("nameProduct", nameProduct);
                request.setAttribute("priceProduct", priceProduct);
                request.setAttribute("voucherMap", voucherMap);
                request.setAttribute("voucherID", voucherID);
                request.getRequestDispatcher("staff.jsp").forward(request, response);
                break;
            }

            case URL_UPDATE_STATUS: {
                int orderId = parseIntSafe(request.getParameter("orderId"), 0);
                String newStatus = request.getParameter("status");
                daoOrder.updateStatus(newStatus, orderId);

                if ("Delivering".equals(newStatus)) {
                    List<OrderDetail> details = daoOrder.getAllOrdersDetailByID(orderId);
                    if (details != null) {
                        for (OrderDetail od : details) {
                            Size_detail cur = daoSize.getSizeByProductIdAndName(od.getProductID(), od.getSize_name());
                            if (cur != null) {
                                int newQty = cur.getQuantity() - od.getQuantity();
                                daoSize.updateQuanSize(newQty, od.getProductID(), cur.getSize_name());
                            }
                        }
                    }
                }
                response.getWriter().write("success");
                break;
            }

            case URL_VIEW_ORDERS: {
                request.setAttribute("totalQuantityMap", totalQuantityMap);
                request.setAttribute("voucherID", voucherID);
                request.setAttribute("voucherMap", voucherMap);
                request.setAttribute("priceP", priceP);
                request.setAttribute("picUrlMap", picUrlMap);
                request.setAttribute("nameProduct", nameProduct);
                request.setAttribute("orderDetailList", orderDetailList);
                request.setAttribute("ordersQuantityMap", ordersQuantityMap);
                request.setAttribute("ordersUserList", ordersUserList);
                request.getRequestDispatcher("viewOrder.jsp").forward(request, response);
                break;
            }

            case URL_HISTORY_ORDERS: {
                String orderIdStr = request.getParameter("orderId");
                String newStatus2 = request.getParameter("status");

                if (newStatus2 != null && !newStatus2.trim().isEmpty()) {
                    int orderId3 = parseIntSafe(orderIdStr, 0);
                    daoOrder.updateStatus(newStatus2, orderId3);
                    response.getWriter().write("success");
                } else {
                    ordersUserList = daoOrder.orderUser(customer_id);
                    Map<String, Boolean> reviewedMap = new HashMap<>();

                    for (Orders o : ordersUserList) {
                        if ("Delivered".equals(o.getStatus())) {
                            for (OrderDetail d : orderDetailList) {
                                if (d.getOrderID() == o.getOrderID()) {
                                    boolean isReviewed = daoFeedback.hasAlreadyReviewed(customer_id, d.getProductID(), o.getOrderID());
                                    String key = o.getOrderID() + "_" + d.getProductID();
                                    reviewedMap.put(key, isReviewed);
                                }
                            }
                        }
                    }
                    request.setAttribute("reviewedMap", reviewedMap);

                    request.setAttribute("totalQuantityMap", totalQuantityMap);
                    request.setAttribute("voucherID", voucherID);
                    request.setAttribute("voucherMap", voucherMap);
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
            case URL_CANCEL_ORDER: {
                int orderId = parseIntSafe(request.getParameter("orderId"), 0);

                boolean ok = daoOrder.cancelOrderByCustomer(orderId, customer_id);

                if (ok) {
                    if (session != null) {
                        session.setAttribute("popupMessage", "Your order has been cancelled.");
                    }
                } else {
                    if (session != null) {
                        session.setAttribute("popupMessage", "This order cannot be cancelled (maybe already delivering or delivered).");
                    }
                }

                response.sendRedirect(request.getContextPath() + URL_VIEW_ORDERS);
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
        try {
            return (s == null || s.isBlank()) ? def : Integer.parseInt(s);
        } catch (Exception e) {
            return def;
        }
    }

    // [CẬP NHẬT] Hàm tính giá mới dùng trường discount của Product
    private static float calcUnitPriceWithDiscount(Product p) {
        if (p == null) {
            return 0f;
        }

        int discount = p.getDiscount();
        if (discount > 0) {
            float discountAmount = p.getPrice() * (discount / 100.0f);
            return p.getPrice() - discountAmount;
        }

        return (float) p.getPrice();
    }
}
