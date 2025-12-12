/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import DAO.CustomerDAO;
import io.github.cdimascio.dotenv.Dotenv;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
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

    // Lớp tiện ích xử lý Google API
    public static class GoogleUtils {

        // SỬA LỖI QUAN TRỌNG: Phải thêm 'static' vì được dùng trong phương thức static
        static Dotenv dotenv = Dotenv.load();
        static final String GOOGLE_CLIENT_ID = dotenv.get("GOOGLE_CLIENT_ID");
        static final String GOOGLE_CLIENT_SECRET = dotenv.get("GOOGLE_CLIENT_SECRET");

        // Lưu ý: Đổi port/path cho đúng dự án của bạn
        static final String GOOGLE_REDIRECT_URI = "http://localhost:8080/Project_SWP391_Group4/google-callback";
        static final String GOOGLE_TOKEN_URL = "https://oauth2.googleapis.com/token";
        static final String GOOGLE_USER_INFO_URL = "https://www.googleapis.com/oauth2/v2/userinfo";

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

        public static GooglePojo getUserInfo(final String accessToken) throws ClientProtocolException, IOException {
            String link = GOOGLE_USER_INFO_URL + "?access_token=" + accessToken;
            String response = Request.Get(link).execute().returnContent().asString();
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
            GooglePojo googleUser = GoogleUtils.getUserInfo(accessToken);

            CustomerDAO dao = new CustomerDAO();

            // Kiểm tra email tồn tại chưa
            boolean userExists = dao.checkEmail(googleUser.getEmail());
            Customer customerAccount;

            if (userExists) {
                // Email đã có -> Đăng nhập luôn
                customerAccount = dao.getCustomerByEmailOrUsername(googleUser.getEmail());

                // (Tùy chọn: Update Google ID nếu null - Code của bạn đang để trống phần này, vậy là ổn)
            } else {
                // Email chưa có -> Đăng ký mới
                String email = googleUser.getEmail();
                String username = email.substring(0, email.indexOf('@')); // Lấy phần trước @ làm username
                String googleId = "gg_" + googleUser.getId();
                String randomPassword = CustomerController.getMd5(googleUser.getId()); // Pass mặc định
                String fullName = googleUser.getName();

                // Tạo đối tượng Customer mới
                Customer newCustomer = new Customer(
                        username,
                        email,
                        randomPassword,
                        "", // Address
                        "", // Phone
                        fullName,
                        googleId
                );

                dao.signUp(newCustomer);

                // Lấy lại từ DB để có ID tự tăng (Identity)
                customerAccount = dao.getCustomerByEmailOrUsername(email);
            }

            // Lưu vào session và chuyển hướng
            HttpSession session = request.getSession();
            session.setAttribute("acc", customerAccount);
            response.sendRedirect("productList");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Login error: " + e.getMessage());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
