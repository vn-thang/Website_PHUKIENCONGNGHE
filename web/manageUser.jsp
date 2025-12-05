<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>Quản Lý Tài Khoản</title>

    <!-- CSS tone cam–trắng -->
    <style>
        body {
            background-color: #ffffff !important;
            font-family: "Segoe UI", sans-serif !important;
            color: #333 !important;
        }

        h2 {
            color: #ff7e27 !important;
            font-weight: 700 !important;
            letter-spacing: 0.5px !important;
        }

        /* BUTTON */
        button, .btn
 {
    border-radius: 12px !important;
    font-size: smaller !important;
}
        .btn-primary {
            background-color: #ff7e27 !important;
            border: none !important;
            color: #fff !important;
        }
        .btn-primary:hover {
            background-color: #e25500 !important;
        }

        .btn-danger {
            background-color: #ff4d4f !important;
            border: none !important;
        }
        .btn-danger:hover {
            background-color: #d9363e !important;
        }

        /* TABLE */
        table {
            border-radius: 14px !important;
            overflow: hidden !important;
            background: #ffffff !important;
            border: 1px solid #f3f3f3 !important;
        }

        thead.table-dark {
            background-color: #ff7e27 !important;
        }

        thead.table-dark th {
            color: #fff !important;
            text-align: center !important;
            font-weight: 600 !important;
            padding: 14px !important;
                        background-color: #ff7e27 !important;

        }

        tbody tr:hover {
            background-color: #fff3e8 !important;
        }

        .table td, .table th {
            vertical-align: middle !important;
            padding: 12px 10px !important;
            border-color: #f5f5f5 !important;
        }

        /* Select role */
        .form-select-sm {
            border-radius: 8px !important;
            border: 1px solid #ffd6ba !important;
        }
        .form-select-sm:focus {
            box-shadow: 0 0 0 3px #ffefe2 !important;
            border-color: #ff8a33 !important;
        }

        /* Badge role */
        .badge.bg-success {
            background-color: #ff7e27 !important;
        }
        .badge.bg-secondary {
            background-color: #999 !important;
        }

    </style>
</head>

<body>

    <jsp:include page="header.jsp" />

    <div class="container mt-5">
        <h2 class="mb-4">Quản Lý Tài Khoản</h2>

        <c:if test="${not empty adminError}">
            <div class="alert alert-danger" role="alert">
                ${adminError}
            </div>
        </c:if>

        <table class="table table-bordered table-hover">
            <thead class="table-dark">
                <tr>
                    <th scope="col">ID</th>
                    <th scope="col">Họ Tên</th>
                    <th scope="col">Email</th>
                    <th scope="col">Vai Trò</th>
                    <th scope="col" style="width: 200px;">Cập Nhật Vai Trò</th>
                    <th scope="col" style="width: 100px;">Xóa</th>
                </tr>
            </thead>

            <tbody>
                <c:forEach items="${userList}" var="u">
                    <tr>
                        <th scope="row">${u.maNguoiDung}</th>
                        <td>${u.hoTen}</td>
                        <td>${u.email}</td>

                        <td>
                            <span class="badge ${u.vaiTro == 'admin' ? 'bg-success' : 'bg-secondary'}">
                                ${u.vaiTro}
                            </span>
                        </td>

                        <td>
                            <form action="manage-user" method="post" class="d-flex">
                                <input type="hidden" name="action" value="updateRole">
                                <input type="hidden" name="userId" value="${u.maNguoiDung}">

                                <select name="role" class="form-select form-select-sm me-2">
                                    <option value="user" ${u.vaiTro == 'user' ? 'selected' : ''}>User</option>
                                    <option value="admin" ${u.vaiTro == 'admin' ? 'selected' : ''}>Admin</option>
                                </select>

                                <button type="submit" class="btn btn-primary btn-sm">Lưu</button>
                            </form>
                        </td>

                        <td>
                            <form action="manage-user" method="post"
                                  onsubmit="return confirm('Bạn có chắc chắn muốn xóa tài khoản này? (Nếu tài khoản có đơn hàng, sẽ không thể xóa)');">

                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="userId" value="${u.maNguoiDung}">

                                <button type="submit" class="btn btn-danger btn-sm">
                                    <i class="fas fa-trash"></i> Xóa
                                </button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>

        </table>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>
