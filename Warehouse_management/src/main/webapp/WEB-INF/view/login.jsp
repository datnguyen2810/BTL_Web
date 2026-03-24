<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> <%@ taglib prefix="form"
uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Hệ thống Quản lý kho</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="/css/style-login.css">
    
</head>
<body>
    <div class="login-card">
        <div class="icon-box">
            <i class="fas fa-warehouse"></i>
        </div>
        <h2>Hệ thống quản lý kho vật tư</h2>
        <p class="subtitle">Vui lòng đăng nhập để quản trị hệ thống</p>

        <form action="/login" method="post">
            <c:if test="${param.error != null}">
                <p style="color: #ef4444; font-size: 14px; margin-bottom: 10px;">
                    Email hoặc mật khẩu không chính xác!
                </p>
            </c:if>
            <div class="form-group">
                <label>Tên đăng nhập / Email</label>
                <div class="input-wrapper">
                    <i class="fas fa-user"></i>
                    <input type="text" name="username" placeholder="admin@ptit.edu.vn" required>
                </div>
            </div>

            <div class="form-group">
                <label>Mật khẩu</label>
                <div class="input-wrapper">
                    <i class="fas fa-lock"></i>
                    <input type="password" name="password" placeholder="•••••••••••" required>
                </div>
                <!-- <a href="#" class="forgot-pass">Quên mật khẩu?</a> -->
            </div>

            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

            <!-- <div class="remember-me">
                <input type="checkbox" id="remember">
                <label for="remember">Ghi nhớ đăng nhập</label>
            </div> -->

            <button type="submit" class="btn-login">ĐĂNG NHẬP</button>
        </form>

    </div>

</body>
</html>