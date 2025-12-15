package controller;

import DAO.VoucherDAO;
import entity.Voucher;
import com.google.gson.Gson; // [RECOMMENDED] Dùng Gson để tạo JSON an toàn
import java.util.HashMap;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "ApplyVoucher", urlPatterns = {"/applyVoucher"})
public class ApplyVoucher extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding(StandardCharsets.UTF_8.name());
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());
        response.setContentType("application/json; charset=UTF-8");
        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate, max-age=0");

        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        Map<String, Object> jsonRes = new HashMap<>();

        try {
            String code = request.getParameter("code");

            // 1. Validate input
            if (code == null || code.trim().isEmpty()) {
                jsonRes.put("ok", false);
                jsonRes.put("message", "Please enter a voucher ID.");
                out.write(gson.toJson(jsonRes));
                return;
            }

            // [FIX] Lấy ID dạng String (Không ép sang int)
            String voucherId = code.trim(); 

            VoucherDAO dao = new VoucherDAO();
            
            // 2. Tìm voucher trong DB (ưu tiên active)
            Voucher voucher = dao.getActiveByIdDb(voucherId);

            // Fallback nếu DB trả null (do múi giờ/driver...)
            if (voucher == null) {
                voucher = dao.getActiveById(voucherId);
            }

            // 3. Kiểm tra kết quả
            if (voucher == null) {
                jsonRes.put("ok", false);
                jsonRes.put("message", "Voucher not found or expired.");
            } else {
                int percent = voucher.getVoucherPercent();
                if (percent <= 0 || percent > 100) {
                    jsonRes.put("ok", false);
                    jsonRes.put("message", "Invalid voucher percentage.");
                } else {
                    // Lưu session
                    HttpSession session = request.getSession(true);
                    session.setAttribute("voucherId", voucher.getVoucherID()); // Lưu String
                    session.setAttribute("voucherPercent", percent);
                    session.setAttribute("voucherCode", voucher.getVoucherID()); // Lưu String

                    // Trả về JSON thành công
                    jsonRes.put("ok", true);
                    jsonRes.put("type", "percent");
                    jsonRes.put("voucherId", voucher.getVoucherID()); // Trả về String
                    jsonRes.put("value", percent);
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            jsonRes.put("ok", false);
            jsonRes.put("message", "Server error: " + ex.getMessage());
        }
        
        out.write(gson.toJson(jsonRes));
        out.flush();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doPost(req, resp);
    }
}