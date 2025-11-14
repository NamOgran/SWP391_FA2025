package DAO;

import entity.Cart;
import entity.Product;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CartDAO extends DBConnect.DBConnect {

    // Lấy toàn bộ item theo customer
    public List<Cart> getAll(int customer_id) {
        List<Cart> list = new ArrayList<>();
        String sql = "SELECT * FROM cart WHERE customer_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, customer_id);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Cart c = new Cart(
                            rs.getInt("cart_id"),
                            rs.getInt("customer_id"),
                            rs.getInt("product_id"),
                            rs.getInt("quantity"),
                            rs.getFloat("price"), // LUÔN là ĐƠN GIÁ
                            rs.getString("size_name")
                    );
                    list.add(c);
                }
            }
        } catch (SQLException e) {
            System.err.println("CartDAO.getAll: " + e.getMessage());
        }
        return list;
    }

    // Thêm item — price là ĐƠN GIÁ
    public void insertCart(int quantity, float price, int customer_id, int product_id, String size_name) {
        String sql = "INSERT INTO cart(quantity, price, customer_id, product_id, size_name) VALUES(?,?,?,?,?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, quantity);
            st.setFloat(2, price); // lưu ĐƠN GIÁ
            st.setInt(3, customer_id);
            st.setInt(4, product_id);
            st.setString(5, size_name);
            st.executeUpdate();
        } catch (SQLException e) {
            System.err.println("CartDAO.insertCart: " + e.getMessage());
        }
    }

    // Cập nhật — price là ĐƠN GIÁ
    public void updateCart(int customer_id, int product_id, int quantity, float price, String size_name) {
        String sql = "UPDATE cart SET quantity = ?, price = ? WHERE customer_id = ? AND product_id = ? AND size_name = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, quantity);
            st.setFloat(2, price); // lưu ĐƠN GIÁ
            st.setInt(3, customer_id);
            st.setInt(4, product_id);
            st.setString(5, size_name);
            st.executeUpdate();
        } catch (SQLException e) {
            System.err.println("CartDAO.updateCart: " + e.getMessage());
        }
    }

    // Chỉ đổi số lượng (không động vào đơn giá)
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

    public Product getProductById(int product_id) {
        String sql = "SELECT * FROM product WHERE product_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, product_id);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    // === SỬA ĐỔI Ở ĐÂY ===
                    // Thêm rs.getBoolean("is_active") vào cuối
                    return new Product(
                            rs.getInt("product_id"),
                            rs.getInt("quantity"),
                            rs.getInt("price"),
                            rs.getInt("category_id"),
                            rs.getInt("promo_id"),
                            rs.getString("name"),
                            rs.getString("description"),
                            rs.getString("pic_url"),
                            rs.getBoolean("is_active") // <-- Bổ sung trường còn thiếu
                    );
                    // === KẾT THÚC SỬA ĐỔI ===
                }
            }
        } catch (SQLException e) {
            System.err.println("CartDAO.getProductById: " + e.getMessage());
        }
        return null;
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
                            rs.getFloat("price"),
                            rs.getString("size_name")
                    );
                }
            }
        } catch (SQLException e) {
            System.err.println("CartDAO.getCartById: " + e.getMessage());
        }
        return null;
    }

    // Subtotal = SUM(đơn giá * số lượng)
    public int getCartTotal(int customer_id) {
        String sql = "SELECT COALESCE(SUM(price * quantity), 0) AS total FROM cart WHERE customer_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, customer_id);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    double total = rs.getDouble("total");
                    return (int) Math.round(total);
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
    // CartDAO.java

    public Float getUnitPriceInCart(int customerId, int productId, String sizeName) {
        String sql = "SELECT price FROM cart WHERE customer_id=? AND product_id=? AND size_name=? LIMIT 1";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, customerId);
            st.setInt(2, productId);
            st.setString(3, sizeName);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getFloat("price");  // đây là ĐƠN GIÁ
                }
            }
        } catch (SQLException e) {
            System.err.println("CartDAO.getUnitPriceInCart: " + e.getMessage());
        }
        return 0f;
    }

    /**
     * Kiểm tra xem một sản phẩm có tồn tại trong giỏ hàng của bất kỳ ai không.
     *
     * @param productId ID sản phẩm
     * @return true nếu có, false nếu không
     */
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
                            rs.getFloat("price"),
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
