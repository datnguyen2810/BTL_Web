package vn.xuandat.Warehouse_management.entity;


import java.time.LocalDateTime;
import java.util.List;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;

@Entity
@Table(name = "imports")

public class Import {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private LocalDateTime date;
    private double totalAmount;

    // @PrePersist
    // protected void onCreate() {
    //     this.date = LocalDateTime.now(); // Tự động lấy giờ hiện tại khi lưu vào DB
    // }


    public Import(){
    }

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User userImport;

    @OneToMany(mappedBy="importEntity")
    private List<ImportDetail> importDetails;

    
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getDate() {
        String tmp = date.toString().substring(0, 10);
        String[] parts = tmp.split("-");
        return parts[2] + "/" + parts[1] + "/" + parts[0];
    }

    public void setDate(LocalDateTime date) {
        this.date = date;
    }

    public String getTotalAmount() {
        String s = String.format("%,.0f", totalAmount);
        return s;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public User getUserImport() {
        return userImport;
    }

    public void setUserImport(User userImport) {
        this.userImport = userImport;
    }

    public List<ImportDetail> getImportDetails() {
        return importDetails;
    }

    public void setImportDetails(List<ImportDetail> importDetails) {
        this.importDetails = importDetails;
    }

    
}