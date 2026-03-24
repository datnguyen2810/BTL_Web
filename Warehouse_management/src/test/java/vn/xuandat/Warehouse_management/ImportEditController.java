package vn.xuandat.Warehouse_management;
// package vn.xuandat.Warehouse_management.controller;

// import org.springframework.beans.factory.annotation.Autowired;
// import org.springframework.stereotype.Controller;
// import org.springframework.ui.Model;
// import org.springframework.web.bind.annotation.GetMapping;
// import org.springframework.web.bind.annotation.PathVariable;
// import org.springframework.web.bind.annotation.PostMapping;
// import org.springframework.web.bind.annotation.RequestMapping;
// import org.springframework.web.bind.annotation.RequestParam;

// import vn.xuandat.Warehouse_management.entity.Import;
// import vn.xuandat.Warehouse_management.entity.ImportDetail;
// import vn.xuandat.Warehouse_management.service.ImportService;
// import vn.xuandat.Warehouse_management.service.MaterialService;

// @Controller
// @RequestMapping("/admin/imports/edit")
// public class ImportEditController {
    
//     @Autowired
//     private ImportService importService;
//     @Autowired
//     private MaterialService materialService;

//     // Mở trang sửa
//     @GetMapping("/{id}")
//     public String showEditForm(@PathVariable Long id, Model model) {
//         Import imp = importService.handleGetImportById(id);
//         model.addAttribute("importTicket", imp);
//         model.addAttribute("materials", materialService.handleGetAllMaterials());
//         return "admin/import/edit-import";
//     }

//     // Xử lý thêm nhanh 1 món vào phiếu cũ
//     @PostMapping("/add-item")
//     public String addItem(@RequestParam Long importId, 
//                           @RequestParam Long materialId,
//                           @RequestParam Long quantity,
//                           @RequestParam Double price) {
//         ImportDetail detail = new ImportDetail();
//         detail.setMaterial(materialService.handleGetMaterialById(materialId));
//         detail.setImport_quantity(quantity);
//         detail.setImport_price(price);
        
//         importService.addItemToExistingImport(importId, detail);
//         return "redirect:/admin/imports/edit/" + importId;
//     }

//     // Xử lý xóa nhanh 1 món khỏi phiếu cũ
//     @GetMapping("/remove-item/{detailId}")
//     public String removeItem(@PathVariable Long detailId) {
//         ImportDetail detail = importDetailRepository.findById(detailId).get();
//         Long importId = detail.getImportTicket().getId();
        
//         importService.removeItemFromImport(detailId);
//         return "redirect:/admin/imports/edit/" + importId;
//     }
// }



// @Service
// public class ImportService {
//     @Autowired
//     private ImportRepository importRepository;
//     @Autowired
//     private ImportDetailRepository importDetailRepository;

//     // 1. Lấy thông tin phiếu để đổ lên form sửa
//     public Import handleGetImportById(Long id) {
//         return importRepository.findById(id).orElse(null);
//     }

//     // 2. Thêm một item mới vào phiếu đang sửa
//     @Transactional
//     public void addItemToExistingImport(Long importId, ImportDetail detail) {
//         Import imp = importRepository.findById(importId).orElse(null);
//         if (imp != null) {
//             detail.setImportTicket(imp);
//             importDetailRepository.save(detail);
            
//             // Cập nhật lại tổng tiền của phiếu cha
//             updateTotalAmount(imp);
//         }
//     }

//     // 3. Xóa một item khỏi phiếu đang sửa
//     @Transactional
//     public void removeItemFromImport(Long detailId) {
//         ImportDetail detail = importDetailRepository.findById(detailId).orElse(null);
//         if (detail != null) {
//             Import imp = detail.getImportTicket();
//             importDetailRepository.delete(detail);
            
//             // Cập nhật lại tổng tiền sau khi xóa
//             updateTotalAmount(imp);
//         }
//     }

//     // Hàm phụ: Tính toán lại tổng tiền dựa trên danh sách chi tiết hiện tại
//     private void updateTotalAmount(Import imp) {
//         List<ImportDetail> details = importDetailRepository.findByImportTicketId(imp.getId());
//         double total = details.stream()
//                              .mapToDouble(d -> d.getImport_price() * d.getImport_quantity())
//                              .sum();
//         imp.setTotal_amount(total);
//         importRepository.save(imp);
//     }
// }