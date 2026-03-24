package vn.xuandat.Warehouse_management.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import jakarta.transaction.Transactional;
import vn.xuandat.Warehouse_management.entity.Import;
import vn.xuandat.Warehouse_management.entity.ImportDetail;
import vn.xuandat.Warehouse_management.entity.User;
import vn.xuandat.Warehouse_management.repository.ImportDetailRepository;
import vn.xuandat.Warehouse_management.repository.ImportRepository;

@Service
public class ImportService {
    private final ImportRepository importRepository;
    private final ImportDetailRepository importDetailRepository;
    private final UserService userService;

    public ImportService(ImportRepository importRepository, ImportDetailRepository importDetailRepository, UserService userService) {
        this.importRepository = importRepository;
        this.importDetailRepository = importDetailRepository;
        this.userService = userService;
    }

    public List<Import> handleGetAllImports() {
        return this.importRepository.findAll();
    }

    public List<Import> searchImports(Long userId, Long importId) {
        return this.importRepository.searchImports(userId, importId);
    }


    @Transactional
    public void handleSaveFinalImport(List<ImportDetail> tempList) {
        // 1. Tạo phiếu nhập mới (Bảng Imports)
        Import imp = new Import();
        imp.setDate(LocalDateTime.now());
        // Tính tổng tiền từ danh sách tạm
        double total = tempList.stream().mapToDouble(i -> i.getImport_price() * i.getImport_quantity()).sum();
        imp.setTotalAmount(total);

        // Lấy thông tin người dùng đang login (lấy từ Spring Security)
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String email = auth.getName(); 
        User currentUser = userService.getUserByEmail(email);

        // Gán vào phiếu trước khi lưu
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
        // 1. Xóa tất cả chi tiết của phiếu này trước (ràng buộc khóa ngoại)
        this.importDetailRepository.deleteByImportId(id); 
        // 2. Xóa phiếu nhập chính
        this.importRepository.deleteById(id);
    }


}
