/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import entity.ImportDetail;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 *
 */
public class ImportDetailDAO extends DBConnect.DBConnect {

    public List<ImportDetail> getAllImportDetail() {
        List<ImportDetail> list = new ArrayList<>();
        String sql = "SELECT import.import_id, importDetails.product_id,product.name,size_detail.size_name, importDetails.quantity,price *importDetails.quantity as\"price\"\n"
                + "FROM     import \n"
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

    public List<ImportDetail> getListToImport(String id) {
        List<ImportDetail> list = new ArrayList<>();
        String sql = "	SELECT importDetails.product_id, size_detail.size_name, importDetails.quantity\n"
                + "	FROM     importDetails INNER JOIN\n"
                + "					  size_detail ON importDetails.product_id = size_detail.product_id AND importDetails.size_name = size_detail.size_name\n"
                + "					  where import_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, id);
            ResultSet rs = st.executeQuery();
            while(rs.next()){
                ImportDetail i = new ImportDetail(rs.getInt("product_id"), rs.getInt("quantity"), rs.getString("size_name"));
                list.add(i);
            }
        } catch (Exception e) {
            System.out.println(e);
        }
        return list;
    }

    public int getQuantityByImportID(String id) {
        int quantity = 0;

        String sql = "SELECT SUM(importDetails.quantity) as \"quantity\"\n"
                + "                FROM     import INNER JOIN\n"
                + "                                 importDetails ON import.import_id = importDetails.import_id INNER JOIN\n"
                + "                                product ON importDetails.product_id = product.product_id\n"
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
                + "FROM     import INNER JOIN\n"
                + "                  importDetails ON import.import_id = importDetails.import_id INNER JOIN\n"
                + "                  product ON importDetails.product_id = product.product_id\n"
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
/**
     * Kiểm tra xem một sản phẩm có tồn tại trong bất kỳ chi tiết nhập hàng nào không.
     * @param productId ID sản phẩm
     * @return true nếu có, false nếu không
     */
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
    // Câu lệnh SQL của bạn phức tạp, chúng ta sẽ đơn giản hóa nó để chỉ lấy importDetails
    String sql = "SELECT * FROM importDetails WHERE product_id = ?";
    try (PreparedStatement st = connection.prepareStatement(sql)) {
        st.setInt(1, productId);
        try (ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                // Bạn có thể cần điều chỉnh constructor này dựa trên entity ImportDetail
                // Giả sử có một constructor phù hợp
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
}
