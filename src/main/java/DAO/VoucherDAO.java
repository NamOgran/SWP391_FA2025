package DAO;

import entity.Promo;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * 
 */
public class PromoDAO extends DBConnect.DBConnect {

    public List<Promo> getAll() {
        List<Promo> list = new ArrayList<>();
        String sql = "SELECT * FROM promo";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Promo p = new Promo(
                        rs.getInt("promo_id"),
                        rs.getInt("promo_percent"),
                        rs.getDate("start_date"),
                        rs.getDate("end_date"));
                list.add(p);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    // === START: NEW PAGINATION METHODS ===

    /**
     * Lấy tổng số khuyến mãi (hỗ trợ tìm kiếm)
     * @param searchKeyword Từ khóa tìm kiếm (theo %)
     * @return Tổng số khuyến mãi
     */
    public int getTotalPromoCount(String searchKeyword) {
        String sql = "SELECT COUNT(*) FROM promo";
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            // Đảm bảo tìm kiếm hoạt động trên SQL Server (chuyển int sang varchar)
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
            System.err.println("Lỗi PromoDAO.getTotalPromoCount: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Lấy danh sách khuyến mãi đã phân trang (hỗ trợ tìm kiếm)
     * @param searchKeyword Từ khóa tìm kiếm (theo %)
     * @param pageIndex Trang hiện tại (bắt đầu từ 1)
     * @param pageSize Số lượng mỗi trang
     * @return Danh sách Promo
     */
    public List<Promo> getPaginatedPromos(String searchKeyword, int pageIndex, int pageSize) {
        List<Promo> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM promo");

        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            sql.append(" WHERE CAST(promo_percent AS VARCHAR) LIKE ?");
        }

        sql.append(" ORDER BY promo_id DESC"); // Sắp xếp mặc định
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY"); // Phân trang SQL Server

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
                    Promo p = new Promo(
                            rs.getInt("promo_id"),
                            rs.getInt("promo_percent"),
                            rs.getDate("start_date"),
                            rs.getDate("end_date"));
                    list.add(p);
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi PromoDAO.getPaginatedPromos: " + e.getMessage());
        }
        return list;
    }
    
    // === END: NEW PAGINATION METHODS ===


    public boolean addIfNotExist(int percent) {
        String sql
                = "IF NOT EXISTS (SELECT 1 FROM promo WHERE promo_percent = ?)\n"
                + "BEGIN\n"
                + "  INSERT INTO promo (promo_percent, start_date, end_date)\n"
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

    public int getIdPromo(int percent) {
        String sql = "SELECT promo_id FROM promo WHERE promo_percent = ?";
        int id = 0;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, percent);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                id = rs.getInt("promo_id");
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return id;
    }

    // Thêm promo mới
    public void addPromo(Promo p) {
        String sql = "INSERT INTO promo (promo_percent, start_date, end_date) VALUES (?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, p.getPromoPercent());
            st.setDate(2, new java.sql.Date(p.getStartDate().getTime()));
            st.setDate(3, new java.sql.Date(p.getEndDate().getTime()));
            st.executeUpdate();
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    // Cập nhật promo
    public void updatePromo(Promo p) {
        String sql = "UPDATE promo SET promo_percent = ?, start_date = ?, end_date = ? WHERE promo_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, p.getPromoPercent());
            st.setDate(2, new java.sql.Date(p.getStartDate().getTime()));
            st.setDate(3, new java.sql.Date(p.getEndDate().getTime()));
            st.setInt(4, p.getPromoID());
            st.executeUpdate();
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    // Xóa promo
    public void deletePromo(int id) {
        String sql = "DELETE FROM promo WHERE promo_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            st.executeUpdate();
        } catch (Exception e) {
            System.out.println(e);
        }
    }

    // Tìm kiếm promo theo phần trăm
    public List<Promo> searchPromo(String keyword) {
        List<Promo> list = new ArrayList<>();
        String sql = "SELECT * FROM promo WHERE CAST(promo_percent AS VARCHAR) LIKE ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, "%" + keyword + "%");
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new Promo(
                        rs.getInt("promo_id"),
                        rs.getInt("promo_percent"),
                        rs.getDate("start_date"),
                        rs.getDate("end_date")
                ));
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    // Lấy promo theo ID (không kiểm tra hiệu lực)
    public Promo getById(int id) {
        String sql = "SELECT promo_id, promo_percent, start_date, end_date FROM promo WHERE promo_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new Promo(
                        rs.getInt("promo_id"),
                        rs.getInt("promo_percent"),
                        rs.getDate("start_date"),
                        rs.getDate("end_date")
                );
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return null;
    }

    // Kiểm tra có tồn tại promo theo ID không
    public boolean existsById(int id) {
        String sql = "SELECT 1 FROM promo WHERE promo_id = ?";
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
        String sql = "SELECT promo_percent FROM promo WHERE promo_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt("promo_percent");
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return null;
    }

    // Lấy Promo theo ID nhưng CHỈ khi còn hiệu lực ngày (lọc ở SQL - SQL Server)
    public Promo getActiveById(int id) {
        String sql
                = "SELECT promo_id, promo_percent, start_date, end_date "
                + "FROM promo "
                + "WHERE promo_id = ? "
                + "  AND (start_date IS NULL OR CAST(GETDATE() AS DATE) >= CAST(start_date AS DATE)) "
                + "  AND (end_date   IS NULL OR CAST(GETDATE() AS DATE) <= CAST(end_date   AS DATE))";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new Promo(
                        rs.getInt("promo_id"),
                        rs.getInt("promo_percent"),
                        rs.getDate("start_date"),
                        rs.getDate("end_date")
                );
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return null;
    }

    // --- THÊM VÀO CUỐI FILE PromoDAO ---
    /**
     * Lấy promo còn hiệu lực (lọc theo ngày ngay tại DB).
     * PostgreSQL dùng
     * CURRENT_DATE.
     */
    public Promo getActiveByIdDb(int id) {
        String sql
                = "SELECT promo_id, promo_percent, start_date, end_date "
                + "FROM public.promo "
                + // dùng public.promo để chắc chắn đúng schema
          
                "WHERE promo_id = ? "
                + "  AND (start_date IS NULL OR start_date <= CURRENT_DATE) "
                + "  AND (end_date   IS NULL OR end_date   >= CURRENT_DATE)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new Promo(
                        rs.getInt("promo_id"),
                        rs.getInt("promo_percent"),
                        rs.getDate("start_date"),
                        rs.getDate("end_date")
                );
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return null;
    }

    /**
     * Debug: xem servlet đang kết nối tới DB nào.
     */
    public String debugUrl() {
        try {
            return (connection != null && !connection.isClosed())
                    ?
                    connection.getMetaData().getURL()
                    : "connection is null/closed";
        } catch (Exception e) {
            return "debugUrl error: " + e.getMessage();
        }
    }

}