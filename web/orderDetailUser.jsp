<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Chi Tiết Đơn Hàng #${order.maDonHang}</title>
</head>
<body>
    <jsp:include page="header.jsp" />

    <div class="container mt-5">
        <a href="order-history" class="btn btn-outline-secondary mb-3">
            <i class="fas fa-arrow-left"></i> Quay lại Lịch sử
        </a>
        
        <h2 class="mb-4">Chi Tiết Đơn Hàng #${order.maDonHang}</h2>

        <div class="row g-4">
            <div class="col-lg-6">
                <div class="card h-100">
                    <div class="card-header">
                        <h5>Thông Tin Nhận Hàng</h5>
                    </div>
                    <div class="card-body">
                        <p><strong>Người Nhận:</strong> ${order.hoTenNguoiNhan}</p>
                        <p><strong>Số Điện Thoại:</strong> ${order.sdtNguoiNhan}</p>
                        <p><strong>Địa Chỉ Giao:</strong> ${order.diaChiNhanHang}</p>
                        <hr>
                        <p><strong>Ngày Đặt:</strong> <fmt:formatDate value="${order.ngayDat}" pattern="dd-MM-yyyy HH:mm"/>
                        </p>
                        <p class="fw-bold fs-5">
                            Tổng Tiền: 
                            <span class="text-danger">
                                <fmt:formatNumber value="${order.tongTien}" type="currency" currencyCode="VND" minFractionDigits="0"/>
                            </span>
                        </p>
                    </div>
                </div>
            </div>
            
           <div class="col-lg-6">
                <div class="card h-100">
                    <div class="card-header">
                        <h5>Trạng Thái Đơn Hàng</h5>
                    </div>
                    <div class="card-body text-center">
                        
                        <div class="mb-3">
                            <c:choose>
                                <c:when test="${order.trangThai == 'Dang xu ly'}">
                                    <h4 class="text-warning text-uppercase"><i class="fas fa-clock"></i> Đang xử lý</h4>
                                </c:when>
                                <c:when test="${order.trangThai == 'Da Thanh Toan'}">
                                    <h4 class="text-info text-uppercase"><i class="fab fa-paypal"></i> Đã Thanh Toán</h4>
                                </c:when>
                                <c:when test="${order.trangThai == 'Dang giao'}">
                                    <h4 class="text-primary text-uppercase"><i class="fas fa-truck"></i> Đang giao</h4>
                                </c:when>
                                <c:when test="${order.trangThai == 'Da giao'}">
                                    <h4 class="text-success text-uppercase"><i class="fas fa-check-circle"></i> Giao thành công</h4>
                                </c:when>
                                <c:when test="${order.trangThai == 'Da huy'}">
                                    <h4 class="text-danger text-uppercase"><i class="fas fa-times-circle"></i> Đã Hủy</h4>
                                </c:when>
                            </c:choose>
                        </div>

                        <c:if test="${order.trangThai == 'Dang xu ly'}">
                            <hr>
                            <p class="text-muted small">Bạn muốn hủy đơn hàng này?</p>
                            <a href="order-history?action=cancel&id=${order.maDonHang}" 
                               class="btn btn-outline-danger w-100"
                               onclick="return confirm('Bạn có chắc chắn muốn hủy đơn hàng này không? Hành động này không thể hoàn tác.');">
                                <i class="fas fa-trash-alt"></i> Hủy Đơn Hàng
                            </a>
                        </c:if>
                        
                    </div>
                </div>
            </div>

        <div class="card mt-4">
            <div class="card-header">
                <h5>Các Sản Phẩm Trong Đơn</h5>
            </div>
            <div class="card-body">
                <table class="table align-middle">
                    <thead>
                        <tr>
                            <th scope="col" colspan="2">Sản Phẩm</th>
                            <th scope="col">Giá (lúc mua)</th>
                            <th scope="col">Số Lượng</th>
                            <th scope="col" class="text-end">Thành Tiền</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${detailList}" var="d">
                            <tr>
                                <td style="width: 80px;">
                                    <img src="${d.product.hinhAnh}" class="img-fluid rounded">
                                </td>
                                <td>${d.product.tenSanPham}</td>
                                <td>
                                    <fmt:formatNumber value="${d.donGia}" type="currency" currencyCode="VND" minFractionDigits="0"/>
                                </td>
                                <td>x ${d.soLuong}</td>
                                <td class="text-end fw-bold">
                                    <fmt:formatNumber value="${d.totalPrice}" type="currency" currencyCode="VND" minFractionDigits="0"/>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
</body>
</html>