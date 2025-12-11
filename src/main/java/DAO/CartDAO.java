package DAO;

import entity.Cart;
import entity.Product;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CartDAO extends DBConnect.DBConnect {

    public List<Cart> getAll(int customer_id) {
        List<Cart> list = new ArrayList<>();
        // [FIX] Giữ nguyên fix bảng size_detail từ trước
        String sql = "SELECT c.*, s.quantity AS size_detail_qty "
                + "FROM cart c "
                + "LEFT JOIN size_detail s ON c.product_id = s.product_id AND c.size_name = s.size_name "
                + "WHERE c.customer_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, customer_id);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Cart c = new Cart(
                            rs.getInt("cart_id"),
                            rs.getInt("customer_id"),
                            rs.getInt("product_id"),
                            rs.getInt("quantity"),
                            rs.getInt("price"), // [FIX] getInt
                            rs.getString("size_name"),
                            rs.getInt("size_detail_qty")
                    );
                    list.add(c);
                }
            }
        } catch (SQLException e) {
            System.err.println("CartDAO.getAll: " + e.getMessage());
        }
        return list;
    }

    // [FIX] price đổi thành int
    public void insertCart(int quantity, int price, int customer_id, int product_id, String size_name) {
        String sql = "INSERT INTO cart(quantity, price, customer_id, product_id, size_name) VALUES(?,?,?,?,?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, quantity);
            st.setInt(2, price); // [FIX] setInt
            st.setInt(3, customer_id);
            st.setInt(4, product_id);
            st.setString(5, size_name);
            st.executeUpdate();
        } catch (SQLException e) {
            System.err.println("CartDAO.insertCart: " + e.getMessage());
        }
    }

    // [FIX] price đổi thành int
    public void updateCart(int customer_id, int product_id, int quantity, int price, String size_name) {
        String sql = "UPDATE cart SET quantity = ?, price = ? WHERE customer_id = ? AND product_id = ? AND size_name = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, quantity);
            st.setInt(2, price); // [FIX] setInt
            st.setInt(3, customer_id);
            st.setInt(4, product_id);
            st.setString(5, size_name);
            st.executeUpdate();
        } catch (SQLException e) {
            System.err.println("CartDAO.updateCart: " + e.getMessage());
        }
    }

    public void updateQuantityOnly(int customer_id, int product_id, String size_name, int quantity) {
        String sql = "UPDATE cart SET quantity = ? WHERE customer_id = ? AND product_id = ? AND size_name = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, quantity);
            st.setInt(2, customer_id);
            st.setInt(3, product_id);
            st.setString(4, size_name);
            st.executeUpdate();
        } catch (SQLException e) {
            System.err.println("CartDAO.updateQuantityOnly: " + e.getMessage());
        }
    }

    public void deleteCart(int product_id, int customer_id) {
        String sql = "DELETE FROM cart WHERE product_id = ? AND customer_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, product_id);
            st.setInt(2, customer_id);
            st.executeUpdate();
        } catch (SQLException e) {
            System.err.println("CartDAO.deleteCart: " + e.getMessage());
        }
    }

    public boolean deleteCartBySize(int product_id, int customer_id, String size_name) {
        String sql = "DELETE FROM cart WHERE product_id = ? AND customer_id = ? AND size_name = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, product_id);
            st.setInt(2, customer_id);
            st.setString(3, size_name);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("CartDAO.deleteCartBySize: " + e.getMessage());
            return false;
        }
    }

    public void deleteAllCart(int customer_id) {
        String sql = "DELETE FROM cart WHERE customer_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, customer_id);
            st.executeUpdate();
        } catch (SQLException e) {
            System.err.println("CartDAO.deleteAllCart: " + e.getMessage());
        }
    }

    public Cart getCartById(int customer_id) {
        String sql = "SELECT * FROM cart WHERE customer_id = ? LIMIT 1";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, customer_id);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return new Cart(
                            rs.getInt("cart_id"),
                            rs.getInt("customer_id"),
                            rs.getInt("product_id"),
                            rs.getInt("quantity"),
                            rs.getInt("price"), // [FIX] getInt
                            rs.getString("size_name")
                    );
                }
            }
        } catch (SQLException e) {
            System.err.println("CartDAO.getCartById: " + e.getMessage());
        }
        return null;
    }

    public int getCartTotal(int customer_id) {
        // [FIX] Tính tổng trả về int luôn
        String sql = "SELECT COALESCE(SUM(price * quantity), 0) AS total FROM cart WHERE customer_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, customer_id);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        } catch (SQLException e) {
            System.err.println("CartDAO.getCartTotal: " + e.getMessage());
        }
        return 0;
    }

    public int getCartCount(int customer_id) {
        String sql = "SELECT COALESCE(SUM(quantity), 0) AS cnt FROM cart WHERE customer_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, customer_id);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("cnt");
                }
            }
        } catch (SQLException e) {
            System.err.println("CartDAO.getCartCount: " + e.getMessage());
        }
        return 0;
    }

    // [FIX] Trả về Integer thay vì Float
    public Integer getUnitPriceInCart(int customerId, int productId, String sizeName) {
        String sql = "SELECT price FROM cart WHERE customer_id=? AND product_id=? AND size_name=? LIMIT 1";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, customerId);
            st.setInt(2, productId);
            st.setString(3, sizeName);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("price");
                }
            }
        } catch (SQLException e) {
            System.err.println("CartDAO.getUnitPriceInCart: " + e.getMessage());
        }
        return 0;
    }

    public boolean hasDataForProduct(int productId) {
        String sql = "SELECT TOP 1 1 FROM cart WHERE product_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, productId);
            try (ResultSet rs = st.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.err.println("CartDAO.hasDataForProduct: " + e.getMessage());
            return true;
        }
    }

    public List<Cart> getCartItemsByProductId(int productId) {
        List<Cart> list = new ArrayList<>();
        String sql = "SELECT * FROM cart WHERE product_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, productId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(new Cart(
                            rs.getInt("cart_id"),
                            rs.getInt("customer_id"),
                            rs.getInt("product_id"),
                            rs.getInt("quantity"),
                            rs.getInt("price"), // [FIX] getInt
                            rs.getString("size_name")
                    ));
                }
            }
        } catch (SQLException e) {
            System.err.println("CartDAO.getCartItemsByProductId: " + e.getMessage());
        }
        return list;
    }
}