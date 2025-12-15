/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.CustomerDAO;
import Utils.EmailUtil;
import com.google.gson.Gson;
import entity.Customer;
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
import java.security.SecureRandom;
import java.util.Random;
import payLoad.ResponseData;
import static url.CustomerURL.URL_FORGOT_PASS;
import static url.CustomerURL.URL_SIGNUP;
import static url.CustomerURL.URL_UPDATE_PASS;
import static url.CustomerURL.URL_VERIFY;
import static url.CustomerURL.URL_VERIFY_SIGNUP;

/**
 *
 *
 */
@WebServlet(name = "customerController", urlPatterns = {
    "/login/signup",
    "/login/forgot",
    "/login/update",
    "/login/verifyCode",
    "/login/verify-signup"
})
public class CustomerController extends HttpServlet {

    private final Gson gson = new Gson();
    CustomerDAO daoCustomer = new CustomerDAO();
    private static final long OTP_EXPIRY_TIME_MS = 10 * 60 * 1000;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
//        processRequest(request, response);
        String urlPath = request.getServletPath();
        switch (urlPath) {
            case URL_SIGNUP:
                signUp(request, response);
                break;
            case URL_FORGOT_PASS:
                forgotPass(request, response);
                break;
            case URL_UPDATE_PASS:
                updatePass(request, response);
                break;
            case URL_VERIFY:
                verifyCode(request, response);
                break;
            case URL_VERIFY_SIGNUP:
                confirmRegistration(request, response);
                break;
        }
    }

    private void deleteCookie(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Cookie[] cookies = request.getCookies();
        for (int i = 0; i < cookies.length; i++) {
            Cookie cookie = cookies[i];
            cookie.setMaxAge(0);
            response.addCookie(cookie);
        }
    }

    protected void forgotPass(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        PrintWriter pw = response.getWriter();
        ResponseData data = new ResponseData();
        data.setIsSuccess(false);

        // 1. Check if email exists
        boolean isExist = daoCustomer.checkEmail(email);
        if (!isExist) {
            data.setDescription("Email does not exist in the system.");
            pw.print(gson.toJson(data));
            pw.flush();
            return;
        }

        try {
            // 2. Generate secure OTP (6 digits)
            String otp = generateNumericOTP(6);

            // 3. Send email (Using EmailUtil)
            String subject = "[GIO Shop] Password Recovery Request";
            String content = "Your verification code is: " + otp
                    + "\n\nThis code will expire in 10 minutes."
                    + "\n\nIf you did not request this, please ignore this email.";

            // EmailUtil handles SSL, Port, etc.
            EmailUtil.sendEmail(email, subject, content);

            // 4. Save security info to Session
            HttpSession session = request.getSession();
            session.setAttribute("otpHash", getMd5(otp)); // Store HASH, not the actual code
            session.setAttribute("otpExpiry", System.currentTimeMillis() + OTP_EXPIRY_TIME_MS);
            session.setAttribute("resetEmail", email); // Store email for step 3

            data.setIsSuccess(true);
            data.setDescription("Code sent successfully.");

        } catch (Exception ex) {
            ex.printStackTrace();
            String chiTietLoi = ex.toString().replace("\"", "'");
            data.setDescription("Runtime Error. Details: " + chiTietLoi);
        }

        pw.print(gson.toJson(data));
        pw.flush();
    }

    /**
     * STEP 2: Verify OTP Code. Compare HASH and expiration time.
     */
    protected void verifyCode(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String inputCode = request.getParameter("code");
        HttpSession session = request.getSession(false); // Get current session, do not create new

        PrintWriter pw = response.getWriter();
        ResponseData data = new ResponseData();
        data.setIsSuccess(false);

        if (session == null) {
            data.setDescription("Session expired. Please try again.");
            pw.print(gson.toJson(data));
            pw.flush();
            return;
        }

        // Get safe data from session
        String sessionOtpHash = (String) session.getAttribute("otpHash");
        Long sessionExpiryTime = (Long) session.getAttribute("otpExpiry");
        String sessionEmail = (String) session.getAttribute("resetEmail");

        if (sessionOtpHash == null || sessionExpiryTime == null || sessionEmail == null) {
            data.setDescription("Invalid or expired session.");
            pw.print(gson.toJson(data));
            pw.flush();
            return;
        }

        // 1. Check expiration
        if (System.currentTimeMillis() > sessionExpiryTime) {
            data.setDescription("OTP has expired.");
            // Remove old session data
            session.removeAttribute("otpHash");
            session.removeAttribute("otpExpiry");
            session.removeAttribute("resetEmail");
            pw.print(gson.toJson(data));
            pw.flush();
            return;
        }

        // 2. Check code (compare hash)
        if (getMd5(inputCode).equals(sessionOtpHash)) {
            data.setIsSuccess(true);
            data.setDescription("Verification successful.");

            // Mark as verified
            session.setAttribute("codeVerified", true);

            // Remove OTP immediately after use
            session.removeAttribute("otpHash");
            session.removeAttribute("otpExpiry");
        } else {
            data.setDescription("Invalid OTP.");
        }

        pw.print(gson.toJson(data));
        pw.flush();
    }

    /**
     * STEP 3: Update new password. Only allowed if session is marked as
     * "codeVerified".
     */
    protected void updatePass(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String password = request.getParameter("password");
        HttpSession session = request.getSession(false);

        PrintWriter pw = response.getWriter();
        ResponseData data = new ResponseData();
        data.setIsSuccess(false);

        if (session == null) {
            data.setDescription("Session expired. Please try again.");
            pw.print(gson.toJson(data));
            pw.flush();
            return;
        }

        // Check permission (must pass step 2)
        Boolean codeVerified = (Boolean) session.getAttribute("codeVerified");
        String email = (String) session.getAttribute("resetEmail");

        if (codeVerified == null || !codeVerified || email == null) {
            data.setDescription("OTP not verified. Password change not allowed.");
            pw.print(gson.toJson(data));
            pw.flush();
            return;
        }

        // Hash new password
        String passwordHash = getMd5(password);

        // Call DAO
        boolean isSuccess = daoCustomer.updatePasswordByEmailOrUsername(passwordHash, email);

        if (isSuccess) {
            data.setIsSuccess(true);
            data.setDescription("Password updated successfully.");

            // Cleanup session after completion
            session.removeAttribute("codeVerified");
            session.removeAttribute("resetEmail");
            // Or session.invalidate() to clear everything

        } else {
            data.setDescription("Cannot update password. Database error.");
        }

        pw.print(gson.toJson(data));
        pw.flush();
    }

    // Generate numeric OTP (6 digits)
    public static String generateNumericOTP(int length) {
        String numbers = "0123456789";
        SecureRandom random = new SecureRandom();
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            sb.append(numbers.charAt(random.nextInt(numbers.length())));
        }
        return sb.toString();
    }

    public static String generateRandomString(int length) {
        String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder randomString = new StringBuilder(length);
        Random random = new Random();

        for (int i = 0; i < length; i++) {
            int index = random.nextInt(characters.length());
            char randomChar = characters.charAt(index);
            randomString.append(randomChar);
        }

        return randomString.toString();
    }

    protected void login(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String input = request.getParameter("input");
        String password = getMd5(request.getParameter("password"));

        boolean isLoginSuccessful = daoCustomer.checkLogin(input, password);

        if (isLoginSuccessful) {
            Customer loggedInCustomer = daoCustomer.getCustomerByEmailOrUsername(input);
            if (loggedInCustomer != null) {
                HttpSession session = request.getSession();
                session.setAttribute("acc", loggedInCustomer);
                response.sendRedirect(request.getContextPath() + "/productList");
            } else {
                request.setAttribute("message", "<div style='color:red'>Cannot load customer data!</div>");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("message", "<div style='color:red'>Invalid username or password!</div>");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    public static String getMd5(String input) {
        try {

            // Static getInstance method is called with hashing MD5
            MessageDigest md = MessageDigest.getInstance("MD5");

            // digest() method is called to calculate message digest
            // of an input digest() return array of byte
            byte[] messageDigest = md.digest(input.getBytes());

            // Convert byte array into signum representation
            BigInteger no = new BigInteger(1, messageDigest);

            // Convert message digest into hex value
            String hashtext = no.toString(16);
            while (hashtext.length() < 32) {
                hashtext = "0" + hashtext;
            }
            return hashtext;
        } // For specifying wrong message digest algorithms
        catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }

    protected void signUp(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = getMd5(request.getParameter("password"));
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String phoneNumber = request.getParameter("phoneNumber");
        String fullName = request.getParameter("fullName");
        String google_id = request.getParameter("google_id");
        if (google_id == null) {
            google_id = "";
        }

        // Check Username & Email (Giữ nguyên logic cũ của bạn)
        if (daoCustomer.isUsernameTaken(username)) {
            request.setAttribute("message", "This username is already taken!");
            saveInputAttribute(request, username, email, address, phoneNumber, fullName);
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
            return;
        }
        if (daoCustomer.checkEmail(email)) {
            request.setAttribute("message", "This email is already registered!");
            saveInputAttribute(request, username, email, address, phoneNumber, fullName);
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
            return;
        }

        // --- LOGIC MỚI: Verify Email ---
        try {
            Customer tempC = new Customer(username, email, password, address, phoneNumber, fullName, google_id);
            String otp = generateNumericOTP(6); // Hàm tạo OTP bạn đã có sẵn

            // Gửi mail (Sử dụng EmailUtil bạn đã có)
            String subject = "[GIO Shop] Verify your Account Registration";
            String content = "Welcome to GIO Shop! \nYour verification code is: " + otp;
            EmailUtil.sendEmail(email, subject, content);

            // Lưu vào Session
            HttpSession session = request.getSession();
            session.setAttribute("tempCustomer", tempC); // Lưu object Customer
            session.setAttribute("registerOtp", otp);    // Lưu mã OTP thực

            // Chuyển sang trang nhập mã (File JSP mới)
            response.sendRedirect(request.getContextPath() + "/verify_register.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Error sending email: " + e.getMessage());
            saveInputAttribute(request, username, email, address, phoneNumber, fullName);
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
        }
    }

    protected void confirmRegistration(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String inputCode = request.getParameter("verifyCode");
        HttpSession session = request.getSession(false); // Lấy session hiện tại, không tạo mới

        // 1. Kiểm tra Session
        if (session == null) {
            System.out.println("DEBUG: Session is NULL -> Mất phiên làm việc");
            request.setAttribute("message", "Session expired. Please sign up again.");
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
            return;
        }

        Customer tempC = (Customer) session.getAttribute("tempCustomer");
        String serverOtp = (String) session.getAttribute("registerOtp");

        // 2. Debug: In giá trị ra console (Cửa sổ Output của Netbeans/IntelliJ)
        System.out.println("--------------------------------------------------");
        System.out.println("DEBUG - Session ID: " + session.getId());
        System.out.println("DEBUG - Server OTP (trong Session): [" + serverOtp + "]");
        System.out.println("DEBUG - User Input (nhập vào):      [" + inputCode + "]");
        System.out.println("--------------------------------------------------");

        if (tempC == null || serverOtp == null) {
            request.setAttribute("message", "Session data missing. Please sign up again.");
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
            return;
        }

        // 3. XỬ LÝ QUAN TRỌNG: Cắt khoảng trắng (Trim)
        if (inputCode != null) {
            inputCode = inputCode.trim(); // Xóa dấu cách thừa ở đầu/cuối
        }

        // 4. So sánh
        // Lưu ý: Ở hàm signUp chúng ta lưu mã thô (Plain text), không phải MD5
        // Nên ở đây so sánh trực tiếp code.equals(serverOtp)
        if (inputCode != null && inputCode.equals(serverOtp)) {

            // Mã đúng -> Gọi DAO lưu vào Database
            boolean isSuccess = daoCustomer.signUp(tempC);

            if (isSuccess) {
                // Xóa session tạm
                session.removeAttribute("tempCustomer");
                session.removeAttribute("registerOtp");

                // Thông báo thành công
                request.setAttribute("registerSuccess", true);
                request.getRequestDispatcher("/signup.jsp").forward(request, response);
            } else {
                request.setAttribute("message", "Database error! Insert failed.");
                request.getRequestDispatcher("/verify_register.jsp").forward(request, response);
            }
        } else {
            // Mã sai
            request.setAttribute("message", "Invalid verification code! (Input: " + inputCode + ")");
            request.getRequestDispatcher("/verify_register.jsp").forward(request, response);
        }
    }

    // Helper method to keep input attributes
    private void saveInputAttribute(HttpServletRequest request, String u, String e, String a, String p, String f) {
        request.setAttribute("inputUsername", u);
        request.setAttribute("inputEmail", e);
        request.setAttribute("inputAddress", a);
        request.setAttribute("inputPhone", p);
        request.setAttribute("inputFullName", f);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

    public static void main(String[] args) {

    }
}
