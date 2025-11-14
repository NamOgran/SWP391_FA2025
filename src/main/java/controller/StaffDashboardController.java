/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import DAO.CustomerDAO;
import DAO.OrderDAO;
import DAO.ProductDAO;
import DAO.PromoDAO;
import entity.Customer;
import entity.OrderDetail;
import entity.Orders;
import entity.Product;
import entity.Promo;
import entity.Staff;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Nguyen Trong Nghia - CE190475
 */
@WebServlet(name = "StaffDashboardController", urlPatterns = {"/staff"})
public class StaffDashboardController extends HttpServlet {

    // 2. Khởi tạo tất cả DAO cần dùng
    OrderDAO orderDAO = new OrderDAO();
    ProductDAO productDAO = new ProductDAO();
    CustomerDAO customerDAO = new CustomerDAO();
    PromoDAO promoDAO = new PromoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 3. KIỂM TRA PHIÊN (Rất quan trọng)
        // Phải đảm bảo nhân viên đã đăng nhập
        HttpSession session = request.getSession(false);
        Staff staff = (session != null) ? (Staff) session.getAttribute("staff") : null;

        if (staff == null) {
            // Nếu chưa đăng nhập, đá về trang login
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return; // Dừng thực thi
        }

        // Nếu là admin, đá về trang admin
        if ("admin".equalsIgnoreCase(staff.getRole())) {
            response.sendRedirect(request.getContextPath() + "/admin");
            return; // Dừng thực thi
        }

        try {
            // 4. LẤY DỮ LIỆU CHO TAB ORDER MANAGEMENT
            // (Hàm này đã có trong OrderDAO)
            List<Orders> orderList = orderDAO.getAllOrdersSort();
            // (Hàm này đã có trong OrderDAO)
            List<OrderDetail> orderDetailList = orderDAO.getAllOrdersDetail();

            // 5. LẤY DỮ LIỆU CHO DASHBOARD
            // (Hàm này đã có trong ProductDAO và CustomerDAO)
            List<Product> productList = productDAO.getAll();
            List<Customer> customerList = customerDAO.getAll();
            Map<Integer, String> customerUsernameMap = new HashMap<>();
            for (Customer c : customerList) {
                // Tôi giả định Customer.java có hàm getCustomer_id() và getUsername()
                customerUsernameMap.put(c.getCustomer_id(), c.getUsername());
            }
            List<Promo> promoList = promoDAO.getAll(); // (Hàm này đã có trong PromoDAO)

            int numberOfOrder = orderList.size();
            int numberOfProduct = productList.size();
            int numberOfCustomer = customerList.size();

            // Tính doanh thu từ các đơn đã "Delivered"
            // (Cách này chính xác hơn là gọi DAO, vì chỉ tính đơn đã giao)
            int revenue = 0;
            for (Orders order : orderList) {
                if ("Delivered".equalsIgnoreCase(order.getStatus())) {
                    revenue += order.getTotal();
                }
            }

            // 6. LẤY DỮ LIỆU MAPS CHO JSTL (Để hiển thị chi tiết đơn hàng)
            Map<Integer, String> nameProduct = new HashMap<>();
            Map<Integer, Integer> priceProduct = new HashMap<>();
            Map<Integer, Integer> promoID = new HashMap<>();

            for (Product p : productList) {
                nameProduct.put(p.getId(), p.getName());
                priceProduct.put(p.getId(), p.getPrice());
                promoID.put(p.getId(), p.getPromoID());
            }

            // Tạo Promo Map từ promoList
            Map<Integer, Integer> promoMap = new HashMap<>();
            for (Promo p : promoList) {
                promoMap.put(p.getPromoID(), p.getPromoPercent());
            }

            // 7. GỬI TẤT CẢ DỮ LIỆU QUA REQUEST SCOPE
            // Dữ liệu cho tab Orders
            request.setAttribute("orderList", orderList);
            request.setAttribute("orderDetailList", orderDetailList);

            // Dữ liệu cho tab Dashboard
            request.setAttribute("numberOfOrder", numberOfOrder);
            request.setAttribute("numberOfProduct", numberOfProduct);
            request.setAttribute("numberOfCustomer", numberOfCustomer);
            request.setAttribute("revenue", revenue); // Doanh thu đã tính

            // Dữ liệu Maps cho chi tiết đơn hàng (Order Details)
            request.setAttribute("nameProduct", nameProduct);
            request.setAttribute("priceProduct", priceProduct);
            request.setAttribute("promoID", promoID);
            request.setAttribute("promoMap", promoMap);
            request.setAttribute("customerUsernameMap", customerUsernameMap);

            // 8. CHUYỂN TIẾP (FORWARD) SANG staff.jsp
            // Dữ liệu sẽ đi kèm request này
            request.getRequestDispatcher("staff.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            // Có thể chuyển sang một trang lỗi chung
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi khi tải dữ liệu dashboard.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu có ai đó POST lên URL này, cũng chỉ cần chạy doGet
        doGet(request, response);
    }
}
