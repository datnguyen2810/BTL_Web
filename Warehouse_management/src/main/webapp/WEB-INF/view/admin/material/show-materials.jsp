<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<% request.setAttribute("activeMenu", "materials"); %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý vật tư - Kho vật tư</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/style-material.css">
</head>
<body>
    <jsp:include page="../layout/sidebar.jsp" />

    <div class="main-content">
        <h1 class="page-header">Quản lý vật tư</h1>
        
        <div class="data-card">
            <c:if test="${not empty error}">
                <div class="alert alert-danger" style="color: #ef4444; background-color: #fee2e2; padding: 12px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #fecaca;">
                    <i class="fas fa-exclamation-circle"></i> ${error}
                </div>
            </c:if>
            
            <c:if test="${not empty message}">
                <div class="alert alert-success" style="color: #10b981; background-color: #d1fae5; padding: 12px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #a7f3d0;">
                    <i class="fas fa-check-circle"></i> ${message}
                </div>
            </c:if>
            
            <form class="toolbar" action="/admin/materials" method="get" >
                <div class="left-actions" style="display:flex; gap:12px; align-items:center;">
                    <sec:authorize access="hasRole('ADMIN')">
                        <button class="btn-add" type="button" onclick="window.location.href='/admin/materials/create'">
                            <i class="fas fa-plus"></i> Thêm vật tư
                        </button>
                    </sec:authorize>

                    <!--  Lọc theo danh mục -->
                    <!-- name="categoryId": gửi lên controller param tên categoryId
                    onchange="this.form.submit()": chọn xong tự submit
                    selectedCategoryId: để giữ lại option đang chọn sau khi load lại trang -->
                    <select name="categoryId" class="filter-select" onchange="this.form.submit()">
                        <option value="">Lọc theo danh mục</option>
                        <c:forEach var="category" items="${categories}">
                            <option value="${category.id}"
                                <c:if test="${category.id == selectedCategoryId}">selected="selected"</c:if>>
                                ${category.name}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                
                <!-- Tìm kiếm -->
                <div class="search-box">
                    <i class="fas fa-search"></i>
                    <input type="text" name="keyword" value="${param.keyword}" placeholder="Nhập tên vật tư...">
                </div>
            </form>

            <table>
                <thead>
                    <tr>
                        <th>Mã vật tư</th>
                        <th>Tên vật tư</th>
                        <th>Danh mục</th>
                        <th>Đơn vị</th>
                        <sec:authorize access="hasRole('ADMIN')">
                            <th>Thao tác</th>
                        </sec:authorize>
                        
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="material" items="${materials}">
                        <tr>
                            <td>${material.id}</td>
                            <td>${material.name}</td>
                            <td>${material.category.name}</td>
                            <td>${material.unit}</td>
                            <td class="action-links">
                                <sec:authorize access="hasRole('ADMIN')">
                                    <a href="/admin/materials/update/${material.id}" class="edit-link">Sửa</a>
                                    <a href="/admin/materials/delete/${material.id}" class="delete-link" onclick="return confirm('Bạn có chắc chắn muốn xóa vật tư này?')">Xóa</a>
                                </sec:authorize>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        
            <%-- Chỉ hiển thị thanh phân trang nếu tổng số trang > 0 --%>
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
                            <a href="/admin/materials?page=0&categoryId=${selectedCategoryId}&keyword=${param.keyword}" class="btn-page">1</a>
                            <c:if test="${begin > 1}">
                                <span style="color: #94a3b8; padding: 0 4px;">...</span>
                            </c:if>
                        </c:if>

                        <%-- Vòng lặp các số trang ở giữa --%>
                        <c:forEach begin="${begin}" end="${end}" var="i">
                            <a href="/admin/materials?page=${i}&categoryId=${selectedCategoryId}&keyword=${param.keyword}" 
                            class="btn-page ${i == currentPage ? 'active' : ''}">${i + 1}</a>
                        </c:forEach>

                        <%-- Dấu ... và trang cuối --%>
                        <c:if test="${end < totalPages - 1}">
                            <c:if test="${end < totalPages - 2}">
                                <span style="color: #94a3b8; padding: 0 4px;">...</span>
                            </c:if>
                            <a href="/admin/materials?page=${totalPages - 1}&categoryId=${selectedCategoryId}&keyword=${param.keyword}" class="btn-page">${totalPages}</a>
                        </c:if>
                    </div>
                </div>
            </c:if>
        </div>
    </div>

</body>
</html>