/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import DAO.CustomerDAO;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
// SỬA LỖI 1: Đổi tên import từ GooglePojo thành GooglePojo
import entity.GooglePojo;
import entity.Customer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.fluent.Request;
import org.apache.http.client.fluent.Form;

@WebServlet(name = "LoginGoogleController", urlPatterns = {"/google-callback"})
public class LoginGoogleController extends HttpServlet {

    // Lớp tiện ích để lấy token và thông tin user
    public static class GoogleUtils {

        // Dán Client ID và Client Secret của bạn vào đây
        private static final String GOOGLE_CLIENT_ID = "374822286993-ui3durfgknmnkvpb6jhllng951hnvmb8.apps.googleusercontent.com";
        private static final String GOOGLE_CLIENT_SECRET = "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";
        private static final String GOOGLE_REDIRECT_URI = "http://localhost:8080/Project_SWP391_Group4/google-callback";
        private static final String GOOGLE_TOKEN_URL = "https://oauth2.googleapis.com/token";
        private static final String GOOGLE_USER_INFO_URL = "https://www.googleapis.com/oauth2/v2/userinfo";

        public static String getToken(final String code) throws ClientProtocolException, IOException {
            String response = Request.Post(GOOGLE_TOKEN_URL)
                    .bodyForm(Form.form()
                            .add("client_id", GOOGLE_CLIENT_ID)
                            .add("client_secret", GOOGLE_CLIENT_SECRET)
                            .add("redirect_uri", GOOGLE_REDIRECT_URI)
                            .add("code", code)
                            .add("grant_type", "authorization_code")
                            .build())
                    .execute().returnContent().asString();

            JsonObject jobj = new Gson().fromJson(response, JsonObject.class);
            return jobj.get("access_token").toString().replaceAll("\"", "");
        }

        // SỬA LỖI 1 (tiếp): Đổi kiểu trả về GooglePojo thành GooglePojo
        public static GooglePojo getUserInfo(final String accessToken) throws ClientProtocolException, IOException {
            String link = GOOGLE_USER_INFO_URL + "?access_token=" + accessToken;
            String response = Request.Get(link).execute().returnContent().asString();
            // Sửa ở đây
            return new Gson().fromJson(response, GooglePojo.class);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");

        if (code == null || code.isEmpty()) {
            request.setAttribute("message", "Google login failed.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            String accessToken = GoogleUtils.getToken(code);
            // SỬA LỖI 1 (tiếp): Đổi GooglePojo thành GooglePojo
            GooglePojo googleUser = GoogleUtils.getUserInfo(accessToken);

            CustomerDAO dao = new CustomerDAO();
            
            // Luôn kiểm tra bằng Email. Đây là cách đáng tin cậy nhất.
            boolean userExists = dao.checkEmail(googleUser.getEmail());

            Customer customerAccount; // Biến để lưu tài khoản

            if (userExists) {
                // Nếu email đã tồn tại, lấy thông tin và đăng nhập
                customerAccount = dao.getCustomerByEmailOrUsername(googleUser.getEmail());
                
                // (Tùy chọn) Cập nhật google_id nếu tài khoản này trước đây tạo bằng form thường
                if (customerAccount.getGoogle_id() == null || customerAccount.getGoogle_id().isEmpty()) {
                    String googleId = "gg_" + googleUser.getId();
                    // Bạn nên tạo một hàm DAO.updateGoogleId(email, googleId)
                    // Tạm thời bỏ qua để không phức tạp hóa
                }

            } else {
                // Nếu email chưa tồn tại, tạo tài khoản mới
                String email = googleUser.getEmail();
                // Tạo username duy nhất, ví dụ: phần trước @
                String username = email.substring(0, email.indexOf('@')); 
                String googleId = "gg_" + googleUser.getId(); // ID của Google, vd: "gg_12345..."
                String randomPassword = CustomerController.getMd5(googleUser.getId()); // Mật khẩu ngẫu nhiên
                String fullName = googleUser.getName(); // Tên đầy đủ, vd: "Nguyen Hai Nam (K17 CT)"

                // === SỬA LỖI 2: SẮP XẾP LẠI THAM SỐ CONSTRUCTOR ===
                // Thứ tự đúng dựa trên Customer.java (7 tham số): 
                // (username, email, password, address, phoneNumber, fullName, google_id)
                Customer newCustomer = new Customer(
                        username,       // 1. username
                        email,          // 2. email
                        randomPassword, // 3. password
                        "",             // 4. address (Trống)
                        "",             // 5. phoneNumber (Trống)
                        fullName,       // 6. fullName
                        googleId        // 7. google_id
                );

                dao.signUp(newCustomer);

                // === SỬA LỖI 3: Lấy lại tài khoản từ DB để có customer_id ===
                // Lấy lại thông tin tài khoản vừa tạo để đảm bảo có customer_id
                customerAccount = dao.getCustomerByEmailOrUsername(email);
            }

            // Đăng nhập (lưu vào session)
            HttpSession session = request.getSession();
            // Lưu tài khoản *đã có customer_id* vào session
            session.setAttribute("acc", customerAccount); 
            response.sendRedirect("productList"); // Chuyển hướng đến trang sản phẩm

        } catch (IOException e) {
            e.printStackTrace();
            request.setAttribute("message", "An error occurred during Google login.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}