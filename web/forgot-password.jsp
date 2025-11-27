<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quên Mật Khẩu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(120deg, #fff, #fbeee6);
            font-family: 'Segoe UI', sans-serif;
            overflow-x: hidden;
        }

        /* HEADER */
        /* HEADER */
        header {
            background: #fff;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            padding: 10px 0;
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000;
        }
        header .navbar-brand {
            font-weight: 700;
            color: #ff7e27 !important;
            font-size: 1.5rem;
        }
        header .nav-link {
            color: #333 !important;
            font-weight: 500;
            margin-left: 20px;
            transition: 0.3s;
        }
        header .nav-link:hover {
            color: #ff7e27 !important;
        }

        /* NỀN ĐỘNG (GIỮ NGUYÊN) */
        .bg-animation {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
            overflow: hidden;
        }
        .bg-animation span {
            position: absolute;
            display: block;
            list-style: none;
            width: 20px;
            height: 20px;
            background: rgba(255, 102, 0, 0.2);
            animation: animate-bg 20s linear infinite;
            bottom: -150px;
        }
        @keyframes animate-bg {
            0% { transform: translateY(0) rotate(0deg); opacity: 1; border-radius: 0; }
            100% { transform: translateY(-1000px) rotate(720deg); opacity: 0; border-radius: 50%; }
        }

        /* FORM */
        .forgot-container {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: #ffffff;
            padding: 2.5rem;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(255, 102, 0, 0.15);
            width: 90%;
            max-width: 450px;
            text-align: center;
        }
        .forgot-container h2 {
            color: #ff7e27;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        .forgot-container p {
            color: #555;
            margin-bottom: 1.5rem;
        }
        .btn-primary {
            background-color: #ff7e27;
            border-color: #ff7e27;
            font-weight: 500;
            padding: 10px;
            transition: 0.3s;
        }
        .btn-primary:hover {
            background-color: #e65c00;
            border-color: #e65c00;
        }
        .form-control:focus {
            border-color: #ff7e27;
            box-shadow: 0 0 0 0.25rem rgba(255, 102, 0, 0.25);
        }
    </style>
</head>
<body>

    <header>
        <nav class="navbar navbar-expand-lg">
            <div class="container">
                <a class="navbar-brand" href="home">
                    <i class="fa-solid fa-bolt"></i> Phụ Kiện Store
                </a>
                <a href="login.jsp" class="nav-link d-inline">Đăng nhập</a>
                <a href="register.jsp" class="nav-link d-inline">Đăng ký</a>
            </div>
        </nav>
    </header>

    <div class="bg-animation">
        <span style="left: 10%; animation-delay: 0s;"></span>
        <span style="left: 25%; animation-delay: 2s; width: 30px; height: 30px;"></span>
        <span style="left: 50%; animation-delay: 4s; width: 60px; height: 60px;"></span>
        <span style="left: 70%; animation-delay: 1s;"></span>
        <span style="left: 85%; animation-delay: 3s; width: 50px; height: 50px;"></span>
    </div>

    <div class="forgot-container">
        <h2><i class="fa-solid fa-envelope-circle-check me-2"></i>Quên Mật Khẩu</h2>
        <p>Nhập email của bạn để nhận mật khẩu mới.</p>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
        </c:if>

        <form action="forgot-password" method="post">
            <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="email" class="form-control" id="email" name="email" required placeholder="Nhập email đã đăng ký">
            </div>
            <div class="d-grid">
                <button type="submit" class="btn btn-primary">Gửi Yêu Cầu</button>
            </div>
        </form>
    </div>

</body>
</html>