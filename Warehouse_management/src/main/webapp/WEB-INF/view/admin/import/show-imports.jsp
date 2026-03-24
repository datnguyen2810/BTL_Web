<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<% request.setAttribute("currentPage", "imports"); %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử nhập kho - Quản lý kho</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/style-import.css">
</head>
<body>

    <jsp:include page="../layout/sidebar.jsp" />

    <div class="main-content">
        <h1 class="page-header">Lịch sử nhập kho</h1>

        <form class="toolbar" action="/admin/imports" method="get">
            <div class="search-box">
                <i class="fas fa-search"></i>
                <input type="text" name="importId" value="${param.importId}" placeholder="Tìm kiếm theo mã phiếu (ví dụ: NK001)...">
            </div>

            <div class="filter-box">
                <select name="userId" onchange="this.form.submit()">
                    <option value="">Tất cả người thực hiện</option>
                    <c:forEach var="user" items="${users}">
                        <option value="${user.id}" 
                            <c:if test="${user.id==selectedUserId}">selected="selected"</c:if>>
                            ${user.fullName}</option>>
                    </c:forEach>
                </select>
            </div>

            <div class="action-box">
                <a href="/admin/imports/create" class="btn-create-import">
                    <i class="fas fa-plus"></i> Tạo phiếu nhập
                </a>
            </div>
                <!-- <button style="padding: 10px 15px; background-color: #f1f5f9; border: 1px solid #e2e8f0; border-radius: 8px; color: #64748b; cursor: pointer; transition: 0.3s;">
                    <i class="fas fa-sync-alt"></i> Làm mới
                </button> -->
        </form>
        
        <div class="data-card">
            <table>
                <thead>
                    <tr>
                        <th>Mã phiếu</th>
                        <th>Ngày nhập</th>
                        <th>Người thực hiện</th>
                        <th>Tổng tiền (VNĐ)</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="importItem" items="${imports}">
                        <tr>
                            <td>${importItem.id}</td>
                            <td>${importItem.getDate()}</td>
                            <td>${importItem.userImport.fullName}</td>
                            <td><strong>${importItem.getTotalAmount()}đ</strong></td>
                            <td class="action-links">
                                <a href="/admin/imports/${importItem.id}" class="detail-link">Chi tiết</a>
                                <!-- <a href="/admin/imports/edit/${importItem.id}" class="edit-link">Sửa</a> -->
                                <sec:authorize access="hasRole('ADMIN')">
                                    <a href="/admin/imports/delete/${importItem.id}" class="delete-link" 
                                    onclick="return confirm('Cảnh báo: Xóa phiếu nhập sẽ làm thay đổi số lượng kho! Bạn chắc chắn chứ?')">
                                    Xóa</a>
                                </sec:authorize>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <!-- <div class="pagination">
                <div class="page-node active">1</div>
                <div class="page-node">2</div>
            </div> -->
        </div>
    </div>

</body>
</html>