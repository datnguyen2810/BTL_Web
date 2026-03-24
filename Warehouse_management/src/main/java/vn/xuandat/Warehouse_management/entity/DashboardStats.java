package vn.xuandat.Warehouse_management.entity;

import java.util.List;

public class DashboardStats {
    private long totalMaterials;
    private long lowStockCount;
    private long totalImportsThisMonth;
    private List<RecentActivityDTO> recentActivities;

    public long getTotalMaterials() {
        return totalMaterials;
    }

    public void setTotalMaterials(long totalMaterials) {
        this.totalMaterials = totalMaterials;
    }

    public long getLowStockCount() {
        return lowStockCount;
    }

    public void setLowStockCount(long lowStockCount) {
        this.lowStockCount = lowStockCount;
    }

    public long getTotalImportsThisMonth() {
        return totalImportsThisMonth;
    }

    public void setTotalImportsThisMonth(long totalImportsThisMonth) {
        this.totalImportsThisMonth = totalImportsThisMonth;
    }

    public List getRecentActivities() {
        return recentActivities;
    }

    public void setRecentActivities(List recentActivities) {
        this.recentActivities = recentActivities;
    }


}
