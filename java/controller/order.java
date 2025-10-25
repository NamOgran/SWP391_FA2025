/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.DAOcart;
import DAO.DAOorder;
import DAO.DAOproduct;
import DAO.DAOpromo;
import DAO.DAOsize;
import entity.orderDetail;
import entity.orders;
import entity.product;
import entity.promo;
import entity.size;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import static url.orderURL.INSERT_ORDERS;
import static url.orderURL.INSERT_ORDERS_DETAILS;
import static url.orderURL.URL_HISTORY_ORDERS;
import static url.orderURL.URL_ORDER_LIST;
import static url.orderURL.URL_UPDATE_STATUS;
import static url.orderURL.URL_VIEW_ORDERS;

@WebServlet(name = "order", urlPatterns = {INSERT_ORDERS, INSERT_ORDERS_DETAILS, URL_ORDER_LIST, URL_UPDATE_STATUS, URL_VIEW_ORDERS, URL_HISTORY_ORDERS})
public class order extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet order</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet order at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        entity.customer acc = (entity.customer) session.getAttribute("acc");

        if (acc == null) {
            System.out.println("DEBUG (Order): User not logged in, redirecting to login page.");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int customer_id = acc.getCustomer_id();
        String usernameCustomer = acc.getUsername(); // Giữ lại username của khách hàng nếu cần cho mục đích hiển thị hoặc log

        System.out.println("DEBUG (Order): User logged in, customer_id: " + customer_id + ", usernameCustomer: " + usernameCustomer);

        String size = request.getParameter("size");
        float total = 0;
        int totalQ = 0;
        int temp = 0;
        int quanS = 0;
        int quantityP = 0;

        String urlPath = request.getServletPath();
        long currentTimeMillis = System.currentTimeMillis();
        Date currentDate = new Date(currentTimeMillis);
        String address = request.getParameter("address");
        String newaddress = request.getParameter("newaddress");
        String status = "Pending";
        String phoneNumber = request.getParameter("phoneNumber");
        
        // SỬA: Thay usernameStaff bằng staff_id. Giá trị mặc định là 0 nếu không có nhân viên nào được gán rõ ràng.
        // Trong một ứng dụng thực tế, bạn sẽ lấy staff_id từ session của người dùng đăng nhập với vai trò Staff.
        int staff_id = 0; // Mặc định là 0 hoặc một giá trị STAFF_ID_DEFAULT nào đó
        String staffIdParam = request.getParameter("staff_id"); // Nếu có tham số staff_id được truyền vào
        if (staffIdParam != null && !staffIdParam.trim().isEmpty()) {
            try {
                staff_id = Integer.parseInt(staffIdParam);
            } catch (NumberFormatException e) {
                System.err.println("DEBUG ERROR (Order): Invalid staff_id parameter: " + staffIdParam);
                // Xử lý lỗi hoặc giữ nguyên staff_id = 0
            }
        }
        
        String total1 = request.getParameter("total");
        if (total1 != null) {
            total = Float.parseFloat(total1);
        }

        DAOcart daoCart = new DAOcart();
        List<entity.cart> cartList = daoCart.getAll(customer_id);
        DAOorder daoOrder = new DAOorder();
        List<orders> orderList = daoOrder.getAllOrders();
        List<orderDetail> orderDetailList = daoOrder.getAllOrdersDetail();
        DAOproduct daoProduct = new DAOproduct();
        List<product> productList = daoProduct.getAll();
        DAOsize daoSize = new DAOsize();
        List<size> sizeList = daoSize.getAll();

        Map<Integer, String> nameProduct = new HashMap<>();
        for (product product : productList) {
            nameProduct.put(product.getId(), product.getName());
        }
        DAOpromo daoPromo = new DAOpromo();
        List<promo> promoList = daoPromo.getAll();
        Map<Integer, Integer> promoMap = new HashMap<>();
        for (promo promo : promoList) {
            promoMap.put(promo.getPromoID(), promo.getPromoPercent());
        }
        Map<Integer, Integer> priceProduct = new HashMap<>();
        for (product product : productList) {
            priceProduct.put(product.getId(), product.getPrice());
        }
        Map<Integer, Integer> promoID = new HashMap<>();
        for (product product : productList) {
            promoID.put(product.getId(), product.getPromoID());
        }
        
        List<orders> ordersUserList = daoOrder.orderUser(customer_id); 
        
        Map<Integer, String> picUrlMap = new HashMap<>();
        for (product product : productList) {
            picUrlMap.put(product.getId(), product.getPicURL());
        }
        Map<Integer, Integer> priceP = new HashMap<>();
        for (product product : productList) {
            priceP.put(product.getId(), product.getPrice());
        }
        Map<Integer, Integer> ordersQuantityMap = new HashMap<>();
        for (orderDetail od : orderDetailList) {
            ordersQuantityMap.put(od.getOrderID(), od.getQuantity());
        }
        Map<Integer, Integer> totalQuantityMap = new HashMap<>();
        for (orders od_item : orderList) {
            int quanO = 0;
            for (orderDetail od_detail : orderDetailList) {
                if (od_item.getOrderID() == od_detail.getOrderID()) {
                    quanO += od_detail.getQuantity();
                }
            }
            totalQuantityMap.put(od_item.getOrderID(), quanO);
        }
        
        switch (urlPath) {
            case INSERT_ORDERS:
                if (newaddress == null || newaddress.trim().isEmpty()) {
                    daoOrder.insertOrder(address, currentDate, status, phoneNumber, customer_id, staff_id, total); // <-- SỬA: Dùng staff_id (int)
                } else {
                    daoOrder.insertOrder(newaddress, currentDate, status, phoneNumber, customer_id, staff_id, total); // <-- SỬA: Dùng staff_id (int)
                }
                
                int orderID = daoOrder.getOrderId();
                System.out.println("DEBUG (Order): New Order ID: " + orderID);
                
                String idParam = request.getParameter("id");
                if (idParam != null && !idParam.trim().isEmpty()) { // Mua sản phẩm đơn lẻ
                    int id2 = Integer.parseInt(idParam);
                    product pCheck = daoProduct.getProductById(id2); 
                    if (pCheck != null) {
                        entity.size sCheck = daoSize.getSizeByProductIdAndName(id2, size);
                        if (sCheck != null) {
                            if (sCheck.getQuantity() > 0) {
                                daoOrder.insertOrderDetail(1, size, id2, orderID);
                                System.out.println("DEBUG (Order): Inserted single order detail for ProductID: " + id2 + ", Size: " + size);
                                response.sendRedirect("productList");
                                return;
                            } else {
                                String nameP = pCheck.getName();
                                String quanP = String.valueOf(sCheck.getQuantity());
                                String ms = "<script>alert(\"Sold out! " + nameP + " only have " + quanP + " left\")</script>";
                                request.setAttribute("ms", ms);
                                request.setAttribute("productList", productList);
                                request.getRequestDispatcher("product.jsp").forward(request, response);
                                return;
                            }
                        } else {
                            System.err.println("DEBUG ERROR (Order): Size '" + size + "' not found for ProductID: " + id2);
                            response.sendRedirect(request.getContextPath() + "/error.jsp?message=Size not found for product");
                            return;
                        }
                    } else {
                        System.err.println("DEBUG ERROR (Order): Product not found for ID: " + id2);
                        response.sendRedirect(request.getContextPath() + "/error.jsp?message=Product not found");
                        return;
                    }
                } 
                
                // Nếu không phải mua sản phẩm đơn lẻ (tức là mua từ giỏ hàng)
                if (cartList != null && !cartList.isEmpty()) {
                    System.out.println("DEBUG (Order): Processing cart items for order insertion.");
                    boolean hasStockIssue = false;
                    StringBuilder stockIssueMessage = new StringBuilder();

                    for (entity.cart c : cartList) {
                        entity.size productSize = daoSize.getSizeByProductIdAndName(c.getProductID(), c.getSize_name());
                        
                        if (productSize != null) {
                            if (c.getQuantity() <= productSize.getQuantity()) {
                                daoOrder.insertOrderDetail(c.getQuantity(), c.getSize_name(), c.getProductID(), orderID);
                                System.out.println("DEBUG (Order): Inserted order detail for ProductID: " + c.getProductID() + ", Size: " + c.getSize_name() + ", Quantity: " + c.getQuantity());
                                daoCart.deleteCartBySize(c.getProductID(), customer_id, c.getSize_name());
                                System.out.println("DEBUG (Order): Deleted cart item for ProductID: " + c.getProductID() + ", CustomerID: " + customer_id + ", Size: " + c.getSize_name());
                            } else {
                                product p = daoProduct.getProductById(c.getProductID());
                                String productName = (p != null) ? p.getName() : "Unknown Product";
                                stockIssueMessage.append("Sold out! Product '").append(productName)
                                                     .append("' (Size: ").append(c.getSize_name())
                                                     .append(") only has ").append(productSize.getQuantity())
                                                     .append(" left, but you requested ").append(c.getQuantity()).append(".\\n");
                                hasStockIssue = true;
                            }
                        } else {
                            stockIssueMessage.append("Error: Size '").append(c.getSize_name())
                                             .append("' for Product ID ").append(c.getProductID())
                                             .append(" not found. Please review your cart. \\n");
                            hasStockIssue = true;
                        }
                    }

                    if (hasStockIssue) {
                        request.setAttribute("ms", "<script>alert(\"" + stockIssueMessage.toString() + "\")</script>");
                        request.setAttribute("productList", productList);
                        request.getRequestDispatcher("cart.jsp").forward(request, response);
                        return;
                    }
                }
                
                System.out.println("DEBUG (Order): Redirecting to productList after order insertion from cart.");
                response.sendRedirect("productList");
                break;

            case URL_ORDER_LIST:
                int numberOfOrder = 0;
                int numberOfProduct = 0;
                int revenue = 0;
                int numberOfCustomer = 0;
                List<orders> orderListSort = daoOrder.getAllOrdersSort();

                String date = request.getParameter("date");

                if (date != null && date.equals("date")) {
                    String yearParam = request.getParameter("year");
                    int yearInt = 0;
                    if (yearParam != null && !yearParam.trim().isEmpty()) {
                        yearInt = Integer.parseInt(yearParam);
                    } else {
                        yearInt = java.time.Year.now().getValue();
                    }

                    numberOfOrder = daoProduct.getNumberOfOrderByYear(yearInt);
                    numberOfProduct = daoProduct.getNumberOfProductByYear(yearInt);
                    revenue = daoProduct.getRevenueByYear(yearInt);
                    numberOfCustomer = daoProduct.getNumberOfCustomerByYear(yearInt);

                    int revenue1 = daoProduct.getRevenueByMonth(1, yearInt);
                    int revenue2 = daoProduct.getRevenueByMonth(2, yearInt);
                    int revenue3 = daoProduct.getRevenueByMonth(3, yearInt);
                    int revenue4 = daoProduct.getRevenueByMonth(4, yearInt);
                    int revenue5 = daoProduct.getRevenueByMonth(5, yearInt);
                    int revenue6 = daoProduct.getRevenueByMonth(6, yearInt);
                    int revenue7 = daoProduct.getRevenueByMonth(7, yearInt);
                    int revenue8 = daoProduct.getRevenueByMonth(8, yearInt);
                    int revenue9 = daoProduct.getRevenueByMonth(9, yearInt);
                    int revenue10 = daoProduct.getRevenueByMonth(10, yearInt);
                    int revenue11 = daoProduct.getRevenueByMonth(11, yearInt);
                    int revenue12 = daoProduct.getRevenueByMonth(12, yearInt);
                    int quarter1 = revenue1 + revenue2 + revenue3;
                    int quarter2 = revenue4 + revenue5 + revenue6;
                    int quarter3 = revenue7 + revenue8 + revenue9;
                    int quarter4 = revenue10 + revenue11 + revenue12;
                    request.setAttribute("revenue1", revenue1);
                    request.setAttribute("revenue2", revenue2);
                    request.setAttribute("revenue3", revenue3);
                    request.setAttribute("revenue4", revenue4);
                    request.setAttribute("revenue5", revenue5);
                    request.setAttribute("revenue6", revenue6);
                    request.setAttribute("revenue7", revenue7);
                    request.setAttribute("revenue8", revenue8);
                    request.setAttribute("revenue9", revenue9);
                    request.setAttribute("revenue10", revenue10);
                    request.setAttribute("revenue11", revenue11);
                    request.setAttribute("revenue12", revenue12);

                    request.setAttribute("quarter1", quarter1);
                    request.setAttribute("quarter2", quarter2);
                    request.setAttribute("quarter3", quarter3);
                    request.setAttribute("quarter4", quarter4);

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

                    int revenue1 = daoProduct.getRevenueByMonth(1, currentYear);
                    int revenue2 = daoProduct.getRevenueByMonth(2, currentYear);
                    int revenue3 = daoProduct.getRevenueByMonth(3, currentYear);
                    int revenue4 = daoProduct.getRevenueByMonth(4, currentYear);
                    int revenue5 = daoProduct.getRevenueByMonth(5, currentYear);
                    int revenue6 = daoProduct.getRevenueByMonth(6, currentYear);
                    int revenue7 = daoProduct.getRevenueByMonth(7, currentYear);
                    int revenue8 = daoProduct.getRevenueByMonth(8, currentYear);
                    int revenue9 = daoProduct.getRevenueByMonth(9, currentYear);
                    int revenue10 = daoProduct.getRevenueByMonth(10, currentYear);
                    int revenue11 = daoProduct.getRevenueByMonth(11, currentYear);
                    int revenue12 = daoProduct.getRevenueByMonth(12, currentYear);
                    int quarter1 = revenue1 + revenue2 + revenue3;
                    int quarter2 = revenue4 + revenue5 + revenue6;
                    int quarter3 = revenue7 + revenue8 + revenue9;
                    int quarter4 = revenue10 + revenue11 + revenue12;

                    request.setAttribute("revenue1", revenue1);
                    request.setAttribute("revenue2", revenue2);
                    request.setAttribute("revenue3", revenue3);
                    request.setAttribute("revenue4", revenue4);
                    request.setAttribute("revenue5", revenue5);
                    request.setAttribute("revenue6", revenue6);
                    request.setAttribute("revenue7", revenue7);
                    request.setAttribute("revenue8", revenue8);
                    request.setAttribute("revenue9", revenue9);
                    request.setAttribute("revenue10", revenue10);
                    request.setAttribute("revenue11", revenue11);
                    request.setAttribute("revenue12", revenue12);
                    request.setAttribute("quarter1", quarter1);
                    request.setAttribute("quarter2", quarter2);
                    request.setAttribute("quarter3", quarter3);
                    request.setAttribute("quarter4", quarter4);

                    request.setAttribute("numberOfOrder", numberOfOrder);
                    request.setAttribute("numberOfProduct", numberOfProduct);
                    request.setAttribute("revenue", revenue);
                    request.setAttribute("numberOfCustomer", numberOfCustomer);
                }
                request.setAttribute("orderDetailList", orderDetailList);
                request.setAttribute("orderList", orderListSort);
                request.setAttribute("nameProduct", nameProduct);
                request.setAttribute("priceProduct", priceProduct);
                request.setAttribute("promoMap", promoMap);
                request.setAttribute("promoID", promoID);

                request.getRequestDispatcher("staff.jsp").forward(request, response);
                break;

            case URL_UPDATE_STATUS:
                System.out.println("DEBUG (Order): Handling URL_UPDATE_STATUS");
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                String newStatus = request.getParameter("status");
                daoOrder.updateStatus(newStatus, orderId);
                
                if ("Delivering".equals(newStatus)) {
                    List<orderDetail> detailsForThisOrder = daoOrder.getAllOrdersDetailByID(orderId);
                    if (detailsForThisOrder != null) {
                        for (orderDetail od : detailsForThisOrder) {
                            entity.size currentSize = daoSize.getSizeByProductIdAndName(od.getProductID(), od.getSize_name());
                            if (currentSize != null) {
                                quanS = currentSize.getQuantity() - od.getQuantity();
                                daoSize.updateQuanSize(quanS, od.getProductID(), currentSize.getSize_name());
                                System.out.println("DEBUG (Order): Updated size quantity for ProductID: " + od.getProductID() + ", Size: " + od.getSize_name() + ", New Quantity: " + quanS);
                            } else {
                                System.err.println("DEBUG ERROR (Order): Size not found for ProductID: " + od.getProductID() + ", Size: " + od.getSize_name() + " during status update.");
                            }
                        }
                    }
                    
                    List<product> allProducts = daoProduct.getAll();
                    for (product p : allProducts) {
                        int totalQuanForProduct = daoSize.getTotalQuantityByProductId(p.getId());
                        daoProduct.updateQuan(totalQuanForProduct, p.getId());
                        System.out.println("DEBUG (Order): Updated product total quantity for ProductID: " + p.getId() + ", New Total Quantity: " + totalQuanForProduct);
                    }
                    response.getWriter().write("success");
                } else {
                    response.getWriter().write("success");
                }
                break;
                
            case URL_VIEW_ORDERS:
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
                
            case URL_HISTORY_ORDERS:
                int orderId3 = 0;
                String orderId2 = request.getParameter("orderId");
                if (orderId2 != null && !orderId2.trim().isEmpty()) {
                    orderId3 = Integer.parseInt(orderId2);
                }
                String newStatus2 = request.getParameter("status");
                if (newStatus2 != null && !newStatus2.trim().isEmpty()) {
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
            default:
                System.err.println("DEBUG ERROR (Order): Unknown URL path: " + urlPath);
                response.sendRedirect(request.getContextPath() + "/error.jsp?message=Unknown order operation");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}