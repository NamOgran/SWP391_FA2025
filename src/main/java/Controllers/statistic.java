/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author LENOVO
 */
@WebServlet(name = "statistic", urlPatterns = {"/statistic"})
public class statistic extends HttpServlet {

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
            out.println("<title>Servlet statistic</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet statistic at " + request.getContextPath() + "</h1>");
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

        int numberOfOrder = 0;
        int numberOfProduct = 0;
        int revenue = 0;
        int numberOfCustomer = 0;
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
//        
        request.getRequestDispatcher("statistic.jsp").forward(request, response);
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
        String username = "";
        Cookie arr[] = request.getCookies();
        for (Cookie o : arr) {
            if (o.getName().equals("input")) {
                username = o.getValue();
            }
        }
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
