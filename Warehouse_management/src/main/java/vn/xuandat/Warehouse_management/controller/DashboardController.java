package vn.xuandat.Warehouse_management.controller;


import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import vn.xuandat.Warehouse_management.entity.DashboardStats;
import vn.xuandat.Warehouse_management.service.DashboardService;

@Controller
public class DashboardController {
    private final DashboardService dashboardService;
    public DashboardController(DashboardService dashboardService) {
        this.dashboardService = dashboardService;
    }

    @GetMapping("/admin/dashboard")
    public String showDashboard(Model model) {
        DashboardStats stats = dashboardService.getDashboardStats();
        stats.setRecentActivities(dashboardService.getRecentActivities());

        model.addAttribute("stats", stats);
        return "admin/dashboard";
    }
    
}
