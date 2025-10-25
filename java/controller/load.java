/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.DAOcart;
import DAO.DAOcustomer;
import DAO.DAOproduct;
import entity.customer;
import entity.product;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie; // Vẫn giữ lại nếu bạn dùng Cookie để ghi nhớ đăng nhập
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; // <-- THÊM DÒNG NÀY
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import static url.cartURL.URL_BUYNOW;
import static url.load.LOAD_CART;
import static url.load.LOAD_PAYMENT;

@WebServlet(name = "load2", urlPatterns = {LOAD_CART, LOAD_PAYMENT, URL_BUYNOW})
public class load extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
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
        customer loggedInCustomer = (customer) session.getAttribute("acc");
        
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
            if(urlPath.equals(URL_BUYNOW)){
                 // Cho phép BuyNow cho khách vãng lai nhưng sẽ không có thông tin địa chỉ sẵn
                 // hoặc redirect để yêu cầu login
                 // response.sendRedirect(request.getContextPath() + "/login.jsp");
                 // return;
            } else {
                 response.sendRedirect(request.getContextPath() + "/login.jsp");
                 return;
            }
        }
        
        // DAOcart của bạn có vẻ đang dùng username (String) cho getAll
        // DAOcart cart = new DAOcart();
        // List<entity.cart> list3 = cart.getAll(username);
        // => Cần cập nhật DAOcart để dùng customer_id (int) cho các thao tác giỏ hàng
        // => HOẶC đảm bảo rằng usernameForCart là duy nhất và chính xác.
        
        DAOcart cart = new DAOcart();
        // THAY ĐỔI: Giả sử DAOcart.getAll() nhận customer_id (int)
        // Nếu DAOcart.getAll() vẫn dùng username (String), thì hãy đảm bảo usernameForCart là duy nhất
        // và phù hợp với cách bạn lưu giỏ hàng.
        List<entity.cart> cartList = null;
        if(customerIdForCart != -1){ // Chỉ lấy giỏ hàng nếu có customerId hợp lệ
            cartList = cart.getAll(customerIdForCart); // Cần cập nhật DAOcart.getAll()
        } else {
            cartList = new ArrayList<>(); // Giỏ hàng rỗng nếu không có khách hàng đăng nhập
        }
        

        DAOproduct productDao = new DAOproduct();
        List<product> productList = productDao.getAll();
        
        Map<Integer, String> picUrlMap = new HashMap<>();
        for (product product : productList) {
            picUrlMap.put(product.getId(), product.getPicURL());
        }
        Map<Integer, String> nameProduct = new HashMap<>();
        for (product product : productList) {
            nameProduct.put(product.getId(), product.getName());
        }
        
        int sum = 0;
        int quanP = 0; // Số lượng sản phẩm khác nhau trong giỏ hàng
        if(cartList != null){
            for (entity.cart cItem : cartList) {
                sum += cItem.getPrice() * cItem.getQuantity(); // Tổng tiền cần tính đúng từ giá và số lượng
                quanP++; // Mỗi item trong giỏ là một sản phẩm khác nhau
            }
        }
        
        // Không cần DAOcustomer.getCustomerByEmailOrUsername(username) nữa nếu dùng session
        // customer c = loggedInCustomer; // Đã có từ session
        
        request.setAttribute("address", customerAddress);
        request.setAttribute("username", usernameForCart); // Có thể cần cho mục đích hiển thị
        request.setAttribute("size", request.getParameter("size")); // Lấy size nếu có (từ BuyNow)
        request.setAttribute("nameProduct", nameProduct);
        request.setAttribute("quanP", quanP);
        request.setAttribute("picUrlMap", picUrlMap);
        request.setAttribute("sum", sum);
        request.setAttribute("cartList", cartList);
        
        System.out.println(request.getParameter("size") + "load"); // Để debug

        switch (urlPath) {
            case LOAD_CART:
                response.getWriter().write(String.valueOf(sum)); // Có lẽ bạn muốn AJAX trả về tổng tiền
                request.getRequestDispatcher("cart.jsp").forward(request, response);              
                break;
            case LOAD_PAYMENT:
                if (sum != 0) {
                    request.getRequestDispatcher("payment.jsp").forward(request, response);
                } else {             
                    // Nếu giỏ hàng trống, quay lại trang giỏ hàng
                    response.sendRedirect(request.getContextPath() + "/cart.jsp"); // Redirect để tránh lỗi forward khi giỏ trống
                }
                break;
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
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}