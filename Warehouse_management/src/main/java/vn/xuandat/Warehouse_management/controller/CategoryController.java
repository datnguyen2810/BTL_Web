package vn.xuandat.Warehouse_management.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;

import vn.xuandat.Warehouse_management.entity.Category;
import vn.xuandat.Warehouse_management.service.CategoryService;


@Controller
public class CategoryController {
    private final CategoryService categoryService;
    public CategoryController(CategoryService categoryService) {
        this.categoryService = categoryService;
    }
    
    @GetMapping("/admin/categories")
    public String getAllCategories(Model model){
        List<Category> categories = this.categoryService.handleGetAllCategories();
        model.addAttribute("categories", categories);
        return "admin/category/show-categories";
    }

    @GetMapping("/admin/categories/delete/{id}")
    public String deleteCategory(@PathVariable Long id) {
        this.categoryService.handleDeleteCategoryById(id);
        return "redirect:/admin/categories";
    }

    @GetMapping("/admin/categories/create")
    public String createCategory(Model model){
        Category newCategory = new Category();
        model.addAttribute("newCategory", newCategory);
        return "admin/category/create-category";
    }

    @PostMapping("/admin/categories/create")
    public String postCreateCategory(@ModelAttribute("newCategory") Category newCategory) {
        this.categoryService.handleSaveCategory(newCategory);
        return "redirect:/admin/categories";
    }

    @GetMapping("/admin/categories/update/{id}")
    public String updateCategory(Model model, @PathVariable Long id){
        Category categoryDB = this.categoryService.findCategoryById(id);
        model.addAttribute("categoryDB", categoryDB);
        return "admin/category/update-category";
    }

    @PostMapping("/admin/categories/update")
    public String postUpdateCategory(@ModelAttribute("categoryDB") Category newCategory){
        this.categoryService.handleSaveCategory(newCategory);
        return "redirect:/admin/categories";
    }
    
}
