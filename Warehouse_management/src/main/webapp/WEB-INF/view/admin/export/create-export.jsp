<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tạo phiếu xuất kho - Quản lý kho</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/style-create-export.css">
</head>
<body>

    <div class="main-content">
        <div class="page-header">
            <h1>Tạo phiếu xuất kho</h1>
            <div>
                <span style="font-size: 14px; color: #64748b;">Ngày xuất: </span>
                <input type="text" class="date-input" value="${displayDate}" readonly>
            </div>
        </div>

        <div class="export-container">
            <div class="card">
                <c:if test="${not empty stockError}">
                    <div style="color: #ef4444; margin-bottom: 10px; font-size: 14px;">
                        <i class="fas fa-exclamation-circle"></i> ${stockError}
                    </div>
                </c:if>

                <form action="/admin/exports/add-temp" method="post" >
                    <h3>Thêm vật tư xuất</h3>
                    <div class="form-group">
                        <label>Chọn mã vật tư</label>
                        <select name="materialId">
                            <option value="">Chọn vật tư...</option>
                            <c:forEach var="material" items="${materials}">
                                <option value = "${material.id}">${material.name} (ID: ${material.id})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Số lượng</label>
                        <input type="number" name="quantity" placeholder="Nhập số lượng xuất" min="1" step="1" required>
                    </div>
                    <div class="form-group">
                        <label>Giá xuất (VNĐ)</label>
                        <input type="number" name="price" placeholder="Nhập giá xuất" min="0" required>
                    </div>

                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                    <button class="btn-add-temp">Thêm vào danh sách tạm</button>
                    <span class="stock-warning">* Hệ thống sẽ kiểm tra tồn kho trước khi thêm</span>
                </form>
            </div>

            <div class="card">
                <div class="table-header">
                    <h3>Chi tiết phiếu xuất (Chưa lưu)</h3>
                    <div class="total-preview">
                        Tổng: <fmt:formatNumber value="${grandTotal}" type="number" />đ
                    </div>
                </div>
                <table>
                    <thead>
                        <tr>
                            <th>Mã vật tư</th>
                            <th>Tên vật tư</th>
                            <th>Số lượng</th>
                            <th>Giá xuất</th>
                            <th>Thành tiền</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${empty tempList}">
                            <tr>
                                <td colspan="6" style="text-align: center; color: #94a3b8; padding: 40px;">
                                    Chưa có vật tư nào trong danh sách xuất.
                                </td>
                            </tr>
                        </c:if>
                        <c:forEach var="item" items="${tempList}" varStatus="status">
                            <tr>
                                <td>${item.material.id}</td>
                                <td>${item.material.name}</td>
                                <td>${item.export_quantity}</td>
                                <td><fmt:formatNumber value="${item.export_price}" type="number"/></td>
                                <td><strong><fmt:formatNumber value="${item.export_quantity * item.export_price}" type="number"/></strong></td>
                                <td style="text-align: center;">
                                    <a href="/admin/exports/remove-temp/${status.index}" 
                                        class="btn-delete-item" onclick="return confirm('Bạn có chắc muốn xóa dòng này?')">
                                        <i class="fas fa-trash-alt"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <form action="/admin/exports/save-final" method="post">
                    
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="btn-submit-export" 
                            <c:if test="${empty tempList}">disabled style="background:#ccc"</c:if>>
                        Lưu phiếu xuất
                    </button>
                </form>
            </div>
        </div>
    </div>

</body>
</html>