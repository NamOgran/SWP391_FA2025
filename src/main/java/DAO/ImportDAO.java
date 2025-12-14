/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import entity.Imports;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
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

        // === SỬA CÂU SQL: DÙNG JOIN ĐỂ LẤY USERNAME ===
        String sql = "SELECT i.import_id, i.staff_id, i.status, i.importDate, s.username " +
                     "FROM import i " +
                     "JOIN staff s ON i.staff_id = s.staff_id " + // Nối bảng staff
                     "ORDER BY i.status DESC";
                     
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                // === CẬP NHẬT CONSTRUCTOR MỚI ===
                // Thêm tham số rs.getString("username") vào cuối
                Imports o = new Imports(
                        rs.getInt("import_id"), 
                        dao.getQuantityByImportID(rs.getString("import_id")), 
                        dao.getPriceByImportID(rs.getString("import_id")), 
                        rs.getInt("staff_id"), 
                        rs.getString("status"), 
                        rs.getDate("importDate"),
                        rs.getString("username") // Lấy username từ kết quả JOIN
                );
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
     *
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


    public int insertImportAndGetId(Imports newImport) {
        // Câu lệnh SQL giữ nguyên
        String sql = "INSERT INTO import (importDate, staff_id, status) VALUES (?, ?, ?)";

        try {
            // 1. Thêm tham số RETURN_GENERATED_KEYS để lấy ID an toàn
            PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

            // 2. SỬA LỖI DATE: Phải dùng new java.sql.Date(.getTime())
            st.setDate(1, new java.sql.Date(newImport.getDate().getTime()));
            st.setInt(2, newImport.getStaff_id());
            st.setString(3, newImport.getStatus());

            int affectedRows = st.executeUpdate();

            if (affectedRows > 0) {
                // 3. Lấy ID vừa sinh ra từ ResultSet đặc biệt này
                try (ResultSet rs = st.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1); // Trả về ID mới tạo
                    }
                }
            }
        } catch (Exception e) {
            System.err.println("Lỗi ImportDAO: " + e.getMessage());
            e.printStackTrace();
        }
        return 0; // Trả về 0 nếu lỗi
    }
    /**
     * [PAGINATION] Lấy tổng số lượng bản ghi Import để tính tổng số trang
     */
    public int getTotalImports() {
        String sql = "SELECT COUNT(*) FROM import";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            System.err.println("Error getting total imports: " + e.getMessage());
        }
        return 0;
    }

    /**
     * [PAGINATION] Lấy danh sách Import theo phân trang
     * @param page Trang hiện tại (bắt đầu từ 1)
     * @param pageSize Số lượng item mỗi trang (10)
     */
    public List<Imports> getImportsByPage(int page, int pageSize) {
        List<Imports> list = new ArrayList<>();
        ImportDetailDAO dao = new ImportDetailDAO();
        
        // Tính toán vị trí bắt đầu (Offset)
        int offset = (page - 1) * pageSize;

        // Sử dụng OFFSET FETCH của SQL Server (yêu cầu SQL Server 2012 trở lên)
        // Bắt buộc phải có ORDER BY khi dùng OFFSET
        String sql = "SELECT i.import_id, i.staff_id, i.status, i.importDate, s.username " +
                     "FROM import i " +
                     "JOIN staff s ON i.staff_id = s.staff_id " +
                     "ORDER BY i.status DESC, i.import_id DESC " + // Thêm ID để sắp xếp ổn định
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, offset);
            st.setInt(2, pageSize);
            
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Imports o = new Imports(
                        rs.getInt("import_id"), 
                        dao.getQuantityByImportID(rs.getString("import_id")), 
                        dao.getPriceByImportID(rs.getString("import_id")), 
                        rs.getInt("staff_id"), 
                        rs.getString("status"), 
                        rs.getDate("importDate"),
                        rs.getString("username")
                );
                list.add(o);
            }
        } catch (Exception e) {
            System.out.println("Error pagination: " + e);
        }
        return list;
    }
}

