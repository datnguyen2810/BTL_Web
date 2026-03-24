package vn.xuandat.Warehouse_management.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name="import_details")
@Getter
@Setter
public class ImportDetail {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private long import_quantity;
    private double import_price;

    @ManyToOne
    @JoinColumn(name = "import_id")
    private Import importEntity;

    @ManyToOne
    @JoinColumn(name = "material_id")
    private Material material;

    


    
}
