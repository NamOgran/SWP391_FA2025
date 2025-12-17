package controller;

import DAO.CartDAO;
import DAO.CategoryDAO;
import DAO.CustomerDAO;
import DAO.FeedBackDAO;
import DAO.ImportDAO;
import DAO.ImportDetailDAO;
import DAO.OrderDAO;
import DAO.ProductDAO;
import DAO.VoucherDAO;
import DAO.Size_detailDAO;
import DAO.StaffDAO;
import DAO.StatsDAO;
import DAO.StatsDAO.ChartData;
import DAO.StatsDAO.OrderPopupData;
import DAO.StatsDAO.TopProduct;
import com.google.gson.Gson;
import entity.Category;
import entity.Customer;
import entity.ImportDetail;
import entity.Imports;
import entity.OrderDetail;
import entity.Orders;
import entity.Product;
import entity.Voucher;
import entity.Size_detail;
import entity.Staff;
import entity.Stats;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import payLoad.ResponseData;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.math.BigInteger;
import java.net.URLEncoder;
import java.nio.file.Paths;
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
import java.util.stream.Collectors;
import org.json.JSONArray;
import org.json.JSONObject;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.nio.file.Path;

@WebServlet(name = "AdminController", urlPatterns = {"/admin"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class AdminController extends HttpServlet {

    private int parseIntSafe(String value, int defaultValue) {
        try {
            return (value == null || value.trim().isEmpty()) ? defaultValue : Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private String encode(String value) {
        if (value == null) {
            return "";
        }
        try {
            return URLEncoder.encode(value, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            return value;
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

    private String processUploadFile(HttpServletRequest request) {
        try {
            Part filePart = request.getPart("file");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                fileName = System.currentTimeMillis() + "_" + fileName.replaceAll("\\s+", "_");

                String applicationPath = request.getServletContext().getRealPath("");
                String uploadPath = applicationPath + File.separator + "images";

                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }

                String targetFilePath = uploadPath + File.separator + fileName;
                filePart.write(targetFilePath);

                File deployDir = new File(applicationPath);
                File targetDir = deployDir.getParentFile();
                File projectRoot = targetDir.getParentFile();

                String srcPath = projectRoot.getAbsolutePath() + File.separator + "src"
                        + File.separator + "main" + File.separator + "webapp" + File.separator + "images";

                File srcDir = new File(srcPath);
                if (srcDir.exists()) {
                    Path source = Paths.get(targetFilePath);
                    Path destination = Paths.get(srcPath + File.separator + fileName);
                    Files.copy(source, destination, StandardCopyOption.REPLACE_EXISTING);
                }

                return "images/" + fileName;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        Staff s = (session != null) ? (Staff) session.getAttribute("staff") : null;

        if (s == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        if (!"admin".equalsIgnoreCase(s.getRole())) {
            response.sendRedirect(request.getContextPath() + "/staff");
            return;
        }

        String action = request.getParameter("action");

        // --- API: VOUCHER DATA ---
        if ("voucher_data".equals(action)) {
            String voucherSearch = request.getParameter("search");
            int voucherPageIndex = parseIntSafe(request.getParameter("page"), 1);
            int voucherPageSize = 10;

            VoucherDAO voucherDAO = new VoucherDAO();
            int totalVouchers = voucherDAO.getTotalVoucherCount(voucherSearch);
            int voucherTotalPages = (int) Math.ceil((double) totalVouchers / voucherPageSize);
            List<Voucher> voucherList = voucherDAO.getPaginatedVouchers(voucherSearch, voucherPageIndex, voucherPageSize);

            Map<String, Object> data = new HashMap<>();
            data.put("list", voucherList);
            data.put("totalPages", voucherTotalPages);
            data.put("currentPage", voucherPageIndex);
            data.put("totalItems", totalVouchers);

            response.setContentType("application/json");
            response.getWriter().write(new Gson().toJson(data));
            return;
        }

        // --- API: PRODUCT RELATED DATA ---
        if ("get_product_related_data".equals(action)) {
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            Gson gson = new Gson();
            try {
                int productId = Integer.parseInt(request.getParameter("productId"));
                Size_detailDAO sizeDAO = new Size_detailDAO();
                CartDAO cartDAO = new CartDAO();
                OrderDAO orderDAO = new OrderDAO();
                ImportDetailDAO importDetailDAO = new ImportDetailDAO();
                FeedBackDAO feedbackDAO = new FeedBackDAO();

                Map<String, Object> relatedData = new HashMap<>();
                relatedData.put("sizes", sizeDAO.getSizesByProductId(productId));
                relatedData.put("carts", cartDAO.getCartItemsByProductId(productId));
                relatedData.put("orders", orderDAO.getOrderDetailsByProductId(productId));
                relatedData.put("imports", importDetailDAO.getImportDetailsByProductId(productId));
                relatedData.put("feedbacks", feedbackDAO.getFeedbackByProductId(productId));

                out.print(gson.toJson(relatedData));
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson("Invalid Product ID"));
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print(gson.toJson("Server Error: " + e.getMessage()));
            }
            return;
        }

        // --- [NEW] API: ACCOUNT RELATED DATA (Customer/Staff) ---
        if ("get_account_related_data".equals(action)) {
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            Gson gson = new Gson();
            try {
                String type = request.getParameter("type");
                int id = Integer.parseInt(request.getParameter("id"));

                Map<String, Object> relatedData = new HashMap<>();

                if ("customer".equals(type)) {
                    CartDAO cartDAO = new CartDAO();
                    FeedBackDAO feedbackDAO = new FeedBackDAO();
                    OrderDAO orderDAO = new OrderDAO();

                    relatedData.put("carts", cartDAO.getAll(id));
                    relatedData.put("feedbacks", feedbackDAO.getFeedbackByCustomerId(id));
                    relatedData.put("orders", orderDAO.orderUser(id));

                } else if ("staff".equals(type)) {
                    OrderDAO orderDAO = new OrderDAO();
                    ImportDAO importDAO = new ImportDAO();

                    relatedData.put("orders", orderDAO.getOrdersByStaffId(id));
                    relatedData.put("imports", importDAO.getImportsByStaffId(id));
                }

                out.print(gson.toJson(relatedData));

            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson("Invalid Account ID"));
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print(gson.toJson("Server Error: " + e.getMessage()));
            }
            return;
        }

        // --- API: VOUCHER RELATED DATA ---
        if ("get_voucher_related_data".equals(action)) {
            response.setContentType("application/json");
            PrintWriter out = response.getWriter();
            Gson gson = new Gson();
            try {
                String voucherId = request.getParameter("voucherId");
                if (voucherId == null) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson("Missing Voucher ID"));
                    return;
                }
                ProductDAO productDAO = new ProductDAO();
                List<Product> products = productDAO.getProductsByVoucherId(voucherId);
                out.print(gson.toJson(products));
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print(gson.toJson("Server Error: " + e.getMessage()));
            }
            return;
        }

        // --- ACTION: TOGGLE PRODUCT STATUS ---
        if ("toggle_product_status".equals(action)) {
            int id = 0;
            try {
                id = Integer.parseInt(request.getParameter("id"));
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/admin?tab=product&msg=invalid_id");
                return;
            }

            ProductDAO dao = new ProductDAO();
            Product p = dao.getProductById(id);
            if (p == null) {
                response.sendRedirect(request.getContextPath() + "/admin?tab=product&msg=not_found");
                return;
            }

            boolean newStatus = !p.isIs_active();
            boolean success = dao.toggleActiveStatus(id, newStatus);

            String page = request.getParameter("page");
            String sort = request.getParameter("sort");
            String search = request.getParameter("search");
            String category = request.getParameter("category");
            String status = request.getParameter("status");
            String msg = "toggle_failed";
            if (success) {
                msg = newStatus ? "activated" : "deactivated";
            }

            StringBuilder redirectUrl = new StringBuilder(request.getContextPath() + "/admin");
            redirectUrl.append("?tab=product&msg=").append(encode(msg));

            if (page != null && !page.isEmpty()) {
                redirectUrl.append("&page=").append(encode(page));
            }
            if (sort != null && !sort.isEmpty()) {
                redirectUrl.append("&sort=").append(encode(sort));
            }
            if (search != null && !search.isEmpty()) {
                redirectUrl.append("&search=").append(encode(search));
            }
            if (category != null && !category.isEmpty() && !category.equals("0")) {
                redirectUrl.append("&category=").append(encode(category));
            }
            if (status != null && !status.isEmpty() && !status.equals("all")) {
                redirectUrl.append("&status=").append(encode(status));
            }

            response.sendRedirect(redirectUrl.toString());
            return;
        }

        // --- DASHBOARD AND TABS LOGIC ---
        String tab = request.getParameter("tab");
        if (tab == null || tab.isEmpty()) {
            tab = "dashboard";
        }

        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        VoucherDAO voucherDAO = new VoucherDAO();
        StaffDAO staffDAO = new StaffDAO();
        CustomerDAO customerDAO = new CustomerDAO();
        StatsDAO statsDAO = new StatsDAO();
        OrderDAO orderDAO = new OrderDAO();
        ImportDAO importDAO = new ImportDAO();
        ImportDetailDAO importDetailDAO = new ImportDetailDAO();
        Size_detailDAO size_detailDAO = new Size_detailDAO();

        String forwardPage = "/admin_Dashboard.jsp";

        switch (tab) {
            case "product": {
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
                request.setAttribute("productSizeMap", productSizeMap);
                request.setAttribute("totalProducts", totalProducts);
                request.setAttribute("list", productList);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("currentPage", pageIndex);
                request.setAttribute("searchName", searchName);
                request.setAttribute("sortBy", sortBy);
                request.setAttribute("selectedCategory", categoryId);
                request.setAttribute("selectedStatus", status);

                List<Category> cateList = categoryDAO.getAll();
                Map<Integer, String> categoryMap = new HashMap<>();
                for (Category c : cateList) {
                    categoryMap.put(c.getCategory_id(), c.getType() + " (" + c.getGender() + ")");
                }
                request.setAttribute("categoryMap", categoryMap);
                request.setAttribute("cateList", cateList);

                Map<String, String> voucherProductMap = new HashMap<>();
                List<Voucher> allVouchers = voucherDAO.getAll();
                for (Voucher p : allVouchers) {
                    if (p.getVoucherPercent() == 0) {
                        voucherProductMap.put(p.getVoucherID(), "None");
                    } else {
                        voucherProductMap.put(p.getVoucherID(), p.getVoucherPercent() + "%");
                    }
                }
                request.setAttribute("voucherMap", voucherProductMap);
                request.setAttribute("voucherList", allVouchers);
                forwardPage = "/admin_ProductManagement.jsp";
                break;
            }
            case "staff_account": {
                String accountSearch = request.getParameter("search_account");
                int accountPageIndex = parseIntSafe(request.getParameter("account_page"), 1);
                int accountPageSize = 10;
                List<Staff> allStaff = staffDAO.getAll();
                final String finalAccountSearch = (accountSearch == null || accountSearch.isEmpty()) ? null : accountSearch.toLowerCase();
                List<Staff> filteredStaff = allStaff.stream()
                        .filter(staff -> !"admin".equalsIgnoreCase(staff.getRole()))
                        .filter(staff -> (finalAccountSearch == null || staff.getUsername().toLowerCase().contains(finalAccountSearch)))
                        .collect(Collectors.toList());
                int totalAccounts = filteredStaff.size();
                int accountTotalPages = (int) Math.ceil((double) totalAccounts / accountPageSize);
                int startIndex = (accountPageIndex - 1) * accountPageSize;
                int endIndex = Math.min(startIndex + accountPageSize, totalAccounts);
                List<Staff> paginatedStaff = (totalAccounts > 0 && startIndex < endIndex) ? filteredStaff.subList(startIndex, endIndex) : Collections.emptyList();
                request.setAttribute("staffList", paginatedStaff);
                request.setAttribute("totalStaffs", totalAccounts);
                request.setAttribute("accountTotalPages", accountTotalPages);
                request.setAttribute("accountCurrentPage", accountPageIndex);
                request.setAttribute("accountSearch", accountSearch);
                forwardPage = "/admin_StaffManagement.jsp";
                break;
            }
            case "customer_manage": {
                String custSearch = request.getParameter("cust_search");
                List<Customer> allCust = customerDAO.getAll();
                List<Customer> filteredCust = new ArrayList<>();
                if (custSearch != null && !custSearch.trim().isEmpty()) {
                    String k = custSearch.toLowerCase();
                    for (Customer c : allCust) {
                        if ((c.getUsername() != null && c.getUsername().toLowerCase().contains(k))
                                || (c.getFullName() != null && c.getFullName().toLowerCase().contains(k))
                                || (c.getPhoneNumber() != null && c.getPhoneNumber().contains(k))) {
                            filteredCust.add(c);
                        }
                    }
                } else {
                    filteredCust = allCust;
                }
                // Sắp xếp ID giảm dần (Mới nhất lên đầu)
Collections.sort(filteredCust, (c1, c2) -> Integer.compare(c2.getCustomer_id(), c1.getCustomer_id()));
                request.setAttribute("customerList", filteredCust);
                request.setAttribute("custTotal", filteredCust.size());
                forwardPage = "/admin_CustomerManagement.jsp";
                break;
            }
            case "voucher": {
                forwardPage = "/admin_VoucherManagement.jsp";
                break;
            }
            case "order": {
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
                Map<Integer, String> productVoucherMap = new HashMap<>();
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
                    productVoucherMap.put(p.getId(), p.getVoucherID());
                    picUrlMap.put(p.getId(), p.getPicURL());

                    String catName = categoryNames.getOrDefault(p.getCategoryID(), "Unknown");
                    productCategoryMap.put(p.getId(), catName);
                }
                request.setAttribute("productNameMap", productNameMap);
                request.setAttribute("productPriceMap", productPriceMap);
                request.setAttribute("productVoucherMap", productVoucherMap);
                request.setAttribute("picUrlMap", picUrlMap);
                request.setAttribute("productCategoryMap", productCategoryMap);

                Map<String, Integer> voucherValMap = new HashMap<>();
                List<Voucher> vouchers = voucherDAO.getAll();
                for (Voucher p : vouchers) {
                    voucherValMap.put(p.getVoucherID(), p.getVoucherPercent());
                }
                request.setAttribute("voucherMap", voucherValMap);

                Map<Integer, Long> calculatedTotalMap = new HashMap<>();
                Map<Integer, Long> subTotalMap = new HashMap<>();
                Map<Integer, Integer> shippingFeeMap = new HashMap<>();

                for (Orders o : orderList) {
                    long subTotal = 0;
                    for (OrderDetail d : orderDetailList) {
                        if (d.getOrderID() == o.getOrderID()) {
                            int pId = d.getProductID();
                            int price = productPriceMap.getOrDefault(pId, 0);
                            String voucherId = productVoucherMap.getOrDefault(pId, null);
                            int percent = (voucherId != null) ? voucherValMap.getOrDefault(voucherId, 0) : 0;
                            long finalPrice = price - (price * percent / 100L);
                            subTotal += (finalPrice * d.getQuantity());
                        }
                    }

                    int shippingFee = 0;
                    if (subTotal < 200000) {
                        shippingFee = 20000;
                    } else {
                        shippingFee = 0;
                    }

                    long finalTotal = subTotal + shippingFee;

                    subTotalMap.put(o.getOrderID(), subTotal);
                    shippingFeeMap.put(o.getOrderID(), shippingFee);
                    calculatedTotalMap.put(o.getOrderID(), finalTotal);
                }

                request.setAttribute("subTotalMap", subTotalMap);
                request.setAttribute("shippingFeeMap", shippingFeeMap);
                request.setAttribute("calculatedTotalMap", calculatedTotalMap);

                request.setAttribute("totalOrders", orderList.size());
                request.setAttribute("orderList", orderList);
                request.setAttribute("orderDetailList", orderDetailList);
                forwardPage = "/admin_OrderManagement.jsp";
                break;
            }
            case "import": {
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
                    String catName = catNameMap.getOrDefault(p.getCategoryID(), "Unknown");
                    productCategoryMap.put(p.getId(), catName);
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

                forwardPage = "/admin_ImportManagement.jsp";
                break;
            }
            case "personal":
                forwardPage = "/admin_PersonalInformation.jsp";
                break;
            case "api_chart_data": {
                int year = parseIntSafe(request.getParameter("year"), LocalDate.now().getYear());
                List<ChartData> dbData = statsDAO.getMonthlyStatsByYear(year);
                double[] revenueData = new double[12];
                int[] ordersData = new int[12];
                for (int i = 0; i < 12; i++) {
                    revenueData[i] = dbData.get(i).revenue;
                    ordersData[i] = dbData.get(i).orders;
                }
                response.setContentType("application/json");
                Gson gson = new Gson();
                Map<String, Object> jsonResponse = new HashMap<>();
                jsonResponse.put("revenue", revenueData);
                jsonResponse.put("orders", ordersData);
                response.getWriter().write(gson.toJson(jsonResponse));
                return;
            }
            case "dashboard":
            default: {
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
                request.setAttribute("displayFrom", fromDate.toString());
                request.setAttribute("displayTo", toDate.toString());
                request.setAttribute("numberOfProduct", statsDAO.getAllProductSizeDetail());
                request.setAttribute("numberOfCustomer", statsDAO.getAllCustomersCount());
                Stats statsRange = statsDAO.getStatsByDateRange(sqlFrom, sqlTo);
                request.setAttribute("numberOfOrder", statsRange != null ? statsRange.getTotalOrders() : 0);
                request.setAttribute("revenue", statsRange != null ? (int) statsRange.getTotalRevenue() : 0);
                Map<String, Integer> orderMap = statsDAO.getOrderStatusCounts(sqlFrom, sqlTo);
                int totalOrdersChart = 0;
                if (orderMap != null) {
                    for (int val : orderMap.values()) {
                        totalOrdersChart += val;
                    }
                }
                String[] fixedStatuses = {"Pending", "Preparing", "Delivering", "Delivered", "Cancelled", "Returned"};
                List<String> sortedLabels = new ArrayList<>();
                List<Integer> sortedData = new ArrayList<>();
                for (String label : fixedStatuses) {
                    sortedLabels.add(label);
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
                    sortedData.add(count);
                }
                Gson gson = new Gson();
                request.setAttribute("orderStatsLabels", gson.toJson(sortedLabels));
                request.setAttribute("orderStatsData", gson.toJson(sortedData));
                request.setAttribute("totalOrdersChart", totalOrdersChart);
                List<OrderPopupData> popupList = statsDAO.getOrdersForPopup(sqlFrom, sqlTo);
                request.setAttribute("popupList", popupList != null ? popupList : new ArrayList<>());
                int currentYear = now.getYear();
                request.setAttribute("currentYear", currentYear);
                List<ChartData> yearData = statsDAO.getMonthlyStatsByYear(currentYear);
                double[] fullRevenue = new double[12];
                int[] fullOrders = new int[12];
                if (yearData != null) {
                    for (ChartData data : yearData) {
                        int mIndex = data.month - 1;
                        if (mIndex >= 0 && mIndex < 12) {
                            fullRevenue[mIndex] = data.revenue;
                            fullOrders[mIndex] = data.orders;
                        }
                    }
                }
                request.setAttribute("chartRevenue", gson.toJson(fullRevenue));
                request.setAttribute("chartOrders", gson.toJson(fullOrders));
                List<TopProduct> bestSellers = statsDAO.getBestSellers(5);
                request.setAttribute("bestSellers", bestSellers != null ? bestSellers : new ArrayList<>());
                List<TopProduct> allBestSellers = statsDAO.getBestSellers(100);
                request.setAttribute("allBestSellers", allBestSellers != null ? allBestSellers : new ArrayList<>());
                forwardPage = "/admin_Dashboard.jsp";
                break;
            }
        }
        request.getRequestDispatcher(forwardPage).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        Staff s = (session != null) ? (Staff) session.getAttribute("staff") : null;
        if (s == null || !"admin".equalsIgnoreCase(s.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }

        String action = request.getParameter("action");

        if ("add_product".equals(action) || "update_product".equals(action) || "delete_product".equals(action)) {
            handleProductAction(request, response, action);
            return;
        }
        if ("add_staff".equals(action) || "update_account".equals(action) || "delete_account".equals(action)) {
            handleAccountAction(request, response, action);
            return;
        }
        if ("add_customer".equals(action) || "update_customer".equals(action) || "delete_customer".equals(action)) {
            handleCustomerAction(request, response, action);
            return;
        }
        if ("check_customer_data".equals(action)) {
            handleCheckCustomerData(request, response);
            return;
        }
        if ("update_profile".equals(action)) {
            handleUpdateProfile(request, response, s);
            return;
        }
        if ("change_password".equals(action)) {
            handleChangePassword(request, response, s);
            return;
        }
        if ("add".equals(action) || "edit".equals(action) || "delete".equals(action)) {
            handleVoucherAction(request, response, action);
            return;
        }
        if ("update_order_status".equals(action)) {
            handleOrderStatusUpdate(request, response);
            return;
        }
        if ("get_customer_orders".equals(action)) {
            handleGetCustomerOrders(request, response);
            return;
        }
        if ("create_import".equals(action)) {
            handleCreateImport(request, response, s.getStaff_id());
            return;
        }
        if ("update_import_status".equals(action)) {
            handleUpdateImportStatus(request, response);
            return;
        }
        if ("cancel_import".equals(action)) {
            handleCancelImport(request, response);
            return;
        }
    }

    private void handleProductAction(HttpServletRequest request, HttpServletResponse response, String action) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        ResponseData responseData = new ResponseData();
        ProductDAO productDAO = new ProductDAO();
        VoucherDAO voucherDAO = new VoucherDAO();
        Size_detailDAO size_detailDAO = new Size_detailDAO();

        try {
            if ("add_product".equals(action)) {
                String name = request.getParameter("name");
                int price = parseIntSafe(request.getParameter("price"), 0);
                int categoryId = parseIntSafe(request.getParameter("category"), 0);
                String des = request.getParameter("des");
                int voucherPercent = parseIntSafe(request.getParameter("voucher"), 0);
                String pic = request.getParameter("pic");
                String uploadedFile = processUploadFile(request);
                if (uploadedFile != null) {
                    pic = uploadedFile;
                }

                String voucherId = null;
                if (voucherPercent >= 0) {
                    String autoId = "V" + voucherPercent;
                    voucherDAO.addIfNotExist(autoId, voucherPercent);
                    voucherId = voucherDAO.getIdVoucher(voucherPercent);
                }
                if (categoryId == 0) {
                    throw new Exception("Invalid Category ID");
                }

                Product p = new Product(price, categoryId, voucherId, name, des, pic);
                boolean isSuccess = productDAO.insert(p);
                if (isSuccess) {
                    List<Product> newProducts = productDAO.sortNew();
                    if (newProducts != null && !newProducts.isEmpty()) {
                        int newProductId = newProducts.get(0).getId();
                        size_detailDAO.insert(new Size_detail("S", newProductId, 0));
                        size_detailDAO.insert(new Size_detail("M", newProductId, 0));
                        size_detailDAO.insert(new Size_detail("L", newProductId, 0));
                    }
                }
                responseData.setIsSuccess(isSuccess);
                responseData.setDescription(isSuccess ? "Success" : "Failed to insert");

            } else if ("update_product".equals(action)) {
                int id = parseIntSafe(request.getParameter("id"), 0);
                String name = request.getParameter("name");
                int price = parseIntSafe(request.getParameter("price"), 0);
                int categoryId = parseIntSafe(request.getParameter("category"), 0);
                String des = request.getParameter("des");
                int voucherPercent = parseIntSafe(request.getParameter("voucher"), 0);
                String pic = request.getParameter("pic");
                String uploadedFile = processUploadFile(request);
                if (uploadedFile != null) {
                    pic = uploadedFile;
                }

                String voucherId = null;
                if (voucherPercent >= 0) {
                    String autoId = "V" + voucherPercent;
                    voucherDAO.addIfNotExist(autoId, voucherPercent);
                    voucherId = voucherDAO.getIdVoucher(voucherPercent);
                }
                if (id == 0) {
                    throw new Exception("Missing Product ID");
                }
                Product existing = productDAO.getProductById(id);
                if (existing != null) {
                    Product p = new Product(id, price, categoryId, voucherId, name, des, pic, existing.isIs_active());
                    boolean isSuccess = productDAO.update(p);
                    responseData.setIsSuccess(isSuccess);
                } else {
                    responseData.setIsSuccess(false);
                    responseData.setDescription("Product not found");
                }

            } else if ("delete_product".equals(action)) {
                int id = parseIntSafe(request.getParameter("id"), 0);

                OrderDAO orderDAO = new OrderDAO();
                CartDAO cartDAO = new CartDAO();
                ImportDetailDAO importDetailDAO = new ImportDetailDAO();
                FeedBackDAO feedBackDAO = new FeedBackDAO();

                boolean hasOrders = !orderDAO.getOrderDetailsByProductId(id).isEmpty();
                boolean hasCarts = !cartDAO.getCartItemsByProductId(id).isEmpty();
                boolean hasImports = !importDetailDAO.getImportDetailsByProductId(id).isEmpty();
                boolean hasFeedbacks = !feedBackDAO.getFeedbackByProductId(id).isEmpty();

                if (hasOrders || hasCarts || hasImports || hasFeedbacks) {
                    responseData.setIsSuccess(false);
                    responseData.setDescription("Cannot delete: Related data exists (Orders/Carts/Imports).");
                } else {
                    List<Size_detail> sizes = size_detailDAO.getSizesByProductId(id);
                    int totalStock = 0;
                    for (Size_detail s : sizes) {
                        totalStock += s.getQuantity();
                    }

                    if (totalStock > 0) {
                        responseData.setIsSuccess(false);
                        responseData.setDescription("Cannot delete: Product still has stock (" + totalStock + ").");
                    } else {
                        try {
                            size_detailDAO.deleteByProductId(id);
                        } catch (Exception ex) {
                        }
                        String result = productDAO.deleteProductWithChecks(id);
                        if ("success".equals(result)) {
                            responseData.setIsSuccess(true);
                        } else {
                            responseData.setIsSuccess(false);
                            responseData.setDescription(result);
                        }
                    }
                }
            }
        } catch (Exception e) {
            responseData.setIsSuccess(false);
            responseData.setDescription("Server Error: " + e.getMessage());
            e.printStackTrace();
        }
        out.print(gson.toJson(responseData));
        out.flush();
    }

    private void handleAccountAction(HttpServletRequest request, HttpServletResponse response, String action) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        ResponseData responseData = new ResponseData();
        StaffDAO staffDAO = new StaffDAO();
        CustomerDAO customerDAO = new CustomerDAO();
        try {
            if ("add_staff".equals(action)) {
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                String email = request.getParameter("email");
                String fullName = request.getParameter("fullName");
                String phone = request.getParameter("phone");
                String address = request.getParameter("address");
                String role = "staff";
                if (customerDAO.isUsernameTaken(username)) {
                    responseData.setIsSuccess(false);
                    responseData.setDescription("Username exists");
                } else if (customerDAO.checkEmail(email) || staffDAO.getStaffByEmailOrUsername(email) != null) {
                    responseData.setIsSuccess(false);
                    responseData.setDescription("Email exists");
                } else {
                    String hashedPassword = getMd5(password);
                    Staff s = new Staff(username, email, hashedPassword, address, phone, fullName, role);
                    boolean isSuccess = staffDAO.signUp(s);
                    responseData.setIsSuccess(isSuccess);
                }
            } else if ("update_account".equals(action)) {
                int id = parseIntSafe(request.getParameter("id"), 0);
                String email = request.getParameter("email");
                String address = request.getParameter("address");
                String fullName = request.getParameter("fullName");
                String phone = request.getParameter("phone");
                boolean isSuccess = staffDAO.updateStaffProfile(id, email, address, phone, fullName);
                responseData.setIsSuccess(isSuccess);
                if (!isSuccess) {
                    responseData.setDescription("Update failed. Email or Phone may already exist.");
                }
            } else if ("delete_account".equals(action)) {
                String username = request.getParameter("username");
                boolean isSuccess = staffDAO.delete(username);
                responseData.setIsSuccess(isSuccess);
                if (!isSuccess) {
                    responseData.setDescription("Cannot delete. Data constraints exist.");
                }
            }
        } catch (Exception e) {
            responseData.setIsSuccess(false);
            responseData.setDescription("Server Error: " + e.getMessage());
        }
        out.print(gson.toJson(responseData));
        out.flush();
    }

    private void handleCustomerAction(HttpServletRequest request, HttpServletResponse response, String action) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        ResponseData responseData = new ResponseData();
        CustomerDAO customerDAO = new CustomerDAO();
        try {
            if ("add_customer".equals(action)) {
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                String email = request.getParameter("email");
                String fullName = request.getParameter("fullName");
                String phone = request.getParameter("phone");
                String address = request.getParameter("address");
                if (customerDAO.isUsernameTaken(username)) {
                    responseData.setIsSuccess(false);
                    responseData.setDescription("Username already exists.");
                } else if (customerDAO.checkEmail(email)) {
                    responseData.setIsSuccess(false);
                    responseData.setDescription("Email already registered.");
                } else {
                    String hashedPassword = getMd5(password);
                    Customer c = new Customer(username, email, hashedPassword, address, phone, fullName, null);
                    boolean isSuccess = customerDAO.signUp(c);
                    responseData.setIsSuccess(isSuccess);
                    if (!isSuccess) {
                        responseData.setDescription("Database Insert Failed.");
                    }
                }
            } else if ("update_customer".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String email = request.getParameter("email");
                String fullName = request.getParameter("fullName");
                String phone = request.getParameter("phone");
                String address = request.getParameter("address");
                boolean isSuccess = customerDAO.updateCustomerProfile(id, email, address, phone, fullName);
                responseData.setIsSuccess(isSuccess);
                if (!isSuccess) {
                    responseData.setDescription("Update failed.");
                }
            } else if ("delete_customer".equals(action)) {
                String username = request.getParameter("username");
                boolean isSuccess = customerDAO.delete(username);
                responseData.setIsSuccess(isSuccess);
                if (!isSuccess) {
                    responseData.setDescription("Cannot delete. Data constraints exist.");
                }
            }
        } catch (Exception e) {
            responseData.setIsSuccess(false);
            responseData.setDescription("Server Error: " + e.getMessage());
            e.printStackTrace();
        }
        out.print(gson.toJson(responseData));
        out.flush();
    }

    private void handleCheckCustomerData(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        try {
            int customerId = Integer.parseInt(request.getParameter("id"));
            OrderDAO orderDAO = new OrderDAO();
            CartDAO cartDAO = new CartDAO();
            FeedBackDAO feedbackDAO = new FeedBackDAO();
            List<Orders> orders = orderDAO.getOrdersByCustomerID(customerId);
            int cartCount = cartDAO.getCartCount(customerId);
            List<entity.Feedback> feedbacks = feedbackDAO.getFeedbackByCustomerId(customerId);
            Map<String, Object> data = new HashMap<>();
            data.put("orderCount", orders.size());
            data.put("cartCount", cartCount);
            data.put("feedbackCount", feedbacks.size());
            data.put("orders", orders.stream().map(o -> o.getOrderID()).collect(Collectors.toList()));
            out.print(gson.toJson(data));
        } catch (Exception e) {
            e.printStackTrace();
            Map<String, Object> errorData = new HashMap<>();
            errorData.put("orderCount", 0);
            errorData.put("cartCount", 0);
            errorData.put("feedbackCount", 0);
            out.print(gson.toJson(errorData));
        }
        out.flush();
    }

    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response, Staff currentStaff) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        ResponseData responseData = new ResponseData();
        StaffDAO staffDAO = new StaffDAO();
        CustomerDAO customerDAO = new CustomerDAO();
        try {
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String phone = request.getParameter("phone");
            String fullName = request.getParameter("fullName");
            String username = currentStaff.getUsername();
            boolean isSuccess = staffDAO.updateStaffProfile(currentStaff.getStaff_id(), email, address, phone, fullName);
            if (isSuccess) {
                HttpSession session = request.getSession();
                Staff updatedStaff = staffDAO.getStaffByEmailOrUsername(username);
                if (updatedStaff != null) {
                    session.setAttribute("staff", updatedStaff);
                }
                if (customerDAO.isUsernameTaken(username)) {
                    boolean syncSuccess = customerDAO.updateUserProfileByUsername(username, email, address, phone, fullName);
                    if (syncSuccess) {
                        Customer updatedCustomer = customerDAO.getCustomerByUsernameOrEmail(username);
                        if (updatedCustomer != null) {
                            session.setAttribute("acc", updatedCustomer);
                        }
                    }
                }
                responseData.setIsSuccess(true);
                responseData.setDescription("Profile updated successfully.");
            } else {
                responseData.setIsSuccess(false);
                responseData.setDescription("Update failed. Email or Phone might be invalid or duplicate.");
            }
        } catch (Exception e) {
            responseData.setIsSuccess(false);
            responseData.setDescription("Error: " + e.getMessage());
            e.printStackTrace();
        }
        out.print(gson.toJson(responseData));
        out.flush();
    }

    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response, Staff currentStaff) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        ResponseData responseData = new ResponseData();
        StaffDAO staffDAO = new StaffDAO();
        CustomerDAO customerDAO = new CustomerDAO();
        try {
            String currentPass = request.getParameter("currentPassword");
            String newPass = request.getParameter("newPassword");
            String currentPassHash = getMd5(currentPass);
            String username = currentStaff.getUsername();
            boolean isCorrect = staffDAO.checkLogin(username, currentPassHash);
            if (isCorrect) {
                String newPassHash = getMd5(newPass);
                boolean isSuccess = staffDAO.updatePasswordByEmailOrUsername(newPassHash, username);
                if (isSuccess) {
                    customerDAO.updatePasswordByUsername(newPassHash, username);
                    responseData.setIsSuccess(true);
                    responseData.setDescription("Password changed successfully.");
                } else {
                    responseData.setIsSuccess(false);
                    responseData.setDescription("Failed to update password in database.");
                }
            } else {
                responseData.setIsSuccess(false);
                responseData.setDescription("Current password is incorrect.");
            }
        } catch (Exception e) {
            responseData.setIsSuccess(false);
            responseData.setDescription("Error: " + e.getMessage());
            e.printStackTrace();
        }
        out.print(gson.toJson(responseData));
        out.flush();
    }

    private void handleVoucherAction(HttpServletRequest request, HttpServletResponse response, String action) throws IOException {
        VoucherDAO dao = new VoucherDAO();
        ProductDAO productDAO = new ProductDAO();
        ResponseData responseData = new ResponseData();

        try {
            if ("add".equals(action) || "edit".equals(action)) {
                String id = request.getParameter("id");
                int percent = parseIntSafe(request.getParameter("percent"), -1);
                String startStr = request.getParameter("startDate");
                String endStr = request.getParameter("endDate");

                if (id == null || id.trim().isEmpty()) {
                    responseData.setIsSuccess(false);
                    responseData.setDescription("Error: Voucher Code is required.");
                } else if (percent < 1 || percent > 100) {
                    responseData.setIsSuccess(false);
                    responseData.setDescription("Error: Percent must be between 1 and 100.");
                } else if (startStr == null || endStr == null) {
                    responseData.setIsSuccess(false);
                    responseData.setDescription("Error: Dates are required.");
                } else {
                    Date start = Date.valueOf(startStr);
                    Date end = Date.valueOf(endStr);
                    if (end.before(start)) {
                        responseData.setIsSuccess(false);
                        responseData.setDescription("Error: End date must be after or equal to Start date.");
                    } else {
                        if ("add".equals(action)) {
                            if (dao.existsById(id)) {
                                responseData.setIsSuccess(false);
                                responseData.setDescription("Error: Voucher Code '" + id + "' already exists!");
                            } else {
                                dao.addVoucher(new Voucher(id, percent, start, end));
                                responseData.setIsSuccess(true);
                                responseData.setDescription("Voucher added successfully!");
                            }
                        } else {
                            dao.updateVoucher(new Voucher(id, percent, start, end));
                            responseData.setIsSuccess(true);
                            responseData.setDescription("Voucher updated successfully!");
                        }
                    }
                }
            } else if ("delete".equals(action)) {
                String id = request.getParameter("id");
                if (productDAO.hasDataForVoucher(id)) {
                    responseData.setIsSuccess(false);
                    responseData.setDescription("Cannot delete: Voucher is currently used by products.");
                } else {
                    dao.deleteVoucher(id);
                    responseData.setIsSuccess(true);
                    responseData.setDescription("Voucher deleted successfully!");
                }
            }
        } catch (Exception e) {
            responseData.setIsSuccess(false);
            responseData.setDescription("Server Error: " + e.getMessage());
            e.printStackTrace();
        }

        response.setContentType("application/json");
        response.getWriter().write(new Gson().toJson(responseData));
    }

    // [FIX] Cập nhật trong file: controller/AdminController.java

