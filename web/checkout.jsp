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

        /* Khung chính */
        .checkout-container {
            background: #fff; border-radius: 14px; padding: 28px;
            box-shadow: 0 4px 14px rgba(0,0,0,0.08); margin-bottom: 28px;
        }

        /* Tiêu đề */
        .section-title {
            color: #ff6600; font-weight: 700; font-size: 20px;
            border-left: 6px solid #ff6600; padding-left: 12px; margin-bottom: 22px;
        }

        /* Sản phẩm */
        .product-summary-img {
            width: 70px; height: 70px; object-fit: cover;
            border-radius: 8px; border: 1px solid #ddd;
        }

        /* Button Đặt hàng */
        .btn-confirm {
            background-color: #ff6600; color: white; font-weight: 700; font-size: 18px;
            width: 100%; padding: 15px 0; border-radius: 50px; transition: 0.25s;
        }
        .btn-confirm:hover {
            background-color: #e25900; box-shadow: 0 4px 12px rgba(255,102,0,0.3);
        }

        /* Box chọn */
        .selected-box {
            border: 1px solid #ddd; border-radius: 12px; padding: 22px;
            background: #fafafa; display: flex; align-items: center; justify-content: space-between;
            transition: 0.25s;
        }
        .selected-box:hover { border-color: #ff6600; background: #fff3eb; }

        /* Cards */
        .payment-method-card, .voucher-item {
            border: 1px solid #ddd; border-radius: 12px; padding: 18px;
            cursor: pointer; display: flex; transition: 0.25s; align-items: center;
        }
        .payment-method-card:hover, .payment-method-card.active, .voucher-item.active {
            background-color: #fff4e8; border-color: #ff6600;
            box-shadow: 0 3px 10px rgba(255,102,0,0.2);
        }

        button, .btn { border-radius: 12px; font-size: 1rem !important; }
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
                            <div class="alert alert-danger mb-3">${errorMessage}</div>
                        </c:if>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Họ tên</label>
                                <input type="text" class="form-control" id="inputName" name="hoTenGiaoHang" value="${sessionScope.acc.hoTen}" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Số điện thoại</label>
                                <input type="text" class="form-control" id="inputPhone" name="soDienThoaiGiaoHang" value="${sessionScope.acc.soDienThoai}" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-bold">Địa chỉ giao hàng</label>
                                
                                <div id="old-address-box" class="alert alert-success d-flex justify-content-between align-items-start p-2" 
                                     style="${empty sessionScope.acc.diaChi ? 'display:none;' : ''}">
                                    <div class="d-flex align-items-start" style="flex: 1; margin-right: 10px;">
                                        <i class="fas fa-home text-danger me-2 mt-1 flex-shrink-0"></i>
                                        <span id="txt-old-address" style="word-wrap: break-word; word-break: break-word; line-height: 1.4;">
                                            ${sessionScope.acc.diaChi}
                                        </span>
                                    </div>
                                    <button type="button" class="btn btn-sm btn-outline-primary text-nowrap ms-2 flex-shrink-0" onclick="showNewAddressForm()">
                                        Thay đổi
                                    </button>
                                </div>

                                <div id="new-address-form" style="${not empty sessionScope.acc.diaChi ? 'display: none;' : ''}">
                                    <div class="card card-body bg-light border-0 p-3">
                                        <div class="row g-2 mb-2">
                                            <div class="col-md-4">
                                                <select class="form-select form-select-sm" id="tinh" title="Tỉnh Thành"><option value="0">Tỉnh Thành</option></select>
                                            </div>
                                            <div class="col-md-4">
                                                <select class="form-select form-select-sm" id="quan" title="Quận Huyện"><option value="0">Quận Huyện</option></select>
                                            </div>
                                            <div class="col-md-4">
                                                <select class="form-select form-select-sm" id="phuong" title="Phường Xã"><option value="0">Phường Xã</option></select>
                                            </div>
                                        </div>
                                        <input type="text" id="soNha" class="form-control form-control-sm" placeholder="Số nhà, tên đường cụ thể...">
                                        
                                        <div class="d-flex justify-content-between align-items-center mt-3">
                                            <button type="button" class="btn btn-sm btn-link text-danger text-decoration-none p-0" onclick="cancelNewAddress()">
                                                Hủy bỏ
                                            </button>
                                            <button type="button" class="btn btn-sm btn-success" onclick="confirmNewAddress()">
                                                <i class="fas fa-check"></i> Xác nhận địa chỉ này
                                            </button>
                                        </div>
                                    </div>
                                </div>

                                <input type="hidden" name="diaChiGiaoHang" id="finalAddress" value="${sessionScope.acc.diaChi}">
                                <input type="hidden" id="isUsingNewAddress" value="false">
                                <input type="hidden" id="isFormOpen" value="${empty sessionScope.acc.diaChi ? 'true' : 'false'}">
                            </div>
                        </div>
                    </div>

                    <div class="checkout-container">
                        <h5 class="section-title"><i class="fas fa-truck-moving me-2"></i>Vận Chuyển</h5>
                        <div class="selected-box mb-3">
                            <div>
                                <div class="fw-bold text-dark" id="displayShipMethodName">Nhanh (Tiêu chuẩn)</div>
                                <div class="text-muted small" id="displayShipDate">Nhận hàng 2-4 ngày</div>
                                <div class="text-success small fw-bold mt-1" id="displayFreeshipTag" style="display:none;">
                                    <i class="fas fa-check-circle"></i> Đã áp mã Freeship
                                </div>
                            </div>
                            <div class="text-end">
                                <div class="fw-bold text-dark" id="displayShipPrice">30.000 đ</div>
                                <button type="button" class="btn btn-link text-decoration-none p-0 text-primary" onclick="openShipModal()">Thay đổi</button>
                            </div>
                        </div>
                        <input type="hidden" id="inputShippingMethod" name="shippingMethod" value="30000">
                        <input type="hidden" id="inputShipDiscount" name="shipDiscount" value="0">
                    </div>

                    <div class="checkout-container">
                        <h5 class="section-title"><i class="fas fa-tags me-2"></i>Ưu Đãi Của Shop</h5>
                        <div class="selected-box">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-tag text-danger me-3 fa-lg"></i>
                                <div>
                                    <div class="fw-bold text-danger">Shop Voucher</div>
                                    <small class="text-muted" id="shopVoucherName">Chưa chọn mã</small>
                                </div>
                            </div>
                            <button type="button" class="btn btn-sm btn-outline-danger" onclick="openShopModal()">Chọn Mã</button>
                        </div>
                        <input type="hidden" id="shopDiscountInput" name="shopDiscount" value="0">
                    </div>

                    <div class="checkout-container">
                        <h5 class="section-title"><i class="fas fa-wallet me-2"></i>Thanh Toán</h5>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="payment-method-card w-100 d-flex align-items-center active" onclick="selectPayment(this)">
                                    <input type="radio" name="paymentMethod" value="cod" checked>
                                    <i class="fas fa-money-bill-wave fa-2x me-3 text-secondary"></i>
                                    <div><div class="fw-bold">Tiền mặt (COD)</div></div>
                                </label>
                            </div>
                            <div class="col-md-6">
                                <label class="payment-method-card w-100 d-flex align-items-center" onclick="selectPayment(this)">
                                    <input type="radio" name="paymentMethod" value="paypal">
                                    <i class="fab fa-paypal fa-2x me-3 text-primary"></i>
                                    <div><div class="fw-bold">PayPal / Thẻ</div></div>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-5">
                    <div class="checkout-container position-sticky" style="top: 20px;">
                        <h5 class="section-title">Đơn Hàng</h5>
                        
                        <div class="products-list mb-3" style="max-height: 250px; overflow-y: auto;">
                            <c:set var="totalMoney" value="0" />
                            <c:forEach items="${paramValues.selectedProductIds}" var="pidStr">
                                <c:set var="pid" value="${Integer.parseInt(pidStr)}" />
                                <c:set var="item" value="${sessionScope.cart.items[pid]}" />
                                <c:if test="${not empty item}">
                                    <div class="d-flex align-items-center mb-2 pb-2 border-bottom item-row"
                                         data-name="${item.product.tenSanPham}" data-qty="${item.quantity}">
                                        <img src="${item.product.hinhAnh}" class="product-summary-img me-2">
                                        <div class="flex-grow-1 lh-1">
                                            <div class="text-truncate small fw-bold" style="max-width: 180px;">${item.product.tenSanPham}</div>
                                            <small class="text-muted">x${item.quantity}</small>
                                        </div>
                                        <div class="fw-bold small text-end"><fmt:formatNumber value="${item.product.gia * item.quantity}" type="currency" currencyCode="VND"/></div>
                                        <input type="hidden" name="selectedProducts" value="${item.product.maSanPham}">
                                    </div>
                                    <c:set var="totalMoney" value="${totalMoney + (item.product.gia * item.quantity)}" />
                                </c:if>
                            </c:forEach>
                        </div>

                        <div class="d-flex justify-content-between mb-1">
                            <span class="text-muted">Tổng tiền hàng:</span>
                            <span class="fw-bold"><fmt:formatNumber value="${totalMoney}" type="currency" currencyCode="VND"/></span>
                            <input type="hidden" id="tempTotalValue" value="${totalMoney}">
                        </div>
                        
                        <div class="d-flex justify-content-between mb-1">
                            <span class="text-muted">Phí vận chuyển:</span>
                            <span id="summaryShip">30.000 đ</span>
                        </div>

                        <div class="d-flex justify-content-between mb-1 text-success">
                            <span>Giảm phí vận chuyển:</span>
                            <span id="summaryShipDiscount">- 0 đ</span>
                        </div>

                        <div class="d-flex justify-content-between mb-3 text-danger">
                            <span>Voucher giảm giá:</span>
                            <span id="summaryShopDiscount">- 0 đ</span>
                        </div>

                        <div class="d-flex justify-content-between border-top pt-3 mb-4">
                            <h5 class="fw-bold">Tổng thanh toán:</h5>
                            <h4 class="text-danger fw-bold" id="finalTotalStr"></h4>
                        </div>

                        <button type="button" class="btn btn-confirm rounded-pill shadow" onclick="showConfirmPopup()">ĐẶT HÀNG</button>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <div class="modal fade" id="shipVoucherModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Chọn Phương Thức Vận Chuyển</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body bg-light">
                    <h6 class="fw-bold mb-2">Đơn vị vận chuyển</h6>
                    <div class="d-grid gap-2 mb-4">
                        <label class="voucher-item p-3 d-flex align-items-center justify-content-between active" onclick="selectRadioStyle(this)">
                            <div>
                                <h6 class="mb-0 fw-bold">Nhanh (Tiêu chuẩn) - 30k</h6>
                                <small class="text-muted">Nhận hàng 2-4 ngày</small>
                            </div>
                            <input type="radio" name="modalShipMethod" value="30000" checked>
                        </label>
                        <label class="voucher-item p-3 d-flex align-items-center justify-content-between" onclick="selectRadioStyle(this)">
                            <div>
                                <h6 class="mb-0 fw-bold text-warning"><i class="fas fa-bolt"></i> Hỏa Tốc - 89k</h6>
                                <small class="text-muted">Nhận hàng trong 2 giờ</small>
                            </div>
                            <input type="radio" name="modalShipMethod" value="89000">
                        </label>
                    </div>
                    <hr>
                    <h6 class="fw-bold mb-2">Mã Vận Chuyển (Freeship)</h6>
                    <div class="d-grid gap-2">
                        <label class="voucher-item p-3 d-flex align-items-center justify-content-between border-success bg-white" id="freeshipOption">
                            <div class="d-flex align-items-center">
                                <div class="bg-success text-white rounded p-2 me-3"><i class="fas fa-truck"></i></div>
                                <div>
                                    <h6 class="mb-0 fw-bold text-success">Miễn Phí Vận Chuyển</h6>
                                    <small class="text-muted">Đơn tối thiểu 3.000.000đ</small>
                                </div>
                            </div>
                            <input type="checkbox" id="modalFreeshipCheck" value="300000" style="transform: scale(1.3);">
                        </label>
                        <small class="text-danger fst-italic" id="freeshipWarning" style="display:none;">* Đơn hàng chưa đủ 3 triệu để áp dụng.</small>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-success w-100" onclick="applyShipData()">Xác Nhận</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="shopVoucherModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header"><h5 class="modal-title fw-bold text-danger">Chọn Voucher Giảm Giá</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
                <div class="modal-body bg-light">
                    <div class="d-grid gap-2">
                        <label class="voucher-item p-3 d-flex align-items-center justify-content-between bg-white">
                            <div><h6 class="mb-0">Không sử dụng</h6></div>
                            <input type="radio" name="shopVoucherOption" value="0" data-min="0" checked>
                        </label>
                        <label class="voucher-item p-3 d-flex align-items-center justify-content-between">
                            <div><h6 class="mb-1 fw-bold text-danger">Giảm 200k</h6><small class="text-muted">Đơn > 1 triệu</small></div>
                            <input type="radio" name="shopVoucherOption" value="200000" data-min="1000000">
                        </label>
                        <label class="voucher-item p-3 d-flex align-items-center justify-content-between">
                            <div><h6 class="mb-1 fw-bold text-danger">Giảm 500k</h6><small class="text-muted">Đơn > 3 triệu</small></div>
                            <input type="radio" name="shopVoucherOption" value="500000" data-min="3000000">
                        </label>
                        <label class="voucher-item p-3 d-flex align-items-center justify-content-between">
                            <div><h6 class="mb-1 fw-bold text-danger">Giảm 1 Triệu</h6><small class="text-muted">Đơn > 10 triệu</small></div>
                            <input type="radio" name="shopVoucherOption" value="1000000" data-min="10000000">
                        </label>
                    </div>
                </div>
                <div class="modal-footer"><button type="button" class="btn btn-danger w-100" onclick="applyShopVoucher()">Áp Dụng</button></div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="confirmModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header bg-light"><h5 class="modal-title fw-bold">Xác Nhận Đặt Hàng</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
                <div class="modal-body">
                    <div class="mb-3 border-bottom pb-3">
                        <h6 class="fw-bold text-primary mb-2"><i class="fas fa-user-check me-2"></i>Thông Tin Giao Hàng</h6>
                        <div class="ms-3">
                            <p class="mb-1 small"><strong>Người nhận:</strong> <span id="confName" class="text-dark"></span></p>
                            <p class="mb-1 small"><strong>SĐT:</strong> <span id="confPhone" class="text-dark"></span></p>
                            <p class="mb-0 small"><strong>Địa chỉ:</strong> <span id="confAddress" class="text-dark"></span></p>
                        </div>
                    </div>
                    <div class="d-flex justify-content-between"><span>Tổng tiền hàng:</span> <span id="confSubTotal"></span></div>
                    <div class="d-flex justify-content-between text-success"><span>Tổng phí vận chuyển:</span> <span id="confShipTotal"></span></div>
                    <div class="d-flex justify-content-between text-danger"><span>Voucher giảm giá:</span> <span id="confDiscount"></span></div>
                    <hr>
                    <div class="d-flex justify-content-between fs-5 fw-bold"><span>Thanh toán:</span> <span class="text-danger" id="confTotal"></span></div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-primary" onclick="submitOrder()">Xác Nhận</button>
                </div>
            </div>
        </div>
    </div>

    <div class="toast-container position-fixed bottom-0 end-0 p-3">
        <div id="successToast" class="toast align-items-center text-bg-success border-0"><div class="d-flex"><div class="toast-body">Đặt hàng thành công!</div></div></div>
    </div>

    <jsp:include page="footer.jsp" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // --- 1. BIẾN TOÀN CỤC ---
            const tempTotalEl = document.getElementById('tempTotalValue');
            let subTotal = tempTotalEl ? parseFloat(tempTotalEl.value) : 0;
            let baseShip = 30000;
            let shipDiscount = 0;
            let shopDiscount = 0;

            // --- 2. HÀM TÍNH TỔNG ---
            window.calculateTotal = function() { // Expose to window to be used by other scripts
                let realShipDiscount = (shipDiscount > baseShip) ? baseShip : shipDiscount;
                let finalShip = baseShip - realShipDiscount;
                let finalTotal = subTotal + finalShip - shopDiscount;
                if(finalTotal < 0) finalTotal = 0;

                const fmt = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' });
                document.getElementById('summaryShip').innerText = fmt.format(baseShip);
                document.getElementById('summaryShipDiscount').innerText = '- ' + fmt.format(realShipDiscount);
                document.getElementById('summaryShopDiscount').innerText = '- ' + fmt.format(shopDiscount);
                document.getElementById('finalTotalStr').innerText = fmt.format(finalTotal);
                
                // Return values for modal use
                return { subTotal, finalShip, shopDiscount, finalTotal };
            }

            // --- 3. XỬ LÝ MODAL VẬN CHUYỂN ---
            window.openShipModal = function() {
                const check = document.getElementById('modalFreeshipCheck');
                const label = document.getElementById('freeshipOption');
                const hint = document.getElementById('freeshipWarning');

                if (subTotal < 3000000) {
                    check.disabled = true; check.checked = false;
                    label.classList.add('disabled'); hint.style.display = 'block';
                } else {
                    check.disabled = false; label.classList.remove('disabled');
                    hint.style.display = 'none';
                }
                new bootstrap.Modal(document.getElementById('shipVoucherModal')).show();
            }

            window.applyShipData = function() {
                const selectedMethod = document.querySelector('input[name="modalShipMethod"]:checked');
                baseShip = parseFloat(selectedMethod.value);
                
                if (baseShip === 30000) {
                    document.getElementById('displayShipMethodName').innerText = "Nhanh (Tiêu chuẩn)";
                    document.getElementById('displayShipDate').innerText = "Nhận hàng 2-4 ngày";
                } else {
                    document.getElementById('displayShipMethodName').innerText = "Hỏa Tốc";
                    document.getElementById('displayShipDate').innerText = "Nhận hàng trong 2 giờ";
                }
                document.getElementById('displayShipPrice').innerText = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(baseShip);
                const isFreeship = document.getElementById('modalFreeshipCheck').checked;
                shipDiscount = isFreeship ? 300000 : 0;
                document.getElementById('displayFreeshipTag').style.display = isFreeship ? 'block' : 'none';
                document.getElementById('inputShippingMethod').value = baseShip;
                document.getElementById('inputShipDiscount').value = shipDiscount;

                bootstrap.Modal.getInstance(document.getElementById('shipVoucherModal')).hide();
                calculateTotal();
            }

            // --- 4. XỬ LÝ MODAL SHOP VOUCHER ---
            window.openShopModal = function() {
                document.querySelectorAll('input[name="shopVoucherOption"]').forEach(r => {
                    const min = parseFloat(r.getAttribute('data-min'));
                    const label = r.closest('.voucher-item');
                    if (subTotal < min) {
                        r.disabled = true; label.classList.add('disabled');
                        if(r.checked) document.querySelector('input[name="shopVoucherOption"][value="0"]').checked = true;
                    } else {
                        r.disabled = false; label.classList.remove('disabled');
                    }
                });
                new bootstrap.Modal(document.getElementById('shopVoucherModal')).show();
            }

            window.applyShopVoucher = function() {
                const selected = document.querySelector('input[name="shopVoucherOption"]:checked');
                shopDiscount = parseFloat(selected.value);
                document.getElementById('shopDiscountInput').value = shopDiscount;
                
                let msg = "Chưa chọn mã";
                if(shopDiscount > 0) msg = "Đã chọn mã giảm " + (shopDiscount/1000) + "k";
                document.getElementById('shopVoucherName').innerText = msg;

                bootstrap.Modal.getInstance(document.getElementById('shopVoucherModal')).hide();
                calculateTotal();
            }

            // --- 5. UI HELPER ---
            window.selectRadioStyle = function(element) {
                const radio = element.querySelector('input[type="radio"]');
                const name = radio.getAttribute('name');
                document.querySelectorAll(`input[name="\${name}"]`).forEach(inp => {
                    inp.closest('.voucher-item').classList.remove('active');
                });
                element.classList.add('active');
                radio.checked = true;
            }

            window.selectPayment = function(el) {
                document.querySelectorAll('.payment-method-card').forEach(e => e.classList.remove('active'));
                el.classList.add('active');
                el.querySelector('input').checked = true;
            }

            // --- 6. POPUP CONFIRM ---
            window.showConfirmPopup = function() {
                const form = document.getElementById('checkoutForm');
                if (!form.checkValidity()) { form.reportValidity(); return; }
                
                // KIỂM TRA: Có đang sửa địa chỉ mà chưa lưu không?
                if ($("#isUsingNewAddress").val() === "true") {
                    alert("Vui lòng bấm nút 'Xác nhận địa chỉ này' (màu xanh) trước khi đặt hàng!");
                    return;
                }
                
                // KIỂM TRA: Địa chỉ có trống không?
                var finalAddr = document.getElementById('finalAddress').value;
                if (!finalAddr || finalAddr.trim() === "") {
                    alert("Vui lòng nhập và xác nhận địa chỉ giao hàng!");
                    return;
                }

                const totals = calculateTotal();
                const fmt = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' });

                // Lấy thông tin hiển thị
                document.getElementById('confName').innerText = document.getElementById('inputName').value;
                document.getElementById('confPhone').innerText = document.getElementById('inputPhone').value;
                
                // [FIX QUAN TRỌNG] Lấy từ hidden input đã được API cập nhật
                document.getElementById('confAddress').innerText = finalAddr;

                document.getElementById('confSubTotal').innerText = fmt.format(totals.subTotal);
                document.getElementById('confShipTotal').innerText = fmt.format(totals.finalShip);
                document.getElementById('confDiscount').innerText = '- ' + fmt.format(totals.shopDiscount);
                document.getElementById('confTotal').innerText = fmt.format(totals.finalTotal);

                new bootstrap.Modal(document.getElementById('confirmModal')).show();
            }

            calculateTotal();
        });
    </script>
   
    <script>
        $(document).ready(function() {
            $.getJSON('https://esgoo.net/api-tinhthanh/1/0.htm', function(data_tinh) {
                if (data_tinh.error == 0) {
                    $.each(data_tinh.data, function(key_tinh, val_tinh) {
                        $("#tinh").append('<option value="' + val_tinh.id + '">' + val_tinh.full_name + '</option>');
                    });
                    $("#tinh").change(function(e) {
                        var idtinh = $(this).val();
                        $("#quan").html('<option value="0">Quận Huyện</option>');
                        $("#phuong").html('<option value="0">Phường Xã</option>');
                        if(idtinh == "0") return;
                        $.getJSON('https://esgoo.net/api-tinhthanh/2/' + idtinh + '.htm', function(data_quan) {
                            if (data_quan.error == 0) {
                                $.each(data_quan.data, function(key_quan, val_quan) {
                                    $("#quan").append('<option value="' + val_quan.id + '">' + val_quan.full_name + '</option>');
                                });
                                $("#quan").change(function(e) {
                                    var idquan = $(this).val();
                                    $("#phuong").html('<option value="0">Phường Xã</option>');
                                    if(idquan == "0") return;
                                    $.getJSON('https://esgoo.net/api-tinhthanh/3/' + idquan + '.htm', function(data_phuong) {
                                        if (data_phuong.error == 0) {
                                            $.each(data_phuong.data, function(key_phuong, val_phuong) {
                                                $("#phuong").append('<option value="' + val_phuong.id + '">' + val_phuong.full_name + '</option>');
                                            });
                                        }
                                    });
                                });
                            }
                        });
                    });
                }
            });
        });

        function showNewAddressForm() {
            $("#old-address-box").slideUp();
            $("#new-address-form").slideDown();
            $("#isUsingNewAddress").val("true"); // Đánh dấu đang sửa
        }

        function cancelNewAddress() {
            if ($("#finalAddress").val().trim() === "") {
                alert("Bạn chưa có địa chỉ, vui lòng nhập đầy đủ!");
                return;
            }
            $("#new-address-form").slideUp();
            $("#old-address-box").slideDown();
            $("#isUsingNewAddress").val("false"); // Hủy sửa
        }
        
        function confirmNewAddress() {
            var t = $("#tinh option:selected").text();
            var q = $("#quan option:selected").text();
            var p = $("#phuong option:selected").text();
            var s = $("#soNha").val().trim();

            if ($("#tinh").val() == 0 || $("#quan").val() == 0 || $("#phuong").val() == 0 || s === "") {
                alert("Vui lòng chọn đầy đủ: Tỉnh, Huyện, Xã và Số nhà!");
                return;
            }

            var fullAddress = s + ", " + p + ", " + q + ", " + t;
            $("#txt-old-address").text(fullAddress);
            $("#finalAddress").val(fullAddress);
            
            $("#new-address-form").slideUp(); 
            $("#old-address-box").removeClass("d-none").slideDown();
            $("#isUsingNewAddress").val("false"); // Đã xác nhận xong
        }

        function submitOrder() {
            // Kiểm tra lần cuối (Double Check)
            if ($("#isUsingNewAddress").val() === "true") {
                alert("Vui lòng bấm nút 'Xác nhận địa chỉ này' trước khi đặt hàng!");
                var confirmModal = bootstrap.Modal.getInstance(document.getElementById('confirmModal'));
                if(confirmModal) confirmModal.hide();
                return;
            }
            if ($("#finalAddress").val().trim() === "") {
                alert("Lỗi: Địa chỉ giao hàng không được để trống!");
                return;
            }

            // Ẩn modal và hiện thông báo thành công
            var confirmModal = bootstrap.Modal.getInstance(document.getElementById('confirmModal'));
            if(confirmModal) confirmModal.hide();
            
            var toastEl = document.getElementById('successToast');
            if(toastEl) {
                var toast = new bootstrap.Toast(toastEl);
                toast.show();
            }
            
            // Submit form sau 1.5 giây
            setTimeout(() => document.getElementById('checkoutForm').submit(), 1500);
        }
    </script>
</body>
</html>