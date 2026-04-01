<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page import="java.util.*" %>
<% request.setAttribute("activeMenu", "dashboard"); %>

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
                    <c:forEach var="activity" items="${activities}">
                        <tr>
                            <td>${activity.id}</td>
                            <c:choose>
                                <c:when test="${activity.type eq 'Nhập kho'}">
                                    <td style="color: #10b981;">${activity.type}</td>
                                </c:when>
                                <c:otherwise>
                                    <td style="color: #ef4444;">${activity.type}</td>
                                </c:otherwise>
                            </c:choose>
                            <td>${activity.userName}</td>
                            <td><span class="badge badge-success">${activity.status}</span></td>
                            <td>${activity.date}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <!-- phân trang -->
            <c:if test="${totalPages > 0}">
                <div class="pagination-container" style="display: flex; justify-content: space-between; align-items: center; margin-top: 20px;">
                    <div class="page-info" style="color: #64748b; font-size: 14px;">
                        Trang ${currentPage + 1} trên ${totalPages}
                    </div>
                    
                    <%-- 1. Xác định số lượng nút muốn hiển thị (ví dụ: 5 nút) --%>
                        <c:set var="maxPages" value="5" />
                        <c:set var="half" value="2" /> <%-- Số nút hiển thị ở mỗi bên trang hiện tại --%>

                        <%-- 2. Tính toán điểm bắt đầu --%>
                        <c:set var="begin" value="${currentPage - half}" />
                        <c:set var="end" value="${currentPage + half}" />

                        <%-- 3. Xử lý trường hợp ở những trang đầu tiên --%>
                        <c:if test="${begin < 0}">
                            <c:set var="begin" value="0" />
                            <c:set var="end" value="${totalPages - 1 < maxPages - 1 ? totalPages - 1 : maxPages - 1}" />
                        </c:if>

                        <%-- 4. Xử lý trường hợp ở những trang cuối cùng --%>
                        <c:if test="${end > totalPages - 1}">
                            <c:set var="end" value="${totalPages - 1}" />
                            <c:set var="begin" value="${end - maxPages + 1 < 0 ? 0 : end - maxPages + 1}" />
                        </c:if>

                        <%-- Bắt đầu phần hiển thị nút --%>
                        <div class="page-buttons" style="display: flex; gap: 5px; align-items: center;">
                            <%-- Nút trang 1 và dấu ... --%>
                            <c:if test="${begin > 0}">
                                <a href="/admin/dashboard?page=0" class="btn-page">1</a>
                                <c:if test="${begin > 1}">
                                    <span style="color: #94a3b8; padding: 0 4px;">...</span>
                                </c:if>
                            </c:if>

                            <%-- Vòng lặp các số trang ở giữa --%>
                            <c:forEach begin="${begin}" end="${end}" var="i">
                                <a href="/admin/dashboard?page=${i}" class="btn-page ${i == currentPage ? 'active' : ''}">${i + 1}</a>
                            </c:forEach>

                            <%-- Dấu ... và trang cuối --%>
                            <c:if test="${end < totalPages - 1}">
                                <c:if test="${end < totalPages - 2}">
                                    <span style="color: #94a3b8; padding: 0 4px;">...</span>
                                </c:if>
                                <a href="/admin/dashboard?page=${totalPages - 1}" class="btn-page">${totalPages}</a>
                            </c:if>
                        </div>
                </div>
            </c:if>
        </div>
    </div>

</body>
</html>