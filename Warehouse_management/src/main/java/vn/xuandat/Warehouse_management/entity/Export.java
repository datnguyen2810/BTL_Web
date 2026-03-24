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
import lombok.Setter;

@Entity
@Table(name = "exports")
@Setter
public class Export {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private LocalDateTime date;
    private double totalAmount;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User userExport;

    @OneToMany(mappedBy="exportEntity")
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

    public User getUserExport() {
        return userExport;
    }

    public List<ExportDetail> getExportDetails() {
        return exportDetails;
    }


}