/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

import java.util.Date;

/**
 *
 * @author thinh
 */
public class importDetail {

    private int importDetailID, productID, quantity, price, importID;
    private String productName, sizeName;

    public importDetail(int importID, int productID, int quantity, int price, String productName, String sizeName) {
        this.productID = productID;
        this.importID = importID;

        this.quantity = quantity;
        this.price = price;
        this.productName = productName;
        this.sizeName = sizeName;
    }

    public importDetail(int productID, int quantity, String sizeName) {
        this.productID = productID;
        this.quantity = quantity;
        this.sizeName = sizeName;
    }
    
    

    public int getImportID() {
        return importID;
    }

    public void setImportID(int importID) {
        this.importID = importID;
    }



    public importDetail() {
    }

    public int getImportDetailID() {
        return importDetailID;
    }

    public void setImportDetailID(int importDetailID) {
        this.importDetailID = importDetailID;
    }

    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
        this.productID = productID;
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

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getSizeName() {
        return sizeName;
    }

    public void setSizeName(String sizeName) {
        this.sizeName = sizeName;
    }

}
