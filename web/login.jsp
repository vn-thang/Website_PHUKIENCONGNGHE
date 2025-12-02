<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Đăng nhập - Phụ Kiện Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(120deg, #fff, #fbeee6);
            font-family: 'Segoe UI', sans-serif;
            overflow: hidden;
        }

        /* Nút Trang chủ (bên trái) */
        .btn-home {
            position: fixed;
            top: 20px;
            left: 20px;
            background-color: #ff7e27;
            color: #fff;
            padding: 8px 14px;
            border-radius: 8px;
            font-weight: 500;
            text-decoration: none;
            transition: 0.3s;
            z-index: 1000;
        }

        .btn-home:hover {
            background-color: #e35500;
            transform: scale(1.05);
        }

        /* Nút Đăng ký (bên phải) */
        .btn-register {
            position: fixed;
            top: 20px;
            right: 20px;
            background-color: #ff7e27;
            color: #fff;
            padding: 8px 14px;
            border-radius: 8px;
            font-weight: 500;
            text-decoration: none;
            transition: 0.3s;
            z-index: 1000;
        }

        .btn-register:hover {
            background-color: #e35500;
            transform: scale(1.05);
        }

        /* FORM */
        .login-container {
            position: relative;
            width: 400px;
            margin: 140px auto;
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            padding: 40px 35px;
            animation: fadeIn 1s ease;
        }

        .login-container h3 {
            color: #ff7e27;
            font-weight: 700;
            margin-bottom: 25px;
            text-align: center;
        }

        .form-control {
            border-radius: 10px;
            padding: 10px 14px;
            border: 1px solid #ddd;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            border-color: #ff7e27;
            box-shadow: 0 0 8px rgba(255,102,0,0.3);
        }

        .btn-login {
            background-color: #ff7e27;
            border: none;
            width: 100%;
            padding: 10px;
            border-radius: 30px;
            font-weight: 600;
            color: #fff;
            transition: 0.3s;
        }

        .btn-login:hover {
            background-color: #e35500;
            transform: scale(1.03);
        }

        .text-muted a {
            color: #ff7e27;
            text-decoration: none;
        }

        .text-muted a:hover {
            text-decoration: underline;
        }

        /* Animation */
        @keyframes fadeIn {
            from {opacity: 0; transform: translateY(-20px);}
            to {opacity: 1; transform: translateY(0);}
        }

        /* Background animation */
        .bg-animation {
            position: absolute;
            top: 0; left: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
            z-index: -1;
        }

        .bg-animation span {
            position: absolute;
            display: block;
            width: 40px;
            height: 40px;
            background: rgba(255, 102, 0, 0.2);
            animation: move 20s linear infinite;
            border-radius: 50%;
        }

        @keyframes move {
            0% {transform: translateY(0) rotate(0deg);}
            100% {transform: translateY(-1000px) rotate(720deg);}
        }
    </style>
</head>
<body>
    <!-- NÚT TRANG CHỦ & ĐĂNG KÝ -->
    <a href="home" class="btn-home"><i class="fa-solid fa-house me-1"></i>Trang chủ</a>
    <a href="register" class="btn-register"><i class="fa-solid fa-user-plus me-1"></i>Đăng ký</a>

    <!-- NỀN CHUYỂN ĐỘNG -->
    <div class="bg-animation">
        <span style="left: 10%; animation-delay: 0s;"></span>
        <span style="left: 25%; animation-delay: 2s; width: 30px; height: 30px;"></span>
        <span style="left: 50%; animation-delay: 4s; width: 60px; height: 60px;"></span>
        <span style="left: 70%; animation-delay: 1s;"></span>
        <span style="left: 85%; animation-delay: 3s; width: 50px; height: 50px;"></span>
    </div>

    <!-- FORM ĐĂNG NHẬP -->
    <div class="login-container">
        <h3><i class="fa-solid fa-right-to-bracket me-2"></i>Đăng Nhập</h3>
        <form action="login" method="post">
            <div class="mb-3">
                <label class="form-label">Tên đăng nhập</label>
                <input type="text" name="user" class="form-control" required placeholder="Nhập tên đăng nhập của bạn">
            </div>
            <div class="mb-3">
                <label class="form-label">Mật khẩu</label>
                <input type="password" name="pass" class="form-control" required placeholder="••••••••">
            </div>
            <button type="submit" class="btn btn-login">Đăng nhập</button>
        </form>

        
            <a href="forgotPassword" class="float-end text-decoration-none">Quên mật khẩu?</a>
       
        <div class="text-center mt-3 text-muted">
            Chưa có tài khoản? <a href="register.jsp">Đăng ký ngay</a>
        </div>
    </div>
</body>
</html>