private void handleOrderStatusUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException {
    response.setContentType("application/json; charset=UTF-8");
    PrintWriter out = response.getWriter();
    Gson gson = new Gson();
    ResponseData responseData = new ResponseData();
    
    try {
        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String newStatus = request.getParameter("status");
        OrderDAO orderDAO = new OrderDAO();
        Size_detailDAO size_detailDAO = new Size_detailDAO();

        // LOGIC MỚI: Kiểm tra tồn kho trước khi xác nhận đơn (Pending -> Delivering)
        if ("Delivering".equals(newStatus)) {
            List<OrderDetail> details = orderDAO.getAllOrdersDetailByID(orderId);
            
            if (details != null && !details.isEmpty()) {
                // BƯỚC 1: KIỂM TRA TỒN KHO (Validation Phase)
                // Duyệt qua toàn bộ sản phẩm để đảm bảo TẤT CẢ đều đủ hàng trước khi trừ
                for (OrderDetail od : details) {
                    Size_detail currentStock = size_detailDAO.getSizeByProductIdAndName(od.getProductID(), od.getSize_name());
                    
                    if (currentStock == null) {
                        throw new Exception("Error data: Product ID not found " + od.getProductID() + " size " + od.getSize_name() + " in stock.");
                    }
                    
                    if (currentStock.getQuantity() < od.getQuantity()) {
                        // Nếu không đủ hàng, ném lỗi ngay lập tức để dừng quy trình
                        throw new Exception("Insufficient stock for the product: " + od.getProductID() 
                                + " (Size: " + od.getSize_name() + "). "
                                + "In stock: " + currentStock.getQuantity() 
                                + ", Customer order: " + od.getQuantity());
                    }
                }

                // BƯỚC 2: TRỪ KHO (Execution Phase)
                // Chỉ chạy khi Bước 1 đã qua (tất cả sản phẩm đều đủ)
                for (OrderDetail od : details) {
                    Size_detail currentStock = size_detailDAO.getSizeByProductIdAndName(od.getProductID(), od.getSize_name());
                    int newQty = currentStock.getQuantity() - od.getQuantity();
                    size_detailDAO.updateQuanSize(newQty, od.getProductID(), currentStock.getSize_name());
                }
            }
        }

        // BƯỚC 3: CẬP NHẬT TRẠNG THÁI ĐƠN HÀNG
        // Chỉ cập nhật khi không có lỗi ở trên
        orderDAO.updateStatus(newStatus, orderId);

        responseData.setIsSuccess(true);
        responseData.setDescription("Update status successfully to " + newStatus);
        
    } catch (Exception e) {
        // Nếu có lỗi (không đủ hàng), trả về thông báo lỗi cho Frontend hiển thị alert
        responseData.setIsSuccess(false);
        responseData.setDescription("Error: " + e.getMessage());
        e.printStackTrace();
    }
    
    out.print(gson.toJson(responseData));
    out.flush();
}

    private void handleCreateImport(HttpServletRequest request, HttpServletResponse response, int staffId) throws IOException {
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
            Imports newImport = new Imports();
            newImport.setStaff_id(staffId);
            newImport.setDate(new Date(System.currentTimeMillis()));
            newImport.setStatus("Pending");
            int importId = importDAO.insertImportAndGetId(newImport);
            if (importId > 0) {
                for (int i = 0; i < jsonArray.length(); i++) {
                    JSONObject item = jsonArray.getJSONObject(i);
                    int pId = Integer.parseInt(item.getString("productId"));
                    String size = item.getString("size");
                    int qty = item.getInt("quantity");
                    ImportDetail detail = new ImportDetail();
                    detail.setImportID(importId);
                    detail.setProductID(pId);
                    detail.setSizeName(size);
                    detail.setQuantity(qty);
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

    private void handleUpdateImportStatus(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        ResponseData responseData = new ResponseData();
        try {
            String idStr = request.getParameter("id");
            int importId = parseIntSafe(idStr, 0);
            ImportDAO importDAO = new ImportDAO();
            ImportDetailDAO detailDAO = new ImportDetailDAO();
            Size_detailDAO size_detailDAO = new Size_detailDAO();

            boolean ok = importDAO.updateStatus(importId, "Delivered");

            if (ok) {
                List<ImportDetail> details = detailDAO.getListToImport(importId);
                for (ImportDetail d : details) {
                    size_detailDAO.updateSize_detailAfterOrder(d.getProductID(), d.getSizeName(), d.getQuantity());
                }
                responseData.setIsSuccess(true);
            } else {
                responseData.setIsSuccess(false);
                responseData.setDescription("DB Update failed.");
            }
        } catch (Exception e) {
            responseData.setIsSuccess(false);
            responseData.setDescription("Error: " + e.getMessage());
        }
        out.print(gson.toJson(responseData));
        out.flush();
    }

    private void handleCancelImport(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        ResponseData responseData = new ResponseData();
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            ImportDAO importDAO = new ImportDAO();

            boolean ok = importDAO.updateStatus(id, "Cancelled");

            responseData.setIsSuccess(ok);
            responseData.setDescription(ok ? "Import cancelled successfully" : "Failed to cancel import");
        } catch (Exception e) {
            responseData.setIsSuccess(false);
            responseData.setDescription("Error: " + e.getMessage());
            e.printStackTrace();
        }
        out.print(gson.toJson(responseData));
        out.flush();
    }

    private void handleGetCustomerOrders(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        ResponseData responseData = new ResponseData();
        try {
            int custId = Integer.parseInt(request.getParameter("id"));
            OrderDAO orderDAO = new OrderDAO();
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

    @Override
    public String getServletInfo() {
        return "Admin Controller";
    }
}