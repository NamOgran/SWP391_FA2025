package entity;

public class Size_detail {
    private String size_name;
    private int product_id;
    private int quantity;

    public Size_detail() {
    }

    public Size_detail(String size_name, int product_id, int quantity) {
        this.size_name = size_name;
        this.product_id = product_id;
        this.quantity = quantity;
    }

    public String getSize_name() { return size_name; }
    public void setSize_name(String size_name) { this.size_name = size_name; }
    public int getProduct_id() { return product_id; }
    public void setProduct_id(int product_id) { this.product_id = product_id; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    @Override
    public String toString() {
        return "Size_detail{" + "size_name=" + size_name + ", product_id=" + product_id + ", quantity=" + quantity + '}';
    }
}