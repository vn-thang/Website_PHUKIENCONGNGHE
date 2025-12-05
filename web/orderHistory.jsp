<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Lịch Sử Mua Hàng</title>

    <!-- STYLE tone cam – trắng -->
    <style>
        body {
            background-color: #ffffff !important;
            font-family: "Segoe UI", sans-serif !important;
            color: #333 !important;
        }

        h2 {
            color: #ff7e27 !important;
            font-weight: 700 !important;
        }

        /* ================= TABLE =============== */
        table {
            border-radius: 14px !important;
            overflow: hidden !important;
            background: #ffffff !important;
            border: 1px solid #f1f1f1 !important;
        }

        thead.table-dark {
            background-color: #ff7e27 !important;
            --bs-table-bg: #ff7e27;
        }

        thead.table-dark th {
            color: #fff !important;
            text-align: center !important;
            font-size: 15px !important;
        }

        tbody tr:hover {
            background-color: #fff4e8 !important;
        }

        .table td, .table th {
            padding: 12px 10px !important;
            border-color: #f3f3f3 !important;
        }

        /* ================= BADGE TRẠNG THÁI ============= */
        .badge {
            padding: 6px 10px !important;
            font-size: 13px !important;
            border-radius: 8px !important;
        }

        .bg-warning {
            background-color: #ffd28a !important;
            color: #333 !important;
        }
        .bg-info {
            background-color: #ff8a33 !important;
            color: #fff !important;
        }
        .bg-primary {
            background-color: #ff7e27 !important;
            color: #fff !important;
        }
        .bg-success {
            background-color: #38c172 !important;
        }
        .bg-danger {
            background-color: #ff4d4f !important;
        }

        /* ================= BUTTON =============== */
        .btn-primary {
            background-color: #ff7e27 !important;
            border: none !important;
            color: #fff !important;
        }
        .btn-primary:hover {
            background-color: #e25500 !important;
        }
        button, .btn {
    border-radius: 12px;
    font-size: smaller !important;
}

/* ================= ROW COLOR BY STATUS ============= */

/* Đang xử lý */
.row-warning {
    background-color: #FFF4DB !important;
}

/* Đã thanh toán */
.row-info {
    background-color: #FFE3CC !important;
}

/* Đang giao */
.row-primary {
    background-color: #FFE0CC !important;
}

/* Đã giao */
.row-success {
    background-color: #E8F8F0 !important;
}

/* Hủy / lỗi */
.row-danger {
    background-color: #FFE1E3 !important;
}

    </style>
</head>

<body>

    <jsp:include page="header.jsp" />

    <div class="container mt-5">
        <h2 class="mb-4">Lịch Sử Mua Hàng Của Bạn</h2>

        <c:choose>
            <c:when test="${empty orderList}">
                <div class="alert alert-info">Bạn chưa có đơn hàng nào.</div>
            </c:when>

            <c:otherwise>
                <table class="table table-bordered table-hover">
                    <thead class="table-dark">
                        <tr>
                            <th scope="col">Mã ĐH</th>
                            <th scope="col">Ngày Đặt</th>
                            <th scope="col">Tổng Tiền</th>
                            <th scope="col">Trạng Thái</th>
                            <th scope="col">Chi Tiết</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:forEach items="${orderList}" var="o">
                           <tr class="
    <c:choose>
        <c:when test='${o.trangThai == "Dang xu ly"}'>row-warning</c:when>
        <c:when test='${o.trangThai == "Da Thanh Toan"}'>row-info</c:when>
        <c:when test='${o.trangThai == "Dang giao"}'>row-primary</c:when>
        <c:when test='${o.trangThai == "Da giao"}'>row-success</c:when>
        <c:otherwise>row-danger</c:otherwise>
    </c:choose>
">

                                <th scope="row">#${o.maDonHang}</th>

                                <td>
                                    <fmt:formatDate value="${o.ngayDat}" pattern="dd-MM-yyyy HH:mm"/>
                                </td>

                                <td class="text-danger fw-bold">
                                    <fmt:formatNumber value="${o.tongTien}" type="currency" currencyCode="VND" minFractionDigits="0"/>
                                </td>

                                <td>
                                    <c:choose>
                                        <c:when test="${o.trangThai == 'Dang xu ly'}">
                                            <span class="badge bg-warning">${o.trangThai}</span>
                                        </c:when>

                                        <c:when test="${o.trangThai == 'Da Thanh Toan'}">
                                            <span class="badge bg-info">${o.trangThai}</span>
                                        </c:when>

                                        <c:when test="${o.trangThai == 'Dang giao'}">
                                            <span class="badge bg-primary">${o.trangThai}</span>
                                        </c:when>

                                        <c:when test="${o.trangThai == 'Da giao'}">
                                            <span class="badge bg-success">${o.trangThai}</span>
                                        </c:when>

                                        <c:otherwise>
                                            <span class="badge bg-danger">${o.trangThai}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td>
                                    <a href="order-history?action=view&id=${o.maDonHang}" class="btn btn-primary btn-sm">
                                        Xem chi tiết
                                    </a>
                                </td>

                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>

    <jsp:include page="footer.jsp" />

</body>
</html>
