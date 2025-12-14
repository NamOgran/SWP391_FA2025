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
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "sortProduct", urlPatterns = {"/sortProduct"})
public class SortProduct extends HttpServlet {

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
        if (sort1 == null) sort1 = "";
        if (sort2 == null) sort2 = "";
        if (priceRange == null) priceRange = "";

        // 2. Gọi DAO lấy danh sách sản phẩm (Lọc sơ bộ)
        ProductDAO dao = new ProductDAO();
        List<Product> productList = dao.getPublicProducts(context, sort1, sort2, priceRange, categoryFilter);

        // 3. Lấy thông tin Khuyến mãi (Voucher) để tính giá thật
        VoucherDAO voucherDAO = new VoucherDAO();
        List<Voucher> voucherListFull = voucherDAO.getAll();
        
        // Tạo Map để tra cứu nhanh: VoucherID -> % Giảm giá
        Map<Integer, Integer> voucherMap = new HashMap<>();
        for (Voucher voucher : voucherListFull) {
            voucherMap.put(voucher.getVoucherID(), voucher.getVoucherPercent());
        }

        // 4. LOGIC SẮP XẾP THEO GIÁ ĐÃ GIẢM (QUAN TRỌNG)
        if ("Increase".equals(sort2) || "Decrease".equals(sort2)) {
            
            Collections.sort(productList, new Comparator<Product>() {
                @Override
                public int compare(Product p1, Product p2) {
                    // Tính giá thực tế sản phẩm 1
                    int discountPercent1 = voucherMap.getOrDefault(p1.getVoucherID(), 0);
                    double finalPrice1 = p1.getPrice() * (1.0 - (discountPercent1 / 100.0));

                    // Tính giá thực tế sản phẩm 2
                    int discountPercent2 = voucherMap.getOrDefault(p2.getVoucherID(), 0);
                    double finalPrice2 = p2.getPrice() * (1.0 - (discountPercent2 / 100.0));

                    // So sánh 2 giá thực tế
                    return Double.compare(finalPrice1, finalPrice2);
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
        request.setAttribute("voucherMap", voucherMap);

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