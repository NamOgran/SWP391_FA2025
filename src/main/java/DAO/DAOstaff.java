/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import entity.customer;
import entity.staff;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author thinh
 */
public class DAOstaff extends DBconnect.DBconnect {

    public List<staff> getAll() {
        List<staff> list = new ArrayList<>();
        String sql = "select * from staff";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                staff a = new staff(
                        rs.getString("username"),
                        rs.getString("email"),
                        rs.getString("password"),
                        rs.getString("address"),
                        rs.getString("phoneNumber"),
                        rs.getString("fullName"));
                list.add(a);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public boolean signUp(staff c) {
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

    public boolean delete(String username) {
        String sql = "delete from staff where username = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, username);
            st.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println(e);
        }
        return false;
    }

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

    public List<staff> search(String name) {
        List<staff> list = new ArrayList<>();
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
                staff p = new staff(rs.getString("username"),
                        rs.getString("email"), rs.getString("password"), rs.getString("address"),
                        rs.getString("phoneNumber"), rs.getString("fullName"));
                list.add(p);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public staff getStaffByEmailOrUsername(String input) {
        String sql = "select * from staff where username = ? or email = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            String usernameOrEmail = null;
            st.setString(1, usernameOrEmail);
            st.setString(2, usernameOrEmail);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                staff c = new staff(
                        rs.getString("username"),
                        rs.getString("email"),
                        rs.getString("password"),
                        rs.getString("address"),
                        rs.getString("phoneNumber"),
                        rs.getString("fullName"));
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

    public staff getStaffByEmailOrUsernameAndPassword(String input, String password) {
        staff s = null;
        String sql = "SELECT * FROM staff WHERE (username = ? OR email = ?) AND password = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, input);
            st.setString(2, input);
            st.setString(3, password);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                s = new staff();
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
}
