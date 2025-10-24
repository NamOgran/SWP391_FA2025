/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

/**
 *
 * @author Administrator
 */
public class size {
    String size_name;
    int product_id;
    int quantity;

    public size(String size_name, int product_id, int quantity) {
        this.size_name = size_name;
        this.product_id = product_id;
        this.quantity = quantity;
    }

    public String getSize_name() {
        return size_name;
    }

    public void setSize_name(String size_name) {
        this.size_name = size_name;
    }

    public int getProduct_id() {
        return product_id;
    }

    public void setProduct_id(int product_id) {
        this.product_id = product_id;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    @Override
    public String toString() {
        return "size{" + "size_name=" + size_name + ", product_id=" + product_id + ", quantity=" + quantity + '}';
    }
    
}
