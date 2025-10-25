/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.DAOcart;
import DAO.DAOproduct;
import DAO.DAOpromo;
import DAO.DAOsize;
import entity.product;
import entity.promo;
import entity.size;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import static url.cartURL.URL_CART_DECREASE;
import static url.cartURL.URL_CART_DELETE;
import static url.cartURL.URL_CART_INCREASE;
import static url.cartURL.URL_CART_INSERT;
import static url.cartURL.URL_CART_LIST;
import static url.cartURL.URL_PAYMENT;

@WebServlet(name = "cart", urlPatterns = {URL_CART_INSERT, URL_CART_LIST, URL_CART_INCREASE, URL_CART_DECREASE, URL_CART_DELETE, URL_PAYMENT})
public class cart extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet cart</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet cart at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        entity.customer acc = (entity.customer) session.getAttribute("acc");

        if (acc == null) {
            System.out.println("DEBUG: User not logged in, redirecting to login page.");
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // SỬA: Lấy customer_id từ đối tượng customer trong session
        int customer_id = acc.getCustomer_id(); // <-- Đảm bảo entity.customer có getCustomer_id()
        System.out.println("DEBUG: User logged in, customer_id: " + customer_id);

        int sum = 0;
        int temp = 0;
        DAOproduct productDAO = new DAOproduct();
        DAOcart cartDAO = new DAOcart();
        DAOpromo promoDAO = new DAOpromo();

        String size = request.getParameter("size");
        System.out.println("DEBUG: size parameter: " + size);

        int id = 0;
        float price = 0;
        int quantity = 0;
        String urlPath = request.getServletPath();
        String ms = "<script>alert(\"Sold out!\")</script>"; // Có thể cải thiện thông báo này

        String idParam = request.getParameter("id");
        String priceParam = request.getParameter("price");
        String quantityParam = request.getParameter("quantity");

        if (idParam != null) {
            id = Integer.parseInt(idParam);
            System.out.println("DEBUG: Product ID (id): " + id);
        }
        if (priceParam != null) {
            price = Float.parseFloat(priceParam);
            System.out.println("DEBUG: Product Price (price): " + price);
        }
        if (quantityParam != null) {
            quantity = Integer.parseInt(quantityParam);
            System.out.println("DEBUG: Quantity: " + quantity);
        }

        // Kiểm tra giá trị cơ bản
        if (id == 0 || price == 0 || quantity == 0 || customer_id == 0 || size == null || size.isEmpty()) { // customer_id == 0 là một check tốt
            System.err.println("DEBUG ERROR: Missing critical parameters for cart operation. ID=" + id + ", Price=" + price + ", Quantity=" + quantity + ", Customer_ID=" + customer_id + ", Size=" + size);
            response.sendRedirect(request.getContextPath() + "/error.jsp?message=Missing cart parameters");
            return;
        }

        List<product> list = productDAO.getAll();
        List<promo> promoList = promoDAO.getAll();
        List<entity.cart> list2 = cartDAO.getAll(customer_id); // <-- SỬA: Truyền customer_id
        DAOsize daoSize = new DAOsize();
        List<size> sizeList = daoSize.getAll();

        System.out.println("DEBUG: Current cart items for customer_id " + customer_id + ": " + list2.size());

        float price2 = 0; // Giá tổng cho item hiện tại (qty * unit_price)

        switch (urlPath) {
            case URL_CART_INSERT:
                System.out.println("DEBUG: Handling URL_CART_INSERT");

                // Tính giá cho item mới
                for (product p : list) {
                    if (id == p.getId()) {
                        price2 = quantity * price;
                        System.out.println("DEBUG: Calculated price2 for new item: " + price2);
                        break;
                    }
                }

                // Kiểm tra xem sản phẩm (cùng size) đã có trong giỏ hàng chưa
                boolean itemExistsInCart = false;
                for (entity.cart c : list2) {
                    if (id == c.getProductID() && customer_id == c.getCustomer_id() && size.equals(c.getSize_name())) { // <-- SỬA: So sánh customer_id
                        itemExistsInCart = true;
                        int newQuantity = c.getQuantity() + quantity;

                        boolean stockAvailable = false;
                        for (entity.size s : sizeList) {
                            if (id == s.getProduct_id() && s.getSize_name().equals(size)) {
                                if (newQuantity <= s.getQuantity()) {
                                    stockAvailable = true;
                                    price2 = newQuantity * price;
                                    cartDAO.updateCart(customer_id, id, newQuantity, price2, size); // <-- SỬA: Truyền customer_id
                                    System.out.println("DEBUG: Updated cart for " + customer_id + " (ProductID: " + id + ", Size: " + size + ") to Quantity: " + newQuantity);
                                    break;
                                } else {
                                    System.out.println("DEBUG: Not enough stock for update: " + s.getQuantity() + " available, requested " + newQuantity);
                                    product p = productDAO.getProductById(id);
                                    request.setAttribute("ms", "<script>alert('Sold out! Only " + s.getQuantity() + " available.');</script>");
                                    request.setAttribute("p", p);
                                    request.getRequestDispatcher("productDetail.jsp").forward(request, response);
                                    return;
                                }
                            }
                        }
                        if (!stockAvailable) {
                            System.err.println("DEBUG ERROR: Size/product combination not found in sizeList for update.");
                            response.sendRedirect(request.getContextPath() + "/error.jsp?message=Size not found for product");
                            return;
                        }
                        break;
                    }
                }

                if (!itemExistsInCart) {
                    System.out.println("DEBUG: Item does not exist in cart, attempting to insert.");
                    boolean stockAvailable = false;
                    for (entity.size s : sizeList) {
                        if (id == s.getProduct_id() && s.getSize_name().equals(size)) {
                            if (quantity <= s.getQuantity()) {
                                stockAvailable = true;
                                cartDAO.insertCart(quantity, price2, customer_id, id, size); // <-- SỬA: Truyền customer_id
                                System.out.println("DEBUG: Inserted into cart for " + customer_id + " (ProductID: " + id + ", Size: " + size + ") Quantity: " + quantity);
                                break;
                            } else {
                                System.out.println("DEBUG: Not enough stock for insert: " + s.getQuantity() + " available, requested " + quantity);
                                product p = productDAO.getProductById(id);
                                request.setAttribute("ms", "<script>alert('Sold out! Only " + s.getQuantity() + " available.');</script>");
                                request.setAttribute("p", p);
                                request.getRequestDispatcher("productDetail.jsp").forward(request, response);
                                return;
                            }
                        }
                    }
                    if (!stockAvailable) {
                        System.err.println("DEBUG ERROR: Size/product combination not found in sizeList for insert.");
                        response.sendRedirect(request.getContextPath() + "/error.jsp?message=Size not found for product");
                        return;
                    }
                }

                System.out.println("DEBUG: Redirecting to loadCart after insert/update.");
                response.sendRedirect("loadCart?size=" + size);

                break;

            case URL_CART_INCREASE:
                for (entity.cart c : list2) {
                    if (id == c.getProductID() && customer_id == c.getCustomer_id() && size.equals(c.getSize_name())) { // <-- SỬA: So sánh customer_id
                        for (entity.size s : sizeList) {
                            if (id == s.getProduct_id() && s.getSize_name().equals(size) && quantity <= s.getQuantity()) {
                                for (product p : list) {
                                    if (p.getId() == id) {
                                        price2 = quantity * (p.getPrice() - ((p.getPrice() * promoList.get(p.getPromoID() - 1).getPromoPercent()) / 100));
                                    }
                                }
                                cartDAO.updateCart(customer_id, id, quantity, price2, size); // <-- SỬA: Truyền customer_id
                            }
                            if (quantity > s.getQuantity() && id == s.getProduct_id() && s.getSize_name().equals(size)) {
                                product p = productDAO.getProductById(id);
                                request.setAttribute("ms", ms);
                                request.setAttribute("p", p);
                                temp++;
                                request.setAttribute("temp", temp);
                            }
                        }
                    }
                }

                List<entity.cart> cartUpdateIncrease = cartDAO.getAll(customer_id); // <-- SỬA: Truyền customer_id
                for (entity.cart c : cartUpdateIncrease) {
                    sum = sum + (int)c.getPrice(); // Ép kiểu về int nếu price trong JSP là int
                }
                System.out.println("DEBUG Increase: Sum: " + sum + ", Temp: " + temp);
                response.getWriter().write(price2 + "," + sum + "," + temp);
                break;

            case URL_CART_DECREASE:
                for (entity.cart c : list2) {
                    if (id == c.getProductID() && customer_id == c.getCustomer_id() && size.equals(c.getSize_name())) { // <-- SỬA: So sánh customer_id
                        for (product p : list) {
                            if (id == p.getId()) {
                                price2 = quantity * (p.getPrice() - ((p.getPrice() * promoList.get(p.getPromoID() - 1).getPromoPercent()) / 100));
                                cartDAO.updateCart(customer_id, id, quantity, price2, size); // <-- SỬA: Truyền customer_id
                            }
                        }
                    }
                }

                List<entity.cart> cartUpdateDecrease = cartDAO.getAll(customer_id); // <-- SỬA: Truyền customer_id
                for (entity.cart c : cartUpdateDecrease) {
                    sum = sum + (int)c.getPrice(); // Ép kiểu về int nếu price trong JSP là int
                }
                System.out.println("DEBUG Decrease: Sum: " + sum);
                response.getWriter().write(price2 + "," + sum);
                break;

            case URL_CART_DELETE:
                int quanP = 0;
                cartDAO.deleteCartBySize(id, customer_id, size); // <-- SỬA: Truyền customer_id
                List<entity.cart> cartUpdateDelete = cartDAO.getAll(customer_id); // <-- SỬA: Truyền customer_id
                for (entity.cart c : cartUpdateDelete) {
                    sum = sum + (int)c.getPrice(); // Ép kiểu về int nếu price trong JSP là int
                    quanP++;
                }
                System.out.println("DEBUG Delete: quanP: " + quanP + ", Sum: " + sum);
                response.getWriter().write(price2 + "," + sum + "," + quanP);
                break;

            case URL_PAYMENT:
                response.sendRedirect("loadPayment?size=" + size);
                break;
            default:
                System.err.println("DEBUG ERROR: Unknown URL path: " + urlPath);
                response.sendRedirect(request.getContextPath() + "/error.jsp?message=Unknown cart operation");
                break;
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }
}