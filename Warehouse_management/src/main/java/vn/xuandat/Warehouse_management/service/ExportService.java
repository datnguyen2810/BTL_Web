package vn.xuandat.Warehouse_management.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import vn.xuandat.Warehouse_management.entity.Export;
import vn.xuandat.Warehouse_management.entity.ExportDetail;
import vn.xuandat.Warehouse_management.entity.User;
import vn.xuandat.Warehouse_management.repository.ExportDetailRepository;
import vn.xuandat.Warehouse_management.repository.ExportRepository;

@Service
public class ExportService {
    private final ExportRepository exportRepository;
    private final ExportDetailRepository exportDetailRepository;
    private final UserService userService;

    public ExportService(ExportRepository exportRepository, ExportDetailRepository exportDetailRepository, UserService userService) {
        this.exportRepository = exportRepository;
        this.exportDetailRepository = exportDetailRepository;
        this.userService = userService;
    }

    public List<Export> searchExports(Long userId, Long exportId) {
        return this.exportRepository.searchExports(userId, exportId);
    }

    @Transactional
    public void handleSaveFinalExport(List<ExportDetail> tempList) {
        // 1. Tạo phiếu nhập mới (Bảng Imports)
        Export exp = new Export();
        exp.setDate(LocalDateTime.now());

        // Tính tổng tiền từ danh sách tạm
        double total = tempList.stream().mapToDouble(it -> it.getExport_price() * it.getExport_quantity()).sum();
        exp.setTotalAmount(total);

        // Lấy thông tin người dùng đang login (lấy từ Spring Security)
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String email = auth.getName();
        User currentUser = userService.getUserByEmail(email);
        exp.setUserExport(currentUser);

        this.exportRepository.save(exp);

        // 2. Lưu chi tiết (Bảng Import_Details)
        for(ExportDetail detail : tempList){
            detail.setExportEntity(exp);
            this.exportDetailRepository.save(detail);
        }
    }

    @Transactional
    public void handleDeleteExport(Long exportId) {
        this.exportDetailRepository.deleteByExportId(exportId); // Xóa chi tiết trước
        this.exportRepository.deleteById(exportId); // Xóa phiếu xuất
    }

    public Export handleGetExportById(Long id) {
        return this.exportRepository.findById(id).orElse(null);
    }
    


}
