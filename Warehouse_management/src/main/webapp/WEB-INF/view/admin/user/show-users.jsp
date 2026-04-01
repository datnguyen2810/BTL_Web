<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<% request.setAttribute("activeMenu", "users"); %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý tài khoản - Hệ thống Kho</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/style-user-management.css">
</head>
<body>
    <jsp:include page="../layout/sidebar.jsp" />

    <div class="main-content">
        <h1 class="page-header">Quản lý tài khoản</h1>

        <div class="data-card">
            <div class="header-actions" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                <%-- Nút thêm mới bên trái --%>
                <button class="btn-add-user" id="btnAddUser" onclick="window.location.href='/admin/users/create'" style="margin-bottom: 0;">
                    <i class="fas fa-plus"></i> Thêm người dùng mới
                </button>

                <%-- Thanh tìm kiếm bên phải (Tìm theo tên hoặc Email) --%>
                <form action="/admin/users" method="GET" style="display: flex; gap: 10px;">
                    <div class="search-box" style="position: relative;">
                        <input type="text" name="keyword" value="${param.keyword}" placeholder="Tìm kiếm theo tên hoặc email..." 
                            style="padding: 10px 15px 10px 35px; border: 1px solid #e2e8f0; border-radius: 8px; width: 250px;">
                        <i class="fas fa-search" style="position: absolute; left: 12px; top: 12px; color: #94a3b8;"></i>
                    </div>
                    <button type="submit" class="btn-search" style="background: #2563eb; color: white; border: none; padding: 10px 20px; border-radius: 8px; cursor: pointer;">
                        Tìm kiếm
                    </button>
                    <c:if test="${not empty param.keyword}">
                        <a href="/admin/users" class="btn-clear" style="padding: 10px; color: #64748b; text-decoration: none;">
                            <i class="fas fa-times"></i>
                        </a>
                    </c:if>
                </form>
            </div>

            <table>
                <thead>
                    <tr>
                        <th>Id</th>
                        <th>Email</th>
                        <th>Fullname</th>
                        <th>Address</th>
                        <th>Role</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="user" items="${users}">
                        <tr>
                            <td>${user.id}</td>
                            <td>${user.email}</td>
                            <td>${user.fullName}</td>
                            <td>${user.address}</td>
                            <td>${user.role.name}</td>
                            <td class="action-links">
                                <a href="/admin/users/update/${user.id}" class="edit-link">Sửa</a>
                                <c:if test="${user.id != currentUser.id}">
                                    <a href="/admin/users/delete/${user.id}"
                                        class="delete-link"
                                        onclick="return confirm('Bạn có chắc muốn xóa người dùng này không?')">
                                        Xóa
                                    </a>
                                </c:if>
                            </td>
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
                            <a href="/admin/users?page=0&keyword=${param.keyword}" class="btn-page">1</a>
                            <c:if test="${begin > 1}">
                                <span style="color: #94a3b8; padding: 0 4px;">...</span>
                            </c:if>
                        </c:if>

                        <%-- Vòng lặp các số trang ở giữa --%>
                        <c:forEach begin="${begin}" end="${end}" var="i">
                            <a href="/admin/users?page=${i}&keyword=${param.keyword}" 
                            class="btn-page ${i == currentPage ? 'active' : ''}">${i + 1}</a>
                        </c:forEach>

                        <%-- Dấu ... và trang cuối --%>
                        <c:if test="${end < totalPages - 1}">
                            <c:if test="${end < totalPages - 2}">
                                <span style="color: #94a3b8; padding: 0 4px;">...</span>
                            </c:if>
                            <a href="/admin/users?page=${totalPages - 1}&keyword=${param.keyword}" class="btn-page">${totalPages}</a>
                        </c:if>
                    </div>
                </div>
            </c:if>
    </div>


</body>
</html>