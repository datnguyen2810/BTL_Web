package vn.xuandat.Warehouse_management.controller;

import java.util.List;

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
                                    @RequestParam(name="categoryId", required = false) Long categoryId, Model model) {
        List<InventoryDTO> report = this.materialService.getInventoryReport(keyword, categoryId);

        // Xử lý logic gán trạng thái (Sắp hết hàng/Còn hàng)
        for(InventoryDTO item : report){
            long stock = item.getTotalImport() - item.getTotalExport();
            item.setStock(stock);
            if(stock == 0) item.setStatus("Hết hàng");
            else if(stock < 10) item.setStatus("Sắp hết hàng");
            else item.setStatus("Còn hàng");
        }

        model.addAttribute("inventoryReport", report);
        model.addAttribute("categories", this.categoryService.handleGetAllCategories());
        return "admin/inventory-report";
    }




}
