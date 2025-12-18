package entity;

import java.util.Date;

public class Voucher {

    private String voucherID;
    private int voucherPercent;
    private Date startDate;
    private Date endDate;
    // [MỚI] Thêm thuộc tính này
    private int maxDiscountAmount;

    public Voucher() {
    }

    // Cập nhật Constructor
    public Voucher(String voucherID, int voucherPercent, Date startDate, Date endDate, int maxDiscountAmount) {
        this.voucherID = voucherID;
        this.voucherPercent = voucherPercent;
        this.startDate = startDate;
        this.endDate = endDate;
        this.maxDiscountAmount = maxDiscountAmount;
    }

    // Giữ lại constructor cũ nếu cần (để tránh lỗi code cũ), hoặc gán max = 0 mặc định
    public Voucher(String voucherID, int voucherPercent, Date startDate, Date endDate) {
        this(voucherID, voucherPercent, startDate, endDate, 0);
    }

    // [MỚI] Getter & Setter
    public int getMaxDiscountAmount() {
        return maxDiscountAmount;
    }

    public void setMaxDiscountAmount(int maxDiscountAmount) {
        this.maxDiscountAmount = maxDiscountAmount;
    }

    // ... (Các Getter/Setter cũ giữ nguyên)
    public String getVoucherID() {
        return voucherID;
    }

    public void setVoucherID(String voucherID) {
        this.voucherID = voucherID;
    }

    public int getVoucherPercent() {
        return voucherPercent;
    }

    public void setVoucherPercent(int voucherPercent) {
        this.voucherPercent = voucherPercent;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }
}
