/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.CustomerDAO;
import Utils.EmailUtil;
import com.google.gson.Gson;
import entity.Customer;
import jakarta.mail.Message;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
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
import java.util.Properties;
import java.util.Random;
import payLoad.ResponseData;
import static url.CustomerURL.URL_FORGOT_PASS;
import static url.CustomerURL.URL_LOGIN_CUSTOMER;
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

        // 1. Kiểm tra email có tồn tại không
        boolean isExist = daoCustomer.checkEmail(email);
        if (!isExist) {
            data.setDescription("Email không tồn tại trong hệ thống.");
            pw.print(gson.toJson(data));
            pw.flush();
            return;
        }

        try {
            // 2. Tạo OTP an toàn (6 chữ số)
            String otp = generateNumericOTP(6);

            // 3. Gửi email (Sử dụng EmailUtil ở file 3)
            String subject = "[GIO Shop] Yêu cầu khôi phục mật khẩu";
            String content = "Mã xác thực của bạn là: " + otp
                    + "\n\nMã này sẽ hết hạn sau 10 phút."
                    + "\n\nNếu bạn không yêu cầu, vui lòng bỏ qua email này.";

            // Hàm sendEmail sẽ tự xử lý các lỗi (SSL, Port, v.v.)
            EmailUtil.sendEmail(email, subject, content);

            // 4. Lưu thông tin bảo mật vào Session
            HttpSession session = request.getSession();
            session.setAttribute("otpHash", getMd5(otp)); // Lưu HASH, không lưu mã thật
            session.setAttribute("otpExpiry", System.currentTimeMillis() + OTP_EXPIRY_TIME_MS);
            session.setAttribute("resetEmail", email); // Lưu email để dùng ở bước 3

            data.setIsSuccess(true);
            data.setDescription("Gửi mã thành công.");

        } catch (Exception ex) {
            ex.printStackTrace();
            String chiTietLoi = ex.toString().replace("\"", "'");
            data.setDescription("Lỗi Runtime. Chi tiết: " + chiTietLoi);
        }

        pw.print(gson.toJson(data));
        pw.flush();
    }

    /**
     * BƯỚC 2: Xác thực mã OTP So sánh HASH và thời gian hết hạn.
     */
    protected void verifyCode(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String inputCode = request.getParameter("code");
        HttpSession session = request.getSession(false); // Lấy session hiện tại, không tạo mới

        PrintWriter pw = response.getWriter();
        ResponseData data = new ResponseData();
        data.setIsSuccess(false);

        if (session == null) {
            data.setDescription("Phiên làm việc đã hết hạn. Vui lòng thử lại.");
            pw.print(gson.toJson(data));
            pw.flush();
            return;
        }

        // Lấy dữ liệu an toàn từ session
        String sessionOtpHash = (String) session.getAttribute("otpHash");
        Long sessionExpiryTime = (Long) session.getAttribute("otpExpiry");
        String sessionEmail = (String) session.getAttribute("resetEmail");

        if (sessionOtpHash == null || sessionExpiryTime == null || sessionEmail == null) {
            data.setDescription("Phiên không hợp lệ hoặc đã hết hạn.");
            pw.print(gson.toJson(data));
            pw.flush();
            return;
        }

        // 1. Kiểm tra hết hạn
        if (System.currentTimeMillis() > sessionExpiryTime) {
            data.setDescription("Mã OTP đã hết hạn.");
            // Xóa session cũ
            session.removeAttribute("otpHash");
            session.removeAttribute("otpExpiry");
            session.removeAttribute("resetEmail");
            pw.print(gson.toJson(data));
            pw.flush();
            return;
        }

        // 2. Kiểm tra mã (so sánh hash)
        if (getMd5(inputCode).equals(sessionOtpHash)) {
            data.setIsSuccess(true);
            data.setDescription("Xác thực thành công");

            // Đánh dấu đã xác thực
            session.setAttribute("codeVerified", true);

            // Xóa OTP ngay sau khi dùng
            session.removeAttribute("otpHash");
            session.removeAttribute("otpExpiry");
        } else {
            data.setDescription("Mã OTP không chính xác.");
        }

        pw.print(gson.toJson(data));
        pw.flush();
    }

    /**
     * BƯỚC 3: Cập nhật mật khẩu mới Chỉ cho phép nếu session đã được đánh dấu
     * "codeVerified".
     */
    protected void updatePass(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String password = request.getParameter("password");
        HttpSession session = request.getSession(false);

        PrintWriter pw = response.getWriter();
        ResponseData data = new ResponseData();
        data.setIsSuccess(false);

        if (session == null) {
            data.setDescription("Phiên làm việc đã hết hạn. Vui lòng thử lại.");
            pw.print(gson.toJson(data));
            pw.flush();
            return;
        }

        // Kiểm tra quyền (phải qua bước 2)
        Boolean codeVerified = (Boolean) session.getAttribute("codeVerified");
        String email = (String) session.getAttribute("resetEmail");

        if (codeVerified == null || !codeVerified || email == null) {
            data.setDescription("Chưa xác thực OTP. Không được phép đổi mật khẩu.");
            pw.print(gson.toJson(data));
            pw.flush();
            return;
        }

        // Hash mật khẩu mới
        String passwordHash = getMd5(password);

        // Gọi DAO (Giả sử DAO đã được sửa lỗi)
        boolean isSuccess = daoCustomer.updatePasswordByEmailOrUsername(passwordHash, email);

        if (isSuccess) {
            data.setIsSuccess(true);
            data.setDescription("Cập nhật mật khẩu thành công.");

            // Dọn dẹp session sau khi hoàn tất
            session.removeAttribute("codeVerified");
            session.removeAttribute("resetEmail");
            // Hoặc session.invalidate() để hủy toàn bộ

        } else {
            data.setDescription("Không thể cập nhật mật khẩu. Lỗi cơ sở dữ liệu.");
        }

        pw.print(gson.toJson(data));
        pw.flush();
    }

    // Hàm tạo OTP 6 số (an toàn hơn)
    public static String generateNumericOTP(int length) {
        String numbers = "0123456789";
        SecureRandom random = new SecureRandom();
        StringBuilder sb = new StringBuilder(length);
        for (int i = 0; i < length; i++) {
            sb.append(numbers.charAt(random.nextInt(numbers.length())));
        }
        return sb.toString();
    }

    public static String getCode(HttpServletRequest request, HttpServletResponse response, String email) throws ServletException, IOException {
        String mess = "";
        HttpSession s = request.getSession();
        final String userName = "dotaiverify@gmail.com"; // TÃ i khoáº£n email gá»­i
        final String password = "fdti iwhb tiuy mwss"; // Máº­t kháº©u email gá»­i

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com"); // SMTP server cá»§a báº¡n
        props.put("mail.smtp.port", "587"); // Cá»•ng SMTP cá»§a báº¡n (thÆ°á»�ng lÃ  587 hoáº·c 25)

        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        jakarta.mail.Session session = jakarta.mail.Session.getInstance(props, new jakarta.mail.Authenticator() {
            @Override
            protected jakarta.mail.PasswordAuthentication getPasswordAuthentication() {
                return new jakarta.mail.PasswordAuthentication(userName, password);
            }
        });
        String code = generateRandomString(5);
        s.setAttribute("code", code);
//                mess = "Username: " + userSend + "\nPassword: " + newPass;
        mess = "Your code: " + code;
        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(userName));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
            message.setSubject("Forget Password");
            message.setText(mess);
            Transport.send(message);

//                    System.out.println("OK");
        } catch (Exception e) {
            System.out.println(e);
        }
        return code;
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
            google_id = ""; // tránh null
        }

        Customer c = new Customer(username, email, password, address, phoneNumber, fullName, google_id);
        boolean isSuccess = daoCustomer.signUp(c);

        if (isSuccess) {
            // Nếu đăng ký thành công → chuyển sang trang đăng nhập
            HttpSession session = request.getSession();
            session.setAttribute("msg", "Đăng ký thành công! Vui lòng đăng nhập.");
            response.sendRedirect(request.getContextPath() + "/profile");
        } else {
            // Nếu thất bại → quay lại signup.jsp với thông báo lỗi
            request.setAttribute("message", "<div style='color:red'>Đăng ký thất bại, vui lòng thử lại!</div>");
            request.getRequestDispatcher("/view/login/signup.jsp").forward(request, response);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

    public static void main(String[] args) {

    }
}
