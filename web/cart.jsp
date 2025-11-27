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
            /* === Tone chính: #ff6600 và fix modal z-index === */
            :root{
                --brand-orange: #ff7e27;
                --brand-orange-hover: #ff7a33;
            }

            body {
                background-color: #f5f5f5;
                font-family: "Helvetica Neue", Arial, sans-serif;
            }
            h2,h4,h5 {
                color: #333;
                font-weight: 600;
            }

            /* link */
            a {
                color: var(--brand-orange);
                text-decoration: none;
            }
            a:hover {
                color: var(--brand-orange-hover);
            }

            /* Cart card / summary */
            .cart-container, .cart-summary {
                background-color: #fff;
                border-radius: 8px;
                padding: 1.5rem;
                box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            }

            /* bảng */
            .cart-table th {
                background-color: #fff0ea;
                color: var(--brand-orange);
                text-transform: uppercase;
            }
            .cart-table td {
                vertical-align: middle;
            }

            /* nút thanh toán */
            .btn-shopee-checkout {
                background-color: var(--brand-orange) !important;
                color: #fff !important;
                border: none !important;
                border-radius: 6px !important;
                font-weight: 600 !important;
                padding: 0.8rem 1rem !important;
                font-size: 1.05rem !important;
            }
            .btn-shopee-checkout:hover {
                background-color: var(--brand-orange-hover);
                color: black !important;
            }

            /* modal header màu brand */
            .modal-header {
                background-color: var(--brand-orange);
                color: #fff;
            }

            /* FIX: modal và backdrop luôn trên header (header của bạn có z-index ~1101) */
            .modal-backdrop {
                z-index: 1190 !important;
            }
            .modal {
                z-index: 1200 !important;
            }

            /* accent trong modal / cart */
            .list-group-item strong {
                color: var(--brand-orange);
            }
            .product-price, .fw-bold.text-danger {
                color: var(--brand-orange) !important;
            }

            /* checkbox checked */
            .form-check-input:checked {
                background-color: var(--brand-orange) !important;
                border-color: var(--brand-orange) !important;
            }

            /* nút xóa outline hover (nhẹ) */
            .btn-outline-danger:hover {
                background-color: rgba(255,102,0,0.06) !important;
                color: #c43f00 !important;
            }

            /* giữ sạch, không thay layout khác */
            .cart-table th small, .cart-table th .small {
                color: var(--brand-orange);
            }
            .form-control{
                width: 200% !important;
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
                                                    <a href="cart?action=remove&productId=${product.maSanPham}" class="btn btn-outline-danger btn-sm">
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
                                    <button type="button" class="btn btn-shopee-checkout" data-bs-toggle="modal" data-bs-target="#checkoutModal">
                                        <i class="fas fa-truck"></i> Thanh Toán (COD)
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

                // --- DOM ---
                const selectAllCheckbox = document.getElementById('select-all-checkbox');
                const itemCheckboxes = document.querySelectorAll('.item-checkbox');
                const totalDisplayVND = document.getElementById('selected-total-display-vnd');
                const totalDisplayUSD = document.getElementById('selected-total-display-usd');
                const exchangeRate = parseFloat('<c:out value="${exchangeRate}" default="25000" />');

                const modalElement = document.getElementById('checkoutModal');
                const modal = new bootstrap.Modal(modalElement); // Khởi tạo modal
                const modalSummaryContainer = document.getElementById('modal-products-summary');

                const checkoutForm = document.getElementById('checkoutForm');
                const paypalContainer = document.getElementById('paypal-button-container');

                // --- FUNCTIONS ---
                function updateSelectedTotal() {
                    let newTotalVND = 0;
                    let allAreChecked = true;
                    let itemsSelected = false;

                    itemCheckboxes.forEach(box => {
                        if (box.checked) {
                            newTotalVND += parseFloat(box.closest('.cart-item-row').dataset.price);
                            itemsSelected = true;
                        } else {
                            allAreChecked = false;
                        }
                    });

                    selectAllCheckbox.checked = allAreChecked && itemsSelected;

                    totalDisplayVND.textContent = newTotalVND.toLocaleString('vi-VN', {style: 'currency', currency: 'VND', minimumFractionDigits: 0});
                    let newTotalUSD = (newTotalVND / exchangeRate).toFixed(2);
                    totalDisplayUSD.textContent = '$' + newTotalUSD;
                }

                function updateModalSummary() {
                    modalSummaryContainer.innerHTML = '';
                    const checkedBoxes = document.querySelectorAll('.item-checkbox:checked');
                    let newTotalVND = 0;

                    if (checkedBoxes.length === 0) {
                        modalSummaryContainer.innerHTML = `
                <li class="list-group-item text-danger">Bạn chưa chọn sản phẩm nào.</li>
            `;
                        return;
                    }

                    checkedBoxes.forEach(box => {
                        const name = box.dataset.name;
                        const image = box.dataset.image;
                        const quantity = box.dataset.quantity;
                        const price = parseFloat(box.dataset.totalPrice);
                        newTotalVND += price;

                        const itemHTML = `
                <li class="list-group-item d-flex justify-content-between align-items-center">
                    <div class="d-flex align-items-center">
                        <img src="${image}" class="rounded me-2"
                             style="width:45px;height:45px;object-fit:contain;">
                        <div>
                            <h6 class="my-0">${name}</h6>
                            <small class="text-muted">SL: ${quantity}</small>
                        </div>
                    </div>
                    <span class="text-danger">
            ${price.toLocaleString('vi-VN', {
              style: 'currency',
              currency: 'VND',
              minimumFractionDigits: 0
              })}
                    </span>
                </li>
            `;

                        modalSummaryContainer.insertAdjacentHTML('beforeend', itemHTML);
                    });

                    const totalHTML = `
            <li class="list-group-item d-flex justify-content-between bg-light">
                <strong>Tổng cộng</strong>
                <strong class="text-danger fs-5">
            ${newTotalVND.toLocaleString('vi-VN', {
              style: 'currency',
              currency: 'VND',
              minimumFractionDigits: 0
              })}
                </strong>
            </li>
        `;

                    modalSummaryContainer.insertAdjacentHTML('beforeend', totalHTML);
                }


                function addHiddenInputsToForm() {
                    checkoutForm.querySelectorAll('input[name="selectedProducts"]').forEach(e => e.remove());

                    const checkedBoxes = document.querySelectorAll('.item-checkbox:checked');

                    if (checkedBoxes.length === 0) {
                        alert('Bạn chưa chọn sản phẩm nào.');
                        return false;
                    }

                    checkedBoxes.forEach(box => {
                        const hidden = document.createElement('input');
                        hidden.type = 'hidden';
                        hidden.name = 'selectedProducts';
                        hidden.value = box.value;
                        checkoutForm.appendChild(hidden);
                    });

                    return true;
                }

                // --- EVENTS ---
                checkoutForm.addEventListener('submit', event => {
                    event.preventDefault();
                    event.stopPropagation();

                    if (!checkoutForm.checkValidity()) {
                        checkoutForm.classList.add('was-validated');
                        return;
                    }

                    if (addHiddenInputsToForm()) {
                        if (!checkoutForm.querySelector('input[name="paymentMethod"]')) {
                            const input = document.createElement('input');
                            input.type = 'hidden';
                            input.name = 'paymentMethod';
                            input.value = 'cod';
                            checkoutForm.appendChild(input);
                        }
                        // sửa gọi submit đúng biến
                        checkoutForm.submit();
                    }
                }, false);

                modalElement.addEventListener('show.bs.modal', function (event) {
                    updateModalSummary();
                });

                selectAllCheckbox.addEventListener('change', () => {
                    itemCheckboxes.forEach(b => b.checked = selectAllCheckbox.checked);
                    updateSelectedTotal();
                });

                itemCheckboxes.forEach(b => b.addEventListener('change', () => {
                        updateSelectedTotal();
                    }));

                // init
                updateSelectedTotal();
            });
        </script>
    </body>
</html>
