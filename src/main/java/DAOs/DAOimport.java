/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import entity.imports;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author thinh
 */
public class DAOimport extends DBconnect.DBconnect {

    public List<imports> getAllImport() {
        List<imports> list = new ArrayList<>();
        DAOimportDetail dao = new DAOimportDetail();

        String sql = "select * from import "
                + "order by status desc";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
//                System.out.println(dao.getPriceByImportID(rs.getString("import_id")));
//                int price = dao.getPriceByImportID(rs.getString("import_id"));
//                System.out.println(price);
                imports o = new imports(rs.getInt("import_id"), dao.getQuantityByImportID(rs.getString("import_id")), dao.getPriceByImportID(rs.getString("import_id")), rs.getString("username"), rs.getString("status"), rs.getDate("importDate"));
//                System.out.println(o.getTotal());
                list.add(o);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public boolean updateStatus(String id) {
        String sql = "update import\n"
                + "set status = 'delivered'\n"
                + "where import_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, id);
            st.executeUpdate();
            return true;
        } catch (Exception e) {
        }
        return false;
    }

    public static void main(String[] args) {
        DAOimport d = new DAOimport();
        System.out.println(d.getAllImport());
    }

}
