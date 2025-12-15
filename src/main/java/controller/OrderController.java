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

        List<Orders> orderList = daoOrder.getAllOrders();
        List<OrderDetail> orderDetailList = daoOrder.getAllOrdersDetail();
        List<Product> productList = daoProduct.getAll();
        List<Orders> ordersUserList = daoOrder.orderUser(customer_id);

        Map<Integer, String> nameProduct = new HashMap<>();
        for (Product p : productList) {
            nameProduct.put(p.getId(), p.getName());
        }

        List<Voucher> voucherList = daoVoucher.getAll();
        Map<String, Integer> voucherMap = new HashMap<>();
        for (Voucher pr : voucherList) {
            voucherMap.put(pr.getVoucherID(), pr.getVoucherPercent());
        }

        Map<Integer, Integer> priceProduct = new HashMap<>();
        Map<Integer, String> voucherID = new HashMap<>();
        Map<Integer, String> picUrlMap = new HashMap<>();
        Map<Integer, Integer> priceP = new HashMap<>();
        
        for (Product p : productList) {
            priceProduct.put(p.getId(), p.getPrice());
            voucherID.put(p.getId(), String.valueOf(p.getVoucherID()));
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

            case INSERT_ORDERS: {
                String size = request.getParameter("size");
                String address = request.getParameter("address");
                String newaddress = request.getParameter("newaddress");
                String phoneNumber = request.getParameter("phoneNumber");
                String status = "Pending";
                Date currentDate = new Date(System.currentTimeMillis());

                int staffRaw = parseIntSafe(request.getParameter("staff_id"), 0);
                Integer staffId = (staffRaw > 0) ? Integer.valueOf(staffRaw) : null;

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
                            session.setAttribute("popupMessage", "This product is out of size_detail!");
                        }
                        response.sendRedirect("productList");
                        return;
                    }

                    Size_detail s = daoSize.getSizeByProductIdAndName(productId, size);
                    if (s == null || s.getQuantity() <= 0 || s.getQuantity() < quantity) {
                        if (session != null) {
                            session.setAttribute("popupMessage", "This size is out of size_detail!");
                        }
                        response.sendRedirect("productList");
                        return;
                    }

                    float unitPriceF = calcUnitPriceWithVoucherSafe(daoProduct, daoVoucher, productId);
                    int unitPrice = Math.max(0, Math.round(unitPriceF));
                    int subtotal = unitPrice * quantity;

                    String voucherIdFromReq = request.getParameter("voucherId");
                    int voucherPctFromReq = parseIntSafe(request.getParameter("voucherPct"), 0);
                    
                    int voucherPercent = (voucherIdFromReq != null && !voucherIdFromReq.isBlank())
                            ? findVoucherPercentById(daoVoucher, voucherIdFromReq)
                            : Math.max(0, voucherPctFromReq);

                    int discount = Math.round(subtotal * (voucherPercent / 100.0f));
                    int grand = Math.max(0, subtotal - discount);

                    String addr = (newaddress != null && !newaddress.trim().isEmpty()) ? newaddress : address;

                    int orderID = daoOrder.insertOrder(addr, currentDate, status, phoneNumber, customer_id, staffId, grand);

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

                List<entity.Cart> cartList = daoCart.getAll(customer_id);
                if (cartList == null || cartList.isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/error.jsp?message=Cart is empty");
                    return;
                }

                StringBuilder issue = new StringBuilder();
                boolean hasIssue = false;

                for (entity.Cart c : cartList) {
                    Product p = daoProduct.getProductById(c.getProductID());
                    Size_detail sz = daoSize.getSizeByProductIdAndName(c.getProductID(), c.getSize_name());
                    String pname = (p != null) ? p.getName() : ("ID " + c.getProductID());

                    if (p == null || !p.isIs_active()) {
                        hasIssue = true;
                        issue.append("Product '")
                                .append(pname)
                                .append("' is no longer available for sale.\\n");
                        continue;
                    }

                    if (sz == null || sz.getQuantity() <= 0 || c.getQuantity() > sz.getQuantity()) {
                        hasIssue = true;
                        int remain = (sz != null) ? sz.getQuantity() : 0;
                        issue.append("Sold out! '")
                                .append(pname)
                                .append("' (size ")
                                .append(c.getSize_name())
                                .append(") only ")
                                .append(remain)
                                .append(" left.\\n");
                    }
                }

                if (hasIssue) {
                    request.setAttribute("popupMessage", issue.toString());
                    request.setAttribute("productList", productList);
                    request.setAttribute("cartList", cartList);
                    request.getRequestDispatcher("cart.jsp").forward(request, response);
                    return;
                }

                int subtotal = daoCart.getCartTotal(customer_id);
                int voucherPercent = 0;
                Object sessVoucher = (session != null) ? session.getAttribute("voucherPercent") : null;
                if (sessVoucher instanceof Integer) {
                    voucherPercent = (Integer) sessVoucher;
                }

                int discount = Math.round(subtotal * (voucherPercent / 100.0f));
                int finalTotal = Math.max(0, subtotal - discount);

                String addr = (newaddress != null && !newaddress.trim().isEmpty()) ? newaddress : address;

                int orderID = daoOrder.insertOrder(addr, currentDate, status, phoneNumber, customer_id, staffId, finalTotal);

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
                    session.setAttribute("popupMessage", "Order placed successfully! Thank you for shopping at GIO Shop!");
                }
                response.sendRedirect("productList");
                return;
            }

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

    private static int findVoucherPercentById(VoucherDAO daoVoucher, String voucherId) {
        List<Voucher> vouchers = daoVoucher.getAll();
        if (vouchers == null) {
            return 0;
        }
        for (Voucher pr : vouchers) {
            if (pr != null && pr.getVoucherID() != null && pr.getVoucherID().equals(voucherId)) {
                return Math.max(0, pr.getVoucherPercent());
            }
        }
        return 0;
    }

    private static float calcUnitPriceWithVoucherSafe(ProductDAO productDAO, VoucherDAO voucherDAO, int productId) {
        Product p = productDAO.getProductById(productId);
        if (p == null) {
            return 0f;
        }
        String vID = String.valueOf(p.getVoucherID());
        int percent = findVoucherPercentById(voucherDAO, vID);
        return p.getPrice() - (p.getPrice() * (percent / 100.0f));
    }
}