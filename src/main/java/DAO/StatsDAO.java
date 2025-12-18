package DAO;

import DBConnect.DBConnect;
import entity.Stats;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class StatsDAO extends DBConnect {

    // ... (Các Inner Class ChartData, TopProduct, OrderPopupData, OrderDetailData giữ nguyên) ...
    public static class ChartData {

        public String label;
        public double revenue;
        public int orders;
        public int month;

        public ChartData(String label, double revenue, int orders) {
            this.label = label;
            this.revenue = revenue;
            this.orders = orders;
        }
    }

    public static class TopProduct {

        private String name;
        private String picUrl;
        private int soldCount;
        private int price;

        public TopProduct(String name, String picUrl, int soldCount, int price) {
            this.name = name;
            this.picUrl = picUrl;
            this.soldCount = soldCount;
            this.price = price;
        }

        public String getName() {
            return name;
        }

        public String getPicUrl() {
            return picUrl;
        }

        public int getSoldCount() {
            return soldCount;
        }

        public int getPrice() {
            return price;
        }
    }

    public static class OrderPopupData {

        private int orderId;
        private String customerName;
        private String address;
        private Date orderDate;
        private String status;
        private int totalAmount;
        private List<OrderDetailData> details;

        public OrderPopupData() {
            this.details = new ArrayList<>();
        }

        public int getOrderId() {
            return orderId;
        }

        public void setOrderId(int orderId) {
            this.orderId = orderId;
        }

        public String getCustomerName() {
            return customerName;
        }

        public void setCustomerName(String customerName) {
            this.customerName = customerName;
        }

        public String getAddress() {
            return address;
        }

        public void setAddress(String address) {
            this.address = address;
        }

        public Date getOrderDate() {
            return orderDate;
        }

        public void setOrderDate(Date orderDate) {
            this.orderDate = orderDate;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }

        public int getTotalAmount() {
            return totalAmount;
        }

        public void setTotalAmount(int totalAmount) {
            this.totalAmount = totalAmount;
        }

        public List<OrderDetailData> getDetails() {
            return details;
        }

        public void setDetails(List<OrderDetailData> details) {
            this.details = details;
        }
    }

    public static class OrderDetailData {

        private String productName;
        private String size;
        private int quantity;
        private int price;

        public OrderDetailData(String productName, String size, int quantity, int price) {
            this.productName = productName;
            this.size = size;
            this.quantity = quantity;
            this.price = price;
        }

        public String getProductName() {
            return productName;
        }

        public String getSize() {
            return size;
        }

        public int getQuantity() {
            return quantity;
        }

        public int getPrice() {
            return price;
        }
    }

    // 1. TỔNG SẢN PHẨM HIỆN CÓ (Size_Detail)
    public int getAllProductSizeDetail() {
        String sql = "SELECT COALESCE(SUM(quantity), 0) FROM size_detail";
        try (Connection conn = new DBConnect().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 2. TỔNG KHÁCH HÀNG
    public int getAllCustomersCount() {
        String sql = "SELECT COUNT(*) FROM customer";
        try (Connection conn = new DBConnect().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 3. THỐNG KÊ THEO KHOẢNG THỜI GIAN
    public Stats getStatsByDateRange(Date from, Date to) {
        Stats stats = new Stats();
        // [FIX] Sửa điều kiện status chỉ lấy 'Delivered'
        String sql = "SELECT "
                + "  (SELECT COALESCE(SUM(total), 0) FROM orders WHERE status = 'Delivered' AND [date] BETWEEN ? AND ?) as revenue, "
                + "  (SELECT COUNT(*) FROM orders WHERE [date] BETWEEN ? AND ?) as orders, "
                + "  (SELECT COUNT(DISTINCT customer_id) FROM orders WHERE [date] BETWEEN ? AND ?) as customers, "
                + "  (SELECT COALESCE(SUM(od.quantity), 0) FROM order_detail od JOIN orders o ON od.order_id = o.order_id WHERE o.status = 'Delivered' AND o.[date] BETWEEN ? AND ?) as products";
        try (Connection conn = new DBConnect().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 1; i <= 8; i += 2) {
                ps.setDate(i, from);
                ps.setDate(i + 1, to);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                stats.setTotalRevenue(rs.getDouble("revenue"));
                stats.setTotalOrders(rs.getInt("orders"));
                stats.setTotalCustomers(rs.getInt("customers"));
                stats.setTotalProducts(rs.getInt("products"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }

    // 4. LẤY DANH SÁCH ORDER CHI TIẾT (CHO POPUP)
    public List<OrderPopupData> getOrdersForPopup(Date from, Date to) {
        List<OrderPopupData> list = new ArrayList<>();
        String sqlOrder = "SELECT o.order_id, c.fullName, o.address, o.[date], o.status, o.total "
                + "FROM orders o "
                + "JOIN customer c ON o.customer_id = c.customer_id "
                + "WHERE o.[date] BETWEEN ? AND ? "
                + "ORDER BY o.[date] DESC";
        try (Connection conn = new DBConnect().getConnection(); PreparedStatement ps = conn.prepareStatement(sqlOrder)) {
            ps.setDate(1, from);
            ps.setDate(2, to);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                OrderPopupData data = new OrderPopupData();
                data.setOrderId(rs.getInt("order_id"));
                data.setCustomerName(rs.getString("fullName"));
                data.setAddress(rs.getString("address"));
                data.setOrderDate(rs.getDate("date"));
                data.setStatus(rs.getString("status"));
                data.setTotalAmount(rs.getInt("total"));
                data.setDetails(getDetailsForOrder(data.getOrderId(), conn));
                list.add(data);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private List<OrderDetailData> getDetailsForOrder(int orderId, Connection conn) {
        List<OrderDetailData> details = new ArrayList<>();
        String sql = "SELECT p.name, od.size_name, od.quantity, p.price "
                + "FROM order_detail od "
                + "JOIN product p ON od.product_id = p.product_id "
                + "WHERE od.order_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                details.add(new OrderDetailData(
                        rs.getString("name"),
                        rs.getString("size_name"),
                        rs.getInt("quantity"),
                        rs.getInt("price")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return details;
    }

    // 5. DỮ LIỆU BIỂU ĐỒ CỘT (THEO NĂM)
    public List<ChartData> getMonthlyStatsByYear(int year) {
        List<ChartData> list = new ArrayList<>();
        for (int i = 1; i <= 12; i++) {
            ChartData data = new ChartData(i + "/" + year, 0, 0);
            data.month = i;
            list.add(data);
        }
        // [FIX] Sửa điều kiện status chỉ lấy 'Delivered'
        String sql = "SELECT MONTH([date]) as m, SUM(total) as revenue, COUNT(*) as orders "
                + "FROM orders "
                + "WHERE status = 'Delivered' AND YEAR([date]) = ? "
                + "GROUP BY MONTH([date])";
        try (Connection conn = new DBConnect().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, year);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int monthVal = rs.getInt("m");
                if (monthVal >= 1 && monthVal <= 12) {
                    ChartData data = list.get(monthVal - 1);
                    data.revenue = rs.getDouble("revenue");
                    data.orders = rs.getInt("orders");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 6. ORDER STATS (PIE CHART)
    public Map<String, Integer> getOrderStatusCounts(Date from, Date to) {
        Map<String, Integer> map = new HashMap<>();
        String sql = "SELECT status, COUNT(*) as cnt FROM orders WHERE [date] BETWEEN ? AND ? GROUP BY status";
        try (Connection conn = new DBConnect().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, from);
            ps.setDate(2, to);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String status = rs.getString("status");
                if (status != null) {
                    map.put(status, rs.getInt("cnt"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    // 7. BEST SELLERS
    public List<TopProduct> getBestSellers(int limit) {
        List<TopProduct> list = new ArrayList<>();
        // [FIX] Sửa điều kiện status chỉ lấy 'Delivered'
        String sql = "SELECT " + (limit > 0 ? "TOP (?)" : "") + " p.name, p.pic_url, p.price, SUM(od.quantity) as total_sold "
                + "FROM order_detail od "
                + "JOIN product p ON od.product_id = p.product_id "
                + "JOIN orders o ON od.order_id = o.order_id "
                + "WHERE o.status = 'Delivered' "
                + "GROUP BY p.product_id, p.name, p.pic_url, p.price "
                + "ORDER BY total_sold DESC";
        try (Connection conn = new DBConnect().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            if (limit > 0) {
                ps.setInt(1, limit);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new TopProduct(
                        rs.getString("name"),
                        rs.getString("pic_url"),
                        rs.getInt("total_sold"),
                        rs.getInt("price")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
