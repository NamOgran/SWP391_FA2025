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
 *
 */
public class Size_detailDAO extends DBConnect.DBConnect {

    // Lấy tất cả danh sách size_detail
    public List<Size_detail> getAll() {
        List<Size_detail> list = new ArrayList<>();
        String sql = "select * from size_detail"; // Đã đúng
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Size_detail s = new Size_detail(rs.getString("size_name"), rs.getInt("product_id"), rs.getInt("quantity"));
                list.add(s);
            }
        } catch (SQLException e) {
            System.err.println("Error in SizeDAO.getAll: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    // Cập nhật số lượng cụ thể (set cứng giá trị)
    public void updateQuanSize(int quantity, int product_id, String size_name) {
        String sql = "update size_detail set quantity = ? where product_id = ? and size_name = ?"; // Đã đúng
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, quantity);
            ps.setInt(2, product_id);
            ps.setString(3, size_name);
            ps.executeUpdate();
            System.out.println("SizeDAO.updateQuanSize: Updated ProductID: " + product_id + ", Size: " + size_name + " to " + quantity);
        } catch (SQLException e) {
            System.err.println("Error in SizeDAO.updateQuanSize: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Lấy số lượng của 1 size cụ thể
    public int getSizeQuantity(int id, String size_name) {
        // SỬA: size_detail -> size_detail
        String sql = "select quantity from size_detail where product_id = ? and size_name = ?";
        int quantity = 0;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            st.setString(2, size_name);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                quantity = rs.getInt("quantity");
            }
        } catch (SQLException e) {
            System.err.println("Error in SizeDAO.getSizeQuantity: " + e.getMessage());
            e.printStackTrace();
        }
        return quantity;
    }

    // Lấy object Size_detail đầy đủ
    public Size_detail getSizeByProductIdAndName(int productID, String size_name) {
        // SỬA: size_detail -> size_detail
        String sql = "SELECT size_name, quantity, product_id FROM size_detail WHERE product_id = ? AND size_name = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, productID);
            st.setString(2, size_name);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new Size_detail(
                        rs.getString("size_name"),
                        rs.getInt("product_id"),
                        rs.getInt("quantity")
                );
            }
        } catch (SQLException e) {
            System.err.println("Error in SizeDAO.getSizeByProductIdAndName: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Kiểm tra xem một sản phẩm có tồn tại trong size_detail không.
     */
    public boolean hasDataForProduct(int productId) {
        // SỬA: size_detail -> size_detail
        String sql = "SELECT TOP 1 1 FROM size_detail WHERE product_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, productId);
            try (ResultSet rs = st.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.err.println("SizeDAO.hasDataForProduct: " + e.getMessage());
            return true;
        }
    }

    // Lấy danh sách các size của 1 sản phẩm
    public List<Size_detail> getSizesByProductId(int productId) {
        List<Size_detail> list = new ArrayList<>();
        // SỬA: size_detail -> size_detail
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
            System.err.println("SizeDAO.getSizesByProductId: " + e.getMessage());
        }
        return list;
    }

    // Cộng hoặc trừ số lượng (dùng cho đặt hàng/nhập hàng)
    public void updateSize_detailAfterOrder(int productId, String size_name, int changeQty) {
        // SỬA: size_detail -> size_detail
        String sql = "UPDATE size_detail SET quantity = quantity + ? WHERE product_id = ? AND size_name = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, changeQty);
            ps.setInt(2, productId);
            ps.setString(3, size_name);
            ps.executeUpdate();
            System.out.println("SizeDAO.updateSize_detailAfterOrder: Size_detail changed by " + changeQty
                    + " for ProductID=" + productId + ", Size=" + size_name);
        } catch (SQLException e) {
            System.err.println("Error in SizeDAO.updateSize_detailAfterOrder: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Kiểm tra còn hàng không
    public boolean isInSize_detail(int productId, String size_name) {
        // SỬA: size_detail -> size_detail
        String sql = "SELECT quantity FROM size_detail WHERE product_id = ? AND size_name = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, productId);
            ps.setString(2, size_name);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("quantity") > 0;
            }
        } catch (SQLException e) {
            System.err.println("Error in SizeDAO.isInSize_detail: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // Thêm mới size vào kho
    public void insert(Size_detail s) {
        // SỬA: size_detail -> size_detail
        String sql = "INSERT INTO size_detail (size_name, product_id, quantity) VALUES (?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, s.getSize_name());
            st.setInt(2, s.getProduct_id());
            st.setInt(3, s.getQuantity());
            st.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error SizeDAO.insert: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Lấy tổng số lượng tồn kho của một sản phẩm (cộng dồn các size)
    public int getTotalQuantityByProductId(int productId) {
        // SỬA: size_detail -> size_detail
        String sql = "SELECT SUM(quantity) FROM size_detail WHERE product_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, productId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1); // Trả về tổng quantity
                }
            }
        } catch (SQLException e) {
            System.err.println("Error SizeDAO.getTotalQuantityByProductId: " + e.getMessage());
        }
        return 0;
    }

    // Xóa tất cả size của một sản phẩm
    public void deleteByProductId(int productId) {
        // SỬA: size_detail -> size_detail
        String sql = "DELETE FROM size_detail WHERE product_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, productId);
            st.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error SizeDAO.deleteByProductId: " + e.getMessage());
        }
    }
}
