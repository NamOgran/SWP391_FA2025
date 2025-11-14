package controller;

// Đảm bảo bạn đã import đầy đủ các gói này
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Collections;
import java.util.stream.Collectors;
import DAO.CategoryDAO;
import DAO.CustomerDAO;
import DAO.ProductDAO;
import DAO.StaffDAO;
import DAO.PromoDAO;
import DAO.StatsDAO;
import entity.Category;
import entity.Customer;
import entity.Product;
import entity.Promo;
import entity.Staff;
import entity.Stats;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@WebServlet(name = "AdminController", urlPatterns = {"/admin"})
public class AdminController extends HttpServlet {
    
    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here.
             You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AdminController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminController at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // Hàm tiện ích để mã hóa URL
    private String encode(String value) {
        if (value == null) return "";
        try {
            return URLEncoder.encode(value, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            return value;
        }
    }
    
    // === START: UPDATED doGet() METHOD (ĐÃ CẬP NHẬT ĐƯỜNG DẪN JSP) ===
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        Staff s = (session != null) ? (Staff) session.getAttribute("staff") : null;
        if (s == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        if (!"admin".equalsIgnoreCase(s.getRole())) {
            response.sendRedirect(request.getContextPath() + "/staff.jsp");
            return;
        }

        // Lấy tham số tab để quyết định tải dữ liệu nào
        String tab = request.getParameter("tab");
        if (tab == null || tab.isEmpty()) {
            tab = "dashboard";
            // Mặc định là dashboard
        }

        // Khởi tạo các DAO
        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        PromoDAO promoDAO = new PromoDAO();
        StaffDAO staffDAO = new StaffDAO();
        CustomerDAO customerDAO = new CustomerDAO();
        // === SỬA ĐỔI 1: Cập nhật đường dẫn JSP mặc định ===
        String forwardPage = "/admin_Dashboard.jsp";
        // Trang mặc định

        switch (tab) {
            
            // ================== CASE 1: PRODUCT ==================
            case "product":
                String searchName = request.getParameter("search");
                String sortBy = request.getParameter("sort");
                String pageRaw = request.getParameter("page");
                String categoryRaw = request.getParameter("category");
                String status = request.getParameter("status");
                int pageIndex = 1;
                int pageSize = 10;
                try {
                    if (pageRaw != null && !pageRaw.isEmpty()) {
                        pageIndex = Integer.parseInt(pageRaw);
                    }
                } catch (NumberFormatException e) {
                    pageIndex = 1;
                }
                int categoryId = 0;
                try {
                    if (categoryRaw != null && !categoryRaw.isEmpty()) {
                        categoryId = Integer.parseInt(categoryRaw);
                    }
                } catch (NumberFormatException e) {
                    categoryId = 0;
                }
                if (status == null || status.isEmpty()) {
                    status = "all";
                }
                int totalProducts = productDAO.getTotalProductCount(searchName, categoryId, status);
                int totalPages = (int) Math.ceil((double) totalProducts / pageSize);
                List<Product> productList = productDAO.getPaginatedProducts(searchName, sortBy, categoryId, status, pageIndex, pageSize);
                request.setAttribute("list", productList);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("currentPage", pageIndex);
                request.setAttribute("searchName", searchName);
                request.setAttribute("sortBy", sortBy);
                request.setAttribute("selectedCategory", categoryId);
                request.setAttribute("selectedStatus", status);
                
                // Dữ liệu chung cho Product (Category Map & Promo Map)
                List<Category> cateList = categoryDAO.getAll();
                Map<Integer, String> categoryMap = new HashMap<>();
                for (Category c : cateList) {
                    categoryMap.put(c.getCategory_id(), c.getType() + " (" + c.getGender() + ")");
                }
                request.setAttribute("categoryMap", categoryMap);
                request.setAttribute("cateList", cateList);
                
                Map<Integer, String> promoMap = new HashMap<>();
                List<Promo> allPromosForMap = promoDAO.getAll();
                for (Promo p : allPromosForMap) {
                    promoMap.put(p.getPromoID(), p.getPromoPercent() + "%");
                }
                request.setAttribute("promoMap", promoMap);
                request.setAttribute("promoList", allPromosForMap);
                // Cần cho modal

                // === SỬA ĐỔI 2: Cập nhật đường dẫn JSP ===
                forwardPage = "/admin_ProductManagement.jsp";
                break;

            // ================== CASE 2: ACCOUNT ==================
            case "account":
                String accountSearch = request.getParameter("search_account");
                String accountRoleFilter = request.getParameter("roleFilter"); 
                String accountPageRaw = request.getParameter("account_page");
                int accountPageIndex = 1;
                int accountPageSize = 10;
                
                if (accountRoleFilter == null || accountRoleFilter.isEmpty()) {
                    accountRoleFilter = "all";
                }
                try {
                    if (accountPageRaw != null && !accountPageRaw.isEmpty()) {
                        accountPageIndex = Integer.parseInt(accountPageRaw);
                    }
                } catch (NumberFormatException e) {
                    accountPageIndex = 1;
                }
                
                final String finalAccountRoleFilter = accountRoleFilter;
                final String finalAccountSearch = (accountSearch == null || accountSearch.isEmpty()) ? null : accountSearch.toLowerCase();
                
                List<Staff> allStaff = staffDAO.getAll();
                List<Customer> allCustomers = customerDAO.getAll();

                List<Staff> filteredStaff = new ArrayList<>();
                List<Staff> nonAdminStaff = allStaff.stream()
                        .filter(staff -> !"admin".equalsIgnoreCase(staff.getRole()))
                        .collect(Collectors.toList());
                
                if (finalAccountRoleFilter.equals("all") || finalAccountRoleFilter.equals("staff")) {
                    filteredStaff = nonAdminStaff.stream()
                        .filter(staff -> (finalAccountSearch == null ||
                                         staff.getUsername().toLowerCase().contains(finalAccountSearch))
    
                                    ) 
                        .collect(Collectors.toList());
                }

                List<Customer> filteredCustomers = new ArrayList<>();
                if (finalAccountRoleFilter.equals("all") || finalAccountRoleFilter.equals("customer")) {
                    filteredCustomers = allCustomers.stream()
                        .filter(customer -> (finalAccountSearch == null ||
                                            customer.getUsername().toLowerCase().contains(finalAccountSearch))
 
                                        )
                        .collect(Collectors.toList());
                }

                List<Object> combinedList = new ArrayList<>();
                combinedList.addAll(filteredStaff);
                combinedList.addAll(filteredCustomers);

                int totalAccounts = combinedList.size();
                int accountTotalPages = (int) Math.ceil((double) totalAccounts / accountPageSize);
                int startIndex = (accountPageIndex - 1) * accountPageSize;
                int endIndex = Math.min(startIndex + accountPageSize, totalAccounts);
                
                List<Object> paginatedList = (totalAccounts > 0 && startIndex < endIndex)
                                             ?
                                            combinedList.subList(startIndex, endIndex)
                                             : Collections.emptyList();
                
                List<Staff> paginatedStaff = paginatedList.stream()
                        .filter(obj -> obj instanceof Staff)
                        .map(obj -> (Staff) obj)
                        .collect(Collectors.toList());
                List<Customer> paginatedCustomers = paginatedList.stream()
                        .filter(obj -> obj instanceof Customer)
                        .map(obj -> (Customer) obj)
                        .collect(Collectors.toList());
                
                request.setAttribute("staffList", paginatedStaff);
                request.setAttribute("customerList", paginatedCustomers);
                request.setAttribute("accountTotalPages", accountTotalPages);
                request.setAttribute("accountCurrentPage", accountPageIndex);
                request.setAttribute("accountSearch", accountSearch);
                request.setAttribute("accountRoleFilter", accountRoleFilter);
                
                // === SỬA ĐỔI 3: Cập nhật đường dẫn JSP ===
                forwardPage = "/admin_AccountManagement.jsp";
                break;

            // ================== CASE 3: PROMO ==================
            case "promo":
                String promoSearch = request.getParameter("promo_search");
                String promoPageRaw = request.getParameter("promo_page");
                int promoPageIndex = 1;
                int promoPageSize = 10;
                
                try {
                    if (promoPageRaw != null && !promoPageRaw.isEmpty()) {
                        promoPageIndex = Integer.parseInt(promoPageRaw);
                    }
                } catch (NumberFormatException e) {
                    promoPageIndex = 1;
                }
                int totalPromos = promoDAO.getTotalPromoCount(promoSearch);
                int promoTotalPages = (int) Math.ceil((double) totalPromos / promoPageSize);
                List<Promo> promoList = promoDAO.getPaginatedPromos(promoSearch, promoPageIndex, promoPageSize);
                request.setAttribute("promoList", promoList);
                request.setAttribute("promoTotalPages", promoTotalPages);
                request.setAttribute("promoCurrentPage", promoPageIndex);
                request.setAttribute("promoSearch", promoSearch);

                // === SỬA ĐỔI 4: Cập nhật đường dẫn JSP ===
                forwardPage = "/admin_PromoManagement.jsp";
                break;

            // ================== CASE 4: PERSONAL ==================
            case "personal":
                // Không cần tải dữ liệu đặc biệt, JSP sẽ đọc từ session
                
                // === SỬA ĐỔI 5: Cập nhật đường dẫn JSP ===
           
                forwardPage = "/admin_PersonalInformation.jsp";
                break;

            // ================== CASE 5: DASHBOARD (DEFAULT) ==================
            case "dashboard":
            default:
                // === Thống kê Dashboard ===
                StatsDAO statsDAO = new StatsDAO();
                Stats stats = statsDAO.getStats(); // Hàm này bạn đã có trong StatsDAO

                request.setAttribute("stats", stats);

                forwardPage = "/admin_Dashboard.jsp";
                break;
        }

        // Chuyển tiếp đến JSP tương ứng
        request.getRequestDispatcher(forwardPage).forward(request, response);
    }
    // === END: UPDATED doGet() METHOD ===

    
    // === START: UPDATED doPost() METHOD (Sửa Redirect) ===
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Staff s = (session != null) ? (Staff) session.getAttribute("staff") : null;
        if (s == null || !"admin".equalsIgnoreCase(s.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
            return;
        }
        
        request.setCharacterEncoding("UTF-8");
        PromoDAO dao = new PromoDAO(); 
        
        // === BỔ SUNG KHỞI TẠO ProductDAO (Cho logic xóa) ===
        ProductDAO productDAO = new ProductDAO();
        // === KẾT THÚC BỔ SUNG ===

        String action = request.getParameter("action");
        String promoPage = request.getParameter("promo_page");
        String promoSearch = request.getParameter("promo_search");
        String msg = "";
        boolean validationError = false;

        try {
            if ("add".equals(action) || "edit".equals(action)) {
                int percent = Integer.parseInt(request.getParameter("percent"));
                java.sql.Date start = java.sql.Date.valueOf(request.getParameter("startDate")); 
                java.sql.Date end = java.sql.Date.valueOf(request.getParameter("endDate")); 

                if (percent < 1 || percent > 100) {
                    msg = "promo_invalid_percent";
                    validationError = true;
                }
                else if (end.before(start)) {
                    msg = "promo_invalid_date";
                    validationError = true;
                }

                if (!validationError) {
                    if ("add".equals(action)) {
                        dao.addPromo(new Promo(0, percent, start, end));
                        msg = "promo_added";
                    } else { // "edit"
                        int id = Integer.parseInt(request.getParameter("id"));
                        dao.updatePromo(new Promo(id, percent, start, end)); 
                        msg = "promo_updated";
                    }
                }
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                
                // === BẮT ĐẦU SỬA ĐỔI: THÊM KIỂM TRA TRƯỚC KHI XÓA ===
                boolean isInUse = productDAO.hasDataForPromo(id);
                
                if (isInUse) {
                    msg = "promo_in_use"; // Thông báo lỗi mới
                    validationError = true;
                } else {
                    // Chỉ xóa nếu không được sử dụng
                    dao.deletePromo(id); 
                    msg = "promo_deleted";
                }
                // === KẾT THÚC SỬA ĐỔI ===
            }
            
        } catch (NumberFormatException e) {
            msg = "promo_invalid_percent";
            validationError = true;
        } catch (IllegalArgumentException e) {
            msg = "promo_invalid_date_format";
            validationError = true;
        }

        // === SỬA ĐỔI 7: Cập nhật URL chuyển hướng ===
        // Sửa "activeTab=promo-manage" thành "tab=promo"
        StringBuilder redirectUrl = new StringBuilder(request.getContextPath() + "/admin");
        redirectUrl.append("?tab=promo&msg=").append(encode(msg));
        // === KẾT THÚC SỬA ĐỔI ===
        
        if (promoPage != null && !promoPage.isEmpty()) {
            redirectUrl.append("&promo_page=").append(encode(promoPage));
        }
        if (promoSearch != null && !promoSearch.isEmpty()) {
            redirectUrl.append("&promo_search=").append(encode(promoSearch));
        }
        
        response.sendRedirect(redirectUrl.toString());
    }
    // === END: UPDATED doPost() METHOD ===

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}