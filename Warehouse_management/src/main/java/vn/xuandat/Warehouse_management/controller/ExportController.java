package vn.xuandat.Warehouse_management.controller;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import vn.xuandat.Warehouse_management.entity.Export;
import vn.xuandat.Warehouse_management.entity.ExportDetail;
import vn.xuandat.Warehouse_management.entity.Material;
import vn.xuandat.Warehouse_management.service.ExportService;
import vn.xuandat.Warehouse_management.service.MaterialService;
import vn.xuandat.Warehouse_management.service.UserService;

@Controller
public class ExportController {
    private final MaterialService materialService;
    private final ExportService exportService;
    private final UserService userService;
    public ExportController(ExportService exportService, UserService userService, MaterialService materialService) {
        this.exportService = exportService;
        this.userService = userService;
        this.materialService = materialService;
    }

    @GetMapping("/admin/exports")
    public String getExports(@RequestParam(name="userId", required=false) Long userId, 
                            @RequestParam(name="exportId", required=false) Long exportId, Model model) {
        List<Export> exports = this.exportService.searchExports(userId, exportId);
        model.addAttribute("exports", exports);
        model.addAttribute("users", this.userService.handleGetAllUsers());
        model.addAttribute("selectedUserId", userId);
        return "admin/export/show-exports";
    }


    @GetMapping("/admin/exports/create")
    public String showCreateForm(HttpSession session, Model model){
        model.addAttribute("materials", this.materialService.handleGetAllMaterials());

        // 2. Quản lý danh sách tạm trong session
        List<ExportDetail> tempList = (List<ExportDetail>) session.getAttribute("tempExportList");
        if(tempList == null){
            tempList = new ArrayList<>();
            session.setAttribute("tempExportList", tempList);
        }

        // 3. Tính tổng tiền tạm tính để hiển thị ra view
        double grandTotal = tempList.stream()
                .mapToDouble(item -> item.getExport_price() * item.getExport_quantity()).sum();
        model.addAttribute("grandTotal", grandTotal);

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        model.addAttribute("displayDate", LocalDateTime.now().format(formatter));
        model.addAttribute("tempList", tempList);
        model.addAttribute("grandTotal", grandTotal);
        return "admin/export/create-export";
    }

    @PostMapping("/admin/exports/add-temp")
    public String addTempExport(@RequestParam(name="materialId") Long materialId, 
                                @RequestParam(name="quantity") int quantity,
                                @RequestParam(name="price") double price,
                                HttpSession session, RedirectAttributes ra) {
        // 1. Lấy tồn kho thực tế từ Database
        long currentStock = materialService.calculateCurrentStock(materialId);
        
        // 2. Lấy danh sách tạm hiện tại từ Session
        List<ExportDetail> temp = (List<ExportDetail>) session.getAttribute("tempExportList");
        if(temp == null) temp = new ArrayList<>();

        // 3. Tính tổng số lượng đã thêm vào tempList cho vật tư này
         long quantityInSession = temp.stream()
                .filter(it -> it.getMaterial().getId().equals(materialId))
                .mapToLong(it -> it.getExport_quantity()).sum();                     

        Material material = materialService.handleGetMaterialById(materialId);
        if (quantity + quantityInSession > currentStock) {
            ra.addFlashAttribute("stockError", "Số lượng xuất vượt quá tồn kho hiện tại (" + currentStock + " " + material.getUnit() + ").");
            return "redirect:/admin/exports/create";
        }

        // 4. Lấy danh sách tạm từ session
        List<ExportDetail> tempList = (List<ExportDetail>) session.getAttribute("tempExportList");
        if(tempList == null){
            tempList = new ArrayList<>();
        }
        // 5. Tạo ExportDetail tạm và thêm vào danh sách
        ExportDetail detail = new ExportDetail();
        detail.setMaterial(this.materialService.handleGetMaterialById(materialId));
        detail.setExport_quantity(quantity);
        detail.setExport_price(price);
        tempList.add(detail);

        // 6. Lưu lại danh sách tạm vào session
        session.setAttribute("tempExportList", tempList);
        return "redirect:/admin/exports/create";
    }

    @GetMapping("/admin/exports/remove-temp/{index}")
    public String removeTempExport(@PathVariable int index, HttpSession session){
        List<ExportDetail> tempList = (List<ExportDetail>) session.getAttribute("tempExportList");
        if(tempList != null && index >= 0 && index < tempList.size()){
            tempList.remove(index);
            session.setAttribute("tempExportList", tempList);
        }
        return "redirect:/admin/exports/create";
    }


    @PostMapping("/admin/exports/save-final")
    public String saveFinalExport(HttpSession session){
        List<ExportDetail> tempList = (List<ExportDetail>) session.getAttribute("tempExportList");

        if(tempList != null && !tempList.isEmpty()){
            this.exportService.handleSaveFinalExport(tempList);
        }
        session.removeAttribute("tempExportList"); // Xóa danh sách tạm sau khi lưu
        return "redirect:/admin/exports";
    }

    // chi tiết phiếu xuất
    @GetMapping("/admin/exports/{id}")
    public String getExportDetail(Model model, @PathVariable Long id) {
        // 1. Lấy thông tin phiếu xuất từ Service
        Export exportTicket = this.exportService.handleGetExportById(id);
        
        // 2. Gửi dữ liệu sang JSP
        model.addAttribute("exportTicket", exportTicket);
        // Danh sách chi tiết vật tư của phiếu đó
        model.addAttribute("details", exportTicket.getExportDetails()); 
        
        return "admin/export/detail-export";
    }

    // xóa phiếu
    @GetMapping("/admin/exports/delete/{id}")
    public String deleteExport(@PathVariable Long id, RedirectAttributes ra){
        try {
            this.exportService.handleDeleteExport(id);
        } catch (Exception e) {
            ra.addFlashAttribute("deleteError", "Không thể xóa phiếu xuất này do có liên quan đến dữ liệu khác.");
        }
        return "redirect:/admin/exports";
    }


}
