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
        <a href="manage-order" class="btn btn-outline-secondary mb-3">
            <i class="fas fa-arrow-left"></i> Quay lại Danh sách
        </a>
        
        <h2 class="mb-4">Chi Tiết Đơn Hàng #${order.maDonHang}</h2>

        <div class="row g-4">
            <div class="col-lg-6">
                <div class="card h-100">
                    <div class="card-header">
                        <h5>Thông Tin Người Nhận</h5>
                    </div>
                    <div class="card-body">
                        <p><strong>Người Đặt (TK):</strong> ${order.tenNguoiDat}</p>
                        <hr>
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
                        <h5>Cập Nhật Trạng Thái</h5>
                    </div>
                    <div class="card-body">
                        <form action="manage-order" method="post">
                            <input type="hidden" name="action" value="updateStatus">
                            <input type="hidden" name="orderId" value="${order.maDonHang}">
                            
                            <div class="mb-3">
                                <label for="statusSelect" class="form-label">Trạng Thái Hiện Tại:</label>
                                <select id="statusSelect" name="status" class="form-select form-select-lg">
                                    <option value="Dang xu ly" ${order.trangThai == 'Dang xu ly' ? 'selected' : ''}>Đang xử lý</option>
                                    <option value="Da Thanh Toan" ${order.trangThai == 'Da Thanh Toan' ? 'selected' : ''}>Đã Thanh Toán (PayPal)</option>
                                    <option value="Dang giao" ${order.trangThai == 'Dang giao' ? 'selected' : ''}>Đang giao</option>
                                    <option value="Da giao" ${order.trangThai == 'Da giao' ? 'selected' : ''}>Đã giao</giao>
                                    <option value="Da huy" ${order.trangThai == 'Da huy' ? 'selected' : ''}>Đã hủy</option>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-success w-100">Cập Nhật</button>
                        </form>
                    </div>
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
                                    <%-- SỬA LỖI: Cần gọi d.product.hinhAnh --%>
                                    <img src="${d.product.hinhAnh}" class="img-fluid rounded">
                                </td>
                                <td>${d.product.tenSanPham}</td>
                                <td>
                                    <%-- SỬA LỖI: d.price -> d.donGia --%>
                                    <fmt:formatNumber value="${d.donGia}" type="currency" currencyCode="VND" minFractionDigits="0"/>
                                </td>
                                <td>
                                    <%-- SỬA LỖI: d.quantity -> d.soLuong --%>
                                    x ${d.soLuong}
                                </td>
                                <td class="text-end fw-bold">
                                    <%-- SỬA LỖI: d.totalPrice (hàm mới) --%>
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