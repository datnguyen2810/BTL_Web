package vn.xuandat.Warehouse_management.controller;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import vn.xuandat.Warehouse_management.entity.InventoryDTO;
import vn.xuandat.Warehouse_management.service.CategoryService;
import vn.xuandat.Warehouse_management.service.MaterialService;

@Controller
public class InventoryReportController {
    private final MaterialService materialService;
    private final CategoryService categoryService;
    
    public InventoryReportController(MaterialService materialService, CategoryService categoryService) {
        this.materialService = materialService;
        this.categoryService = categoryService;
    }

    @GetMapping("/admin/inventory-report")
    public String showInventoryReport(@RequestParam(name="keyword", required = false) String keyword, 
                                    @RequestParam(name="categoryId", required = false) Long categoryId, 
                                    @RequestParam(name="page", defaultValue = "0") int page,
                                    Model model) {
        int pageSize = 5;
        Pageable pageable = PageRequest.of(page, pageSize);
        Page<InventoryDTO> reportPage = this.materialService.getPagedInventoryReport(keyword, categoryId, pageable);
        if (page < 0 || page >= reportPage.getTotalPages() && reportPage.getTotalPages() > 0) {
            return "redirect:/admin/inventory-report?page=0";      
        }
        // Xử lý logic gán trạng thái (Sắp hết hàng/Còn hàng)
        for(InventoryDTO item : reportPage){
            long stock = item.getTotalImport() - item.getTotalExport();
            item.setStock(stock);
            if(stock == 0) item.setStatus("Hết hàng");
            else if(stock < 10) item.setStatus("Sắp hết hàng");
            else item.setStatus("Còn hàng");
        }

        model.addAttribute("inventoryReport", reportPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", reportPage.getTotalPages());
    
        model.addAttribute("categories", this.categoryService.handleGetAllCategories());
        model.addAttribute("selectedCategoryId", categoryId);
        return "admin/inventory-report";
    }




}
