/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

/**
 *
 *
 */
public class Product {
    int id, quantity, price, categoryID, promoID;
    String name, description, picURL;
    
    // BỔ SUNG: Trường is_active
    private boolean is_active;

    // SỬA: Constructor đầy đủ
    public Product(int id, int quantity, int price, int categoryID, int promoID, String name, String description, String picURL, boolean is_active) {
        this.id = id;
        this.quantity = quantity;
        this.price = price;
        this.categoryID = categoryID;
        this.promoID = promoID;
        this.name = name;
        this.description = description;
        this.picURL = picURL;
        // BỔ SUNG: Gán giá trị is_active
        this.is_active = is_active;
    }

    // Constructor rỗng (Giữ nguyên)
    public Product() {
    }

    // SỬA: Constructor không có id (dùng khi insert)
    public Product(int quantity, int price, int categoryID, int promoID, String name, String description, String picURL) {
        this.quantity = quantity;
        this.price = price;
        this.categoryID = categoryID;
        this.promoID = promoID;
        this.name = name;
        this.description = description;
        this.picURL = picURL;
        this.is_active = true; // Mặc định là true khi tạo mới
    }

    // --- (Tất cả Getter/Setter cho id, quantity, price, v.v. giữ nguyên) ---
    
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
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

    public int getPromoID() {
        return promoID;
    }

    public void setPromoID(int promoID) {
        this.promoID = promoID;
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

    // --- BỔ SUNG: Getter/Setter cho is_active ---
    
    public boolean isIs_active() {
        return is_active;
    }

    public void setIs_active(boolean is_active) {
        this.is_active = is_active;
    }
    
    // SỬA: Hàm toString()
    @Override
    public String toString() {
        return "product{" + "id=" + id + ", quantity=" + quantity + ", price=" + price + 
               ", categoryID=" + categoryID + ", promoID=" + promoID + ", name=" + name + 
               ", description=" + description + ", picURL=" + picURL + 
               ", is_active=" + is_active + '}';
    }
}