/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;
import java.util.Date;

public class Voucher {
    // [FIX] Đổi int -> String để khớp với DB varchar(50)
    String voucherID; 
    int voucherPercent;
    Date startDate;
    Date endDate;

    // Sửa Constructor
    public Voucher(String voucherID, int voucherPercent, Date startDate, Date endDate) {
        this.voucherID = voucherID;
        this.voucherPercent = voucherPercent;
        this.startDate = startDate;
        this.endDate = endDate;
    }

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



    @Override
    public String toString() {
        return "voucher{" + "voucherID=" + voucherID + ", voucherPercent=" + voucherPercent + ", startDate=" + startDate + ", endDate=" + endDate + '}';
    }
    
}
