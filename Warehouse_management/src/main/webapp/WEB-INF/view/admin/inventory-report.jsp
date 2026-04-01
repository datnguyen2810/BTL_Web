<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<% request.setAttribute("activeMenu", "inventory-report"); %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo cáo tồn kho - Quản lý kho</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/style-inventory-report.css">
</head>
<body>

    <jsp:include page="layout/sidebar.jsp" />
    
    <div class="main-content">
        <div class="page-header">
            Báo cáo tồn kho hiện tại
        </div>

        <form class="toolbar" action="/admin/inventory-report" method="get">
            <div class="search-box">
                <i class="fas fa-search"></i>
                <input type="text" placeholder="Tìm kiếm vật tư theo tên..." name="keyword" value="${param.keyword}">
            </div>

            <select name="categoryId" onchange="this.form.submit()" style="padding: 10px; border-radius: 8px; border: 1px solid var(--border-color);">
                <option value="">Tất cả danh mục</option>
                <c:forEach var="category" items="${categories}">
                    <option value="${category.id}" ${param.categoryId == category.id ? 'selected' : ''}>${category.name}</option>
                </c:forEach>
            </select>
        </form>

        <div class="data-card">
            <table>
                <thead>
                    <tr>
                        <th>Mã vật tư</th>
                        <th>Tên vật tư</th>
                        <th>Đơn vị</th>
                        <th>Tổng nhập</th>
                        <th>Tổng xuất</th>
                        <th>Số lượng tồn</th>
                        <th>Trạng thái</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${inventoryReport}">
                        <tr>
                            <td><strong>${item.materialId}</strong></td>
                            <td>${item.materialName}</td>
                            <td>${item.unit}</td>       
                            <td>${item.totalImport}</td>
                            <td>${item.totalExport}</td>
                            <td class="stock-value ${item.stock < 10 ? 'status-low' : 'status-ok'}">${item.stock}</td>
                            <td><span class="badge ${item.stock < 10 ? 'badge-danger' : 'badge-success'}">${item.status}</span></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            <c:if test="${totalPages > 0}">
                <div class="pagination-container" style="display: flex; justify-content: space-between; align-items: center; margin-top: 20px;"">
                    <div class="page-info" style="color: #64748b; font-size: 14px;">
                        Trang ${currentPage + 1} trên ${totalPages}
                    </div>
                    
                    <%-- 1. Xác định số lượng nút muốn hiển thị (ví dụ: 5 nút) --%>
                    <c:set var="maxPages" value="5"/>
                    <c:set var="half" value="2"/>

                    <%-- 2. Tính toán điểm bắt đầu --%>
                    <c:set var="begin" value="${currentPage - half}"/>
                    <c:set var="end" value="${currentPage + half}"/>

                    <%-- 3. Xử lý trường hợp ở những trang đầu tiên --%>
                    <c:if test="${begin < 0}">
                        <c:set var="begin" value="0"/>
                        <c:set var="end" value="${totalPages - 1 < maxPages - 1 ? totalPages - 1 : maxPages - 1}" />
                    </c:if>

                    <%-- 4. Xử lý trường hợp ở những trang cuối cùng --%>
                    <c:if test="${end > totalPages - 1}">
                        <c:set var="end" value="${totalPages - 1}"/>
                        <c:set var="begin" value="${end - maxPages + 1 < 0 ? 0 : end - maxPages + 1}"/>
                    </c:if>

                    <%-- Bắt đầu phần hiển thị nút --%>
                    <div class="page-buttons" style="display: flex; gap: 5px; align-items: center;">
                        <%-- Nút trang 1 và dấu ... --%>
                        <c:if test="${begin > 0}">
                            <a href="/admin/inventory-report?page=0&categoryId=${selectedCategoryId}&keyword=${param.keyword}" class="btn-page">1</a>
                            <c:if test="${begin > 1}">
                                <span style="color: #94a3b8; padding: 0 4px;">...</span>
                            </c:if>
                        </c:if>

                        <%-- Vòng lặp các số trang ở giữa --%>
                        <c:forEach begin="${begin}" end="${end}" var="i">
                            <a href="/admin/inventory-report?page=${i}&categoryId=${selectedCategoryId}&keyword=${param.keyword}" 
                            class="btn-page ${i == currentPage ? 'active' : ''}">${i + 1}</a>
                        </c:forEach>

                        <%-- Dấu ... và trang cuối --%>
                        <c:if test="${end < totalPages - 1}">
                            <c:if test="${end < totalPages - 2}">
                                <span style="color: #94a3b8; padding: 0 4px;">...</span>
                            </c:if>
                            <a href="/admin/inventory-report?page=${totalPages - 1}&categoryId=${selectedCategoryId}&keyword=${param.keyword}" class="btn-page">${totalPages}</a>
                        </c:if>
                </div>
            </c:if>

        </div>
    </div>

</body>
</html>