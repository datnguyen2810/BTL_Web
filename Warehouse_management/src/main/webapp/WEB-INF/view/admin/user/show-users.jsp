<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<% request.setAttribute("currentPage", "users"); %>

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
            <button class="btn-add-user" id="btnAddUser" onclick="window.location.href='/admin/users/create'">
                <i class="fas fa-plus"></i> Thêm người dùng mới
            </button>

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
                    <!-- <c:forEach items="${users}" var="user">
                        <tr>
                            <td>${user.id}</td>
                            <td>${user.email}</td>
                            <td>${user.fullName}</td>
                            <td>${user.address}</td>
                            <td>${user.role.name}</td> -->
                            <!-- <td><span class="badge badge-admin">Admin</span></td> -->
                            <!-- <td class="action-links">
                                <a href="/admin/users/update/${user.id}" class="edit-link">Sửa</a>
                                <a href="/admin/users/delete/${user.id}" 
                                    class="delete-link"
                                    onclick="return confirm('Bạn có chắc muốn xóa người dùng này không?')">
                                    Xóa
                                </a>
                            </td>
                        </tr>
                    </c:forEach> -->

                    <c:forEach var="user" items="${users}">
                        <tr>
                            <td>${user.id}</td>
                            <td>${user.email}</td>
                            <td>${user.fullName}</td>
                            <td>${user.address}</td>
                            <td>${user.role.name}</td>
                            <td class="action-links">
                                <a href="/admin/users/update/${user.id}" class="edit-link">Sửa</a>
                                <a href="/admin/users/delete/${user.id}"
                                    class="delete-link"
                                    onclick="return confirm('Bạn có chắc muốn xóa người dùng này không?')">
                                    Xóa
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                
                </tbody>
            </table>
        </div>
    </div>


</body>
</html>