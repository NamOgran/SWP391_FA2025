/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

import java.util.Date;

/**
 *
 * @author Administrator
 */
public class orders {
    int orderID;
    String address;
    Date date;
    String status;
    String phoneNumber;
    String usernameCustomer;
    String usernameStaff;
    int total;

    public orders(int orderID, String address, Date date, String status, String phoneNumber, String usernameCustomer, String usernameStaff, int total) {
        this.orderID = orderID;
        this.address = address;
        this.date = date;
        this.status = status;
        this.phoneNumber = phoneNumber;
        this.usernameCustomer = usernameCustomer;
        this.usernameStaff = usernameStaff;
        this.total = total;
    }

    public int getOrderID() {
        return orderID;
    }

    public void setOrderID(int orderID) {
        this.orderID = orderID;
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
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getUsernameCustomer() {
        return usernameCustomer;
    }

    public void setUsernameCustomer(String usernameCustomer) {
        this.usernameCustomer = usernameCustomer;
    }

    public String getUsernameStaff() {
        return usernameStaff;
    }

    public void setUsernameStaff(String usernameStaff) {
        this.usernameStaff = usernameStaff;
    }

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    @Override
    public String toString() {
        return "orders{" + "orderID=" + orderID + ", address=" + address + ", date=" + date + ", status=" + status + ", phoneNumber=" + phoneNumber + ", usernameCustomer=" + usernameCustomer + ", usernameStaff=" + usernameStaff + ", total=" + total + '}';
    }
    
}
