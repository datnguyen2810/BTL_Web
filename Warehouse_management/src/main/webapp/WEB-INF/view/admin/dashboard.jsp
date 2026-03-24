<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page import="java.util.*" %>
<% request.setAttribute("currentPage", "dashboard"); %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Quản lý kho vật tư</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/style-dashboard.css">
</head>
<body>
    <jsp:include page="layout/sidebar.jsp" />

    <div class="main-content">
        <h1 class="page-header">Tổng quan hệ thống</h1>

        <!-- stat: thống kê -->
        <div class="stats-grid"> 
            <div class="stat-card">
                <div class="stat-label">Tổng số vật tư</div>
                <div class="stat-value">${stats.totalMaterials}</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Vật tư sắp hết hàng</div>
                <div class="stat-value red">${stats.lowStockCount}</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Đơn nhập tháng này</div>
                <div class="stat-value blue">${stats.totalImportsThisMonth}</div>
            </div>
        </div>

        <div class="data-card">
            <h3>Nhập xuất gần đây</h3>
            <table>
                <thead>
                    <tr>
                        <th>Mã phiếu</th>
                        <th>Loại</th>
                        <th>Người thực hiện</th>
                        <th>Trạng thái</th>
                        <th>Ngày</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- <tr>
                        <td>NK001</td>
                        <td style="color: #10b981;">Nhập kho</td>
                        <td>Nguyễn Văn A</td>
                        <td><span class="badge badge-success">Hoàn thành</span></td>
                        <td>26/01/2026</td>
                    </tr> -->

                    <c:forEach var="activity" items="${stats.recentActivities}">
                        <tr>
                            <td>${activity.id}</td>
                            <td style="color: ${activity.type == 'Nhập kho' ? '#10b981' : '#ef4444'}">${activity.type}</td>
                            <td>${activity.userName}</td>
                            <td><span class="badge badge-success">${activity.status}</span></td>
                            <td>${activity.date}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

</body>
</html>