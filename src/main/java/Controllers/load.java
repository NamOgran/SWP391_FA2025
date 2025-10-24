/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.DAOcart;
import DAO.DAOcustomer;
import DAO.DAOproduct;
import entity.customer;
import entity.product;
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
import static url.cartURL.URL_BUYNOW;
import static url.load.LOAD_CART;
import static url.load.LOAD_PAYMENT;

/**
 *
 * @author Administrator
 */
@WebServlet(name = "load2", urlPatterns = {LOAD_CART, LOAD_PAYMENT, URL_BUYNOW})
public class load extends HttpServlet {

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
            out.println("<title>Servlet load2</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet load2 at " + request.getContextPath() + "</h1>");
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
        String urlPath = request.getServletPath();
        String username = "";
        Cookie arr[] = request.getCookies();
        for (Cookie o : arr) {
            if (o.getName().equals("input")) {
                username = o.getValue();
            }
        }
        int quanP = 0;
        DAOcart cart = new DAOcart();
        DAOproduct productDao = new DAOproduct();
        List<product> productList = productDao.getAll();
        List<entity.cart> list3 = cart.getAll(username);
        Map<Integer, String> picUrlMap = new HashMap<>();
        for (product product : productList) {
            picUrlMap.put(product.getId(), product.getPicURL());
        }
        Map<Integer, String> nameProduct = new HashMap<>();
        for (product product : productList) {
            nameProduct.put(product.getId(), product.getName());
        }
        int sum = 0;
        for (int i = 0; i < list3.size(); i++) {
            sum = sum + list3.get(i).getPrice();
            quanP++;
        }
        DAOcustomer daoCustomer = new DAOcustomer();
        customer c = daoCustomer.getCustomerByEmailOrUsername(username);
        String address = null;
        if(c != null){
            address = c.getAddress();
        }
        request.setAttribute("address", address);
        request.setAttribute("username", username);
        request.setAttribute("size", size);
        request.setAttribute("nameProduct", nameProduct);
        request.setAttribute("quanP", quanP);
        request.setAttribute("picUrlMap", picUrlMap);
        
        
        
        
        
        request.setAttribute("sum", sum);
        request.setAttribute("cartList", list3);
        System.out.println(size + "load");
        switch (urlPath) {
            case LOAD_CART:
                response.getWriter().write(String.valueOf(sum));
                request.getRequestDispatcher("cart.jsp").forward(request, response);                
                break;
            case LOAD_PAYMENT:
                if(sum != 0){
                    request.getRequestDispatcher("payment.jsp").forward(request, response);
                }else{                  
                    request.getRequestDispatcher("cart.jsp").forward(request, response);
                }
                
                break;
            case URL_BUYNOW:
                if (!username.equals("")) {
                    String pic = request.getParameter("picURL");
                    String name = request.getParameter("name");
                    float price = Float.parseFloat(request.getParameter("price"));
                    int quantity = Integer.parseInt(request.getParameter("quantity"));
                    int id = Integer.parseInt(request.getParameter("id"));
                    request.setAttribute("pic", pic);
                    request.setAttribute("name", name);
                    request.setAttribute("price", price);
                    request.setAttribute("quantity", quantity);
                    request.setAttribute("id", id);
                    System.out.println(name + " " + price + " " + id);
                    request.getRequestDispatcher("buynow.jsp").forward(request, response);
                } else {
                    response.sendRedirect("http://localhost:8080/Project_SWP391_Group4/profile");
                }

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
