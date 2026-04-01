<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<% request.setAttribute("activeMenu", "categories"); %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý danh mục - Kho vật tư</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">    
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/style-category.css">
</head>
<body>
    <jsp:include page="../layout/sidebar.jsp" />

    <div class="main-content">
        <h1 class="page-header">Quản lý danh mục</h1>
        
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
            
            <!-- <sec:authorize access="hasRole('ADMIN')">
                <button class="btn-add" onclick="window.location.href='/admin/categories/create'">
                    <i class="fas fa-plus"></i> Thêm danh mục mới
                </button>
            </sec:authorize> -->
            <div class="header-actions" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                <%-- Nút thêm mới bên trái --%>
                <sec:authorize access="hasRole('ADMIN')">
                    <button class="btn-add" onclick="window.location.href='/admin/categories/create'" style="margin-bottom: 0;">
                        <i class="fas fa-plus"></i> Thêm danh mục mới
                    </button>
                </sec:authorize>

                <%-- Thanh tìm kiếm bên phải --%>
                <form action="/admin/categories" method="GET" style="display: flex; gap: 10px;">
                    <div class="search-box" style="position: relative;">
                        <input type="text" name="keyword" value="${param.keyword}" placeholder="Nhập tên danh mục..." 
                            style="padding: 10px 15px 10px 35px; border: 1px solid #e2e8f0; border-radius: 8px; width: 250px;">
                        <i class="fas fa-search" style="position: absolute; left: 12px; top: 12px; color: #94a3b8;"></i>
                    </div>
                    <button type="submit" class="btn-search" style="background: #2563eb; color: white; border: none; padding: 10px 20px; border-radius: 8px; cursor: pointer;">
                        Tìm kiếm
                    </button>
                    <c:if test="${not empty param.keyword}">
                        <a href="/admin/categories" class="btn-clear" style="padding: 10px; color: #64748b; text-decoration: none;">
                            <i class="fas fa-times"></i>
                        </a>
                    </c:if>
                </form>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>Mã danh mục</th>
                        <th>Tên danh mục</th>
                        <th>Mô tả</th>
                        <sec:authorize access="hasRole('ADMIN')">
                            <th>Thao tác</th>
                        </sec:authorize>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="category" items="${categories}">
                        <tr>
                            <td>${category.id}</td>
                            <td>${category.name}</td>
                            <td>${category.description}</td>
                            <sec:authorize access="hasRole('ADMIN')">
                                <td class="action-links">
                                    <a href="/admin/categories/update/${category.id}" class="edit-link">Sửa</a>
                                    <a href="/admin/categories/delete/${category.id}" class="delete-link"
                                        onclick="return confirm('Bạn có chắc chắn muốn xóa danh mục này?');">
                                        Xóa</a>
                                </td>
                            </sec:authorize>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
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
                            <a href="/admin/categories?page=0&keyword=${param.keyword}" class="btn-page">1</a>
                            <c:if test="${begin > 1}">
                                <span style="color: #94a3b8; padding: 0 4px;">...</span>
                            </c:if>
                        </c:if>

                        <%-- Vòng lặp các số trang ở giữa --%>
                        <c:forEach begin="${begin}" end="${end}" var="i">
                            <a href="/admin/categories?page=${i}&keyword=${param.keyword}" 
                            class="btn-page ${i == currentPage ? 'active' : ''}">${i + 1}</a>
                        </c:forEach>

                        <%-- Dấu ... và trang cuối --%>
                        <c:if test="${end < totalPages - 1}">
                            <c:if test="${end < totalPages - 2}">
                                <span style="color: #94a3b8; padding: 0 4px;">...</span>
                            </c:if>
                            <a href="/admin/categories?page=${totalPages - 1}&keyword=${param.keyword}" class="btn-page">${totalPages}</a>
                        </c:if>
                    </div>
                </div>
            </c:if>
        </div>
    </div>

</body>
</html>