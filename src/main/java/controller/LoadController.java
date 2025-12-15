/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.CartDAO;
import DAO.ProductDAO;
import DAO.VoucherDAO;
import DAO.Size_detailDAO;
import entity.Size_detail;
import entity.Customer;
import entity.Product;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import static url.CartURL.URL_BUYNOW;
import static url.Load.LOAD_CART;
import static url.Load.LOAD_PAYMENT;

@WebServlet(name = "load2", urlPatterns = {LOAD_CART, LOAD_PAYMENT, URL_BUYNOW})
public class LoadController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet load2</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet load2 at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String urlPath = request.getServletPath();

        // Lấy thông tin khách hàng từ SESSION (ưu tiên)
        HttpSession session = request.getSession();
        Customer loggedInCustomer = (Customer) session.getAttribute("acc");

        // Kiểm tra xem người dùng đã đăng nhập chưa
        if (loggedInCustomer == null && !urlPath.equals(URL_BUYNOW)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Khai báo biến username và customer_id nếu cần
        String usernameForCart = "";
        int customerIdForCart = -1;
        String customerAddress = "";

        if (loggedInCustomer != null) {
            usernameForCart = loggedInCustomer.getUsername();
            customerIdForCart = loggedInCustomer.getCustomer_id();
            customerAddress = loggedInCustomer.getAddress();
        } else {
            if (urlPath.equals(URL_BUYNOW)) {
                // Cho phép logic BuyNow chạy tiếp (check login bên dưới switch case nếu cần)
            } else {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
        }

        CartDAO cart = new CartDAO();
        List<entity.Cart> cartList = null;
        if (customerIdForCart != -1) {
            cartList = cart.getAll(customerIdForCart);
        } else {
            cartList = new ArrayList<>();
        }

        ProductDAO productDao = new ProductDAO();
        VoucherDAO voucherDao = new VoucherDAO();
        List<Product> productList = productDao.getAll();

        Map<Integer, String> picUrlMap = new HashMap<>();
        Map<Integer, String> nameProduct = new HashMap<>();
        Map<Integer, Integer> priceP = new HashMap<>();
        Map<Integer, List<String>> productSizeMap = new HashMap<>();
        Map<Integer, Boolean> activeP = new HashMap<>();

        for (Product product : productList) {
            int id = product.getId();

            picUrlMap.put(id, product.getPicURL());
            nameProduct.put(id, product.getName());
            activeP.put(id, product.isIs_active());

            // ===== GIÁ BÁN HIỆN TẠI (SAU VOUCHER, NẾU CÓ) =====
            int unitPrice = product.getPrice();
            
            // [UPDATED] Xử lý Voucher ID dạng String
            // String.valueOf để an toàn nếu Product vẫn trả về int, hoặc convert int sang String
            String voucherId = String.valueOf(product.getVoucherID());

            // Kiểm tra voucherId hợp lệ (không null, không rỗng, không phải "0")
            if (voucherId != null && !voucherId.equals("0") && !voucherId.trim().isEmpty()) {
                // Truyền String vào DAO
                Integer percentObj = voucherDao.getPercentById(voucherId);
                
                if (percentObj != null && percentObj > 0) {
                    int percent = percentObj;
                    float originalPrice = (float) product.getPrice();
                    float discountedPrice = originalPrice - (originalPrice * percent / 100.0f);
                    unitPrice = Math.round(discountedPrice);
                }
            }

            priceP.put(id, unitPrice); // LƯU GIÁ SAU VOUCHER
        }

        int sum = 0;
        int quanP = 0;
        if (cartList != null) {
            for (entity.Cart cItem : cartList) {
                sum += cItem.getPrice() * cItem.getQuantity();
                quanP++;
            }
        }
        Size_detailDAO sizeDetailDao = new Size_detailDAO();
        List<Size_detail> sizeDetails = sizeDetailDao.getAll();

        for (Size_detail sd : sizeDetails) {
            if (sd.getQuantity() <= 0) {
                continue;
            }
            int pid = sd.getProduct_id();
            productSizeMap
                    .computeIfAbsent(pid, k -> new java.util.ArrayList<>())
                    .add(sd.getSize_name());
        }

        request.setAttribute("address", customerAddress);
        request.setAttribute("username", usernameForCart);
        request.setAttribute("size", request.getParameter("size"));
        request.setAttribute("nameProduct", nameProduct);
        request.setAttribute("priceP", priceP);
        request.setAttribute("quanP", quanP);
        request.setAttribute("picUrlMap", picUrlMap);
        request.setAttribute("sum", sum);
        request.setAttribute("cartList", cartList);
        request.setAttribute("productSizeMap", productSizeMap);
        request.setAttribute("activeP", activeP);

        System.out.println(request.getParameter("size") + "load");

        switch (urlPath) {
            case LOAD_CART:
                request.getRequestDispatcher("cart.jsp").forward(request, response);
                break;
            case LOAD_PAYMENT: {
                if (cartList != null && !cartList.isEmpty()) {
                    request.getRequestDispatcher("payment.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/loadCart");
                }
                break;
            }

            case URL_BUYNOW:
                if (loggedInCustomer != null) {
                    String pic = request.getParameter("picURL");
                    String name = request.getParameter("name");
                    float price = Float.parseFloat(request.getParameter("price"));
                    int quantity = Integer.parseInt(request.getParameter("quantity"));
                    int id = Integer.parseInt(request.getParameter("id"));
                    String size = request.getParameter("size");

                    request.setAttribute("pic", pic);
                    request.setAttribute("name", name);
                    request.setAttribute("price", price);
                    request.setAttribute("quantity", quantity);
                    request.setAttribute("id", id);
                    request.setAttribute("size", size);

                    System.out.println(name + " " + price + " " + id + " " + size);
                    request.getRequestDispatcher("buynow.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/login.jsp");
                }
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "URL not recognized");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}