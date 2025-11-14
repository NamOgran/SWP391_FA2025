
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import entity.product;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author LENOVO
 */
public class DAOproduct extends DBconnect.DBconnect {
//int id, int quantity, int price, int categoryID, int promoID, String name, String description, String picURL

    public List<product> getAll() {
        List<product> list = new ArrayList<>();
        String sql = "select * from product";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                product p = new product(rs.getInt("product_id"), rs.getInt("quantity"), rs.getInt("price"), rs.getInt("category_id"), rs.getInt("promo_id"), rs.getString("name"),
                        rs.getString("description"), rs.getString("pic_url"));
                list.add(p);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public int getProductQuantity(int product_id) {
        int quantity = 0;
        String sql = "SELECT quantity FROM product WHERE product_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, product_id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                quantity = rs.getInt("quantity");
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return quantity;
    }

    public boolean updateQuantity(int id, int quantity) {
        String sql = " update product\n"
                + "set quantity = ?\n"
                + "where product_id = ?";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, quantity);
            st.setInt(2, id);
            st.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println(e);
        }
        return false;
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

    public void updateQuan(int quantity, int product_id) {
        String sql = "update product\n"
                + "set quantity = ?\n"
                + "where product_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, quantity);
            ps.setInt(2, product_id);
            ps.executeUpdate();
        } catch (Exception e) {
        }
    }

    public boolean update(product p) {
        String sql = "UPDATE [dbo].[product]\n"
                + "   SET [name] = ?\n"
                + "      ,[quantity] = ?\n"
                + "      ,[description] = ?\n"
                + "      ,[pic_url] =?\n"
                + "      ,[price] = ?\n"
                + "      ,[category_id] = ?\n"
                + "      ,[promo_id] = ?\n"
                + " WHERE [product_id] = ?\n"
                + ""
                + "";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, p.getName());
            st.setInt(2, p.getQuantity());
            st.setString(3, p.getDescription());
            st.setString(4, p.getPicURL());
            st.setInt(5, p.getPrice());
            st.setInt(6, p.getCategoryID());
            st.setInt(7, p.getPromoID());
            st.setInt(8, p.getId());
            st.executeUpdate();
            return true;
        } catch (Exception e) {
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "delete from product where product_id = ?\n";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            st.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println(e);
        }
        return false;
    }

    public boolean insert(product p) {
        String sql = "INSERT INTO [dbo].[product]\n"
                + "           ([name]\n"
                + "           ,[quantity]\n"
                + "           ,[description]\n"
                + "           ,[pic_url]\n"
                + "           ,[price]\n"
                + "           ,[category_id]\n"
                + "           ,[promo_id])\n"
                + "     VALUES\n"
                + "           (?,?,?,?,?,?,?)";

        try {

            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, p.getName());
            st.setInt(2, p.getQuantity());
            st.setString(3, p.getDescription());
            st.setString(4, p.getPicURL());
            st.setInt(5, p.getPrice());
            st.setInt(6, p.getCategoryID());
            st.setInt(7, p.getPromoID());
            st.executeUpdate();
            return true;
        } catch (Exception e) {
            System.out.println(e);
        }
        return false;

    }

    public List<product> search(String name) {
        List<product> list = new ArrayList<>();
        String sql = "select * from product \n"
                + "where name like ? ";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, name);

            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                product p = new product(rs.getInt("product_id"), rs.getInt("quantity"), rs.getInt("price"), rs.getInt("category_id"), rs.getInt("promo_id"), rs.getString("name"),
                        rs.getString("description"), rs.getString("pic_url"));
                list.add(p);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public List<product> get8RandomProduct() {
        List<product> list = new ArrayList<>();
        String sql = "select top 8* from product order by newid()";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                product p = new product(rs.getInt("product_id"), rs.getInt("quantity"), rs.getInt("price"), rs.getInt("category_id"), rs.getInt("promo_id"), rs.getString("name"),
                        rs.getString("description"), rs.getString("pic_url"));
                list.add(p);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public List<product> getFemaleProduct() {
        DAOcategory DAOcategory = new DAOcategory();
        String listId = DAOcategory.getIdGender("female");
        List<product> list = new ArrayList<>();
        String sql = "select * from product where category_id in " + listId;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                product p = new product(rs.getInt("product_id"), rs.getInt("quantity"), rs.getInt("price"), rs.getInt("category_id"), rs.getInt("promo_id"), rs.getString("name"),
                        rs.getString("description"), rs.getString("pic_url"));
                list.add(p);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public List<product> sortIncrease() {

        List<product> list = new ArrayList<>();
        String sql = "SELECT * FROM product\n"
                + "ORDER BY price";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                product p = new product(rs.getInt("product_id"), rs.getInt("quantity"), rs.getInt("price"), rs.getInt("category_id"), rs.getInt("promo_id"), rs.getString("name"),
                        rs.getString("description"), rs.getString("pic_url"));
                list.add(p);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public List<product> sortDecrease() {
        List<product> list = new ArrayList<>();
        String sql = "SELECT * FROM product\n"
                + "ORDER BY price DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                product p = new product(rs.getInt("product_id"), rs.getInt("quantity"), rs.getInt("price"), rs.getInt("category_id"), rs.getInt("promo_id"), rs.getString("name"),
                        rs.getString("description"), rs.getString("pic_url"));
                list.add(p);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public List<product> sortBestSeller() {
        List<product> list = new ArrayList<>();
        String sql = "SELECT p.*\n"
                + "FROM product p\n"
                + "JOIN (\n"
                + "    SELECT product_id, SUM(quantity) AS total_quantity\n"
                + "    FROM order_detail\n"
                + "    GROUP BY product_id\n"
                + ") AS product_sales ON p.product_id = product_sales.product_id\n"
                + "ORDER BY product_sales.total_quantity DESC;";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                product p = new product(rs.getInt("product_id"), rs.getInt("quantity"), rs.getInt("price"), rs.getInt("category_id"), rs.getInt("promo_id"), rs.getString("name"),
                        rs.getString("description"), rs.getString("pic_url"));
                list.add(p);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public List<product> sortNew() {
        List<product> list = new ArrayList<>();
        String sql = "select * from product ORDER BY product_id DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                product p = new product(rs.getInt("product_id"), rs.getInt("quantity"), rs.getInt("price"), rs.getInt("category_id"), rs.getInt("promo_id"), rs.getString("name"),
                        rs.getString("description"), rs.getString("pic_url"));
                list.add(p);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public int getNumberOfOrder() {
        int number = 0;
        String sql = "SELECT COUNT(*) AS total FROM orders";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                number = rs.getInt("total");

            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return number;
    }

    public int getNumberOfOrderByYear(int year) {
        int number = 0;
        String sql = "SELECT COUNT(*) AS total FROM orders\n"
                + "        WHERE YEAR(date) = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, year);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                number = rs.getInt("total");
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return number;
    }

    public int getNumberOfProductByYear(int year) {
        int number = 0;
        String sql = "SELECT sum(order_detail.quantity) as total\n"
                + "FROM   order_detail INNER JOIN\n"
                + "             orders ON order_detail.order_id = orders.order_id\n"
                + "			 WHERE YEAR(date) = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, year);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                number = rs.getInt("total");
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return number;
    }

    public int getNumberOfProduct() {
        int number = 0;
        String sql = "select sum(quantity) as total from order_detail";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                number = rs.getInt("total");

            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return number;
    }

    public int getRevenue() {
        int number = 0;
        String sql = "SELECT sum(order_detail.quantity * product.price) AS total\n"
                + "FROM   order_detail INNER JOIN\n"
                + "             product ON order_detail.product_id = product.product_id";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                number = rs.getInt("total");

            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return number;
    }

    public int getRevenueByYear(int year) {
        int number = 0;
        String sql = "SELECT sum(order_detail.quantity * product.price) AS total\n"
                + "FROM   order_detail INNER JOIN\n"
                + "             product ON order_detail.product_id = product.product_id INNER JOIN\n"
                + "             orders ON order_detail.order_id = orders.order_id\n"
                + "			  WHERE YEAR(date) = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, year);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                number = rs.getInt("total");

            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return number;
    }

    public int getRevenueByMonth(int month, int year) {
        int number = 0;
        String sql = "SELECT COALESCE(SUM(total), 0) AS tong\n"
                + "FROM orders\n"
                + "WHERE MONTH(date) = ? and year(date)  = ?;";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, month);
            st.setInt(2, year);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                number = rs.getInt("tong");

            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return number;
    }

    public int getNumberOfCustomer() {
        int number = 0;
        String sql = "select count(DISTINCT  usernameCustomer) as total from orders";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                number = rs.getInt("total");

            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return number;
    }

    public int getNumberOfCustomerByYear(int year) {
        int number = 0;
        String sql = "select count(DISTINCT  usernameCustomer) as total \n"
                + "from orders\n"
                + " WHERE YEAR(date) = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, year);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                number = rs.getInt("total");

            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return number;
    }

    public List<product> getMaleProduct() {
        DAOcategory DAOcategory = new DAOcategory();
        String listId = DAOcategory.getIdGender("male");

        List<product> list = new ArrayList<>();
        String sql = "select * from product where category_id in " + listId;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                product p = new product(rs.getInt("product_id"), rs.getInt("quantity"), rs.getInt("price"), rs.getInt("category_id"), rs.getInt("promo_id"), rs.getString("name"),
                        rs.getString("description"), rs.getString("pic_url"));
                list.add(p);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public List<product> getFemaleProductByType(String type) {
        DAOcategory DAOcategory = new DAOcategory();
        int id = DAOcategory.getIdType(type, "female");

        List<product> list = new ArrayList<>();
        String sql = "select * from product\n"
                + "where category_id = " + id;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                product p = new product(rs.getInt("product_id"), rs.getInt("quantity"), rs.getInt("price"), rs.getInt("category_id"), rs.getInt("promo_id"), rs.getString("name"),
                        rs.getString("description"), rs.getString("pic_url"));
                list.add(p);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public List<product> getMaleProductByType(String type) {
        DAOcategory DAOcategory = new DAOcategory();
        int id = DAOcategory.getIdType(type, "male");

        List<product> list = new ArrayList<>();
        String sql = "select * from product\n"
                + "where category_id = " + id;
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                product p = new product(rs.getInt("product_id"), rs.getInt("quantity"), rs.getInt("price"), rs.getInt("category_id"), rs.getInt("promo_id"), rs.getString("name"),
                        rs.getString("description"), rs.getString("pic_url"));
                list.add(p);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

}
