package vn.xuandat.Warehouse_management.service;

import java.util.List;

import org.springframework.stereotype.Service;

import vn.xuandat.Warehouse_management.entity.InventoryDTO;
import vn.xuandat.Warehouse_management.entity.Material;
import vn.xuandat.Warehouse_management.repository.MaterialRepository;

@Service
public class MaterialService {
    private final MaterialRepository materialRepository;
    public MaterialService(MaterialRepository materialRepository) {
        this.materialRepository = materialRepository;
    }

    public List<Material> searchMaterials(Long categoryId, String keyword){
        if(keyword != null && keyword.trim().isEmpty()){
            keyword = null;
        }
        return this.materialRepository.searchMaterials(categoryId, keyword);
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
        this.materialRepository.deleteById(id);
    }

    public List<Material> findByCategoryId(Long categoryId) {
        return this.materialRepository.findByCategoryId(categoryId);
    }

    public long calculateCurrentStock(Long materialId) {
        return this.materialRepository.calculateCurrentStock(materialId);
    }

    public List<InventoryDTO> getInventoryReport(String keyword, Long categoryId) {
        return this.materialRepository.getInventoryReport(keyword, categoryId);
    }


}
