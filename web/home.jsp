<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Trang Chủ - Phụ Kiện Store</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
        <style>
            /* ====== CSS GỐC (GIỮ NGUYÊN) ====== */
            body {
                margin: 0;
                font-family: "Segoe UI", Arial, sans-serif !important;
                background-color: #fffefe;
                color: #333;
            }
            h2, h5 {
                font-weight: 600;
            }
            .hero-section {
                position: relative;
                height: 420px;
                border-radius: 16px;
                overflow: hidden;
                margin-bottom: 2rem;
                box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            }
            .hero-slide {
                position: absolute;
                inset: 0;
                background-size: cover;
                background-position: center;
                opacity: 0;
                transition: opacity 1s ease-in-out;
            }
            .hero-slide.active {
                opacity: 1;
            }
            .hero-overlay {
                position: absolute;
                inset: 0;
                background: rgba(0,0,0,0);
            }
            .hero-btn {
                position: absolute;
                top: 50%;
                transform: translateY(-50%);
                background-color: rgba(228,74,10,0.8);
                color: #fff;
                border: none;
                border-radius: 50%;
                width: 45px;
                height: 45px;
                font-size: 1.2rem;
                cursor: button;
                z-index: 10;
                transition: 0.3s;
            }
            .hero-btn:hover {
                background-color: #FF7A3D;
                transform: scale(1.1) translateY(-50%);
            }
            .hero-btn.prev {
                left: 20px;
            }
            .hero-btn.next {
                right: 20px;
            }
            .best-sellers-section {
                background: #fff;
                border-radius: 18px;
                box-shadow: 0 6px 20px rgba(0,0,0,0.08);
                overflow: hidden;
                margin-bottom: 2rem;
            }
            .best-sellers-header {
                padding: 1.2rem 1.5rem;
                background: linear-gradient(90deg, #E44A0A, #FF7A3D);
                color: white;
                font-size: 1.4rem;
                font-weight: 600;
                text-transform: uppercase;
            }
            .top-1-card, .small-card {
                display: block;
                text-decoration: none;
                color: #333;
                transition: all 0.3s ease;
            }
            .top-1-card:hover, .small-card:hover {
                transform: translateY(-5px);
            }
            .top-1-image-wrapper, .small-card-image {
                position: relative;
                overflow: hidden;
                border-radius: 10px;
            }
            .top-1-image-wrapper img, .small-card-image img {
                width: 100%;
                height: 100%;
                object-fit: cover;
                transition: transform 0.4s ease;
            }
            .top-1-card:hover img, .small-card:hover img {
                transform: scale(1.05);
            }
            .top-badge {
                position: absolute;
                
                right:-1px;
                background: linear-gradient(135deg, #E44A0A, #FF7A3D);
                color: #fff;
                font-weight: 700;
                padding: 5px 12px;
                border-radius: 20px;
                font-size: 0.85rem;
                box-shadow: 0 3px 6px rgba(0,0,0,0.2);
            }

            /* Card Sản Phẩm */
            .product-card {
                background: #fffefe;
                border: solid #f1f1f1;
                border-radius: 12px;
                box-shadow: 0 1px 8px rgba(0,0,0,0.08);
                transition: 0.25s ease;
            }
            .product-card:hover {
                transform: translateY(-4px);
                box-shadow: 0 6px 16px rgba(0,0,0,0.12);
            }
            .product-img {
                width: 100%;
                height: 240px !important;
                object-fit: contain;
                padding: 8px;
                background: #fafafa;
                border-radius: 12px 12px 0 0;
            }
            .product-title {
                font-size: 0.95rem !important;
                font-weight: 600;
                color: #222;
                height: 40px !important;
                overflow: hidden;
                text-align: center;
            }
            .product-price {
                color: #ff6f3c;
                font-weight: 600;
                font-size: 1rem !important;
                text-align: center !important;
                margin-bottom: 12px;
            }
            .product-card .card-footer {
                border-top: none !important;
                background: transparent;
                display: flex;
                justify-content: center;
                gap: 10px;
            }
            .card{
                --bs-card-border-width: none !important;
            }
            .card-footer a {
                background: #ffffff;
                border: 1px #ff7e27 solid;
                border-radius: 14px !important;
                padding: 4px 8px !important;
                font-size: 0.8rem !important;
                font-weight: 500;
                color: #333;
                text-decoration: none;
                transition: 0.2s ease;
                margin-bottom: 14px;
            }
            .card-footer a.btn-warning {
                background-color: #ff6f0f !important;
                border-color: #E44A0A !important;
                color: #fff !important;
            }
            .card-footer a.btn-warning:hover {
                background-color: #FF7A3D !important;
                color: #fff !important;
            }
            .card-footer a.btn-outline-success {
                border-color: #E44A0A !important;
                color: #E44A0A !important;
            }
            .card-footer a.btn-outline-success:hover {
                background-color: #E44A0A !important;
                color: #fff !important;
            }

            /* Pagination */
            .pagination .page-link {
                border-radius: 10px;
                margin: 0 4px;
                color: #E44A0A;
                border: 1px solid #ffc1b0;
            }
            .pagination .page-link:hover {
                background-color: #E44A0A;
                color: white;
            }
            .pagination .active .page-link {
                background-color: #E44A0A;
                border-color: #E44A0A;
                color: white;
            }

            .row-cols-md-4 > * {
                padding: 8px !important;
            }
            .row {
                margin-left: -4px !important;
                margin-right: -4px !important;
            }

            /* ====== [MỚI] CSS CHO THANH LỌC NGANG (FILTER TOOLBAR) ====== */
            .filter-toolbar {
                background-color: #fff;
                border: 1px solid #f0f0f0;
                border-radius: 12px;
                padding: 15px 20px;
                margin-bottom: 20px;
                box-shadow: 0 2px 8px rgba(0,0,0,0.03);
            }
            .filter-label {
                font-weight: 700;
                color: #E44A0A;
                margin-right: 10px;
                text-transform: uppercase;
                font-size: 0.9rem;
            }
            .filter-select {
                border-radius: 20px;
                border-color: #ddd;
                font-size: 0.9rem;
                padding: 5px 30px 5px 15px;
                min-width: 180px;
            }
            .filter-select:focus {
                border-color: #E44A0A;
                box-shadow: 0 0 0 0.2rem rgba(228, 74, 10, 0.25);
            }
            .price-input-group {
                display: flex;
                align-items: center;
                gap: 5px;
            }
            .price-input-group input {
                border-radius: 20px;
                font-size: 0.9rem;
                max-width: 120px;
            }
            .btn-apply-filter {
                background-color: #E44A0A;
                color: white;
                border: none;
                border-radius: 20px;
                padding: 5px 20px;
                font-weight: 600;
                font-size: 0.9rem;
            }
            .btn-apply-filter:hover {
                background-color: #d63f00;
                color: white;
            }
            .row-cols-md-4 > * {
    padding: 12px !important;
}
        </style>
    </head>

    <body>
        <jsp:include page="header.jsp" />

        <div class="container mt-5">
           

            <c:if test="${empty param.cid && empty param.search && currentPage == 1 && empty param.priceFrom}">
                <div class="hero-section">
                    <div class="hero-slide active" style="background-image: url('https://cf.shopee.vn/file/vn-11134258-820l4-mfxo13pqr09af9');"><div class="hero-overlay"></div></div>
                    <div class="hero-slide" style="background-image: url('https://cf.shopee.vn/file/vn-50009109-727a24a85a60935da5ccb9008298f681');"><div class="hero-overlay"></div></div>
                    <div class="hero-slide" style="background-image: url('https://cf.shopee.vn/file/vn-11134258-820l4-mfxo3ih8jzt51a');"><div class="hero-overlay"></div></div>
                    <button class="hero-btn prev"><i class="fas fa-chevron-left"></i></button>
                    <button class="hero-btn next"><i class="fas fa-chevron-right"></i></button>
                </div>
            </c:if>

            <c:if test="${not empty sessionScope.orderSuccess}">
                <div class="alert alert-success alert-dismissible fade show mt-3" role="alert">
                    <strong>Đặt hàng thành công!</strong> Cảm ơn bạn đã mua sắm tại Phụ Kiện Store.
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <c:remove var="orderSuccess" scope="session"/>
            </c:if>

            <c:if test="${empty param.cid && empty param.search && currentPage == 1 && not empty top1BestSeller && empty param.priceFrom}">
                <div class="best-sellers-section">
                    <div class="best-sellers-header"><i class="fa-solid fa-fire me-2"></i> Sản Phẩm Bán Chạy</div>
                    <div class="row g-0">
                        <div class="col-lg-5 col-md-6 border-end">
                            <a href="detail?pid=${top1BestSeller.maSanPham}" class="top-1-card p-3">
                                <div class="top-1-image-wrapper">
                                    <span class="top-badge"><i class="fa-solid fa-crown me-1"></i>TOP 1</span>
                                    <img src="${top1BestSeller.hinhAnh}" alt="${top1BestSeller.tenSanPham}">
                                </div>
                                <h5 class="mt-3">${top1BestSeller.tenSanPham}</h5>
                                <div class="product-price">
                                    <fmt:formatNumber value="${top1BestSeller.gia}" type="currency" currencyCode="VND" minFractionDigits="0"/>
                                </div>
                            </a>
                        </div>
                        <div class="col-lg-7 col-md-6 p-3">
                            <div class="row row-cols-3 g-3">
                                <c:forEach items="${top2to7BestSellers}" var="p" varStatus="loop">
                                    <div class="col">
                                        <a href="detail?pid=${p.maSanPham}" class="small-card">
                                            <div class="small-card-image">
                                                <span class="top-badge">TOP ${loop.count + 1}</span>
                                                <img src="${p.hinhAnh}" alt="${p.tenSanPham}">
                                            </div>
                                            <div class="p-2">
                                                <div class="product-title">${p.tenSanPham}</div>
                                                <div class="product-price">
                                                    <fmt:formatNumber value="${p.gia}" type="currency" currencyCode="VND" minFractionDigits="0"/>
                                                </div>
                                            </div>
                                        </a>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>
            </c:if>

            <hr class="my-5" style="color: #eee;">

            <div class="d-flex justify-content-between align-items-end mb-3 pb-2">
                <h2 class="m-0" style="font-size: 1.6rem;">
                    <c:choose>
                        <c:when test="${not empty activeCategoryId}">
                            Danh mục: <span style="color:#E44A0A;">${categoryList.stream().filter(c -> c.maDanhMuc == activeCategoryId).findFirst().get().tenDanhMuc}</span>
                        </c:when>
                        <c:when test="${not empty searchQuery}">
                            Kết quả: "<span style="color:#E44A0A;">${searchQuery}</span>"
                        </c:when>
                        <c:otherwise>Tất Cả Sản Phẩm</c:otherwise>
                    </c:choose>
                </h2>

                <form action="home" method="get" class="d-flex align-items-center">
                    <c:if test="${not empty activeCategoryId}"><input type="hidden" name="cid" value="${activeCategoryId}"></c:if>
                        <div class="input-group">
                            <input type="text" name="search" class="form-control" placeholder="Tìm trong danh sách..." value="${searchQuery}" style="border-radius: 20px 0 0 20px; border-color: #E44A0A; width: 200px;">
                        <button class="btn btn-outline-success" type="submit" style="border-radius: 0 20px 20px 0; background-color: #E44A0A; color: #fff; border-color: #E44A0A;">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                </form>
            </div>

            <div class="filter-toolbar">
                <form action="home" method="get" class="row g-3 align-items-center">
                    <input type="hidden" name="search" value="${searchQuery}">

                    <div class="col-auto">
                        <span class="filter-label"><i class="fas fa-filter"></i> Bộ lọc:</span>
                    </div>

                    <div class="col-auto">
                        <select name="cid" class="form-select filter-select" onchange="this.form.submit()">
                            <option  value="all">-- Tất cả danh mục --</option>
                            <c:forEach items="${categoryList}" var="c">
                                <option value="${c.maDanhMuc}" ${activeCategoryId == c.maDanhMuc ? 'selected' : ''}>
                                    ${c.tenDanhMuc}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="col-auto ms-md-3">
                        <div class="price-input-group">
                            <span class="fw-bold text-muted small">Giá:</span>
                            <input type="number" name="priceFrom" class="form-control form-control-sm" placeholder="Từ (VNĐ)" value="${priceFrom}" min="0">
                            <span>-</span>
                            <input type="number" name="priceTo" class="form-control form-control-sm" placeholder="Đến (VNĐ)" value="${priceTo}" min="0">
                        </div>
                    </div>

                    <div class="col-auto">
                        <button type="submit" class="btn-apply-filter">Áp dụng</button>
                    </div>

                    <c:if test="${not empty activeCategoryId || not empty priceFrom || not empty priceTo}">
                        <div class="col-auto ms-auto">
                            <a href="home" class="text-danger text-decoration-none small fw-bold"><i class="fas fa-times"></i> Xóa lọc</a>
                        </div>
                    </c:if>
                </form>
            </div>
            <div class="row row-cols-1 row-cols-md-4 g-4">
                <c:forEach items="${productList}" var="p">
                    <div class="col">
                        <div class="card product-card h-100">
                            <a href="detail?pid=${p.maSanPham}">
                                <img src="${p.hinhAnh}" class="product-img" alt="${p.tenSanPham}">
                            </a>
                            <div class="card-body p-2">
                                <h5 class="product-title">
                                    <a href="detail?pid=${p.maSanPham}" class="text-decoration-none">${p.tenSanPham}</a>
                                </h5>
                                <p class="product-price">
                                    <fmt:formatNumber value="${p.gia}" type="currency" currencyCode="VND" minFractionDigits="0"/>
                                </p>
                            </div>
                            <div class="card-footer bg-transparent text-center pb-3">
                                <a href="detail?pid=${p.maSanPham}" class="btn btn-warning btn-sm me-1 text-white">Xem chi tiết</a>
                                <a href="cart?action=add&productId=${p.maSanPham}" class="btn btn-outline-success btn-sm"><i class="fas fa-cart-plus"></i>Thêm vào giỏ</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <c:if test="${empty productList}">
                <div class="alert alert-warning mt-4 text-center p-5">
                    <i class="fas fa-box-open fa-3x mb-3 text-muted"></i><br>
                    Không tìm thấy sản phẩm nào phù hợp với bộ lọc của bạn.
                </div>
            </c:if>

            <c:if test="${totalPages > 1}">
                <nav class="mt-5 d-flex justify-content-center">
                    <ul class="pagination">
                        <c:url var="baseLink" value="home">
                            <c:param name="cid" value="${activeCategoryId}" />
                            <c:param name="search" value="${searchQuery}" />
                            <c:param name="priceFrom" value="${priceFrom}" />
                            <c:param name="priceTo" value="${priceTo}" />
                        </c:url>

                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="${baseLink}&page=${currentPage - 1}">&laquo;</a>
                        </li>

                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link" href="${baseLink}&page=${i}">${i}</a>
                            </li>
                        </c:forEach>

                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="${baseLink}&page=${currentPage + 1}">&raquo;</a>
                        </li>
                    </ul>
                </nav>
            </c:if>

        </div>

        <jsp:include page="footer.jsp" />

        <script>
            const slides = document.querySelectorAll(".hero-slide");
            const prevBtn = document.querySelector(".hero-btn.prev");
            const nextBtn = document.querySelector(".hero-btn.next");
            let index = 0;
            function showSlide(i) {
                slides.forEach(s => s.classList.remove("active"));
                slides[i].classList.add("active");
            }
            function nextSlide() {
                index = (index + 1) % slides.length;
                showSlide(index);
            }
            function prevSlide() {
                index = (index - 1 + slides.length) % slides.length;
                showSlide(index);
            }
            if (slides.length > 0 && prevBtn && nextBtn) {
                nextBtn.addEventListener("click", nextSlide);
                prevBtn.addEventListener("click", prevSlide);
                setInterval(nextSlide, 4000);
            }
        </script>
    </body>
</html>