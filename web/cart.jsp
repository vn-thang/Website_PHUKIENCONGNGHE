<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="exchangeRate" value="25000" />
<%-- Tính totalUSD dựa trên giá trị động, không phải tĩnh --%>
<c:set var="totalUSD" value="${sessionScope.cart.totalCartPrice / exchangeRate}" />

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title> Giỏ Hàng | Shopee Style</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<style>
:root {
    --brand-orange: #ff7e27;
    --brand-orange-hover: #e76d20;
    --brand-red: #ff4a4a;
    --brand-red-hover: #c43131;
}

/* GLOBAL */
body {
    background-color: #f5f5f5;
    font-family: "Helvetica Neue", Arial, sans-serif;
}
h2, h4, h5 {
    color: #333;
    font-weight: 600;
}
a {
    color: var(--brand-orange);
    text-decoration: none;
}
a:hover {
    color: var(--brand-orange-hover);
}

/* CARD WRAPPER */
.cart-container,
.cart-summary {
    background-color: #fff;
    border-radius: 8px;
    padding: 1.5rem;
    box-shadow: 0 2px 8px rgba(0,0,0,0.05);
}

/* TABLE */
.cart-table th {
    background-color: #ffe7d3;
    color: var(--brand-orange);
    text-transform: uppercase;
}
.cart-table td {
    vertical-align: middle;
}

/* FORM CONTROL FIX WIDTH SAFE */
.form-control {
    width: 100%;
    max-width: 300px;
}

/* -----------------------------------
   BUTTON SYSTEM (KHÔNG GỘP CHUNG)
------------------------------------*/

/* NÚT CHÍNH – class dùng để thay thế override Bootstrap */
.btn-brand {
    background-color: var(--brand-orange);
    border: none;
    color: #fff;
    border-radius: 6px;
    transition: 0.25s ease;
}
.btn-brand:hover {
    background-color: var(--brand-orange-hover);
    color: #fff;
}

/* NÚT OUTLINE DANGER */
.btn-brand-outline {
    background: transparent;
    
    color: var(--brand-red);
    border-radius: 6px;
    transition: 0.25s ease;
}
.btn-brand-outline:hover {
    background-color: #ffebeb;
    color: var(--brand-red-hover);
}

/* NÚT TÙY BIẾN RIÊNG */
.btn-buy-now {
    background-color: var(--brand-orange);
    color: #fff;
    border-radius: 6px;
    border: none;
    transition: 0.25s ease;
}
.btn-buy-now:hover {
    background-color: var(--brand-orange-hover);
}

.btn-shopee-checkout {
    background-color: var(--brand-orange);
    color: #fff;
    border-radius: 6px;
    border: none;
    transition: 0.25s ease;
}
.btn-shopee-checkout:hover {
    background-color: var(--brand-orange-hover);
}

/* MODAL */
.modal-header {
    background-color: var(--brand-orange);
    color: #fff;
}

/* TRÁNH XUNG ĐỘT HEADER/FOOTER */
.modal-backdrop { 
    z-index: 1190; 
}
.modal { 
    z-index: 1200; 
}

/* TEXT ACCENT */
.text-accent,
.list-group-item strong,
.product-price {
    color: var(--brand-orange);
}

/* CHECKBOX BRAND */
.form-check-input:checked {
    background-color: var(--brand-orange);
    border-color: var(--brand-orange);
}

