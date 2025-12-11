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

/**
 *
 *
 */
@WebServlet(name = "customerController", urlPatterns = {
    "/login/signup", 
    "/login/forgot", 
    "/login/update", 
    "/login/verifyCode" 
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
     * STEP 3: Update new password. Only allowed if session is marked as "codeVerified".
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
        String password = getMd5(request.getParameter("password")); // Hash password
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String phoneNumber = request.getParameter("phoneNumber");
        String fullName = request.getParameter("fullName");
        String google_id = request.getParameter("google_id");
        if (google_id == null) {
            google_id = ""; 
        }

        // --- CHECK FOR DUPLICATES ---

        // 1. Check Username (checks both Customer and Staff tables)
        if (daoCustomer.isUsernameTaken(username)) {
            request.setAttribute("message", "This username is already taken!");
            // Keep input data
            saveInputAttribute(request, username, email, address, phoneNumber, fullName);
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
            return; // Stop registration
        }

        // 2. Check Email
        if (daoCustomer.checkEmail(email)) {
            request.setAttribute("message", "This email is already registered!");
            // Keep input data
            saveInputAttribute(request, username, email, address, phoneNumber, fullName);
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
            return; // Stop registration
        }

        // --- END CHECK ---

        // Create object and save if valid
        Customer c = new Customer(username, email, password, address, phoneNumber, fullName, google_id);
        boolean isSuccess = daoCustomer.signUp(c);

        if (isSuccess) {
            // Registration successful -> Show Popup (Success Logic)
            request.setAttribute("registerSuccess", true);
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
        } else {
            // System Error
            request.setAttribute("message", "System error, please try again later!");
            saveInputAttribute(request, username, email, address, phoneNumber, fullName);
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
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