/*
 * File: StaffController.java
 */
package controller;

import DAO.CategoryDAO;
import DAO.CustomerDAO;
import DAO.ImportDAO;
import DAO.ImportDetailDAO;
import DAO.ProductDAO;
import DAO.PromoDAO;
import DAO.SizeDAO;
import DAO.StaffDAO;
import DAO.OrderDAO;              // <-- THÊM
import com.google.gson.Gson;
import entity.Category;
import entity.Customer;
import entity.ImportDetail;
import entity.Imports;
import entity.Product;
import entity.Staff;
import entity.Orders;            // <-- THÊM
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;      // <-- THÊM cho List<Map<...>>
import payLoad.ResponseData;
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

@WebServlet(
    name = "staffController",
    urlPatterns = {
        URL_IMPORT_UPDATE_STAFF,
        URL_IMPORT_STAFF,
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
        // === 3 URL CHO CUSTOMER MANAGE (staff.jsp đang gọi) ===
        "/staff/customer",
        "/staff/customer/search",
        "/staff/customer/detail"
    }
)
public class StaffController extends HttpServlet {

    StaffDAO daoStaff = new StaffDAO();
    CustomerDAO daoCustomer = new CustomerDAO();
    ProductDAO daoProduct = new ProductDAO();
    CategoryDAO daoCategory = new CategoryDAO();
    ImportDetailDAO daoImportDetail = new ImportDetailDAO();
    ImportDAO daoImport = new ImportDAO();
    SizeDAO daoSize = new SizeDAO();
    PromoDAO daoPromo = new PromoDAO();
    OrderDAO daoOrder = new OrderDAO();    // dùng cho các chỗ cũ của em
    private Gson gson = new Gson();

    // THÊM: DAO dùng riêng cho các hàm handle* (giữ đúng tên như trong StaffCustomerController)
    private CustomerDAO customerDAO = new CustomerDAO();
    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");   // giống bên StaffCustomerController
        String urlPath = request.getServletPath();

