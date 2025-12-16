package controller;

import DAO.CustomerDAO;
import com.google.gson.Gson; // Đảm bảo đã add thư viện GSON vào Libraries
import entity.Customer;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import payLoad.ResponseData; // Đảm bảo class này tồn tại

// [QUAN TRỌNG] Map chính xác các đường dẫn. 
// "/changePassword" phải khớp với url trong AJAX
@WebServlet(name = "profileController", urlPatterns = {"/profile", "/updateProfile", "/changePassword"})
public class ProfileController extends HttpServlet {

    private CustomerDAO daoCustomer = new CustomerDAO();
    private Gson gson = new Gson();

    // Regex check pass ở server
    private static final String PASS_REGEX = "^(?=.*[A-Z])(?=.*[!@#$%^&*(),.?\":{}|<>]).{8,24}$";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String urlPath = request.getServletPath();
        
        // Chỉ xử lý hiển thị profile ở GET
        if ("/profile".equals(urlPath)) {
            viewProfile(request, response);
        } 
        // Các action update/change pass phải dùng POST để bảo mật
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String urlPath = request.getServletPath();
        
        // Điều hướng xử lý dựa trên URL
        if ("/changePassword".equals(urlPath)) {
            handleChangePasswordAjax(request, response);
        } else if ("/updateProfile".equals(urlPath)) {
            updateProfile(request, response);
        }
    }

    // --- LOGIC XỬ LÝ AJAX CHANGE PASSWORD ---
    private void handleChangePasswordAjax(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // Cấu hình header trả về JSON
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        ResponseData resData = new ResponseData();

        try {
            HttpSession session = request.getSession(false);
            Customer acc = (session != null) ? (Customer) session.getAttribute("acc") : null;

            if (acc == null) {
                resData.setIsSuccess(false);
                resData.setDescription("Session expired. Please login again.");
                out.print(gson.toJson(resData));
                return;
            }

            String action = request.getParameter("action"); // Lấy cờ 'verify' hoặc 'change'

            if ("verify".equals(action)) {
                // === BƯỚC 1: KIỂM TRA MẬT KHẨU CŨ ===
                String currentPass = request.getParameter("currentPassword");
                if(currentPass == null) currentPass = "";
                
                String currentPassHash = getMd5(currentPass);
                
                // Kiểm tra trong DB (Sử dụng username hoặc email từ session)
                boolean isCorrect = daoCustomer.checkLogin(acc.getUsername(), currentPassHash);
                
                if (isCorrect) {
                    resData.setIsSuccess(true);
                    resData.setDescription("Password correct.");
                } else {
                    resData.setIsSuccess(false);
                    resData.setDescription("Incorrect current password.");
                }

            } else if ("change".equals(action)) {
                // === BƯỚC 2: ĐỔI MẬT KHẨU MỚI ===
                String newPass = request.getParameter("newPassword");
                
                // Validate lại ở Server
                if (newPass == null || !newPass.matches(PASS_REGEX)) {
                    resData.setIsSuccess(false);
                    resData.setDescription("Password does not meet security requirements. Please try again.");
                } else {
                    String newPassHash = getMd5(newPass);
                    boolean isSuccess = daoCustomer.updatePasswordByEmailOrUsername(newPassHash, acc.getUsername());
                    
                    if (isSuccess) {
                        resData.setIsSuccess(true);
                        resData.setDescription("Password updated successfully.");
                        
                        // (Tùy chọn) Cập nhật lại session nếu object session chứa pass
                        // acc.setPassword(newPassHash); 
                        // session.setAttribute("acc", acc);
                    } else {
                        resData.setIsSuccess(false);
                        resData.setDescription("Database update failed.");
                    }
                }
            } else {
                resData.setIsSuccess(false);
                resData.setDescription("Invalid action parameter.");
            }

        } catch (Exception e) {
            e.printStackTrace(); // In lỗi ra console server để debug
            resData.setIsSuccess(false);
            resData.setDescription("Server Error: " + e.getMessage());
        }

        out.print(gson.toJson(resData));
        out.flush();
    }

    // --- CÁC HÀM HỖ TRỢ ---
    
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

    private void updateProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String address = request.getParameter("address");
        String phoneNumber = request.getParameter("phoneNumber");
        String email = request.getParameter("email");

        boolean isSuccess = daoCustomer.updateUserProfile(email, address, phoneNumber, fullName);

        if (isSuccess) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                Customer updatedCustomer = daoCustomer.getCustomerByEmailOrUsername(email);
                if (updatedCustomer != null) {
                    session.setAttribute("acc", updatedCustomer);
                }
            }
            response.sendRedirect(request.getContextPath() + "/profile");
        } else {
            request.setAttribute("errorMessage", "Update failed!");
             viewProfile(request, response); // Reuse view logic to keep data
        }
    }

    private void viewProfile(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Customer loggedInCustomer = (session != null) ? (Customer) session.getAttribute("acc") : null;

        if (loggedInCustomer != null) {
            request.setAttribute("fullName", loggedInCustomer.getFullName());
            request.setAttribute("email", loggedInCustomer.getEmail());
            request.setAttribute("address", loggedInCustomer.getAddress());
            request.setAttribute("phoneNumber", loggedInCustomer.getPhoneNumber());
            request.setAttribute("acc", loggedInCustomer);
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }
}