/* BUTTON FONT SIZE UNIFORM */
button {
    font-size: 1rem;
}
</style>

    </head>
    <body>
        <jsp:include page="header.jsp" />

        <div class="container mt-5 mb-5">
            <h2 class="mb-4"><i class="fas fa-shopping-cart"></i> Giỏ Hàng Của Bạn</h2>

            <c:if test="${not empty sessionScope.orderError}">
                <div class="alert alert-danger">${sessionScope.orderError}</div>
                <c:remove var="orderError" scope="session"/>
            </c:if>

            <c:choose>
                <c:when test="${empty sessionScope.cart || empty sessionScope.cart.items}">
                    <div class="alert alert-info">
                        Giỏ hàng của bạn đang trống. <a href="home">Tiếp tục mua sắm</a>.
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="row g-4">
                        <div class="col-lg-8">
                            <div class="cart-container">
                                <table class="table table-hover align-middle cart-table">
                                    <thead>
                                        <tr>
                                            <th class="text-center" style="width: 5%;">
                                                <input class="form-check-input" type="checkbox" id="select-all-checkbox" checked>
                                            </th>
                                            <th colspan="2">Sản Phẩm</th>
                                            <th class="text-center">Số Lượng</th>
                                            <th class="text-end">Thành Tiền</th>
                                            <th class="text-center">Xóa</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${sessionScope.cart.items}" var="entry">
                                            <c:set var="item" value="${entry.value}" />
                                            <c:set var="product" value="${item.product}" />

                                            <tr class="cart-item-row" data-price="${item.totalPrice}">
                                                <td class="text-center">
                                                    <input class="form-check-input item-checkbox" 
                                                           type="checkbox" 
                                                           value="${product.maSanPham}" 
                                                           data-name="${product.tenSanPham}"
                                                           data-image="${product.hinhAnh}"
                                                           data-quantity="${item.quantity}"
                                                           data-total-price="${item.totalPrice}"
                                                           checked>
                                                </td>
                                                <td style="width:90px">
                                                    <img src="${product.hinhAnh}" class="img-fluid rounded" 
                                                         style="width:80px; height:80px; object-fit:cover;">
                                                </td>
                                                <td>
                                                    <strong>${product.tenSanPham}</strong><br>
                                                    <small class="text-muted">
                                                        <fmt:formatNumber value="${product.gia}" type="currency" currencyCode="VND" minFractionDigits="0"/>
                                                    </small>
                                                </td>
                                                <td class="text-center">
                                                    <form action="cart" method="post">
                                                        <input type="hidden" name="action" value="update">
                                                        <input type="hidden" name="productId" value="${product.maSanPham}">
                                                        <input type="number" name="quantity" value="${item.quantity}" 
                                                               class="form-control form-control-sm text-center" 
                                                               style="width:80px" min="1" max="${product.soLuongTon}" onchange="this.form.submit()">
                                                    </form>
                                                </td>
                                                <td class="text-end fw-bold text-danger">
                                                    <fmt:formatNumber value="${item.totalPrice}" type="currency" currencyCode="VND" minFractionDigits="0"/>
                                                </td>
                                                <td class="text-center">
                                                   <a href="cart?action=remove&productId=${product.maSanPham}" 
   class="btn-brand-outline btn-sm">
    <i class="fas fa-trash"></i>
</a>

                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <div class="col-lg-4">
                            <div class="cart-summary">
                                <h4 class="mb-3">Tổng Cộng</h4>
                                <ul class="list-group list-group-flush">
                                    <li class="list-group-item d-flex justify-content-between">
                                        Tổng tiền (Đã chọn) <span class="fw-bold text-danger fs-5" id="selected-total-display-vnd">
                                            <fmt:formatNumber value="${sessionScope.cart.totalCartPrice}" type="currency" currencyCode="VND" minFractionDigits="0"/>
                                        </span>
                                    </li>
                                    <li class="list-group-item d-flex justify-content-between">
                                        Tương đương (USD)
                                        <span class="text-primary" id="selected-total-display-usd">
                                            $<fmt:formatNumber value="${totalUSD}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                        </span>
                                    </li>
                                </ul>
                                <div class="d-grid gap-2 mt-3">
                                   <button type="button" 
        class="btn-buy-now text-white" 
        id="btn-go-checkout" disabled>
    Tiến Hành Thanh Toán
