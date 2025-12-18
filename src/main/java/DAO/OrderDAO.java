package DAO;

import entity.OrderDetail;
import entity.Orders;

import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class OrderDAO extends DBConnect.DBConnect {

    // ========================= SELECT (LẤY DỮ LIỆU) =========================
    public List<Orders> getAllOrders() {
        List<Orders> list = new ArrayList<>();
        // [UPDATE] Added voucher_id column
        String sql = "SELECT order_id, address, [date], status, phone_number, customer_id, staff_id, total, voucher_id FROM orders";
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
                        rs.getInt("total"),
                        rs.getString("voucher_id") // [NEW] Map voucher_id
                ));
            }
        } catch (SQLException e) {
            System.err.println("OrderDAO.getAllOrders: " + e.getMessage());
        }
        return list;
    }

    public List<Orders> getAllOrdersSort() {
        List<Orders> list = new ArrayList<>();
        // [UPDATE] Added voucher_id column & Sort by OrderID DESC
        String sql
                = "SELECT order_id, address, [date], status, phone_number, customer_id, staff_id, total, voucher_id "
                + "FROM orders "
                + "ORDER BY order_id DESC";

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
                        rs.getInt("total"),
                        rs.getString("voucher_id") // [NEW] Map voucher_id
                ));
            }
        } catch (SQLException e) {
            System.err.println("OrderDAO.getAllOrdersSort: " + e.getMessage());
        }
        return list;
    }

    public List<Orders> searchOrdersById(String orderId) {
        List<Orders> list = new ArrayList<>();
        // SQL SELECT * already includes voucher_id if the column exists in DB
        String sql = "SELECT * FROM orders WHERE CAST(order_id AS VARCHAR) LIKE ? "
                + "ORDER BY CASE "
                + "  WHEN status = 'Pending' THEN 1 "
                + "  WHEN status = 'Delivering' THEN 2 "
                + "  WHEN status = 'Shipped' THEN 3 "
                + "  WHEN status = 'Delivered' THEN 4 "
                + "  WHEN status = 'Cancelled' THEN 5 "
                + "  ELSE 6 END, [date] DESC, order_id DESC";
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
                            rs.getInt("total"),
                            rs.getString("voucher_id") // [NEW] Map voucher_id
                    ));
                }
            }
        } catch (SQLException e) {
            System.err.println("OrderDAO.searchOrdersById: " + e.getMessage());
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
        // [UPDATE] Added voucher_id
        String sql = "SELECT order_id, address, [date], status, phone_number, customer_id, staff_id, total, voucher_id "
                + "FROM orders WHERE customer_id = ? ORDER BY [date] DESC, order_id DESC";
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
                            rs.getInt("total"),
                            rs.getString("voucher_id") // [NEW] Map voucher_id
                    ));
                }
            }
        } catch (SQLException e) {
            System.err.println("OrderDAO.orderUser: " + e.getMessage());
        }
        return list;
    }

    // ========================= INSERT (TẠO ĐƠN HÀNG) =========================
    // [UPDATE] Insert with VoucherID logic
    public int insertOrder(String address, Date date, String status, String phoneNumber,
            int customer_id, Integer staffId, int total, String voucherId) {

        // Added voucher_id to query
        String sql = "INSERT INTO orders(address, [date], status, phone_number, customer_id, staff_id, total, voucher_id) "
                + "VALUES(?,?,?,?,?,?,?,?)";

        try (PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            st.setString(1, address);
            st.setDate(2, new java.sql.Date(date.getTime()));
            st.setString(3, status);
            st.setString(4, (phoneNumber == null ? "" : phoneNumber));
            st.setInt(5, customer_id);

            if (staffId == null || staffId <= 0) {
                st.setNull(6, java.sql.Types.INTEGER);
            } else {
                st.setInt(6, staffId);
            }

            st.setInt(7, total);

            // Handle Voucher ID (allow NULL or empty)
            if (voucherId == null || voucherId.trim().isEmpty() || voucherId.equals("0")) {
                st.setNull(8, java.sql.Types.VARCHAR);
            } else {
                st.setString(8, voucherId);
            }

            st.executeUpdate();

            try (ResultSet keys = st.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
            return getLatestOrderIdByCustomer(customer_id);

        } catch (SQLException e) {
            System.err.println("OrderDAO.insertOrder Error: " + e.getMessage());
            return 0;
        }
    }

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

    // [UPDATE] Transaction Method: Accepts voucherId
    public int insertOrderWithDetails(String address, Date date, String status, String phoneNumber,
            int customer_id, int staff_id, int total, String voucherId, // Added param
            List<OrderDetail> details) {

        boolean oldAutoCommit = true;
        try {
            oldAutoCommit = connection.getAutoCommit();
            connection.setAutoCommit(false); // Begin transaction

            // Call updated insertOrder
            int orderId = insertOrder(address, date, status, phoneNumber, customer_id, staff_id, total, voucherId);

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

            connection.commit(); // Commit
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

    // ========================= UTILITIES =========================
    public int getLatestOrderIdByCustomer(int customer_id) {
        String sqlServer = "SELECT TOP 1 order_id FROM orders WHERE customer_id = ? ORDER BY order_id DESC";

        try (PreparedStatement st = connection.prepareStatement(sqlServer)) {
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

    public List<Orders> getOrdersByCustomerID(int customerID) {
        List<Orders> list = new ArrayList<>();
        // [UPDATE] Added voucher_id
        final String sql = "SELECT order_id, address, [date], status, phone_number, customer_id, staff_id, total, voucher_id "
                + "FROM orders WHERE customer_id = ? ORDER BY [date] DESC";
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
                            rs.getInt("total"),
                            rs.getString("voucher_id") // [NEW] Map voucher_id
                    ));
                }
            }
        } catch (SQLException e) {
            System.out.println("OrderDAO.getOrdersByCustomerID: " + e.getMessage());
        }
        return list;
    }

    @Deprecated
    public int getOrderId() {
        String sql = "SELECT TOP 1 order_id FROM orders ORDER BY order_id DESC";
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

    // ========================= ADMIN / SEARCH / FILTER =========================
    public List<Orders> getAllOrdersNewestFirst() {
        List<Orders> list = new ArrayList<>();
        // [UPDATE] Added voucher_id
        String sql = "SELECT order_id, address, [date], status, phone_number, customer_id, staff_id, total, voucher_id "
                + "FROM orders "
                + "ORDER BY [date] DESC, order_id DESC";
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
                        rs.getInt("total"),
                        rs.getString("voucher_id") // [NEW] Map voucher_id
                ));
            }
        } catch (SQLException e) {
            System.err.println("OrderDAO.getAllOrdersNewestFirst: " + e.getMessage());
        }
        return list;
    }

    public List<Orders> getOrdersByStaffId(int staffId) {
        List<Orders> list = new ArrayList<>();
        // [UPDATE] Added voucher_id implicitly (SELECT *) or explicitly
        // Explicit is better for clarity, adding voucher_id here:
        String sql = "SELECT order_id, address, [date], status, phone_number, customer_id, staff_id, total, voucher_id "
                + "FROM orders WHERE staff_id = ? ORDER BY [date] DESC, order_id DESC";
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
                            rs.getInt("total"),
                            rs.getString("voucher_id") // [NEW] Map voucher_id
                    ));
                }
            }
        } catch (SQLException e) {
            System.err.println("OrderDAO.getOrdersByStaffId: " + e.getMessage());
        }
        return list;
    }

    public int getTotalOrdersCount() {
        String sql = "SELECT COUNT(*) FROM orders";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("OrderDAO.getTotalOrdersCount: " + e.getMessage());
        }
        return 0;
    }

    public List<Orders> getPaginatedOrders(int pageIndex, int pageSize) {
        List<Orders> list = new ArrayList<>();
        // [UPDATE] Added voucher_id
        String sql = "SELECT order_id, address, [date], status, phone_number, customer_id, staff_id, total, voucher_id "
                + "FROM orders "
                + "ORDER BY order_id DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            int offset = (pageIndex - 1) * pageSize;
            st.setInt(1, offset);
            st.setInt(2, pageSize);

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
                            rs.getInt("total"),
                            rs.getString("voucher_id") // [NEW] Map voucher_id
                    ));
                }
            }
        } catch (SQLException e) {
            System.err.println("OrderDAO.getPaginatedOrders: " + e.getMessage());
        }
        return list;
    }

    // ========================= CANCEL FLOW (CUSTOMER) =========================
    public boolean cancelOrderByCustomer(int orderId, int customerId) {
        String sql = "UPDATE orders "
                + "SET status = 'Cancelled' "
                + "WHERE order_id = ? "
                + "  AND customer_id = ? "
                + "  AND status = 'Pending'";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.setInt(2, customerId);
            int updated = ps.executeUpdate();
            return updated > 0;
        } catch (SQLException e) {
            System.err.println("OrderDAO.cancelOrderByCustomer: " + e.getMessage());
            return false;
        }
    }
}
