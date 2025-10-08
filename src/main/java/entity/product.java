
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

/**
 *
 * @author LENOVO
 */
public class product {
    //    product_id int IDENTITY(1,1) primary key,
//[name] varchar(255),
//quantity int, 
//[description] varchar(255),
//pic_url varchar(255),
//price int,
//category_id int foreign key references category,
//promo_id int foreign key references promo
    int id, quantity, price, categoryID, promoID;
    String name, description, picURL;

    public product(int id, int quantity, int price, int categoryID, int promoID, String name, String description, String picURL) {
        this.id = id;
        this.quantity = quantity;
        this.price = price;
        this.categoryID = categoryID;
        this.promoID = promoID;
        this.name = name;
        this.description = description;
        this.picURL = picURL;
    }
    
       public product() {
    }

        public product( int quantity, int price, int categoryID, int promoID, String name, String description, String picURL) {
        this.quantity = quantity;
        this.price = price;
        this.categoryID = categoryID;
        this.promoID = promoID;
        this.name = name;
        this.description = description;
        this.picURL = picURL;
    }
  


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

    @Override
    public String toString() {
        return "product{" + "id=" + id + ", quantity=" + quantity + ", price=" + price + ", categoryID=" + categoryID + ", promoID=" + promoID + ", name=" + name + ", description=" + description + ", picURL=" + picURL + '}';
    }
    

}

