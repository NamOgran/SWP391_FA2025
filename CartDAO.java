package DAO;

import entity.Cart;
import entity.Product;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * CartDAO - Lớp truy xuất dữ liệu (Data Access Object) cho bảng "cart"
 * 
 * ✅ Chức năng chính:
 *  - Lấy / thêm / cập nhật / xóa item trong giỏ hàng
 *  - Tính tổng tiền, đếm số lượng item
 *  - Hỗ trợ kiểm tra đơn giá, sản phẩm
 * 
 * 🔥 Quy ước trong hệ thống:
 *  - Cột `price` trong bảng `cart` luôn lưu **ĐƠN GIÁ**, không phải thành tiền.
 *  - Thành tiền chỉ được tính tạm thời trong controller hoặc JSP: `price * quantity`
 * 
 * @author duyent
 */
public class CartDAO extends DBConnect.DBConnect {

    /** 
     * Lấy toàn bộ sản phẩm trong giỏ hàng theo ID khách hàng
     * @param customer_id ID khách hàng
     * @return Danh sách Cart
     */
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
                            rs.getFloat("price"), // Đơn giá (LUÔN)
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

    /** 
     * Thêm một sản phẩm mới vào giỏ hàng
     * @param quantity số lượng
     * @param price đơn giá (đã áp dụng khuyến mãi nếu có)
     * @param customer_id ID khách hàng
     * @param product_id ID sản phẩm
     * @param size_name size của sản phẩm
     */
    public void insertCart(int quantity, float price, int customer_id, int product_id, String size_name) {
        String sql = "INSERT INTO cart(quantity, price, customer_id, product_id, size_name) VALUES(?,?,?,?,?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, quantity);
            st.setFloat(2, price);
            st.setInt(3, customer_id);
            st.setInt(4, product_id);
            st.setString(5, size_name);
            st.executeUpdate();
        } catch (SQLException e) {
            System.err.println("CartDAO.insertCart: " + e.getMessage());
        }
    }

    /**
     * Cập nhật lại một item trong giỏ hàng (cả số lượng và đơn giá)
     * 
     * ⚠ Khi có thay đổi khuyến mãi hoặc người dùng thêm trùng sản phẩm
     */
    public void updateCart(int customer_id, int product_id, int quantity, float price, String size_name) {
        String sql = "UPDATE cart SET quantity = ?, price = ? WHERE customer_id = ? AND product_id = ? AND size_name = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, quantity);
            st.setFloat(2, price);
            st.setInt(3, customer_id);
            st.setInt(4, product_id);
            st.setString(5, size_name);
            st.executeUpdate();
        } catch (SQLException e) {
            System.err.println("CartDAO.updateCart: " + e.getMessage());
        }
    }

    /**
     * Chỉ cập nhật số lượng sản phẩm trong giỏ hàng (không thay đổi đơn giá)
     * 
     * Dùng cho các thao tác tăng/giảm bằng AJAX trong cart.jsp
     */
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

    /**
     * Xóa sản phẩm khỏi giỏ (không xét size)
     * → chỉ dùng khi sản phẩm không có size
     */
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

    /**
     * Xóa sản phẩm khỏi giỏ dựa trên (product_id + size_name)
     * 
     * @return true nếu xóa thành công
     */
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

    /**
     * Xóa toàn bộ giỏ hàng của khách hàng (khi đặt hàng thành công)
     */
    public void deleteAllCart(int customer_id) {
        String sql = "DELETE FROM cart WHERE customer_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, customer_id);
            st.executeUpdate();
        } catch (SQLException e) {
            System.err.println("CartDAO.deleteAllCart: " + e.getMessage());
        }
    }

    /**
     * Lấy thông tin sản phẩm từ bảng product (phục vụ khi cần tính lại giá)
     */
    public Product getProductById(int product_id) {
        String sql = "SELECT * FROM product WHERE product_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, product_id);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return new Product(
                            rs.getInt("product_id"),
                            rs.getInt("quantity"),
                            rs.getInt("price"),
                            rs.getInt("category_id"),
                            rs.getInt("promo_id"),
                            rs.getString("name"),
                            rs.getString("description"),
                            rs.getString("pic_url")
                    );
                }
            }
        } catch (SQLException e) {
            System.err.println("CartDAO.getProductById: " + e.getMessage());
        }
        return null;
    }

    /**
     * Lấy 1 item bất kỳ trong giỏ hàng (dùng khi test hoặc cần preview)
     */
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

    /**
     * Tính tổng tiền giỏ hàng = SUM(đơn giá * số lượng)
     * 
     * @return tổng tiền (đã làm tròn về int)
     */
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

    /**
     * Đếm tổng số lượng sản phẩm trong giỏ (tính tổng quantity)
     */
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

    /**
     * Lấy đơn giá của sản phẩm trong giỏ theo (customer_id, product_id, size_name)
     * 
     * Dùng khi cần kiểm tra hoặc hiển thị lại đơn giá cũ trong cart.jsp
     * 
     * @return đơn giá (float)
     */
    public Float getUnitPriceInCart(int customerId, int productId, String sizeName) {
        String sql = "SELECT price FROM cart WHERE customer_id=? AND product_id=? AND size_name=? LIMIT 1";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, customerId);
            st.setInt(2, productId);
            st.setString(3, sizeName);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getFloat("price");  // ĐƠN GIÁ
                }
            }
        } catch (SQLException e) {
            System.err.println("CartDAO.getUnitPriceInCart: " + e.getMessage());
        }
        return 0f;
    }
}
