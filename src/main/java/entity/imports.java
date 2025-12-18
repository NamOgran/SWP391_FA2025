package entity;

import java.util.Date;

public class Imports {

    private int quantity, total, id, staff_id;
    private String status;
    private Date date;

    // === 1. THÊM THUỘC TÍNH NÀY ===
    private String username;

    public Imports() {
    }

    // === 2. CẬP NHẬT CONSTRUCTOR NÀY (Thêm String username vào cuối) ===
    public Imports(int id, int quantity, int total, int staff_id, String status, Date date, String username) {
        this.id = id;
        this.quantity = quantity;
        this.total = total;
        this.staff_id = staff_id;
        this.status = status;
        this.date = date;
        this.username = username; // Gán giá trị
    }

    // Constructor cũ (dùng cho việc Insert) giữ nguyên cũng được
    public Imports(int id, int quantity, int total, int staff_id, String status, Date date) {
        this.id = id;
        this.quantity = quantity;
        this.total = total;
        this.staff_id = staff_id;
        this.status = status;
        this.date = date;
    }

    // === 3. THÊM GETTER VÀ SETTER CHO USERNAME ===
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    // ... (Các getter/setter cũ giữ nguyên) ...
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

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    public int getStaff_id() {
        return staff_id;
    }

    public void setStaff_id(int staff_id) {
        this.staff_id = staff_id;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }
}
