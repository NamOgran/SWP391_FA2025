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
import static url.FemailProductURL.URL_FEMALE_DRESS;
import static url.FemailProductURL.URL_FEMALE_PANT;
import static url.FemailProductURL.URL_FEMALE_PRODUCT;
import static url.FemailProductURL.URL_FEMALE_TSHIRT;

@WebServlet(name = "femaleProductController", urlPatterns = {URL_FEMALE_PRODUCT, URL_FEMALE_TSHIRT, URL_FEMALE_DRESS, URL_FEMALE_PANT})
public class FemaleProductController extends HttpServlet {

    ProductDAO DAOproduct = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String urlPath = request.getServletPath();

        VoucherDAO voucher2 = new VoucherDAO();
        List<Voucher> voucherList = voucher2.getAll();

        // [FIX] Map key changed to String for VoucherID
        Map<String, Integer> voucherMap = new HashMap<>();
        for (Voucher voucher : voucherList) {
            voucherMap.put(voucher.getVoucherID(), voucher.getVoucherPercent());
        }
        request.setAttribute("voucherMap", voucherMap);

        switch (urlPath) {
            case URL_FEMALE_PRODUCT:
                getFemaleProduct(request, response);
                break;
            case URL_FEMALE_TSHIRT:
                getTShirt(request, response);
                break;
            case URL_FEMALE_DRESS:
                getDress(request, response);
                break;
            case URL_FEMALE_PANT:
                getPant(request, response);
                break;
        }
    }

    private void getTShirt(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> list = DAOproduct.getFemaleProductByType("t-shirt");
        request.setAttribute("productList", list);
        request.setAttribute("pageContext", "female_tshirt");
        request.getRequestDispatcher("/productList.jsp").forward(request, response);
    }

    private void getPant(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> list = DAOproduct.getFemaleProductByType("pant");
        request.setAttribute("productList", list);
        request.setAttribute("pageContext", "female_pant");
        request.getRequestDispatcher("/productList.jsp").forward(request, response);
    }

    private void getDress(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> list = DAOproduct.getFemaleProductByType("dress");
        request.setAttribute("productList", list);
        request.setAttribute("pageContext", "female_dress");
        request.getRequestDispatcher("/productList.jsp").forward(request, response);
    }

    private void getFemaleProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Product> list = DAOproduct.getFemaleProduct();
        request.setAttribute("productList", list);
        request.setAttribute("pageContext", "all_female");
        request.getRequestDispatcher("/productList.jsp").forward(request, response);
    }
}
