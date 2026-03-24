<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm vật tư mới</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-blue: #3b82f6; /* Màu xanh nút bấm đồng bộ */
            --bg-body: #f8fafc;
            --text-main: #1e293b;
            --border-color: #e2e8f0;
        }

        body {
            font-family: 'Segoe UI', Tahoma, sans-serif;
            background-color: var(--bg-body);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .form-card {
            background: #ffffff;
            width: 100%;
            max-width: 600px;
            padding: 35px;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05); /* Bo góc và đổ bóng nhẹ */
        }

        .form-header {
            margin-bottom: 25px;
            text-align: center;
        }

        .form-header h2 {
            margin: 0;
            color: var(--text-main);
            font-size: 24px;
            font-weight: 700;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .full-width {
            grid-column: span 2;
        }

        .form-group label {
            display: block;
            font-weight: 600;
            color: #64748b;
            margin-bottom: 8px;
            font-size: 14px;
        }

        .form-group input, 
        .form-group select {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid var(--border-color);
            border-radius: 8px; /* Bo góc input đồng nhất */
            font-size: 14px;
            color: var(--text-main);
            outline: none;
            box-sizing: border-box;
            transition: border-color 0.3s;
        }

        .form-group input:focus, 
        .form-group select:focus {
            border-color: var(--primary-blue);
        }

        .btn-group {
            display: flex;
            gap: 12px;
            margin-top: 30px;
        }

        .btn-submit {
            flex: 2;
            background-color: var(--primary-blue);
            color: white;
            padding: 12px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s;
        }

        .btn-submit:hover {
            background-color: #2563eb;
        }

        .btn-cancel {
            flex: 1;
            background-color: #f1f5f9;
            color: #64748b;
            padding: 12px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            text-align: center;
            text-decoration: none;
            cursor: pointer;
        }

        .btn-cancel:hover {
            background-color: #e2e8f0;
        }
    </style>
</head>
<body>

    <div class="form-card">
        <div class="form-header">
            <h2><i class="fas fa-box"></i> Thêm vật tư mới</h2>
        </div>

        <form:form action="/admin/materials/create" method="POST" modelAttribute="material">
            <div class="form-grid">
                <div class="form-group full-width">
                    <label for="material_name">Tên vật tư</label>
                    <form:input type="text" id="material_name" path="name" placeholder="Nhập tên vật tư..." required="true"/>
                </div>

                <div class="form-group">
                    <label for="category">Danh mục</label>
                    <form:select id="category" path="category" required="true">
                        <!-- <form:option value="">-- Chọn danh mục --</form:option> -->
                        <!-- items="${categories}": lấy danh sách category từ model.addAttribute("categories", ...).
                        itemValue="id": giá trị của mỗi <option value="..."> là id.
                        itemLabel="name": chữ hiển thị của option là name. -->
                        <form:options items="${categories}" itemValue="id" itemLabel="name"/>
                    </form:select>
                </div>

                <div class="form-group">
                    <label for="unit">Đơn vị tính</label>
                    <form:input type="text" id="unit" path="unit" placeholder="Cái, Thanh, Ram..." required="true"/>
                </div>
            </div>

            <div class="btn-group">
                <button type="submit" class="btn-submit">Lưu vật tư</button>
                <a href="javascript:history.back()" class="btn-cancel">Quay lại</a>
            </div>
        </form:form>
    </div>

</body>
</html>