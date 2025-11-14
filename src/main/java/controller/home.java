/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import DAO.ProductDAO;
import DAO.PromoDAO;
import entity.Promo;
import java.util.HashMap;
import java.util.Map;
import static url.ProductURL.URL_PRODUCT_DETAIL;
import entity.Product;
import entity.Product;
import jakarta.servlet.http.Cookie;
import static url.ProductURL.URL_PRODUCT_LIST;

/**
 *
 * 
 */
@WebServlet(name = "productList", urlPatterns = {URL_PRODUCT_LIST, URL_PRODUCT_DETAIL})
public class Home extends HttpServlet {

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
            out.println("<title>Servlet productList</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet productList at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    ProductDAO DAOproduct = new ProductDAO();
    PromoDAO promo = new PromoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String urlPath = request.getServletPath();
        List<Promo> promoList = promo.getAll();
        Map<Integer, Integer> promoMap = new HashMap<>();
        for (Promo promo : promoList) {
            promoMap.put(promo.getPromoID(), promo.getPromoPercent());
        }
        switch (urlPath) {
            case URL_PRODUCT_DETAIL:
                List<Product> productList2 = DAOproduct.getAll();
                int id = Integer.parseInt(request.getParameter("id"));
                Product p = DAOproduct.getProductById(id);
                request.setAttribute("promoMap", promoMap);
                request.setAttribute("p", p);
                request.getRequestDispatcher("productDetail.jsp").forward(request, response);
                break;

            case URL_PRODUCT_LIST:
                ProductDAO DAOproduct = new ProductDAO();
                List<Product> productList = DAOproduct.get8RandomProduct();
                request.setAttribute("promoMap", promoMap);
                request.setAttribute("productList", productList);
                request.getRequestDispatcher("index.jsp").forward(request, response);
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
