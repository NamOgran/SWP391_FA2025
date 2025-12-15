package DAO;

import entity.Product;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO extends DBConnect.DBConnect {

    // Helper: Map ResultSet to Entity
    private Product mapRow(ResultSet rs) throws SQLException {
        return new Product(
                rs.getInt("product_id"),
                rs.getInt("price"),
                rs.getInt("category_id"),
                rs.getString("voucher_id"), // [FIX] Correct column name and type (String)
                rs.getString("name"),
                rs.getString("description"),
                rs.getString("pic_url"),
                rs.getBoolean("is_active")
        );
    }

    // --- CRUD METHODS ---

    public List<Product> getAll() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM product";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) { System.out.println(e); }
        return list;
    }

    public Product getProductById(int product_id) {
        String sql = "SELECT * FROM product WHERE product_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, product_id);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) { System.out.println(e); }
        return null;
    }

    public boolean insert(Product p) {
        // [FIX] Changed 'promo_id' to 'voucher_id'
        String sql = "INSERT INTO product(name, description, pic_url, price, category_id, voucher_id, is_active) VALUES (?,?,?,?,?,?,?)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, p.getName());
            st.setString(2, p.getDescription());
            st.setString(3, p.getPicURL());
            st.setInt(4, p.getPrice());
            st.setInt(5, p.getCategoryID());
            
            // [FIX] Use setString for voucherID
            if (p.getVoucherID() == null || p.getVoucherID().isEmpty()) {
                st.setNull(6, java.sql.Types.VARCHAR);
            } else {
                st.setString(6, p.getVoucherID());
            }
            
            st.setBoolean(7, true); 
            st.executeUpdate();
            return true;
        } catch (Exception e) { System.out.println(e); }
        return false;
    }

    public boolean update(Product p) {
        // [FIX] Changed 'promo_id' to 'voucher_id'
        String sql = "UPDATE product SET name=?, description=?, pic_url=?, price=?, category_id=?, voucher_id=?, is_active=? WHERE product_id=?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, p.getName());
            st.setString(2, p.getDescription());
            st.setString(3, p.getPicURL());
            st.setInt(4, p.getPrice());
            st.setInt(5, p.getCategoryID());
            
            // [FIX] Use setString for voucherID
            if (p.getVoucherID() == null || p.getVoucherID().isEmpty()) {
                st.setNull(6, java.sql.Types.VARCHAR);
            } else {
                st.setString(6, p.getVoucherID());
            }
            
            st.setBoolean(7, p.isIs_active());
            st.setInt(8, p.getId());
            st.executeUpdate();
            return true;
        } catch (Exception e) { System.out.println(e); }
        return false;
    }

    public String deleteProductWithChecks(int productId) {
        try {
            Size_detailDAO size_detailDAO = new Size_detailDAO();
            if (size_detailDAO.hasDataForProduct(productId)) return "Deletion failed: Has related data in Size_detail.";
            
            CartDAO cartDAO = new CartDAO();
            if (cartDAO.hasDataForProduct(productId)) return "Deletion failed: Has related data in Cart.";

            OrderDAO orderDAO = new OrderDAO();
            if (orderDAO.hasDataForProduct(productId)) return "Deletion failed: Has related data in Orders.";
            
            ImportDetailDAO importDetailDAO = new ImportDetailDAO();
            if (importDetailDAO.hasDataForProduct(productId)) return "Deletion failed: Has related data in Imports.";

            FeedBackDAO feedBackDAO = new FeedBackDAO();
            if (feedBackDAO.hasDataForProduct(productId)) return "Deletion failed: Has related data in Feedback.";
        } catch (Exception e) { return "Check error: " + e.getMessage(); }

        String sql = "DELETE FROM product WHERE product_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, productId);
            return st.executeUpdate() > 0 ? "success" : "Product not found";
        } catch (SQLException e) { return "DB Error: " + e.getMessage(); }
    }
    
    public boolean delete(int id) {
        return "success".equals(deleteProductWithChecks(id));
    }

    // --- SEARCH & FILTER METHODS ---

    public int getTotalProductCount(String searchName, int categoryId, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM product WHERE 1=1");
        if (searchName != null && !searchName.trim().isEmpty()) sql.append(" AND name LIKE ?");
        if (categoryId > 0) sql.append(" AND category_id = ?");
        if ("active".equals(status)) sql.append(" AND is_active = 1");
        else if ("inactive".equals(status)) sql.append(" AND is_active = 0");
        
        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            if (searchName != null && !searchName.trim().isEmpty()) st.setString(idx++, "%" + searchName + "%");
            if (categoryId > 0) st.setInt(idx++, categoryId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public List<Product> getPaginatedProducts(String searchName, String sortBy, int categoryId, String status, int pageIndex, int pageSize) {
        List<Product> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM product WHERE 1=1");
        if (searchName != null && !searchName.trim().isEmpty()) sql.append(" AND name LIKE ?");
        if (categoryId > 0) sql.append(" AND category_id = ?");
        if ("active".equals(status)) sql.append(" AND is_active = 1");
        else if ("inactive".equals(status)) sql.append(" AND is_active = 0");
        
        if ("price_asc".equals(sortBy)) sql.append(" ORDER BY price ASC");
        else if ("price_desc".equals(sortBy)) sql.append(" ORDER BY price DESC");
        else if ("name_asc".equals(sortBy)) sql.append(" ORDER BY name ASC");
        else sql.append(" ORDER BY product_id DESC");
        
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            if (searchName != null && !searchName.trim().isEmpty()) st.setString(idx++, "%" + searchName + "%");
            if (categoryId > 0) st.setInt(idx++, categoryId);
            st.setInt(idx++, (pageIndex - 1) * pageSize);
            st.setInt(idx++, pageSize);
            
            ResultSet rs = st.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean toggleActiveStatus(int productId, boolean newStatus) {
        String sql = "UPDATE product SET is_active = ? WHERE product_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setBoolean(1, newStatus);
            st.setInt(2, productId);
            return st.executeUpdate() > 0;
        } catch (Exception e) { return false; }
    }

    // --- PUBLIC/SHOPPING METHODS ---

    public List<Product> getPublicProducts(String context, String sort1, String sort2, String priceRange, String categoryFilter) {
        List<Product> list = new ArrayList<>();
        CategoryDAO catDao = new CategoryDAO();
        StringBuilder sql = new StringBuilder("SELECT p.* FROM product p ");
        if ("BestSeller".equals(sort1)) {
            sql.append(" LEFT JOIN (SELECT product_id, SUM(quantity) as sold FROM order_detail GROUP BY product_id) s ON p.product_id = s.product_id ");
        }

        sql.append(" WHERE p.is_active = 1 ");
        
        if (context != null && !context.isEmpty()) {
            if (context.contains("female")) {
                if (context.contains("tshirt")) sql.append(" AND p.category_id = ").append(catDao.getIdType("t-shirt", "female"));
                else if (context.contains("dress")) sql.append(" AND p.category_id = ").append(catDao.getIdType("dress", "female"));
                else if (context.contains("pant")) sql.append(" AND p.category_id = ").append(catDao.getIdType("pant", "female"));
                else sql.append(" AND p.category_id IN ").append(catDao.getIdGender("female"));
            } else if (context.contains("male")) {
                if (context.contains("tshirt")) sql.append(" AND p.category_id = ").append(catDao.getIdType("t-shirt", "male"));
                else if (context.contains("short")) sql.append(" AND p.category_id = ").append(catDao.getIdType("short", "male"));
                else if (context.contains("pant")) sql.append(" AND p.category_id = ").append(catDao.getIdType("pant", "male"));
                else sql.append(" AND p.category_id IN ").append(catDao.getIdGender("male"));
            }
        }

        if (priceRange != null && !priceRange.isEmpty()) {
            switch (priceRange) {
                case "0-100000": sql.append(" AND p.price < 100000 "); break;
                case "200000-300000": sql.append(" AND p.price BETWEEN 200000 AND 300000 "); break;
                case "300000-400000": sql.append(" AND p.price BETWEEN 300000 AND 400000 "); break;
                case "400000-500000": sql.append(" AND p.price BETWEEN 400000 AND 500000 "); break;
                case "500000+": sql.append(" AND p.price > 500000 "); break;
            }
        }

        if ("name_asc".equals(sort2)) sql.append(" ORDER BY p.name ASC ");
        else if ("name_desc".equals(sort2)) sql.append(" ORDER BY p.name DESC ");
        else if ("BestSeller".equals(sort1)) sql.append(" ORDER BY s.sold DESC ");
        else sql.append(" ORDER BY p.product_id DESC ");

        try (PreparedStatement st = connection.prepareStatement(sql.toString()); 
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) { System.out.println("Error ProductDAO.getPublicProducts: " + e.getMessage()); }
        return list;
    }

    public List<Product> search(String name) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM product WHERE name LIKE ? AND is_active = 1";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, name);
            ResultSet rs = st.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) { System.out.println(e); }
        return list;
    }

    public List<Product> sortNew() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM product WHERE is_active = 1 ORDER BY product_id DESC";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) { System.out.println(e); }
        return list;
    }
    
    public List<Product> get8RandomProduct() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT TOP 8 * FROM product WHERE is_active = 1 ORDER BY NEWID()";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
    
    public List<Product> sortIncrease() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM product WHERE is_active = 1 ORDER BY price ASC";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) {}
        return list;
    }
    
    public List<Product> sortDecrease() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM product WHERE is_active = 1 ORDER BY price DESC";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) {}
        return list;
    }
    
    public List<Product> getFemaleProduct() {
        CategoryDAO cat = new CategoryDAO();
        return getByCatIds(cat.getIdGender("female"));
    }
    public List<Product> getMaleProduct() {
        CategoryDAO cat = new CategoryDAO();
        return getByCatIds(cat.getIdGender("male"));
    }
    public List<Product> getFemaleProductByType(String type) {
        CategoryDAO cat = new CategoryDAO();
        return getByCatId(cat.getIdType(type, "female"));
    }
    public List<Product> getMaleProductByType(String type) {
        CategoryDAO cat = new CategoryDAO();
        return getByCatId(cat.getIdType(type, "male"));
    }
    private List<Product> getByCatIds(String ids) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM product WHERE category_id IN " + ids + " AND is_active = 1";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) {}
        return list;
    }
    private List<Product> getByCatId(int id) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM product WHERE category_id = ? AND is_active = 1";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) {}
        return list;
    }
    
    public boolean hasDataForVoucher(String voucherId) { // [FIX] String parameter
        String sql = "SELECT TOP 1 1 FROM product WHERE voucher_id = ?"; // [FIX] voucher_id
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, voucherId); // [FIX] setString
            ResultSet rs = st.executeQuery();
            return rs.next();
        } catch (SQLException e) { return true; }
    }
    
    public List<Product> getProductsByVoucherId(String voucherId) { // [FIX] String parameter
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM product WHERE voucher_id = ?"; // [FIX] voucher_id
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, voucherId); // [FIX] setString
            ResultSet rs = st.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // Statistics methods (Keep SQL logic)
    public int getNumberOfProduct() { return 0; } 
    public int getNumberOfOrder() { return 0; }
    public int getRevenue() { return 0; }
    public int getNumberOfCustomer() { return 0; }
    
    public int getNumberOfOrderByYear(int year) { 
        String sql = "SELECT COUNT(*) FROM orders WHERE YEAR([date]) = ? AND status = 'Delivered'";
        return getCount(sql, year);
    }
    public int getNumberOfProductByYear(int year) {
        String sql = "SELECT COALESCE(SUM(od.quantity), 0) FROM order_detail od JOIN orders o ON od.order_id = o.order_id WHERE YEAR(o.[date]) = ? AND o.status = 'Delivered'";
        return getCount(sql, year);
    }
    public int getRevenueByYear(int year) {
        String sql = "SELECT COALESCE(SUM(total), 0) FROM orders WHERE YEAR([date]) = ? AND status = 'Delivered'";
        return getCount(sql, year);
    }
    public int getRevenueByMonth(int month, int year) {
        String sql = "SELECT COALESCE(SUM(total), 0) FROM orders WHERE MONTH([date]) = ? AND YEAR([date]) = ? AND status = 'Delivered'";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, month);
            st.setInt(2, year);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {}
        return 0;
    }
    public int getNumberOfCustomerByYear(int year) {
        String sql = "SELECT COUNT(DISTINCT customer_id) FROM orders WHERE YEAR([date]) = ? AND status = 'Delivered'";
        return getCount(sql, year);
    }
    private int getCount(String sql, int param) {
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, param);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {}
        return 0;
    }
}