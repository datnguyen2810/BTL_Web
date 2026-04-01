package vn.xuandat.Warehouse_management.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import jakarta.transaction.Transactional;
import vn.xuandat.Warehouse_management.entity.Import;
import vn.xuandat.Warehouse_management.entity.ImportDetail;
import vn.xuandat.Warehouse_management.entity.User;
import vn.xuandat.Warehouse_management.repository.ImportDetailRepository;
import vn.xuandat.Warehouse_management.repository.ImportRepository;
import vn.xuandat.Warehouse_management.repository.MaterialRepository;

@Service
public class ImportService {
    private final ImportRepository importRepository;
    private final ImportDetailRepository importDetailRepository;
    private final UserService userService;
    private final MaterialRepository materialRepository;

    public ImportService(ImportRepository importRepository, ImportDetailRepository importDetailRepository, UserService userService, MaterialRepository materialRepository) {
        this.importRepository = importRepository;
        this.importDetailRepository = importDetailRepository;
        this.userService = userService;
        this.materialRepository = materialRepository;
    }

    public List<Import> handleGetAllImports() {
        return this.importRepository.findAll();
    }

    public Page<Import> getPagedImport(Long userId, String importCode, Pageable pageable) {
        return this.importRepository.getPagedImport(userId, importCode, pageable);
    }

    public boolean isCodeExists(String code) {
        return importRepository.existsByCode(code);
    }

    @Transactional
    public void handleSaveFinalImport(List<ImportDetail> tempList, String importCode) {
        // 1. Tạo phiếu nhập mới (Bảng Imports)
        Import imp = new Import();
        imp.setDate(LocalDateTime.now());
        imp.setCode(importCode);
        // Tính tổng tiền từ danh sách tạm
        double total = tempList.stream().mapToDouble(i -> i.getImport_price() * i.getImport_quantity()).sum();
        imp.setTotalAmount(total);

        // Lấy thông tin người dùng đang login (lấy từ Spring Security)
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String email = auth.getName(); 
        User currentUser = userService.getUserByEmail(email);
        imp.setUserImport(currentUser);
        
        imp = this.importRepository.save(imp);

        // 2. Lưu chi tiết (Bảng Import_Details)
        for (ImportDetail detail : tempList) {
            detail.setImportEntity(imp); // Gán quan hệ với phiếu vừa tạo
            this.importDetailRepository.save(detail);
        }
    }

    public Import handleGetImportById(Long id) {
        return this.importRepository.findById(id).orElse(null);
    }

    @Transactional
    public void handleDeleteImport(Long id) {
        // 1. Kiểm tra tồn kho (Tránh bị âm kho sau khi xóa)
        List<ImportDetail> details = this.importDetailRepository.findByImportId(id);
        for(ImportDetail detail : details){
            long materialId = detail.getMaterial().getId();
            long currentStock = this.materialRepository.calculateCurrentStock(materialId);
            if(currentStock < detail.getImport_quantity()){
                throw new RuntimeException("Không thể xóa! Phiếu nhập này đã được xuất kho một phần hoặc toàn bộ.");
            }
        }

        // 2. Xóa phiếu nhập (cascade delete sẽ tự động xóa ImportDetail)
        this.importRepository.deleteById(id);
    }


}
