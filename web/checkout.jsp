<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh Toán | Phụ Kiện Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body { background-color: #f5f5f5; font-family: 'Segoe UI', sans-serif; }
        .checkout-container { background: #fff; border-radius: 8px; padding: 20px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); margin-bottom: 20px; }
        .section-title { color: #ff6600; font-weight: 700; border-bottom: 1px solid #eee; padding-bottom: 10px; margin-bottom: 20px; }
        .product-summary-img { width: 60px; height: 60px; object-fit: cover; border-radius: 5px; border: 1px solid #ddd; }
        .payment-method-card { border: 1px solid #ddd; border-radius: 8px; padding: 15px; cursor: pointer; transition: all 0.3s; }
        .payment-method-card:hover, .payment-method-card.active { border-color: #ff6600; background-color: #fff5eb; }
        .payment-method-card input { display: none; }
        .btn-confirm { background-color: #ff6600; color: white; font-weight: bold; width: 100%; padding: 12px; }
        .btn-confirm:hover { background-color: #e05a00; color: white; }
        
        /* Voucher & Ship Styles */
        .voucher-item { border: 1px dashed #ff6600; background: #fff5eb; border-radius: 8px; cursor: pointer; transition: 0.2s; }
        .voucher-item:hover { background: #ffe0cc; }
        .voucher-item.disabled { opacity: 0.5; cursor: not-allowed; background: #eee; border-color: #ccc; }
        
        .ship-option { border: 1px solid #ddd; border-radius: 8px; padding: 10px; margin-bottom: 10px; background: #f9f9f9; }
        .freeship-badge { background: #00bfa5; color: white; font-size: 0.7rem; padding: 2px 6px; border-radius: 4px; margin-left: 5px; }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />

    <div class="container mt-4 mb-5">
        <h3 class="mb-4"><i class="fas fa-money-check-alt me-2"></i>Thanh Toán</h3>
        
        <form id="checkoutForm" action="order" method="POST">
            <div class="row">
                <div class="col-lg-7">
                    
                    <div class="checkout-container">
                        <h5 class="section-title"><i class="fas fa-map-marker-alt me-2"></i>Thông Tin Nhận Hàng</h5>
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger mb-3"><i class="fas fa-exclamation-triangle me-2"></i>${errorMessage}</div>
                        </c:if>
                        <div class="mb-3">
                            <label class="form-label">Họ và tên</label>
                            <input type="text" class="form-control" id="customerName" name="hoTenGiaoHang" value="${sessionScope.acc.hoTen}" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Số điện thoại</label>
                            <input type="text" class="form-control" id="customerPhone" name="soDienThoaiGiaoHang" value="${sessionScope.acc.soDienThoai}" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Địa chỉ giao hàng</label>
                            <textarea class="form-control" id="customerAddress" name="diaChiGiaoHang" rows="2" required>${sessionScope.acc.diaChi}</textarea>
                        </div>
                    </div>

                    <div class="checkout-container">
                        <h5 class="section-title"><i class="fas fa-truck me-2"></i>Vận Chuyển & Ưu Đãi</h5>
                        
                        <div class="mb-4">
                            <label class="form-label fw-bold">Đơn vị vận chuyển:</label>
                            <div class="ship-option d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="fw-bold">Nhanh (Tiêu chuẩn)</span>
                                    <div class="text-muted small">Nhận hàng sau 2-4 ngày</div>
                                </div>
                                <div class="text-end">
                                    <div id="shipFeeText" class="fw-bold">30.000 đ</div>
                                </div>
                            </div>

                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="useFreeship" name="useFreeship" value="true" onchange="calculateTotal()">
                                <label class="form-check-label" for="useFreeship">
                                    Áp dụng mã <span class="freeship-badge">FREESHIP</span> (Miễn phí vận chuyển)
                                </label>
                            </div>
                        </div>

                        <hr>

                        <div class="d-flex justify-content-between align-items-center pt-2">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-ticket-alt text-danger me-3 fa-lg"></i>
                                <div>
                                    <div class="fw-bold">Shop Voucher</div>
                                    <small class="text-muted" id="voucherNameDisplay">Chưa chọn mã nào</small>
                                </div>
                            </div>
                            <button type="button" class="btn btn-outline-danger btn-sm" onclick="openVoucherModal()">
                                Chọn Voucher
                            </button>
                        </div>
                        
                        <input type="hidden" id="selectedDiscountInput" name="selectedDiscount" value="0">
                    </div>

                    <div class="checkout-container">
                        <h5 class="section-title"><i class="fas fa-credit-card me-2"></i>Phương Thức Thanh Toán</h5>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="payment-method-card w-100 d-flex align-items-center active" onclick="selectPayment(this)">
                                    <input type="radio" name="paymentMethod" value="cod" checked>
                                    <i class="fas fa-truck fa-2x me-3 text-secondary"></i>
                                    <div><div class="fw-bold">Thanh toán khi nhận hàng</div><small class="text-muted">COD</small></div>
                                </label>
                            </div>
                            <div class="col-md-6">
                                <label class="payment-method-card w-100 d-flex align-items-center" onclick="selectPayment(this)">
                                    <input type="radio" name="paymentMethod" value="paypal">
                                    <i class="fas fa-university fa-2x me-3 text-primary"></i>
                                    <div><div class="fw-bold">Thanh toán trực tuyến</div><small class="text-muted">Thẻ ATM / Visa / Ví</small></div>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-5">
                    <div class="checkout-container position-sticky" style="top: 90px;">
                        <h5 class="section-title">Đơn Hàng Của Bạn</h5>
                        
                        <div class="products-list mb-3" style="max-height: 300px; overflow-y: auto;">
                            <c:set var="totalMoney" value="0" />
                            <c:forEach items="${paramValues.selectedProductIds}" var="pidStr">
                                <c:set var="pid" value="${Integer.parseInt(pidStr)}" />
                                <c:set var="item" value="${sessionScope.cart.items[pid]}" />
                                <c:if test="${not empty item}">
                                    <div class="d-flex align-items-center mb-3 pb-3 border-bottom item-row" 
                                         data-name="${item.product.tenSanPham}" 
                                         data-qty="${item.quantity}" 
                                         data-price="${item.product.gia * item.quantity}">
                                        <img src="${item.product.hinhAnh}" class="product-summary-img me-3">
                                        <div class="flex-grow-1">
                                            <h6 class="mb-0 text-truncate" style="max-width: 200px;">${item.product.tenSanPham}</h6>
                                            <small class="text-muted">x${item.quantity}</small>
                                        </div>
                                        <div class="fw-bold text-end">
                                            <fmt:formatNumber value="${item.product.gia * item.quantity}" type="currency" currencyCode="VND"/>
                                        </div>
                                        <input type="hidden" name="selectedProducts" value="${item.product.maSanPham}">
                                    </div>
                                    <c:set var="totalMoney" value="${totalMoney + (item.product.gia * item.quantity)}" />
                                </c:if>
                            </c:forEach>
                        </div>

                        <div class="d-flex justify-content-between mb-2">
                            <span>Tiền hàng:</span>
                            <span><fmt:formatNumber value="${totalMoney}" type="currency" currencyCode="VND"/></span>
                            <input type="hidden" id="tempTotalValue" value="${totalMoney}">
                        </div>
                        
                        <div class="d-flex justify-content-between mb-2">
                            <span>Phí vận chuyển:</span>
                            <span id="summaryShip">30.000 đ</span>
                        </div>

                        <div class="d-flex justify-content-between mb-3 text-danger">
                            <span>Voucher giảm giá:</span>
                            <span id="summaryDiscount">- 0 đ</span>
                        </div>

                        <div class="d-flex justify-content-between border-top pt-3 mb-4">
                            <h5 class="fw-bold">Tổng thanh toán:</h5>
                            <h4 class="text-danger fw-bold" id="finalTotalStr"></h4>
                        </div>

                        <button type="button" class="btn btn-confirm rounded-pill" onclick="showConfirmPopup()">
                            XÁC NHẬN ĐẶT HÀNG
                        </button>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <div class="modal fade" id="voucherModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Chọn Voucher Giảm Giá</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body bg-light">
                    <div class="d-grid gap-2">
                        <label class="voucher-item p-3 d-flex align-items-center justify-content-between bg-white border-secondary">
                            <div><h6 class="mb-0 text-dark">Không sử dụng</h6></div>
                            <input type="radio" name="voucherOption" class="voucher-radio" value="0" data-min="0" checked>
                        </label>

                        <label class="voucher-item p-3 d-flex align-items-center justify-content-between">
                            <div>
                                <h6 class="mb-1 fw-bold text-danger">Giảm 200.000đ</h6>
                                <small class="text-muted">Đơn tối thiểu 1.000.000đ</small>
                            </div>
                            <input type="radio" name="voucherOption" class="voucher-radio" value="200000" data-min="1000000">
                        </label>

                        <label class="voucher-item p-3 d-flex align-items-center justify-content-between">
                            <div>
                                <h6 class="mb-1 fw-bold text-danger">Giảm 500.000đ</h6>
                                <small class="text-muted">Đơn tối thiểu 3.000.000đ</small>
                            </div>
                            <input type="radio" name="voucherOption" class="voucher-radio" value="500000" data-min="3000000">
                        </label>

                        <label class="voucher-item p-3 d-flex align-items-center justify-content-between">
                            <div>
                                <h6 class="mb-1 fw-bold text-danger">Giảm 1.000.000đ</h6>
                                <small class="text-muted">Đơn tối thiểu 10.000.000đ</small>
                            </div>
                            <input type="radio" name="voucherOption" class="voucher-radio" value="1000000" data-min="10000000">
                        </label>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary w-100" onclick="applyVoucher()">Áp Dụng</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="confirmModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header bg-light">
                    <h5 class="modal-title fw-bold">Xác Nhận Đặt Hàng</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="d-flex justify-content-between"><span>Tiền hàng:</span> <span id="confSubTotal"></span></div>
                    <div class="d-flex justify-content-between"><span>Phí vận chuyển:</span> <span id="confShip"></span></div>
                    <div class="d-flex justify-content-between text-danger"><span>Voucher:</span> <span id="confVoucher"></span></div>
                    <hr>
                    <div class="d-flex justify-content-between fs-5 fw-bold"><span>Tổng thanh toán:</span> <span class="text-danger" id="confTotal"></span></div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-primary" onclick="submitOrder()">Xác Nhận</button>
                </div>
            </div>
        </div>
    </div>

    <div class="toast-container position-fixed bottom-0 end-0 p-3">
        <div id="successToast" class="toast align-items-center text-bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex"><div class="toast-body"><i class="fas fa-check-circle me-2"></i> Đặt hàng thành công!</div></div>
        </div>
    </div>

    <jsp:include page="footer.jsp" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        const STANDARD_SHIP = 30000;
        let tempTotal = parseFloat(document.getElementById('tempTotalValue').value);
        
        let currentShip = STANDARD_SHIP;
        let currentDiscount = 0;

        // 1. Hàm tính toán chung (Gọi khi đổi Ship hoặc đổi Voucher)
        function calculateTotal() {
            const fmt = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' });

            // A. Xử lý Vận chuyển (Từ Checkbox)
            const isFreeship = document.getElementById('useFreeship').checked;
            if (isFreeship) {
                currentShip = 0;
                document.getElementById('shipFeeText').innerText = "0 đ (Đã áp mã)";
                document.getElementById('shipFeeText').classList.add("text-success");
            } else {
                currentShip = STANDARD_SHIP;
                document.getElementById('shipFeeText').innerText = "30.000 đ";
                document.getElementById('shipFeeText').classList.remove("text-success");
            }

            // B. Xử lý Voucher Giảm giá (Từ biến toàn cục do Modal set)
            // (Đã được set trong applyVoucher)

            // C. Hiển thị ra Tóm tắt
            document.getElementById('summaryShip').innerText = fmt.format(currentShip);
            document.getElementById('summaryDiscount').innerText = '- ' + fmt.format(currentDiscount);

            // D. Tính tổng cuối
            let final = tempTotal + currentShip - currentDiscount;
            if(final < 0) final = 0;
            document.getElementById('finalTotalStr').innerText = fmt.format(final);
        }

        // 2. Mở Modal Voucher
        function openVoucherModal() {
            const radios = document.querySelectorAll('.voucher-radio');
            radios.forEach(r => {
                const min = parseFloat(r.dataset.min);
                const label = r.closest('.voucher-item');
                if (tempTotal < min) {
                    r.disabled = true;
                    label.classList.add('disabled');
                    if(r.checked) document.querySelector('input[value="0"]').checked = true;
                } else {
                    r.disabled = false;
                    label.classList.remove('disabled');
                }
            });
            new bootstrap.Modal(document.getElementById('voucherModal')).show();
        }

        // 3. Áp dụng Voucher từ Modal
        function applyVoucher() {
            const selected = document.querySelector('input[name="voucherOption"]:checked');
            currentDiscount = parseFloat(selected.value);
            
            // Cập nhật input ẩn để gửi lên server
            document.getElementById('selectedDiscountInput').value = currentDiscount;
            
            // Hiển thị tên voucher
            let msg = "Chưa chọn mã nào";
            if (currentDiscount > 0) {
                msg = "Đã chọn mã giảm " + (currentDiscount/1000) + "k";
            }
            document.getElementById('voucherNameDisplay').innerText = msg;

            // Đóng modal và tính lại tiền
            bootstrap.Modal.getInstance(document.getElementById('voucherModal')).hide();
            calculateTotal();
        }

        // 4. Show Popup Xác Nhận
        function showConfirmPopup() {
            const form = document.getElementById('checkoutForm');
            if (!form.checkValidity()) { form.reportValidity(); return; }

            const fmt = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' });
            
            document.getElementById('confSubTotal').innerText = fmt.format(tempTotal);
            document.getElementById('confShip').innerText = fmt.format(currentShip);
            document.getElementById('confVoucher').innerText = '- ' + fmt.format(currentDiscount);
            
            let final = tempTotal + currentShip - currentDiscount;
            if(final < 0) final = 0;
            document.getElementById('confTotal').innerText = fmt.format(final);

            new bootstrap.Modal(document.getElementById('confirmModal')).show();
        }

        function submitOrder() {
            bootstrap.Modal.getInstance(document.getElementById('confirmModal')).hide();
            new bootstrap.Toast(document.getElementById('successToast')).show();
            setTimeout(() => document.getElementById('checkoutForm').submit(), 1500);
        }
        
        function selectPayment(el) {
            document.querySelectorAll('.payment-method-card').forEach(e => e.classList.remove('active'));
            el.classList.add('active');
            el.querySelector('input').checked = true;
        }

        // Init
        calculateTotal();
    </script>
</body>
</html>