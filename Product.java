package entity;

public class Product {

    private int id;
    private int price;
    private int categoryID;

    // [THAY ĐỔI] Từ String voucherID thành int discount
    private int discount;

    private String name;
    private String description;
    private String picURL;
    private boolean is_active;

    public Product() {
    }

    // Cập nhật Constructor đầy đủ (khi lấy từ DB)
    public Product(int id, int price, int categoryID, int discount, String name, String description, String picURL, boolean is_active) {
        this.id = id;
        this.price = price;
        this.categoryID = categoryID;
        this.discount = discount; // [MỚI]
        this.name = name;
        this.description = description;
        this.picURL = picURL;
        this.is_active = is_active;
    }

    // Cập nhật Constructor thêm mới (không có ID và is_active)
    public Product(int price, int categoryID, int discount, String name, String description, String picURL) {
        this.price = price;
        this.categoryID = categoryID;
        this.discount = discount; // [MỚI]
        this.name = name;
        this.description = description;
        this.picURL = picURL;
        this.is_active = true;
    }

    // --- Getter & Setter mới ---
    public int getDiscount() {
        return discount;
    }

    public void setDiscount(int discount) {
        this.discount = discount;
    }

    // --- Các Getter & Setter cũ (Giữ nguyên) ---
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public int getCategoryID() {
        return categoryID;
    }

    public void setCategoryID(int categoryID) {
        this.categoryID = categoryID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getPicURL() {
        return picURL;
    }

    public void setPicURL(String picURL) {
        this.picURL = picURL;
    }

    public boolean isIs_active() {
        return is_active;
    }

    public void setIs_active(boolean is_active) {
        this.is_active = is_active;
    }

    @Override
    public String toString() {
        return "Product{" + "id=" + id + ", price=" + price + ", categoryID=" + categoryID + ", discount=" + discount + ", name=" + name + ", description=" + description + ", picURL=" + picURL + ", is_active=" + is_active + '}';
    }
}
