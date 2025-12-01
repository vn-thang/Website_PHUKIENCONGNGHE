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

/* --- 1. KHUNG BAO NGOÀI (QUAN TRỌNG NHẤT) --- */
.hotline-btn-wrapper {
    position: fixed; /* Ép cố định vào màn hình */
    bottom: 110px;   /* Cách đáy 110px (để nhường chỗ cho con bot ở dưới) */
    right: 30px;     /* Cách phải 30px */
    z-index: 999999;
    width: 60px;
    height: 60px;
    /* Căn icon vào giữa */
    display: flex;
    justify-content: center;
    align-items: center;
}
.hotline-animation {
    /* Đảm bảo animation nằm giữa khung 60px */
    display: flex;
    justify-content: center;
    align-items: center;
    width: 100%;
    height: 100%;
}

/* Vòng tròn viền ngoài (Lan tỏa) */
.c-circle {
    width: 70px;
    height: 70px;
    position: absolute;
    background-color: transparent;
    border-radius: 100%;
    border: 2px solid #e60808;
    opacity: .5;
    animation: ring-circle-anim 1.2s infinite ease-in-out;
}

/* Vòng tròn nền mờ */
.c-circle-fill {
    width: 50px;
    height: 50px;
    position: absolute;
    background-color: rgba(230, 8, 8, 0.7);
    border-radius: 100%;
    border: 2px solid transparent;
    animation: ring-circle-fill-anim 2.3s infinite ease-in-out;
}

/* Vòng tròn chứa Icon (Nút chính) */
.c-img-circle {
    background-color: #e60808;
    width: 40px; /* Kích thước nút đỏ */
    height: 40px;
    border-radius: 100%;
    position: relative;
    z-index: 2;
    display: flex;
    justify-content: center;
    align-items: center;
    animation: ring-circle-img-anim 1s infinite ease-in-out;
    box-shadow: 0 4px 10px rgba(0,0,0,0.3);
}

.c-img-circle a {
    display: flex;
    color: #fff;
    font-size: 18px;
    text-decoration: none;
}


/* --- KEYFRAMES (HIỆU ỨNG RUNG) --- */
@keyframes ring-circle-anim {
    0% { transform: rotate(0) scale(0.5) skew(1deg); opacity: 0.1; }
    30% { transform: rotate(0) scale(0.7) skew(1deg); opacity: 0.5; }
    100% { transform: rotate(0) scale(1) skew(1deg); opacity: 0.1; }
}

@keyframes ring-circle-fill-anim {
    0% { transform: rotate(0) scale(0.7) skew(1deg); opacity: 0.2; }
    50% { transform: rotate(0) scale(1) skew(1deg); opacity: 0.2; }
    100% { transform: rotate(0) scale(0.7) skew(1deg); opacity: 0.2; }
}

@keyframes ring-circle-img-anim {
    0% { transform: rotate(0) scale(1) skew(1deg); }
    10% { transform: rotate(-25deg) scale(1) skew(1deg); }
    20% { transform: rotate(25deg) scale(1) skew(1deg); }
    30% { transform: rotate(-25deg) scale(1) skew(1deg); }
    40% { transform: rotate(25deg) scale(1) skew(1deg); }
    50% { transform: rotate(0) scale(1) skew(1deg); }
    100% { transform: rotate(0) scale(1) skew(1deg); }
}
/* --- CSS CHO NÚT CHATBOT (Phía dưới) --- */
.chatbot-toggler {
    position: fixed;
    bottom: 50px;
    right: 35px; /* Căn thẳng hàng với nút gọi ở trên */
    outline: none;
    border: none;
    height: 50px;
    width: 50px;
    display: flex;
    cursor: pointer;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
    background: #007bff; /* Màu xanh chatbot */
    transition: all 0.2s ease;
    z-index: 9999;
    box-shadow: 0 4px 10px rgba(0,0,0,0.2);
}

.chatbot-toggler i {
    color: #fff;
    font-size: 22px;
}

.chatbot-toggler:hover {
    transform: scale(1.1);
}

