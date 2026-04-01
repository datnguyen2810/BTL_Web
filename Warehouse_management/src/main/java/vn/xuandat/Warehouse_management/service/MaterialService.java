package vn.xuandat.Warehouse_management.service;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import vn.xuandat.Warehouse_management.entity.InventoryDTO;
import vn.xuandat.Warehouse_management.entity.Material;
import vn.xuandat.Warehouse_management.repository.ExportDetailRepository;
import vn.xuandat.Warehouse_management.repository.ImportDetailRepository;
import vn.xuandat.Warehouse_management.repository.MaterialRepository;

@Service
public class MaterialService {
    private final MaterialRepository materialRepository;
    private final ImportDetailRepository importDetailRepository;
    private final ExportDetailRepository exportDetailRepository;
    
    public MaterialService(MaterialRepository materialRepository, ImportDetailRepository importDetailRepository, ExportDetailRepository exportDetailRepository) {
        this.materialRepository = materialRepository;
        this.importDetailRepository = importDetailRepository;
        this.exportDetailRepository = exportDetailRepository;
    }

    public Page<Material> getPagedMaterials(Long categoryId, String keyword, Pageable pageable) {
        if(keyword != null && keyword.trim().isEmpty()) {
            keyword = null;
        }
        return materialRepository.getPagedMaterials(categoryId, keyword, pageable);
    }

    public List<Material> handleGetAllMaterials() {
        return this.materialRepository.findAll();
    }

    public void handleSaveMaterial(Material material) {
        this.materialRepository.save(material);
    }

    public Material handleGetMaterialById(Long id) {
        return this.materialRepository.findById(id).orElse(null);
    }

    public void handleDeleteMaterialById(Long id) {
        // 1. Kiểm tra xem vật tư này đã từng phát sinh giao dịch chưa
        boolean hasImport = importDetailRepository.existsByMaterialId(id);
        boolean hasExport = exportDetailRepository.existsByMaterialId(id);
        if (hasImport || hasExport) {
            throw new RuntimeException("Không thể xóa! Vật tư này đã có lịch sử Nhập/Xuất kho.");
        }

        // 2. Nếu chưa có giao dịch nào thì mới cho xóa
        materialRepository.deleteById(id);
    }

    public List<Material> findByCategoryId(Long categoryId) {
        return this.materialRepository.findByCategoryId(categoryId);
    }

    public long calculateCurrentStock(Long materialId) {
        return this.materialRepository.calculateCurrentStock(materialId);
    }

    public Page<InventoryDTO> getPagedInventoryReport(String keyword, Long categoryId, Pageable pageable) {
        if(keyword != null && keyword.trim().isEmpty()) {
            keyword = null;
        }
        return this.materialRepository.getPagedInventoryReport(keyword, categoryId, pageable);
    }


}
