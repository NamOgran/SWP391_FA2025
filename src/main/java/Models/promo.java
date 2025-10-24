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
public class promo {
    int promoID;
    int promoPercent;
    Date startDate;
    Date endDate;

    public promo(int promoID, int promoPercent, Date startDate, Date endDate) {
        this.promoID = promoID;
        this.promoPercent = promoPercent;
        this.startDate = startDate;
        this.endDate = endDate;
    }

    public int getPromoID() {
        return promoID;
    }

    public void setPromoID(int promoID) {
        this.promoID = promoID;
    }

    public int getPromoPercent() {
        return promoPercent;
    }

    public void setPromoPercent(int promoPercent) {
        this.promoPercent = promoPercent;
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
        return "promo{" + "promoID=" + promoID + ", promoPercent=" + promoPercent + ", startDate=" + startDate + ", endDate=" + endDate + '}';
    }
    
}
