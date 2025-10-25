package DAO;

import entity.OrderDetail;
import entity.Orders;
import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * OrderDAO - Lớp truy xuất dữ liệu cho bảng "orders" và "order_detail".
 *
 * ✅ Chức năng chính:
 *  - Lấy danh sách đơn hàng và chi tiết đơn hàng
 *  - Thêm mới đơn hàng (insert order + details)
 *  - Cập nhật trạng thái đơn hàng
 *  - Lấy ID đơn mới nhất của khách hàng
 *
 * 🔥 Quy ước:
 *  - Bảng orders.order_id là AUTO_INCREMENT
 *  - Bảng order_detail lưu chi tiết gồm (order_id, product_id, size_name, quantity)
 *  - Cột total (int) lưu tổng tiền của đơn (đã bao gồm khuyến mãi)
 *  - Cột staff_id có thể null nếu đơn chưa được nhân viên xác nhận
 *
 * @author 
 */
public class OrderDAO extends DBConnect.DBConnect {

    // =========================================================
    // ===============        SELECT QUERY       ===============
    // =========================================================

    /**
     * Lấy tất cả đơn hàng trong hệ thống (không sắp xếp).
     */
    public List<Orders> getAllOrders() {
        List<Orders> list = new ArrayList<>();
        String sql = "SELECT order_id, address, date, status, phone_number, customer_id, staff_id, total FROM orders";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(new Orders(
                        rs.getInt("order_id"),
                        rs.getString("address"),
                        rs.getDate("date"),
                        rs.getString("status"),
                        rs.getString("phone_number"),
                        rs.getInt("customer_id"),
                        rs.getInt("staff_id"),
                        rs.getInt("total")
                ));
            }
        } catch (SQLException e) {
            System.err.println("OrderDAO.getAllOrders: " + e.getMessage());
        }
        return list;
    }

    /**
     * Lấy tất cả đơn hàng có sắp xếp theo trạng thái ưu tiên:
     * Pending → Delivering → Delivered → Cancelled → (khác)
     * Sau đó sắp xếp tiếp theo ngày và order_id giảm dần.
     */
    public List<Orders> getAllOrdersSort() {
        List<Orders> list = new ArrayList<>();
        String sql =
            "SELECT order_id, address, date, status, phone_number, customer_id, staff_id, total " +
            "FROM orders " +
            "ORDER BY CASE " +
            "  WHEN status = 'Pending' THEN 1 " +
            "  WHEN status = 'Delivering' THEN 2 " +
            "  WHEN status = 'Delivered' THEN 3 " +
            "  WHEN status = 'Cancelled' THEN 4 " +
            "  ELSE 5 END, date DESC, order_id DESC";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(new Orders(
                        rs.getInt("order_id"),
                        rs.getString("address"),
                        rs.getDate("date"),
                        rs.getString("status"),
                        rs.getString("phone_number"),
                        rs.getInt("customer_id"),
                        rs.getInt("staff_id"),
                        rs.getInt("total")
                ));
            }
        } catch (SQLException e) {
            System.err.println("OrderDAO.getAllOrdersSort: " + e.getMessage());
        }
        return list;
    }

    /**
     * Lấy toàn bộ chi tiết của tất cả đơn hàng.
     */
    public List<OrderDetail> getAllOrdersDetail() {
        List<OrderDetail> list = new ArrayList<>();
        String sql = "SELECT order_id, product_id, size_name, quantity FROM order_detail";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(new OrderDetail(
                        rs.getInt("quantity"),
                        rs.getString("size_name"),
                        rs.getInt("product_id"),
                        rs.getInt("order_id")
                ));
            }
        } catch (SQLException e) {
            System.err.println("OrderDAO.getAllOrdersDetail: " + e.getMessage());
        }
        return list;
    }

    /**
     * Lấy danh sách chi tiết đơn hàng theo ID đơn hàng.
     *
     * @param order_id Mã đơn hàng
     * @return List<OrderDetail> danh sách chi tiết
     */
    public List<OrderDetail> getAllOrdersDetailByID(int order_id) {
        List<OrderDetail> list = new ArrayList<>();
        String sql = "SELECT order_id, product_id, size_name, quantity FROM order_detail WHERE order_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, order_id);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(new OrderDetail(
                            rs.getInt("quantity"),
                            rs.getString("size_name"),
                            rs.getInt("product_id"),
                            rs.getInt("order_id")
                    ));
                }
            }
        } catch (SQLException e) {
            System.err.println("OrderDAO.getAllOrdersDetailByID: " + e.getMessage());
        }
        return list;
    }

    /**
     * Lấy danh sách đơn hàng của 1 khách hàng cụ thể, sắp xếp mới nhất trước.
     *
     * @param customer_id ID khách hàng
     */
    public List<Orders> orderUser(int customer_id) {
        List<Orders> list = new ArrayList<>();
        String sql = "SELECT order_id, address, date, status, phone_number, customer_id, staff_id, total " +
                     "FROM orders WHERE customer_id = ? ORDER BY date DESC, order_id DESC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, customer_id);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(new Orders(
                            rs.getInt("order_id"),
                            rs.getString("address"),
                            rs.getDate("date"),
                            rs.getString("status"),
                            rs.getString("phone_number"),
                            rs.getInt("customer_id"),
                            rs.getInt("staff_id"),
                            rs.getInt("total")
                    ));
                }
            }
        } catch (SQLException e) {
            System.err.println("OrderDAO.orderUser: " + e.getMessage());
        }
        return list;
    }

    // =========================================================
    // ===============         INSERT          ===============
    // =========================================================

    /**
     * Thêm mới một đơn hàng vào bảng orders.
     * 
     * @param address      địa chỉ giao hàng
     * @param date         ngày đặt
     * @param status       trạng thái ban đầu (Pending,...)
     * @param phoneNumber  số điện thoại nhận hàng
     * @param customer_id  ID khách hàng
     * @param staffId      ID nhân viên (có thể null nếu chưa xử lý)
     * @param total        tổng tiền đơn (VND)
     * @return order_id vừa được tạo (0 nếu lỗi)
     */
    public int insertOrder(String address, Date date, String status, String phoneNumber,
                           int customer_id, Integer staffId, int total) {
        String sql = "INSERT INTO orders(address, date, status, phone_number, customer_id, staff_id, total) VALUES(?,?,?,?,?,?,?)";
        try (PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            st.setString(1, address);
            st.setDate(2, new java.sql.Date(date.getTime()));
            st.setString(3, status);
            st.setString(4, (phoneNumber == null ? "" : phoneNumber));
            st.setInt(5, customer_id);
            if (staffId == null || staffId <= 0) {
                st.setNull(6, java.sql.Types.INTEGER);  // staff_id null
            } else {
                st.setInt(6, staffId);
            }
            st.setInt(7, total);
            st.executeUpdate();

            // Lấy order_id vừa sinh (nếu DB hỗ trợ)
            try (ResultSet keys = st.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }

            // fallback: lấy đơn mới nhất của customer
            return getLatestOrderIdByCustomer(customer_id);

        } catch (SQLException e) {
            System.err.println("OrderDAO.insertOrder: " + e.getMessage());
            return 0;
        }
    }

    /**
     * Thêm chi tiết đơn hàng (order_detail).
     * 
     * @param quantity   số lượng
     * @param size_name  size sản phẩm
     * @param productID  ID sản phẩm
     * @param orderID    ID đơn hàng
     */
    public void insertOrderDetail(int quantity, String size_name, int productID, int orderID) {
        String sql = "INSERT INTO order_detail(order_id, product_id, size_name, quantity) VALUES(?,?,?,?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, orderID);
            st.setInt(2, productID);
            st.setString(3, size_name);
            st.setInt(4, quantity);
            st.executeUpdate();
        } catch (SQLException e) {
            System.err.println("OrderDAO.insertOrderDetail: " + e.getMessage());
        }
    }

    /**
     * Giao dịch (transaction) tạo đơn hàng + thêm chi tiết đơn hàng.
     * Nếu có lỗi, rollback toàn bộ.
     *
     * @return order_id tạo thành công, hoặc 0 nếu rollback.
     */
    public int insertOrderWithDetails(String address, Date date, String status, String phoneNumber,
                                      int customer_id, int staff_id, int total,
                                      List<OrderDetail> details) {
        boolean oldAutoCommit = true;
        try {
            oldAutoCommit = connection.getAutoCommit();
            connection.setAutoCommit(false); // bắt đầu transaction

            int orderId = insertOrder(address, date, status, phoneNumber, customer_id, staff_id, total);
            if (orderId <= 0) {
                connection.rollback();
                connection.setAutoCommit(oldAutoCommit);
                return 0;
            }

            if (details != null) {
                for (OrderDetail d : details) {
                    insertOrderDetail(d.getQuantity(), d.getSize_name(), d.getProductID(), orderId);
                }
            }

            connection.commit(); // xác nhận giao dịch
            connection.setAutoCommit(oldAutoCommit);
            return orderId;

        } catch (SQLException ex) {
            try { connection.rollback(); } catch (SQLException ignore) {}
            System.err.println("OrderDAO.insertOrderWithDetails: " + ex.getMessage());
            try { connection.setAutoCommit(oldAutoCommit); } catch (SQLException ignore) {}
            return 0;
        }
    }

    // =========================================================
    // ===============          UTILS          ===============
    // =========================================================

    /**
     * Lấy ID đơn mới nhất của 1 khách hàng (theo order_id DESC).
     */
    public int getLatestOrderIdByCustomer(int customer_id) {
        String sql = "SELECT order_id FROM orders WHERE customer_id = ? ORDER BY order_id DESC LIMIT 1";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, customer_id);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return rs.getInt("order_id");
            }
        } catch (SQLException e) {
            System.err.println("OrderDAO.getLatestOrderIdByCustomer: " + e.getMessage());
        }
        return 0;
    }

    /**
     * (Deprecated) Lấy order_id lớn nhất toàn bảng. Chỉ giữ lại để tương thích cũ.
     */
    @Deprecated
    public int getOrderId() {
        String sql = "SELECT order_id FROM orders ORDER BY order_id DESC LIMIT 1";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) return rs.getInt("order_id");
        } catch (SQLException e) {
            System.err.println("OrderDAO.getOrderId (deprecated): " + e.getMessage());
        }
        return 0;
    }

    // =========================================================
    // ===============          UPDATE          ===============
    // =========================================================

    /**
     * Cập nhật trạng thái đơn hàng (Pending → Delivering → Delivered → Cancelled...).
     */
    public void updateStatus(String status, int order_id) {
        String sql = "UPDATE orders SET status = ? WHERE order_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, order_id);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("OrderDAO.updateStatus: " + e.getMessage());
        }
    }
}
