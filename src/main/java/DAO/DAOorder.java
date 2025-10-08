/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import entity.orderDetail;
import entity.orders;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 *
 * @author Administrator
 */
public class DAOorder extends DBconnect.DBconnect {

    public List<orders> getAllOrders() {
        List<orders> list = new ArrayList<>();
        String sql = "select * from orders";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                orders o = new orders(rs.getInt("order_id"), rs.getString("address"), rs.getDate("date"), rs.getString("status"),
                        rs.getString("phone_number"), rs.getString("usernameCustomer"), rs.getString("usernameStaff"), rs.getInt("total"));
                list.add(o);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public List<orders> getAllOrdersSort() {
        List<orders> list = new ArrayList<>();
        String sql = "SELECT *\n"
                + "FROM orders\n"
                + "ORDER BY CASE \n"
                + "    WHEN status = 'Pending' THEN 1\n"
                + "    WHEN status = 'Delivering' THEN 2\n"
                + "    WHEN status = 'Delivered' THEN 3\n"
                + "    WHEN status = 'Cancelled' THEN 4\n"
                + "    ELSE 5\n"
                + "END;";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                orders o = new orders(rs.getInt("order_id"), rs.getString("address"), rs.getDate("date"), rs.getString("status"),
                        rs.getString("phone_number"), rs.getString("usernameCustomer"), rs.getString("usernameStaff"), rs.getInt("total"));
                list.add(o);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public List<orderDetail> getAllOrdersDetail() {
        List<orderDetail> list = new ArrayList<>();
        String sql = "select * from order_detail";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                orderDetail od = new orderDetail(rs.getInt("quantity"), rs.getString("size_name"), rs.getInt("product_id"), rs.getInt("order_id")
                );
                list.add(od);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public List<orderDetail> getAllOrdersDetailByID(int order_id) {
        List<orderDetail> list = new ArrayList<>();
        String sql = "select * from order_detail where order_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, order_id);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                orderDetail od = new orderDetail(rs.getInt("quantity"), rs.getString("size_name"), rs.getInt("product_id"), rs.getInt("order_id")
                );
                list.add(od);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public List<orders> orderUser(String usernameCustomer) {
        List<orders> list = new ArrayList<>();
        String sql = "select * from orders where usernameCustomer = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, usernameCustomer);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                orders o = new orders(rs.getInt("order_id"), rs.getString("address"), rs.getDate("date"), rs.getString("status"),
                        rs.getString("phone_number"), rs.getString("usernameCustomer"), rs.getString("usernameStaff"), rs.getInt("total"));
                list.add(o);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public void insertOrder(String address, Date date, String status, String phoneNumber, String usernameCustomer, String usernameStaff, float total) {
        String sql = "insert into\n"
                + "orders\n"
                + "values(?,?,?,?,?,?,?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, address);
            st.setDate(2, new java.sql.Date(date.getTime()));
            st.setString(3, status);
            st.setString(4, phoneNumber);
            st.setString(5, usernameCustomer);
            st.setString(6, usernameStaff);
            st.setFloat(7, total);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void insertOrderDetail(int quantity, String size_name, int productID, int orderID) {
        String sql = "insert into\n"
                + "order_detail\n"
                + "values(?,?,?,?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, orderID);
            st.setInt(2, productID);
            st.setString(3, size_name);
            st.setInt(4, quantity);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public int getOrderId() {
        int order_id = 0;
        String sql = "SELECT MAX(order_id) as order_id\n"
                + "FROM orders;";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                order_id = rs.getInt("order_id");
                return order_id;
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return order_id;
    }

    public void updateStatus(String status, int order_id) {
        String sql = "update orders\n"
                + "set status = ?\n"
                + "where order_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, order_id);
            ps.executeUpdate();
        } catch (Exception e) {
        }
    }

}
