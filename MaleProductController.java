package controller;

import DAO.ProductDAO;
import DAO.VoucherDAO;
import entity.Product;
import entity.Voucher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static url.MaleProductURL.URL_MALE_PRODUCT;
import static url.MaleProductURL.URL_MALE_PANT;
import static url.MaleProductURL.URL_MALE_SHORT;
import static url.MaleProductURL.URL_MALE_TSHIRT;

@WebServlet(name = "maleProductController", urlPatterns = {URL_MALE_PRODUCT, URL_MALE_TSHIRT, URL_MALE_SHORT, URL_MALE_PANT})
public class MaleProductController extends HttpServlet {

    ProductDAO DAOproduct = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String urlPath = request.getServletPath();

        // Load Vouchers
        VoucherDAO voucher2 = new VoucherDAO();
        List<Voucher> voucherList = voucher2.getAll();

        // [FIX] Map key changed to String for VoucherID
        Map<String, Integer> voucherMap = new HashMap<>();
        for (Voucher voucher : voucherList) {
            voucherMap.put(voucher.getVoucherID(), voucher.getVoucherPercent());
        }
        request.setAttribute("voucherMap", voucherMap);

        // Switch based on URL
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
                getPant(request, response);
                break;
        }
    }

    private void getTShirt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> list = DAOproduct.getMaleProductByType("t-shirt");
        request.setAttribute("productList", list);
        // Important: Set context for Breadcrumbs and Sorting
        request.setAttribute("pageContext", "male_tshirt");
        request.getRequestDispatcher("/productList.jsp").forward(request, response);
    }

    private void getPant(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> list = DAOproduct.getMaleProductByType("pant");
        request.setAttribute("productList", list);
        request.setAttribute("pageContext", "male_pant");
        request.getRequestDispatcher("/productList.jsp").forward(request, response);
    }

    private void getShort(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> list = DAOproduct.getMaleProductByType("short");
        request.setAttribute("productList", list);
        request.setAttribute("pageContext", "male_short");
        request.getRequestDispatcher("/productList.jsp").forward(request, response);
    }

    private void getMaleProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> list = DAOproduct.getMaleProduct();
        request.setAttribute("productList", list);
        request.setAttribute("pageContext", "all_male");
        request.getRequestDispatcher("/productList.jsp").forward(request, response);
    }
}
