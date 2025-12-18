package DAO;

import entity.Voucher;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class VoucherDAO extends DBConnect.DBConnect {

    // IMPORTANT: Make sure Entity Voucher.java is also updated to use String voucherID!
    public List<Voucher> getAll() {
        List<Voucher> list = new ArrayList<>();
        // [FIX] Use voucher_id (varchar)
        String sql = "SELECT * FROM voucher";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Voucher p = new Voucher(
                        rs.getString("voucher_id"), // [FIX] getString
                        rs.getInt("voucher_percent"),
                        rs.getDate("start_date"),
                        rs.getDate("end_date"),
                        rs.getInt("max_discount_amount"));
                list.add(p);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    // === PAGINATION METHODS ===
    public int getTotalVoucherCount(String searchKeyword) {
        String sql = "SELECT COUNT(*) FROM voucher";
        // Search by ID or Percent
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql += " WHERE voucher_id LIKE ? OR CAST(voucher_percent AS VARCHAR) LIKE ?";
        }

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                st.setString(1, "%" + searchKeyword + "%");
                st.setString(2, "%" + searchKeyword + "%");
            }
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            System.err.println("Error VoucherDAO.getTotalVoucherCount: " + e.getMessage());
        }
        return 0;
    }

    public List<Voucher> getPaginatedVouchers(String searchKeyword, int pageIndex, int pageSize) {
        List<Voucher> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM voucher");

        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append(" WHERE voucher_id LIKE ? OR CAST(voucher_percent AS VARCHAR) LIKE ?");
        }

        // [FIX] Sort by voucher_id instead of int ID
        sql.append(" ORDER BY voucher_id ASC");
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                st.setString(paramIndex++, "%" + searchKeyword + "%");
                st.setString(paramIndex++, "%" + searchKeyword + "%");
            }

            int offset = (pageIndex - 1) * pageSize;
            st.setInt(paramIndex++, offset);
            st.setInt(paramIndex++, pageSize);

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Voucher p = new Voucher(
                            rs.getString("voucher_id"), // [FIX] getString
                            rs.getInt("voucher_percent"),
                            rs.getDate("start_date"),
                            rs.getDate("end_date"),
                            rs.getInt("max_discount_amount"));
                    list.add(p);
                }
            }
        } catch (Exception e) {
            System.err.println("Error VoucherDAO.getPaginatedVouchers: " + e.getMessage());
        }
        return list;
    }

    // === CRUD METHODS ===
    // [FIX] This method was logic-heavy based on Int ID. 
    // Replaced logic: Add voucher if the String ID doesn't exist.
    public boolean addIfNotExist(String voucherId, int percent) {
        String sql = "IF NOT EXISTS (SELECT 1 FROM voucher WHERE voucher_id = ?) "
                + "BEGIN "
                + "  INSERT INTO voucher (voucher_id, voucher_percent, start_date, end_date) "
                + "  VALUES (?, ?, CAST(GETDATE() AS DATE), DATEADD(month, 1, GETDATE())) "
                + "END";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, voucherId);
            st.setString(2, voucherId);
            st.setInt(3, percent);
            st.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println(e);
        }
        return false;
    }

    // [FIX] Returns String ID.
    // If logic needs to find an ID by percent (which is ambiguous), return first match.
    public String getIdVoucher(int percent) {
        String sql = "SELECT TOP 1 voucher_id FROM voucher WHERE voucher_percent = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, percent);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getString("voucher_id");
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return null;
    }

    // Trong VoucherDAO.java
