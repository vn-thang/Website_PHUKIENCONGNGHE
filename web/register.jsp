<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng ký tài khoản | Phụ Kiện Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #fff8f5, #fff3eb);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            position: relative;
            overflow: hidden;
        }

        /* ====== Nút Trang chủ & Đăng nhập ====== */
        .btn-home, .btn-login {
            position: fixed;
            top: 25px;
            padding: 8px 16px;
            background-color: #ee4d2d;
            color: #fff;
            border-radius: 8px;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.3s ease;
            z-index: 1000;
        }

        .btn-home:hover, .btn-login:hover {
            background-color: #ff704f;
            transform: scale(1.05);
        }

        .btn-home { left: 25px; }
        .btn-login { right: 25px; }

        /* ====== Form đăng ký ====== */
        .register-container {
            background: #fff;
            padding: 40px 50px;
            border-radius: 20px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
            width: 420px;
            text-align: center;
            transition: all 0.3s ease;
            position: relative;
            z-index: 2;
        }

        .register-container:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.12);
        }

        .register-container h2 {
            color: #ee4d2d;
            font-weight: 700;
            font-size: 26px;
            margin-bottom: 25px;
        }

        .register-container h2 i {
            margin-right: 8px;
        }

        /* ====== Input ====== */
        .register-container input[type="text"],
        .register-container input[type="email"],
        .register-container input[type="password"] {
            width: 100%;
            padding: 12px 14px;
            margin-bottom: 15px;
            border: 1.5px solid #e7e7e7;
            border-radius: 10px;
            background-color: #f9fbff;
            font-size: 15px;
            transition: 0.3s;
        }

        .register-container input:focus {
            border-color: #ee4d2d;
            background-color: #fff;
            outline: none;
            box-shadow: 0 0 6px rgba(238,77,45,0.2);
        }

        /* ====== Nút đăng ký ====== */
        .register-container button {
            width: 100%;
            padding: 12px;
            background: #ee4d2d;
            color: white;
            border: none;
            border-radius: 30px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .register-container button:hover {
            background: linear-gradient(90deg, #ee4d2d, #ff784f);
            box-shadow: 0 4px 10px rgba(238,77,45,0.4);
        }

        /* ====== Liên kết đăng nhập ====== */
        .register-container .login-link {
            margin-top: 15px;
            font-size: 14px;
            color: #555;
        }

        .register-container .login-link a {
            color: #ee4d2d;
            font-weight: 500;
            text-decoration: none;
        }

        .register-container .login-link a:hover {
            color: #ff7b59;
        }

        /* ====== Thông báo lỗi ====== */
        .alert {
            background-color: rgba(255, 77, 77, 0.12);
            border: 1px solid rgba(255, 77, 77, 0.3);
            color: #c00;
            border-radius: 10px;
            padding: 10px 15px;
            font-size: 14px;
            margin-bottom: 15px;
        }

        /* ====== Hiệu ứng nền ====== */
        .bg-animation {
            position: absolute;
            top: 0; left: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
            z-index: 0;
        }

        .bg-animation span {
            position: absolute;
            display: block;
            width: 40px;
            height: 40px;
            background: rgba(238, 77, 45, 0.2);
            animation: move 18s linear infinite;
            border-radius: 50%;
        }

        @keyframes move {
            0% { transform: translateY(0) rotate(0deg); opacity: 1; }
            100% { transform: translateY(-1000px) rotate(720deg); opacity: 0; }
        }
    </style>
</head>
<body>
    <!-- ====== Nút Trang chủ & Đăng nhập ====== -->
    <a href="home" class="btn-home"><i class="fa-solid fa-house me-1"></i>Trang chủ</a>
    <a href="login" class="btn-login"><i class="fa-solid fa-right-to-bracket me-1"></i>Đăng nhập</a>

    <!-- ====== Hiệu ứng nền ====== -->
    <div class="bg-animation">
        <span style="left: 10%; animation-delay: 0s;"></span>
        <span style="left: 25%; animation-delay: 2s; width: 30px; height: 30px;"></span>
        <span style="left: 50%; animation-delay: 4s; width: 60px; height: 60px;"></span>
        <span style="left: 70%; animation-delay: 1s;"></span>
        <span style="left: 85%; animation-delay: 3s; width: 50px; height: 50px;"></span>
    </div>

    <!-- ====== FORM ĐĂNG KÝ ====== -->
    <div class="register-container">
        <h2><i class="fa-solid fa-user-plus"></i> Đăng ký tài khoản</h2>

        <c:if test="${not empty errorMessage}">
            <div class="alert">${errorMessage}</div>
        </c:if>

        <form action="register" method="post">
            <input type="text" name="hoTen" placeholder="Họ và tên" required>
            <input type="text" name="user" placeholder="Tên đăng nhập" required>
            <input type="password" name="pass" placeholder="Mật khẩu" required>
            <input type="password" name="re_pass" placeholder="Nhập lại mật khẩu" required>
            <input type="email" name="email" placeholder="Email" required>
            <input type="text" name="sdt" placeholder="Số điện thoại" required>
            <input type="text" name="diaChi" placeholder="Địa chỉ" required>

            <button type="submit">Đăng ký</button>
        </form>

        <div class="login-link">
            Đã có tài khoản? <a href="login.jsp">Đăng nhập ngay</a>
        </div>
    </div>
</body>
</html>
