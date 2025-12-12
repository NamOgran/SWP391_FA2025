package DAO;
import entity.ImportDetail;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ImportDetailDAO extends DBConnect.DBConnect {

    public List<ImportDetail> getAllImportDetail() {
        List<ImportDetail> list = new ArrayList<>();
        // [FIX] Changed 'size_detail' to 'size_detail'
        String sql = "SELECT import.import_id, importDetails.product_id, product.name, size_detail.size_name, importDetails.quantity, (product.price * importDetails.quantity) as \"price\"\n"
                + "FROM      import \n"
                + "join importDetails on import.import_id = importDetails.import_id \n"
                + "join size_detail on size_detail.product_id = importDetails.product_id and size_detail.size_name = importDetails.size_name\n"
                + "join product on product.product_id = size_detail.product_id";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                ImportDetail o = new ImportDetail(rs.getInt("import_id"), rs.getInt("product_id"), rs.getInt("quantity"), rs.getInt("price"), rs.getString("name"), rs.getString("size_name"));
                list.add(o);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    /**
     * Lấy danh sách chi tiết nhập hàng theo Import ID.
     * @param id Import ID (Integer)
     * @return List<ImportDetail>
     */
    public List<ImportDetail> getListToImport(int id) {
        List<ImportDetail> list = new ArrayList<>();
        // [FIX] Changed 'size_detail' to 'size_detail'
        String sql = "SELECT id.product_id, p.name, sd.size_name, id.quantity, p.price " +
                      "FROM importDetails id " +
                      "JOIN size_detail sd ON id.product_id = sd.product_id AND id.size_name = sd.size_name " +
                      "JOIN product p ON id.product_id = p.product_id " +
                      "WHERE id.import_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            while(rs.next()){
                ImportDetail i = new ImportDetail();
                i.setImportID(id);
                i.setProductID(rs.getInt("product_id"));
                i.setProductName(rs.getString("name"));
                i.setQuantity(rs.getInt("quantity"));
                i.setSizeName(rs.getString("size_name"));
                i.setPrice(rs.getInt("price")); // Lấy giá của sản phẩm (price * 1)
                list.add(i);
            }
        } catch (Exception e) {
            System.out.println("Error ImportDetailDAO: " + e);
        }
        return list;
    }

    public int getQuantityByImportID(String id) {
        int quantity = 0;
        String sql = "SELECT SUM(importDetails.quantity) as \"quantity\"\n"
                + "         FROM      import INNER JOIN\n"
                + "                        importDetails ON import.import_id = importDetails.import_id INNER JOIN\n"
                + "                        product ON importDetails.product_id = product.product_id\n"
                + "								where import.import_id  = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                quantity = rs.getInt("quantity");
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return quantity;
    }

    public int getPriceByImportID(String id) {
        int price = 0;
        String sql = "			SELECT SUM(price *importDetails.quantity) as \"price\"\n"
                + "FROM      import INNER JOIN\n"
                + "          importDetails ON import.import_id = importDetails.import_id INNER JOIN\n"
                + "          product ON importDetails.product_id = product.product_id\n"
                + "where import.import_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                price = rs.getInt("price");
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return price;
    }
    
    public boolean hasDataForProduct(int productId) {
        String sql = "SELECT TOP 1 1 FROM importDetails WHERE product_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, productId);
            try (ResultSet rs = st.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.err.println("ImportDetailDAO.hasDataForProduct: " + e.getMessage());
            return true;
        }
    }
    
    public List<ImportDetail> getImportDetailsByProductId(int productId) {
        List<ImportDetail> list = new ArrayList<>();
        String sql = "SELECT * FROM importDetails WHERE product_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, productId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    ImportDetail id = new ImportDetail();
                    id.setImportID(rs.getInt("import_id"));
                    id.setProductID(rs.getInt("product_id"));
                    id.setSizeName(rs.getString("size_name"));
                    id.setQuantity(rs.getInt("quantity"));
                    list.add(id);
                }
            }
        } catch (SQLException e) {
            System.err.println("ImportDetailDAO.getImportDetailsByProductId: " + e.getMessage());
        }
        return list;
    }
    
    public boolean insertImportDetail(ImportDetail detail) {
        String sql = "INSERT INTO importDetails (import_id, product_id, size_name, quantity) " +
                        "VALUES (?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, detail.getImportID());
            st.setInt(2, detail.getProductID());
            st.setString(3, detail.getSizeName());
            st.setInt(4, detail.getQuantity());
            
            return st.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Lỗi ImportDetailDAO.insertImportDetail: " + e.getMessage());
        }
        return false;
    }
}