/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import DBConnect.DBConnect;
import entity.Stats;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author Nguyen Trong Nhan - CE190493
 */
public class StatsDAO {

    /**
     * Trả về đối tượng Stats chứa:
     * - tổng số lượng product = SUM(quantity) từ bảng product
     * - tổng số order = COUNT(*) từ bảng [Order] (đặt [] nếu tên là từ khóa)
     * - tổng doanh thu = SUM(total) từ bảng [Order] (hoặc tên cột của bạn)
     * - tổng số customer = COUNT(*) từ bảng customer
     */
    public Stats getStats() {
        Stats stats = new Stats();
        // Giá trị mặc định an toàn
        stats.setTotalProducts(0);
        stats.setTotalOrders(0);
        stats.setTotalRevenue(0.0);
        stats.setTotalCustomers(0);

        String sqlTotalProducts = "SELECT COALESCE(SUM(quantity), 0) AS totalProducts FROM product";
        // Nếu bảng order có tên là Order (từ khóa), dùng [] hoặc đổi tên bảng
        String sqlTotalOrders   = "SELECT COALESCE(COUNT(*), 0) AS totalOrders FROM [orders]";
        // Thay 'total' bằng tên cột thực tế trong bảng order nếu khác
        String sqlTotalRevenue  = "SELECT COALESCE(SUM(total), 0) AS totalRevenue FROM [orders]";
        String sqlTotalCustomers= "SELECT COALESCE(COUNT(*), 0) AS totalCustomers FROM customer";

        try (Connection conn = new DBConnect().getConnection()) {

            // totalProducts
            try (PreparedStatement ps = conn.prepareStatement(sqlTotalProducts);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats.setTotalProducts(rs.getInt("totalProducts"));
                }
            }

            // totalOrders
            try (PreparedStatement ps = conn.prepareStatement(sqlTotalOrders);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats.setTotalOrders(rs.getInt("totalOrders"));
                }
            }

            // totalRevenue
            try (PreparedStatement ps = conn.prepareStatement(sqlTotalRevenue);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Dùng getDouble để tránh lỗi với số lớn
                    stats.setTotalRevenue(rs.getDouble("totalRevenue"));
                }
            }

            // totalCustomers
            try (PreparedStatement ps = conn.prepareStatement(sqlTotalCustomers);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats.setTotalCustomers(rs.getInt("totalCustomers"));
                }
            }

        } catch (SQLException ex) {
            ex.printStackTrace(); // or use logger
        } catch (Exception e) {
            e.printStackTrace();
        }

        return stats;
    }
}

