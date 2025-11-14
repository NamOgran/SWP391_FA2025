/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

public class Customer {

    private int customer_id;
    private String username;
    private String email;
    private String password;
    private String address;
    private String phoneNumber;
    private String fullName;
    private String google_id;

    // Constructor đầy đủ (khi đọc từ DB)
    public Customer(int customer_id, String username, String email, String password,
            String address, String phoneNumber, String fullName, String google_id) {
        this.customer_id = customer_id;
        this.username = username;
        this.email = email;
        this.password = password;
        this.address = address;
        this.phoneNumber = phoneNumber;
        this.fullName = fullName;
        this.google_id = google_id;
    }

    // Constructor khi đăng ký (DB tự sinh customer_id)
    public Customer(String username, String email, String password,
            String address, String phoneNumber, String fullName, String google_id) {
        this.username = username;
        this.email = email;
        this.password = password;
        this.address = address;
        this.phoneNumber = phoneNumber;
        this.fullName = fullName;
        this.google_id = google_id;
    }

    // Getters & Setters
    public int getCustomer_id() {
        return customer_id;
    }

    public void setCustomer_id(int customer_id) {
        this.customer_id = customer_id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getGoogle_id() {
        return google_id;
    }

    public void setGoogle_id(String google_id) {
        this.google_id = google_id;
    }

    @Override
    public String toString() {
        return "Customer{" + "customer_id=" + customer_id + ", username=" + username
                + ", email=" + email + ", password=" + password + ", address=" + address
                + ", phoneNumber=" + phoneNumber + ", fullName=" + fullName
                + ", google_id=" + google_id + '}';
    }
}
