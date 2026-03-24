package vn.xuandat.Warehouse_management.entity;

import java.util.List;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "materials")
@Setter
@Getter
public class Material {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String name;
    private String unit;
    // private double basePrice;

    @OneToMany(mappedBy = "material")
    private List<ImportDetail> importDetails;
    
    @OneToMany(mappedBy = "material")
    private List<ExportDetail> exportDetails;

    @ManyToOne
    @JoinColumn(name = "category_id")
    private Category category;
}
