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

import jakarta.servlet.http.HttpSession;
import vn.xuandat.Warehouse_management.entity.Import;
import vn.xuandat.Warehouse_management.entity.ImportDetail;
import vn.xuandat.Warehouse_management.service.ImportService;
import vn.xuandat.Warehouse_management.service.MaterialService;
import vn.xuandat.Warehouse_management.service.UserService;


@Controller
public class ImportController {
    private final ImportService importService;
    private final UserService userService;
    private final MaterialService materialService;
    public ImportController(ImportService importService, UserService userService, MaterialService materialService) {
        this.importService = importService;
        this.userService = userService;
        this.materialService = materialService;
    }

    @GetMapping("/admin/imports")
    public String getImports(@RequestParam(name="userId", required = false) Long userId,
                            @RequestParam(name="importId", required = false) Long importId, Model model) {
        List<Import> imports = this.importService.searchImports(userId, importId);
        model.addAttribute("imports", imports);
        model.addAttribute("users", this.userService.handleGetAllUsers());
        model.addAttribute("selectedUserId", userId);
        return "admin/import/show-imports";
    }

    
    @GetMapping("/admin/imports/create")
    public String showCreateForm(HttpSession session, Model model) {
        // 1. Luôn nạp lại danh sách vật tư để hiển thị trong <select>
        model.addAttribute("materials", this.materialService.handleGetAllMaterials());

        // Quy trình hoạt động:
        // Lần đầu người dùng truy cập /admin/imports/create:
        // getAttribute() trả về null (chưa có dữ liệu)
        // Code tạo một ArrayList mới
        // Lưu nó vào session với setAttribute("tempImportList", tempList)
        // Lần thứ 2, 3, ...:
        // getAttribute() truy xuất danh sách đã lưu từ lần trước
        // 2. Quản lý danh sách tạm trong session
        List<ImportDetail> tempList = (List<ImportDetail>) session.getAttribute("tempImportList");
        if (tempList == null) {
            tempList = new ArrayList<>();
            session.setAttribute("tempImportList", tempList);
        }

        // 3. Tính tổng tiền tạm tính để hiển thị ra view
        double grandTotal = tempList.stream()
                .mapToDouble(item -> item.getImport_price() * item.getImport_quantity())
                .sum();

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        model.addAttribute("displayDate", LocalDateTime.now().format(formatter));
        model.addAttribute("tempList", tempList);
        model.addAttribute("grandTotal", grandTotal);
        
        return "admin/import/create-import";
    }

    @PostMapping("/admin/imports/add-temp")
    public String addTempItem(@RequestParam Long materialId, 
                              @RequestParam Long quantity, 
                              @RequestParam Double price, 
                              HttpSession session) {
        List<ImportDetail> tempList = (List<ImportDetail>) session.getAttribute("tempImportList");
        if (tempList == null) tempList = new ArrayList<>();

        ImportDetail detail = new ImportDetail();
        detail.setMaterial(materialService.handleGetMaterialById(materialId));
        detail.setImport_quantity(quantity);
        detail.setImport_price(price);

        tempList.add(detail);
        session.setAttribute("tempImportList", tempList);

        return "redirect:/admin/imports/create";
    }

    // Xóa 1 dòng khỏi danh sách tạm
    @GetMapping("/admin/imports/remove-temp/{index}")
    public String removeTempItem(@PathVariable int index, HttpSession session) {
        List<ImportDetail> tempList = (List<ImportDetail>) session.getAttribute("tempImportList");
        if (tempList != null && index >= 0 && index < tempList.size()) {
            tempList.remove(index);
            session.setAttribute("tempImportList", tempList);
        }
        return "redirect:/admin/imports/create";
    }

    // Lưu toàn bộ từ Session vào Database
    @PostMapping("/admin/imports/save-final")
    public String saveFinalImport(HttpSession session) {
        List<ImportDetail> tempList = (List<ImportDetail>) session.getAttribute("tempImportList");
        
        if (tempList != null && !tempList.isEmpty()) {
            // Gọi service xử lý lưu vào 2 bảng Imports và Import_Details
            // Nên lấy User đang đăng nhập từ Session để gán vào phiếu nhập
            this.importService.handleSaveFinalImport(tempList);
            
            // Xóa sạch danh sách tạm sau khi lưu thành công
            session.removeAttribute("tempImportList");
        }
        return "redirect:/admin/imports";
    }


    // Chi tiết phiếu nhập
    @GetMapping("/admin/imports/{id}")
    public String getImportDetail(Model model, @PathVariable Long id) {
        // 1. Lấy thông tin phiếu nhập (bao gồm cả User và danh sách ImportDetail)
        Import importTicket = this.importService.handleGetImportById(id);
        
        // 2. Gửi dữ liệu sang JSP
        model.addAttribute("importTicket", importTicket);
        // Danh sách chi tiết thường được mapping @OneToMany trong entity Import
        model.addAttribute("details", importTicket.getImportDetails()); 
        
        return "admin/import/detail-import";
    }


    // Xóa phiếu nhập
    @GetMapping("/admin/imports/delete/{id}")
    public String deleteImport(@PathVariable Long id) {
        this.importService.handleDeleteImport(id);
        return "redirect:/admin/imports";
    }

    

}
