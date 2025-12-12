/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import entity.Category; // BỔ SUNG IMPORT
import entity.Product;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException; // BỔ SUNG IMPORT
import java.util.ArrayList;
import java.util.List;

/**
 *
 * 
 */
public class CategoryDAO extends DBConnect.DBConnect {

   
    /**
     * Lấy tất cả danh mục (category) từ cơ sở dữ liệu.
     * @return một List<Category>
     */
    public List<Category> getAll() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM category"; // Truy vấn bảng category
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            
            while (rs.next()) {
                // Sử dụng constructor của Category(int, String, String)
                Category c = new Category(
                        rs.getInt("category_id"),
                        rs.getString("type"),
                        rs.getString("gender")
                );
                list.add(c);
            }
        } catch (SQLException e) {
            // Nên dùng System.err để in lỗi
            System.err.println("Lỗi CategoryDAO.getAll: " + e.getMessage());
        }
        return list;
    }
  
    /**
 * Lấy một category bằng ID
 * @param categoryId ID của category
 * @return Đối tượng Category hoặc null
 */
public Category getCategoryById(int categoryId) {
    String sql = "SELECT * FROM category WHERE category_id = ?";
    try {
        PreparedStatement st = connection.prepareStatement(sql);
        st.setInt(1, categoryId);
        ResultSet rs = st.executeQuery();
        if (rs.next()) {
            return new Category(
                    rs.getInt("category_id"),
                    rs.getString("type"),
                    rs.getString("gender")
            );
        }
    } catch (SQLException e) {
        System.err.println("Lỗi CategoryDAO.getCategoryById: " + e.getMessage());
    }
    return null;
}

/**
 * Thêm một category mới
 * @param category Đối tượng Category (không cần ID)
 * @return true nếu thành công
 */
public boolean insert(Category category) {
    String sql = "INSERT INTO category ([type], gender) VALUES (?, ?)";
    try {
        PreparedStatement st = connection.prepareStatement(sql);
        st.setString(1, category.getType());
        st.setString(2, category.getGender());
        int rowsAffected = st.executeUpdate();
        return rowsAffected > 0;
    } catch (SQLException e) {
        // Lỗi 2627 hoặc 2601 (UNIQUE constraint)
        System.err.println("Lỗi CategoryDAO.insert: " + e.getMessage());
    }
    return false;
}

/**
 * Cập nhật một category
 * @param category Đối tượng Category (phải có ID)
 * @return true nếu thành công
 */
public boolean update(Category category) {
    String sql = "UPDATE category SET [type] = ?, gender = ? WHERE category_id = ?";
    try {
        PreparedStatement st = connection.prepareStatement(sql);
        st.setString(1, category.getType());
        st.setString(2, category.getGender());
        st.setInt(3, category.getCategory_id());
        int rowsAffected = st.executeUpdate();
        return rowsAffected > 0;
    } catch (SQLException e) {
        System.err.println("Lỗi CategoryDAO.update: " + e.getMessage());
    }
    return false;
}

/**
 * Xóa một category bằng ID
 * @param categoryId ID của category
 * @return true nếu thành công
 */
public boolean delete(int categoryId) {
    String sql = "DELETE FROM category WHERE category_id = ?";
    try {
        PreparedStatement st = connection.prepareStatement(sql);
        st.setInt(1, categoryId);
        int rowsAffected = st.executeUpdate();
        return rowsAffected > 0;
    } catch (SQLException e) {
        // Lỗi 547 là lỗi Foreign Key (SQL Server)
        System.err.println("Lỗi CategoryDAO.delete: " + e.getMessage());
    }
    return false;
}

/**
 * Kiểm tra xem Category ID có đang được sử dụng bởi bảng 'product' không.
 * @param categoryId ID của category
 * @return true nếu đang được sử dụng, false nếu không.
 */
public boolean isCategoryInUse(int categoryId) {
    String sql = "SELECT TOP 1 1 FROM product WHERE category_id = ?";
    try {
        PreparedStatement st = connection.prepareStatement(sql);
        st.setInt(1, categoryId);
        ResultSet rs = st.executeQuery();
        return rs.next(); // Trả về true nếu tìm thấy (rs.next() == true)
    } catch (SQLException e) {
        System.err.println("Lỗi CategoryDAO.isCategoryInUse: " + e.getMessage());
    }
    return false; // Mặc định là false nếu có lỗi
}
    public String getIdGender(String gender) {
        String result = "(";
        String sql = "select category_id from category where gender = '" + gender + "'";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                int i = rs.getInt("category_id");
                result += i + ",";
            }
        } catch (Exception e) {
            System.out.println(e);
        }

        result = result.substring(0, result.length() - 1);
        result += ")";
        return result;
    }

    public int getIdType(String type, String gender) {
        // [FIX] Đảm bảo câu query chính xác với tên cột trong DB
        String sql = "SELECT category_id FROM category WHERE [type] = ? AND gender = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, type);
            st.setString(2, gender);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt("category_id");
            }
        } catch (Exception e) {
            System.err.println("CategoryDAO.getIdType Error: " + e.getMessage());
        }
        return 0; // Trả về 0 nếu không tìm thấy
    }

    public static void main(String[] args) {
//        CategoryDAO dao = new CategoryDAO();
//        System.out.println(dao.getIdGender("female"));
        
        // Test hàm mới
        CategoryDAO dao = new CategoryDAO();
        List<Category> list = dao.getAll();
        for (Category c : list) {
            System.out.println(c.getCategory_id() + ": " + c.getType() + " (" + c.getGender() + ")");
        }
    }
}