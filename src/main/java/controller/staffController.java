/*
 * File: controller/StaffController.java
 * Full Updated Version (English Translated)
 */
package controller;

import java.time.LocalDate;
import DAO.CategoryDAO;
import DAO.CustomerDAO;
import DAO.ImportDAO;
import DAO.ImportDetailDAO;
import DAO.ProductDAO;
import DAO.VoucherDAO;
import DAO.Size_detailDAO;
import DAO.StaffDAO;
import DAO.OrderDAO;
import DAO.StatsDAO;
import com.google.gson.Gson;
import entity.Category;
import entity.Customer;
import entity.ImportDetail;
import entity.Imports;
import entity.Product;
import entity.Staff;
import entity.Stats;
import entity.Orders;
import entity.OrderDetail;
import entity.Size_detail;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;
import payLoad.ResponseData;

// Import static URLs
import static url.StaffURL.URL_ACCOUNT_MANAGEMENT_STAFF;
import static url.StaffURL.URL_ADD_ACCOUNT_STAFF;
import static url.StaffURL.URL_ADD_PRODUCT_STAFF;
import static url.StaffURL.URL_BOTH_DELETE_STAFF;
import static url.StaffURL.URL_CATEGORY_ADD;
import static url.StaffURL.URL_CATEGORY_DELETE;
import static url.StaffURL.URL_CATEGORY_LIST;
import static url.StaffURL.URL_CATEGORY_UPDATE;
import static url.StaffURL.URL_CHANGEPASS_PROFILE_STAFF;
import static url.StaffURL.URL_CUSTOMER_DELETE_STAFF;
import static url.StaffURL.URL_IMPORT_CREATE;
import static url.StaffURL.URL_IMPORT_GET_PRODUCTS;
import static url.StaffURL.URL_IMPORT_STAFF;
import static url.StaffURL.URL_IMPORT_UPDATE_STAFF;
import static url.StaffURL.URL_LOGIN_STAFF;
import static url.StaffURL.URL_PRODUCT_DELETE_STAFF;
import static url.StaffURL.URL_PRODUCT_MANAGEMENT_STAFF;
import static url.StaffURL.URL_PROFILE_STAFF;
import static url.StaffURL.URL_SEARCH_ACCOUNT_STAFF;
import static url.StaffURL.URL_SEARCH_PRODUCT_STAFF;
import static url.StaffURL.URL_SORT_PRODUCT_STAFF;
import static url.StaffURL.URL_STAFF_DELETE_STAFF;
import static url.StaffURL.URL_UPDATE_ACCOUNT_STAFF;
import static url.StaffURL.URL_UPDATE_PRODUCT_STAFF;
import static url.StaffURL.URL_UPDATE_PROFILE_STAFF;
import static url.StaffURL.URL_STAFF_CUSTOMER_LIST;
import static url.StaffURL.URL_STAFF_CUSTOMER_SEARCH;
import static url.StaffURL.URL_STAFF_CUSTOMER_DETAIL;
import static url.StaffURL.URL_STAFF;
import static url.StaffURL.URL_ORDER_UPDATE_STAFF; // <--- IMPORTANT: Order update URL

@WebServlet(
        name = "staffController",
        urlPatterns = {
            "/staff/product/size_detail",
            URL_IMPORT_UPDATE_STAFF,
            URL_IMPORT_STAFF,
            URL_IMPORT_CREATE,
            URL_IMPORT_GET_PRODUCTS,
            URL_CHANGEPASS_PROFILE_STAFF,
            URL_UPDATE_PROFILE_STAFF,
            URL_ADD_ACCOUNT_STAFF,
            URL_UPDATE_ACCOUNT_STAFF,
            URL_ADD_PRODUCT_STAFF,
            URL_UPDATE_PRODUCT_STAFF,
            URL_BOTH_DELETE_STAFF,
            URL_CUSTOMER_DELETE_STAFF,
            URL_STAFF_DELETE_STAFF,
            URL_SEARCH_ACCOUNT_STAFF,
            URL_ACCOUNT_MANAGEMENT_STAFF,
            URL_PRODUCT_DELETE_STAFF,
            URL_PRODUCT_MANAGEMENT_STAFF,
            URL_SORT_PRODUCT_STAFF,
            URL_SEARCH_PRODUCT_STAFF,
            URL_PROFILE_STAFF,
            URL_CATEGORY_LIST,
            URL_CATEGORY_ADD,
            URL_CATEGORY_UPDATE,
            URL_CATEGORY_DELETE,
            URL_STAFF_CUSTOMER_LIST,
            URL_STAFF_CUSTOMER_SEARCH,
            URL_STAFF_CUSTOMER_DETAIL,
            URL_STAFF,
            URL_ORDER_UPDATE_STAFF,}
)
public class StaffController extends HttpServlet {

