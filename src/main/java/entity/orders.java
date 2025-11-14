/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

import java.util.Date;
import java.util.List;

public class Orders {

    private int order_id;
    private String address;
    private Date date;
    private String status;
    private String phone_number;
    private int customer_id;
    private int staff_id;
    private int total;
    private List<OrderDetail> orderDetails; // liên kết 1-n
    // Constructor mới với staff_id (int)

    public Orders(int orderID, String address, Date date, String status, String phoneNumber, int customer_id, int staff_id, int total) {
        this.order_id = orderID;
        this.address = address;
        this.date = date;
        this.status = status;
        this.phone_number = phone_number;
        this.customer_id = customer_id;
        this.staff_id = staff_id;
        this.total = total;
    }

    // Constructor khi insert (orderID tự tăng)
    public Orders(String address, Date date, String status, String phoneNumber, int customer_id, int staff_id, int total) {
        this.address = address;
        this.date = date;
        this.status = status;
        this.phone_number = phone_number;
        this.customer_id = customer_id;
        this.staff_id = staff_id;
        this.total = total;
    }

    public int getOrderID() {
        return order_id;
    }

    public void setOrderID(int orderID) {
        this.order_id = order_id;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPhoneNumber() {
        return phone_number;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phone_number = phone_number;
    }

    public int getCustomer_id() {
        return customer_id;
    }

    public void setCustomer_id(int customer_id) {
        this.customer_id = customer_id;
    }

    // Getter cho staff_id (int)
    public int getStaff_id() {
        return staff_id;
    }

    // Setter cho staff_id (int)
    public void setStaff_id(int staff_id) {
        this.staff_id = staff_id;
    }

    public float getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    @Override
    public String toString() {
        return "orders{" + "orderID=" + order_id + ", address=" + address + ", date=" + date + ", status=" + status + ", phoneNumber=" + phone_number + ", customer_id=" + customer_id + ", staff_id=" + staff_id + ", total=" + total + '}';
    }
}
