<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> <%@ taglib prefix="form"
uri="http://www.springframework.org/tags/form" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm người dùng mới</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-green: #10b981; /* Màu xanh lá đặc trưng của nút Thêm người dùng */
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
            min-height: 100vh;
            margin: 0;
            padding: 20px;
        }

        .form-card {
            background: #ffffff;
            width: 100%;
            max-width: 650px;
            padding: 35px;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
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
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid var(--border-color);
            border-radius: 8px; /* Bo góc đồng bộ với hệ thống */
            font-size: 14px;
            color: var(--text-main);
            outline: none;
            box-sizing: border-box;
            transition: border-color 0.3s;
        }

        .form-group input:focus, 
        .form-group select:focus {
            border-color: var(--primary-green);
        }

        .btn-group {
            display: flex;
            gap: 12px;
            margin-top: 30px;
        }

        .btn-submit {
            flex: 2;
            background-color: var(--primary-green);
            color: white;
            padding: 12px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s;
        }

        .btn-submit:hover {
            background-color: #059669;
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
            <h2><i class="fas fa-user-plus"></i> Thêm người dùng mới</h2>
        </div>

        <form:form action="/admin/users/create" method="POST" modelAttribute="newUser">
            <div class="form-grid">
                <div class="form-group full-width">
                    <label for="fullname">Họ và tên</label>
                    <form:input type="text" id="fullname" path="fullName" placeholder="Nhập họ tên đầy đủ..." required="true"/>
                </div>

                <div class="form-group">
                    <label for="email">Email</label>
                    <form:input type="email" id="email" path="email" placeholder="example@company.com" required="true"/>
                </div>

                <div class="form-group">
                    <label for="password">Mật khẩu</label>
                    <form:input type="password" id="password" path="password" placeholder="••••••••" required="true"/>
                </div>

                <div class="form-group">
                    <label for="age">Tuổi</label>
                    <form:input type="number" id="age" path="age" min="0" max="100" placeholder="Ví dụ: 25" required="true"/>
                </div>

                <div class="form-group">
                    <label for="role">Vai trò (Role)</label>
                    <form:select id="role" path="role.id" required="true">
                        <form:option value="">Chọn vai trò</form:option>
                        <form:option value="1">Admin</form:option>
                        <form:option value="2">User</form:option>
                    </form:select>
                </div>

                <div class="form-group full-width">
                    <label for="address">Địa chỉ</label>
                    <form:textarea id="address" path="address" rows="3" placeholder="Nhập địa chỉ cư trú..."></form:textarea>
                </div>
            </div>

            <div class="btn-group">
                <button type="submit" class="btn-submit">Tạo tài khoản</button>
                <a href="javascript:history.back()" class="btn-cancel">Hủy bỏ</a>
            </div>
        </form:form>
    </div>

</body>
</html>