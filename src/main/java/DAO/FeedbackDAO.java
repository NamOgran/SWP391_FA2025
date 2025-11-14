package DAO;

import entity.Feedback;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO extends DBConnect.DBConnect {

    /**
     * Kiểm tra xem một sản phẩm có tồn tại trong feedback không.
     * @param productId ID sản phẩm
     * @return true nếu có, false nếu không
     */
    public boolean hasDataForProduct(int productId) {
        String sql = "SELECT TOP 1 1 FROM feedback WHERE product_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, productId);
            try (ResultSet rs = st.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.err.println("FeedbackDAO.hasDataForProduct: " + e.getMessage());
            return true; 
        }
    }
    
    /**
     * Lấy danh sách feedback theo ID sản phẩm.
     * @param productId ID sản phẩm
     * @return Danh sách Feedback
     */
    public List<Feedback> getFeedbackByProductId(int productId) {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT * FROM feedback WHERE product_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, productId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Feedback f = new Feedback(
                            rs.getInt("feedback_id"),
                            rs.getString("content"),
                            rs.getInt("rate_point"),
                            rs.getInt("customer_id"),
                            rs.getInt("product_id")
                    );
                    list.add(f);
                }
            }
        } catch (SQLException e) {
            System.err.println("FeedbackDAO.getFeedbackByProductId: " + e.getMessage());
        }
        return list;
    }
    /**
     * Lấy danh sách feedback theo ID khách hàng.
     * @param customerId ID khách hàng
     * @return Danh sách Feedback
     */
    public List<Feedback> getFeedbackByCustomerId(int customerId) {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT * FROM feedback WHERE customer_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, customerId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Feedback f = new Feedback(
                            rs.getInt("feedback_id"),
                            rs.getString("content"),
                            rs.getInt("rate_point"),
                            rs.getInt("customer_id"),
                            rs.getInt("product_id")
                    );
                    list.add(f);
                }
            }
        } catch (SQLException e) {
            System.err.println("FeedbackDAO.getFeedbackByCustomerId: " + e.getMessage());
        }
        return list;
    }
}