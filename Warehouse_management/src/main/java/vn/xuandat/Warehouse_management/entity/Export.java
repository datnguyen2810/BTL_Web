package vn.xuandat.Warehouse_management.entity;


import java.time.LocalDateTime;
import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;
import lombok.Setter;

@Entity
@Table(name = "exports")
@Setter
public class Export {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(unique = true, nullable = false)
    private String code;
    private LocalDateTime date;
    private double totalAmount;

    @Transient
    private long totalItems;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User userExport;

    @OneToMany(mappedBy="exportEntity", cascade = CascadeType.REMOVE, orphanRemoval = true)
    private List<ExportDetail> exportDetails;

    public Long getId() {
        return id;
    }

    public String getDate() {
        String tmp = date.toString().substring(0, 10);
        String[] parts = tmp.split("-");
        return parts[2] + "/" + parts[1] + "/" + parts[0];
    }

    public String getTotalAmount() {
        return String.format("%,.0f", totalAmount);
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public User getUserExport() {
        return userExport;
    }

    public List<ExportDetail> getExportDetails() {
        return exportDetails;
    }

    public long getTotalItems() {
        return totalItems;
    }

    public void setTotalItems(long totalItems) {
        this.totalItems = totalItems;
    }
    


}