package DAO;

import entity.Voucher;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class VoucherDAO extends DBConnect.DBConnect {

    public List<Voucher> getAll() {
        List<Voucher> list = new ArrayList<>();
        // [FIX] DB uses 'promo_id' and 'promo_percent'
        String sql = "SELECT * FROM voucher";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Voucher p = new Voucher(
                        rs.getInt("promo_id"),      // [FIX] Map promo_id -> voucherID
                        rs.getInt("promo_percent"), // [FIX] Map promo_percent -> voucherPercent
                        rs.getDate("start_date"),
                        rs.getDate("end_date"));
                list.add(p);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    // === START: PAGINATION METHODS ===

    public int getTotalVoucherCount(String searchKeyword) {
        String sql = "SELECT COUNT(*) FROM voucher";
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            // [FIX] Use promo_percent
            sql += " WHERE CAST(promo_percent AS VARCHAR) LIKE ?";
        }

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                st.setString(1, "%" + searchKeyword + "%");
            }
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi VoucherDAO.getTotalVoucherCount: " + e.getMessage());
        }
        return 0;
    }

    public List<Voucher> getPaginatedVouchers(String searchKeyword, int pageIndex, int pageSize) {
        List<Voucher> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM voucher");

        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            // [FIX] Use promo_percent
            sql.append(" WHERE CAST(promo_percent AS VARCHAR) LIKE ?");
        }

        sql.append(" ORDER BY promo_id DESC"); // [FIX] Use promo_id
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                st.setString(paramIndex++, "%" + searchKeyword + "%");
            }

            int offset = (pageIndex - 1) * pageSize;
            st.setInt(paramIndex++, offset);
            st.setInt(paramIndex++, pageSize);

            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Voucher p = new Voucher(
                            rs.getInt("promo_id"),      // [FIX]
                            rs.getInt("promo_percent"), // [FIX]
                            rs.getDate("start_date"),
                            rs.getDate("end_date"));
                    list.add(p);
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi VoucherDAO.getPaginatedVouchers: " + e.getMessage());
        }
        return list;
    }
    
    // === END: PAGINATION METHODS ===

    public boolean addIfNotExist(int percent) {
        // [FIX] Use promo_percent
        String sql
                = "IF NOT EXISTS (SELECT 1 FROM voucher WHERE promo_percent = ?)\n"
                + "BEGIN\n"
                + "  INSERT INTO voucher (promo_percent, start_date, end_date)\n"
                + "  VALUES (?,'2024-02-26','2024-04-01')\n"
                + "END";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, percent);
            st.setInt(2, percent);
            st.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println(e);
        }
        return false;
    }

    public int getIdVoucher(int percent) {
        // [FIX] Use promo_id and promo_percent
        String sql = "SELECT promo_id FROM voucher WHERE promo_percent = ?";
        int id = 0;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, percent);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                id = rs.getInt("promo_id"); // [FIX]
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return id;
    }

    // Thêm voucher mới
    public void addVoucher(Voucher p) {
        // [FIX] Use promo_percent
        String sql = "INSERT INTO voucher (promo_percent, start_date, end_date) VALUES (?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, p.getVoucherPercent());
            st.setDate(2, new java.sql.Date(p.getStartDate().getTime()));
            st.setDate(3, new java.sql.Date(p.getEndDate().getTime()));
            st.executeUpdate();
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    // Cập nhật voucher
    public void updateVoucher(Voucher p) {
        // [FIX] Use promo_percent and promo_id
        String sql = "UPDATE voucher SET promo_percent = ?, start_date = ?, end_date = ? WHERE promo_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, p.getVoucherPercent());
            st.setDate(2, new java.sql.Date(p.getStartDate().getTime()));
            st.setDate(3, new java.sql.Date(p.getEndDate().getTime()));
            st.setInt(4, p.getVoucherID());
            st.executeUpdate();
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    // Xóa voucher
    public void deleteVoucher(int id) {
        // [FIX] Use promo_id
        String sql = "DELETE FROM voucher WHERE promo_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            st.executeUpdate();
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    // Tìm kiếm voucher theo phần trăm
    public List<Voucher> searchVoucher(String keyword) {
        List<Voucher> list = new ArrayList<>();
        // [FIX] Use promo_percent
        String sql = "SELECT * FROM voucher WHERE CAST(promo_percent AS VARCHAR) LIKE ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, "%" + keyword + "%");
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new Voucher(
                        rs.getInt("promo_id"),      // [FIX]
                        rs.getInt("promo_percent"), // [FIX]
                        rs.getDate("start_date"),
                        rs.getDate("end_date")
                ));
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    // Lấy voucher theo ID (không kiểm tra hiệu lực)
    public Voucher getById(int id) {
        // [FIX] Use promo_id and promo_percent
        String sql = "SELECT promo_id, promo_percent, start_date, end_date FROM voucher WHERE promo_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new Voucher(
                        rs.getInt("promo_id"),      // [FIX]
                        rs.getInt("promo_percent"), // [FIX]
                        rs.getDate("start_date"),
                        rs.getDate("end_date")
                );
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return null;
    }

    // Kiểm tra có tồn tại voucher theo ID không
    public boolean existsById(int id) {
        // [FIX] Use promo_id
        String sql = "SELECT 1 FROM voucher WHERE promo_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            return rs.next();
        } catch (Exception e) {
            System.out.println(e);
        }
        return false;
    }

    // Lấy phần trăm giảm theo ID (tiện dùng nhanh)
    public Integer getPercentById(int id) {
        // [FIX] Use promo_percent and promo_id
        String sql = "SELECT promo_percent FROM voucher WHERE promo_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt("promo_percent"); // [FIX]
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return null;
    }

    // Lấy Voucher theo ID nhưng CHỈ khi còn hiệu lực ngày (SQL Server)
    public Voucher getActiveById(int id) {
        // [FIX] Use promo_id and promo_percent
        String sql
                = "SELECT promo_id, promo_percent, start_date, end_date "
                + "FROM voucher "
                + "WHERE promo_id = ? "
                + "  AND (start_date IS NULL OR CAST(GETDATE() AS DATE) >= CAST(start_date AS DATE)) "
                + "  AND (end_date   IS NULL OR CAST(GETDATE() AS DATE) <= CAST(end_date   AS DATE))";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new Voucher(
                        rs.getInt("promo_id"),      // [FIX]
                        rs.getInt("promo_percent"), // [FIX]
                        rs.getDate("start_date"),
                        rs.getDate("end_date")
                );
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return null;
    }

    // Lấy voucher còn hiệu lực (phiên bản khác)
    public Voucher getActiveByIdDb(int id) {
        // [FIX] Use promo_id and promo_percent
        String sql
                = "SELECT promo_id, promo_percent, start_date, end_date "
                + "FROM voucher "
                + "WHERE promo_id = ? "
                + "  AND (start_date IS NULL OR CAST(GETDATE() AS DATE) >= start_date) "
                + "  AND (end_date   IS NULL OR CAST(GETDATE() AS DATE) <= end_date)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new Voucher(
                        rs.getInt("promo_id"),      // [FIX]
                        rs.getInt("promo_percent"), // [FIX]
                        rs.getDate("start_date"),
                        rs.getDate("end_date")
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
}