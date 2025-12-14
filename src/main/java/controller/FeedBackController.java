/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// Import your DAO and Entity
import DAO.FeedBackDAO;
import entity.Feedback; 
import entity.Customer; // ===== ADDED: Import your Customer class =====

import java.io.BufferedReader;
// JSON Library, need to add JAR file to WEB-INF/lib
import org.json.JSONObject;

/**
 *
 * @author Tran Quang Duyen
 */
// This URL Pattern must match the fetch() command in JavaScript
@WebServlet(name = "FeedBackController", urlPatterns = {"/feedback"})
public class FeedBackController extends HttpServlet {

    private FeedBackDAO feedbackDAO;

    // Initialize DAO when servlet is loaded
    @Override
    public void init() {
        feedbackDAO = new FeedBackDAO();
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet FeedbackController</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet FeedbackController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    /**
     * Handles the HTTP <code>GET</code> method.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Do not use doGet for sending feedback, keep as is
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JSONObject jsonResponse = new JSONObject();

        // ===== MODIFIED FROM HERE =====

        // 1. Get customerId from Session
        HttpSession session = request.getSession(false);

        // 1.1. Check if session has "acc" attribute (from LoginServlet)
        if (session == null || session.getAttribute("acc") == null) {
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "You need to log in to leave a review.");
            out.print(jsonResponse.toString());
            out.flush();
            return;
        }
        
        int customerId;
        try {
            // 1.2. Get Customer object from session
            Customer loggedInCustomer = (Customer) session.getAttribute("acc");
            
            // 1.3. Get ID from that object
            // *** IMPORTANT: Update .getCustomerID() if your method is named .getId() or similar ***
            customerId = loggedInCustomer.getCustomer_id(); 

        } catch (Exception e) {
             e.printStackTrace(); // Print error to console for debugging
             jsonResponse.put("status", "error");
            jsonResponse.put("message", "Session error (Cannot read Customer data).");
            out.print(jsonResponse.toString());
            out.flush();
            return;
        }
        
        // ===== END MODIFICATION =====


        // 2. Read JSON data from request body (Keep as is)
        StringBuilder sb = new StringBuilder();
        String line;
        try (BufferedReader reader = request.getReader()) {
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        
        // 3. Parse JSON and Process Logic (Keep as is)
        try {
            JSONObject jsonRequest = new JSONObject(sb.toString());
            
            int productId = jsonRequest.getInt("productId");
            int orderId = jsonRequest.getInt("orderId");
            int rating = jsonRequest.getInt("rating");
            String comment = jsonRequest.getString("comment");

            // 4. Use DAO to check business logic
            
            // 4.1. Check if user actually purchased the item
            if (!feedbackDAO.hasPurchased(customerId, productId, orderId)) {
                jsonResponse.put("status", "error");
                jsonResponse.put("message", "You can only review products that have been purchased and delivered.");
                out.print(jsonResponse.toString());
                out.flush();
                return;
            }

            // 4.2. Check if they have already reviewed this order
            if (feedbackDAO.hasAlreadyReviewed(customerId, productId, orderId)) {
                jsonResponse.put("status", "error");
                jsonResponse.put("message", "You have already reviewed this product for this order.");
                out.print(jsonResponse.toString());
                out.flush();
                return;
            }

            // 5. If everything is OK -> Insert into Database
            Feedback fb = new Feedback(); 
            fb.setCustomerId(customerId); // customerId is now correct
            fb.setProductId(productId);
            fb.setOrderId(orderId);
            fb.setRatePoint(rating);
            fb.setContent(comment);
            
            boolean insertSuccess = feedbackDAO.insertFeedback(fb);

            if (insertSuccess) {
                jsonResponse.put("status", "success");
                // Optional: Call another DAO function here to update
                // average rating in 'Products' table
                // productDAO.updateAverageRating(productId);
                
            } else {
                jsonResponse.put("status", "error");
                jsonResponse.put("message", "Could not save feedback. Please try again.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            jsonResponse.put("status", "error");
            jsonResponse.put("message", "Server error while processing data: " + e.getMessage());
        }

        // 6. Send JSON response back to JavaScript
        out.print(jsonResponse.toString());
        out.flush();
    }

    /**
     * Returns a short description of the servlet.
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}