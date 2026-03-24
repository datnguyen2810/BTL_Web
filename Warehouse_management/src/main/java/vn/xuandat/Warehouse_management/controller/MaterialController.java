package vn.xuandat.Warehouse_management.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

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

    // @InitBinder
    // public void initBinder(WebDataBinder binder) {
    //     binder.registerCustomEditor(Category.class, new PropertyEditorSupport() {
    //         @Override
    //         public void setAsText(String text) {
    //             if (text == null || text.isEmpty()) {
    //                 setValue(null);
    //             } else {
    //                 setValue(categoryService.findCategoryById(Long.valueOf(text)));
    //             }
    //         }
    //     });
    // }

    // @GetMapping("/admin/materials")
    // public String getAllMaterials(Model model){
    //     List<Material> materials = this.materialService.handleGetAllMaterials();
    //     model.addAttribute("materials", materials);
    //     return "admin/material/show-material";
    // }

    // xử lý phần lọc 
    @GetMapping("/admin/materials")
    public String getMaterials(@RequestParam(name="categoryId", required = false) Long categoryId, 
                    @RequestParam(name="keyword", required = false) String keyword, Model model){
        List<Material> materials = this.materialService.searchMaterials(categoryId, keyword);
        model.addAttribute("materials", materials);
        model.addAttribute("categories", this.categoryService.handleGetAllCategories());
        model.addAttribute("selectedCategoryId", categoryId);
        // model.addAttribute("keyword", keyword);
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
    public String deleteMaterial(@PathVariable Long id) {
        this.materialService.handleDeleteMaterialById(id);
        return "redirect:/admin/materials";
    }


}
