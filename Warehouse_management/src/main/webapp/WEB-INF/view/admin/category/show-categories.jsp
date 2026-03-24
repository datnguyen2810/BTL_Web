<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<% request.setAttribute("currentPage", "categories"); %>
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
            <sec:authorize access="hasRole('ADMIN')">
                <button class="btn-add" onclick="window.location.href='/admin/categories/create'">
                    <i class="fas fa-plus"></i> Thêm danh mục mới
                </button>
            </sec:authorize>

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
        </div>
    </div>

</body>
</html>