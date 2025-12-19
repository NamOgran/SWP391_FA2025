package entity;

public class Cart {

    private int cart_id;
    private int customer_id;
    private int product_id;
    private int quantity;
    private int price;      // INT, khớp DB
    private String size_name;
    private int stockQuantity;

    public Cart() {
    }

    // Constructor đầy đủ (MỚI) - 7 tham số
    public Cart(int cart_id, int customer_id, int product_id,
            int quantity, int price, String size_name, int stockQuantity) {
        this.cart_id = cart_id;
        this.customer_id = customer_id;
        this.product_id = product_id;
        this.quantity = quantity;
        this.price = price;
        this.size_name = size_name;
        this.stockQuantity = stockQuantity;
    }

    // GỘP LOGIC: gọi lại constructor trên, tự set stockQuantity = 0
    public Cart(int cart_id, int customer_id, int product_id,
            int quantity, int price, String size_name) {
        this(cart_id, customer_id, product_id, quantity, price, size_name, 0);
    }

    // Getters & Setters
    public int getCartID() {
        return cart_id;
    }

    public void setCartID(int cart_id) {
        this.cart_id = cart_id;
    }

    public int getCustomer_id() {
        return customer_id;
    }

    public void setCustomer_id(int customer_id) {
        this.customer_id = customer_id;
    }

    public int getProductID() {
        return product_id;
    }

    public void setProductID(int product_id) {
        this.product_id = product_id;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public String getSize_name() {
        return size_name;
    }

    public void setSize_name(String size_name) {
        this.size_name = size_name;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    @Override
    public String toString() {
        return "Cart{"
                + "cart_id=" + cart_id
                + ", customer_id=" + customer_id
                + ", product_id=" + product_id
                + ", quantity=" + quantity
                + ", price=" + price
                + ", size_name=" + size_name
                + ", stock=" + stockQuantity
                + '}';
    }
}
