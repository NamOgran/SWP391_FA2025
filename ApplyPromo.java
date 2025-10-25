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

@WebServlet(name = "ApplyPromo", urlPatterns = {"/applyPromo"})
public class ApplyPromo extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // --- CMT: Thiết lập encoding + JSON + chống cache để client luôn nhận dữ liệu mới
        request.setCharacterEncoding(StandardCharsets.UTF_8.name());
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());
        response.setContentType("application/json; charset=UTF-8");
        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");
        response.setHeader("Pragma", "no-cache");

        // CMT: try-with-resources đảm bảo đóng writer kể cả khi có exception
        try (PrintWriter out = response.getWriter()) {
            // ---------- 1) Lấy & kiểm tra tham số ----------
            String code = request.getParameter("code");

            if (code == null || code.trim().isEmpty()) {
                // CMT: Thiếu mã -> trả JSON báo lỗi (client .success sẽ thấy ok=false)
                out.write("{\"ok\":false,\"message\":\"Please enter a promo ID.\"}");
                return;
            }

            final int promoId;
            try {
                // CMT: Chỉ chấp nhận mã số (ID); tránh injection, dễ validate
                promoId = Integer.parseInt(code.trim());
            } catch (NumberFormatException e) {
                out.write("{\"ok\":false,\"message\":\"Promo ID must be a number.\"}");
                return;
            }

            // ---------- 2) Gọi DAO kiểm tra trạng thái khuyến mãi ----------
            PromoDAO dao = new PromoDAO();

            // CMT (DEBUG): log ra để chắc đang dùng đúng DB/connection. Có thể tắt khi production.
            System.out.println("[ApplyPromo] DB URL = " + dao.debugUrl());
            System.out.println("[ApplyPromo] Try apply promoId=" + promoId);

            // CMT: Ưu tiên filter "active" ở tầng DB (dựa theo CURRENT_DATE/now() tuỳ SQL)
            Promo promo = dao.getActiveByIdDb(promoId);

            // CMT: Fallback trong trường hợp DB chưa filter hoặc có vấn đề timezone...
            if (promo == null) {
                System.out.println("[ApplyPromo] getActiveByIdDb=NULL, fallback getActiveById(Java)");
                promo = dao.getActiveById(promoId);
            }

            // ---------- 3) Xử lý khi không tìm thấy hoặc hết hạn ----------
            if (promo == null) {
                out.write("{\"ok\":false,\"message\":\"Promo not found or not active.\"}");
                return;
            }

            int percent = promo.getPromoPercent();
            // CMT: Validate business rule: % phải trong (0..100]
            if (percent <= 0 || percent > 100) {
                out.write("{\"ok\":false,\"message\":\"Promo percent is invalid.\"}");
                return;
            }

            // ---------- 4) Lưu trạng thái promo vào session (để trang khác đọc lại) ----------
            // CMT: Tạo session nếu chưa có; có thể cân nhắc rotate session id sau đăng nhập để tránh fixation.
            HttpSession session = request.getSession(true);
            session.setAttribute("promoId", promo.getPromoID());
            session.setAttribute("promoPercent", percent);
            session.setAttribute("promoCode", String.valueOf(promo.getPromoID())); // CMT: giữ tương thích chỗ khác nếu đang dùng "promoCode"

            // ---------- 5) Trả JSON thành công ----------
            out.write("{\"ok\":true,"
                    + "\"type\":\"percent\","
                    + "\"promoId\":" + promo.getPromoID() + ","
                    + "\"value\":" + percent
                    + "}");
        } catch (Exception ex) {
            // CMT: Bắt mọi exception để luôn trả JSON (giúp client hiện message thay vì rơi vào .error)
            ex.printStackTrace();

            // NOTE: writer ở try-with-resources đã đóng; gọi lại getWriter() để trả JSON lỗi
            // Hạn chế: nếu đã ghi một phần JSON trước khi lỗi, response có thể bị "trộn".
            // Thực tế nên buffer chuỗi trước rồi write một lần (xem gợi ý bên dưới).
            response.getWriter().write("{\"ok\":false,\"message\":\"Server error: "
                    + ex.getClass().getSimpleName() + "\"}");
            // TODO (tuỳ nhu cầu): có thể set status code rõ hơn, ví dụ 500
            // response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    // CMT: Cho phép GET map về POST để thuận tiện test; chuẩn REST thì chỉ nên dùng POST
    // và bật CSRF token kiểm soát form/ Ajax.
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doPost(req, resp);
    }
}
