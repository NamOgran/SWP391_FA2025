/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller;

import DAO.CustomerDAO;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import entity.GooglePojo;
import entity.Customer;
import io.github.cdimascio.dotenv.Dotenv; 
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

        // Khởi tạo Dotenv để đọc file .env
        // Lưu ý: File .env phải nằm ở thư mục gốc của Project (Root Directory)
        private static final Dotenv dotenv = Dotenv.configure().ignoreIfMissing().load();

        // Lấy thông tin từ file .env
        private static final String GOOGLE_CLIENT_ID = dotenv.get("GOOGLE_CLIENT_ID");
        private static final String GOOGLE_CLIENT_SECRET = dotenv.get("GOOGLE_CLIENT_SECRET");
        private static final String GOOGLE_REDIRECT_URI = dotenv.get("GOOGLE_REDIRECT_URI");
        
        private static final String GOOGLE_TOKEN_URL = "https://oauth2.googleapis.com/token";
        private static final String GOOGLE_USER_INFO_URL = "https://www.googleapis.com/oauth2/v2/userinfo";

        public static String getToken(final String code) throws ClientProtocolException, IOException {
            // Kiểm tra xem biến môi trường có đọc được không (để debug)
            if (GOOGLE_CLIENT_ID == null || GOOGLE_CLIENT_SECRET == null) {
                throw new IOException("Không tìm thấy GOOGLE_CLIENT_ID hoặc SECRET trong file .env");
            }

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
            request.setAttribute("message", "Google login failed. Code is missing.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            String accessToken = GoogleUtils.getToken(code);
            GooglePojo googleUser = GoogleUtils.getUserInfo(accessToken);

            CustomerDAO dao = new CustomerDAO();
            
            // Luôn kiểm tra bằng Email
            boolean userExists = dao.checkEmail(googleUser.getEmail());

            Customer customerAccount;

            if (userExists) {
                // Email đã tồn tại -> Lấy thông tin
                customerAccount = dao.getCustomerByEmailOrUsername(googleUser.getEmail());
                
                // (Tùy chọn) Cập nhật google_id nếu chưa có
                if (customerAccount.getGoogle_id() == null || customerAccount.getGoogle_id().isEmpty()) {
                    // Logic cập nhật google_id có thể thêm ở đây
                }

            } else {
                // Email chưa tồn tại -> Đăng ký mới
                String email = googleUser.getEmail();
                String username = email.substring(0, email.indexOf('@')); 
                String googleId = "gg_" + googleUser.getId(); 
                
                // Lưu ý: Cần chắc chắn class CustomerController có phương thức getMd5 public static
                // Nếu không, bạn cần import hoặc viết lại hàm md5 ở đây
                String randomPassword = CustomerController.getMd5(googleUser.getId()); 
                String fullName = googleUser.getName();

                // Tạo đối tượng Customer mới
                Customer newCustomer = new Customer(
                        username,       // 1. username
                        email,          // 2. email
                        randomPassword, // 3. password
                        "",             // 4. address
                        "",             // 5. phoneNumber
                        fullName,       // 6. fullName
                        googleId        // 7. google_id
                );

                dao.signUp(newCustomer);

                // Lấy lại từ DB để có customer_id
                customerAccount = dao.getCustomerByEmailOrUsername(email);
            }

            // Lưu vào session và chuyển hướng
            HttpSession session = request.getSession();
            session.setAttribute("acc", customerAccount); 
            response.sendRedirect(request.getContextPath()); 

        } catch (Exception e) {
            e.printStackTrace();
            // In lỗi chi tiết ra để debug nếu file .env không load được
            System.err.println("Google Login Error: " + e.getMessage());
            
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