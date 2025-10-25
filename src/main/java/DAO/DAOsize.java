/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import entity.size;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException; // Import SQLException
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Administrator
 */
public class DAOsize extends DBconnect.DBconnect {

    public List<size> getAll() {
        List<size> list = new ArrayList<>();
        String sql = "select * from size_detail"; // Tên bảng là size_detail
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                // Thứ tự phải khớp với constructor trong entity.size
                size s = new size(rs.getString("size_name"), rs.getInt("product_id"), rs.getInt("quantity"));
                list.add(s);
            }
        } catch (SQLException e) { // Thay Exception bằng SQLException để bắt lỗi cụ thể hơn
            System.err.println("Error in DAO.DAOsize.getAll: " + e.getMessage()); // Dùng err cho lỗi
            e.printStackTrace(); // In stack trace để debug
        }
        return list;
    }

    public void updateQuanSize(int quantity, int product_id, String size_name) {
        String sql = "update size_detail\n"
                + "set quantity = ?\n"
                + "where product_id = ? and size_name = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, quantity);
            ps.setInt(2, product_id);
            ps.setString(3, size_name);
            ps.executeUpdate();
             System.out.println("DAO.DAOsize.updateQuanSize: Updated quantity for ProductID: " + product_id + ", Size: " + size_name + " to " + quantity);
        } catch (SQLException e) { // Thay Exception bằng SQLException
            System.err.println("Error in DAO.DAOsize.updateQuanSize: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public int getSizeQuantity(int id, String size_name) {
        String sql = "select quantity \n"
                + "from size_detail\n"
                + "where product_id = ? and size_name = ?";
        int quantity = 0;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            st.setString(2, size_name);
            ResultSet rs = st.executeQuery();
            if (rs.next()) { // Dùng if thay vì while nếu chỉ mong đợi 1 kết quả
                quantity = rs.getInt("quantity");
            }
        } catch (SQLException e) { // Thay Exception bằng SQLException
            System.err.println("Error in DAO.DAOsize.getSizeQuantity: " + e.getMessage());
            e.printStackTrace();
        }
        return quantity;
    }

    // BỔ SUNG PHƯƠNG THỨC NÀY
    // Phương thức getSizeByProductIdAndName để lấy toàn bộ object size
    public size getSizeByProductIdAndName(int productID, String size_name) {
        String sql = "SELECT size_name, quantity, product_id FROM size_detail WHERE product_id = ? AND size_name = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, productID);
            st.setString(2, size_name);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                // Tạo đối tượng size với các cột có trong database
                return new size(
                        rs.getString("size_name"),
                        rs.getInt("product_id"),
                        rs.getInt("quantity")
                );
            }
        } catch (SQLException e) {
            System.err.println("Error in DAO.DAOsize.getSizeByProductIdAndName: " + e.getMessage());
            e.printStackTrace();
        }
        return null; // Trả về null nếu không tìm thấy
    }
    
    // BỔ SUNG PHƯƠNG THỨC NÀY
    // Phương thức getTotalQuantityByProductId cho sản phẩm
    public int getTotalQuantityByProductId(int productID) {
        String sql = "SELECT SUM(quantity) FROM size_detail WHERE product_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, productID);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1); // Trả về tổng quantity
            }
        } catch (SQLException e) {
            System.err.println("Error in DAO.DAOsize.getTotalQuantityByProductId: " + e.getMessage());
            e.printStackTrace();
        }
        return 0; // Trả về 0 nếu không tìm thấy hoặc có lỗi
    }
}