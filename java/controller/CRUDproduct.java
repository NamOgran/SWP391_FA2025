/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.DAOcategory;
import DAO.DAOproduct;
import DAO.DAOpromo;
import entity.category;
import entity.product;
import entity.promo;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.NumberFormat;
import java.util.List;
import java.util.Locale;
import java.util.Random;
import static url.productURL.DELETE_PRODUCT;
import static url.productURL.UPDATE_JSP_PRODUCT;
import static url.productURL.ADD_PRODUCT;
import static url.productURL.UPDATE_PRODUCT;
import static url.productURL.SEARCH_PRODUCT;
import static url.productURL.SEARCH_PRODUCT_AJAX;

/**
 *
 * @author LENOVO
 */
@WebServlet({
    "/admin",
    UPDATE_JSP_PRODUCT,
    DELETE_PRODUCT,
    UPDATE_PRODUCT,
    ADD_PRODUCT,
    "/toggleProduct",   // ✅ thêm dòng này
    SEARCH_PRODUCT,
    SEARCH_PRODUCT_AJAX
})

public class CRUDproduct extends HttpServlet {

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
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CRUDproduct</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CRUDproduct at " + request.getContextPath() + "</h1>");
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

        String urlPath = request.getServletPath();

        switch (urlPath) {

            // ---------------- ADD PRODUCT ----------------
            case ADD_PRODUCT: {
                DAOpromo daoPromo = new DAOpromo();
                DAOcategory daoCate = new DAOcategory();

                List<promo> promoList = daoPromo.getAll();
                List<category> cateList = daoCate.getAll();

                request.setAttribute("promoList", promoList);
                request.setAttribute("cateList", cateList);

                request.getRequestDispatcher("addProduct.jsp").forward(request, response);
                break;
            }

            // ---------------- ADMIN PAGE ----------------
            case "/admin":
                DAOproduct daoAdmin = new DAOproduct();
                String sort = request.getParameter("sort");
                String search = request.getParameter("search");

                List<product> list;

                if (search != null && !search.trim().isEmpty()) {
                    // tìm kiếm theo tên
                    list = daoAdmin.search("%" + search + "%");
                } else if ("asc".equalsIgnoreCase(sort)) {
                    // sắp xếp tăng dần
                    list = daoAdmin.sortIncrease();
                } else if ("desc".equalsIgnoreCase(sort)) {
                    // sắp xếp giảm dần
                    list = daoAdmin.sortDecrease();
                } else {
                    // mặc định load tất cả
                    list = daoAdmin.getAll();
                }

                request.setAttribute("list", list);
                request.getRequestDispatcher("admin.jsp").forward(request, response);
                break;

            // ---------------- UPDATE PRODUCT PAGE ----------------
            case UPDATE_JSP_PRODUCT: {
                int id = Integer.parseInt(request.getParameter("id"));

                DAOproduct daoProduct = new DAOproduct();
                DAOpromo daoPromoU = new DAOpromo();
                DAOcategory daoCateU = new DAOcategory();

                product prod = daoProduct.getProductById(id);
                List<promo> promoListUpdate = daoPromoU.getAll();
                List<category> cateListUpdate = daoCateU.getAll();

                request.setAttribute("product", prod);
                request.setAttribute("promoList", promoListUpdate);
                request.setAttribute("cateList", cateListUpdate);

                request.getRequestDispatcher("updateProduct.jsp").forward(request, response);
                break;
            }

            // ---------------- UPDATE PRODUCT ACTION ----------------
            case UPDATE_PRODUCT: {
                String quantity = request.getParameter("quantity");
                String productId = request.getParameter("id");
                String categoryId = request.getParameter("category");
                String promoId = request.getParameter("promo");
                String name = request.getParameter("name");
                String price = request.getParameter("price");
                String pic = request.getParameter("pic");
                String des = request.getParameter("des");

                try {
                    DAOproduct daoUpdate = new DAOproduct();
                    int idInt = Integer.parseInt(productId);
                    int quanInt = Integer.parseInt(quantity);
                    int priceInt = Integer.parseInt(price);
                    int categoryInt = Integer.parseInt(categoryId);
                    int promoInt = Integer.parseInt(promoId);

                    product p = new product(idInt, quanInt, priceInt, categoryInt, promoInt, name, des, pic);

                    boolean success = daoUpdate.update(p);
                    if (success) {
                        response.sendRedirect(request.getContextPath() + "/admin");
                    } else {
                        response.getWriter().println("<h3 style='color:red;'>❌ Failed to update product!</h3>");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    response.getWriter().println("<h3 style='color:red;'>⚠️ Error updating product: "
                            + e.getMessage() + "</h3>");
                }
                break;
            }

            // ---------------- DELETE PRODUCT ----------------
            case DELETE_PRODUCT: {
                int id = Integer.parseInt(request.getParameter("id"));
                DAOproduct daoDel = new DAOproduct();
                daoDel.delete(id);
                response.sendRedirect(request.getContextPath() + "/admin");
                break;
            }

            // ---------------- SEARCH PRODUCT ----------------
            case SEARCH_PRODUCT: {
                DAOproduct daoSearch = new DAOproduct();
                String name = request.getParameter("search");
                List<product> productList = daoSearch.search("%" + name + "%");
                request.setAttribute("productList", productList);
                request.getRequestDispatcher("productList.jsp").forward(request, response);
                break;
            }

            // ---------------- SEARCH AJAX ----------------
            case SEARCH_PRODUCT_AJAX: {
                DAOproduct daoAjax = new DAOproduct();
                String name = request.getParameter("txt");
                List<product> productList = daoAjax.search("%" + name + "%");

                PrintWriter out = response.getWriter();
                for (product o : productList) {
                    NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                    String formatted = nf.format(o.getPrice());
                    out.println("<div class=\"search-product\">"
                            + "<div class=\"search-info\">"
                            + "<div class=\"title\">"
                            + "<a href=\"/Project_SWP391_Group4/productDetail?id=" + o.getId() + "\">"
                            + o.getName() + "</a>"
                            + "<p>" + formatted + " VND</p>"
                            + "</div>"
                            + "<div class=\"search-img\">"
                            + "<a href=\"#\">"
                            + "<img src=\"" + o.getPicURL() + "\" alt=\"img\">"
                            + "</a>"
                            + "</div>"
                            + "</div><hr>");
                }
                break;
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
        String urlPath = request.getServletPath();

        switch (urlPath) {
            case ADD_PRODUCT:
                String quantity = request.getParameter("quantity");
                String categoryId = request.getParameter("category");
                String promoId = request.getParameter("promo");
                String name = request.getParameter("name");
                String price = request.getParameter("price");
                String pic = request.getParameter("pic");
                String des = request.getParameter("des");

                DAOproduct daoAdd = new DAOproduct();

                int quanInt = safeParseInt(quantity, 0);
                int categoryInt = safeParseInt(categoryId, 0);
                int promoInt = safeParseInt(promoId, 0);
                int priceInt = safeParseInt(price, 0);

                product newP = new product(quanInt, priceInt, categoryInt, promoInt, name, des, pic);

                if (daoAdd.insert(newP)) {
                    response.sendRedirect(request.getContextPath() + "/admin");
                } else {
                    response.getWriter().println("<h3 style='color:red;'>❌ Failed to add product!</h3>");
                }
                break;

            case UPDATE_PRODUCT:
                String productId = request.getParameter("id");
                quantity = request.getParameter("quantity");
                categoryId = request.getParameter("category");
                promoId = request.getParameter("promo");
                name = request.getParameter("name");
                price = request.getParameter("price");
                pic = request.getParameter("pic");
                des = request.getParameter("des");

                try {
                    DAOproduct daoUpdate = new DAOproduct();
                    int idInt = Integer.parseInt(productId);
                    int quanUp = Integer.parseInt(quantity);
                    int priceUp = Integer.parseInt(price);
                    int cateUp = Integer.parseInt(categoryId);
                    int promoUp = Integer.parseInt(promoId);

                    product p = new product(idInt, quanUp, priceUp, cateUp, promoUp, name, des, pic);

                    boolean success = daoUpdate.update(p);
                    if (success) {
                        response.sendRedirect(request.getContextPath() + "/admin");
                    } else {
                        response.getWriter().println("<h3 style='color:red;'>❌ Failed to update product!</h3>");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    response.getWriter().println("<h3 style='color:red;'>⚠️ Error updating product: " + e.getMessage() + "</h3>");
                }
                break;

            default:
                processRequest(request, response);
        }
    }

    private int safeParseInt(String value, int defaultValue) {
        try {
            if (value == null || value.trim().isEmpty()) {
                return defaultValue;
            }
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
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
