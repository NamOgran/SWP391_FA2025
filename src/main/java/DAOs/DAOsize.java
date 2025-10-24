/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import entity.size;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Administrator
 */
public class DAOsize extends DBconnect.DBconnect {

    public List<size> getAll() {
        List<size> list = new ArrayList<>();
        String sql = "select * from size_detail";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                size s = new size(rs.getString("size_name"), rs.getInt("product_id"), rs.getInt("quantity"));
                list.add(s);
            }
        } catch (Exception e) {
            System.out.println(e);
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
        } catch (Exception e) {
        }
    }

    public int getSizeQuantity(int id, String size_name) {
        String sql = "select quantity \n"
                + "from size_detail\n"
                + "where product_id =  ? and size_name = ?";
        int quantity = 0;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            st.setString(2, size_name);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                quantity = rs.getInt("quantity");
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return quantity;
    }
}
