/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.DAOpromo;
import entity.promo;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author Nguyen Trong Nhan - CE190493
 */
@WebServlet(name = "AdminServlet", urlPatterns = {"/admin"})
public class AdminServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try ( PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AdminServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AdminServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy danh sách promo từ DB
        DAOpromo dao = new DAOpromo();
        List<promo> promoList = dao.getAll();

        // Gửi danh sách sang JSP
        request.setAttribute("promoList", promoList);

        // Forward về trang admin.jsp
        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }

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
        request.setCharacterEncoding("UTF-8");
    DAOpromo dao = new DAOpromo();

    String action = request.getParameter("action");

    if ("add".equals(action)) {
        int percent = Integer.parseInt(request.getParameter("percent"));
        java.sql.Date start = java.sql.Date.valueOf(request.getParameter("startDate"));
        java.sql.Date end = java.sql.Date.valueOf(request.getParameter("endDate"));
        dao.addPromo(new promo(0, percent, start, end));

    } else if ("edit".equals(action)) {
        int id = Integer.parseInt(request.getParameter("id"));
        int percent = Integer.parseInt(request.getParameter("percent"));
        java.sql.Date start = java.sql.Date.valueOf(request.getParameter("startDate"));
        java.sql.Date end = java.sql.Date.valueOf(request.getParameter("endDate"));
        dao.updatePromo(new promo(id, percent, start, end));

    } else if ("delete".equals(action)) {
        int id = Integer.parseInt(request.getParameter("id"));
        dao.deletePromo(id);

    } else if ("search".equals(action)) {
        String keyword = request.getParameter("keyword");
        List<promo> promoList = dao.searchPromo(keyword);
        request.setAttribute("promoList", promoList);
        request.getRequestDispatcher("admin.jsp").forward(request, response);
        return;
    }

    // Sau khi xử lý, load lại danh sách promo
    List<promo> promoList = dao.getAll();
    request.setAttribute("promoList", promoList);
    request.getRequestDispatcher("admin.jsp").forward(request, response);
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

}
