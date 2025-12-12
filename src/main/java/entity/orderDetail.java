/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

public class OrderDetail {
    private int orderDetailID;
    private int quantity;
    private String size_name;
    private int productID;
    private int orderID;

    public OrderDetail() {
        // Constructor mặc định
    }
    
    // Constructor DÙNG KHI ĐỌC TỪ DB (có orderDetailID)
    public OrderDetail(int orderDetailID, int quantity, String size_name, int productID, int orderID) {
        this.orderDetailID = orderDetailID;
        this.quantity = quantity;
        this.size_name = size_name;
        this.productID = productID;
        this.orderID = orderID;
    }

    // Constructor DÙNG KHI TẠO MỚI (KHÔNG CÓ orderDetailID, để DB tự tăng)
    public OrderDetail(int quantity, String size_name, int productID, int orderID) {
        this.quantity = quantity;
        this.size_name = size_name;
        this.productID = productID;
        this.orderID = orderID;
    }

    // Getter và Setter cho orderDetailID
    public int getOrderDetailID() {
        return orderDetailID;
    }

    public void setOrderDetailID(int orderDetailID) {
        this.orderDetailID = orderDetailID;
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
        return "orderDetail{" + "orderDetailID=" + orderDetailID + ", quantity=" + quantity + ", size_name=" + size_name + ", productID=" + productID + ", orderID=" + orderID + '}';
    }
}