package vn.xuandat.Warehouse_management.service;

import java.util.List;

import org.springframework.stereotype.Service;

import vn.xuandat.Warehouse_management.entity.Category;
import vn.xuandat.Warehouse_management.repository.CategoryRepository;

@Service
public class CategoryService {
    private final CategoryRepository categoryRepository;
    public CategoryService(CategoryRepository categoryRepository) {
        this.categoryRepository = categoryRepository;
    }

    public List<Category> handleGetAllCategories() {
       return this.categoryRepository.findAll();
    }

    public void handleDeleteCategoryById(Long id) {
        this.categoryRepository.deleteById(id);
    }

    public void handleSaveCategory(Category newCategory) {
        this.categoryRepository.save(newCategory);
    }

    public Category findCategoryById(Long id) {
        return this.categoryRepository.findById(id).orElse(null);
    }


}
