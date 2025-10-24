/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import entity.product;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author thinh
 */
public class DAOcategory extends DBconnect.DBconnect {

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
        String sql = "select category_id\n"
                + "from category\n"
                + "where [type] =? and gender = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, type);
            st.setString(2, gender);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                int i = rs.getInt("category_id");
                return i;
            }
        } catch (Exception e) {
        }
        return 0;
    }

    public static void main(String[] args) {
//        DAOcategory dao = new DAOcategory();
//        System.out.println(dao.getIdGender("female"));
    }

}
