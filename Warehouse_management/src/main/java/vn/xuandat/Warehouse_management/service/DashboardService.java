package vn.xuandat.Warehouse_management.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import vn.xuandat.Warehouse_management.entity.DashboardStats;
import vn.xuandat.Warehouse_management.entity.Export;
import vn.xuandat.Warehouse_management.entity.Import;
import vn.xuandat.Warehouse_management.entity.RecentActivityDTO;
import vn.xuandat.Warehouse_management.repository.ExportRepository;
import vn.xuandat.Warehouse_management.repository.ImportRepository;
import vn.xuandat.Warehouse_management.repository.MaterialRepository;

@Service
public class DashboardService {
    private final MaterialRepository materialRepository;
    private final ImportRepository importRepository;
    private final ExportRepository exportRepository;
    public DashboardService(ImportRepository importRepository, ExportRepository exportRepository, MaterialRepository materialRepository) {
        this.importRepository = importRepository;
        this.exportRepository = exportRepository;
        this.materialRepository = materialRepository;
    }

    public DashboardStats getDashboardStats() {
        DashboardStats stats = new DashboardStats();
        // Tổng số vật tư 
        stats.setTotalMaterials(materialRepository.count());
        // Vật tư sắp hết hàng (Tính toán tồn kho < 10)
        stats.setLowStockCount(materialRepository.countLowStockMaterials());
        // Đơn nhập tháng này
        stats.setTotalImportsThisMonth(importRepository.countImportsInCurrentMonth());
        return stats;
    }

    public Page<RecentActivityDTO> getPagedActivities(int page, int size) {
        List<RecentActivityDTO> activitiesPage = new ArrayList<>();
        LocalDateTime twoWeekAgo = LocalDateTime.now().minusWeeks(2);

        // 1. Lấy list Nhập kho trong 2 tuần gần đây (Chuyển sang DTO)
        List<Import> listImports = importRepository.findByDateGreaterThanEqual(twoWeekAgo);
        for (Import imp : listImports) {
            activitiesPage.add(new RecentActivityDTO(
                imp.getCode(), 
                "Nhập kho", 
                imp.getUserImport() != null ? imp.getUserImport().getFullName() : "Hệ thống", 
                "Hoàn thành", 
                imp.getDate()
            ));
        }

        // 2. Lấy list Xuất kho trong 2 tuần gần đây (Chuyển sang DTO)
        List<Export> listExports = exportRepository.findByDateGreaterThanEqual(twoWeekAgo);
        for (Export exp : listExports) {
            activitiesPage.add(new RecentActivityDTO(
                exp.getCode(),
                "Xuất kho",
                exp.getUserExport() != null ? exp.getUserExport().getFullName() : "Hệ thống",
                "Hoàn thành",
                exp.getDate()
            ));
        }

        // 3. Sắp xếp toàn bộ theo ngày mới nhất lên đầu
        activitiesPage = activitiesPage.stream()
            .sorted((a, b) -> b.getDate2().compareTo(a.getDate2()))
            .toList();  

        // 4. Thực hiện phân trang thủ công trên List
        int start = page * size;
        int end = Math.min((start + size), activitiesPage.size());
        
        // Kiểm tra nếu trang yêu cầu vượt quá dữ liệu hiện có
        if (start >= activitiesPage.size() && !activitiesPage.isEmpty()) {
            return new PageImpl<>(new ArrayList<>(), PageRequest.of(page, size), activitiesPage.size());
        }

        // pageContent = dữ liệu trang hiện tại
        // PageRequest.of(page, size) = thông tin trang (số trang, kích thước)
        // activitiesPage.size() = tổng số record (dùng để tính tổng trang: 100 / 5 = 20 trang)
        List<RecentActivityDTO> pageContent = activitiesPage.subList(start, end);
        return new PageImpl<>(pageContent, PageRequest.of(page, size), activitiesPage.size());
    }


}
