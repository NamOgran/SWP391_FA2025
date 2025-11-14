package DAO;

import entity.OrderDetail;
import entity.Orders;

import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class OrderDAO extends DBConnect.DBConnect {

    // ========================= SELECT =========================
    public List<Orders> getAllOrders() {
        List<Orders> list = new ArrayList<>();
        String sql = "SELECT order_id, address, date, status, phone_number, customer_id, staff_id, total FROM orders";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
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

    public List<Orders> getAllOrdersSort() {
        List<Orders> list = new ArrayList<>();
        String sql
                = "SELECT order_id, address, date, status, phone_number, customer_id, staff_id, total "
                + "FROM orders "
                + "ORDER BY CASE "
                + "  WHEN status = 'Pending' THEN 1 "
                + "  WHEN status = 'Delivering' THEN 2 "
                + "  WHEN status = 'Delivered' THEN 3 "
                + "  WHEN status = 'Cancelled' THEN 4 "
                + "  ELSE 5 END, date DESC, order_id DESC";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
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

    public List<OrderDetail> getAllOrdersDetail() {
        List<OrderDetail> list = new ArrayList<>();
        String sql = "SELECT order_id, product_id, size_name, quantity FROM order_detail";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
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

    public List<Orders> orderUser(int customer_id) {
        List<Orders> list = new ArrayList<>();
        String sql = "SELECT order_id, address, date, status, phone_number, customer_id, staff_id, total "
                + "FROM orders WHERE customer_id = ? ORDER BY date DESC, order_id DESC";
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

    // ========================= INSERT (đặt hàng) =========================
    /**
     * Tạo đơn và TRẢ VỀ order_id sinh ra. total là INT (VND). YÊU CẦU:
     * orders.order_id phải AUTO_INCREMENT.
     */
    // signature đổi total -> int, staffId -> Integer để có thể setNull
    public int insertOrder(String address, Date date, String status, String phoneNumber,
            int customer_id, Integer staffId, int total) {
        String sql = "INSERT INTO orders(address, date, status, phone_number, customer_id, staff_id, total) "
                + "VALUES(?,?,?,?,?,?,?)";
        try (PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            st.setString(1, address);
            st.setDate(2, new java.sql.Date(date.getTime()));
            st.setString(3, status);
            st.setString(4, (phoneNumber == null ? "" : phoneNumber));
            st.setInt(5, customer_id);
            if (staffId == null || staffId <= 0) {
                st.setNull(6, java.sql.Types.INTEGER);     // <<< quan trọng
            } else {
                st.setInt(6, staffId);
            }
            st.setInt(7, total);
            st.executeUpdate();

            try (ResultSet keys = st.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);     // <<< trả về order_id
                }
            }
            // fallback an toàn theo customer
            return getLatestOrderIdByCustomer(customer_id);

        } catch (SQLException e) {
            System.err.println("OrderDAO.insertOrder: " + e.getMessage());
            return 0;
        }
    }

    /**
     * Thêm chi tiết đơn. Ghi rõ tên cột để không phụ thuộc thứ tự cột DB.
     * Schema: order_detail(order_id, product_id, size_name, quantity)
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
     * Giao dịch: tạo đơn + thêm toàn bộ chi tiết 
     */
    public int insertOrderWithDetails(String address, Date date, String status, String phoneNumber,
            int customer_id, int staff_id, int total,
            List<OrderDetail> details) {
        boolean oldAutoCommit = true;
        try {
            oldAutoCommit = connection.getAutoCommit();
            connection.setAutoCommit(false);

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

            connection.commit();
            connection.setAutoCommit(oldAutoCommit);
            return orderId;

        } catch (SQLException ex) {
            try {
                connection.rollback();
            } catch (SQLException ignore) {
            }
            System.err.println("OrderDAO.insertOrderWithDetails: " + ex.getMessage());
            try {
                connection.setAutoCommit(oldAutoCommit);
            } catch (SQLException ignore) {
            }
            return 0;
        }
    }

    // ========================= UTILS =========================
    /**
     * Lấy đơn mới nhất của customer (tránh MAX toàn bảng).
     */
    public int getLatestOrderIdByCustomer(int customer_id) {
        String sql = "SELECT order_id FROM orders WHERE customer_id = ? ORDER BY order_id DESC LIMIT 1";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, customer_id);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("order_id");
                }
            }
        } catch (SQLException e) {
            System.err.println("OrderDAO.getLatestOrderIdByCustomer: " + e.getMessage());
        }
        return 0;
    }
    /**
     * Lấy danh sách đơn hàng của 1 khách hàng cụ thể.
     * Dùng trong StaffCustomerController (viewCustomerDetail).
     */
    public List<Orders> getOrdersByCustomerID(int customerID) {
        List<Orders> list = new ArrayList<>();
        final String sql = "SELECT order_id, address, date, status, phone_number, customer_id, staff_id, total "
                + "FROM orders WHERE customer_id = ? ORDER BY date DESC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, customerID);
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
            System.out.println("OrderDAO.getOrdersByCustomerID: " + e.getMessage());
        }
        return list;
    }

    /**
     * Giữ lại cho tương thích cũ, KHÔNG khuyến nghị dùng.
     */
    @Deprecated
    public int getOrderId() {
        String sql = "SELECT order_id FROM orders ORDER BY order_id DESC LIMIT 1";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("order_id");
            }
        } catch (SQLException e) {
            System.err.println("OrderDAO.getOrderId (deprecated): " + e.getMessage());
        }
        return 0;
    }

    // ========================= UPDATE =========================
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

    /**
     * Kiểm tra xem một sản phẩm có tồn tại trong bất kỳ chi tiết đơn hàng nào
     * không.
     *
     * @param productId ID sản phẩm
     * @return true nếu có, false nếu không
     */
    public boolean hasDataForProduct(int productId) {
        String sql = "SELECT TOP 1 1 FROM order_detail WHERE product_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, productId);
            try (ResultSet rs = st.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.err.println("OrderDAO.hasDataForProduct: " + e.getMessage());
            return true;
        }
    }

    public List<OrderDetail> getOrderDetailsByProductId(int productId) {
        List<OrderDetail> list = new ArrayList<>();
        String sql = "SELECT * FROM order_detail WHERE product_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, productId);
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
            System.err.println("OrderDAO.getOrderDetailsByProductId: " + e.getMessage());
        }
        return list;
    }
    
    public List<Orders> getAllOrdersNewestFirst() {
    List<Orders> list = new ArrayList<>();
    String sql = "SELECT order_id, address, [date], status, phone_number, customer_id, staff_id, total " +
                 "FROM orders " +
                 "ORDER BY [date] DESC, order_id DESC";
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
        System.err.println("OrderDAO.getAllOrdersNewestFirst: " + e.getMessage());
    }
    return list;
}


    /**
     * Lấy danh sách đơn hàng theo ID nhân viên.
     *
     * @param staffId ID nhân viên
     * @return Danh sách Orders
     */
    public List<Orders> getOrdersByStaffId(int staffId) {
        List<Orders> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE staff_id = ? ORDER BY date DESC, order_id DESC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, staffId);
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
            System.err.println("OrderDAO.getOrdersByStaffId: " + e.getMessage());
        }
        return list;
    }
    public List<Orders> searchOrdersById(String orderId) {
    List<Orders> list = new ArrayList<>();
    // Dùng LIKE để tìm kiếm gần đúng, ví dụ: "100" sẽ ra "1002", "1003"
    // Dùng CAST vì order_id là kiểu INT trong CSDL
    String sql = "SELECT * FROM orders WHERE CAST(order_id AS VARCHAR) LIKE ? "
               + "ORDER BY CASE " // Giữ nguyên logic sort
               + "  WHEN status = 'Pending' THEN 1 "
               + "  WHEN status = 'Processing' THEN 2 " // Thêm Processing
               + "  WHEN status = 'Delivering' THEN 3 "
               + "  WHEN status = 'Shipped' THEN 4 " // Thêm Shipped
               + "  WHEN status = 'Completed' THEN 5 " 
               + "  WHEN status = 'Cancelled' THEN 6 "
               + "  ELSE 7 END, date DESC, order_id DESC";
               
    try (PreparedStatement st = connection.prepareStatement(sql)) {
        st.setString(1, "%" + orderId + "%");
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
        System.err.println("OrderDAO.searchOrdersById: " + e.getMessage());
    }
    return list;
}
    
}
