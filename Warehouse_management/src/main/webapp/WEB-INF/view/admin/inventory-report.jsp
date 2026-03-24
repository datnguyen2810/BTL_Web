<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<% request.setAttribute("currentPage", "inventory-report"); %>
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
                <input type="text" placeholder="Tìm kiếm vật tư theo mã hoặc tên..." name="keyword" value="${param.keyword}">
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
        </div>
    </div>

</body>
</html>