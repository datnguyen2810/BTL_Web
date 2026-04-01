package vn.xuandat.Warehouse_management.controller;


import org.springframework.data.domain.Page;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import vn.xuandat.Warehouse_management.entity.DashboardStats;
import vn.xuandat.Warehouse_management.entity.RecentActivityDTO;
import vn.xuandat.Warehouse_management.service.DashboardService;

@Controller
public class DashboardController {
    private final DashboardService dashboardService;
    public DashboardController(DashboardService dashboardService) {
        this.dashboardService = dashboardService;
    }

    @GetMapping("/admin/dashboard")
    public String showDashboard(Model model, @RequestParam(defaultValue = "0") int page) {
        // DashboardStats stats = dashboardService.getDashboardStats();
        // stats.setRecentActivities(dashboardService.getRecentActivities());

        int pageSize = 5;
        Page<RecentActivityDTO> pagedActivities = dashboardService.getPagedActivities(page, pageSize);
        //nếu page không hợp lệ, redirect về trang 0
        if (page < 0 || page >= pagedActivities.getTotalPages() && pagedActivities.getTotalPages() > 0) {
            return "redirect:/admin/dashboard?page=0";      
        }
        
        DashboardStats stats = dashboardService.getDashboardStats();
        model.addAttribute("stats", stats);
        model.addAttribute("activities", pagedActivities.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", pagedActivities.getTotalPages());
        return "admin/dashboard";
    }
    
}
