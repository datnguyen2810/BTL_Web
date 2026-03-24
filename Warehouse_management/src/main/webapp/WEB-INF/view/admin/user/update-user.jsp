<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> <%@ taglib prefix="form"
uri="http://www.springframework.org/tags/form" %>


<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cập nhật người dùng</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --accent-orange: #f59e0b; /* Màu cam để phân biệt với form Thêm */
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
            border-bottom: 2px solid var(--bg-body);
            padding-bottom: 15px;
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

        /* Input ID để ở chế độ readonly */
        .form-group input[readonly] {
            background-color: #f1f5f9;
            cursor: not-allowed;
            color: #94a3b8;
        }

        .form-group input, 
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid var(--border-color);
            border-radius: 8px; /* Bo góc đồng bộ */
            font-size: 14px;
            color: var(--text-main);
            outline: none;
            box-sizing: border-box;
            transition: border-color 0.3s;
        }

        .form-group input:focus, 
        .form-group select:focus {
            border-color: var(--accent-orange);
        }

        .btn-group {
            display: flex;
            gap: 12px;
            margin-top: 30px;
        }

        .btn-update {
            flex: 2;
            background-color: var(--accent-orange);
            color: white;
            padding: 12px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: opacity 0.3s;
        }

        .btn-update:hover {
            opacity: 0.9;
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
    </style>
</head>
<body>

    <div class="form-card">
        <div class="form-header">
            <h2><i class="fas fa-user-edit"></i> Cập nhật người dùng</h2>
        </div>

        <form:form action="/admin/users/update" method="POST" modelAttribute="userDB">
            <div class="form-grid">
                <div class="form-group">
                    <label for="user_id">Mã người dùng (ID)</label>
                    <form:input type="text" id="user_id" path="id" readonly="true"/>
                </div>

                <div class="form-group">
                    <label for="fullname">Họ và tên</label>
                    <form:input type="text" id="fullname" path="fullName" required="true"/>
                </div>

                <div class="form-group">
                    <label for="email">Email</label>
                    <form:input type="email" id="email" path="email" required="true"/>
                </div>

                <div class="form-group">
                    <label for="password">Mật khẩu mới </label>
                    <form:input type="password" id="password" path="password" placeholder="••••••••" required="true"/>
                </div>

                <div class="form-group">
                    <label for="age">Tuổi</label>
                    <form:input type="number" id="age" path="age" min="0" max="100" required="true"/>
                </div>

                <div class="form-group">
                    <label for="role">Vai trò (Role)</label>
                    <form:select id="role" path="role.id" required="true">
                        <form:option value="1">Admin</form:option>
                        <form:option value="2">User</form:option>
                    </form:select>
                </div>

                <div class="form-group full-width">
                    <label for="address">Địa chỉ</label>
                    <form:textarea id="address" path="address" rows="3" required="true"></form:textarea>
                </div>
            </div>

            <div class="btn-group">
                <button type="submit" class="btn-update">Cập nhật thông tin</button>
                <a href="javascript:history.back()" class="btn-cancel">Quay lại</a>
            </div>
        </form:form>
    </div>

</body>
</html>
<!-- <html>
  <head>
    <title>Update User</title>

    <style>
      body {
        font-family: Arial, Helvetica, sans-serif;
        background: #f4f6f9;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
      }

      .form-container {
        background: white;
        padding: 30px;
        width: 350px;
        border-radius: 10px;
        box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
      }

      h2 {
        text-align: center;
        margin-bottom: 20px;
      }

      label {
        font-weight: 500;
      }

      input {
        width: 100%;
        padding: 10px;
        margin-top: 5px;
        margin-bottom: 15px;
        border: 1px solid #ccc;
        border-radius: 5px;
        font-size: 14px;
      }

      input:focus {
        border-color: #4caf50;
        outline: none;
      }

      button {
        width: 100%;
        padding: 12px;
        background: #2196f3;
        color: white;
        border: none;
        border-radius: 6px;
        font-size: 16px;
        cursor: pointer;
      }

      button:hover {
        background: #1976d2;
      }

      .cancel-btn {
        margin-top: 10px;
        display: block;
        text-align: center;
      }
    </style>
  </head>

  <body>
    <div class="form-container">
      <h2>Update User</h2>

      <form:form
        action="/admin/users/update"
        method="post"
        modelAttribute="userDB"
      >
        <form:input path="id" type="hidden" />

        <label>Email</label>
        <form:input path="email" type="email" required="true" />

        <label>Password</label>
        <form:input path="password" type="password" required="true" />

        <label>Full Name</label>
        <form:input path="fullName" required="true" />

        <label>Age</label>
        <form:input path="age" type="number" />

        <label>Address</label>
        <form:input path="address" />

        <label>Role</label>
        <form:select path="role.id">
            <form:option value="1">ADMIN</form:option>
            <form:option value="2">USER</form:option>
        </form:select>


        <button type="submit">Update User</button>

        <a href="/admin/users" class="cancel-btn">Cancel</a>
      </form:form>
    </div>
  </body>
</html> -->
