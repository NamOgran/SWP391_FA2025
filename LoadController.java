package controller;

import DAO.CartDAO;
import DAO.ProductDAO;
import DAO.VoucherDAO;
import DAO.Size_detailDAO;
import entity.Size_detail;
import entity.Customer;
import entity.Product;
import entity.Voucher;

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
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

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

        HttpSession session = request.getSession();
        Customer loggedInCustomer = (Customer) session.getAttribute("acc");

        // Require login for everything except Buy Now
        if (loggedInCustomer == null && !urlPath.equals(URL_BUYNOW)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Prepare customer info
        String usernameForCart = "";
        int customerIdForCart = -1;
        String customerAddress = "";

        if (loggedInCustomer != null) {
            usernameForCart = loggedInCustomer.getUsername();
            customerIdForCart = loggedInCustomer.getCustomer_id();
            customerAddress = loggedInCustomer.getAddress();
        } else {
            // BuyNow can be handled separately below
            if (!urlPath.equals(URL_BUYNOW)) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }
        }

        // Load cart (FULL cart list)
        CartDAO cartDao = new CartDAO();
        List<entity.Cart> cartList;
        if (customerIdForCart != -1) {
            cartList = cartDao.getAll(customerIdForCart);
        } else {
            cartList = new ArrayList<>();
        }

        // Load products + voucher prices
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

            int unitPrice = product.getPrice();

            int percent = product.getDiscount();
            if (percent > 0) {
                float originalPrice = (float) product.getPrice();
                // Nếu logic của bạn chỉ là phần trăm:
                float discountedPrice = originalPrice - (originalPrice * percent / 100.0f);
                unitPrice = Math.round(discountedPrice);
            }

            priceP.put(id, unitPrice);
        }

        // Sizes available per product (only sizes with qty > 0)
        Size_detailDAO sizeDetailDao = new Size_detailDAO();
        List<Size_detail> sizeDetails = sizeDetailDao.getAll();
        for (Size_detail sd : sizeDetails) {
            if (sd.getQuantity() <= 0) {
                continue;
            }
            int pid = sd.getProduct_id();
            productSizeMap.computeIfAbsent(pid, k -> new ArrayList<>()).add(sd.getSize_name());
        }

        // Default totals for FULL cart (used for cart.jsp)
        int sum = calcSum(cartList);
        int quanP = (cartList == null) ? 0 : cartList.size();

        // Common attributes
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

        System.out.println(request.getParameter("size") + " load");

        switch (urlPath) {

            case LOAD_CART: {
                request.getRequestDispatcher("cart.jsp").forward(request, response);
                break;
            }

            case LOAD_PAYMENT: {
                // If cart is empty -> back to cart
                if (cartList == null || cartList.isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/loadCart");
                    return;
                }

                // NEW: receive selected items from cart.jsp
                String[] selectedItems = request.getParameterValues("selectedItems");

                List<entity.Cart> paymentList = cartList;
                boolean isSelectionMode = (selectedItems != null && selectedItems.length > 0);

                if (isSelectionMode) {
                    Set<String> selectedKeys = parseSelectedKeys(selectedItems);
                    paymentList = filterCartBySelected(cartList, selectedKeys);

                    if (paymentList.isEmpty()) {
                        response.sendRedirect(request.getContextPath() + "/loadCart");
                        return;
                    }
                }

                String validationError = validatePaymentItems(paymentList, productDao, sizeDetailDao);
                if (validationError != null) {
                    response.sendRedirect(request.getContextPath() + "/loadCart");
                    return;
                }

                // ================================================================
                // [FIX] TÍNH LẠI TỔNG TIỀN DỰA TRÊN GIÁ MỚI NHẤT (priceP)
                // ================================================================
                int freshSum = 0;
                for (entity.Cart c : paymentList) {
                    // Lấy giá hiện tại từ Map priceP đã load ở đầu doGet
                    Integer currentPrice = priceP.get(c.getProductID());

                    // Nếu không tìm thấy giá mới (trường hợp hiếm), dùng giá cũ trong cart
                    if (currentPrice == null) {
                        currentPrice = c.getPrice();
                    }

                    freshSum += currentPrice * c.getQuantity();
                }
                // ================================================================

                request.setAttribute("cartList", paymentList);
                request.setAttribute("sum", freshSum); // Dùng biến freshSum vừa tính
                request.setAttribute("quanP", paymentList.size());

                request.getRequestDispatcher("payment.jsp").forward(request, response);
                break;
            }

            case URL_BUYNOW: {
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
            }

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

    // ---------- Helpers (NEW) ----------
    private static int calcSum(List<entity.Cart> list) {
        int sum = 0;
        if (list != null) {
            for (entity.Cart cItem : list) {
                sum += cItem.getPrice() * cItem.getQuantity();
            }
        }
        return sum;
    }

    // Convert ["12::M", "12::L"] into a Set for quick lookup
    private static Set<String> parseSelectedKeys(String[] selectedItems) {
        Set<String> keys = new HashSet<>();
        for (String raw : selectedItems) {
            if (raw == null) {
                continue;
            }
            String v = raw.trim();
            if (v.isEmpty()) {
                continue;
            }

            // expected: productId::size
            int idx = v.indexOf("::");
            if (idx <= 0 || idx >= v.length() - 2) {
                continue;
            }

            String pidStr = v.substring(0, idx).trim();
            String size = v.substring(idx + 2).trim();

            if (pidStr.isEmpty() || size.isEmpty()) {
                continue;
            }

            try {
                int pid = Integer.parseInt(pidStr);
                if (pid > 0) {
                    keys.add(pid + "::" + size);
                }
            } catch (Exception ignore) {
            }
        }
        return keys;
    }

    private static List<entity.Cart> filterCartBySelected(List<entity.Cart> cartList, Set<String> selectedKeys) {
        List<entity.Cart> result = new ArrayList<>();
        if (cartList == null || selectedKeys == null || selectedKeys.isEmpty()) {
            return result;
        }

        for (entity.Cart c : cartList) {
            String key = c.getProductID() + "::" + c.getSize_name();
            if (selectedKeys.contains(key)) {
                result.add(c);
            }
        }
        return result;
    }

    /**
     * Return null if OK. Otherwise return a short error string. Validation is
     * done only for items that will be paid.
     */
    private static String validatePaymentItems(List<entity.Cart> paymentList,
            ProductDAO productDao,
            Size_detailDAO sizeDao) {
        if (paymentList == null || paymentList.isEmpty()) {
            return "No items selected.";
        }

        for (entity.Cart item : paymentList) {
            int pid = item.getProductID();
            String size = item.getSize_name();
            int qty = item.getQuantity();

            Product p = productDao.getProductById(pid);
            if (p == null) {
                return "A selected product no longer exists.";
            }
            if (!p.isIs_active()) {
                return "A selected product is no longer for sale.";
            }
            if (size == null || size.isBlank()) {
                return "Invalid size in selected item.";
            }

            int stock = sizeDao.getSizeQuantity(pid, size);
            if (stock <= 0) {
                return "A selected item is out of stock.";
            }
            if (qty > stock) {
                return "A selected item exceeds available stock.";
            }
        }
        return null;
    }
}