    StaffDAO daoStaff = new StaffDAO();
    CustomerDAO daoCustomer = new CustomerDAO();
    ProductDAO daoProduct = new ProductDAO();
    CategoryDAO daoCategory = new CategoryDAO();
    ImportDetailDAO daoImportDetail = new ImportDetailDAO();
    ImportDAO daoImport = new ImportDAO();
    Size_detailDAO daoSize = new Size_detailDAO();
    VoucherDAO daoVoucher = new VoucherDAO();
    OrderDAO daoOrder = new OrderDAO();
    StatsDAO statsDAO = new StatsDAO();
    private Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String urlPath = request.getServletPath();
        switch (urlPath) {
            case URL_STAFF:
                staffDashboard(request, response);
                break;
            case URL_PRODUCT_MANAGEMENT_STAFF:
                listProduct(request, response);
                break;
            case URL_SORT_PRODUCT_STAFF:
                sort(request, response);
                break;
            case URL_SEARCH_PRODUCT_STAFF:
                searchProduct(request, response);
                break;
            case URL_PROFILE_STAFF:
                profile(request, response);
                break;
            case URL_PRODUCT_DELETE_STAFF:
                deleteProduct(request, response);
                break;
            case URL_ACCOUNT_MANAGEMENT_STAFF:
                accountList(request, response);
                break;
            case URL_SEARCH_ACCOUNT_STAFF:
                searchAccount(request, response);
                break;
            // === DELETE HANDLERS ===
            case URL_STAFF_DELETE_STAFF:
                deleteStaff(request, response);
                break;
            case URL_CUSTOMER_DELETE_STAFF:
                deleteCustomer(request, response);
                break;
            case URL_BOTH_DELETE_STAFF:
                deleteBoth(request, response);
                break;
            case URL_UPDATE_PRODUCT_STAFF:
                updateProduct(request, response);
                break;
            case URL_ADD_PRODUCT_STAFF:
                addProduct(request, response);
                break;
            case URL_UPDATE_ACCOUNT_STAFF:
                updateAccount(request, response);
                break;
            case URL_ADD_ACCOUNT_STAFF:
                addStaff(request, response);
                break;
            case URL_UPDATE_PROFILE_STAFF:
                updateProfile(request, response);
                break;
            case URL_CHANGEPASS_PROFILE_STAFF:
                changePassword(request, response);
                break;
            case URL_IMPORT_STAFF:
                importList(request, response);
                break;
            case URL_IMPORT_UPDATE_STAFF:
                updateStatus(request, response);
                break;
            case URL_IMPORT_CREATE:
                createImport(request, response);
                break;
            case URL_IMPORT_GET_PRODUCTS:
                getProductsAndSizesForImport(request, response);
                break;
            // category
            case URL_CATEGORY_LIST:
                listCategories(request, response);
                break;
            case URL_CATEGORY_ADD:
                addCategory(request, response);
                break;
            case URL_CATEGORY_UPDATE:
                updateCategory(request, response);
                break;
            case URL_CATEGORY_DELETE:
                deleteCategory(request, response);
                break;
            case URL_STAFF_CUSTOMER_LIST:
                listCustomers(request, response);
                break;
            case URL_STAFF_CUSTOMER_SEARCH:
                searchCustomers(request, response);
                break;
            case URL_STAFF_CUSTOMER_DETAIL:
                customerOrders(request, response);
                break;
            // === ORDER STATUS UPDATE ===
            case URL_ORDER_UPDATE_STAFF:
                updateOrderStatus(request, response);
                break;
            case "/staff/product/size_detail":
                getAllProductSize_details(request, response);
                break;
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doPost(req, resp);
    }

