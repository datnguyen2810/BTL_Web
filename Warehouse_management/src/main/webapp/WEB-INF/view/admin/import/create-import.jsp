
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tạo phiếu nhập kho - Quản lý kho</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/style-create-import.css">
</head>
<body>

    <div class="main-content">
        <div class="page-header">
            <h1>Tạo phiếu nhập kho</h1>
            <div>
                <span style="font-size: 14px; color: #64748b;">Ngày nhập: </span>
                <input type="text" class="date-input" value="${displayDate}" readonly>
            </div>
        </div>

        <div class="import-container">
            <div class="card">
                <form action="/admin/imports/add-temp" method="post">
                    <h3>Thêm vật tư vào phiếu</h3>
                    <div class="form-group">
                        <label>Chọn vật tư</label>
                        <select name="materialId" required>
                            <option value="">Chọn vật tư...</option>
                            <c:forEach var="material" items="${materials}">
                                <option value="${material.id}">${material.name} (ID: ${material.id})</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Số lượng</label>
                        <input type="number" name="quantity" min="1" step="1" value="1" required>
                    </div>
                    <div class="form-group">
                        <label>Đơn giá nhập (VNĐ)</label>
                        <input type="number" name="price" placeholder="Nhập giá nhập..." min="0" required>
                    </div>

                    <!-- Thêm token CSRF vào form -->
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                    <button type="submit" class="btn-add-temp">
                        <i class="fas fa-plus"></i> Thêm vào danh sách tạm
                    </button>
                </form>
            </div>

            <div class="card">
                <div class="table-header">
                    <h3>Chi tiết phiếu nhập (Chưa lưu)</h3>
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
                            <th>Đơn giá</th>
                            <th>Thành tiền</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:if test="${empty tempList}">
                            <tr>
                                <td colspan="6" style="text-align: center; color: #94a3b8; padding: 40px;">
                                    <i class="fas fa-box-open" style="display:block; font-size: 24px; margin-bottom: 10px;"></i>
                                    Chưa có vật tư nào trong danh sách tạm.
                                </td>
                            </tr>
                        </c:if>
                        <c:forEach var="item" items="${tempList}" varStatus="status">
                            <tr>
                                <td>${item.material.id}</td>
                                <td>${item.material.name}</td>
                                <td>${item.import_quantity}</td>
                                <td><fmt:formatNumber value="${item.import_price}" type="number" /></td>
                                <td><strong><fmt:formatNumber value="${item.import_quantity * item.import_price}" type="number" /></strong></td>
                                <td style="text-align: center;">
                                    <a href="/admin/imports/remove-temp/${status.index}" 
                                       class="btn-delete-item" onclick="return confirm('Bạn có chắc muốn xóa dòng này?')">
                                        <i class="fas fa-trash-alt"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <form action="/admin/imports/save-final" method="POST" style="margin-top: 20px; text-align: right;">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="btn-submit-all" 
                            <c:if test="${empty tempList}">disabled style="background: #cbd5e1; cursor: not-allowed;"</c:if>>
                        <i class="fas fa-check-circle"></i> Lưu phiếu nhập
                    </button>
                </form>
            </div>
        </div>
    </div>

</body>
</html>