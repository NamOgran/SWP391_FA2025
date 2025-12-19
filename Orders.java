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
    private String voucherID; // [NEW] Added field

    private List<OrderDetail> orderDetails;

    public Orders() {
    }

    // Update Constructor to include voucherID
    public Orders(int orderID, String address, Date date, String status, String phoneNumber, int customer_id, int staff_id, int total, String voucherID) {
        this.order_id = orderID;
        this.address = address;
        this.date = date;
        this.status = status;
        this.phone_number = phoneNumber;
        this.customer_id = customer_id;
        this.staff_id = staff_id;
        this.total = total;
        this.voucherID = voucherID;
    }

    // [NEW] Getter & Setter
    public String getVoucherID() {
        return voucherID;
    }

    public void setVoucherID(String voucherID) {
        this.voucherID = voucherID;
    }

    // ... (Keep existing Getters/Setters for other fields)
    public int getOrderID() {
        return order_id;
    }

    public void setOrderID(int order_id) {
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

    public void setPhoneNumber(String phone_number) {
        this.phone_number = phone_number;
    }

    public int getCustomer_id() {
        return customer_id;
    }

    public void setCustomer_id(int customer_id) {
        this.customer_id = customer_id;
    }

    public int getStaff_id() {
        return staff_id;
    }

    public void setStaff_id(int staff_id) {
        this.staff_id = staff_id;
    }

    public float getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }
}
