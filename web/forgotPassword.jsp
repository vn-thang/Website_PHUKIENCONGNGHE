<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quên Mật Khẩu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-5">
                <div class="card shadow-sm">
                    <div class="card-body p-4">
                        <h3 class="text-center mb-4">Quên Mật Khẩu</h3>
                        
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">${error}</div>
                        </c:if>

                        <form action="forgotPassword" method="post">
                            <div class="mb-3">
                                <label class="form-label">Nhập Email đăng ký:</label>
                                <input type="email" name="email" class="form-control" required placeholder="example@email.com">
                            </div>
                            <button type="submit" class="btn btn-warning w-100 text-white">Gửi Mã Xác Thực</button>
                        </form>
                        
                        <div class="text-center mt-3">
                            <a href="login.jsp" class="text-decoration-none">Quay lại Đăng nhập</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>