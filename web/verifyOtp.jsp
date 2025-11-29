<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Đặt Lại Mật Khẩu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-5">
                <div class="card shadow-sm">
                    <div class="card-body p-4">
                        <h3 class="text-center mb-4">Đặt Lại Mật Khẩu</h3>
                        
                        <c:if test="${not empty message}">
                            <div class="alert alert-success">${message}</div>
                        </c:if>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">${error}</div>
                        </c:if>

                        <form action="resetPassword" method="post">
                            <div class="mb-3">
                                <label class="form-label fw-bold">Mã OTP (trong email):</label>
                                <input type="text" name="otp" class="form-control" required placeholder="Nhập 6 số...">
                            </div>
                            <hr>
                            <div class="mb-3">
                                <label class="form-label">Mật khẩu mới:</label>
                                <input type="password" name="newPass" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Nhập lại mật khẩu:</label>
                                <input type="password" name="confirmPass" class="form-control" required>
                            </div>
                            <button type="submit" class="btn btn-success w-100">Xác Nhận Đổi Mật Khẩu</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>