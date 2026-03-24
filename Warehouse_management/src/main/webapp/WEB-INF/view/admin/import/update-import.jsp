<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Sửa phiếu nhập #${importTicket.id}</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="/css/style.css">
    <link rel="stylesheet" href="/css/style-create_import.css">
    <style>
        /* Tông màu cam cho chế độ Sửa */
        :root { --accent-edit: #f59e0b; }
        .page-header h1 { color: var(--accent-edit); }
        .btn-update-final {
            background-color: var(--accent-edit);
            color: white; border: none; padding: 12px 25px;
            border-radius: 8px; font-weight: 600; cursor: pointer;
        }
    </style>
</head>
<body>

    <div class="main-content">
        <div class="page-header">
            <h1><i class="fas fa-edit"></i> Chỉnh sửa phiếu nhập kho</h1>
            <a href="javascript:history.back()" style="text-decoration: none; color: #64748b;">
                <i class="fas fa-arrow-left"></i> Quay lại
            </a>
        </div>

        <div class="import-container">
            <div class="card">
                <h3>Thông tin chung</h3>
                <form action="/admin/imports/update-info" method="post">
                    <input type="hidden" name="id" value="${importTicket.id}">
                    <div class="form-group">
                        <label>Người thực hiện</label>
                        <select name="userId">
                            <c:forEach var="u" items="${users}">
                                <option value="${u.id}" ${u.id == importTicket.user.id ? 'selected' : ''}>
                                    ${u.fullName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Ngày nhập (Chỉ xem)</label>
                        <input type="text" value="${importTicket.date}" readonly style="background: #f1f5f9;">
                    </div>
                </form>

                <hr style="border: 0; border-top: 1px solid #e2e8f0; margin: 20px 0;">

                <h3>Thêm vật tư mới vào phiếu</h3>
                <form action="/admin/imports/edit/add-item" method="post">
                    <input type="hidden" name="importId" value="${importTicket.id}">
                    <div class="form-group">
                        <label>Vật tư</label>
                        <select name="materialId" required>
                            <c:forEach var="m" items="${materials}">
                                <option value="${m.id}">${m.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Số lượng</label>
                        <input type="number" name="quantity" min="1" value="1">
                    </div>
                    <div class="form-group">
                        <label>Đơn giá</label>
                        <input type="number" name="price" required>
                    </div>
                    <button type="submit" class="btn-add-temp" style="background: #64748b;">Thêm vào phiếu</button>
                </form>
            </div>

            <div class="card">
                <h3>Chi tiết vật tư trong phiếu</h3>
                <table>
                    <thead>
                        <tr>
                            <th>Mã VT</th>
                            <th>Tên vật tư</th>
                            <th>Số lượng</th>
                            <th>Đơn giá</th>
                            <th>Thành tiền</th>
                            <th>Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="dt" items="${importTicket.importDetails}">
                            <tr>
                                <td>${dt.material.id}</td>
                                <td>${dt.material.name}</td>
                                <td><b>${dt.import_quantity}</b></td>
                                <td><fmt:formatNumber value="${dt.import_price}" type="number"/></td>
                                <td><fmt:formatNumber value="${dt.import_quantity * dt.import_price}" type="number"/></td>
                                <td>
                                    <a href="/admin/imports/edit/remove-item/${dt.id}" 
                                       style="color: #ef4444;" onclick="return confirm('Xóa vật tư này khỏi phiếu?')">
                                        <i class="fas fa-times-circle"></i>
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <div style="text-align: right; margin-top: 30px;">
                    <h3 style="margin-bottom: 20px;">Tổng tiền: <b style="color: #10b981;">
                        <fmt:formatNumber value="${importTicket.total_amount}" type="number"/>đ</b>
                    </h3>
                    <form action="/admin/imports/edit/confirm" method="post">
                        <input type="hidden" name="importId" value="${importTicket.id}">
                        <button type="submit" class="btn-update-final">Xác nhận cập nhật phiếu</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

</body>
</html> 