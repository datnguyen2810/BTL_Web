package vn.xuandat.Warehouse_management.service;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import vn.xuandat.Warehouse_management.entity.Category;
import vn.xuandat.Warehouse_management.repository.CategoryRepository;
import vn.xuandat.Warehouse_management.repository.MaterialRepository;

@Service
public class CategoryService {
    private final CategoryRepository categoryRepository;
    private final MaterialRepository materialRepository;

    public CategoryService(CategoryRepository categoryRepository, MaterialRepository materialRepository) {
        this.categoryRepository = categoryRepository;
        this.materialRepository = materialRepository;
    }

    public Page<Category> getPagedCategories(String keyword, Pageable pageable) {
        if(keyword != null && keyword.trim().isEmpty()){
            keyword = null;
        }
        return categoryRepository.searchCategories(keyword, pageable);
    }

    public List<Category> handleGetAllCategories() {
       return this.categoryRepository.findAll();
    }

    public void handleDeleteCategoryById(Long id) {
        long count = this.materialRepository.countByCategoryId(id);
        if(count > 0){
            throw new RuntimeException("Không thể xóa! Danh mục này đang chứa " + count + " vật tư.");
        }
        this.categoryRepository.deleteById(id);
    }

    public void handleSaveCategory(Category newCategory) {
        this.categoryRepository.save(newCategory);
    }

    public Category findCategoryById(Long id) {
        return this.categoryRepository.findById(id).orElse(null);
    }


}