/* --- CSS CHO CỬA SỔ CHAT --- */
.chat-window-container {
    position: fixed;
    right: /*35px;*/ 90px;
    bottom: /*90px;*/ 20px;
    width: 300px;
    height: 450px; /* Chiều cao khung chat */
    background: #fff;
    border-radius: 15px;
    box-shadow: 0 0 128px 0 rgba(0,0,0,0.1), 0 32px 64px -48px rgba(0,0,0,0.5);
     display: none;
    flex-direction: column;
    z-index: 999999;
    overflow: hidden;
    font-family: Arial, sans-serif;
    transform-origin: bottom right;
}

.chat-header {
    background: #007bff;
    padding: 10px 15px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    height: 45px;
}

.chat-title {
    color: #fff;
    font-size: 14px;
    font-weight: 600;
}

.close-btn {
    background: none;
    border: none;
    color: #fff;
    font-size: 24px;
    cursor: pointer;
}

.chat-body {
    padding: 10px;
    flex: 1;
    overflow-y: auto;
    background: #f1f5f9;
    font-size: 12px;
    min-height: 0; /* Quan trọng cho flex */
    display: block;
}

.chat-footer {
    display: flex;
    align-items: center; /* Căn giữa theo chiều dọc */
    padding: 8px 10px;
    border-top: 1px solid #eee; /* Màu viền nhẹ hơn cho tinh tế */
    background: #fff;
    min-height: 60px; 
}

.chat-footer input {
    /* [QUAN TRỌNG] Thêm flex: 1 để ô nhập tự co giãn chiếm hết chỗ trống */
    flex: 1; 
    
    border: 1px solid #ddd; /* Viền nhạt hơn */
    outline: none;
    height: 36px;
    border-radius: 16px; /* Bo tròn mềm mại hơn (hình viên thuốc) */
    padding: 0 12px;
    font-size: 12px; /* Tăng nhẹ 1px cho dễ đọc */
    background: #f9f9f9; /* Màu nền xám nhẹ cho hiện đại */
}

.chat-footer button {
    margin-left: 8px; /* Giảm khoảng cách chút cho gọn */
    background: #007bff;
    color: white;
    border: none;
    
    /* [QUAN TRỌNG] Bo tròn thành hình tròn hoàn hảo */
    border-radius: 50%; 
    
    width: 32px;
    height: 32px;
    cursor: pointer;
    
    /* [QUAN TRỌNG] Căn giữa icon tuyệt đối */
    display: flex;
    align-items: center;
    justify-content: center;
    
    transition: background 0.2s; /* Hiệu ứng chuyển màu mượt */
}

.chat-footer button i {
    font-size: 12px;
    /* Mẹo nhỏ: Icon máy bay thường bị lệch trái do cái đuôi, dịch sang phải 1 xíu để cân mắt */
    margin-left: -2px; 
    margin-top: 1px;
}

.chat-footer button:hover {
    background: #0056b3; /* Đổi màu khi di chuột vào */
}

/* --- SỬA LẠI ĐOẠN TIN NHẮN (CHO CHẮC CHẮN HIỆN CHỮ) --- */
.message {
    margin-bottom: 15px;
    display: flex;
    width: 100%; /* Đảm bảo tin nhắn chiếm chiều rộng */
}
.bot-message { justify-content: flex-start; }
.user-message { justify-content: flex-end; }

/* Ép hiển thị tin nhắn bằng mọi giá */
.msg-content {
    max-width: 80%;
    padding: 8px 12px;
    font-size: 13px;
    line-height: 1.4;
    border-radius: 12px;
    word-wrap: break-word;   /* Tự xuống dòng nếu chữ quá dài */
    word-break: break-word;  /* Ngăn vỡ giao diện */
    display: inline-flex !important;
    visibility: visible !important;
    opacity: 1 !important;
     flex-shrink: 0; 
}

.bot-message .msg-content {
    background: #fff !important;    /* Ép nền trắng */
    color: #333 !important;         /* Ép chữ đen */
    border: 1px solid #e5e5e5;
    border-bottom-left-radius: 0;
}

.user-message .msg-content {
    background: #007bff !important; /* Ép nền xanh */
    color: #fff !important;         /* Ép chữ trắng */
    border-bottom-right-radius: 0;
}

/* --- PHẦN GỢI Ý CÂU HỎI (FAQ) --- */

