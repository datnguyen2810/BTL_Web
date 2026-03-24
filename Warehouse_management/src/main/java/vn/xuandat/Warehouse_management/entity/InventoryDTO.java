package vn.xuandat.Warehouse_management.entity;


public class InventoryDTO {
    private Long materialId;
    private String materialName;
    private String unit;
    private Long totalImport;
    private Long totalExport;
    private Long stock;
    private String status;

    public InventoryDTO() {
    }

    // Hibernate cần Constructor này
    public InventoryDTO(Long materialId, String materialName, String unit, Long totalImport, Long totalExport) {
        this.materialId = materialId;
        this.materialName = materialName;
        this.unit = unit;
        this.totalImport = totalImport;
        this.totalExport = totalExport;
    }
    
    public Long getMaterialId() {
        return materialId;
    }

    public void setMaterialId(Long materialId) {
        this.materialId = materialId;
    }

    public String getMaterialName() {
        return materialName;
    }

    public void setMaterialName(String materialName) {
        this.materialName = materialName;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public Long getTotalImport() {
        return totalImport;
    }

    public void setTotalImport(Long totalImport) {
        this.totalImport = totalImport;
    }

    public Long getTotalExport() {
        return totalExport;
    }

    public void setTotalExport(Long totalExport) {
        this.totalExport = totalExport;
    }

    public Long getStock() {
        return stock;
    }

    public void setStock(Long stock) {
        this.stock = stock;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }


}
