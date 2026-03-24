package vn.xuandat.Warehouse_management.service;

import java.util.ArrayList;
import java.util.List;

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
        // 1. Tổng số vật tư (Lấy từ bảng materials)
        stats.setTotalMaterials(materialRepository.count());

        // 2. Vật tư sắp hết hàng (Tính toán tồn kho < 10)
        stats.setLowStockCount(materialRepository.countLowStockMaterials());

        // 3. Đơn nhập tháng này
        stats.setTotalImportsThisMonth(importRepository.countImportsInCurrentMonth());
        return stats;
    }

    public List<RecentActivityDTO> getRecentActivities(){
        List<RecentActivityDTO> activities = new ArrayList<>();
        // 1. Lấy 5 phiếu nhập gần nhất
        List<Import> recentImports = importRepository.findTop5ByOrderByDateDesc();
        for (Import imp : recentImports) {
            activities.add(new RecentActivityDTO(
                "NK" + String.format("%03d", imp.getId()), 
                "Nhập kho", 
                imp.getUserImport() != null ? imp.getUserImport().getFullName() : "Hệ thống", 
                "Hoàn thành", 
                imp.getDate()
            ));
        }

        // 2. Lấy 5 phiếu xuất gần nhất
        List<Export> recentExports = exportRepository.findTop5ByOrderByDateDesc();
        for(Export exp : recentExports){
            activities.add(new RecentActivityDTO(
                "XK" + String.format("%03d", exp.getId()),
                "Xuất kho",
                exp.getUserExport() != null ? exp.getUserExport().getFullName() : "Hệ thống",
                "Hoàn thành",
                exp.getDate()
            ));
        }
        
        // 3. Sắp xếp tất cả theo ngày giảm dần và lấy 5 cái mới nhất tổng cộng
        return activities.stream()
            .sorted((a, b) -> b.getDate().compareTo(a.getDate()))
            .limit(5)
            .toList();  
    }


}
