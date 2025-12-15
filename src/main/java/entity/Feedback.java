package entity;
import java.sql.Timestamp;

public class Feedback {
    private int feedbackId;
    private int customerId;
    private int productId;
    private int orderId; // [MỚI]
    private int ratePoint;
    private String content;
    private Timestamp createdAt;
    private String customerName; // [MỚI] Dùng để hiển thị tên người đánh giá

    public Feedback() {}

    public int getFeedbackId() { return feedbackId; }
    public void setFeedbackId(int feedbackId) { this.feedbackId = feedbackId; }
    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    public int getRatePoint() { return ratePoint; }
    public void setRatePoint(int ratePoint) { this.ratePoint = ratePoint; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }
}