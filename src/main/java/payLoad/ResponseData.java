package payLoad;

public class ResponseData {

    private boolean isSuccess;
    private String description;
    private Object data;

    /**
     * Hàm khởi tạo rỗng (no-argument constructor)
     * Trình biên dịch yêu cầu hàm này.
     */
    public ResponseData() {
    }

    /**
     * Hàm khởi tạo 3 tham số
     * Đây là hàm mà StaffController đang cố gắng gọi.
     */
    public ResponseData(boolean isSuccess, String description, Object data) {
        this.isSuccess = isSuccess;
        this.description = description;
        this.data = data;
    }

    // Getters and Setters
    public boolean getIsSuccess() {
        return isSuccess;
    }

    public void setIsSuccess(boolean isSuccess) {
        this.isSuccess = isSuccess;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }
}