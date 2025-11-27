<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Chi tiết đơn hàng #${order.maDonHang} - Phụ Kiện Store</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    
    <style>
        :root{
            --accent:#ff7e27;
            --muted:#f7f7f7;
            --card-border:#eee;
        }

        body {
            background-color: var(--muted);
            font-family: 'Segoe UI', Tahoma, Arial, sans-serif;
            color: #333;
        }

        .container {
            margin-top: 30px;
            margin-bottom: 50px;
        }

        /* Title */
        h2.section-title, h3.section-title {
            color: var(--accent);
            font-weight: 700;
            border-left: 5px solid var(--accent);
            padding-left: 12px;
            margin-bottom: 20px;
        }

        /* Quay lại button */
        .btn-outline-custom {
            border-color: var(--accent);
            color: var(--accent);
            border-radius: 20px;
            padding: 6px 16px;
            font-size: 0.9rem;
            transition: all .15s ease;
        }
        .btn-outline-custom:hover {
            background-color: var(--accent);
            color: #fff;
            border-color: var(--accent);
        }

        /* Card */
        .card {
            border-radius: 12px;
            border: 1px solid var(--card-border);
            box-shadow: 0 3px 12px rgba(0,0,0,0.05);
        }
        .card-header {
            background: #fff7f2;
            border-bottom: 1px solid #ffe8d9;
        }

        /* Table container */
        .table-responsive {
            border-radius: 10px;
            overflow: hidden; /* important: prevent image overflow */
            background: #fff;
            border: 1px solid var(--card-border);
            box-shadow: 0 2px 10px rgba(0,0,0,0.04);
        }

        table.table {
            margin-bottom: 0;
        }

        table.table thead th {
            background: #fff8f3;
            color: #6b3a1a;
            font-weight: 600;
        }

        table.table tbody tr td, table.table tbody tr th {
            vertical-align: middle;
        }

        /* ====== Fix hình ảnh quá cỡ ======
           - sử dụng container để ép kích thước
           - object-fit: cover/contain để giữ tỉ lệ
           - max-width/max-height phòng trường hợp ảnh lớn
        */
        .img-box {
            width: 70px;
            height: 70px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            border-radius: 8px;
            background: #fff;
            border: 1px solid #eee;
            padding: 4px;
        }

        .img-box img {
            display: block;
            width: 100%;
            height: 100%;
            object-fit: contain; /* giữ tỉ lệ, không bóp méo */
            max-width: 100%;
            max-height: 100%;
        }

        /* an toàn cho tên sản phẩm dài */
        .product-name {
            word-break: break-word;
            max-width: 420px; /* ngăn quá dài đẩy layout */
        }

        /* Tổng tiền */
        .order-total {
            font-size: 1.6rem;
            font-weight: 700;
            color: var(--accent);
        }

        /* responsive nhỏ */
        @media (max-width: 576px) {
            .img-box { width: 56px; height: 56px; }
            .product-name { max-width: 220px; }
        }
    </style>
</head>
<body>
    
    <jsp:include page="header.jsp" /> 
    
    <div class="container">
        <a href="lich-su-mua-hang" class="btn btn-outline-custom mb-3">
            <i class="fas fa-arrow-left"></i> Quay lại Lịch sử
        </a>
        
        <h2 class="section-title">Chi tiết đơn hàng #${order.maDonHang}</h2>

        <div class="row g-4">
            <!-- Thông tin giao hàng -->
            <div class="col-lg-4">
                <div class="card h-100">
                    <div class="card-header">
                        <h5 class="mb-0 text-dark fw-bold">Thông tin giao hàng</h5>
                    </div>
                    <div class="card-body">
                        <p class="mb-2">
                            <strong>Trạng thái:</strong> 
                            <span class="badge bg-success">${order.trangThai}</span>
                        </p>
                        <hr>
                        <p class="mb-1"><strong>Người nhận:</strong> ${order.hoTenNguoiNhan}</p>
                        <p class="mb-1"><strong>Số điện thoại:</strong> ${order.sdtNguoiNhan}</p>
                        <p class="mb-0"><strong>Địa chỉ:</strong> ${order.diaChiNhanHang}</p>
                    </div>
                </div>
            </div>
            
            <!-- Danh sách sản phẩm -->
            <div class="col-lg-8">
                <h3 class="section-title" style="margin-top: 6px;">Các sản phẩm đã mua</h3>

                <div class="table-responsive">
                    <table class="table align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th style="width:90px" colspan="2">Sản phẩm</th>
                                <th style="width:150px">Đơn giá (lúc mua)</th>
                                <th style="width:110px">Số lượng</th>
                                <th class="text-end" style="width:160px">Thành tiền</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${detailList}" var="item">
                                <tr>
                                    <td>
                                        <div class="img-box">
                                            <img src="${item.product.hinhAnh}" 
                                                 alt="${item.product.tenSanPham}"
                                                 onerror="this.onerror=null;this.src='https://via.placeholder.com/70?text=No+Image';">
                                        </div>
                                    </td>
                                    <td>
                                        <div class="product-name">
                                            ${item.product.tenSanPham}
                                        </div>
                                    </td>
                                    <td>
                                        <fmt:formatNumber value="${item.donGia}" type="currency" currencyCode="VND"/>
                                    </td>
                                    <td class="text-center">${item.soLuong}</td>
                                    <td class="text-end">
                                        <fmt:formatNumber value="${item.donGia * item.soLuong}" type="currency" currencyCode="VND"/>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <hr>

                <div class="d-flex justify-content-end align-items-center">
                    <span class="me-3 fs-5">Tổng tiền đơn hàng:</span>
                    <span class="order-total">
                        <fmt:formatNumber value="${order.tongTien}" type="currency" currencyCode="VND"/>
                    </span>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>
