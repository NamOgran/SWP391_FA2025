/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import entity.promo;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Administrator
 */
public class DAOpromo extends DBconnect.DBconnect {

    public List<promo> getAll() {
        List<promo> list = new ArrayList<>();
        String sql = "select * from promo";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                promo p = new promo(rs.getInt("promo_id"), rs.getInt("promo_percent"), rs.getDate("start_date"), rs.getDate("end_date"));
                list.add(p);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public boolean addIfNotExist(int percent) {
        String sql = "IF NOT EXISTS (SELECT 1 FROM promo WHERE promo_percent = ?)\n"
                + "BEGIN\n"
                + "    INSERT INTO promo (promo_percent, start_date, end_date)\n"
                + "    VALUES (?,'2024-02-26', '2024-04-01')\n"
                + "END";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, percent);
            st.setInt(2, percent);
            st.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println(e);
        }
        return false;
    }
    
    public int getIdPromo(int percent){
        String sql = "select promo_id from promo "
                + "where promo_percent = ?";
        int id = 0;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, percent);
            ResultSet rs = st.executeQuery();
            while(rs.next()){
                id = rs.getInt("promo_id");
            }
           
        } catch (Exception e) {
            System.out.println(e);
        }
        return id;
    }
}
