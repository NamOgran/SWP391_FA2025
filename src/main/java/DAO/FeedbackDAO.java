package DAO;

import DBConnect.DBConnect;
import entity.Feedback;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class FeedBackDAO extends DBConnect {

    /**
     * Lấy danh sách feedback cơ bản theo ID sản phẩm. (Từ file số 2)
     */
    public List<Feedback> getFeedbackByProductId(int productId) {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT * FROM feedback WHERE product_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, productId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {

                    // ===== ĐÃ SỬA LỖI CONSTRUCTOR =====
                    // Sử dụng constructor rỗng và setters
                    Feedback f = new Feedback();
                    f.setFeedbackId(rs.getInt("feedback_id"));
                    f.setContent(rs.getString("content"));
                    f.setRatePoint(rs.getInt("rate_point"));
                    f.setCustomerId(rs.getInt("customer_id"));
                    f.setProductId(rs.getInt("product_id"));
                    // Các trường khác (orderId, createdAt) sẽ là null/0
                    // vì câu SELECT * không có join

                    list.add(f);
                }
            }
        } catch (SQLException e) {
            System.err.println("FeedbackDAO.getFeedbackByProductId: " + e.getMessage());
        }
        return list;
    }

    /**
     * Lấy danh sách feedback theo ID khách hàng. (Từ file số 2)
     */
    public List<Feedback> getFeedbackByCustomerId(int customerId) {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT * FROM feedback WHERE customer_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, customerId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {

                    // ===== ĐÃ SỬA LỖI CONSTRUCTOR =====
                    // Sử dụng constructor rỗng và setters
                    Feedback f = new Feedback();
                    f.setFeedbackId(rs.getInt("feedback_id"));
                    f.setContent(rs.getString("content"));
                    f.setRatePoint(rs.getInt("rate_point"));
                    f.setCustomerId(rs.getInt("customer_id"));
                    f.setProductId(rs.getInt("product_id"));

                    list.add(f);
                }
            }
        } catch (SQLException e) {
            System.err.println("FeedbackDAO.getFeedbackByCustomerId: " + e.getMessage());
        }
        return list;
    }

    public boolean insertFeedback(Feedback feedback) {
    // SỬA: Thêm order_id vào câu lệnh SQL INSERT
    String sql = "INSERT INTO feedback (customer_id, product_id, order_id, rate_point, content, created_at) VALUES (?, ?, ?, ?, ?, GETDATE())";
    
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, feedback.getCustomerId());
        ps.setInt(2, feedback.getProductId());
        ps.setInt(3, feedback.getOrderId()); // SỬA: Đã thêm set order_id
        ps.setInt(4, feedback.getRatePoint());
        ps.setString(5, feedback.getContent());
        // GETDATE() sẽ tự lấy giờ hiện tại của SQL Server, không cần set tham số thứ 6
        
        return ps.executeUpdate() > 0;
    } catch (SQLException e) {
        System.err.println("Error inserting feedback: " + e.getMessage());
        e.printStackTrace();
        return false;
    }
}

    public List<Feedback> getFeedbacksWithCustomerByProductId(int productId) {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT f.*, c.fullName FROM feedback f "
                + "JOIN customer c ON f.customer_id = c.customer_id "
                + "WHERE f.product_id = ? ORDER BY f.created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Feedback fb = new Feedback();
                    fb.setFeedbackId(rs.getInt("feedback_id"));
                    fb.setCustomerId(rs.getInt("customer_id"));
                    fb.setProductId(rs.getInt("product_id"));
                    fb.setOrderId(rs.getInt("order_id"));
                    fb.setRatePoint(rs.getInt("rate_point"));
                    fb.setContent(rs.getString("content"));
                    fb.setCreatedAt(rs.getTimestamp("created_at"));
                    fb.setCustomerName(rs.getString("fullName"));
                    list.add(fb);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean hasPurchased(int customerId, int productId, int orderId) {
        String sql = "SELECT COUNT(*) FROM orders o "
                + "JOIN order_detail od ON o.order_id = od.order_id "
                + "WHERE o.order_id = ? AND o.customer_id = ? AND od.product_id = ? AND o.status = 'Delivered'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, customerId);
            ps.setInt(3, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean hasAlreadyReviewed(int customerId, int productId, int orderId) {
    // SỬA: Kiểm tra theo order_id để mỗi lần mua đều được đánh giá
    String sql = "SELECT COUNT(*) FROM feedback WHERE customer_id = ? AND product_id = ? AND order_id = ?";
    
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, customerId);
        ps.setInt(2, productId);
        ps.setInt(3, orderId); // Thêm check orderId
        
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}

    // Hàm hasDataForProduct của bạn cũng đã đúng, giữ nguyên
    public boolean hasDataForProduct(int productId) {
        String sql = "SELECT TOP 1 1 FROM feedback WHERE product_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, productId);
            try (ResultSet rs = st.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.err.println("FeedbackDAO.hasDataForProduct: " + e.getMessage());
            return false;
        }
    }
    public List<Feedback> getFeedbacksByProductID(int productId) {
        List<Feedback> list = new ArrayList<>();
        // Join bảng feedback với customer để lấy fullName
        String sql = "SELECT f.rate_point, f.content, c.fullName " +
                     "FROM feedback f " +
                     "JOIN customer c ON f.customer_id = c.customer_id " +
                     "WHERE f.product_id = ? " +
                     "ORDER BY f.feedback_id DESC"; // Lấy mới nhất trước

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, productId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Feedback fb = new Feedback();
                    fb.setRatePoint(rs.getInt("rate_point"));
                    fb.setContent(rs.getString("content"));
                    // Chỉ set tên khách hàng để hiển thị
                    fb.setCustomerName(rs.getString("fullName")); 
                    
                    list.add(fb);
                }
            }
        } catch (Exception e) {
            System.out.println("Error FeedBackDAO.getFeedbacksByProductID: " + e.getMessage());
        }
        return list;
    }
}
