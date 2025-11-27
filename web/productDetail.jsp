<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${productDetail.tenSanPham}</title>

    <!-- Bootstrap & FontAwesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>

<style>
/* ======= TONE CAM ======= */
body {
    background-color: #fffaf4;
    font-family: Arial, sans-serif;
}
:root {
    --main-orange: #ff7b00;
    --orange-light: #ffe5cc;
}

/* ======= NAVBAR ======= */
.navbar {
    background: white !important;
    border-bottom: 3px solid var(--main-orange);
}
.navbar-brand, .navbar-nav .nav-link {
    color: var(--main-orange) !important;
    font-weight: 600;
}
.navbar-nav .nav-link:hover {
    background-color: var(--orange-light);
    border-radius: 6px;
}

/* ======= BUTTON ======= */


/* ======= KHUNG CHI TIẾT ======= */
.detail-container {
    background: #fff;
    padding: 2rem;
    margin-top: 2rem;
    border-radius: 10px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}
.btn-shopee-add {
    border-radius: 12px !important;
    border:1px #ff7e27 solid !important;
    background-color: #FFF0EB !important;
    color: #ff7e27 !important;
    font-size: 20px;
    padding: 8px 16px;
}
.btn-lg{
      border-radius: 12px !important;
    border:1px #ff7e27 solid !important;
    background-color: #ff7e27 !important;
    color: #fff !important;
    font-size: 20px;
    padding: 8px 16px;
}
.btn-shopee-add:hover{
     border-radius: 12px !important;
    border:1px #ff7e27 solid !important;
    background-color: #ff7e27 !important;
    color: black !important;
}
.btn-lg:hover{
    border-radius: 12px !important;
    border:1px #ff7e27 solid !important;
    background-color: #ff7e27 !important;
    color: black !important;
}
/* Ảnh chi tiết – Không méo, không zoom, luôn cân */
.product-image-detail {
    width: 100%;
    height: 350px;
    object-fit: contain;
    padding: 10px;
    background: white;
    border: 1px solid #eee;
    border-radius: 10px;
}

/* ======= GIÁ ======= */
.product-price-detail {
    font-size: 2rem;
    font-weight: bold;
    color: var(--main-orange);
    background: #fff0e0;
    padding: 1rem;
    border-radius: 10px;
}

/* ======= MÔ TẢ ======= */
.product-description-container {
    margin-top: 2rem;
    background: white;
    border-radius: 10px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}
.description-header {
    padding: 1rem;
    background: #fff5eb;
    border-bottom: 1px solid #eee;
}
.description-body {
    padding: 1.5rem;
    line-height: 1.7;
    white-space: pre-wrap;
}

/* ====================== SẢN PHẨM LIÊN QUAN ====================== */
.related-products-container {
    margin-top: 2rem;
    background: #fff;
    border-radius: 10px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}
.related-header {
    padding: 1rem;
    background: #fff5eb;
    border-bottom: 1px solid #eee;
    display: flex;
    justify-content: space-between;
}

/* CARD SẢN PHẨM LIÊN QUAN */
.shopee-product-card {
    text-decoration: none;
    display: block;
    background: white;
    border-radius: 12px;
    border: 1px solid #eee;
    transition: 0.25s;
    overflow: hidden;
}
.shopee-product-card:hover {
    border-color: var(--main-orange);
    transform: translateY(-5px);
    box-shadow: 0 6px 15px rgba(0,0,0,0.15);
}

/* KHUNG ẢNH – chuẩn Shopee */
.product-image {
    width: 100%;
    height: 220px;
    background: #fff;
    display: flex;
    justify-content: center;
    align-items: center;
    overflow: hidden;
}
/* Ảnh không méo, không zoom */
.product-image img {
    max-width: 100%;
    max-height: 100%;
    object-fit: cover;
    top: 8px;
}

/* TEXT */
.product-title {
    font-size: 0.9rem;
    min-height: 40px;
    color: #333;
    font-weight: 500;
}
.product-price {
    font-size: 1.1rem;
    font-weight: bold;
    color: var(--main-orange);
    margin-bottom: 12px;
}
</style>

</head>
<body>

<jsp:include page="header.jsp"/>

<div class="container">

    <!-- Chi tiết sản phẩm -->
    <c:if test="${not empty productDetail}">
        <div class="detail-container">
            <div class="row g-4 align-items-center">

                <!-- Ảnh -->
                <div class="col-md-5">
                    <img src="${productDetail.hinhAnh}" class="product-image-detail">
                </div>

                <!-- Thông tin -->
                <div class="col-md-7">
                    <h2>${productDetail.tenSanPham}</h2>
                    <p class="text-muted">Mã SP: SP${productDetail.maSanPham}</p>

                    <div class="product-price-detail">
                        <fmt:formatNumber value="${productDetail.gia}" type="currency"
                                          currencyCode="VND" minFractionDigits="0"/>
                    </div>

                    <div class="d-flex align-items-center gap-3 mt-3">
                        <a class="btn-shopee-add" href="cart?action=add&productId=${productDetail.maSanPham}"
                           class="btn btn-shopee-add btn-lg">
                            <i class="fas fa-cart-plus"></i> Thêm vào giỏ
                        </a>

                        <a class="btn-lg" href="buy-now?pid=${productDetail.maSanPham}"
                           class="btn btn-lg">
                            Mua ngay
                        </a>
                    </div>

                    <div class="mt-4">
                        <c:choose>
                            <c:when test="${productDetail.soLuongTon > 0}">
                                <span class="text-success">
                                    <i class="fas fa-check-circle"></i>
                                    Còn hàng (${productDetail.soLuongTon})
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="text-danger">
                                    <i class="fas fa-times-circle"></i>
                                    Hết hàng
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                </div>
            </div>
        </div>

        <!-- Mô tả sản phẩm -->
        <div class="product-description-container">
            <div class="description-header">
                <h4>Mô tả sản phẩm</h4>
            </div>
            <div class="description-body">
                ${productDetail.moTa}
            </div>
        </div>

        <!-- Sản phẩm liên quan -->
        <c:if test="${not empty relatedProducts}">
            <div class="related-products-container">
                <div class="related-header">
                    <h4>Sản phẩm liên quan</h4>
                    <a href="home?cid=${productDetail.maDanhMuc}" class="btn-view-more">Xem thêm →</a>
                </div>

                <div class="row row-cols-2 row-cols-md-4 g-3 p-3">
                    <c:forEach items="${relatedProducts}" var="p">
                        <div class="col">
                            <a href="detail?pid=${p.maSanPham}" class="shopee-product-card">
                                <div class="product-image">
                                    <img src="${p.hinhAnh}" alt="">
                                </div>

                                <div class="p-2">
                                    <div class="product-title">${p.tenSanPham}</div>
                                    <div class="product-price">
                                        <fmt:formatNumber value="${p.gia}" type="currency"
                                                          currencyCode="VND" minFractionDigits="0"/>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </c:forEach>
                </div>

            </div>
        </c:if>

    </c:if>

    <c:if test="${empty productDetail}">
        <div class="alert alert-danger mt-4 text-center">
            Sản phẩm không tồn tại. <a href="home">Quay lại trang chủ</a>.
        </div>
    </c:if>

</div>

<jsp:include page="footer.jsp"/>

</body>
</html>
