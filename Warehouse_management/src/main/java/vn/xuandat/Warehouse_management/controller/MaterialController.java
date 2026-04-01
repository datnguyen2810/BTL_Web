package vn.xuandat.Warehouse_management.controller;

import java.util.List;

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
import vn.xuandat.Warehouse_management.entity.Material;
import vn.xuandat.Warehouse_management.service.CategoryService;
import vn.xuandat.Warehouse_management.service.MaterialService;

@Controller
public class MaterialController {
    private final MaterialService materialService;
    private final CategoryService categoryService;

    public MaterialController(MaterialService materialService, CategoryService categoryService) {
        this.materialService = materialService;
        this.categoryService = categoryService;
    }
    
    @GetMapping("/admin/materials")
    public String getMaterials(
        @RequestParam(name="categoryId", required = false) Long categoryId, 
        @RequestParam(name="keyword", required = false) String keyword,
        @RequestParam(name="page", defaultValue = "0") int page,
        Model model) {
    
        int pageSize = 5; // Số bản ghi mỗi trang
        Pageable pageable = PageRequest.of(page, pageSize); // chỉ truy vấn đúng số bản ghi cần thiết cho trang hiện tại
        
        // Gọi Service trả về Page thay vì List
        Page<Material> materialPage = this.materialService.getPagedMaterials(categoryId, keyword, pageable);
        if (page < 0 || page >= materialPage.getTotalPages() && materialPage.getTotalPages() > 0) {
            return "redirect:/admin/materials?page=0";      
        }
        
        model.addAttribute("materials", materialPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", materialPage.getTotalPages());
        
        model.addAttribute("categories", this.categoryService.handleGetAllCategories());
        model.addAttribute("selectedCategoryId", categoryId);      
        return "admin/material/show-materials";
    }


    @GetMapping("/admin/materials/create")
    public String createMaterial(Model model){
        Material newMaterial = new Material();
        model.addAttribute("material", newMaterial);
        model.addAttribute("categories", this.categoryService.handleGetAllCategories());
        return "admin/material/create-material";
    }

    @PostMapping("/admin/materials/create")
    public String postCreateMaterial(@ModelAttribute("material") Material material){
        this.materialService.handleSaveMaterial(material);
        return "redirect:/admin/materials";
    }

    @GetMapping("/admin/materials/update/{id}")
    public String updateMaterial(Model model, @PathVariable Long id){
        Material materialDB = this.materialService.handleGetMaterialById(id);
        List<Category> categories = this.categoryService.handleGetAllCategories();
        model.addAttribute("materialDB", materialDB);
        model.addAttribute("categories", categories);
        return "admin/material/update-material";
    }

    @PostMapping("/admin/materials/update")
    public String postUpdateMaterial(@ModelAttribute("materialDB") Material material){
        this.materialService.handleSaveMaterial(material);
        return "redirect:/admin/materials";
    }

    @GetMapping("/admin/materials/delete/{id}")
    public String deleteMaterial(@PathVariable Long id, RedirectAttributes ra) {
        try {
            this.materialService.handleDeleteMaterialById(id);
            ra.addFlashAttribute("message", "Xóa nguyên vật liệu thành công!");
        } catch (RuntimeException e) {
            ra.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/admin/materials";
    }


}
