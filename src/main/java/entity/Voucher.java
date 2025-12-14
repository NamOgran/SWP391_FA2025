/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

import java.util.Date;

/**
 *
 * 
 */
public class Voucher {
    int voucherID;
    int voucherPercent;
    Date startDate;
    Date endDate;

    public Voucher(int voucherID, int voucherPercent, Date startDate, Date endDate) {
        this.voucherID = voucherID;
        this.voucherPercent = voucherPercent;
        this.startDate = startDate;
        this.endDate = endDate;
    }

    public int getVoucherID() {
        return voucherID;
    }

    public void setVoucherID(int voucherID) {
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
