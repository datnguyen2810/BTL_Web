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
@Table(name= "export_details")
@Setter
@Getter
public class ExportDetail {
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    private Long id;
    private int export_quantity;
    private double export_price;

    @ManyToOne
    @JoinColumn(name = "export_id")
    private Export exportEntity;

    @ManyToOne
    @JoinColumn(name = "material_id")
    private Material material;
}



