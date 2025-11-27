<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thông Tin Tài Khoản</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(120deg, #fff, #fbeee6);
            font-family: 'Segoe UI', sans-serif;
        }

        .profile-container {
            max-width: 700px;
            margin: 140px auto;
            background-color: #fff;
            padding: 2.5rem 2rem;
            border-radius: 16px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            animation: fadeIn 0.8s ease;
        }

        .profile-container h2 {
            text-align: center;
            color: #ff7e27;
            font-weight: 700;
            margin-bottom: 1.5rem;
        }

        .form-label {
            font-weight: 500;
            color: #444;
        }

        .form-control, textarea {
            border-radius: 10px;
            border: 1px solid #ddd;
            padding: 10px 14px;
            transition: all 0.3s ease;
        }

        .form-control:focus, textarea:focus {
            border-color: #ff7e27;
            box-shadow: 0 0 8px rgba(255,102,0,0.3);
        }

        .btn-save {
            background-color: #ff7e27;
            border: none;
            color: white;
            border-radius: 30px;
            font-weight: 600;
            padding: 10px 20px;
            transition: 0.3s;
        }

        .btn-save:hover {
            background-color: #e35500;
            transform: scale(1.03);
        }

        .btn-outline-secondary {
            --bs-btn-color:#fff !important;
          
            --bs-btn-bg:#ff7e27 !important;
            
            border-radius: 30px;
            font-weight: 600;
            padding: 10px 20px;
            transition: 0.3s;
        }

        .btn-outline-secondary:hover {
            background-color: #ff7e27;
            color: white;
            transform: scale(1.03);
        }

        .alert {
            border-radius: 10px;
        }

        @keyframes fadeIn {
            from {opacity: 0; transform: translateY(-20px);}
            to {opacity: 1; transform: translateY(0);}
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />

    <div class="container">
        <div class="profile-container">
            <h2><i class="fa-solid fa-user-circle me-2"></i>Thông Tin Tài Khoản</h2>

            <c:if test="${not empty successMessage}">
                <div class="alert alert-success" role="alert">
                    ${successMessage}
                </div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger" role="alert">
                    ${errorMessage}
                </div>
            </c:if>

            <form action="profile" method="post">
                <div class="mb-3">
                    <label class="form-label">Tên đăng nhập</label>
                    <input type="text" class="form-control" value="${sessionScope.acc.tenDangNhap}" readonly disabled>
                    <div class="form-text text-muted">Tên đăng nhập không thể thay đổi.</div>
                </div>
                
                <div class="mb-3">
                    <label for="hoTen" class="form-label">Họ và Tên</label>
                    <input type="text" class="form-control" id="hoTen" name="hoTen" value="${sessionScope.acc.hoTen}" required>
                </div>
                
                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" class="form-control" id="email" name="email" value="${sessionScope.acc.email}" required>
                </div>
                
                <div class="mb-3">
                    <label for="sdt" class="form-label">Số điện thoại</label>
                    <input type="tel" class="form-control" id="sdt" name="sdt" value="${sessionScope.acc.soDienThoai}" required>
                </div>
                
                <div class="mb-3">
                    <label for="diaChi" class="form-label">Địa chỉ</label>
                    <textarea class="form-control" id="diaChi" name="diaChi" rows="3" required>${sessionScope.acc.diaChi}</textarea>
                </div>
                
                <div class="d-flex justify-content-between mt-4">
                    <button type="submit" class="btn btn-save">
                        <i class="fas fa-save me-2"></i>Lưu Thay Đổi
                    </button>
                    <a href="change-password.jsp" class="btn btn-outline-secondary">
                        <i class="fas fa-key me-2"></i>Đổi Mật Khẩu
                    </a>
                </div>
            </form>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>
