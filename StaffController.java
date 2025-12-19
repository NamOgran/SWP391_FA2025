package controller;

import DAO.CategoryDAO;
import DAO.CustomerDAO;
import DAO.ImportDAO;
import DAO.ImportDetailDAO;
import DAO.OrderDAO;
import DAO.ProductDAO;
import DAO.Size_detailDAO;
import DAO.StaffDAO;
import DAO.StatsDAO;
import DAO.StatsDAO.ChartData;
import DAO.StatsDAO.OrderPopupData;
import DAO.StatsDAO.TopProduct;
import DAO.VoucherDAO;
import com.google.gson.Gson;
import entity.Category;
import entity.Customer;
import entity.ImportDetail;
import entity.Imports;
import entity.OrderDetail;
import entity.Orders;
import entity.Product;
import entity.Size_detail;
import entity.Staff;
import entity.Stats;
import entity.Voucher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.json.JSONArray;
import org.json.JSONObject;
import payLoad.ResponseData;
import static url.StaffURL.*;

@WebServlet(name = "StaffController", urlPatterns = {
    URL_STAFF,
    URL_PRODUCT_MANAGEMENT_STAFF,
    URL_STAFF_CUSTOMER_LIST,
    URL_STAFF_CUSTOMER_DETAIL,
    "/staff/order",
    URL_ORDER_UPDATE_STAFF,
    URL_IMPORT_STAFF,
    URL_IMPORT_CREATE,
    "/staff/voucher",
    "/staff/voucher/data",
    "/staff/profile",
    "/staff/profile/update",
    "/staff/profile/changepass"
})
@MultipartConfig
public class StaffController extends HttpServlet {