// 1. Sửa hàm thêm mới Voucher (Insert)
    public void insertVoucher(Voucher v) {
        // Thêm cột max_discount_amount vào câu SQL
        String sql = "INSERT INTO voucher (voucher_id, voucher_percent, start_date, end_date, max_discount_amount) "
                + "VALUES (?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, v.getVoucherID());
            st.setInt(2, v.getVoucherPercent());
            // Chuyển đổi java.util.Date sang java.sql.Date
            st.setDate(3, new java.sql.Date(v.getStartDate().getTime()));
            st.setDate(4, new java.sql.Date(v.getEndDate().getTime()));
            st.setInt(5, v.getMaxDiscountAmount()); // [MỚI] Set giá trị max

            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

// 2. Sửa hàm cập nhật Voucher (Update)
    public void updateVoucher(Voucher v) {
        // Thêm cập nhật cột max_discount_amount
        String sql = "UPDATE voucher SET voucher_percent = ?, start_date = ?, end_date = ?, max_discount_amount = ? "
                + "WHERE voucher_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, v.getVoucherPercent());
            st.setDate(2, new java.sql.Date(v.getStartDate().getTime()));
            st.setDate(3, new java.sql.Date(v.getEndDate().getTime()));
            st.setInt(4, v.getMaxDiscountAmount()); // [MỚI]
            st.setString(5, v.getVoucherID());

            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    // Delete voucher
    public void deleteVoucher(String id) { // [FIX] param String
        String sql = "DELETE FROM voucher WHERE voucher_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, id); // [FIX] setString
            st.executeUpdate();
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    // Search
    public List<Voucher> searchVoucher(String keyword) {
        List<Voucher> list = new ArrayList<>();
        // Search by ID or Percent
        String sql = "SELECT * FROM voucher WHERE voucher_id LIKE ? OR CAST(voucher_percent AS VARCHAR) LIKE ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, "%" + keyword + "%");
            st.setString(2, "%" + keyword + "%");
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new Voucher(
                        rs.getString("voucher_id"),
                        rs.getInt("voucher_percent"),
                        rs.getDate("start_date"),
                        rs.getDate("end_date")
                ));
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    // Get by ID
    public Voucher getById(String id) { // [FIX] param String
        String sql = "SELECT * FROM voucher WHERE voucher_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new Voucher(
                        rs.getString("voucher_id"),
                        rs.getInt("voucher_percent"),
                        rs.getDate("start_date"),
                        rs.getDate("end_date"),
                        rs.getInt("max_discount_amount") // [QUAN TRỌNG] Thêm dòng này
                );
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return null;
    }

    // Check exist
    public boolean existsById(String id) { // [FIX] param String
        String sql = "SELECT 1 FROM voucher WHERE voucher_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, id);
            ResultSet rs = st.executeQuery();
            return rs.next();
        } catch (Exception e) {
            System.out.println(e);
        }
        return false;
    }

    // Get percent
    public Integer getPercentById(String id) { // [FIX] param String
        String sql = "SELECT voucher_percent FROM voucher WHERE voucher_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt("voucher_percent");
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return null;
    }

    // Get Active Voucher
    public Voucher getActiveById(String id) { // [FIX] param String
        String sql = "SELECT * FROM voucher "
                + "WHERE voucher_id = ? "
                + "  AND (start_date IS NULL OR CAST(GETDATE() AS DATE) >= CAST(start_date AS DATE)) "
                + "  AND (end_date   IS NULL OR CAST(GETDATE() AS DATE) <= CAST(end_date   AS DATE))";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new Voucher(
                        rs.getString("voucher_id"),
                        rs.getInt("voucher_percent"),
                        rs.getDate("start_date"),
                        rs.getDate("end_date")
                );
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return null;
    }

    // Fallback Active Voucher
    public Voucher getActiveByIdDb(String id) {
        String sql = "SELECT * FROM voucher "
                + "WHERE voucher_id = ? "
                + "  AND (start_date IS NULL OR CAST(GETDATE() AS DATE) >= start_date) "
                + "  AND (end_date   IS NULL OR CAST(GETDATE() AS DATE) <= end_date)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new Voucher(
                        rs.getString("voucher_id"),
                        rs.getInt("voucher_percent"),
                        rs.getDate("start_date"),
                        rs.getDate("end_date"),
                        rs.getInt("max_discount_amount") // [MỚI] Lấy cột này
                );
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return null;
    }

    public String debugUrl() {
        try {
            return (connection != null && !connection.isClosed())
                    ? connection.getMetaData().getURL()
                    : "connection is null/closed";
        } catch (Exception e) {
            return "debugUrl error: " + e.getMessage();
        }
    }

    public boolean hasUsedVoucher(int customerId, String voucherId) {
        // Giả sử bảng orders có cột voucher_id. 
        // Nếu chưa có, bạn cần ALTER TABLE orders ADD voucher_id VARCHAR(50);
        String sql = "SELECT COUNT(*) FROM orders WHERE customer_id = ? AND voucher_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, customerId);
            st.setString(2, voucherId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0; // Trả về true nếu đã có đơn hàng dùng voucher này
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

}
