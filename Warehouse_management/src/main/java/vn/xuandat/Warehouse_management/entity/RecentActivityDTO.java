package vn.xuandat.Warehouse_management.entity;


public class RecentActivityDTO {
    private String id;       // Ví dụ: NK001, XK002
    private String type;     // "Nhập kho" hoặc "Xuất kho"
    private String userName; // Tên người thực hiện
    private String status;   // "Hoàn thành"
    private String date;

    // Constructor đầy đủ tham số
    public RecentActivityDTO(String id, String type, String userName, String status, String date) {
        this.id = id;
        this.type = type;
        this.userName = userName;
        this.status = status;
        this.date = date;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getDate2(){
        String[] parts = date.split("/");
        // return parts[2] + "-" + parts[1] + "-" + parts[0];
        return String.format("%04d/%02d/%02d", Integer.parseInt(parts[2]), Integer.parseInt(parts[1]), Integer.parseInt(parts[0]));
    }

    
}
