/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import entity.Customer;
import entity.Staff;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 *
 */
public class StaffDAO extends DBConnect.DBConnect {

    public List<Staff> getAll() {
        List<Staff> list = new ArrayList<>();
        String sql = "select * from staff";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Staff a = new Staff();
                a.setStaff_id(rs.getInt("staff_id"));
                a.setUsername(rs.getString("username"));
                a.setEmail(rs.getString("email"));
                a.setPassword(rs.getString("password"));
                a.setAddress(rs.getString("address"));
                a.setPhoneNumber(rs.getString("phoneNumber"));
                a.setFullName(rs.getString("fullName"));
                a.setRole(rs.getString("role"));

                list.add(a);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public boolean signUp(Staff c) {
        String sql = "insert into staff(username, email, password, address, phoneNumber, fullName, role) "
                + "values (?,?,?,?,?,?,?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, c.getUsername());
            st.setString(2, c.getEmail());
            st.setString(3, c.getPassword());
            st.setString(4, c.getAddress());
            st.setString(5, c.getPhoneNumber());
            st.setString(6, c.getFullName());
            st.setString(7, c.getRole());
            st.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println(e);
        }
        return false;
    }

    public boolean updatePasswordByEmailOrUsername(String password, String input) {
        String sql = "update staff set password = ? where email = ? or username = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, password);
            st.setString(2, input);
            st.setString(3, input);
            st.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println(e);
        }
        return false;
    }

    // === START: UPDATED delete() METHOD ===
    /**
     * Xóa một staff bằng username. Trả về false nếu có lỗi (ví dụ: vi phạm ràng
     * buộc khóa ngoại).
     *
     * @param username Tên người dùng để xóa
     * @return true nếu xóa thành công, false nếu thất bại (VD: còn orders,
     * imports)
     */
    public boolean delete(String username) {
        String sql = "delete from staff where username = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, username);
            st.executeUpdate();
            return true;
        } catch (SQLException e) {
            // Lỗi 547 là lỗi Foreign Key (SQL Server)
            if (e.getErrorCode() == 547) {
                System.err.println("StaffDAO.delete FK ERROR: Không thể xóa " + username + " vì có dữ liệu liên quan (VD: orders, imports). " + e.getMessage());
            } else {
                System.err.println("StaffDAO.delete SQL ERROR: " + e.getMessage());
            }
        }
        return false; // Trả về false nếu có lỗi (bao gồm cả lỗi FK)
    }
    // === END: UPDATED delete() METHOD ===

    public boolean updateStaffProfile(String username, String email, String address, String phoneNumber, String fullName) {
        String sql = "update staff\n"
                + "set address = ?, \n"
                + "phoneNumber = ?,\n"
                + "email = ?,\n"
                + "fullName = ?\n"
                + "where username = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, address);
            st.setString(2, phoneNumber);
            st.setString(3, email);

            st.setString(4, fullName);
            st.setString(5, username);
            st.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println(e);
        }
        return false;
    }

    public List<Staff> search(String name) {
        List<Staff> list = new ArrayList<>();
        String sql = "select * from customer\n"
                + "where fullName like ?\n"
                + "union all\n"
                + "select * from staff\n"
                + "where fullName like ? and username !='admin'";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, name);
            st.setString(2, name);

            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Staff p = new Staff(rs.getString("username"),
                        rs.getString("email"), rs.getString("password"), rs.getString("address"),
                        rs.getString("phoneNumber"), rs.getString("fullName"));
                list.add(p);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public Staff getStaffByEmailOrUsername(String input) {
        String sql = "select * from staff where username = ? or email = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            // SỬA LỖI: Phải gán tham số 'input'
            st.setString(1, input);
            st.setString(2, input);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                // SỬA LỖI: Sử dụng constructor rỗng và setter để gán đúng
                Staff c = new Staff();
                c.setStaff_id(rs.getInt("staff_id"));
                c.setUsername(rs.getString("username"));
                c.setEmail(rs.getString("email"));
                c.setPassword(rs.getString("password"));
                c.setAddress(rs.getString("address"));
                c.setPhoneNumber(rs.getString("phoneNumber"));
                c.setFullName(rs.getString("fullName"));
                c.setRole(rs.getString("role")); // Quan trọng
                return c;
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return null;
    }

    public boolean checkLogin(String input, String password) {
        String sql = "select * from staff where (username = ? or email = ?) and password = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, input);
            st.setString(2, input);

            st.setString(3, password);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                return true;
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return false;
    }

    public Staff getStaffByEmailOrUsernameAndPassword(String input, String password) {
        Staff s = null;
        String sql = "SELECT * FROM staff WHERE (username = ? OR email = ?) AND password = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, input);
            st.setString(2, input);
            st.setString(3, password);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                s = new Staff();
                s.setStaff_id(rs.getInt("staff_id"));
                s.setUsername(rs.getString("username"));
                s.setEmail(rs.getString("email"));
                s.setPassword(rs.getString("password"));
                s.setFullName(rs.getString("fullName"));
                s.setAddress(rs.getString("address"));
                s.setPhoneNumber(rs.getString("phoneNumber"));
                s.setRole(rs.getString("role"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return s;
    }

    public boolean updateStaffProfile(String email, String address, String phoneNumber, String fullName) {
        String sql = "update staff\n"
                + "set address = ?, \n"
                + "phoneNumber = ?,\n"
                + "fullName = ?\n"
                + "where email = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, address);
            st.setString(2, phoneNumber);
            st.setString(3, fullName);
            st.setString(4, email);
            st.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println(e);
        }
        return false;
    }

    /**
     * Cập nhật thông tin Staff theo ID (được gọi bởi AdminController)
     */
    public boolean updateStaffProfile(int id, String email, String address, String phoneNumber, String fullName) {
        String sql = "UPDATE staff SET email = ?, address = ?, phoneNumber = ?, fullName = ? WHERE staff_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, email);
            st.setString(2, address);
            st.setString(3, phoneNumber);
            st.setString(4, fullName);
            st.setInt(5, id);

            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            System.err.println("Error StaffDAO.updateStaffProfile: " + e.getMessage());
            return false;
        }
    }

    public boolean isEmailExistedExceptId(String email, int staffId) {
        String sql = "SELECT COUNT(*) FROM staff WHERE email = ? AND staff_id <> ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, email);
            ps.setInt(2, staffId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
