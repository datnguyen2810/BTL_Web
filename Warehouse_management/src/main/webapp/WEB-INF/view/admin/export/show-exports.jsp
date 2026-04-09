<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<% request.setAttribute("activeMenu", "exports"); %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử xuất kho - Quản lý kho</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/style-export.css">
</head>
<body>
    <style>
        /* Container chính chứa toàn bộ các cột */
        .chart-container {
            display: flex;
            align-items: flex-end;    /* Quan trọng: Để các cột bám đáy mọc lên */
            justify-content: space-around;
            height: 300px;           /* Chiều cao cố định của biểu đồ */
            border-bottom: 2px solid #e5e7eb;
            padding: 30px 10px 10px 10px;
            margin-top: 20px;
            position: relative;
            background-color: #ffffff;
        }

        /* Bao quanh một cột và nhãn phía dưới */
        .bar-wrapper {
            display: flex;
            flex-direction: column;
            align-items: center;
            width: 50px;             /* Độ rộng của khu vực mỗi cột */
            height: 100%;
            justify-content: flex-end;
        }

        /* Hình dáng của cột */
        .bar {
            width: 100%;             /* Chiếm hết độ rộng bar-wrapper */
            background: linear-gradient(to top, #3b82f6, #60a5fa); /* Đổ màu gradient cho hiện đại */
            border-radius: 6px 6px 0 0;
            position: relative;
            transition: all 0.3s ease; /* Hiệu ứng mượt mà khi thay đổi chiều cao hoặc hover */
            cursor: pointer;
        }

        /* Hiệu ứng khi di chuột vào cột */
        .bar:hover {
            background: #2563eb;     /* Đổi màu đậm hơn */
            transform: scaleX(1.05); /* Giãn nhẹ chiều ngang */
        }

        /* Giá trị con số hiển thị trên đầu cột */
        .bar-value {
            position: absolute;
            top: -25px;              /* Đẩy số lên trên đỉnh cột */
            left: 50%;
            transform: translateX(-50%);
            font-size: 11px;
            font-weight: 700;
            color: #1e293b;
            white-space: nowrap;     /* Không cho nhảy dòng nếu số dài */
        }

        /* Nhãn Ngày/Tháng/Năm phía dưới đáy */
        .bar-label {
            margin-top: 12px;
            font-size: 12px;
            font-weight: 500;
            color: #64748b;
            text-align: center;
            width: 100%;
            overflow: hidden;
            text-overflow: ellipsis; /* Nếu nhãn quá dài sẽ hiện dấu ... */
        }

        /* Responsive: Tự động thu nhỏ cột trên màn hình điện thoại */
        @media (max-width: 768px) {
            .chart-container {
                height: 200px;
            }
            .bar-wrapper {
                width: 30px;
            }
            .bar-label {
                font-size: 10px;
            }
        }
    </style>

    <jsp:include page="../layout/sidebar.jsp" />

    <div class="main-content">
        <h1 class="page-header">Lịch sử xuất kho</h1>

        <form class="toolbar" action="/admin/exports" method="get">
            <div class="search-box">
                <i class="fas fa-search"></i>
                <input type="text" name="exportCode" value="${param.exportCode}" placeholder="Tìm kiếm theo mã phiếu (ví dụ: XK001)...">    
            </div>

            <div class="filter-box">
                <select name="userId" onchange="this.form.submit()">
                    <option value="">Tất cả người thực hiện</option>
                    <c:forEach var="user" items="${users}">
                        <option value="${user.id}" 
                            <c:if test="${user.id==selectedUserId}">selected="selected"</c:if>>
                            ${user.fullName}</option>
                    </c:forEach>
                </select>
            </div>

            <!-- <button style="padding: 10px 15px; background-color: #f1f5f9; border: 1px solid #e2e8f0; border-radius: 8px; color: #64748b; cursor: pointer; transition: 0.3s;">
                <i class="fas fa-sync-alt"></i> Làm mới
            </button> -->
            <div class="action-box">
                <a href="/admin/exports/create" class="btn-create-export">
                    <i class="fas fa-plus"></i> Tạo phiếu xuất
                </a>
            </div>

        </form>

        <div class="data-card" modelAttribute="exports">
            <table>
                <thead>
                    <tr>
                        <th>Mã phiếu</th>
                        <th>Ngày xuất</th>
                        <th>Người thực hiện</th>
                        <th>Số lượng vật tư</th>
                        <th>Tổng tiền</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="export" items="${exports}">
                        <tr>
                            <td>${export.code}</td>
                            <td>${export.date}</td>
                            <td>${export.userExport.fullName}</td>
                            <td><strong>${export.totalItems}</strong></td>
                            <td><strong>${export.totalAmount}</strong></td>
                            <td class="action-links">
                                <a href="/admin/exports/${export.id}" class="detail-link">Chi tiết</a>

                                <sec:authorize access="hasRole('ADMIN')">
                                    <!-- <a href="/admin/exports/edit/${export.id}" class="edit-link">Sửa</a> -->
                                    <a href="/admin/exports/delete/${export.id}" class="delete-link" 
                                        onclick="return confirm('Cảnh báo: Xóa phiếu xuất sẽ làm thay đổi số lượng kho! Bạn chắc chắn chứ?')">
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
                            <a href="/admin/exports?page=0&userId=${selectedUserId}&exportCode=${param.exportCode}" class="btn-page">1</a>
                            <c:if test="${begin > 1}">
                                <span style="color: #94a3b8; padding: 0 4px;">...</span>
                            </c:if>
                        </c:if>

                        <%-- Vòng lặp các số trang ở giữa --%>
                        <c:forEach begin="${begin}" end="${end}" var="i">
                            <a href="/admin/exports?page=${i}&userId=${selectedUserId}&exportCode=${param.exportCode}" 
                            class="btn-page ${i == currentPage ? 'active' : ''}">${i + 1}</a>
                        </c:forEach>

                        <%-- Dấu ... và trang cuối --%>
                        <c:if test="${end < totalPages - 1}">
                            <c:if test="${end < totalPages - 2}">
                                <span style="color: #94a3b8; padding: 0 4px;">...</span>
                            </c:if>
                            <a href="/admin/exports?page=${totalPages - 1}&userId=${selectedUserId}&exportCode=${param.exportCode}" class="btn-page">${totalPages}</a>
                        </c:if>
                    </div>
                </div>
            </c:if>
        </div>
        <div class="data-card" style="margin-top: 30px; padding: 25px;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px;">
                <h2 style="font-size: 1.2rem; font-weight: 600; color: #1e293b; margin: 0;">
                    <i class="fas fa-chart-line" style="margin-right: 8px; color: #3b82f6;"></i>
                    Thống kê giá trị xuất kho
                </h2>
                
                <form action="/admin/exports" method="get" style="display: flex; gap: 10px;">
                    <select name="statType" onchange="this.form.submit()" style="padding: 6px 12px; border-radius: 6px; border: 1px solid #e2e8f0; font-size: 14px;">
                        <option value="DATE" ${param.statType == 'DATE' ? 'selected' : ''}>Theo Ngày (7 ngày gần nhất)</option>
                        <option value="MONTH" ${param.statType == 'MONTH' || param.statType == null ? 'selected' : ''}>Theo Tháng (Năm nay)</option>
                        <option value="YEAR" ${param.statType == 'YEAR' ? 'selected' : ''}>Theo Năm</option>
                    </select>
                    <input type="hidden" name="exportCode" value="${param.exportCode}">
                    <input type="hidden" name="userId" value="${param.userId}">
                </form>
            </div>

            <div class="chart-container">
                <c:choose>
                    <c:when test="${not empty exportStats}">
                        <c:forEach var="stat" items="${exportStats}">
                            <%-- Tính toán chiều cao cột --%>
                            <c:set var="height" value="${maxAmount > 0 ? (stat.amount / maxAmount * 100) : 0}" />
                            
                            <div class="bar-wrapper">
                                <div class="bar" style='height: <c:out value="${height}"/>%;'>
                                    <span class="bar-value">
                                        <c:choose>
                                            <c:when test="${stat.amount >= 1000000}">
                                                ${String.format("%.1fM", stat.amount/1000000)}
                                            </c:when>
                                            <c:otherwise>
                                                ${String.format("%.0f", stat.amount)}
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <span class="bar-label">${stat.label}</span>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div style="width: 100%; height: 200px; display: flex; align-items: center; justify-content: center; color: #94a3b8; font-style: italic;">
                            Không có dữ liệu thống kê trong khoảng thời gian này.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>


</body>
</html>