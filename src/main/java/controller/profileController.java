/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.CustomerDAO;
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
import java.util.Arrays;
import payLoad.ResponseData;
import static url.ProfileURL.URL_CHANGEPASS;
import static url.ProfileURL.URL_PROFILE;
import static url.ProfileURL.URL_UPDATE;

/**
 *
 * @author nam
 */
@WebServlet(name = "profileController", urlPatterns = {URL_PROFILE, URL_UPDATE, URL_CHANGEPASS})
public class ProfileController extends HttpServlet {

    CustomerDAO daoCustomer = new CustomerDAO();
    private Gson gson = new Gson();

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String urlPath = request.getServletPath();
        switch (urlPath) {
            case URL_PROFILE:
                viewProfile(request, response);
                break;
            case URL_UPDATE:
                updateProfile(request, response);
                break;
            case URL_CHANGEPASS:
                changePass(request, response);
                break;
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

    private void changePass(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String currentPassword = request.getParameter("currentPassword");
        currentPassword = getMd5(currentPassword);
        String newPassword = request.getParameter("newPassword");
        newPassword = getMd5(newPassword);
        String input = request.getParameter("input");
        boolean isSuccess = false;
        boolean isCorrect = daoCustomer.checkLogin(input, currentPassword);
        if (isCorrect) {
            isSuccess = daoCustomer.updatePasswordByEmailOrUsername(newPassword, input);

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

  
    private void updateProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy dữ liệu từ form
        String fullName = request.getParameter("fullName");
        String address = request.getParameter("address");
        String phoneNumber = request.getParameter("phoneNumber");
        String email = request.getParameter("email");

        // Thực hiện update vào DB
        boolean isSuccess = daoCustomer.updateUserProfile(email, address, phoneNumber, fullName);

        if (isSuccess) {
            //  Update thành công 
            HttpSession session = request.getSession(false);
            if (session != null) {
                Customer updatedCustomer = daoCustomer.getCustomerByEmailOrUsername(email);
                if (updatedCustomer != null) {
                    session.setAttribute("acc", updatedCustomer);
                }
            }

            //Chuyển hướng về profile
            response.sendRedirect(request.getContextPath() + "/profile");

        } else {
      

            // Đặt một thông báo lỗi vào request
            request.setAttribute("errorMessage", "Cập nhật thất bại! Đã có lỗi xảy ra, vui lòng thử lại.");

            //Lấy lại thông tin (CŨ) từ session để hiển thị lại form         
            HttpSession session = request.getSession(false);
            if (session != null) {
                Customer c = (Customer) session.getAttribute("acc");
                if (c != null) {
                    // Đặt lại các thuộc tính mà profile.jsp cần để hiển thị
                    request.setAttribute("fullName", c.getFullName());
                    request.setAttribute("email", c.getEmail());
                    request.setAttribute("address", c.getAddress());
                    request.setAttribute("phoneNumber", c.getPhoneNumber());
                }
            }

            // Chuyển tiếp (FORWARD) trở lại trang profile.jsp để hiển thị lỗi
            // (Forward sẽ giữ nguyên các attribute bạn vừa set)
            request.getRequestDispatcher("profile.jsp").forward(request, response);

         
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

   

private void viewProfile(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    // Lấy session hiện tại (không tạo mới nếu chưa có)
    HttpSession session = request.getSession(false);
    Customer loggedInCustomer = null;

    //  Ưu tiên kiểm tra xem có đối tượng "acc" trong session không
    if (session != null) {
        loggedInCustomer = (Customer) session.getAttribute("acc"); // Lấy Customer từ session
        System.out.println("ProfileController: Found user in session: " + (loggedInCustomer != null)); // Log để debug
    } else {
        System.out.println("ProfileController: Session not found."); // Log để debug
    }

    //  Nếu tìm thấy người dùng trong session
    if (loggedInCustomer != null) {
        // Lấy thông tin cần thiết từ đối tượng Customer trong session
        request.setAttribute("fullName", loggedInCustomer.getFullName());
        request.setAttribute("email", loggedInCustomer.getEmail());
        request.setAttribute("address", loggedInCustomer.getAddress());
        request.setAttribute("phoneNumber", loggedInCustomer.getPhoneNumber());

        // Đặt cả đối tượng 'acc' vào request scope
        // để trang profile.jsp có thể dùng <c:if test="${empty acc.google_id}"> kiểm tra
        request.setAttribute("acc", loggedInCustomer);

        // Chuyển tiếp (forward) đến trang profile.jsp
        request.getRequestDispatcher("profile.jsp").forward(request, response);

    } else {
        //  Nếu không có người dùng trong session -> Chuyển hướng về trang đăng nhập
        System.out.println("ProfileController: User not in session. Redirecting to login."); // Log để debug
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}

}
