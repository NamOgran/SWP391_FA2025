/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import entity.customer;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author thinh
 */
public class DAOcustomer extends DBconnect.DBconnect {

    public customer getCustomerByUsernameOrEmail(String input) {
        // Viết câu truy vấn SQL để lấy thông tin customer dựa trên username hoặc email
        // Ví dụ:
        String query = "SELECT * FROM Customer WHERE username = ? OR email = ?";
        // Thực hiện truy vấn, ánh xạ kết quả vào một đối tượng Customer và trả về
        // ...
        // Nếu không tìm thấy, trả về null
        return null;
    }

    public List<customer> getAll() {
        List<customer> listAccount = new ArrayList<>();
        String sql = "select * from customer";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                customer a = new customer(rs.getInt("customer_id"), rs.getString("username"),
                        rs.getString("email"), rs.getString("password"), rs.getString("address"), rs.getString("phoneNumber"), rs.getString("fullName"), rs.getString("google_id"));
                listAccount.add(a);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return listAccount;
    }

    public boolean delete(String customer_id) {
        String sql = "delete from customer where customer_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, customer_id);

            st.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println(e);
        }
        return false;
    }

    public boolean checkLogin(String input, String password) {
        String sql = "SELECT * FROM customer WHERE (username = ? OR email = ?) AND password = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, input);
            st.setString(2, input);
            st.setString(3, password);
            ResultSet rs = st.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean signUp(customer c) {
        String sql = "INSERT INTO customer(username, email, password, address, phoneNumber, fullName, google_id) "
                + "VALUES (?,?,?,?,?,?,?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, c.getUsername());
            st.setString(2, c.getEmail());
            st.setString(3, c.getPassword());
            st.setString(4, c.getAddress());
            st.setString(5, c.getPhoneNumber());
            st.setString(6, c.getFullName());
            st.setString(7, c.getGoogle_id() == null ? "" : c.getGoogle_id());
            st.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean checkEmail(String email) {
        String sql = "select * from customer where email = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, email);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                return true;
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return false;
    }

    public boolean updatePasswordByEmailOrUsername(String password, String input) {
        String sql = "update customer set password = ? where email = ? or username = ?";
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

    public boolean updatePasswordByUsername(String password, String username) {
        String sql = "update customer set password = ? where username = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, password);
            st.setString(2, username);
            st.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println(e);
        }
        return false;
    }

    public customer getCustomerByEmailOrUsername(String input) {
        String sql = "SELECT * FROM customer WHERE username = ? OR email = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, input);
            st.setString(2, input);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new customer(
                        rs.getInt("customer_id"),
                        rs.getString("username"),
                        rs.getString("email"),
                        rs.getString("password"),
                        rs.getString("address"),
                        rs.getString("phoneNumber"),
                        rs.getString("fullName"),
                        rs.getString("google_id")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean existsByUsernameOrEmail(String username, String email) {
        String sql = "SELECT * FROM customer WHERE username = ? OR email = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, username);
            st.setString(2, email);
            ResultSet rs = st.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateUserProfile(String email, String address, String phoneNumber, String fullName) {
        String sql = "update customer\n"
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
