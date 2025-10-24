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
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
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

/**
 *
 * @author Administrator
 */
@WebServlet(name = "order", urlPatterns = {INSERT_ORDERS, INSERT_ORDERS_DETAILS, URL_ORDER_LIST, URL_UPDATE_STATUS, URL_VIEW_ORDERS, URL_HISTORY_ORDERS})
public class order extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
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

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String size = request.getParameter("size");
        float total = 0;
        int totalQ = 0;
        int temp = 0;
        int quanS = 0;
        int quantityP = 0;
        String username = "";
        Cookie arr[] = request.getCookies();
        for (Cookie o : arr) {
            if (o.getName().equals("input")) {
                username = o.getValue();
            }
        }
        String urlPath = request.getServletPath();
        long currentTimeMillis = System.currentTimeMillis();
        Date currentDate = new Date(currentTimeMillis);
        String address = request.getParameter("address");
        String newaddress = request.getParameter("newaddress");
        String status = "Pending";
        String phoneNumber = request.getParameter("phoneNumber");
        String usernameStaff = request.getParameter("usernameStaff");
        String id = request.getParameter("id");
        String total1 = request.getParameter("total");
        if (total1 != null) {
            total = Float.parseFloat(total1);
        }
        DAOcart daoCart = new DAOcart();
        List<entity.cart> cartList = daoCart.getAll(username);
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
        List<orders> ordersUserList = daoOrder.orderUser(username);
        Map<Integer, String> picUrlMap = new HashMap<>();
        for (product product : productList) {
            picUrlMap.put(product.getId(), product.getPicURL());
        }
        Map<Integer, Integer> priceP = new HashMap<>();
        for (product product : productList) {
            priceP.put(product.getId(), product.getPrice());
        }
        Map<Integer, Integer> ordersQuantityMap = new HashMap<>();
        for (orderDetail orders : orderDetailList) {
            ordersQuantityMap.put(orders.getOrderID(), orders.getQuantity());
        }
        Map<Integer, Integer> totalQuantityMap = new HashMap<>();
        for (int i = 0; i < orderList.size(); i++) {
            int quanO = 0;
            for (int j = 0; j < orderDetailList.size(); j++) {
                if (orderList.get(i).getOrderID() == orderDetailList.get(j).getOrderID()) {
                    quanO = quanO + orderDetailList.get(j).getQuantity();
                }
            }
            for (orders od : orderList) {
                totalQuantityMap.put(orderList.get(i).getOrderID(), quanO);
            }
        }
        switch (urlPath) {
            case INSERT_ORDERS:
                if (newaddress.equals("")) {
                    daoOrder.insertOrder(address, currentDate, status, phoneNumber, username, usernameStaff, total);
                }
                if (!newaddress.equals("")) {
                    daoOrder.insertOrder(newaddress, currentDate, status, phoneNumber, username, usernameStaff, total);
                }
                int orderID = daoOrder.getOrderId();
                System.out.println(id);
                if (id != null) {
                    int id2 = Integer.parseInt(id);
                    for (int i = 0; i < productList.size(); i++) {
                        if (productList.get(i).getId() == id2) {
                            if (productList.get(i).getQuantity() > 0) {
                                quantityP = productList.get(i).getQuantity() - 1;
                                daoOrder.insertOrderDetail(1, size, id2, orderID);
                                response.sendRedirect("productList");
                            }
                            if (productList.get(i).getQuantity() <= 0) {
                                String nameP = productList.get(i).getName();
                                String quanP = String.valueOf(productList.get(i).getQuantity());
                                String ms = "<script>\n"
                                        + "        alert(\"Sold out! " + nameP + "Only have " + quanP + "left\")\n"
                                        + "    </script>";
                                request.setAttribute("ms", ms);
                                request.setAttribute("productList", productList);
                                request.getRequestDispatcher("product.jsp").forward(request, response);
                            }
                        }
                    }
                }
                if (id == null) {
                    for (int i = 0; i < productList.size(); i++) {
                        temp = 0;
                        totalQ = 0;
                        String sizeP = "";
                        for (int j = 0; j < cartList.size(); j++) {
                            if (productList.get(i).getId() == cartList.get(j).getProductID()) {
                                if (productList.get(i).getQuantity() >= cartList.get(j).getQuantity()) {
                                    for (int k = 0; k < sizeList.size(); k++) {
                                        if (cartList.get(j).getProductID() == sizeList.get(k).getProduct_id() && cartList.get(j).getSize_name().equals(sizeList.get(k).getSize_name())) {
                                            totalQ = totalQ + cartList.get(j).getQuantity();
                                            sizeP = sizeList.get(k).getSize_name();
                                        }
                                    }
                                    daoOrder.insertOrderDetail(totalQ, sizeP, cartList.get(j).getProductID(), orderID);
                                    daoCart.deleteCart(cartList.get(j).getProductID(), username);
                                    totalQ = 0;
                                }
                                if (productList.get(i).getQuantity() < cartList.get(j).getQuantity()) {
                                    String nameP = productList.get(i).getName();
                                    String quanP = String.valueOf(productList.get(i).getQuantity());
                                    String ms = "<script>\n"
                                            + "        alert(\"Sold out! " + nameP + "Only have " + quanP + "left\")\n"
                                            + "    </script>";
                                    request.setAttribute("ms", ms);
                                    request.setAttribute("productList", productList);
                                    request.getRequestDispatcher("product.jsp").forward(request, response);
                                    temp++;
                                }
                            }
                        }
                    }
                    if (temp == 0) {
                        response.sendRedirect("productList");
                    }
                }
                break;
            case URL_ORDER_LIST:
                int numberOfOrder = 0;
                int numberOfProduct = 0;
                int revenue = 0;
                int numberOfCustomer = 0;
                List<orders> orderListSort = daoOrder.getAllOrdersSort();
                DAO.DAOproduct DAOproduct = new DAOproduct();

                String date = request.getParameter("date");

                if (date.equals("date")) {
                    String year = request.getParameter("year");

                    int yearInt = Integer.parseInt(year);

                    numberOfOrder = DAOproduct.getNumberOfOrderByYear(yearInt);
                    numberOfProduct = DAOproduct.getNumberOfProductByYear(yearInt);
                    revenue = DAOproduct.getRevenueByYear(yearInt);
                    numberOfCustomer = DAOproduct.getNumberOfCustomerByYear(yearInt);

                    int revenue1 = DAOproduct.getRevenueByMonth(1, yearInt);
                    int revenue2 = DAOproduct.getRevenueByMonth(2, yearInt);
                    int revenue3 = DAOproduct.getRevenueByMonth(3, yearInt);
                    int revenue4 = DAOproduct.getRevenueByMonth(4, yearInt);
                    int revenue5 = DAOproduct.getRevenueByMonth(5, yearInt);
                    int revenue6 = DAOproduct.getRevenueByMonth(6, yearInt);
                    int revenue7 = DAOproduct.getRevenueByMonth(7, yearInt);
                    int revenue8 = DAOproduct.getRevenueByMonth(8, yearInt);
                    int revenue9 = DAOproduct.getRevenueByMonth(9, yearInt);
                    int revenue10 = DAOproduct.getRevenueByMonth(10, yearInt);
                    int revenue11 = DAOproduct.getRevenueByMonth(11, yearInt);
                    int revenue12 = DAOproduct.getRevenueByMonth(12, yearInt);
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

//            12 month
                } else {
                    numberOfProduct = DAOproduct.getNumberOfProduct();
                    numberOfOrder = DAOproduct.getNumberOfOrder();
                    revenue = DAOproduct.getRevenue();
                    numberOfCustomer = DAOproduct.getNumberOfCustomer();

                    int revenue1 = DAOproduct.getRevenueByMonth(1, 2024);
                    int revenue2 = DAOproduct.getRevenueByMonth(2, 2024);
                    int revenue3 = DAOproduct.getRevenueByMonth(3, 2024);
                    int revenue4 = DAOproduct.getRevenueByMonth(4, 2024);
                    int revenue5 = DAOproduct.getRevenueByMonth(5, 2024);
                    int revenue6 = DAOproduct.getRevenueByMonth(6, 2024);
                    int revenue7 = DAOproduct.getRevenueByMonth(7, 2024);
                    int revenue8 = DAOproduct.getRevenueByMonth(8, 2024);
                    int revenue9 = DAOproduct.getRevenueByMonth(9, 2024);
                    int revenue10 = DAOproduct.getRevenueByMonth(10, 2024);
                    int revenue11 = DAOproduct.getRevenueByMonth(11, 2024);
                    int revenue12 = DAOproduct.getRevenueByMonth(12, 2024);
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
                System.out.println("dfkjadsfdsn");
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                String newStatus = request.getParameter("status");
                daoOrder.updateStatus(newStatus, orderId);
                if (newStatus.equals("Delivering")) {
                    for (int i = 0; i < orderDetailList.size(); i++) {
                        if (orderId == orderDetailList.get(i).getOrderID()) {
                            for (int j = 0; j < sizeList.size(); j++) {
                                if (sizeList.get(j).getProduct_id() == orderDetailList.get(i).getProductID() && sizeList.get(j).getSize_name().equals(orderDetailList.get(i).getSize_name())) {
                                    quanS = sizeList.get(j).getQuantity() - orderDetailList.get(i).getQuantity();
                                    daoSize.updateQuanSize(quanS, orderDetailList.get(i).getProductID(), sizeList.get(j).getSize_name());
                                }
                            }
                        }
                    }
                    List<size> sizeList2 = daoSize.getAll();
                    for (int i = 0; i < productList.size(); i++) {
                        int quanP = 0;
                        for (int j = 0; j < sizeList2.size(); j++) {
                            if (sizeList2.get(j).getProduct_id() == productList.get(i).getId()) {
                                quanP = quanP + sizeList2.get(j).getQuantity();
                            }
                        }
                        daoProduct.updateQuan(quanP, productList.get(i).getId());
                    }
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
                if (orderId2 != null) {
                    orderId3 = Integer.parseInt(orderId2);
                }
                String newStatus2 = request.getParameter("status");
                if (newStatus2 != null) {
                    daoOrder.updateStatus(newStatus2, orderId3);
                    request.setAttribute("ordersUserList", ordersUserList);
                    response.getWriter().write("success");
                }
                if (newStatus2 == null) {
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
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
