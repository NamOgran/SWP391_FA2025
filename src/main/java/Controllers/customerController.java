/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.DAOcustomer;
import com.google.gson.Gson;
import entity.customer;
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
import java.util.Properties;
import java.util.Random;
import javax.mail.Message;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import payLoad.ResponseData;
import static url.customerURL.URL_FORGOT_PASS;
import static url.customerURL.URL_LOGIN_CUSTOMER;

import static url.customerURL.URL_SIGNUP;
import static url.customerURL.URL_UPDATE_PASS;

/**
 *
 * @author thinh
 */
@WebServlet(name = "customerController", urlPatterns = {URL_LOGIN_CUSTOMER, URL_SIGNUP, URL_FORGOT_PASS, URL_UPDATE_PASS})
public class customerController extends HttpServlet {

    private Gson gson = new Gson();
    DAOcustomer daoCustomer = new DAOcustomer();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
//        processRequest(request, response);
        String urlPath = request.getServletPath();
        switch (urlPath) {
            case URL_LOGIN_CUSTOMER:
                login(request, response);
                break;
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

    protected void updatePass(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String password = request.getParameter("password");
        password = getMd5(password);
        String email = request.getParameter("email");


//        deleteCookie(request, response);

        boolean isSuccess = daoCustomer.updatePasswordByEmailOrUsername(password, email);

        ResponseData data = new ResponseData();
        data.setIsSuccess(isSuccess);
        data.setDescription("");
        data.setData("");
        String json = gson.toJson(data);
        PrintWriter pw = response.getWriter();
        pw.print(json);
        pw.flush();
    }

    protected void forgotPass(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        boolean isSuccess = daoCustomer.checkEmail(email);
        ResponseData data = new ResponseData();
        data.setIsSuccess(isSuccess);
        data.setDescription("");
        data.setData("");

        if (isSuccess) {
            String code = getCode(request, response, email);
            data.setData(code);

//            request.setAttribute("email", email);
//            request.setAttribute("message", "<div id=\"message\" style=\"color: green\">Please enter the code sent to your email to continue</div>");
//            request.getRequestDispatcher("/forgot.jsp").forward(request, response);
        }
//        else {
//
////            request.setAttribute("email", email);
////            request.setAttribute("message", "<div id=\"message\" style=\"color: red\">Your email is not exist</div>");
////            request.getRequestDispatcher("/forgot.jsp").forward(request, response);
//        }
        String json = gson.toJson(data);
        PrintWriter pw = response.getWriter();
        pw.print(json);
        pw.flush();
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

        javax.mail.Session session = javax.mail.Session.getInstance(props, new javax.mail.Authenticator() {
            protected javax.mail.PasswordAuthentication getPasswordAuthentication() {
                return new javax.mail.PasswordAuthentication(userName, password);
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
        String password = request.getParameter("password");
        password = getMd5(password);
        boolean isSuccess = daoCustomer.checkLogin(input, password);
        if (isSuccess) {
            response.sendRedirect("/Project_SWP391_Group4/productList");
        } else {
            request.setAttribute("message", "<div id=\"message\" style=\"color: red\">Incorrect username or password</div>");
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
        String password = request.getParameter("password");
        password = getMd5(password);
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String phoneNumber = request.getParameter("phoneNumber");
        String fullName = request.getParameter("fullName");

        customer c = new customer(username, email, password, address, phoneNumber, fullName);

        boolean isSuccess = daoCustomer.signUp(c);
        ResponseData data = new ResponseData();
        data.setIsSuccess(isSuccess);
        data.setData("");
        data.setDescription("");
        String json = gson.toJson(data);
        PrintWriter pw = response.getWriter();
        pw.print(json);
        pw.flush();

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
