/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import entity.Product;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * 
 */
public class ProductDAO extends DBConnect.DBConnect {

    // === PHƯƠNG THỨC MỚI CHO PHÂN TRANG (Dùng cho Admin) ===
    /**
     * Lấy tổng số sản phẩm, có thể lọc theo tên. (Dùng cho Admin, đếm tất cả)
     * @param searchName Tên tìm kiếm (nếu rỗng, đếm tất cả)
     * @return Tổng số sản phẩm
     */
    public int getTotalProductCount(String searchName) {
        String sql = "SELECT COUNT(*) FROM product";
        if (searchName != null && !searchName.trim().isEmpty()) {
            sql += " WHERE name LIKE ?";
        }
        
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            if (searchName != null && !searchName.trim().isEmpty()) {
                st.setString(1, "%" + searchName + "%");
            }
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1); // Trả về giá trị của cột COUNT(*)
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi ProductDAO.getTotalProductCount: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Lấy danh sách sản phẩm đã được phân trang. (Dùng cho Admin, lấy tất cả)
     * @param searchName Tên tìm kiếm (nếu rỗng, bỏ qua)
     * @param sortBy Sắp xếp ("asc", "desc") (nếu rỗng, dùng mặc định)
     * @param pageIndex Trang hiện tại (bắt đầu từ 1)
     * @param pageSize Số lượng sản phẩm mỗi trang (ví dụ: 10)
     * @return Danh sách sản phẩm
     */
    public List<Product> getPaginatedProducts(String searchName, String sortBy, int pageIndex, int pageSize) {
        List<Product> list = new ArrayList<>();
        
        // Xây dựng câu lệnh SQL cơ bản
        StringBuilder sql = new StringBuilder("SELECT * FROM product");
        
        // Thêm điều kiện WHERE (cho tìm kiếm)
        if (searchName != null && !searchName.trim().isEmpty()) {
            sql.append(" WHERE name LIKE ?");
        }
        
        // Thêm ORDER BY (cho sắp xếp)
        if (sortBy != null && !sortBy.trim().isEmpty()) {
            if ("asc".equals(sortBy)) {
                sql.append(" ORDER BY price ASC");
            } else if ("desc".equals(sortBy)) {
                sql.append(" ORDER BY price DESC");
            } else {
                sql.append(" ORDER BY product_id DESC"); // Mặc định
            }
        } else {
            sql.append(" ORDER BY product_id DESC"); // Mặc định
        }
        
        // Thêm OFFSET-FETCH (cho phân trang SQL Server 2012+)
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            
            // Set tham số cho WHERE (nếu có)
            if (searchName != null && !searchName.trim().isEmpty()) {
                st.setString(paramIndex++, "%" + searchName + "%");
            }
            
            // Set tham số cho OFFSET-FETCH
            int offset = (pageIndex - 1) * pageSize;
            st.setInt(paramIndex++, offset);
            st.setInt(paramIndex++, pageSize);
            
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product(
                            rs.getInt("product_id"),
                            rs.getInt("quantity"),
                            rs.getInt("price"),
                            rs.getInt("category_id"),
                            rs.getInt("promo_id"),
                            rs.getString("name"),
                            rs.getString("description"),
                            rs.getString("pic_url"),
                            rs.getBoolean("is_active")
                    );
                    list.add(p);
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi ProductDAO.getPaginatedProducts: " + e.getMessage());
        }
        return list;
    }
    
    // === CÁC PHƯƠNG THỨC CŨ ĐÃ CẬP NHẬT (CHO ADMIN) ===

    // Hàm getAll() này DÙNG CHO ADMIN, lấy tất cả
    public List<Product> getAll() {
        List<Product> list = new ArrayList<>();
        String sql = "select * from product"; 
        try {
            PreparedStatement st = connection.prepareStatement(sql); 
            ResultSet rs = st.executeQuery(); 
            while (rs.next()) {
                Product p = new Product(
                        rs.getInt("product_id"), 
                        rs.getInt("quantity"), 
                        rs.getInt("price"), 
                        rs.getInt("category_id"), 
                        rs.getInt("promo_id"), 
                        rs.getString("name"),
                        rs.getString("description"), 
                        rs.getString("pic_url"),
                        rs.getBoolean("is_active") 
                );
                list.add(p); 
            }
        } catch (Exception e) {
            System.out.println(e); 
        }
        return list; 
    }

    // Hàm getProductById() này DÙNG CHO ADMIN (vì nó lấy cả sản phẩm inactive)
    public Product getProductById(int product_id) {
        String sql = "select * from product where product_id=?"; 
        try {
            PreparedStatement st = connection.prepareStatement(sql); 
            st.setInt(1, product_id);
            ResultSet rs = st.executeQuery(); 
            if (rs.next()) {
                Product p = new Product(
                        rs.getInt("product_id"), 
                        rs.getInt("quantity"), 
                        rs.getInt("price"), 
                        rs.getInt("category_id"), 
                        rs.getInt("promo_id"), 
                        rs.getString("name"),
                        rs.getString("description"), 
                        rs.getString("pic_url"),
                        rs.getBoolean("is_active") 
                );
                return p; 
            }
        } catch (SQLException e) {
            System.out.println(e); 
        }
        return null; 
    }
    
    // === CÁC HÀM CÔNG CỘNG (PUBLIC) CẦN LỌC is_active = 1 ===

    // SỬA: Hàm search() DÙNG CHO PUBLIC (AJAX) -> chỉ lấy sp active
    public List<Product> search(String name) {
        List<Product> list = new ArrayList<>();
        // BỔ SUNG: AND is_active = 1
        String sql = "select * from product where name like ? AND is_active = 1"; 
        try {
            PreparedStatement st = connection.prepareStatement(sql); 
            st.setString(1, name);
            ResultSet rs = st.executeQuery(); 
            while (rs.next()) {
                Product p = new Product(
                        rs.getInt("product_id"), 
                        rs.getInt("quantity"), 
                        rs.getInt("price"), 
                        rs.getInt("category_id"), 
                        rs.getInt("promo_id"), 
                        rs.getString("name"),
                        rs.getString("description"), 
                        rs.getString("pic_url"),
                        rs.getBoolean("is_active")
                );
                list.add(p); 
            }
        } catch (Exception e) {
            System.out.println(e); 
        }
        return list; 
    }

    // SỬA: Hàm get8RandomProduct() DÙNG CHO PUBLIC (index.jsp) -> chỉ lấy sp active
    public List<Product> get8RandomProduct() {
        List<Product> list = new ArrayList<>();
        // BỔ SUNG: WHERE is_active = 1
        String sql = "select top 8 * from product WHERE is_active = 1 order by newid()"; 
        try {
            PreparedStatement st = connection.prepareStatement(sql); 
            ResultSet rs = st.executeQuery(); 
            while (rs.next()) {
                Product p = new Product(
                        rs.getInt("product_id"), 
                        rs.getInt("quantity"), 
                        rs.getInt("price"), 
                        rs.getInt("category_id"), 
                        rs.getInt("promo_id"), 
                        rs.getString("name"),
                        rs.getString("description"), 
                        rs.getString("pic_url"),
                        rs.getBoolean("is_active")
                );
                list.add(p); 
            }
        } catch (Exception e) {
            System.out.println(e); 
        }
        return list; 
    }

    // SỬA: Hàm getFemaleProduct() DÙNG CHO PUBLIC -> chỉ lấy sp active
    public List<Product> getFemaleProduct() {
        CategoryDAO DAOcategory = new CategoryDAO(); 
        String listId = DAOcategory.getIdGender("female"); 
        List<Product> list = new ArrayList<>();
        // BỔ SUNG: AND is_active = 1
        String sql = "select * from product where category_id in " + listId + " AND is_active = 1"; 
        try {
            PreparedStatement st = connection.prepareStatement(sql); 
            ResultSet rs = st.executeQuery(); 
            while (rs.next()) {
                Product p = new Product(
                        rs.getInt("product_id"), 
                        rs.getInt("quantity"), 
                        rs.getInt("price"), 
                        rs.getInt("category_id"), 
                        rs.getInt("promo_id"), 
                        rs.getString("name"),
                        rs.getString("description"), 
                        rs.getString("pic_url"),
                        rs.getBoolean("is_active")
                );
                list.add(p); 
            }
        } catch (Exception e) {
            System.out.println(e); 
        }
        return list; 
    }

    // SỬA: Hàm getMaleProduct() DÙNG CHO PUBLIC -> chỉ lấy sp active
    public List<Product> getMaleProduct() {
        CategoryDAO DAOcategory = new CategoryDAO(); 
        String listId = DAOcategory.getIdGender("male"); 

        List<Product> list = new ArrayList<>();
        // BỔ SUNG: AND is_active = 1
        String sql = "select * from product where category_id in " + listId + " AND is_active = 1"; 
        try {
            PreparedStatement st = connection.prepareStatement(sql); 
            ResultSet rs = st.executeQuery(); 
            while (rs.next()) {
                Product p = new Product(
                        rs.getInt("product_id"), 
                        rs.getInt("quantity"), 
                        rs.getInt("price"), 
                        rs.getInt("category_id"), 
                        rs.getInt("promo_id"), 
                        rs.getString("name"),
                        rs.getString("description"), 
                        rs.getString("pic_url"),
                        rs.getBoolean("is_active")
                );
                list.add(p); 
            }
        } catch (Exception e) {
            System.out.println(e); 
        }
        return list; 
    }

    // SỬA: Hàm getFemaleProductByType() DÙNG CHO PUBLIC -> chỉ lấy sp active
    public List<Product> getFemaleProductByType(String type) {
        CategoryDAO DAOcategory = new CategoryDAO();
        int id = DAOcategory.getIdType(type, "female");

        List<Product> list = new ArrayList<>();
        // BỔ SUNG: AND is_active = 1
        String sql = "select * from product where category_id = " + id + " AND is_active = 1";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Product p = new Product(
                        rs.getInt("product_id"), 
                        rs.getInt("quantity"), 
                        rs.getInt("price"), 
                        rs.getInt("category_id"), 
                        rs.getInt("promo_id"), 
                        rs.getString("name"),
                        rs.getString("description"), 
                        rs.getString("pic_url"),
                        rs.getBoolean("is_active")
                );
                list.add(p);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    // SỬA: Hàm getMaleProductByType() DÙNG CHO PUBLIC -> chỉ lấy sp active
    public List<Product> getMaleProductByType(String type) {
        CategoryDAO DAOcategory = new CategoryDAO();
        int id = DAOcategory.getIdType(type, "male");

        List<Product> list = new ArrayList<>();
        // BỔ SUNG: AND is_active = 1
        String sql = "select * from product where category_id = " + id + " AND is_active = 1";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Product p = new Product(
                        rs.getInt("product_id"), 
                        rs.getInt("quantity"), 
                        rs.getInt("price"), 
                        rs.getInt("category_id"), 
                        rs.getInt("promo_id"), 
                        rs.getString("name"),
                        rs.getString("description"), 
                        rs.getString("pic_url"),
                        rs.getBoolean("is_active")
                );
                list.add(p);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    // === CÁC HÀM SẮP XẾP DÙNG CHO PUBLIC ===

    // SỬA: Hàm sortIncrease() -> chỉ lấy sp active
    public List<Product> sortIncrease() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM product WHERE is_active = 1 ORDER BY price ASC"; 
        try {
            PreparedStatement st = connection.prepareStatement(sql); 
            ResultSet rs = st.executeQuery(); 
            while (rs.next()) {
                Product p = new Product(
                        rs.getInt("product_id"), 
                        rs.getInt("quantity"), 
                        rs.getInt("price"), 
                        rs.getInt("category_id"), 
                        rs.getInt("promo_id"), 
                        rs.getString("name"),
                        rs.getString("description"), 
                        rs.getString("pic_url"),
                        rs.getBoolean("is_active")
                );
                list.add(p); 
            }
        } catch (Exception e) {
            System.out.println(e); 
        }
        return list; 
    }

    // SỬA: Hàm sortDecrease() -> chỉ lấy sp active
    public List<Product> sortDecrease() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM product WHERE is_active = 1 ORDER BY price DESC"; 
        try {
            PreparedStatement st = connection.prepareStatement(sql); 
            ResultSet rs = st.executeQuery(); 
            while (rs.next()) {
                Product p = new Product(
                        rs.getInt("product_id"), 
                        rs.getInt("quantity"), 
                        rs.getInt("price"), 
                        rs.getInt("category_id"), 
                        rs.getInt("promo_id"), 
                        rs.getString("name"),
                        rs.getString("description"), 
                        rs.getString("pic_url"),
                        rs.getBoolean("is_active")
                );
                list.add(p); 
            }
        } catch (Exception e) {
            System.out.println(e); 
        }
        return list; 
    }

    // SỬA: Hàm sortBestSeller() -> chỉ lấy sp active
    public List<Product> sortBestSeller() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.*\n"
                + "FROM product p\n"
                + "JOIN (\n"
                + "    SELECT product_id, SUM(quantity) AS total_quantity\n"
                + "    FROM order_detail\n"
                + "    GROUP BY product_id\n" 
                + ") AS product_sales ON p.product_id = product_sales.product_id\n"
                + "WHERE p.is_active = 1\n" // BỔ SUNG
                + "ORDER BY product_sales.total_quantity DESC;"; 
        try {
            PreparedStatement st = connection.prepareStatement(sql); 
            ResultSet rs = st.executeQuery(); 
            while (rs.next()) {
                Product p = new Product(
                        rs.getInt("product_id"), 
                        rs.getInt("quantity"), 
                        rs.getInt("price"), 
                        rs.getInt("category_id"), 
                        rs.getInt("promo_id"), 
                        rs.getString("name"),
                        rs.getString("description"), 
                        rs.getString("pic_url"),
                        rs.getBoolean("is_active")
                );
                list.add(p); 
            }
        } catch (Exception e) {
            System.out.println(e); 
        }
        return list; 
    }

    // SỬA: Hàm sortNew() -> chỉ lấy sp active
    public List<Product> sortNew() {
        List<Product> list = new ArrayList<>();
        String sql = "select * from product WHERE is_active = 1 ORDER BY product_id DESC"; 
        try {
            PreparedStatement st = connection.prepareStatement(sql); 
            ResultSet rs = st.executeQuery(); 
            while (rs.next()) {
                Product p = new Product(
                        rs.getInt("product_id"), 
                        rs.getInt("quantity"), 
                        rs.getInt("price"), 
                        rs.getInt("category_id"), 
                        rs.getInt("promo_id"), 
                        rs.getString("name"),
                        rs.getString("description"), 
                        rs.getString("pic_url"),
                        rs.getBoolean("is_active")
                );
                list.add(p); 
            }
        } catch (Exception e) {
            System.out.println(e); 
        }
        return list; 
    }

    // === CÁC HÀM KHÔNG ĐỔI (Cập nhật, Xóa, Thống kê, v.v.) ===
    
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
                + "             orders ON order_detail.order_id = \n"
                + "orders.order_id\n"
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
    
    public boolean update(Product p) {
        String sql = "UPDATE [dbo].[product]\n"
                + "   SET [name] = ?\n"
                + "      ,[quantity] = ?\n"
                + "      ,[description] = ?\n" 
                + "      ,[pic_url] =?\n"
                + "      ,[price] = ?\n"
                + "      ,[category_id] = ?\n"
                + "      ,[promo_id] = ?\n" 
                + " WHERE [product_id] = ?\n";
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

    // ... (bên trong lớp ProductDAO)

    /**
     * Xóa sản phẩm SAU KHI kiểm tra các ràng buộc dữ liệu.
     * Trả về "success" nếu thành công, ngược lại trả về thông báo lỗi.
     */
    public String deleteProductWithChecks(int productId) {
        // 1. Kiểm tra các bảng phụ thuộc
        try {
            SizeDAO sizeDAO = new SizeDAO();
            if (sizeDAO.hasDataForProduct(productId)) {
                return "Deletion failed: Product has related data in 'size_detail'.";
            }
            
            CartDAO cartDAO = new CartDAO();
            if (cartDAO.hasDataForProduct(productId)) {
                return "Deletion failed: Product has related data in 'cart'.";
            }
            
            OrderDAO orderDAO = new OrderDAO();
            if (orderDAO.hasDataForProduct(productId)) {
                return "Deletion failed: Product has related data in 'order_detail'.";
            }
            
            ImportDetailDAO importDetailDAO = new ImportDetailDAO();
            if (importDetailDAO.hasDataForProduct(productId)) {
                return "Deletion failed: Product has related data in 'importDetails'.";
            }
            
            FeedbackDAO feedbackDAO = new FeedbackDAO();
            if (feedbackDAO.hasDataForProduct(productId)) {
                return "Deletion failed: Product has related data in 'feedback'.";
            }

        } catch (Exception e) {
             return "Error during dependency check: " + e.getMessage();
        }

        // 2. Nếu không có ràng buộc, tiến hành xóa
        String sql = "DELETE FROM product WHERE product_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, productId);
            int rowsAffected = st.executeUpdate();
            if (rowsAffected > 0) {
                return "success"; // Thành công
            } else {
                return "Deletion failed: Product not found.";
            }
        } catch (SQLException e) {
            // Lỗi này không nên xảy ra nếu các kiểm tra ở trên là đúng
            // Trừ khi có thêm ràng buộc khóa ngoại mà chúng ta bỏ lỡ
            System.err.println("ProductDAO.deleteProductWithChecks SQL ERROR: " + e.getMessage());
            return "Database error during deletion. Check constraints.";
        }
    }

    // Tùy chọn: Giữ lại hàm delete() cũ hoặc sửa nó để gọi hàm mới
    public boolean delete(int id) {
        // Hàm cũ này không còn được khuyến nghị sử dụng cho logic của bạn
        // Tốt nhất là gọi hàm mới và kiểm tra kết quả "success"
        String result = deleteProductWithChecks(id);
        return "success".equals(result);
    }

    public boolean insert(Product p) {
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
    
    // === PHƯƠNG THỨC ĐỂ BẬT/TẮT SẢN PHẨM ===
    
    public boolean toggleActiveStatus(int productId, boolean newStatus) {
        String sql = "UPDATE product SET is_active = ? WHERE product_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setBoolean(1, newStatus);
            st.setInt(2, productId);
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            System.out.println("Lỗi ProductDAO.toggleActiveStatus: " + e.getMessage());
            return false;
        }
    }
    /**
     * Lấy tổng số sản phẩm, có thể lọc theo tên, danh mục và trạng thái.
     * (Dùng cho Admin, đếm tất cả)
     * @param searchName Tên tìm kiếm
     * @param categoryId ID danh mục (0 = tất cả)
     * @param status Trạng thái ("all", "active", "inactive")
     * @return Tổng số sản phẩm
     */
    public int getTotalProductCount(String searchName, int categoryId, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM product");
        
        List<String> conditions = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        if (searchName != null && !searchName.trim().isEmpty()) {
            conditions.add("name LIKE ?");
            params.add("%" + searchName + "%");
        }
        if (categoryId > 0) {
            conditions.add("category_id = ?");
            params.add(categoryId);
        }
        if (status != null && !status.equals("all") && !status.isEmpty()) {
            if (status.equals("active")) {
                conditions.add("is_active = 1");
            } else if (status.equals("inactive")) {
                conditions.add("is_active = 0");
            }
        }

        if (!conditions.isEmpty()) {
            sql.append(" WHERE ").append(String.join(" AND ", conditions));
        }
        
        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            // Set tham số
            for (int i = 0; i < params.size(); i++) {
                st.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1); // Trả về giá trị của cột COUNT(*)
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi ProductDAO.getTotalProductCount: " + e.getMessage());
        }
        return 0;
    }
    /**
     * Lấy danh sách sản phẩm đã được phân trang. (Đã cập nhật)
     * (Dùng cho Admin, lấy tất cả)
     * @param searchName Tên tìm kiếm (nếu rỗng, bỏ qua)
     * @param sortBy Sắp xếp ("price_asc", "price_desc", "name_asc", "name_desc")
     * @param categoryId ID danh mục (0 = tất cả)
     * @param status Trạng thái ("all", "active", "inactive")
     * @param pageIndex Trang hiện tại (bắt đầu từ 1)
     * @param pageSize Số lượng sản phẩm mỗi trang
     * @return Danh sách sản phẩm
     */
    public List<Product> getPaginatedProducts(String searchName, String sortBy, int categoryId, String status, int pageIndex, int pageSize) {
      
        List<Product> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM product");
        
        List<String> conditions = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        // 1. Thêm điều kiện WHERE (cho tìm kiếm và lọc)
        if (searchName != null && !searchName.trim().isEmpty()) {
            conditions.add("name LIKE ?");
            params.add("%" + searchName + "%");
        }
        if (categoryId > 0) {
            conditions.add("category_id = ?");
            params.add(categoryId);
        }
        if (status != null && !status.equals("all") && !status.isEmpty()) {
            if (status.equals("active")) {
                conditions.add("is_active = 1");
            } else if (status.equals("inactive")) {
                conditions.add("is_active = 0");
            }
        }

        if (!conditions.isEmpty()) {
            sql.append(" WHERE ").append(String.join(" AND ", conditions));
        }
        
        // 2. Thêm ORDER BY (cho sắp xếp)
        if (sortBy != null && !sortBy.trim().isEmpty()) {
            if ("price_asc".equals(sortBy)) {
                sql.append(" ORDER BY price ASC");
            } else if ("price_desc".equals(sortBy)) {
                sql.append(" ORDER BY price DESC");
            } else if ("name_asc".equals(sortBy)) {
                sql.append(" ORDER BY name ASC");
            } else if ("name_desc".equals(sortBy)) {
                sql.append(" ORDER BY name DESC");
            } else {
                sql.append(" ORDER BY product_id DESC"); // Mặc định
            }
        } else {
            sql.append(" ORDER BY product_id DESC"); // Mặc định
        }
        
        // 3. Thêm OFFSET-FETCH (cho phân trang SQL Server 2012+)
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        
        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            
            // 4. Set tham số cho WHERE (nếu có)
            for (Object param : params) {
                st.setObject(paramIndex++, param);
            }
            
            // 5. Set tham số cho OFFSET-FETCH
            int offset = (pageIndex - 1) * pageSize;
            st.setInt(paramIndex++, offset);
            st.setInt(paramIndex++, pageSize);
            
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product(
                            rs.getInt("product_id"),
                            rs.getInt("quantity"),
                            rs.getInt("price"),
                            rs.getInt("category_id"),
                            rs.getInt("promo_id"),
                            rs.getString("name"),
                            rs.getString("description"),
                            rs.getString("pic_url"),
                            rs.getBoolean("is_active")
                    );
                    list.add(p);
                }
            }
        } catch (Exception e) {
            System.out.println("Lỗi ProductDAO.getPaginatedProducts: " + e.getMessage());
        }
        return list;
    }
    /**
     * Lấy danh sách các sản phẩm (chỉ ID, Name, Status) theo Promo ID.
     * Dùng cho việc kiểm tra ràng buộc khi xóa Promo.
     * @param promoId ID của khuyến mãi
     * @return Danh sách sản phẩm
     */
    public List<Product> getProductsByPromoId(int promoId) {
        List<Product> list = new ArrayList<>();
        // Lấy tất cả thông tin, constructor của Product đã được cập nhật
        String sql = "SELECT * FROM product WHERE promo_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, promoId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    // Sử dụng constructor đầy đủ của Product (đã được cập nhật)
                    Product p = new Product(
                            rs.getInt("product_id"),
                            rs.getInt("quantity"),
                            rs.getInt("price"),
                            rs.getInt("category_id"),
                            rs.getInt("promo_id"),
                            rs.getString("name"),
                            rs.getString("description"),
                            rs.getString("pic_url"),
                            rs.getBoolean("is_active")
                    );
                    list.add(p);
                }
            }
        } catch (SQLException e) {
            System.err.println("ProductDAO.getProductsByPromoId: " + e.getMessage());
        }
        return list;
    }

    /**
     * Kiểm tra nhanh xem có sản phẩm nào đang dùng Promo ID này không.
     * @param promoId ID của khuyến mãi
     * @return true nếu có ít nhất 1 sản phẩm đang dùng, false nếu không
     */
    public boolean hasDataForPromo(int promoId) {
        String sql = "SELECT TOP 1 1 FROM product WHERE promo_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, promoId);
            try (ResultSet rs = st.executeQuery()) {
                return rs.next(); // true nếu tìm thấy
            }
        } catch (SQLException e) {
            System.err.println("ProductDAO.hasDataForPromo: " + e.getMessage());
            return true; // Failsafe: Giả sử là CÓ nếu DB lỗi
        }
    }
}