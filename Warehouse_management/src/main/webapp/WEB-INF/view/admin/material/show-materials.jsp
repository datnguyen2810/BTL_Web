<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<% request.setAttribute("currentPage", "materials"); %>
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
        </div>
    </div>

</body>
</html>