package vn.xuandat.Warehouse_management.controller;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import vn.xuandat.Warehouse_management.entity.Category;
import vn.xuandat.Warehouse_management.service.CategoryService;
import vn.xuandat.Warehouse_management.service.MaterialService;


@Controller
public class CategoryController {
    private final CategoryService categoryService;
    private final MaterialService materialService;
    public CategoryController(CategoryService categoryService, MaterialService materialService) {
        this.categoryService = categoryService;
        this.materialService = materialService;
    }
    
    @GetMapping("/admin/categories")
    public String getCategoriesPage(Model model, 
                                    @RequestParam(defaultValue = "0") int page,
                                    @RequestParam(required = false) String keyword) {
        int pageSize = 5;
        // page: chỉ số bắt đầu từ 0, pageSize: số dòng trên mỗi trang
        Pageable pageable = PageRequest.of(page, pageSize);
        Page<Category> categoryPage = categoryService.getPagedCategories(keyword, pageable);
        if (page < 0 || page >= categoryPage.getTotalPages() && categoryPage.getTotalPages() > 0) {
            return "redirect:/admin/categories?page=0";      
        }

        model.addAttribute("categories", categoryPage.getContent());
        model.addAttribute("currentPage", page); 
        model.addAttribute("totalPages", categoryPage.getTotalPages());
        return "admin/category/show-categories";
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
    
    @GetMapping("/admin/categories/delete/{id}")
    public String deleteCategory(@PathVariable Long id, RedirectAttributes ra) {
        try {
            this.categoryService.handleDeleteCategoryById(id);
            ra.addFlashAttribute("message", "Xóa danh mục thành công!");
        } catch (RuntimeException e) {
            ra.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/admin/categories";
    }
}