.faq-section {
    margin-top: 8px;
    padding: 0 5px;
}

.faq-header-text {
    font-size: 12px;
    color: #666;
    margin-bottom: 5px;
    font-weight: 400;
}

.faq-list {
    display: flex;
    flex-direction: column;
    gap: 4px;
    align-items: flex-start;
    padding: 0 5px;
    margin-bottom: 8px;
}

.faq-btn {
    background: #fff;
    border: 1px solid #e0e0e0;
    padding: 3px 8px;
    border-radius: 10px;
    color: #555;
    font-size: 12px !important;;
    text-align: left;
    cursor: pointer;
    transition: all 0.2s ease;
    box-shadow: 0 1px 2px rgba(0,0,0,0.05);
    width: fit-content;
    max-width: 100%;
    margin-bottom: 0;
}

.faq-btn:hover {
    background: #007bff;
    color: #fff;
    border-color: #007bff;
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
                
<div class="hotline-btn-wrapper">
    <div class="hotline-animation">
        <div class="c-circle"></div>
        <div class="c-circle-fill"></div>
        <div class="c-img-circle">
            <a href="https://zalo.me/0961531720" target="_blank">
                <i class="fas fa-phone-alt"></i>
            </a>
        </div>
    </div>
</div>
<div class="chatbot-toggler" onclick="toggleChatWindow()">
    <i class="fas fa-robot" id="chatIcon"></i>
    <i class="fas fa-times" id="closeIcon" style="display: none;"></i>
</div>

<div class="chat-window-container" id="chatWindow">
    
    <div class="chat-header">
        <div class="chat-title">
            <i class="fas fa-robot"></i> Trợ lý ảo TStore
        </div>
        <button onclick="toggleChatWindow()" class="close-btn">&times;</button>
    </div>
    
   <div class="chat-body" id="chatBody">
        
        <div class="message bot-message">
            <div class="msg-content">
                Xin chào! 👋<br>
                Mình là trợ lý ảo của TStore.<br>
                Bạn cần hỗ trợ vấn đề gì ạ?
            </div>
        </div>

        <div class="faq-section">
            <p class="faq-header-text">Câu hỏi thường gặp:</p>
            
            <div class="faq-list">
                <button class="faq-btn" onclick="sendQuickMessage('Chính sách bảo hành')">
                    🛡️ Chính sách bảo hành
                </button>
                
                <button class="faq-btn" onclick="sendQuickMessage('Phí vận chuyển bao nhiêu')">
                    🚚 Phí vận chuyển
                </button>
                
                <button class="faq-btn" onclick="sendQuickMessage('Địa chỉ shop ở đâu')">
                    📍 Địa chỉ cửa hàng
                </button>
                
                <button class="faq-btn" onclick="sendQuickMessage('Cách thức thanh toán')">
                    💳 Cách thức thanh toán
                </button>
            </div>
        </div>
  </div>
    
    <div class="chat-footer">
        <input type="text" id="userInput" placeholder="Nhập tin nhắn..." onkeypress="handleEnter(event)">
        <button onclick="sendMessage()"><i class="fas fa-paper-plane"></i></button>
</div>
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

// --- HÀM BẬT/TẮT CHATBOT (Dành cho HTML có onclick="toggleChatWindow()") ---
  document.addEventListener("DOMContentLoaded", function () {

        // Gán hàm vào window để HTML có thể gọi onclick="toggleChatWindow()"
        window.toggleChatWindow = function () {

            const chatWindow = document.getElementById('chatWindow') 
                || document.querySelector('.chat-window-container');

            const chatIcon = document.getElementById('chatIcon');
            const closeIcon = document.getElementById('closeIcon');

            if (!chatWindow) {
                console.error("Không tìm thấy #chatWindow");
                return;
            }

            const isHidden = window.getComputedStyle(chatWindow).display === 'none';

            if (isHidden) {
                chatWindow.style.display = 'flex';

                if (chatIcon) chatIcon.style.display = 'none';
                if (closeIcon) closeIcon.style.display = 'block';
            } else {
                chatWindow.style.display = 'none';

                if (chatIcon) chatIcon.style.display = 'block';
                if (closeIcon) closeIcon.style.display = 'none';
            }
        };

    });
    // --- 2. Gửi tin nhắn khi nhấn Enter ---
    const userInput = document.getElementById('userInput');
    if(userInput) {
        userInput.addEventListener('keypress', function(e){
            if(e.key === 'Enter') sendMessage();
        });
    }

    // --- 3. Gửi tin nhắn khi nhấn nút gửi ---
    const sendBtn = document.querySelector('.chat-footer button');
    if(sendBtn) {
        sendBtn.addEventListener('click', sendMessage);
    }

    // --- 4. Gửi tin nhắn user ---
    function sendMessage() {
        if(!userInput) return;
        const msg = userInput.value.trim();
        if(!msg) return;
        addMessage(msg,'user');
        userInput.value = '';
        sendToServer(msg);
    }

    // --- 5. Hiển thị tin nhắn trên giao diện ---
  // --- 5. Hiển thị tin nhắn trên giao diện (ĐÃ SỬA GIAO DIỆN TÁCH RỜI) ---
    function addMessage(msg, sender='bot') {
        const chatBody = document.getElementById('chatBody');
        if(!chatBody) return;

        // Ẩn FAQ nếu là user gửi
        if(sender === 'user') {
            const faq = document.querySelector('.faq-section');
            if(faq) faq.style.display = 'none';
        }

        const messageDiv = document.createElement('div');
        messageDiv.classList.add('message', sender === 'user' ? 'user-message' : 'bot-message');
        messageDiv.style.display = 'flex';
        messageDiv.style.justifyContent = sender === 'user' ? 'flex-end' : 'flex-start';
        messageDiv.style.marginBottom = '10px';

        const contentDiv = document.createElement('div');
        contentDiv.classList.add('msg-content');
        
        // Cấu hình chung
        contentDiv.style.wordWrap = 'break-word';

        // === [PHẦN QUAN TRỌNG NHẤT] ===
        
        if (sender === 'bot') {
            // NẾU LÀ BOT:
            // 1. Nền trong suốt (Để tách rời bong bóng chữ và nút bấm)
            // 2. Xóa padding (Để các phần tử con tự căn chỉnh)
            contentDiv.style.background = 'transparent'; 
         //   contentDiv.style.padding = '0';
            contentDiv.style.boxShadow = 'none';
            contentDiv.style.color = '#000';
            contentDiv.style.maxWidth = '100%'; // Cho phép rộng ra để chứa nút dài
            
            // Xếp dọc (để lời dẫn ở trên, nút ở dưới)
            contentDiv.style.display = 'flex';
            contentDiv.style.flexDirection = 'column';
            contentDiv.style.gap = '5px'; 
            
            contentDiv.innerHTML = msg; // Bắt buộc dùng innerHTML để hiện nút/ảnh
        } else {
            // NẾU LÀ USER:
            // Giữ nguyên giao diện bong bóng xanh truyền thống
            contentDiv.style.background = '#007bff';
            contentDiv.style.color = '#fff';
            contentDiv.style.padding = '10px 15px';
            contentDiv.style.borderRadius = '15px';
            contentDiv.style.maxWidth = '80%';
            contentDiv.style.boxShadow = '0 1px 2px rgba(0,0,0,0.1)';
            
            contentDiv.textContent = msg; // Dùng textContent cho an toàn
        }

        // ===============================

        messageDiv.appendChild(contentDiv);
        chatBody.appendChild(messageDiv);

        chatBody.scrollTop = chatBody.scrollHeight;
    }

    // --- 6. Gửi tin nhắn tới server ---
    function sendToServer(msg) {
        fetch('${pageContext.request.contextPath}/ChatServlet', {
            method: 'POST',
            headers: {'Content-Type':'application/x-www-form-urlencoded; charset=UTF-8'},
            body: 'msg=' + encodeURIComponent(msg)
        })
        .then(response => response.text())
        .then(data => addMessage(data,'bot'))
        .catch(err => console.error(err));
    }
    // --- 7. FAQ buttons ---
   
    window.sendQuickMessage = function(text) {
        // 1. Hiện tin nhắn của khách lên màn hình
        addMessage(text, 'user');
        
        // 2. Gửi về Server để Bot trả lời
        sendToServer(text);
    };
</script>
    </body>
</html>