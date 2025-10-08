/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

/**
 *
 * @author Administrator
 */
public class orderDetail {
    int quantity;
    String size_name;
    int productID;
    int orderID;

    public orderDetail(int quantity, String size_name, int productID, int orderID) {
        this.quantity = quantity;
        this.size_name = size_name;
        this.productID = productID;
        this.orderID = orderID;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getSize_name() {
        return size_name;
    }

    public void setSize_name(String size_name) {
        this.size_name = size_name;
    }

    public int getProductID() {
        return productID;
    }

    public void setProductID(int productID) {
        this.productID = productID;
    }

    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
    }

    @Override
    public String toString() {
        return "orderDetail{" + "quantity=" + quantity + ", size_name=" + size_name + ", productID=" + productID + ", orderID=" + orderID + '}';
    }
    
}
