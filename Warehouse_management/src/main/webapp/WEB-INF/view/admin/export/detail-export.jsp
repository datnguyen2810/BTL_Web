<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết phiếu xuất #${exportTicket.id}</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="/css/style.css">
    <style>
        .container { max-width: 1000px; margin: 30px auto; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #edf2f7; padding-bottom: 20px; margin-bottom: 20px; }
        .info-section { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 30px; }
        .info-box p { margin: 5px 0; color: #4a5568; }
        .info-box b { color: #2d3748; }
        table { width: 100%; border-collapse: collapse; }
        th { background: #f8fafc; padding: 12px; text-align: center; border-bottom: 2px solid #e2e8f0; }
        td { padding: 12px; border-bottom: 1px solid #edf2f7; }
        .total-amount { text-align: right; margin-top: 20px; font-size: 1.2em; font-weight: bold; color: #38a169; }
    </style>
</head>
<body>

<div class="container">
    <div class="header">
        <h2>Phiếu xuất kho #${exportTicket.id}</h2>
        <a href="/admin/exports" class="btn-back" style="text-decoration: none; color: #64748b;">
            <i class="fas fa-arrow-left"></i> Quay lại
        </a>
    </div>

    <div class="info-section">
        <div class="info-box">
            <p>Người thực hiện: <b>${not empty exportTicket.userExport ? exportTicket.userExport.fullName : 'Hệ thống'}</b></p>
            <p>Mã nhân viên: <b>${exportTicket.userExport.id}</b></p>
        </div>
        <div class="info-box" style="text-align: right;">
            <p>Ngày xuất: <b>${exportTicket.date}</b></p>
            <!-- <p>Trạng thái: <b style="color: #38a169;">Hoàn thành</b></p> -->
        </div>
    </div>

    <table>
        <thead>
            <tr>
                <th>Mã vật tư</th>
                <th>Tên vật tư</th>
                <th>Số lượng xuất</th>
                <th>Đơn giá xuất</th>
                <th>Thành tiền</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="dt" items="${details}">
                <tr>
                    <td>${dt.material.id}</td>
                    <td>${dt.material.name}</td>
                    <td>${dt.export_quantity}</td>
                    <td><fmt:formatNumber value="${dt.export_price}" type="number"/>đ</td>
                    <td><b><fmt:formatNumber value="${dt.export_quantity * dt.export_price}" type="number"/>đ</b></td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <div class="total-amount">
        Tổng giá trị xuất: <b>${exportTicket.getTotalAmount()}đ</b>
    </div>
</div>

</body>
</html>