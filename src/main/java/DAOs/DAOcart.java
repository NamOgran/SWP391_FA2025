/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import entity.cart;
import entity.product;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Administrator
 */
public class DAOcart extends DBconnect.DBconnect {

    public List<cart> getAll(String username) {
        List<cart> list = new ArrayList<>();
        String sql = "select *from cart where username = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, username);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                cart c = new cart(rs.getInt("cart_id"), rs.getString("username"), rs.getInt("product_id"), rs.getInt("quantity"),
                        rs.getInt("price"), rs.getString("size_name"));
                list.add(c);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public void insertCart(int quantity, float price, String username, int product_id,String size_name) {
        String sql = "insert into\n"
                + "cart\n"
                + "values(?,?,?,?,?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);           
            st.setInt(1, quantity);
            st.setFloat(2, price);
            st.setString(3, username);
            st.setInt(4, product_id);
            st.setString(5,size_name);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void updateCart(String username, int product_id, int quantity, float price, String size_name) {
        String sql = "update cart\n"
                + "set username = ?,\n"
                + "product_id = ?,\n"
                + "quantity = ?,\n"
                + "price = ?,\n"
                + "size_name = ?\n"
                + "where username = ? and product_id=? and size_name = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, username);
            st.setInt(2, product_id);
            st.setInt(3, quantity);
            st.setFloat(4, price);
            st.setString(5,size_name);
            st.setString(6, username);
            st.setInt(7, product_id);
            st.setString(8,size_name);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void deleteCart(int product_id, String username) {
        String sql = "delete from cart \n"
                + "where product_id = ? and username = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, product_id);
            st.setString(2, username);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }
    public void deleteCartBySize(int product_id, String username,String size_name) {
        String sql = "delete from cart \n"
                + "where product_id = ? and username = ? and size_name = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, product_id);
            st.setString(2, username);
            st.setString(3, size_name);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void deleteAllCart(String username) {
        String sql = "delete from cart \n"
                + "where username = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, username);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public product getProductById(int product_id) {

        String sql = "select * from product where product_id=?";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, product_id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                product p = new product(rs.getInt("product_id"), rs.getInt("quantity"), rs.getInt("price"), rs.getInt("category_id"), rs.getInt("promo_id"), rs.getString("name"),
                        rs.getString("description"), rs.getString("pic_url"));
                return p;
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }

    public cart getCartById(String username) {

        String sql = "select * from cart where username=?";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, username);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                cart c = new cart(rs.getInt("cart_id"), rs.getString("username"), rs.getInt("product_id"), rs.getInt("quantity"),
                        rs.getInt("price"),rs.getString("size_name"));
                return c;
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }

    public static void main(String[] args) {
        DAOcart cart = new DAOcart();
    }
}
