package controller;

import DAO.VoucherDAO;
import entity.Voucher;
import com.google.gson.Gson; // [RECOMMENDED] Dùng Gson để tạo JSON an toàn
import entity.Customer;
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
public class ApplyVoucherController extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding(StandardCharsets.UTF_8.name());
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        Map<String, Object> jsonRes = new HashMap<>();

        try {
            String code = request.getParameter("code");
            if (code == null || code.trim().isEmpty()) {
                jsonRes.put("ok", false);
                jsonRes.put("message", "Please enter a voucher ID.");
                out.write(gson.toJson(jsonRes));
                return;
            }
            String voucherId = code.trim();
            VoucherDAO dao = new VoucherDAO();

            // 1. Lấy thông tin Voucher
            Voucher voucher = dao.getActiveByIdDb(voucherId);

            if (voucher == null) {
                jsonRes.put("ok", false);
                jsonRes.put("message", "Voucher not found or expired.");
            } else {
                // 2. [MỚI] Kiểm tra user đã dùng chưa
                HttpSession session = request.getSession(false);
                Customer acc = (session != null) ? (Customer) session.getAttribute("acc") : null;

                if (acc != null) {
                    boolean isUsed = dao.hasUsedVoucher(acc.getCustomer_id(), voucher.getVoucherID());
                    if (isUsed) {
                        jsonRes.put("ok", false);
                        jsonRes.put("message", "You have already used this voucher. This voucher can only be used once per account.");
                        out.write(gson.toJson(jsonRes));
                        return;
                    }
                } else {
                    // Nếu chưa login thì có thể tạm cho áp dụng để xem giá, 
                    // nhưng khi thanh toán (Checkout) phải bắt login và check lại.
                }

                // 3. Xử lý thành công
                int percent = voucher.getVoucherPercent();
                int maxDiscount = voucher.getMaxDiscountAmount(); // [MỚI]

                session.setAttribute("voucherId", voucher.getVoucherID());
                session.setAttribute("voucherPercent", percent);
                session.setAttribute("maxDiscount", maxDiscount); // [MỚI] Lưu max discount vào session

                jsonRes.put("ok", true);
                jsonRes.put("type", "percent");
                jsonRes.put("voucherId", voucher.getVoucherID());
                jsonRes.put("value", percent);
                jsonRes.put("maxDiscount", maxDiscount); // [MỚI] Trả về cho Frontend hiển thị
                jsonRes.put("message", "Voucher applied! Discount: " + percent + "% (Max: " + maxDiscount + "đ)");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            jsonRes.put("ok", false);
            jsonRes.put("message", "Server error: " + ex.getMessage());
        }
        out.write(gson.toJson(jsonRes));
        out.flush();
    }
}
