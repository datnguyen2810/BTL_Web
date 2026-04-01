package vn.xuandat.Warehouse_management.controller;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
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
                            @RequestParam(name="exportCode", required=false) String exportCode, 
                            @RequestParam(name="page", defaultValue="0") int page,
                            Model model) {
        int pageSize = 5;
        Pageable pageable = PageRequest.of(page, pageSize);
        Page<Export> exportPage = this.exportService.getPagedExport(userId, exportCode, pageable);
        if (page < 0 || page >= exportPage.getTotalPages() && exportPage.getTotalPages() > 0) {
            return "redirect:/admin/exports?page=0";      
        }
        model.addAttribute("exports", exportPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", exportPage.getTotalPages());
 
        model.addAttribute("users", this.userService.handleGetAllUsers());
        model.addAttribute("selectedUserId", userId);
        return "admin/export/show-exports";
    }


    @GetMapping("/admin/exports/create")
    public String showCreateForm(HttpSession session, Model model){
        model.addAttribute("materials", this.materialService.handleGetAllMaterials());

        // Quản lý danh sách tạm trong session
        List<ExportDetail> tempList = (List<ExportDetail>) session.getAttribute("tempExportList");
        if(tempList == null){
            tempList = new ArrayList<>();
            session.setAttribute("tempExportList", tempList);
        }

        // Tính tổng tiền tạm tính để hiển thị ra view
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
                                @RequestParam(name="quantity") Long quantity,
                                @RequestParam(name="price") double price,
                                HttpSession session, RedirectAttributes ra) {
        // 1. Lấy danh sách tạm từ Session
        List<ExportDetail> tempList = (List<ExportDetail>) session.getAttribute("tempExportList");
        if (tempList == null) tempList = new ArrayList<>();

        // 2. Lấy tồn kho thực tế từ Database
        long currentStock = materialService.calculateCurrentStock(materialId);
        Material material = materialService.handleGetMaterialById(materialId);

        // 3. Tìm xem vật tư này đã có trong danh sách tạm chưa
        ExportDetail existingDetail = null;
        for (ExportDetail d : tempList) {
            if (d.getMaterial().getId().equals(materialId)) {
                existingDetail = d;
                break;
            }
        }

        // 4. Kiểm tra tổng số lượng sau khi gộp
        long totalAfterAdd = quantity;
        if (existingDetail != null) {
            totalAfterAdd += existingDetail.getExport_quantity();
        }

        if (totalAfterAdd > currentStock) {
            ra.addFlashAttribute("stockError", "Tổng lượng xuất vượt quá tồn kho hiện tại (" 
                                + currentStock + " " + material.getUnit() + ").");
            return "redirect:/admin/exports/create";
        }

        // 5. Thực hiện Gộp hoặc Thêm mới
        if (existingDetail != null) {
            // Nếu đã có: Cập nhật số lượng mới và đơn giá mới
            existingDetail.setExport_quantity(totalAfterAdd);
            existingDetail.setExport_price(price);
        } 
        else {
            // Nếu chưa có: Tạo mới 
            ExportDetail detail = new ExportDetail();
            detail.setMaterial(material);
            detail.setExport_quantity(quantity);
            detail.setExport_price(price);  
            tempList.add(detail);
        }

        // 6. Cập nhật lại session
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

    @GetMapping("/admin/exports/cancel")
    public String cancel(HttpSession session) {
        session.removeAttribute("tempExportList");
        session.removeAttribute("exportCode");
        return "redirect:/admin/exports";
    }


    @PostMapping("/admin/exports/save-final")
    public String saveFinalExport(HttpSession session, 
                                  @RequestParam String exportCode,
                                  RedirectAttributes ra) {

        if(exportService.isCodeExists(exportCode)){
            ra.addFlashAttribute("error", "Mã phiếu '" + exportCode + "' đã tồn tại trên hệ thống!");
            // Lưu lại mã phiếu vào session để hiển thị lại trên input, tránh bắt user gõ lại
            session.setAttribute("exportCode", exportCode); 
            return "redirect:/admin/exports/create";
        }

        List<ExportDetail> tempList = (List<ExportDetail>) session.getAttribute("tempExportList");

        if(tempList != null && !tempList.isEmpty()){
            this.exportService.handleSaveFinalExport(tempList, exportCode);
        }
        session.removeAttribute("tempExportList"); // Xóa danh sách tạm sau khi lưu
        return "redirect:/admin/exports";
    }

    // chi tiết phiếu xuất
    @GetMapping("/admin/exports/{id}")
    public String getExportDetail(Model model, @PathVariable Long id) {
        Export exportTicket = this.exportService.handleGetExportById(id);
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
