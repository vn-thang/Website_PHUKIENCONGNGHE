<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>${not empty productDetail ? 'Chỉnh Sửa Sản Phẩm' : 'Thêm Sản Phẩm Mới'}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background-color: #ffffff;
            font-family: "Segoe UI", sans-serif;
        }

        .card {
            border-radius: 14px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            border: none;
        }

        .card-header {
            background: #ff6600 !important;
            color: white !important;
            border-radius: 14px 14px 0 0;
            padding: 18px;
        }

        h3 {
            font-weight: 700;
        }

        /* Override Bootstrap buttons */
        .btn {
            border-radius: 10px !important;
            border: none !important;
        }

        .btn-primary {
            background-color: #ff6600 !important;
        }

        .btn-primary:hover {
            background-color: #e25500 !important;
        }

        .btn-secondary {
            background-color: #999 !important;
        }

        .btn-secondary:hover {
            background-color: #666 !important;
        }

        .form-label {
            font-weight: 600;
        }

        .form-control, .form-select {
            border-radius: 10px !important;
            border: 1px solid #ffdab8 !important;
            padding: 10px;
        }

        .form-control:focus, .form-select:focus {
            border-color: #ff6600 !important;
            box-shadow: 0 0 6px rgba(255,102,0,0.5) !important;
        }

    </style>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="container mt-5 mb-5">
    <div class="row justify-content-center">
        <div class="col-md-8">

            <div class="card">

                <div class="card-header">
                    <h3>${not empty productDetail ? 'Chỉnh Sửa Sản Phẩm' : 'Thêm Sản Phẩm Mới'}</h3>
                </div>

                <div class="card-body">
                    <form action="manager-product" method="post">

                        <input type="hidden" name="action" value="${not empty productDetail ? 'update' : 'add'}">

                        <c:if test="${not empty productDetail}">
                            <input type="hidden" name="id" value="${productDetail.maSanPham}">
                        </c:if>

                        <!-- Tên -->
                        <div class="mb-3">
                            <label class="form-label">Tên Sản Phẩm</label>
                            <input type="text" class="form-control"
                                   name="name" value="${productDetail.tenSanPham}" required>
                        </div>

                        <!-- Hình -->
                        <div class="mb-3">
                            <label class="form-label">Link Hình Ảnh</label>
                            <input type="text" class="form-control"
                                   name="image" value="${productDetail.hinhAnh}" required>
                        </div>

                        <!-- Giá + Tồn -->
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Giá (VNĐ)</label>
                                <input type="number" class="form-control"
                                       name="price" value="${productDetail.gia}" required>
                            </div>

                            <div class="col-md-6 mb-3">
                                <label class="form-label">Số Lượng Kho</label>
                                <input type="number" class="form-control"
                                       name="stock" value="${productDetail.soLuongTon}" required>
                            </div>
                        </div>

                        <!-- Danh mục -->
                        <div class="mb-3">
                            <label class="form-label">Danh Mục</label>
                            <select class="form-select" name="category" required>
                                <c:forEach items="${categoryList}" var="c">
                                    <option value="${c.maDanhMuc}"
                                            ${productDetail.maDanhMuc == c.maDanhMuc ? 'selected' : ''}>
                                        ${c.tenDanhMuc}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Mô tả -->
                        <div class="mb-3">
                            <label class="form-label">Mô Tả</label>
                            <textarea class="form-control" name="description"
                                      rows="4" required>${productDetail.moTa}</textarea>
                        </div>

                        <!-- Buttons -->
                        <a href="manager-product" class="btn btn-secondary me-2">Quay Lại</a>

                        <button type="submit" class="btn btn-primary">
                            ${not empty productDetail ? 'Cập Nhật' : 'Thêm Mới'}
                        </button>

                    </form>
                </div>
            </div>

        </div>
    </div>
</div>
<!-- TOAST THÔNG BÁO -->
<div id="toastBox" 
     style="
        position: fixed; 
        top: 20px; 
        right: 20px; 
        z-index: 9999;
        display: none;
     ">
    <div id="toastMessage" 
         style="
            background: #ff7e27;
            color: #fff;
            padding: 12px 18px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            font-size: 15px;
            font-weight: 600;
            min-width: 260px;
            animation: fadeIn 0.4s ease-out;
         ">
    </div>
</div>

<style>
@keyframes fadeIn {
    from { opacity: 0; transform: translateY(-10px); }
    to { opacity: 1; transform: translateY(0); }
}
@keyframes fadeOut {
    from { opacity: 1; transform: translateY(0); }
    to { opacity: 0; transform: translateY(-10px); }
}
</style>

<script>
function showToast(message) {
    const toastBox = document.getElementById("toastBox");
    const toastMsg = document.getElementById("toastMessage");

    toastMsg.innerText = message;
    toastBox.style.display = "block";

    setTimeout(() => {
        toastMsg.style.animation = "fadeOut 0.4s ease-in";
        setTimeout(() => {
            toastBox.style.display = "none";
            toastMsg.style.animation = ""; // reset animation
        }, 400);
    }, 2500);
}
</script>

<c:if test="${not empty success}">
    <script>
        showToast("${success}");
    </script>
</c:if>
<jsp:include page="footer.jsp" />

</body>
</html>
