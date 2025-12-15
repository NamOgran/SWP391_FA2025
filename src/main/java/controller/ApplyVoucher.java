package controller;

import DAO.PromoDAO;
import entity.Promo;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "ApplyPromo", urlPatterns = {"/applyPromo"}) // Servlet xử lý apply mã khuyến mãi (POST/GET)
public class ApplyPromo extends HttpServlet {

    private static final long serialVersionUID = 1L; // Khuyến nghị cho Serializable

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Thiết lập mã hóa và kiểu phản hồi JSON
        request.setCharacterEncoding(StandardCharsets.UTF_8.name());
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());
        response.setContentType("application/json; charset=UTF-8");
        // Chặn cache để Ajax luôn nhận dữ liệu mới
        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
        response.setHeader("Pragma", "no-cache");

        try (PrintWriter out = response.getWriter()) { // Tự đóng writer
            String code = request.getParameter("code"); // Lấy tham số mã (ID) khuyến mãi từ client

            // Validate: không nhập mã
            if (code == null || code.trim().isEmpty()) {
                out.write("{\"ok\":false,\"message\":\"Please enter a promo ID.\"}");
                return;
            }

            final int promoId; // ID khuyến mãi (int)
            try {
                promoId = Integer.parseInt(code.trim()); // Validate: phải là số
            } catch (NumberFormatException e) {
                out.write("{\"ok\":false,\"message\":\"Promo ID must be a number.\"}");
                return;
            }

            PromoDAO dao = new PromoDAO(); // Khởi tạo DAO làm việc với bảng promo

            // DEBUG: in thông tin DB/ID để kiểm tra đúng nguồn dữ liệu
            System.out.println("[ApplyPromo] DB URL = " + dao.debugUrl());
            System.out.println("[ApplyPromo] Try apply promoId=" + promoId);

            // Ưu tiên query ở DB: chỉ lấy promo active (CURRENT_DATE nằm trong [start_date, end_date])
            Promo promo = dao.getActiveByIdDb(promoId);

            // Fallback nếu DB trả null (vấn đề timezone/driver...): kiểm tra bằng Java
            if (promo == null) {
                System.out.println("[ApplyPromo] getActiveByIdDb=NULL, fallback getActiveById(Java)");
                promo = dao.getActiveById(promoId);
            }

            // Không tìm thấy hoặc không active
            if (promo == null) {
                out.write("{\"ok\":false,\"message\":\"Promo not found or not active.\"}");
                return;
            }

            int percent = promo.getPromoPercent(); // Phần trăm giảm
            // Validate biên hợp lệ 1..100
            if (percent <= 0 || percent > 100) {
                out.write("{\"ok\":false,\"message\":\"Promo percent is invalid.\"}");
                return;
            }

            // Lưu thông tin promo vào session để các trang khác (cart/payment) dùng lại
            HttpSession session = request.getSession(true);
            session.setAttribute("promoId", promo.getPromoID());
            session.setAttribute("promoPercent", percent);
            session.setAttribute("promoCode", String.valueOf(promo.getPromoID())); // Giữ tương thích nơi dùng "promoCode"

            // Trả JSON thành công: type=percent, value=percent
            out.write("{\"ok\":true,"
                    + "\"type\":\"percent\","
                    + "\"promoId\":" + promo.getPromoID() + ","
                    + "\"value\":" + percent
                    + "}");
        } catch (Exception ex) {
            ex.printStackTrace(); // Log server
            // Trả JSON báo lỗi để Ajax .success vẫn bắt được và hiển thị message
            response.getWriter().write("{\"ok\":false,\"message\":\"Server error: "
                    + ex.getClass().getSimpleName() + "\"}");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doPost(req, resp); // Cho phép gọi GET (tiện debug/linh hoạt)
    }
}
