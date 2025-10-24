/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.DAOcart;
import DAO.DAOproduct;
import DAO.DAOpromo;
import DAO.DAOsize;
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
import static url.cartURL.URL_CART_DECREASE;
import static url.cartURL.URL_CART_DELETE;
import static url.cartURL.URL_CART_INCREASE;
import static url.cartURL.URL_CART_INSERT;
import static url.cartURL.URL_CART_LIST;
import static url.cartURL.URL_PAYMENT;

/**
 *
 * @author Administrator
 */
@WebServlet(name = "cart", urlPatterns = {URL_CART_INSERT, URL_CART_LIST, URL_CART_INCREASE, URL_CART_DECREASE, URL_CART_DELETE, URL_PAYMENT})
public class cart extends HttpServlet {

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
            out.println("<title>Servlet cart</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet cart at " + request.getContextPath() + "</h1>");
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
        int sum = 0;
        int temp = 0;
        DAOproduct product = new DAOproduct();
        DAOcart cart = new DAOcart();
        DAOpromo promo = new DAOpromo();
        String username = "";
        Cookie arr[] = request.getCookies();
        for (Cookie o : arr) {
            if (o.getName().equals("input")) {
                username = o.getValue();
            }
        }
        String size = request.getParameter("size");
        System.out.println(size + "cart");
        int id = 0;
        float price = 0;
        int quantity = 0;
        String urlPath = request.getServletPath();
        String ms = "<script>\n"
                + "        alert(\"Sold out!\")\n"
                + "    </script>";
        String idParam = request.getParameter("id");
        String priceParam = request.getParameter("price");
        String quantityParam = request.getParameter("quantity");
        if (idParam != null) {
            id = Integer.parseInt(idParam);
        }
        if (priceParam != null) {
            price = Float.parseFloat(priceParam);
        }
        if (quantityParam != null) {
            quantity = Integer.parseInt(quantityParam);
        }
        int totalQ = quantity;
        List<product> list = product.getAll();
        List<promo> promoList = promo.getAll();
        List<entity.cart> list2 = cart.getAll(username);
        DAOsize daoSize = new DAOsize();
        List<size> sizeList = daoSize.getAll();
        Map<Integer, Integer> promoMap = new HashMap<>();
        for (promo promoM : promoList) {
            promoMap.put(promoM.getPromoID(), promoM.getPromoPercent());
        }
        float price2 = 0;
        System.out.println(id);
        System.out.println(username);
        switch (urlPath) {
            case URL_CART_INSERT:
                for (int i = 0; i < list.size(); i++) {
                    if (id == (list.get(i).getId())) {
                        price2 = quantity * price;
                    }
                }
                for (int i = 0; i < list2.size(); i++) {
                    if (id == (list2.get(i).getProductID()) && username.equals(list2.get(i).getUsername()) && size.equals(list2.get(i).getSize_name())) {
                        quantity = list2.get(i).getQuantity() + quantity;
                        for (int j = 0; j < sizeList.size(); j++) {
                            if (id == (sizeList.get(j).getProduct_id()) && sizeList.get(j).getSize_name().equals(size) && quantity < (sizeList.get(j).getQuantity())) {
                                price2 = quantity * price;
                                cart.updateCart(username, id, quantity, price2, size);
                                temp++;
                            }
                        }

                    }
                }

                if (temp == 0) {
                    for (int j = 0; j < sizeList.size(); j++) {
                        if (id == (sizeList.get(j).getProduct_id()) && sizeList.get(j).getSize_name().equals(size) && quantity <= (sizeList.get(j).getQuantity())) {
                            cart.insertCart(quantity, price2, username, id, size);
                            temp++;
                        }
                        if (quantity > (sizeList.get(j).getQuantity()) && id == (sizeList.get(j).getProduct_id()) && sizeList.get(j).getSize_name().equals(size)) {
                            product p = product.getProductById(id);
                            request.setAttribute("ms", ms);
                            request.setAttribute("p", p);
                            request.setAttribute("promoMap", promoMap);
                            request.getRequestDispatcher("productDetail.jsp").forward(request, response);

                        }
                    }
                }

                if (temp != 0 && !username.equals("")) {
                    response.sendRedirect("loadCart?size=" + size);
                }
                if (username.equals("")) {
                    response.sendRedirect("http://localhost:8080/Project_SWP391_Group4/profile");
                }

                break;
            case URL_CART_INCREASE:

                for (int i = 0; i < list2.size(); i++) {
                    if (id == (list2.get(i).getProductID()) && username.equals(list2.get(i).getUsername()) && size.equals(list2.get(i).getSize_name())) {

                        for (int j = 0; j < sizeList.size(); j++) {
                            if (id == (sizeList.get(j).getProduct_id()) && sizeList.get(j).getSize_name().equals(size) && quantity <= (sizeList.get(j).getQuantity())) {
                                for (int k = 0; k < list.size(); k++) {
                                    if (list.get(k).getId() == id) {
                                        price2 = quantity * (list.get(k).getPrice() - ((list.get(k).getPrice() * promoList.get(list.get(k).getPromoID() - 1).getPromoPercent()) / 100));

                                    }
                                }
                                cart.updateCart(username, id, quantity, price2, size);

                            }
                            if (quantity > (sizeList.get(j).getQuantity()) && id == (sizeList.get(j).getProduct_id()) && sizeList.get(j).getSize_name().equals(size)) {
                                product p = product.getProductById(id);
                                request.setAttribute("ms", ms);
                                request.setAttribute("p", p);
                                temp++;
                                request.setAttribute("temp", temp);

                            }
                        }
                    }
                }

                List<entity.cart> cartUpdateIncrease = cart.getAll(username);
                for (int i = 0; i < cartUpdateIncrease.size(); i++) {
                    sum = sum + cartUpdateIncrease.get(i).getPrice();
                    
                }
                System.out.println(sum);
                System.out.println(temp);
                response.getWriter().write(price2 + "," + sum + "," + temp);

                break;

            case URL_CART_DECREASE:
                for (int i = 0; i < list2.size(); i++) {
                    if (id == (list2.get(i).getProductID()) && username.equals(list2.get(i).getUsername()) && size.equals(list2.get(i).getSize_name())) {
                        for (int j = 0; j < list.size(); j++) {
                            if (id == (list.get(j).getId()) && quantity <= (list.get(j).getQuantity())) {
                                price2 = quantity * (list.get(j).getPrice() - ((list.get(j).getPrice() * promoList.get(list.get(j).getPromoID() - 1).getPromoPercent()) / 100));
                                cart.updateCart(username, id, quantity, price2, size);
                            }
                            if (quantity > (list.get(j).getQuantity()) && id == (list.get(j).getId())) {
                                product p = product.getProductById(id);
                                request.setAttribute("ms", ms);
                                request.setAttribute("p", p);
                                request.getRequestDispatcher("productDetail.jsp").forward(request, response);
                            }
                        }

                    }
                }

                List<entity.cart> cartUpdateDecrease = cart.getAll(username);
                for (int i = 0; i < cartUpdateDecrease.size(); i++) {
                    sum = sum + cartUpdateDecrease.get(i).getPrice();
                }
                System.out.println(sum);

                response.getWriter().write(price2 + "," + sum);
                break;
            case URL_CART_DELETE:
                int quanP = 0;
                cart.deleteCartBySize(id, username, size);
                List<entity.cart> cartUpdateDelete = cart.getAll(username);
                for (int i = 0; i < cartUpdateDelete.size(); i++) {
                    sum = sum + cartUpdateDelete.get(i).getPrice();
                    quanP++;
                }
                System.out.println(quanP);
                System.out.println(sum);
                response.getWriter().write(price2 + "," + sum + "," + quanP);

                break;
            case URL_PAYMENT:
                response.sendRedirect("loadPayment?size=" + size);
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
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response
    )
            throws ServletException,
             IOException {
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
