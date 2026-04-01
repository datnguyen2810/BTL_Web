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
        List<RecentActivityDTO> activitiePage = new ArrayList<>();
        LocalDateTime oneWeekAgo = LocalDateTime.now().minusWeeks(1);

        // 1. Lấy list Nhập kho trong 1 tuần gần đây (Chuyển sang DTO)
        List<Import> allImports = importRepository.findByDateGreaterThanEqual(oneWeekAgo);
        for (Import imp : allImports) {
            activitiePage.add(new RecentActivityDTO(
                imp.getCode(), 
                "Nhập kho", 
                imp.getUserImport() != null ? imp.getUserImport().getFullName() : "Hệ thống", 
                "Hoàn thành", 
                imp.getDate()
            ));
        }

        // 2. Lấy list Xuất kho trong 1 tuần gần đây (Chuyển sang DTO)
        List<Export> allExports = exportRepository.findByDateGreaterThanEqual(oneWeekAgo);
        for (Export exp : allExports) {
            activitiePage.add(new RecentActivityDTO(
                exp.getCode(),
                "Xuất kho",
                exp.getUserExport() != null ? exp.getUserExport().getFullName() : "Hệ thống",
                "Hoàn thành",
                exp.getDate()
            ));
        }

        // 3. Sắp xếp toàn bộ theo ngày mới nhất lên đầu
        activitiePage = activitiePage.stream()
            .sorted((a, b) -> b.getDate().compareTo(a.getDate()))
            .toList();  

        // 4. Thực hiện phân trang thủ công trên List
        int start = page * size;
        int end = Math.min((start + size), activitiePage.size());
        
        // Kiểm tra nếu trang yêu cầu vượt quá dữ liệu hiện có
        if (start >= activitiePage.size() && !activitiePage.isEmpty()) {
            return new PageImpl<>(new ArrayList<>(), PageRequest.of(page, size), activitiePage.size());
        }

        // pageContent = dữ liệu trang hiện tại
        // PageRequest.of(page, size) = thông tin trang (số trang, kích thước)
        // activitiePage.size() = tổng số record (dùng để tính tổng trang: 100 / 5 = 20 trang)
        List<RecentActivityDTO> pageContent = activitiePage.subList(start, end);
        return new PageImpl<>(pageContent, PageRequest.of(page, size), activitiePage.size());
    }


    // public List<RecentActivityDTO> getRecentActivities(){
    //     List<RecentActivityDTO> activities = new ArrayList<>();
    //     // 1. Lấy 5 phiếu nhập gần nhất
    //     List<Import> recentImports = importRepository.findTop5ByOrderByDateDesc();
    //     for (Import imp : recentImports) {
    //        RecentActivityDTO tmp = new RecentActivityDTO(
    //             "NK" + String.format("%03d", imp.getId()), 
    //             "Nhập kho", 
    //             imp.getUserImport() != null ? imp.getUserImport().getFullName() : "Hệ thống", 
    //             "Hoàn thành", 
    //             imp.getDate()
    //         );
    //         activities.add(tmp);
    //     }

    //     // 2. Lấy 5 phiếu xuất gần nhất
    //     List<Export> recentExports = exportRepository.findTop5ByOrderByDateDesc();
    //     for(Export exp : recentExports){
    //         RecentActivityDTO tmp = new RecentActivityDTO(
    //             "XK" + String.format("%03d", exp.getId()),
    //             "Xuất kho",
    //             exp.getUserExport() != null ? exp.getUserExport().getFullName() : "Hệ thống",
    //             "Hoàn thành",
    //             exp.getDate()
    //         );
    //         activities.add(tmp);
    //     }
        
    //     // 3. Sắp xếp tất cả theo ngày giảm dần và lấy 5 cái mới nhất tổng cộng
    //     return activities.stream()
    //         .sorted((a, b) -> b.getDate().compareTo(a.getDate()))
    //         .limit(5)
    //         .toList();  
    // }



}
