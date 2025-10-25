/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import DBconnect.DBconnect;
import entity.category;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 * DAOcategory - Data Access Object for the "category" table.
 *
 * Table structure: category_id INT (PK) type VARCHAR(50) gender VARCHAR(20)
 *
 * This class handles all interactions between the application and the
 * "category" table.
 *
 * @author Phuoc
 */
public class DAOcategory extends DBconnect {

    /**
     * Get all categories from the database
     *
     * @return List of all categories
     */
    public List<category> getAll() {
        List<category> list = new ArrayList<>();
        String sql = "SELECT * FROM category";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(new category(
                        rs.getInt("category_id"),
                        rs.getString("type"),
                        rs.getString("gender")
                ));
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    /**
     * Get a single category by ID
     *
     * @param id category ID
     * @return category object, or null if not found
     */
    public category getCategoryById(int id) {
        String sql = "SELECT * FROM category WHERE category_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new category(
                        rs.getInt("category_id"),
                        rs.getString("type"),
                        rs.getString("gender")
                );
            }
        } catch (Exception e) {
            System.out.println("❌ Error in getCategoryById(): " + e.getMessage());
        }
        return null;
    }

    /**
     * Get all category IDs for a specific gender
     *
     * @param gender male/female/unisex
     * @return category IDs in SQL IN format (e.g. "(1,2,3)")
     */
    public String getIdGender(String gender) {
        String result = "(";
        String sql = "SELECT category_id FROM category WHERE gender = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, gender);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                int i = rs.getInt("category_id");
                result += i + ",";
            }
        } catch (Exception e) {
            System.out.println("❌ Error in getIdGender(): " + e.getMessage());
        }

        // Remove last comma
        if (result.endsWith(",")) {
            result = result.substring(0, result.length() - 1);
        }
        result += ")";
        return result;
    }

    /**
     * Get category ID by type and gender
     *
     * @param type category type (e.g. "Áo sơ mi")
     * @param gender gender (e.g. "Nam")
     * @return category_id or 0 if not found
     */
    public int getIdType(String type, String gender) {
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
            System.out.println("❌ Error in getIdType(): " + e.getMessage());
        }
        return 0;
    }

    /**
     * Insert new category
     *
     * @param c category object
     * @return true if success, false if failed
     */
    public boolean insert(category c) {
        String sql = "INSERT INTO category (type, gender) VALUES (?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, c.getType());
            st.setString(2, c.getGender());
            st.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println("❌ Error in insert(): " + e.getMessage());
        }
        return false;
    }

    /**
     * Update category by ID
     *
     * @param c category object
     * @return true if success, false if failed
     */
    public boolean update(category c) {
        String sql = "UPDATE category SET type = ?, gender = ? WHERE category_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, c.getType());
            st.setString(2, c.getGender());
            st.setInt(3, c.getCategory_id());
            st.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println("❌ Error in update(): " + e.getMessage());
        }
        return false;
    }

    /**
     * Delete category by ID
     *
     * @param id category_id
     * @return true if success, false if failed
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM category WHERE category_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            st.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println("❌ Error in delete(): " + e.getMessage());
        }
        return false;
    }

    // ✅ Quick test
    public static void main(String[] args) {
        DAOcategory dao = new DAOcategory();
        List<category> list = dao.getAll();
        for (category c : list) {
            System.out.println(c);
        }
    }
}