    // ================== STAFF DASHBOARD (MODIFIED) ==================
    private void staffDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Staff staff = (session != null) ? (Staff) session.getAttribute("staff") : null;
        if (staff == null || !"staff".equalsIgnoreCase(staff.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // === 1. KEEP TAB STATE (IMPORTANT) ===
        String activeTab = request.getParameter("activeTab");
        if (activeTab == null || activeTab.trim().isEmpty()) {
            activeTab = "statistic";
        }
        request.setAttribute("activeTab", activeTab);

        // === 2. STATISTICS PROCESSING (CHART) ===
        String yearParam = request.getParameter("year");
        int year;
        if (yearParam == null || yearParam.isEmpty()) {
            year = LocalDate.now().getYear();
        } else {
            try {
                year = Integer.parseInt(yearParam);
            } catch (NumberFormatException e) {
                year = LocalDate.now().getYear();
            }
        }

        request.setAttribute("year", year);

        // === 3. ORDER MANAGEMENT PROCESSING (Sort, Pagination, Search) ===
        int pageIndex = 1;
        int pageSize = 10;
        try {
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.isEmpty()) {
                pageIndex = Integer.parseInt(pageStr);
            }
        } catch (NumberFormatException e) {
            pageIndex = 1;
        }

        String searchId = request.getParameter("searchId");
        List<Orders> orderList;
        int totalPages = 1;

        if (searchId != null && !searchId.trim().isEmpty()) {
            orderList = daoOrder.searchOrdersById(searchId);
            totalPages = 1;
        } else {
            orderList = daoOrder.getPaginatedOrders(pageIndex, pageSize);
            int totalOrders = daoOrder.getTotalOrdersCount();
            totalPages = (int) Math.ceil((double) totalOrders / pageSize);
        }

        // === 4. PREPARE AUXILIARY DATA (MAPS) ===
        List<OrderDetail> orderDetailList = daoOrder.getAllOrdersDetail();

        Map<Integer, String> customerUsernameMap = new HashMap<>();
        List<Customer> customers = daoCustomer.getAll();
        for (Customer c : customers) {
            customerUsernameMap.put(c.getCustomer_id(), c.getFullName() != null ? c.getFullName() : c.getUsername());
        }

        List<Product> productList = daoProduct.getAll();
        Map<Integer, String> nameProduct = new HashMap<>();
        Map<Integer, Integer> priceProduct = new HashMap<>();
        Map<Integer, Integer> voucherID = new HashMap<>();
        Map<Integer, Integer> voucherMap = new HashMap<>();

        for (Product p : productList) {
            nameProduct.put(p.getId(), p.getName());
            priceProduct.put(p.getId(), p.getPrice());
            voucherID.put(p.getId(), p.getVoucherID());
        }
        List<entity.Voucher> vouchers = daoVoucher.getAll();
        for (entity.Voucher pr : vouchers) {
            voucherMap.put(pr.getVoucherID(), pr.getVoucherPercent());
        }

        // === 5. SEND DATA TO JSP ===
        request.setAttribute("orderList", orderList);
        request.setAttribute("orderDetailList", orderDetailList);
        request.setAttribute("orderCurrentPage", pageIndex);
        request.setAttribute("orderTotalPages", totalPages);

        // Send back search keyword to keep input state
        request.setAttribute("searchId", searchId);

        request.setAttribute("customerUsernameMap", customerUsernameMap);
        request.setAttribute("nameProduct", nameProduct);
        request.setAttribute("priceProduct", priceProduct);
        request.setAttribute("voucherID", voucherID);
        request.setAttribute("voucherMap", voucherMap);

        request.getRequestDispatcher("/staff.jsp").forward(request, response);
    }

