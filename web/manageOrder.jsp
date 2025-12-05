<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Quản Lý Đơn Hàng</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
       /* ========================
   🎨 TONE CAM UI 
   Tối ưu – Không xung đột
========================= */

/* Tiêu đề chính */
.page-title {
    color: #ff7e27;
    font-weight: 700;
    letter-spacing: .3px;
}

/* ========================
   BUTTON
========================= */
.btn-order-view {
    background-color: #ff7e27;
    border-color: #ff7e27;
    padding: 5px 12px;
    font-size: 13px;
    border-radius: 8px;
}

.btn-order-view:hover {
    background-color: #e65a00;
    border-color: #e65a00;
}

/* ========================
   TABLE
========================= */
.order-table {
    border-radius: 10px;
    overflow: hidden;
    box-shadow: 0 2px 10px rgba(0,0,0,0.08);
}

.order-table thead {
    background-color: #ff7e27 !important;
    color: white;
}

.order-table th,
.order-table td {
    vertical-align: middle;
    padding: 10px 12px;
}

/* ========================
   BADGE TRẠNG THÁI
========================= */


/* Đang xử lý */
.badge-processing {
    background-color: #ffcc80;
    color: #663300;
    padding: 6px 12px;
    border-radius: 6px;
}

/* Đã thanh toán */
.badge-paid {
    background-color: #ff9966;
    color: #ffffff;
    padding: 6px 12px;
    border-radius: 6px;
}

/* Đang giao */
.badge-shipping {
    background-color: #007bff;
    color: #ffffff;
    padding: 6px 12px;
    border-radius: 6px;
}

/* Đã giao */
.badge-finished {
    background-color: #28a745;
    color: #ffffff;
    padding: 6px 12px;
    border-radius: 6px;
}

/* Hủy / Lỗi */
.badge-failed {
    background-color: #dc3545;
    color: #ffffff;
    padding: 6px 12px;
    border-radius: 6px;
}

    </style>
</head>

<body>
    <jsp:include page="header.jsp" />

    <div class="container mt-5">
        <h2 class="mb-4 page-title">Quản Lý Đơn Hàng</h2>

        
        <table class="table table-bordered table-hover order-table">

            <thead>
                <tr>
                    <th scope="col">Mã ĐH</th>
                    <th scope="col">Người Đặt</th>
                    <th scope="col">Ngày Đặt</th>
                    <th scope="col">Tổng Tiền</th>
                    <th scope="col">Trạng Thái</th>
                    <th scope="col">Chi Tiết</th>
                </tr>
            </thead>

            <tbody>
                <c:forEach items="${orderList}" var="o">
                    <tr>
                        <th scope="row">#${o.maDonHang}</th>

                        <td>${o.tenNguoiDat} (ID: ${o.maNguoiDung})</td>

                        <td>
                            <fmt:formatDate value="${o.ngayDat}" pattern="dd-MM-yyyy HH:mm"/>
                        </td>

                        <td class="text-danger fw-bold">
                            <fmt:formatNumber value="${o.tongTien}" type="currency" currencyCode="VND" minFractionDigits="0"/>
                        </td>

                        <td>
                            <c:choose>
                                <c:when test="${o.trangThai == 'Đang xử lý'}">
    <span class="badge badge-processing">${o.trangThai}</span>
</c:when>

<c:when test="${o.trangThai == 'Đã Thanh Toán'}">
    <span class="badge badge-paid">${o.trangThai}</span>
</c:when>

<c:when test="${o.trangThai == 'Đang giao'}">
    <span class="badge badge-shipping">${o.trangThai}</span>
</c:when>

<c:when test="${o.trangThai == 'Đã giao'}">
    <span class="badge badge-finished">${o.trangThai}</span>
</c:when>

<c:otherwise>
    <span class="badge badge-failed">${o.trangThai}</span>
</c:otherwise>

                            </c:choose>
                        </td>

                        <td>
                            <a href="manage-order?action=view&id=${o.maDonHang}" class="btn-order-view text-white">
    Xem
</a>

                        </td>
                    </tr>
                </c:forEach>
            </tbody>

        </table>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>
