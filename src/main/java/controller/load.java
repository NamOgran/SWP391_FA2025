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
import jakarta.servlet.http.HttpSession; // <-- THÊM DÒNG NÀY
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import static url.CartURL.URL_BUYNOW;
import static url.Load.LOAD_CART;
import static url.Load.LOAD_PAYMENT;

@WebServlet(name = "load2", urlPatterns = {LOAD_CART, LOAD_PAYMENT, URL_BUYNOW})
public class Load extends HttpServlet {

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
            // Nếu chưa đăng nhập và không phải URL_BUYNOW (URL_BUYNOW sẽ được xử lý khác)
            // Redirect đến trang login hoặc hiển thị thông báo
            response.sendRedirect(request.getContextPath() + "/login.jsp"); // Hoặc trang login của bạn
            return;
        }

        // Khai báo biến username và customer_id nếu cần
        String usernameForCart = "";
        int customerIdForCart = -1; // -1 hoặc một giá trị không hợp lệ
        String customerAddress = "";

        if (loggedInCustomer != null) {
            usernameForCart = loggedInCustomer.getUsername(); // Hoặc email, tùy bạn dùng gì cho giỏ hàng
            customerIdForCart = loggedInCustomer.getCustomer_id();
            customerAddress = loggedInCustomer.getAddress();
        } else {
            // Trường hợp URL_BUYNOW có thể truy cập mà không cần đăng nhập
            // hoặc bạn cần xử lý trường hợp không có session (ví dụ: dùng cookie để tự động đăng nhập)
            // Trong trường hợp này, bạn có thể cân nhắc gửi họ đến trang đăng nhập nếu BuyNow yêu cầu login.
            // Hoặc nếu bạn muốn BuyNow hoạt động cho khách vãng lai, cần thêm logic.
            if (urlPath.equals(URL_BUYNOW)) {
                // Cho phép BuyNow cho khách vãng lai nhưng sẽ không có thông tin địa chỉ sẵn
                // hoặc redirect để yêu cầu login
                // response.sendRedirect(request.getContextPath() + "/login.jsp");
                // return;
            } else {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
        }

        // CartDAO của bạn có vẻ đang dùng username (String) cho getAll
        // CartDAO Cart = new CartDAO();
        // List<entity.Cart> list3 = Cart.getAll(username);
        // => Cần cập nhật CartDAO để dùng customer_id (int) cho các thao tác giỏ hàng
        // => HOẶC đảm bảo rằng usernameForCart là duy nhất và chính xác.
        CartDAO cart = new CartDAO();
        // THAY ĐỔI: Giả sử CartDAO.getAll() nhận customer_id (int)
        // Nếu CartDAO.getAll() vẫn dùng username (String), thì hãy đảm bảo usernameForCart là duy nhất
        // và phù hợp với cách bạn lưu giỏ hàng.
        List<entity.Cart> cartList = null;
        if (customerIdForCart != -1) { // Chỉ lấy giỏ hàng nếu có customerId hợp lệ
            cartList = cart.getAll(customerIdForCart); // Cần cập nhật CartDAO.getAll()
        } else {
            cartList = new ArrayList<>(); // Giỏ hàng rỗng nếu không có khách hàng đăng nhập
        }

        ProductDAO productDao = new ProductDAO();
        VoucherDAO voucherDao = new VoucherDAO();   // NEW
        List<Product> productList = productDao.getAll();

        Map<Integer, String> picUrlMap = new HashMap<>();
        Map<Integer, String> nameProduct = new HashMap<>();
        Map<Integer, Integer> priceP = new HashMap<>();
        Map<Integer, List<String>> productSizeMap = new HashMap<>();

        for (Product product : productList) {
            int id = product.getId();

            // Ảnh + tên như cũ
            picUrlMap.put(id, product.getPicURL());
            nameProduct.put(id, product.getName());

            // ===== GIÁ BÁN HIỆN TẠI (SAU VOUCHER, NẾU CÓ) =====
            int unitPrice = product.getPrice();     // mặc định = giá gốc
            int voucherId = product.getVoucherID();

            if (voucherId > 0) {
                Integer percentObj = voucherDao.getPercentById(voucherId);
                if (percentObj != null && percentObj > 0) {
                    int percent = percentObj;
                    float originalPrice = (float) product.getPrice();
                    float discountedPrice = originalPrice - (originalPrice * percent / 100.0f);
                    unitPrice = Math.round(discountedPrice);
                }
            }

            priceP.put(id, unitPrice);  // LƯU GIÁ SAU VOUCHER
        }

        int sum = 0;
        int quanP = 0; // Số lượng sản phẩm khác nhau trong giỏ hàng
        if (cartList != null) {
            for (entity.Cart cItem : cartList) {
                sum += cItem.getPrice() * cItem.getQuantity(); // Tổng tiền cần tính đúng từ giá và số lượng
                quanP++; // Mỗi item trong giỏ là một sản phẩm khác nhau
            }
        }
        Size_detailDAO sizeDetailDao = new Size_detailDAO();
        List<Size_detail> sizeDetails = sizeDetailDao.getAll();

        for (Size_detail sd : sizeDetails) {
            if (sd.getQuantity() <= 0) {
                continue;   // bỏ size hết hàng
            }
            int pid = sd.getProduct_id();
            productSizeMap
                    .computeIfAbsent(pid, k -> new java.util.ArrayList<>())
                    .add(sd.getSize_name());
        }

        // Không cần CustomerDAO.getCustomerByEmailOrUsername(username) nữa nếu dùng session
        // Customer c = loggedInCustomer; // Đã có từ session
        request.setAttribute("address", customerAddress);
        request.setAttribute("username", usernameForCart); // Có thể cần cho mục đích hiển thị
        request.setAttribute("size", request.getParameter("size")); // Lấy size nếu có (từ BuyNow)
        request.setAttribute("nameProduct", nameProduct);
        request.setAttribute("priceP", priceP);
        request.setAttribute("quanP", quanP);
        request.setAttribute("picUrlMap", picUrlMap);
        request.setAttribute("sum", sum);
        request.setAttribute("cartList", cartList);
        request.setAttribute("productSizeMap", productSizeMap);

        System.out.println(request.getParameter("size") + "load"); // Để debug

        switch (urlPath) {
            case LOAD_CART:
                request.getRequestDispatcher("cart.jsp").forward(request, response);
                break;
            case LOAD_PAYMENT: {
                if (cartList != null && !cartList.isEmpty()) {
                    request.getRequestDispatcher("payment.jsp").forward(request, response);
                } else {
                    // Không có item -> quay lại loadCart
                    response.sendRedirect(request.getContextPath() + "/loadCart");
                }
                break;
            }

            case URL_BUYNOW:
                if (loggedInCustomer != null) { // Chỉ cho phép mua ngay nếu đã đăng nhập
                    String pic = request.getParameter("picURL");
                    String name = request.getParameter("name");
                    float price = Float.parseFloat(request.getParameter("price"));
                    int quantity = Integer.parseInt(request.getParameter("quantity"));
                    int id = Integer.parseInt(request.getParameter("id"));
                    String size = request.getParameter("size"); // Lấy size từ BuyNow

                    request.setAttribute("pic", pic);
                    request.setAttribute("name", name);
                    request.setAttribute("price", price);
                    request.setAttribute("quantity", quantity);
                    request.setAttribute("id", id);
                    request.setAttribute("size", size); // Pass size to buynow.jsp

                    System.out.println(name + " " + price + " " + id + " " + size);
                    request.getRequestDispatcher("buynow.jsp").forward(request, response);
                } else {
                    // Nếu chưa đăng nhập, chuyển hướng đến trang login
                    response.sendRedirect(request.getContextPath() + "/login.jsp");
                }
                break;
            default:
                // Xử lý các trường hợp URL không xác định
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
