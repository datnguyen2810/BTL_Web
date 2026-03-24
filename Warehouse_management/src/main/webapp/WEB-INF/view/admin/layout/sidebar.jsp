<!-- <%-- Sidebar Fragment - Include này vào các trang để dùng chung sidebar --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="sidebar">
    <div class="sidebar-header">Quản lý kho vật tư</div>
    <a href="/admin/dashboard" class="nav-item ${currentPage == 'dashboard' ? 'active' : ''}"><i class="fas fa-chart-line"></i> Dashboard</a>
    <a href="/admin/categories" class="nav-item ${currentPage == 'categories' ? 'active' : ''}"><i class="fas fa-list"></i> Danh mục</a>
    <a href="/admin/materials" class="nav-item ${currentPage == 'materials' ? 'active' : ''}"><i class="fas fa-box"></i> Vật tư</a>
    <a href="/admin/imports" class="nav-item ${currentPage == 'imports' ? 'active' : ''}"><i class="fas fa-file-import"></i> Nhập kho</a>
    <a href="/admin/exports" class="nav-item ${currentPage == 'exports' ? 'active' : ''}"><i class="fas fa-file-export"></i> Xuất kho</a>
    <a href="/admin/inventory-report" class="nav-item ${currentPage == 'inventory-report' ? 'active' : ''}"><i class="fas fa-warehouse"></i> Báo cáo tồn kho</a>
    <a href="/admin/users" class="nav-item ${currentPage == 'users' ? 'active' : ''}"><i class="fas fa-users-cog"></i> Quản lý người dùng</a>
    <a href="/logout" class="nav-item logout"><i class="fas fa-sign-out-alt"></i> Đăng xuất</a>
</div> -->

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<div class="sidebar">
    <div class="sidebar-header">QUẢN LÝ KHO VẬT TƯ</div>
    
    <div class="user-profile" style="padding: 15px; border-top: 1px solid #374151; margin-top: 0px;">
        <div style="display: flex; align-items: center; gap: 10px;">
            <i class="fas fa-user-circle" style="font-size: 24px; color: #9ca3af;"></i>
            <div>
                <%-- Lấy username (email) mặc định từ Security --%>
                <p style="font-size: 14px; font-weight: 600; margin: 0;">
                    <sec:authentication property="principal.username" />
                </p>
                <p style="font-size: 12px; color: #9ca3af; margin: 0;">
                    <sec:authorize access="hasRole('ADMIN')">Quản trị viên</sec:authorize>
                    <sec:authorize access="hasRole('USER')">Nhân viên kho</sec:authorize>
                </p>
            </div>
        </div>
    </div>

    <a href="/admin/dashboard" class="nav-item ${currentPage == 'dashboard' ? 'active' : ''}">
        <i class="fas fa-chart-line"></i> Dashboard
    </a>

    <a href="/admin/categories" class="nav-item ${currentPage == 'categories' ? 'active' : ''}">
        <i class="fas fa-list"></i> Danh mục
    </a>

    <a href="/admin/materials" class="nav-item ${currentPage == 'materials' ? 'active' : ''}">
        <i class="fas fa-box"></i> Vật tư
    </a>

    <a href="/admin/imports" class="nav-item ${currentPage == 'imports' ? 'active' : ''}">
        <i class="fas fa-file-import"></i> Nhập kho
    </a>

    <a href="/admin/exports" class="nav-item ${currentPage == 'exports' ? 'active' : ''}">
        <i class="fas fa-file-export"></i> Xuất kho
    </a>

    <a href="/admin/inventory-report" class="nav-item ${currentPage == 'inventory-report' ? 'active' : ''}">
        <i class="fas fa-warehouse"></i> Báo cáo tồn kho
    </a>

    <sec:authorize access="hasRole('ADMIN')">
        <a href="/admin/users" class="nav-item ${currentPage == 'users' ? 'active' : ''}">
            <i class="fas fa-users-cog"></i> Quản lý người dùng
        </a>
    </sec:authorize>

    <form action="/logout" method="post" id="logoutForm" style="display: none;">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    </form>


    <a href="javascript:void(0)" onclick="document.getElementById('logoutForm').submit()" class="nav-item logout">
        <i class="fas fa-sign-out-alt"></i> Đăng xuất
    </a>
</div>