    protected void updateOrderStatus(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            String newStatus = request.getParameter("status");

            daoOrder.updateStatus(newStatus, orderId);

            if ("Delivering".equals(newStatus)) {
                List<OrderDetail> details = daoOrder.getAllOrdersDetailByID(orderId);
                if (details != null) {
                    for (OrderDetail od : details) {
                        // Lấy thông tin size hiện tại
                        Size_detail cur = daoSize.getSizeByProductIdAndName(od.getProductID(), od.getSize_name());
                        if (cur != null) {
                            // Trừ tồn kho trong bảng size_detail (size_detail)
                            int newQty = cur.getQuantity() - od.getQuantity();
                            daoSize.updateQuanSize(newQty, od.getProductID(), cur.getSize_name());
                        }
                    }
                }

                // --- ĐOẠN NÀY ĐÃ XÓA ---
                // Bạn đã xóa vòng lặp for (Product p : daoProduct.getAll()) updateQuan ở đây
                // Vì bảng Product không còn cột quantity để update nữa.
                // Số lượng tổng sẽ được tự động tính bằng SUM(quantity) trong ProductDAO.getProductQuantity() khi cần hiển thị.
            }

            ResponseData data = new ResponseData();
            data.setIsSuccess(true);
            data.setDescription("Update order status successfully");

            String json = gson.toJson(data);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter pw = response.getWriter();
            pw.print(json);
            pw.flush();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

    private void getAllProductSize_details(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            // Lấy toàn bộ danh sách Size_detail (Size + Quantity + ProductID)
            // Giả sử daoSize là Size_detailDAO và có hàm getAll() trả về List<Size_detail>
            List<Size_detail> size_details = daoSize.getAll();

            ResponseData data = new ResponseData();
            data.setIsSuccess(true);
            data.setData(size_details);
            data.setDescription("Size_detail list retrieved successfully");

            String json = gson.toJson(data);

            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter pw = response.getWriter();
            pw.print(json);
            pw.flush();
        } catch (Exception e) {
            e.printStackTrace();
            // Trả về lỗi nếu có
            ResponseData data = new ResponseData();
            data.setIsSuccess(false);
            data.setDescription(e.getMessage());
            response.getWriter().print(gson.toJson(data));
        }
    }

    protected void updateStatus(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        boolean isSuccess = daoImport.updateStatus(id);



        ResponseData data = new ResponseData();
        data.setIsSuccess(isSuccess);
        data.setDescription("");
        data.setData("");
        String json = gson.toJson(data);
        PrintWriter pw = response.getWriter();
        pw.print(json);
        pw.flush();
    }

    private void jsonResponse(HttpServletResponse response, boolean isSuccess, String description, Object data) throws IOException {
        ResponseData responseData = new ResponseData(isSuccess, description, data);
        String json = gson.toJson(responseData);
        PrintWriter pw = response.getWriter();
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        pw.print(json);
        pw.flush();
    }

