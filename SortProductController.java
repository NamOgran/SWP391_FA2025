package controller;

import DAO.ProductDAO;
import entity.Product;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

@WebServlet(name = "sortProduct", urlPatterns = {"/sortProduct"})
public class SortProductController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Lấy tham số từ JSP
        String sort1 = request.getParameter("sort1"); // New / BestSeller
        String sort2 = request.getParameter("sort2"); // Increase / Decrease (Giá) hoặc name_asc...
        String context = request.getParameter("context"); // male_tshirt, female_pant...
        String priceRange = request.getParameter("priceRange");
        String categoryFilter = request.getParameter("categoryFilter");

        // Xử lý null
        if (sort1 == null) {
            sort1 = "";
        }
        if (sort2 == null) {
            sort2 = "";
        }
        if (priceRange == null) {
            priceRange = "";
        }

        // 2. Gọi DAO lấy danh sách sản phẩm (Lọc sơ bộ)
        ProductDAO dao = new ProductDAO();
        List<Product> productList = dao.getPublicProducts(context, sort1, sort2, priceRange, categoryFilter);

        // 3. [LOẠI BỎ] Không cần VoucherDAO hay voucherMap nữa
        // 4. LOGIC SẮP XẾP THEO GIÁ ĐÃ GIẢM
        if ("Increase".equals(sort2) || "Decrease".equals(sort2)) {

            Collections.sort(productList, new Comparator<Product>() {
                @Override
                public int compare(Product p1, Product p2) {
                    // Tính giá thực tế sản phẩm 1 dùng int discount
                    double price1 = p1.getPrice() * (1.0 - (p1.getDiscount() / 100.0));

                    // Tính giá thực tế sản phẩm 2 dùng int discount
                    double price2 = p2.getPrice() * (1.0 - (p2.getDiscount() / 100.0));

                    // So sánh 2 giá thực tế
                    return Double.compare(price1, price2);
                }
            });

            // Nếu user chọn Giá giảm dần (Decrease) -> Đảo ngược danh sách
            if ("Decrease".equals(sort2)) {
                Collections.reverse(productList);
            }
        }

        // 5. Gửi dữ liệu về JSP
        request.setAttribute("pageContext", context); // Để giữ Breadcrumb đúng
        request.setAttribute("productList", productList);

        // [CẬP NHẬT] Không gửi voucherMap nữa vì JSP nên dùng p.discount
        // Giữ trạng thái filter trên UI
        request.setAttribute("param.sort1", sort1);
        request.setAttribute("param.sort2", sort2);
        request.setAttribute("param.priceRange", priceRange);

        request.getRequestDispatcher("/productList.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
