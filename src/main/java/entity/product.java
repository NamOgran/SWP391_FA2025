package entity;

public class Product {
    private int id;
    private int price;
    private int categoryID;
    private String voucherID; // [FIX] Changed int to String to match DB varchar(50)
    private String name;
    private String description;
    private String picURL;
    private boolean is_active;

    public Product() {
    }

    // Constructor full
    public Product(int id, int price, int categoryID, String voucherID, String name, String description, String picURL, boolean is_active) {
        this.id = id;
        this.price = price;
        this.categoryID = categoryID;
        this.voucherID = voucherID;
        this.name = name;
        this.description = description;
        this.picURL = picURL;
        this.is_active = is_active;
    }

    // Constructor for new product (default active = true)
    public Product(int price, int categoryID, String voucherID, String name, String description, String picURL) {
        this.price = price;
        this.categoryID = categoryID;
        this.voucherID = voucherID;
        this.name = name;
        this.description = description;
        this.picURL = picURL;
        this.is_active = true;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getPrice() { return price; }
    public void setPrice(int price) { this.price = price; }

    public int getCategoryID() { return categoryID; }
    public void setCategoryID(int categoryID) { this.categoryID = categoryID; }

    // [FIX] Updated Getter/Setter for String voucherID
    public String getVoucherID() { return voucherID; }
    public void setVoucherID(String voucherID) { this.voucherID = voucherID; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getPicURL() { return picURL; }
    public void setPicURL(String picURL) { this.picURL = picURL; }

    public boolean isIs_active() { return is_active; }
    public void setIs_active(boolean is_active) { this.is_active = is_active; }

    @Override
    public String toString() {
        return "Product{" + "id=" + id + ", price=" + price + ", categoryID=" + categoryID + ", voucherID=" + voucherID + ", name=" + name + ", description=" + description + ", picURL=" + picURL + ", is_active=" + is_active + '}';
    }
}