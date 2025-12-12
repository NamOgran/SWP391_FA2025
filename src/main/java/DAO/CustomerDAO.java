/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;
import entity.Customer;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;


public class CustomerDAO extends DBConnect.DBConnect {

    public Customer getCustomerByUsernameOrEmail(String input) {
        // Viết câu truy vấn SQL để lấy thông tin Customer dựa trên username hoặc email
        // Ví dụ:
        String query = "SELECT * FROM Customer WHERE username = ? OR email = ?";
        // Thực hiện truy vấn, ánh xạ kết quả vào một đối tượng Customer và trả về
        // ...
        // Nếu không tìm thấy, trả về null
        return null;
    }

    public List<Customer> getAll() {
        List<Customer> listAccount = new ArrayList<>();
        String sql = "select * from customer";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Customer a = new Customer(
                        rs.getInt("customer_id"),
                        rs.getString("username"),
                        rs.getString("email"),
                        rs.getString("password"),
                        rs.getString("address"),
                        rs.getString("phoneNumber"),
                        rs.getString("fullName"),
                        rs.getString("google_id")
                );
                listAccount.add(a);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return listAccount;
    }

    // === START: UPDATED delete() METHOD ===
    /**
     * Xóa một customer bằng username.
     * Trả về false nếu có lỗi (ví dụ: vi phạm ràng buộc khóa ngoại).
     * @param username Tên người dùng để xóa
     * @return true nếu xóa thành công, false nếu thất bại (VD: còn orders, cart)
     */
    public boolean delete(String username) {
        String sql = "DELETE FROM customer WHERE username = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, username);
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0; // Trả về true nếu có hàng bị xóa
        } catch (SQLException e) {
            // Lỗi 547 là lỗi Foreign Key (SQL Server)
            if (e.getErrorCode() == 547) {
                System.err.println("CustomerDAO.delete FK ERROR: Không thể xóa " + username + " vì có dữ liệu liên quan (VD: orders, cart). " + e.getMessage());
            } else {
                System.err.println("CustomerDAO.delete SQL ERROR: " + e.getMessage());
            }
        }
        return false; // Trả về false nếu có lỗi
    }
    // === END: UPDATED delete() METHOD ===


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

    public boolean signUp(Customer c) {
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

    public Customer getCustomerByEmailOrUsername(String input) {
        String sql = "SELECT * FROM customer WHERE username = ? OR email = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, input);
            st.setString(2, input);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new Customer(
                        rs.getInt("customer_id"),
                        rs.getString("username"),
                        rs.getString("email"),
                        rs.getString("password"),
                        rs.getString("address"),
                        rs.getString("phoneNumber"),
                        rs.getString("fullName"),
                        // [FIX] Xử lý null cho google_id an toàn hơn
                        rs.getString("google_id") == null ? "" : rs.getString("google_id")
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
    public boolean updateUserProfileByUsername(String username, String email, String address, String phoneNumber, String fullName) {
        String sql = "UPDATE customer "
                + "SET email = ?, address = ?, phoneNumber = ?, fullName = ? "
                + "WHERE username = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, email);
            st.setString(2, address);
            st.setString(3, phoneNumber);
            st.setString(4, fullName);
            st.setString(5, username);
            
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            System.out.println("Lỗi CustomerDAO.updateUserProfileByUsername: " + e.getMessage());
            return false;
        }
    }
    
    // === START: NEW isUsernameTaken() METHOD ===
    /**
     * KIỂM TRA USERNAME TỒN TẠI TRÊN CẢ 2 BẢNG (CUSTOMER VÀ STAFF)
     * Dùng cho việc tạo tài khoản mới.
     * @param username Tên người dùng cần kiểm tra
     * @return true nếu tên đã tồn tại, false nếu chưa
     */
    public boolean isUsernameTaken(String username) {
        // Câu lệnh UNION sẽ kiểm tra cả 2 bảng
        String sql = "SELECT 1 FROM customer WHERE username = ? "
                   + "UNION "
                   + "SELECT 1 FROM staff WHERE username = ?";
        
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, username);
            st.setString(2, username);
            
            try (ResultSet rs = st.executeQuery()) {
                // Nếu rs.next() là true, nghĩa là tìm thấy ít nhất 1 kết quả
                return rs.next(); 
            }
        } catch (SQLException e) {
            System.err.println("Lỗi CustomerDAO.isUsernameTaken: " + e.getMessage());
            e.printStackTrace();
        }
        
        // Mặc định trả về true để an toàn (thà chặn nhầm còn hơn cho tạo trùng)
        return true; 
    }
    public Customer getCustomerByID(int id) {
    String sql = "SELECT * FROM customer WHERE customer_id = ?";
    try (PreparedStatement st = connection.prepareStatement(sql)) {
        st.setInt(1, id);
        try (ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                // ÁNH XẠ THỦ CÔNG (vì class này không có mapRow)
                return new Customer(
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
        }
    } catch (SQLException e) {
        System.out.println("CustomerDAO.getCustomerByID ERROR: " + e.getMessage());
    }
    return null;
}
public List<Customer> getAllCustomers() {
    List<Customer> list = new ArrayList<>();
    final String sql = "SELECT * FROM customer ORDER BY customer_id DESC";
    try (PreparedStatement st = connection.prepareStatement(sql);
         ResultSet rs = st.executeQuery()) {
        while (rs.next()) {
            Customer c = new Customer(
                    rs.getInt("customer_id"),
                    rs.getString("username"),
                    rs.getString("email"),
                    rs.getString("password"),
                    rs.getString("address"),
                    rs.getString("phoneNumber"),
                    rs.getString("fullName"),
                    rs.getString("google_id")
            );
            list.add(c);
        }
    } catch (SQLException e) {
        System.out.println("CustomerDAO.getAllCustomers ERROR: " + e.getMessage());
    }
    return list;
}

    public List<Customer> search(String keyword) {
    List<Customer> list = new ArrayList<>();
    final String sql = "SELECT * FROM customer "
            + "WHERE fullName LIKE ? OR email LIKE ? OR username LIKE ?";
    String like = "%" + keyword + "%";
    try (PreparedStatement st = connection.prepareStatement(sql)) {
        st.setString(1, like);
        st.setString(2, like);
        st.setString(3, like);

        try (ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                Customer c = new Customer(
                        rs.getInt("customer_id"),
                        rs.getString("username"),
                        rs.getString("email"),
                        rs.getString("password"),
                        rs.getString("address"),
                        rs.getString("phoneNumber"),
                        rs.getString("fullName"),
                        rs.getString("google_id")
                );
                list.add(c);
            }
        }
    } catch (SQLException e) {
        System.out.println("CustomerDAO.search ERROR: " + e.getMessage());
    }
    return list;
}

/**
     * Cập nhật thông tin Customer theo ID (được gọi bởi AdminController)
     */
    public boolean updateCustomerProfile(int id, String email, String address, String phoneNumber, String fullName) {
        String sql = "UPDATE customer SET email = ?, address = ?, phoneNumber = ?, fullName = ? WHERE customer_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, email);
            st.setString(2, address);
            st.setString(3, phoneNumber);
            st.setString(4, fullName);
            st.setInt(5, id);
            
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error CustomerDAO.updateCustomerProfile: " + e.getMessage());
            return false;
        }
    }

}