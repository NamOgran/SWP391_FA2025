/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import entity.Size_detail;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * Size_detailDAO - Optimized Resource Management
 */
public class Size_detailDAO extends DBConnect.DBConnect {

    // Lấy tất cả danh sách size_detail
    public List<Size_detail> getAll() {
        List<Size_detail> list = new ArrayList<>();
        String sql = "select * from size_detail";
        // [FIX] Dùng try-with-resources để tự động đóng kết nối
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {

            while (rs.next()) {
                Size_detail s = new Size_detail(rs.getString("size_name"), rs.getInt("product_id"), rs.getInt("quantity"));
                list.add(s);
            }
        } catch (SQLException e) {
            System.err.println("Error in Size_detailDAO.getAll: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    // Cập nhật số lượng cụ thể
    public void updateQuanSize(int quantity, int product_id, String size_name) {
        String sql = "update size_detail set quantity = ? where product_id = ? and size_name = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, product_id);
            ps.setString(3, size_name);
            ps.executeUpdate();
            System.out.println("Size_detailDAO.updateQuanSize: Updated ProductID: " + product_id + ", Size: " + size_name + " to " + quantity);
        } catch (SQLException e) {
            System.err.println("Error in Size_detailDAO.updateQuanSize: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Lấy số lượng của 1 size cụ thể
    public int getSizeQuantity(int id, String size_name) {
        String sql = "select quantity from size_detail where product_id = ? and size_name = ?";
        int quantity = 0;
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            st.setString(2, size_name);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    quantity = rs.getInt("quantity");
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in Size_detailDAO.getSizeQuantity: " + e.getMessage());
            e.printStackTrace();
        }
        return quantity;
    }

    // Lấy object Size_detail đầy đủ
    public Size_detail getSizeByProductIdAndName(int productID, String size_name) {
        String sql = "SELECT size_name, quantity, product_id FROM size_detail WHERE product_id = ? AND size_name = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, productID);
            st.setString(2, size_name);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return new Size_detail(
                            rs.getString("size_name"),
                            rs.getInt("product_id"),
                            rs.getInt("quantity")
                    );
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in Size_detailDAO.getSizeByProductIdAndName: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Kiểm tra xem một sản phẩm có tồn tại trong size_detail không. Note: "TOP
     * 1" dùng cho SQL Server. Nếu dùng MySQL hãy đổi thành "LIMIT 1"
     */
    public boolean hasDataForProduct(int productId) {
        String sql = "SELECT TOP 1 1 FROM size_detail WHERE product_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, productId);
            try (ResultSet rs = st.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.err.println("Size_detailDAO.hasDataForProduct: " + e.getMessage());
            return true; // Mặc định trả về true để an toàn (tránh xóa nhầm nếu lỗi DB)
        }
    }

    // Lấy danh sách các size của 1 sản phẩm
    public List<Size_detail> getSizesByProductId(int productId) {
        List<Size_detail> list = new ArrayList<>();
        String sql = "SELECT * FROM size_detail WHERE product_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, productId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(new Size_detail(
                            rs.getString("size_name"),
                            rs.getInt("product_id"),
                            rs.getInt("quantity")
                    ));
                }
            }
        } catch (SQLException e) {
            System.err.println("Size_detailDAO.getSizesByProductId: " + e.getMessage());
        }
        return list;
    }

    // Cộng hoặc trừ số lượng (dùng cho đặt hàng/nhập hàng)
    public void updateSize_detailAfterOrder(int productId, String size_name, int changeQty) {
        String sql = "UPDATE size_detail SET quantity = quantity + ? WHERE product_id = ? AND size_name = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, changeQty);
            ps.setInt(2, productId);
            ps.setString(3, size_name);
            ps.executeUpdate();
            System.out.println("Size_detailDAO.updateSize_detailAfterOrder: Size_detail changed by " + changeQty
                    + " for ProductID=" + productId + ", Size=" + size_name);
        } catch (SQLException e) {
            System.err.println("Error in Size_detailDAO.updateSize_detailAfterOrder: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Kiểm tra còn hàng không
    public boolean isInSize_detail(int productId, String size_name) {
        String sql = "SELECT quantity FROM size_detail WHERE product_id = ? AND size_name = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setString(2, size_name);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("quantity") > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in Size_detailDAO.isInSize_detail: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // Thêm mới size vào kho
    public void insert(Size_detail s) {
        String sql = "INSERT INTO size_detail (size_name, product_id, quantity) VALUES (?, ?, ?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, s.getSize_name());
            st.setInt(2, s.getProduct_id());
            st.setInt(3, s.getQuantity());
            st.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error Size_detailDAO.insert: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Lấy tổng số lượng tồn kho của một sản phẩm (cộng dồn các size)
    public int getTotalQuantityByProductId(int productId) {
        String sql = "SELECT SUM(quantity) FROM size_detail WHERE product_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, productId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error Size_detailDAO.getTotalQuantityByProductId: " + e.getMessage());
        }
        return 0;
    }

    // Xóa tất cả size của một sản phẩm (Hàm quan trọng bạn vừa thêm)
    public void deleteByProductId(int productId) {
        String sql = "DELETE FROM size_detail WHERE product_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, productId);
            st.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error Size_detailDAO.deleteByProductId: " + e.getMessage());
        }
    }
}