</button>

                                    <div id="paypal-button-container" class="mt-3" style="display:none;"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="modal fade" id="checkoutModal" tabindex="-1" aria-labelledby="checkoutModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="checkoutModalLabel"><i class="fas fa-map-marker-alt"></i> Xác Nhận Giao Hàng</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>

                    <form id="checkoutForm" action="order" method="post" class="needs-validation" novalidate>
                        <div class="modal-body">
                            <div class="row g-4">
                              

                                <div class="col-md-6">
                                    <h5>Thông Tin Giao Hàng</h5>
                                    <div class="mb-3">
                                        <label class="form-label">Họ Tên</label>
                                        <input type="text" class="form-control" name="hoTenGiaoHang" value="${sessionScope.acc.hoTen}" required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Số Điện Thoại</label>
                                        <input type="tel" class="form-control" name="soDienThoaiGiaoHang" value="${sessionScope.acc.soDienThoai}" required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Địa Chỉ</label>
                                        <textarea placeholder="Vui lòng nhập địa chỉ chi tiết nơi bạn muốn nhận hàng" class="form-control" name="diaChiGiaoHang" rows="3" required></textarea>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-shopee-checkout">Xác Nhận Đặt Hàng</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <jsp:include page="footer.jsp" />



       <script>
    document.addEventListener('DOMContentLoaded', function () {

        // --- 1. KHAI BÁO DOM ELEMENTS ---
        const selectAllCheckbox = document.getElementById('select-all-checkbox');
        const itemCheckboxes = document.querySelectorAll('.item-checkbox');
        
        // Nơi hiển thị tổng tiền
        const totalDisplayVND = document.getElementById('selected-total-display-vnd');
        const totalDisplayUSD = document.getElementById('selected-total-display-usd'); // Có thể giữ hoặc bỏ nếu không dùng
        const buyCountSpan = document.getElementById('buy-count'); // Span hiển thị số lượng (0)
        
        // Tỷ giá (Lấy từ server hoặc mặc định)
        const exchangeRate = parseFloat('<c:out value="${exchangeRate}" default="25000" />');

        // Nút "Tiến Hành Thanh Toán" (Lưu ý: ID này phải khớp với nút bạn đã sửa ở HTML)
        const btnGoCheckout = document.getElementById('btn-go-checkout');


        // --- 2. HÀM TÍNH TOÁN TỔNG TIỀN ---
        function updateSelectedTotal() {
            let newTotalVND = 0;
            let count = 0;
            let allAreChecked = true;
            let hasItems = itemCheckboxes.length > 0;

            if (!hasItems) allAreChecked = false;

            itemCheckboxes.forEach(box => {
                if (box.checked) {
                    // Lấy giá tiền từ data-price của dòng tương ứng
                    // Giả định HTML của bạn có class 'cart-item-row' và data-price chứa tổng tiền item đó
                    const row = box.closest('.cart-item-row');
                    const price = parseFloat(row.dataset.price); 
                    
                    newTotalVND += price;
                    count++;
                } else {
                    allAreChecked = false;
                }
            });

            // Cập nhật trạng thái checkbox "Chọn tất cả"
            if (selectAllCheckbox) {
                selectAllCheckbox.checked = allAreChecked && hasItems;
            }

            // Hiển thị tổng tiền VND
            if (totalDisplayVND) {
                totalDisplayVND.textContent = newTotalVND.toLocaleString('vi-VN', {
                    style: 'currency', 
                    currency: 'VND', 
                    minimumFractionDigits: 0
                });
            }

            // Hiển thị tổng tiền USD (nếu có)
            if (totalDisplayUSD) {
                let newTotalUSD = (newTotalVND / exchangeRate).toFixed(2);
                totalDisplayUSD.textContent = '$' + newTotalUSD;
            }

            // Hiển thị số lượng đã chọn trên nút
            if (buyCountSpan) {
                buyCountSpan.textContent = '(' + count + ')';
            }

            // Enable/Disable nút thanh toán
            if (btnGoCheckout) {
                btnGoCheckout.disabled = count === 0;
            }
        }


        // --- 3. XỬ LÝ SỰ KIỆN CHECKBOX ---

        // Sự kiện click "Chọn tất cả"
        if (selectAllCheckbox) {
            selectAllCheckbox.addEventListener('change', function () {
                itemCheckboxes.forEach(box => {
                    box.checked = selectAllCheckbox.checked;
                });
                updateSelectedTotal();
            });
        }

        // Sự kiện click từng checkbox sản phẩm
        itemCheckboxes.forEach(box => {
            box.addEventListener('change', function () {
                updateSelectedTotal();
            });
        });


        // --- 4. XỬ LÝ SỰ KIỆN CLICK "TIẾN HÀNH THANH TOÁN" ---
        if (btnGoCheckout) {
            btnGoCheckout.addEventListener('click', function (e) {
                e.preventDefault(); // Ngăn chặn hành vi mặc định

                // Lấy danh sách các checkbox đang được chọn
                const checkedBoxes = document.querySelectorAll('.item-checkbox:checked');

                if (checkedBoxes.length === 0) {
                    alert("Vui lòng chọn ít nhất 1 sản phẩm để thanh toán!");
                    return;
                }

                // --- TẠO FORM ẨN ĐỂ GỬI DỮ LIỆU SANG checkout.jsp ---
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'checkout.jsp'; // Chuyển hướng sang trang checkout mới

                // Duyệt qua từng sản phẩm đã chọn
                checkedBoxes.forEach(cb => {
                    const input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = 'selectedProductIds'; // Tham số này sẽ được checkout.jsp đọc
                    input.value = cb.value; // Value này là ID sản phẩm (hoặc ID item trong giỏ)
                    form.appendChild(input);
                });

                // Gắn form vào body và submit
                document.body.appendChild(form);
                form.submit();
            });
        }

        // --- 5. KHỞI TẠO ---
        // Tính toán lại tổng tiền khi load trang (phòng trường hợp trình duyệt lưu cache checkbox)
        updateSelectedTotal();
    });
</script>
    </body>
</html>
