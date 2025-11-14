package controller;

import DAO.ProductDAO;
import DAO.PromoDAO; // <-- SỬA LỖI: Thêm import
import entity.Product;
import entity.Promo; // <-- SỬA LỖI: Thêm import
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.HashMap; // <-- SỬA LỖI: Thêm import
import java.util.List;
import java.util.Map; // <-- SỬA LỖI: Thêm import

/**
 *
 * @author LENOVO
 */
@WebServlet(name = "sortProduct", urlPatterns = {"/sortProduct"})
public class SortProduct extends HttpServlet {

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
            out.println("<title>Servlet sortProduct</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet sortProduct at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String sortId = request.getParameter("sortID");

        DAO.ProductDAO dao = new ProductDAO();
        List<Product> productList = null; // Khai báo list ở ngoài

        // === SỬA LỖI: BẮT ĐẦU THÊM PROMO MAP ===
        // 1. Tạo DAO khuyến mãi
        DAO.PromoDAO promoDAO = new DAO.PromoDAO();
        // 2. Lấy tất cả khuyến mãi
        List<Promo> promoListFull = promoDAO.getAll();
        // 3. Tạo một Map để JSP dễ sử dụng
        Map<Integer, Integer> promoMap = new HashMap<>();
        for (Promo promo : promoListFull) {
            promoMap.put(promo.getPromoID(), promo.getPromoPercent());
        }
        // === SỬA LỖI: KẾT THÚC THÊM PROMO MAP ===

        // 4. Lấy danh sách sản phẩm đã sắp xếp (giữ nguyên logic cũ)
        if ("Increase".equals(sortId)) {
            productList = dao.sortIncrease();
        } else if ("Decrease".equals(sortId)) {
            productList = dao.sortDecrease();
        } else if ("BestSeller".equals(sortId)) {
            productList = dao.sortBestSeller();
        } else if ("New".equals(sortId)) {
            productList = dao.sortNew();
        } else {
            // Trường hợp mặc định nếu sortId không khớp
            productList = dao.sortNew();
        }

        // === SỬA LỖI: Đặt thuộc tính VÀ forward MỘT LẦN ở cuối ===
        request.setAttribute("productList", productList);
        request.setAttribute("promoMap", promoMap); // <-- GỬI PROMO MAP SANG JSP
        request.getRequestDispatcher("productList.jsp").forward(request, response);
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