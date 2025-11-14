/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import entity.Imports;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author thinh
 */
public class ImportDAO extends DBConnect.DBConnect {

    public List<Imports> getAllImport() {
        List<Imports> list = new ArrayList<>();
        ImportDetailDAO dao = new ImportDetailDAO();

        String sql = "select * from import "
                + "order by status desc";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
//                System.out.println(dao.getPriceByImportID(rs.getString("import_id")));
//                int price = dao.getPriceByImportID(rs.getString("import_id"));
//                System.out.println(price);
                Imports o = new Imports(rs.getInt("import_id"), dao.getQuantityByImportID(rs.getString("import_id")), dao.getPriceByImportID(rs.getString("import_id")), rs.getInt("staff_id"), rs.getString("status"), rs.getDate("importDate"));
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
        ImportDAO d = new ImportDAO();
        System.out.println(d.getAllImport());
    }
/**
     * Lấy danh sách nhập hàng theo ID nhân viên.
     * @param staffId ID nhân viên
     * @return Danh sách Imports
     */
    public List<Imports> getImportsByStaffId(int staffId) {
        List<Imports> list = new ArrayList<>();
        ImportDetailDAO dao = new ImportDetailDAO(); // Để lấy total/quantity
        String sql = "SELECT * FROM import WHERE staff_id = ? ORDER BY importDate DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, staffId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Imports o = new Imports(
                        rs.getInt("import_id"), 
                        dao.getQuantityByImportID(rs.getString("import_id")), 
                        dao.getPriceByImportID(rs.getString("import_id")), 
                        rs.getInt("staff_id"), 
                        rs.getString("status"), 
                        rs.getDate("importDate")
                );
                list.add(o);
            }
        } catch (Exception e) {
            System.err.println("ImportDAO.getImportsByStaffId: " + e.getMessage());
        }
        return list;
    }
}
