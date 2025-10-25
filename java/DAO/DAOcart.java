/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import entity.cart;
import entity.product;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DAOcart extends DBconnect.DBconnect {

    // LẤY TẤT CẢ SẢN PHẨM TRONG GIỎ HÀNG DỰA TRÊN CUSTOMER_ID
    public List<cart> getAll(int customer_id) { // <-- SỬA: Thay đổi tham số từ String username sang int customer_id
        List<cart> list = new ArrayList<>();
        // SỬA: Câu SQL để lọc theo customer_id
        String sql = "select * from cart where customer_id = ?"; 
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, customer_id); // <-- SỬA: Dùng setInt
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                cart c = new cart(rs.getInt("cart_id"), 
                                  rs.getInt("customer_id"), // <-- SỬA: Lấy customer_id
                                  rs.getInt("product_id"), 
                                  rs.getInt("quantity"),
                                  rs.getFloat("price"), // <-- SỬA: Lấy float price
                                  rs.getString("size_name"));
                list.add(c);
            }
            System.out.println("DAO.getAll for customer_id " + customer_id + ": Found " + list.size() + " items.");
        } catch (Exception e) {
            System.err.println("Error in DAO.getAll: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    // THÊM SẢN PHẨM MỚI VÀO GIỎ HÀNG
    public void insertCart(int quantity, float price, int customer_id, int product_id, String size_name) { // <-- SỬA: customer_id (int)
        // SỬA: Chỉ định rõ các cột cần INSERT (và thứ tự)
        String sql = "insert into cart(quantity, price, customer_id, product_id, size_name) values(?,?,?,?,?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, quantity);
            st.setFloat(2, price);
            st.setInt(3, customer_id); // <-- SỬA: Dùng setInt
            st.setInt(4, product_id);
            st.setString(5, size_name);
            int rowsAffected = st.executeUpdate();
            System.out.println("DAO.insertCart: Rows affected: " + rowsAffected + " for customer_id: " + customer_id);
        } catch (SQLException e) {
            System.err.println("Error in DAO.insertCart: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // CẬP NHẬT SẢN PHẨM TRONG GIỎ HÀNG
    public void updateCart(int customer_id, int product_id, int quantity, float price, String size_name) { // <-- SỬA: customer_id (int)
        // SỬA: Tối ưu câu lệnh UPDATE, chỉ cập nhật quantity và price
        String sql = "update cart set quantity = ?, price = ? where customer_id = ? and product_id = ? and size_name = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, quantity);
            st.setFloat(2, price);
            st.setInt(3, customer_id); // <-- SỬA: Dùng setInt
            st.setInt(4, product_id);
            st.setString(5, size_name);
            int rowsAffected = st.executeUpdate();
            System.out.println("DAO.updateCart: Rows affected: " + rowsAffected + " for customer_id: " + customer_id);
        } catch (SQLException e) {
            System.err.println("Error in DAO.updateCart: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // XÓA SẢN PHẨM TRONG GIỎ HÀNG
    public void deleteCart(int product_id, int customer_id) { // <-- SỬA: customer_id (int)
        String sql = "delete from cart where product_id = ? and customer_id = ?"; // <-- SỬA: Dùng customer_id
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, product_id);
            st.setInt(2, customer_id); // <-- SỬA: Dùng setInt
            int rowsAffected = st.executeUpdate();
            System.out.println("DAO.deleteCart: Rows affected: " + rowsAffected + " for customer_id: " + customer_id);
        } catch (SQLException e) {
            System.err.println("Error in DAO.deleteCart: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    // XÓA SẢN PHẨM THEO SIZE TRONG GIỎ HÀNG
    public void deleteCartBySize(int product_id, int customer_id, String size_name) { // <-- SỬA: customer_id (int)
        String sql = "delete from cart where product_id = ? and customer_id = ? and size_name = ?"; // <-- SỬA: Dùng customer_id
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, product_id);
            st.setInt(2, customer_id); // <-- SỬA: Dùng setInt
            st.setString(3, size_name);
            int rowsAffected = st.executeUpdate();
            System.out.println("DAO.deleteCartBySize: Rows affected: " + rowsAffected + " for customer_id: " + customer_id);
        } catch (SQLException e) {
            System.err.println("Error in DAO.deleteCartBySize: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // XÓA TẤT CẢ SẢN PHẨM TRONG GIỎ HÀNG
    public void deleteAllCart(int customer_id) { // <-- SỬA: customer_id (int)
        String sql = "delete from cart where customer_id = ?"; // <-- SỬA: Dùng customer_id
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, customer_id); // <-- SỬA: Dùng setInt
            int rowsAffected = st.executeUpdate();
            System.out.println("DAO.deleteAllCart: Rows affected: " + rowsAffected + " for customer_id: " + customer_id);
        } catch (SQLException e) {
            System.err.println("Error in DAO.deleteAllCart: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // LẤY SẢN PHẨM THEO ID (Không thay đổi, vì đây là product DAO, không phải cart)
    public product getProductById(int product_id) {
        String sql = "select * from product where product_id=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, product_id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                product p = new product(rs.getInt("product_id"), rs.getInt("quantity"), rs.getInt("price"), rs.getInt("category_id"), rs.getInt("promo_id"), rs.getString("name"),
                        rs.getString("description"), rs.getString("pic_url"));
                return p;
            }
        } catch (SQLException e) {
            System.err.println("Error in DAO.getProductById: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // LẤY GIỎ HÀNG THEO CUSTOMER_ID (trả về một cart duy nhất - có vẻ không đúng, nên trả về List<cart>)
    // Phương thức này có vẻ dư thừa nếu đã có getAll(int customer_id)
    public cart getCartById(int customer_id) { // <-- SỬA: customer_id (int)
        String sql = "select * from cart where customer_id=?"; // <-- SỬA: Dùng customer_id
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, customer_id); // <-- SỬA: Dùng setInt
            ResultSet rs = st.executeQuery();
            // Nếu bạn muốn lấy 1 giỏ hàng duy nhất (ví dụ: chỉ có 1 item)
            // hoặc item đầu tiên, thì giữ nguyên.
            // Nếu không, bạn có thể cân nhắc xóa hoặc sửa thành getAll.
            if (rs.next()) { 
                cart c = new cart(rs.getInt("cart_id"), 
                                  rs.getInt("customer_id"), 
                                  rs.getInt("product_id"), 
                                  rs.getInt("quantity"),
                                  rs.getFloat("price"), // <-- SỬA: Lấy float price
                                  rs.getString("size_name"));
                return c;
            }
        } catch (SQLException e) {
            System.err.println("Error in DAO.getCartById: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public static void main(String[] args) {
        // DAOcart cart = new DAOcart(); // Có thể thêm test ở đây
    }
}