    // === CATEGORY HANDLERS ===
    private void listCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Category> list = daoCategory.getAll();
        jsonResponse(response, true, "Success", list);
    }

    private void addCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String type = request.getParameter("type");
        String gender = request.getParameter("gender");

        if (type == null || type.trim().isEmpty() || gender == null || gender.trim().isEmpty()) {
            jsonResponse(response, false, "Type and Gender are required.", null);
            return;
        }

        Category newCategory = new Category(0, type, gender);
        boolean isSuccess = daoCategory.insert(newCategory);
        if (isSuccess) {
            jsonResponse(response, true, "Category added successfully.", null);
        } else {
            jsonResponse(response, false, "Failed to add category. Type/Gender might already exist.", null);
        }
    }

    private void updateCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String type = request.getParameter("type");
            String gender = request.getParameter("gender");

            if (type == null || type.trim().isEmpty() || gender == null || gender.trim().isEmpty()) {
                jsonResponse(response, false, "Type and Gender are required.", null);
                return;
            }

            Category category = new Category(id, type, gender);
            boolean isSuccess = daoCategory.update(category);

            if (isSuccess) {
                jsonResponse(response, true, "Category updated successfully.", null);
            } else {
                jsonResponse(response, false, "Failed to update category. Type/Gender might already exist.", null);
            }
        } catch (NumberFormatException e) {
            jsonResponse(response, false, "Invalid Category ID.", null);
        }
    }

    private void deleteCategory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean isInUse = daoCategory.isCategoryInUse(id);

            if (isInUse) {
                jsonResponse(response, false, "Cannot delete: This category is being used by one or more products.", null);
                return;
            }

            boolean isSuccess = daoCategory.delete(id);
            if (isSuccess) {
                jsonResponse(response, true, "Category deleted successfully.", null);
            } else {
                jsonResponse(response, false, "Failed to delete category.", null);
            }
        } catch (NumberFormatException e) {
            jsonResponse(response, false, "Invalid Category ID.", null);
        }
    }

    // === IMPORT HANDLERS ===
    protected void importList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int page = 1;
        int pageSize = 10;
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                page = Integer.parseInt(pageParam);
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        List<Imports> list = daoImport.getImportsByPage(page, pageSize);
        int totalRecords = daoImport.getTotalImports();
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        List<ImportDetail> listDetail = daoImportDetail.getAllImportDetail();
        Map<String, Object> combinedData = new HashMap<>();
        combinedData.put("list", list);
        combinedData.put("listDetail", listDetail);
        combinedData.put("currentPage", page);
        combinedData.put("totalPages", totalPages);
        combinedData.put("totalRecords", totalRecords);

        ResponseData data = new ResponseData();
        data.setIsSuccess(true);
        data.setData(combinedData);
        data.setDescription("Loaded page " + page);

        String json = gson.toJson(data);
        PrintWriter pw = response.getWriter();
        pw.print(json);
        pw.flush();
    }

    private void getProductsAndSizesForImport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Product> products = daoProduct.getAll();
            List<Size_detail> sizes = daoSize.getAll();

            Map<String, Object> data = new HashMap<>();
            data.put("products", products);
            data.put("sizes", sizes);

            jsonResponse(response, true, "Data loaded", data);
        } catch (Exception e) {
            jsonResponse(response, false, "Error loading data: " + e.getMessage(), null);
        }
    }

    private void createImport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Staff staff = (session != null) ? (Staff) session.getAttribute("staff") : null;
        if (staff == null) {
            jsonResponse(response, false, "Session expired. Please login again.", null);
            return;
        }
        int staff_id = staff.getStaff_id();
        String productsJson = request.getParameter("products");

        if (productsJson == null || productsJson.isEmpty() || productsJson.equals("[]")) {
            jsonResponse(response, false, "No products added to import list.", null);
            return;
        }

        try {
            long importDate = System.currentTimeMillis();
            java.sql.Date sqlDate = new java.sql.Date(importDate);

            Imports newImport = new Imports();
            newImport.setDate(sqlDate);
            newImport.setStaff_id(staff_id);
            newImport.setStatus("Pending");

            int newImportId = daoImport.insertImportAndGetId(newImport);
            if (newImportId == 0) {
                jsonResponse(response, false, "Could not create import record.", null);
                return;
            }

            ImportDetail[] productsToImport = gson.fromJson(productsJson, ImportDetail[].class);
            for (ImportDetail detail : productsToImport) {
                detail.setImportID(newImportId);
                daoImportDetail.insertImportDetail(detail);
            }

            jsonResponse(response, true, "Import list created successfully! Status: Pending.", null);
        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse(response, false, "Error processing import: " + e.getMessage(), null);
        }
    }

    // === PROFILE & ACCOUNT HANDLERS ===
    protected void changePassword(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String currentPassword = request.getParameter("currentPassword");
        currentPassword = getMd5(currentPassword);
        String newPassword = request.getParameter("newPassword");
        newPassword = getMd5(newPassword);
        String input = request.getParameter("input");
        boolean isSuccess = false;
        boolean isCorrect = daoStaff.checkLogin(input, currentPassword);
        if (isCorrect) {
            isSuccess = daoStaff.updatePasswordByEmailOrUsername(newPassword, input);
        }
        ResponseData data = new ResponseData();
        data.setIsSuccess(isSuccess);
        data.setDescription("");
        data.setData("");
        String json = gson.toJson(data);
        PrintWriter pw = response.getWriter();
        pw.print(json);
        pw.flush();
    }

    protected void updateProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String fullName = request.getParameter("fullName");

        boolean isSuccess = false;
        isSuccess = daoStaff.updateStaffProfile(username, email, address, phone, fullName);
        if (isSuccess) {
            try {
                jakarta.servlet.http.HttpSession session = request.getSession(false);
                if (session != null) {
                    Staff updatedStaff = daoStaff.getStaffByEmailOrUsername(username);
                    if (updatedStaff != null) {
                        session.setAttribute("staff", updatedStaff);
                    }
                }
            } catch (Exception e) {
                System.err.println("Error updating session after profile edit: " + e.getMessage());
            }
        }

        ResponseData data = new ResponseData();
        data.setIsSuccess(isSuccess);
        data.setData("");
        data.setDescription(isSuccess ? "Profile updated" : "Update failed");
        String json = gson.toJson(data);
        PrintWriter pw = response.getWriter();
        pw.print(json);
        pw.flush();
    }

    protected void addStaff(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        password = getMd5(password);
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String role = request.getParameter("role");

        ResponseData data = new ResponseData();
        boolean isSuccess = false;
        if (daoCustomer.isUsernameTaken(username)) {
            data.setIsSuccess(false);
            data.setDescription("Username already exists. Please choose another one.");
        } else {
            Staff s = new Staff(username, email, password, address, phone, fullName, role);
            isSuccess = daoStaff.signUp(s);

            data.setIsSuccess(isSuccess);
            if (!isSuccess) {
                data.setDescription("An error occurred during signup. Email might be taken.");
            }
        }

        data.setData("");
        String json = gson.toJson(data);
        PrintWriter pw = response.getWriter();
        pw.print(json);
        pw.flush();
    }

    protected void updateAccount(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String type = request.getParameter("type");
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        boolean isSuccess = false;

        if ("staff".equals(type)) {
            isSuccess = daoStaff.updateStaffProfile(username, email, address, phone, fullName);
        } else if ("customer".equals(type)) {
            isSuccess = daoCustomer.updateUserProfileByUsername(username, email, address, phone, fullName);
        }

        ResponseData data = new ResponseData();
        data.setIsSuccess(isSuccess);
        data.setData("");
        data.setDescription(isSuccess ? "Update successful" : "Update failed");
        String json = gson.toJson(data);
        PrintWriter pw = response.getWriter();
        pw.print(json);
        pw.flush();
    }

    protected void addProduct(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        // String quantity = ... (Đã xóa, không cần lấy nữa)
        String voucher = request.getParameter("voucher");

        daoVoucher.addIfNotExist(Integer.parseInt(voucher));
        int voucherId = daoVoucher.getIdVoucher(Integer.parseInt(voucher));

        String price = request.getParameter("price");
        String gender = request.getParameter("gender");
        String type = request.getParameter("type");
        String des = request.getParameter("des");
        String url = request.getParameter("url");

        int categoryID = daoCategory.getIdType(type, gender);
        if (url != null && url.length() > 11) {
            url = "/Project_SWP_Group2/images" + url.substring(11, url.length());
        }

        Product p = new Product(Integer.parseInt(price), categoryID, voucherId, name, des, url);

        // 1. Insert Product
        boolean isSuccess = daoProduct.insert(p);

        // 2. [FIX] Tự động tạo Size_detail S, M, L (Nếu insert product thành công)
        if (isSuccess) {
            // Lấy sản phẩm vừa tạo (thường là ID lớn nhất)
            List<Product> newProducts = daoProduct.sortNew();
            if (newProducts != null && !newProducts.isEmpty()) {
                int newProductId = newProducts.get(0).getId();
                // Giả sử bạn dùng Entity là Size_detail và DAO là Size_detailDAO (daoSize)
                daoSize.insert(new Size_detail("S", newProductId, 0));
                daoSize.insert(new Size_detail("M", newProductId, 0));
                daoSize.insert(new Size_detail("L", newProductId, 0));
            }
        }

        ResponseData data = new ResponseData();
        data.setIsSuccess(isSuccess);
        data.setData("");
        data.setDescription("");
        String json = gson.toJson(data);
        PrintWriter pw = response.getWriter();
        pw.print(json);
        pw.flush();
    }

    protected void updateProduct(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        Product p = daoProduct.getProductById(Integer.parseInt(id));

        String name = request.getParameter("name");
        String voucher = request.getParameter("voucher");

        daoVoucher.addIfNotExist(Integer.parseInt(voucher));
        int voucher_id = daoVoucher.getIdVoucher(Integer.parseInt(voucher));
        String price = request.getParameter("price");
        String description = request.getParameter("description");

        p.setName(name);
        p.setVoucherID(voucher_id);
        p.setPrice(Integer.parseInt(price));
        p.setDescription(description);

        boolean isSuccess = daoProduct.update(p);
        ResponseData data = new ResponseData();
        data.setIsSuccess(isSuccess);
        data.setData("");
        data.setDescription("");
        String json = gson.toJson(data);
        PrintWriter pw = response.getWriter();
        pw.print(json);
        pw.flush();
    }

    protected void deleteBoth(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        daoStaff.delete(username);
        daoCustomer.delete(username);

        ResponseData data = new ResponseData();
        data.setIsSuccess(true);
        data.setData("");
        data.setDescription("");
        String json = gson.toJson(data);
        PrintWriter pw = response.getWriter();
        pw.print(json);
        pw.flush();
    }

    protected void deleteStaff(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        boolean isSuccess = daoStaff.delete(username);

        ResponseData data = new ResponseData();
        data.setIsSuccess(isSuccess);
        data.setData("");
        if (!isSuccess) {
            data.setDescription("Could not delete staff. They may have related data (e.g., orders, imports).");
        }

        String json = gson.toJson(data);
        PrintWriter pw = response.getWriter();
        pw.print(json);
        pw.flush();
    }

    protected void deleteCustomer(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        boolean isSuccess = daoCustomer.delete(username);

        ResponseData data = new ResponseData();
        data.setIsSuccess(isSuccess);
        data.setData("");
        if (!isSuccess) {
            data.setDescription("Could not delete customer. They may have related data (e.g., orders, cart, feedback).");
        }

        String json = gson.toJson(data);
        PrintWriter pw = response.getWriter();
        pw.print(json);
        pw.flush();
    }

    protected void searchAccount(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String input = request.getParameter("input");
        input = "%" + input + "%";
        List<Staff> list = daoStaff.search(input);
        ResponseData data = new ResponseData();
        data.setIsSuccess(true);
        data.setData(list);
        data.setDescription("");
        String json = gson.toJson(data);
        PrintWriter pw = response.getWriter();
        pw.print(json);
        pw.flush();
    }

    protected void accountList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Customer> listCustomer = daoCustomer.getAll();
        List<Staff> listStaff = daoStaff.getAll();

        ResponseData data = new ResponseData();
        data.setIsSuccess(true);

        Map<String, Object> combinedData = new HashMap<>();
        combinedData.put("customers", listCustomer);
        combinedData.put("staffs", listStaff);
        data.setData(combinedData);

        data.setDescription("");
        String json = gson.toJson(data);
        PrintWriter pw = response.getWriter();
        pw.print(json);
        pw.flush();
    }

    protected void deleteProduct(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        int id = Integer.parseInt(idStr);

        daoSize.deleteByProductId(id);

        boolean isSuccess = daoProduct.delete(id);

        ResponseData data = new ResponseData();
        data.setIsSuccess(isSuccess);
        data.setData("");

        if (!isSuccess) {
            data.setDescription("Cannot delete product. It might be in an Order or Cart.");
        } else {
            data.setDescription("Product deleted successfully.");
        }

        String json = gson.toJson(data);
        PrintWriter pw = response.getWriter();
        pw.print(json);
        pw.flush();
    }

    protected void profile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Cookie[] cookies = request.getCookies();
        String input = "";
        for (Cookie cooky : cookies) {
            if (cooky.getName().equals("input")) {
                input = cooky.getValue();
                break;
            }
        }
        Staff c = null;
        if (!input.equals("")) {
            c = daoStaff.getStaffByEmailOrUsername(input);
        }

        ResponseData data = new ResponseData();
        data.setIsSuccess(true);
        data.setData(c);
        data.setDescription("");
        String json = gson.toJson(data);
        PrintWriter pw = response.getWriter();
        pw.print(json);
        pw.flush();
    }

    protected void searchProduct(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String input = request.getParameter("input");
        input = "%" + input + "%";
        List<Product> productList = daoProduct.search(input);
        ResponseData data = new ResponseData();
        data.setIsSuccess(true);
        data.setData(productList);
        data.setDescription("");
        String json = gson.toJson(data);
        PrintWriter pw = response.getWriter();
        pw.print(json);
        pw.flush();
    }

    protected void sort(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String option = request.getParameter("option");
        List<Product> productList = null;
        if (option.equals("Increase")) {
            productList = daoProduct.sortIncrease();
        } else if (option.equals("Decrease")) {
            productList = daoProduct.sortDecrease();
        }

        ResponseData data = new ResponseData();
        data.setIsSuccess(true);
        data.setData(productList);
        data.setDescription("");
        String json = gson.toJson(data);
        PrintWriter pw = response.getWriter();
        pw.print(json);
        pw.flush();
    }

    protected void listProduct(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Product> list = daoProduct.getAll();
        request.setAttribute("productList", list);

        boolean isSuccess = false;
        if (list != null) {
            isSuccess = true;
        }

        ResponseData data = new ResponseData();
        data.setIsSuccess(isSuccess);
        data.setData(list);
        data.setDescription("");
        String json = gson.toJson(data);
        PrintWriter pw = response.getWriter();
        pw.print(json);
        pw.flush();
    }

    // === CUSTOMER MANAGE HANDLERS ===
    protected void listCustomers(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        List<Customer> list = daoCustomer.getAll();
        ResponseData data = new ResponseData();
        data.setIsSuccess(true);
        data.setDescription("");
        data.setData(list);

        String json = gson.toJson(data);
        PrintWriter pw = response.getWriter();
        pw.print(json);
        pw.flush();
    }

    protected void searchCustomers(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String keyword = request.getParameter("input");
        if (keyword == null) {
            keyword = "";
        }
        keyword = keyword.trim();

        List<Customer> list;
        if (keyword.isEmpty()) {
            list = daoCustomer.getAll();
        } else {
            list = daoCustomer.search(keyword);
        }

        ResponseData data = new ResponseData();
        data.setIsSuccess(true);
        data.setDescription("");
        data.setData(list);

        String json = gson.toJson(data);
        PrintWriter pw = response.getWriter();
        pw.print(json);
        pw.flush();
    }

    protected void customerOrders(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idStr = request.getParameter("id");
        int customerId;
        try {
            customerId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            ResponseData data = new ResponseData();
            data.setIsSuccess(false);
            data.setDescription("Invalid customer id");
            data.setData(null);

            String json = gson.toJson(data);
            PrintWriter pw = response.getWriter();
            pw.print(json);
            pw.flush();
            return;
        }

        List<Orders> orders = daoOrder.getOrdersByCustomerID(customerId);

        Map<String, Object> dataMap = new HashMap<>();
        dataMap.put("orders", orders);
        ResponseData data = new ResponseData();
        data.setIsSuccess(true);
        data.setDescription("");
        data.setData(dataMap);

        String json = gson.toJson(data);
        PrintWriter pw = response.getWriter();
        pw.print(json);
        pw.flush();
    }

    // === UTILS ===
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
    public String getServletInfo() {
        return "Staff Controller";
    }
}