        switch (urlPath) {
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

            // === 3 CASE CUSTOMER (DÙNG HÀM handle* từ StaffCustomerController) ===
            case "/staff/customer":
                try {
                    handleListCustomers(request, response);
                } catch (Exception e) {
                    e.printStackTrace();
                    writeError(response, "Server error: " + e.getMessage());
                }
                break;
            case "/staff/customer/search":
                try {
                    handleSearchCustomers(request, response);
                } catch (Exception e) {
                    e.printStackTrace();
                    writeError(response, "Server error: " + e.getMessage());
                }
                break;
            case "/staff/customer/detail":
                try {
                    handleCustomerDetail(request, response);
                } catch (Exception e) {
                    e.printStackTrace();
                    writeError(response, "Server error: " + e.getMessage());
                }
                break;
        }
    }

    // Cho chắc: nếu có request GET tới mấy URL này thì cũng xử lý như POST
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doPost(req, resp);
    }

    protected void updateStatus(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        boolean isSuccess = daoImport.updateStatus(id);
        List<ImportDetail> listToImport = daoImportDetail.getListToImport(id);

        for (ImportDetail detail : listToImport) {
            int quantityProduct = daoProduct.getProductQuantity(detail.getProductID());
            daoProduct.updateQuantity(detail.getProductID(), quantityProduct + detail.getQuantity());
            int quantitySize = daoSize.getSizeQuantity(detail.getProductID(), detail.getSizeName());
            daoSize.updateQuanSize(quantitySize + detail.getQuantity(), detail.getProductID(), detail.getSizeName());
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

    // === CÁC HÀM MỚI XỬ LÍ CHO CATEGORY ===

    private void jsonResponse(HttpServletResponse response, boolean isSuccess, String description, Object data) throws IOException {
        ResponseData responseData = new ResponseData(isSuccess, description, data);
        String json = gson.toJson(responseData);
        PrintWriter pw = response.getWriter();
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        pw.print(json);
        pw.flush();
    }

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
    // === KẾT THÚC CÁC HÀM CATEGORY ===

    protected void importList(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Imports> list = daoImport.getAllImport();
        List<ImportDetail> listDetail = daoImportDetail.getAllImportDetail();

        Map<String, Object> combinedData = new HashMap<>();
        combinedData.put("list", list);
        combinedData.put("listDetail", listDetail);

        ResponseData data = new ResponseData();
        data.setIsSuccess(true);
        data.setData(combinedData);
        data.setDescription("");
        String json = gson.toJson(data);
        PrintWriter pw = response.getWriter();
        pw.print(json);
        pw.flush();
    }

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
                System.err.println("Lỗi khi cập nhật session sau khi edit profile: " + e.getMessage());
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
        String quantity = request.getParameter("quantity");
        String promo = request.getParameter("promo");

        daoPromo.addIfNotExist(Integer.parseInt(promo));

        int promoId = daoPromo.getIdPromo(Integer.parseInt(promo));

        String price = request.getParameter("price");
        String gender = request.getParameter("gender");
        String type = request.getParameter("type");
        String des = request.getParameter("des");
        String url = request.getParameter("url");
        int categoryID = daoCategory.getIdType(type, gender);
        url = "/Project_SWP_Group2/images" + url.substring(11, url.length());
        Product p = new Product(Integer.parseInt(quantity), Integer.parseInt(price), categoryID, promoId, name, des, url);
        boolean isSuccess = daoProduct.insert(p);
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
        String promo = request.getParameter("promo");

        daoPromo.addIfNotExist(Integer.parseInt(promo));
        int promo_id = daoPromo.getIdPromo(Integer.parseInt(promo));
        String price = request.getParameter("price");
        String description = request.getParameter("description");

        p.setName(name);
        p.setPromoID(promo_id);
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
        String id = request.getParameter("id");
        boolean isSuccess = daoProduct.delete(Integer.parseInt(id));
        ResponseData data = new ResponseData();
        data.setIsSuccess(isSuccess);
        data.setData("");
        data.setDescription("");
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
        } else {

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

    protected void login(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String input = request.getParameter("input");
        String password = request.getParameter("password");
        password = getMd5(password);

        Staff s = daoStaff.getStaffByEmailOrUsernameAndPassword(input, password);
        if (s != null) {
            request.getSession().setAttribute("staff", s);
            if ("admin".equalsIgnoreCase(s.getRole())) {
                response.sendRedirect(request.getContextPath() + "/admin?tab=dashboard");
            } else if ("staff".equalsIgnoreCase(s.getRole())) {
                response.sendRedirect(request.getContextPath() + "/staff.jsp");
            } else {
                request.setAttribute("message", "<div id='message' style='color:red'>Role không hợp lệ!</div>");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }

        } else {
            request.setAttribute("message", "<div id='message' style='color:red'>Incorrect username or password</div>");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
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

    // ================== CÁC HÀM handle* LẤY TỪ StaffCustomerController ==================

    // 1) /staff/customer -> LIST ALL
    private void handleListCustomers(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        // dùng hàm bạn đã có trong DAO
        List<Customer> customers = customerDAO.getAllCustomers();

        List<Map<String, Object>> data = new ArrayList<>();
        for (Customer c : customers) {
            Map<String, Object> m = new HashMap<>();
            // key phải trùng với JS trong staff.jsp (renderCustomerRows):
            // cst.customer_id, cst.username, cst.fullName, cst.email, cst.phoneNumber, cst.address
            m.put("customer_id", c.getCustomer_id());
            m.put("username", c.getUsername());
            m.put("fullName", c.getFullName());
            m.put("email", c.getEmail());
            m.put("phoneNumber", c.getPhoneNumber());
            m.put("address", c.getAddress());
            data.add(m);
        }

        Map<String, Object> result = new HashMap<>();
        result.put("isSuccess", true);
        result.put("data", data);

        writeJson(response, result);
    }

    // 2) /staff/customer/search -> SEARCH
    private void handleSearchCustomers(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String input = request.getParameter("input");
        if (input == null) {
            input = "";
        }
        input = input.trim();

        List<Customer> customers;
        if (input.isEmpty()) {
            customers = customerDAO.getAllCustomers();
        } else {
            // dùng hàm search(String keyword) bạn đã viết
            customers = customerDAO.search(input);
        }

        List<Map<String, Object>> data = new ArrayList<>();
        for (Customer c : customers) {
            Map<String, Object> m = new HashMap<>();
            m.put("customer_id", c.getCustomer_id());
            m.put("username", c.getUsername());
            m.put("fullName", c.getFullName());
            m.put("email", c.getEmail());
            m.put("phoneNumber", c.getPhoneNumber());
            m.put("address", c.getAddress());
            data.add(m);
        }

        Map<String, Object> result = new HashMap<>();
        result.put("isSuccess", true);
        result.put("data", data);

        writeJson(response, result);
    }

    // 3) /staff/customer/detail -> ORDERS BY CUSTOMER
    private void handleCustomerDetail(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String idRaw = request.getParameter("id");
        int customerId;
        try {
            customerId = Integer.parseInt(idRaw);
        } catch (NumberFormatException e) {
            writeError(response, "Invalid customer id");
            return;
        }

        // cần có hàm này trong OrderDAO: getOrdersByCustomerID(int customerId)
        List<Orders> orders = orderDAO.getOrdersByCustomerID(customerId);

        List<Map<String, Object>> ordersList = new ArrayList<>();
        for (Orders o : orders) {
            Map<String, Object> m = new HashMap<>();
            m.put("orderID", o.getOrderID());
            m.put("date", o.getDate());
            m.put("address", o.getAddress());
            m.put("phoneNumber", o.getPhoneNumber()); // nếu entity là getPhone_number() thì đổi lại
            m.put("status", o.getStatus());
            m.put("total", o.getTotal());
            ordersList.add(m);
        }

        Map<String, Object> data = new HashMap<>();
        data.put("orders", ordersList);

        Map<String, Object> result = new HashMap<>();
        result.put("isSuccess", true);
        result.put("data", data);

        writeJson(response, result);
    }

    // ================== UTIL JSON CHO CÁC HÀM handle* ==================
    private void writeJson(HttpServletResponse response, Object obj) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.print(gson.toJson(obj));
            out.flush();
        }
    }

    private void writeError(HttpServletResponse response, String message) throws IOException {
        Map<String, Object> result = new HashMap<>();
        result.put("isSuccess", false);
        result.put("message", message);
        writeJson(response, result);
    }

    // ================== THÊM PHẦN CUSTOMER MANAGE CŨ CỦA EM (HIỆN CHƯA DÙNG) ==================
    // /staff/customer  → trả về list customer (JS: listCustomers())
    private void listCustomersAjax(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        List<Customer> list = daoCustomer.getAllCustomers();   // đã viết trong CustomerDAO
        jsonResponse(response, true, "", list);
    }

    // /staff/customer/search  → search theo name/email/username (JS: searchCustomers)
    private void searchCustomersAjax(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String keyword = request.getParameter("input");
        if (keyword == null) keyword = "";
        keyword = keyword.trim();

        List<Customer> list;
        if (keyword.isEmpty()) {
            list = daoCustomer.getAllCustomers();
        } else {
            list = daoCustomer.search(keyword);
        }
        jsonResponse(response, true, "", list);
    }

    // /staff/customer/detail → trả list order của 1 customer (JS: loadCustomerOrders)
    private void customerOrdersAjax(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idStr = request.getParameter("id");
        int customerId;
        try {
            customerId = Integer.parseInt(idStr);
        } catch (Exception e) {
            jsonResponse(response, false, "Invalid customer id", null);
            return;
        }

        List<Orders> orders = daoOrder.getOrdersByCustomerID(customerId);

        Map<String, Object> data = new HashMap<>();
        data.put("orders", orders);

        jsonResponse(response, true, "", data);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
