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
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;
import payLoad.ResponseData;
import static url.profileURL.URL_CHANGEPASS;
import static url.profileURL.URL_PROFILE;
import static url.profileURL.URL_UPDATE;

/**
 *
 * @author thinh
 */
@WebServlet(name = "profileController", urlPatterns = {URL_PROFILE, URL_UPDATE, URL_CHANGEPASS})
public class profileController extends HttpServlet {

    DAOcustomer daoCustomer = new DAOcustomer();
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
        String fullName = request.getParameter("fullName");
        String address = request.getParameter("address");
        String phoneNumber = request.getParameter("phoneNumber");
        String email = request.getParameter("email");

        boolean isSuccess = daoCustomer.updateUserProfile(email, address, phoneNumber, fullName);
        if (isSuccess) {
            response.sendRedirect("Project_SWP391_Group4/profile");

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
        Cookie[] cookies = request.getCookies();
        String input = "";
        for (Cookie cooky : cookies) {
            if (cooky.getName().equals("input")) {
                input = cooky.getValue();
                break;
            }
        }
        

        
        if (!input.equals("")) {
            customer c = daoCustomer.getCustomerByEmailOrUsername(input);
            request.setAttribute("fullName", c.getFullName());
            request.setAttribute("email", c.getEmail());
            request.setAttribute("address", c.getAddress());
            request.setAttribute("phoneNumber", c.getPhoneNumber());
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
//        ResponseData data = new ResponseData();
//        data.setIsSuccess(true);
//        data.setDescription("");
//        data.setData(email);
//        String json = gson.toJson(data);
//        PrintWriter pw = response.getWriter();
//        pw.print(json);
//        pw.flush();
    }

}
