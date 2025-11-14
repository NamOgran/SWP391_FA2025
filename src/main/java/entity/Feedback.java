package entity;

public class Feedback {
    private int feedback_id;
    private String content;
    private int rate_point;
    private int customer_id;
    private int product_id;

    // Constructors, Getters và Setters
    public Feedback() {}

    public Feedback(int feedback_id, String content, int rate_point, int customer_id, int product_id) {
        this.feedback_id = feedback_id;
        this.content = content;
        this.rate_point = rate_point;
        this.customer_id = customer_id;
        this.product_id = product_id;
    }

    public int getFeedback_id() {
        return feedback_id;
    }

    public void setFeedback_id(int feedback_id) {
        this.feedback_id = feedback_id;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public int getRate_point() {
        return rate_point;
    }

    public void setRate_point(int rate_point) {
        this.rate_point = rate_point;
    }

    public int getCustomer_id() {
        return customer_id;
    }

    public void setCustomer_id(int customer_id) {
        this.customer_id = customer_id;
    }

    public int getProduct_id() {
        return product_id;
    }

    public void setProduct_id(int product_id) {
        this.product_id = product_id;
    }
    

}