/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

public class Cart {
    int cart_id;
    int customer_id; // <-- Đã đổi từ String username sang int customer_id
    int product_id;
    int quantity;
    float price; // <-- Đã đổi từ int sang float
    String size_name;

    // Constructor mới: nhận customer_id (int) và price (float)
    public Cart(int cart_id, int customer_id, int product_id, int quantity, float price, String size_name) {
        this.cart_id = cart_id;
        this.customer_id = customer_id;
        this.product_id = product_id;
        this.quantity = quantity;
        this.price = price;
        this.size_name = size_name;
    }

    public int getCartID() {
        return cart_id;
    }

    public void setCartID(int cart_id) {
        this.cart_id = cart_id;
    }

    // Getter cho customer_id
    public int getCustomer_id() {
        return customer_id;
    }

    // Setter cho customer_id (nhận int)
    public void setCustomer_id(int customer_id) { // <-- SỬA: Thay đổi kiểu tham số
        this.customer_id = customer_id;
    }

    public int getProductID() {
        return product_id;
    }

    public void setProductID(int product_id) {
        this.product_id = product_id;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    // Getter cho price (float)
    public float getPrice() { // <-- SỬA: Kiểu trả về float
        return price;
    }

    // Setter cho price (float)
    public void setPrice(float price) { // <-- SỬA: Kiểu tham số float
        this.price = price;
    }

    public String getSize_name() {
        return size_name;
    }

    public void setSize_name(String size_name) {
        this.size_name = size_name;
    }

    @Override
    public String toString() {
        return "cart{" + "cart_id=" + cart_id + ", customer_id=" + customer_id + ", product_id=" + product_id + ", quantity=" + quantity + ", price=" + price + ", size_name=" + size_name + '}';
    }
}
