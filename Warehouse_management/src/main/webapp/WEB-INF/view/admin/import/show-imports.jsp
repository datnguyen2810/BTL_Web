<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<% request.setAttribute("activeMenu", "imports"); %>
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

        <h1 class="page-header">Lịch sử nhập kho</h1>

        <form class="toolbar" action="/admin/imports" method="get">
            <div class="search-box">
                <i class="fas fa-search"></i>
                <input type="text" name="importCode" value="${param.importCode}" placeholder="Tìm kiếm theo mã phiếu (ví dụ: NK001)...">
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
                            <td>${importItem.getCode()}</td>
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
                            <a href="/admin/imports?page=0&categoryId=${selectedCategoryId}&keyword=${param.keyword}" class="btn-page">1</a>
                            <c:if test="${begin > 1}">
                                <span style="color: #94a3b8; padding: 0 4px;">...</span>
                            </c:if>
                        </c:if>

                        <%-- Vòng lặp các số trang ở giữa --%>
                        <c:forEach begin="${begin}" end="${end}" var="i">
                            <a href="/admin/imports?page=${i}&categoryId=${selectedCategoryId}&keyword=${param.keyword}" 
                            class="btn-page ${i == currentPage ? 'active' : ''}">${i + 1}</a>
                        </c:forEach>

                        <%-- Dấu ... và trang cuối --%>
                        <c:if test="${end < totalPages - 1}">
                            <c:if test="${end < totalPages - 2}">
                                <span style="color: #94a3b8; padding: 0 4px;">...</span>
                            </c:if>
                            <a href="/admin/imports?page=${totalPages - 1}&categoryId=${selectedCategoryId}&keyword=${param.keyword}" class="btn-page">${totalPages}</a>
                        </c:if>
                    </div>
                </div>
            </c:if>
        </div>
    </div>

</body>
</html>