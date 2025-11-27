<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>Đổi Mật Khẩu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #fff5f0; /* Nền sáng cam nhạt */
            font-family: 'Segoe UI', sans-serif;
        }
        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(255, 102, 0, 0.2);
        }
        .card h2 {
            color: #ff7e27;
            font-weight: 700;
        }
        .btn-primary {
            background-color: #ff7e27 !important;
            border-color: #ff7e27;
            transition: all 0.3s ease;
            border: none !important;
        }
        .btn-primary:hover {
            background-color: #ff7e27;
           
        }
        .form-label {
            color: #333;
            font-weight: 500;
        }
        .alert-success {
            background-color: #ffefe0;
            border-color: #ffddc2;
            color: #b34a00;
        }
        .alert-danger {
            background-color: #fbebee;
            border-color: #f8d7da;
            color: #721c24;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />
    
    <div class="container" style="max-width: 500px; margin-top: 5rem;">
        <div class="card p-4">
            <h2 class="text-center mb-4">🔒 Đổi Mật Khẩu</h2>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>
            <c:if test="${not empty success}">
                <div class="alert alert-success">${success}</div>
            </c:if>

            <form action="change-password" method="post">
                <div class="mb-3">
                    <label for="oldPass" class="form-label">Mật khẩu cũ</label>
                    <input type="password" class="form-control" id="oldPass" name="oldPass" required>
                </div>
                <div class="mb-3">
                    <label for="newPass" class="form-label">Mật khẩu mới</label>
                    <input type="password" class="form-control" id="newPass" name="newPass" required>
                </div>
                <div class="mb-3">
                    <label for="reNewPass" class="form-label">Nhập lại mật khẩu mới</label>
                    <input type="password" class="form-control" id="reNewPass" name="reNewPass" required>
                </div>
                <div class="d-grid">
                    <button type="submit" class="btn btn-primary">Xác Nhận</button>
                </div>
            </form>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>