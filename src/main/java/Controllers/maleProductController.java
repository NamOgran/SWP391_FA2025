/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.DAOproduct;
import DAO.DAOpromo;
import entity.product;
import entity.promo;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static url.maleProductURL.URL_MALE_PRODUCT;
import static url.maleProductURL.URL_MALE_PANT;
import static url.maleProductURL.URL_MALE_SHORT;
import static url.maleProductURL.URL_MALE_TSHIRT;

/**
 *
 * @author thinh
 */
@WebServlet(name = "maleProductController", urlPatterns = {URL_MALE_PRODUCT, URL_MALE_TSHIRT, URL_MALE_SHORT, URL_MALE_PANT})
public class maleProductController extends HttpServlet {

    DAOproduct DAOproduct = new DAOproduct();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String urlPath = request.getServletPath();
        DAOpromo promo2 = new DAOpromo();
        List<promo> promoList = promo2.getAll();
        Map<Integer, Integer> promoMap = new HashMap<>();
        for (promo promo : promoList) {
            promoMap.put(promo.getPromoID(), promo.getPromoPercent());
        }
        request.setAttribute("promoMap", promoMap);
        switch (urlPath) {
            case URL_MALE_PRODUCT:
                getMaleProduct(request, response);
                break;
            case URL_MALE_TSHIRT:
                getTShirt(request, response);
                break;
            case URL_MALE_SHORT:
                getShort(request, response);
                break;
            case URL_MALE_PANT:
                getPant(request,response);
                break;

        }
    }

    private void getTShirt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<product> list = DAOproduct.getMaleProductByType("t-shirt");
        request.setAttribute("productList", list);
        request.setAttribute("path", "../.");
        request.getRequestDispatcher("/productList.jsp").forward(request, response);
    }

    private void getPant(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<product> list = DAOproduct.getMaleProductByType("pant");
        request.setAttribute("productList", list);
        request.setAttribute("path", "../.");

        request.getRequestDispatcher("/productList.jsp").forward(request, response);
    }

    private void getShort(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<product> list = DAOproduct.getMaleProductByType("short");
        request.setAttribute("productList", list);
        request.setAttribute("path", "../.");

        request.getRequestDispatcher("/productList.jsp").forward(request, response);
    }

    private void getMaleProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<product> list = DAOproduct.getMaleProduct();
        request.setAttribute("productList", list);
        request.setAttribute("path", ".");
        request.getRequestDispatcher("/productList.jsp").forward(request, response);
    }

}