    private int parseIntSafe(String value, int defaultValue) {
        try {
            return (value == null || value.trim().isEmpty()) ? defaultValue : Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    public static String getMd5(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] messageDigest = md.digest(input.getBytes());
            BigInteger no = new BigInteger(1, messageDigest);
            String hashtext = no.toString(16);
            while (hashtext.length() < 32) {
                hashtext = "0" + hashtext;
            }
            return hashtext;
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        Staff staff = (session != null) ? (Staff) session.getAttribute("staff") : null;

        if (staff == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        if (!"staff".equalsIgnoreCase(staff.getRole())) {
            if ("admin".equalsIgnoreCase(staff.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin");
            } else {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied. Staff role required.");
            }
            return;
        }

        String tab = request.getParameter("tab");
        if ("api_chart_data".equals(tab)) {
            getChartData(request, response);
            return;
        }

        String urlPath = request.getServletPath();

        if ("/staff/voucher/data".equals(urlPath)) {
            getVoucherData(request, response);
            return;
        }

        switch (urlPath) {
            case URL_STAFF:
                showDashboard(request, response);
                break;
            case URL_PRODUCT_MANAGEMENT_STAFF:
                listProduct(request, response);
                break;
            case URL_STAFF_CUSTOMER_LIST:
                listCustomers(request, response);
                break;
            case "/staff/order":
                listOrders(request, response);
                break;
            case URL_IMPORT_STAFF:
                listImports(request, response);
                break;
            case "/staff/voucher":
                request.getRequestDispatcher("/staff_Voucher.jsp").forward(request, response);
                break;
            case "/staff/profile":
                request.getRequestDispatcher("/staff_Profile.jsp").forward(request, response);
                break;
            default:
                showDashboard(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        Staff staff = (session != null) ? (Staff) session.getAttribute("staff") : null;

        if (staff == null || !"staff".equalsIgnoreCase(staff.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String urlPath = request.getServletPath();
        String action = request.getParameter("action");

        if (URL_STAFF_CUSTOMER_DETAIL.equals(urlPath) || "get_customer_orders".equals(action)) {
            getCustomerOrderHistory(request, response);
        } else if (URL_ORDER_UPDATE_STAFF.equals(urlPath) || "update_order_status".equals(action)) {
            updateOrderStatus(request, response);
        } else if (URL_IMPORT_CREATE.equals(urlPath) || "create_import".equals(action)) {
            createImport(request, response, staff.getStaff_id());
        } else if ("/staff/profile/update".equals(urlPath)) {
            updateProfile(request, response);
        } else if ("/staff/profile/changepass".equals(urlPath)) {
            changePassword(request, response);
        } else {
            doGet(request, response);
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        StatsDAO statsDAO = new StatsDAO();
        Gson gson = new Gson();

        String fromParam = request.getParameter("fromDate");
        String toParam = request.getParameter("toDate");
        LocalDate now = LocalDate.now();
        LocalDate fromDate, toDate;

        if (fromParam == null || fromParam.isEmpty() || toParam == null || toParam.isEmpty()) {
            toDate = now;
            fromDate = now.withDayOfYear(1);
        } else {
            try {
                fromDate = LocalDate.parse(fromParam);
                toDate = LocalDate.parse(toParam);
            } catch (Exception e) {
                toDate = now;
                fromDate = now.withDayOfYear(1);
            }
        }
        Date sqlFrom = Date.valueOf(fromDate);
        Date sqlTo = Date.valueOf(toDate);

        int productsInStock = statsDAO.getAllProductSizeDetail();
        int totalCustomers = statsDAO.getAllCustomersCount();
        Stats statsRange = statsDAO.getStatsByDateRange(sqlFrom, sqlTo);
        int totalOrders = (statsRange != null) ? statsRange.getTotalOrders() : 0;
        int revenue = (statsRange != null) ? (int) statsRange.getTotalRevenue() : 0;

        Map<String, Integer> orderMap = statsDAO.getOrderStatusCounts(sqlFrom, sqlTo);
        String[] fixedStatuses = {"Pending", "Preparing", "Delivering", "Delivered", "Cancelled", "Returned"};
        List<String> labels = new ArrayList<>();
        List<Integer> data = new ArrayList<>();
        int totalOrdersChart = 0;

        for (String label : fixedStatuses) {
            labels.add(label);
            int count = 0;
            if (orderMap != null) {
                if ("Pending".equals(label)) {
                    count += orderMap.getOrDefault("Pending", 0);
                } else if ("Preparing".equals(label)) {
                    count += orderMap.getOrDefault("Preparing", 0) + orderMap.getOrDefault("Processing", 0) + orderMap.getOrDefault("Confirmed", 0);
                } else if ("Delivering".equals(label)) {
                    count += orderMap.getOrDefault("Delivering", 0) + orderMap.getOrDefault("Shipping", 0) + orderMap.getOrDefault("Shipped", 0);
                } else if ("Delivered".equals(label)) {
                    count += orderMap.getOrDefault("Delivered", 0) + orderMap.getOrDefault("Completed", 0) + orderMap.getOrDefault("Success", 0);
                } else if ("Cancelled".equals(label)) {
                    count += orderMap.getOrDefault("Cancelled", 0) + orderMap.getOrDefault("Cancel", 0);
                } else if ("Returned".equals(label)) {
                    count += orderMap.getOrDefault("Returned", 0) + orderMap.getOrDefault("Refunded", 0);
                }
            }
            data.add(count);
            totalOrdersChart += count;
        }

        int currentYear = now.getYear();
        List<ChartData> yearData = statsDAO.getMonthlyStatsByYear(currentYear);
        double[] fullRevenue = new double[12];
        int[] fullOrders = new int[12];

        if (yearData != null) {
            for (ChartData d : yearData) {
                int mIndex = d.month - 1;
                if (mIndex >= 0 && mIndex < 12) {
                    fullRevenue[mIndex] = d.revenue;
                    fullOrders[mIndex] = d.orders;
                }
            }
        }

        List<OrderPopupData> recentOrders = statsDAO.getOrdersForPopup(sqlFrom, sqlTo);
        List<TopProduct> topProducts = statsDAO.getBestSellers(5);

        request.setAttribute("displayFrom", fromDate.toString());
        request.setAttribute("displayTo", toDate.toString());
        request.setAttribute("numberOfProduct", productsInStock);
        request.setAttribute("numberOfCustomer", totalCustomers);
        request.setAttribute("numberOfOrder", totalOrders);
        request.setAttribute("revenue", revenue);
        request.setAttribute("orderStatsLabels", gson.toJson(labels));
        request.setAttribute("orderStatsData", gson.toJson(data));
        request.setAttribute("totalOrdersChart", totalOrdersChart);
        request.setAttribute("recentOrders", recentOrders);
        request.setAttribute("topProducts", topProducts);
        request.setAttribute("currentYear", currentYear);
        request.setAttribute("chartRevenue", gson.toJson(fullRevenue));
        request.setAttribute("chartOrders", gson.toJson(fullOrders));

        request.getRequestDispatcher("/staff_Dashboard.jsp").forward(request, response);
    }

    private void getChartData(HttpServletRequest request, HttpServletResponse response) throws IOException {
        StatsDAO statsDAO = new StatsDAO();
        int year = parseIntSafe(request.getParameter("year"), LocalDate.now().getYear());
        List<ChartData> dbData = statsDAO.getMonthlyStatsByYear(year);
        double[] revenueData = new double[12];
        int[] ordersData = new int[12];
        if (dbData != null) {
            for (ChartData data : dbData) {
                int mIndex = data.month - 1;
                if (mIndex >= 0 && mIndex < 12) {
                    revenueData[mIndex] = data.revenue;
                    ordersData[mIndex] = data.orders;
                }
            }
        }
        response.setContentType("application/json");
        Gson gson = new Gson();
        Map<String, Object> jsonResponse = new HashMap<>();
        jsonResponse.put("revenue", revenueData);
        jsonResponse.put("orders", ordersData);
        response.getWriter().write(gson.toJson(jsonResponse));
    }

    private void listProduct(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ProductDAO productDAO = new ProductDAO();
        Size_detailDAO size_detailDAO = new Size_detailDAO();
        CategoryDAO categoryDAO = new CategoryDAO();

        String searchName = request.getParameter("search");
        String sortBy = request.getParameter("sort");
        String status = request.getParameter("status");
        int pageIndex = parseIntSafe(request.getParameter("page"), 1);
        int categoryId = parseIntSafe(request.getParameter("category"), 0);
        int pageSize = 10;
        if (status == null || status.isEmpty()) {
            status = "all";
        }

        int totalProducts = productDAO.getTotalProductCount(searchName, categoryId, status);
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
        List<Product> productList = productDAO.getPaginatedProducts(searchName, sortBy, categoryId, status, pageIndex, pageSize);

        Map<Integer, Map<String, Integer>> productSizeMap = new HashMap<>();
        for (Product p : productList) {
            List<Size_detail> sizes = size_detailDAO.getSizesByProductId(p.getId());
            Map<String, Integer> sizeQty = new HashMap<>();
            sizeQty.put("S", 0);
            sizeQty.put("M", 0);
            sizeQty.put("L", 0);
            for (Size_detail sz : sizes) {
                sizeQty.put(sz.getSize_name(), sz.getQuantity());
            }
            productSizeMap.put(p.getId(), sizeQty);
        }

        List<Category> cateList = categoryDAO.getAll();
        Map<Integer, String> categoryMap = new HashMap<>();
        for (Category c : cateList) {
            categoryMap.put(c.getCategory_id(), c.getType() + " (" + c.getGender() + ")");
        }

        request.setAttribute("list", productList);
        request.setAttribute("totalProducts", totalProducts);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", pageIndex);
        request.setAttribute("searchName", searchName);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("selectedCategory", categoryId);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("productSizeMap", productSizeMap);
        request.setAttribute("categoryMap", categoryMap);
        request.setAttribute("cateList", cateList);

        request.getRequestDispatcher("/staff_Product.jsp").forward(request, response);
    }

    private void listCustomers(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        CustomerDAO customerDAO = new CustomerDAO();
        List<Customer> allCust = customerDAO.getAll();
        Collections.sort(allCust, (c1, c2) -> Integer.compare(c2.getCustomer_id(), c1.getCustomer_id()));
        request.setAttribute("customerList", allCust);
        request.setAttribute("custTotal", allCust.size());
        request.getRequestDispatcher("/staff_Customer.jsp").forward(request, response);
    }

    private void getCustomerOrderHistory(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        ResponseData responseData = new ResponseData();
        OrderDAO orderDAO = new OrderDAO();
        try {
            int custId = Integer.parseInt(request.getParameter("id"));
            List<Orders> orders = orderDAO.getOrdersByCustomerID(custId);
            Collections.sort(orders, (o1, o2) -> Integer.compare(o2.getOrderID(), o1.getOrderID()));

            List<Map<String, Object>> simpleList = new ArrayList<>();
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            for (Orders o : orders) {
                Map<String, Object> map = new HashMap<>();
                map.put("order_id", o.getOrderID());
                map.put("dateString", (o.getDate() != null) ? sdf.format(o.getDate()) : "");
                map.put("address", o.getAddress());
                map.put("status", o.getStatus());
                map.put("totalString", String.format("%,d VND", (int) o.getTotal()));
                simpleList.add(map);
            }
            responseData.setIsSuccess(true);
            responseData.setData(simpleList);
        } catch (Exception e) {
            responseData.setIsSuccess(false);
            responseData.setDescription("Error: " + e.getMessage());
        }
        out.print(gson.toJson(responseData));
        out.flush();
    }

    private void listOrders(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        OrderDAO orderDAO = new OrderDAO();
        CustomerDAO customerDAO = new CustomerDAO();
        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        VoucherDAO voucherDAO = new VoucherDAO();

        List<Orders> orderList = orderDAO.getAllOrdersSort();
        List<OrderDetail> orderDetailList = orderDAO.getAllOrdersDetail();

        Map<Integer, String> customerMap = new HashMap<>();
        List<Customer> customers = customerDAO.getAll();
        for (Customer c : customers) {
            String displayName = (c.getFullName() != null && !c.getFullName().isEmpty()) ? c.getFullName() : c.getUsername();
            customerMap.put(c.getCustomer_id(), displayName);
        }
        request.setAttribute("customerMap", customerMap);

        Map<Integer, String> productNameMap = new HashMap<>();
        Map<Integer, Integer> productPriceMap = new HashMap<>();
        Map<Integer, Integer> productDiscountMap = new HashMap<>();
        Map<Integer, String> picUrlMap = new HashMap<>();
        Map<Integer, String> productCategoryMap = new HashMap<>();

        List<Category> categories = categoryDAO.getAll();
        Map<Integer, String> categoryNames = new HashMap<>();
        for (Category c : categories) {
            categoryNames.put(c.getCategory_id(), c.getType() + " (" + c.getGender() + ")");
        }

        List<Product> products = productDAO.getAll();
        for (Product p : products) {
            productNameMap.put(p.getId(), p.getName());
            productPriceMap.put(p.getId(), p.getPrice());
            productDiscountMap.put(p.getId(), p.getDiscount());
            picUrlMap.put(p.getId(), p.getPicURL());
            productCategoryMap.put(p.getId(), categoryNames.getOrDefault(p.getCategoryID(), "Unknown"));
        }
        request.setAttribute("productNameMap", productNameMap);
        request.setAttribute("productPriceMap", productPriceMap);
        request.setAttribute("picUrlMap", picUrlMap);
        request.setAttribute("productCategoryMap", productCategoryMap);

        Map<String, Integer> voucherValMap = new HashMap<>();
        List<Voucher> vouchers = voucherDAO.getAll();
        for (Voucher p : vouchers) {
            voucherValMap.put(p.getVoucherID(), p.getVoucherPercent());
        }
        request.setAttribute("voucherMap", voucherValMap);

        request.setAttribute("totalOrders", orderList.size());
        request.setAttribute("orderList", orderList);
        request.setAttribute("orderDetailList", orderDetailList);

        request.getRequestDispatcher("/staff_Order.jsp").forward(request, response);
    }

    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        ResponseData responseData = new ResponseData();

        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String newStatus = request.getParameter("status");

            OrderDAO orderDAO = new OrderDAO();
            Size_detailDAO size_detailDAO = new Size_detailDAO();
            ProductDAO productDAO = new ProductDAO();

            if ("Delivering".equals(newStatus)) {
                List<OrderDetail> details = orderDAO.getAllOrdersDetailByID(orderId);

                if (details != null && !details.isEmpty()) {
                    for (OrderDetail od : details) {
                        Size_detail currentStock = size_detailDAO.getSizeByProductIdAndName(od.getProductID(), od.getSize_name());

                        if (currentStock == null) {
                            Product p = productDAO.getProductById(od.getProductID());
                            String pName = (p != null) ? p.getName() : "ID " + od.getProductID();
                            throw new Exception("Error data: No information found for the product: " + pName);
                        }

                        if (currentStock.getQuantity() < od.getQuantity()) {
                            Product p = productDAO.getProductById(od.getProductID());
                            String productName = (p != null) ? p.getName() : "Product ID " + od.getProductID();
                            throw new Exception("Insufficient stock for: " + productName
                                    + " (Size: " + od.getSize_name() + "). "
                                    + "In stock: " + currentStock.getQuantity()
                                    + ", Customer Order: " + od.getQuantity());
                        }
                    }

                    for (OrderDetail od : details) {
                        Size_detail currentStock = size_detailDAO.getSizeByProductIdAndName(od.getProductID(), od.getSize_name());
                        int newQty = currentStock.getQuantity() - od.getQuantity();
                        size_detailDAO.updateQuanSize(newQty, od.getProductID(), currentStock.getSize_name());
                    }
                }
            }

            orderDAO.updateStatus(newStatus, orderId);

            responseData.setIsSuccess(true);
            responseData.setDescription("Status update successful: " + newStatus);

        } catch (Exception e) {
            responseData.setIsSuccess(false);
            responseData.setDescription("Error: " + e.getMessage());
            e.printStackTrace();
        }

        out.print(gson.toJson(responseData));
        out.flush();
    }

    private void listImports(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ImportDAO importDAO = new ImportDAO();
        ImportDetailDAO importDetailDAO = new ImportDetailDAO();
        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO();

        String importSearch = request.getParameter("import_search");
        int importPage = parseIntSafe(request.getParameter("import_page"), 1);
        int importPageSize = 10;

        List<Imports> allImports = importDAO.getAllImport();
        List<Imports> filteredImports = new ArrayList<>();

        if (importSearch != null && !importSearch.trim().isEmpty()) {
            String key = importSearch.toLowerCase();
            for (Imports i : allImports) {
                if (i.getUsername() != null && i.getUsername().toLowerCase().contains(key)) {
                    filteredImports.add(i);
                }
            }
        } else {
            filteredImports = allImports;
        }

        Collections.sort(filteredImports, (o1, o2) -> o2.getId() - o1.getId());

        int totalImports = filteredImports.size();
        int importTotalPages = (int) Math.ceil((double) totalImports / importPageSize);
        int startImp = (importPage - 1) * importPageSize;
        int endImp = Math.min(startImp + importPageSize, totalImports);
        List<Imports> paginatedImports = (startImp < endImp) ? filteredImports.subList(startImp, endImp) : new ArrayList<>();

        Map<Integer, List<ImportDetail>> importDetailMap = new HashMap<>();
        for (Imports i : paginatedImports) {
            importDetailMap.put(i.getId(), importDetailDAO.getListToImport(i.getId()));
        }

        List<Product> products = productDAO.getAll();
        List<Category> categories = categoryDAO.getAll();

        Map<Integer, String> catNameMap = new HashMap<>();
        for (Category c : categories) {
            catNameMap.put(c.getCategory_id(), c.getType() + " (" + c.getGender() + ")");
        }

        Map<Integer, Product> prodMap = new HashMap<>();
        Map<Integer, String> productCategoryMap = new HashMap<>();

        for (Product p : products) {
            prodMap.put(p.getId(), p);
            productCategoryMap.put(p.getId(), catNameMap.getOrDefault(p.getCategoryID(), "Unknown"));
        }

        request.setAttribute("importList", paginatedImports);
        request.setAttribute("totalImports", totalImports);
        request.setAttribute("importTotalPages", importTotalPages);
        request.setAttribute("importCurrentPage", importPage);
        request.setAttribute("importSearch", importSearch);
        request.setAttribute("importDetailMap", importDetailMap);
        request.setAttribute("productList", products);
        request.setAttribute("prodMap", prodMap);
        request.setAttribute("productCategoryMap", productCategoryMap);

        request.getRequestDispatcher("/staff_Import.jsp").forward(request, response);
    }

    private void createImport(HttpServletRequest request, HttpServletResponse response, int staffId) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        ResponseData responseData = new ResponseData();

        try {
            String itemsJson = request.getParameter("items");
            JSONArray jsonArray = new JSONArray(itemsJson);
            if (jsonArray.length() == 0) {
                throw new Exception("No items provided");
            }

            ImportDAO importDAO = new ImportDAO();
            ImportDetailDAO detailDAO = new ImportDetailDAO();
            ProductDAO productDAO = new ProductDAO();

            int totalAmount = 0;
            for (int i = 0; i < jsonArray.length(); i++) {
                JSONObject item = jsonArray.getJSONObject(i);
                int pId = Integer.parseInt(item.getString("productId"));
                int qty = item.getInt("quantity");
                Product p = productDAO.getProductById(pId);
                if (p != null) {
                    totalAmount += p.getPrice() * qty;
                }
            }

            Imports newImport = new Imports();
            newImport.setStaff_id(staffId);
            newImport.setDate(new Date(System.currentTimeMillis()));
            newImport.setStatus("Pending");
            newImport.setTotal(totalAmount);

            int importId = importDAO.insertImportAndGetId(newImport);
            if (importId > 0) {
                for (int i = 0; i < jsonArray.length(); i++) {
                    JSONObject item = jsonArray.getJSONObject(i);
                    int pId = Integer.parseInt(item.getString("productId"));
                    String size = item.getString("size");
                    int qty = item.getInt("quantity");

                    Product p = productDAO.getProductById(pId);
                    int price = (p != null) ? p.getPrice() : 0;

                    ImportDetail detail = new ImportDetail();
                    detail.setImportID(importId);
                    detail.setProductID(pId);
                    detail.setSizeName(size);
                    detail.setQuantity(qty);
                    detail.setPrice(price);

                    detailDAO.insertImportDetail(detail);
                }
                responseData.setIsSuccess(true);
            } else {
                responseData.setIsSuccess(false);
                responseData.setDescription("Failed to create import record.");
            }
        } catch (Exception e) {
            responseData.setIsSuccess(false);
            responseData.setDescription("Error: " + e.getMessage());
        }
        out.print(gson.toJson(responseData));
        out.flush();
    }

    // [UPDATED] Hàm này được cập nhật để phù hợp với VoucherDAO mới (có lọc ngày)
    private void getVoucherData(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        VoucherDAO voucherDAO = new VoucherDAO();

        int page = parseIntSafe(request.getParameter("page"), 1);
        String search = request.getParameter("search");
        // [MỚI] Lấy tham số ngày từ request
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        if (search == null) {
            search = "";
        }

        int pageSize = 10;
        // [MỚI] Truyền startDate, endDate vào DAO
        int totalItems = voucherDAO.getTotalVoucherCount(search, startDate, endDate);
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        List<Voucher> list = voucherDAO.getPaginatedVouchers(search, startDate, endDate, page, pageSize);

        Map<String, Object> result = new HashMap<>();
        result.put("list", list);
        result.put("totalPages", totalPages);
        result.put("currentPage", page);
        result.put("totalItems", totalItems);

        out.print(gson.toJson(result));
        out.flush();
    }

    private void updateProfile(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        ResponseData res = new ResponseData();

        HttpSession session = request.getSession();
        Staff currentStaff = (Staff) session.getAttribute("staff");
        StaffDAO staffDAO = new StaffDAO();
        CustomerDAO customerDAO = new CustomerDAO();

        try {
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String phone = request.getParameter("phone");
            String fullName = request.getParameter("fullName");

            boolean isSuccess = staffDAO.updateStaffProfile(currentStaff.getStaff_id(), email, address, phone, fullName);

            if (isSuccess) {
                Staff updatedStaff = staffDAO.getStaffByEmailOrUsername(currentStaff.getUsername());
                session.setAttribute("staff", updatedStaff);

                if (customerDAO.isUsernameTaken(currentStaff.getUsername())) {
                    customerDAO.updateUserProfileByUsername(currentStaff.getUsername(), email, address, phone, fullName);
                }

                res.setIsSuccess(true);
                res.setDescription("Profile updated successfully!");
            } else {
                res.setIsSuccess(false);
                res.setDescription("Update failed. Email/Phone may exist.");
            }
        } catch (Exception e) {
            res.setIsSuccess(false);
            res.setDescription("Error: " + e.getMessage());
        }
        out.print(gson.toJson(res));
        out.flush();
    }

    private void changePassword(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        ResponseData res = new ResponseData();

        HttpSession session = request.getSession();
        Staff currentStaff = (Staff) session.getAttribute("staff");
        StaffDAO staffDAO = new StaffDAO();
        CustomerDAO customerDAO = new CustomerDAO();

        try {
            String currentPass = request.getParameter("currentPassword");
            String newPass = request.getParameter("newPassword");

            String currentPassHash = getMd5(currentPass);
            boolean isCorrect = staffDAO.checkLogin(currentStaff.getUsername(), currentPassHash);

            if (isCorrect) {
                String newPassHash = getMd5(newPass);
                boolean isSuccess = staffDAO.updatePasswordByEmailOrUsername(newPassHash, currentStaff.getUsername());

                if (isSuccess) {
                    customerDAO.updatePasswordByUsername(newPassHash, currentStaff.getUsername());
                    currentStaff.setPassword(newPassHash);
                    session.setAttribute("staff", currentStaff);

                    res.setIsSuccess(true);
                    res.setDescription("Password changed successfully!");
                } else {
                    res.setIsSuccess(false);
                    res.setDescription("Database update failed.");
                }
            } else {
                res.setIsSuccess(false);
                res.setDescription("Incorrect current password.");
            }
        } catch (Exception e) {
            res.setIsSuccess(false);
            res.setDescription("Error: " + e.getMessage());
        }
        out.print(gson.toJson(res));
        out.flush();
    }
}
