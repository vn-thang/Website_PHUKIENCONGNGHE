<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Quản Lý Sản Phẩm</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

  <style>
/* ============================
   GLOBAL
============================ */
body {
    background-color: #ffffff;
    font-family: "Segoe UI", sans-serif;
    color: #333;
}

h2 {
    color: #ff7e27;
    font-weight: 700;
}

/* ============================
   TABLE
============================ */
.table {
    border-radius: 12px;
    border: 1px solid #ffe0cc;
    overflow: hidden;
}

thead.table-dark th {
    background-color: #ff7e27;
    color: #fff;
    font-size: 15px;
    text-align: center;
}

tbody tr:hover {
    background: #fff3e6;
}

/* ============================
   FILTER BOX
============================ */
.filter-box {
    background: #fff;
    padding: 15px 20px;
    border-radius: 12px;
    box-shadow: 0 3px 10px rgba(0,0,0,0.08);
    border-left: 4px solid #ff7e27;
}

/* ============================
   BUTTON SYSTEM (không đè Bootstrap)
============================ */
.btn-main {
    background-color: #ff7e27;
    color: #fff;
    border-radius: 10px;
    padding: 8px 14px;
    border: none;
}
.btn-main:hover {
    background-color: #e25500;
    color: #fff;
}

/* Search button */
.btn-search {
    background-color: #ffa733;
    color: #fff;
    border-radius: 10px;
    border: none;
}
.btn-search {
    position: absolute;
    right: 8% !important;
    top: 37.5% !important;
    transform: translateY(-50%);
    background: #ff6f0f;
    border: none;
    color: #fff;
    height: 40px;
    width: 42px;
    border-radius: 8px !important;
    display: flex;
    justify-content: center;
    align-items: center;
}
.btn-search:hover {
    background-color: #ff7b00;
}

/* Warning button (Sửa) */
.btn-edit {
    background-color: #ffc107;
    color: #000;
    border-radius: 10px;
    border: none;
}
.btn-edit:hover {
    background-color: #e0a800;
}

/* Danger button (Xóa) */
.btn-delete {
    background-color: #dc3545;
    color: #fff;
    border-radius: 10px;
    border: none;
}
.btn-delete:hover {
    background-color: #c82333;
}

/* Statistic button */
.statistic-btn {
    background-color: #ffa733;
    border: none;
    color: #fff;
    border-radius: 10px;
    padding: 8px 14px;
}
.statistic-btn:hover {
    background-color: #ff7e27;
}
@media (min-width: 768px) {
    .col-md-7 {
        flex: 0 0 auto;
        width: 50% !important;
    }
}
</style>

</head>

<body>

<jsp:include page="header.jsp" />



<div class="container mt-5">

    <!-- TITLE + STATISTIC -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2><i class="fas fa-box"></i> Quản Lý Sản Phẩm</h2>

        <form action="statistic" method="get">
           <button type="submit" class="statistic-btn">
    <i class="fas fa-chart-bar"></i> Xem thống kê
</button>

        </form>
    </div>

    <!-- SEARCH + CATEGORY FILTER -->
    <div class="filter-box mb-4">
        <div class="row g-3">

            <!-- Search -->
            <div class="col-md-5">
                <form action="manager-product" method="get" class="d-flex">
                    <input type="text" name="search" value="${searchValue}"
                           class="form-control me-2"
                           placeholder="Tìm kiếm theo tên sản phẩm...">
                  <button class="btn-search">
    <i class="fa fa-search"></i>
</button>

                </form>
            </div>

            <!-- Filter -->
            <div class="col-md-7 d-flex justify-content-md-end">
                <form action="manager-product" method="get" class="d-flex align-items-center">
                    <label class="fw-bold me-2">Danh mục:</label>
                    <select name="cid" class="form-select w-auto" onchange="this.form.submit()">
                        <option value="all">Tất cả</option>
                        <c:forEach items="${categoryList}" var="c">
                            <option value="${c.maDanhMuc}"
                                ${tag == c.maDanhMuc ? "selected" : ""}>
                                ${c.tenDanhMuc}
                            </option>
                        </c:forEach>
                    </select>
                </form>
            </div>

        </div>
    </div>

    <!-- ADD BUTTON -->
    <div class="mb-3">
        <a href="manager-product?action=show-add-form" class="btn-main">
    <i class="fas fa-plus"></i> Thêm Sản Phẩm
</a>

    </div>

    <!-- PRODUCT TABLE -->
    <table class="table table-hover align-middle shadow-sm">
        <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th style="width: 30%;">Tên Sản Phẩm</th>
                <th>Hình</th>
                <th>Giá</th>
                <th>Tồn</th>
                <th class="text-center">Hành Động</th>
            </tr>
        </thead>

        <tbody>
        <c:forEach items="${productList}" var="p">
            <tr>
                <td>${p.maSanPham}</td>
                <td>${p.tenSanPham}</td>
                <td>
                    <img src="${p.hinhAnh}" style="width:70px;height:70px;object-fit:cover;border-radius:10px;">
                </td>
                <td><fmt:formatNumber value="${p.gia}" type="currency" currencyCode="VND"/></td>
                <td>${p.soLuongTon}</td>

                <td class="text-center">
                   <a href="manager-product?action=load&pid=${p.maSanPham}"
   class="btn-edit btn-sm me-2">
    <i class="fa-solid fa-pen"></i> Sửa
</a>


                    <a href="manager-product?action=delete&pid=${p.maSanPham}"
   class="btn-delete btn-sm"
   onclick="return confirm('Bạn chắc chắn muốn xóa?')">
    <i class="fa-solid fa-trash"></i> Xóa
</a>

                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

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
            background: #ff6600;
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
