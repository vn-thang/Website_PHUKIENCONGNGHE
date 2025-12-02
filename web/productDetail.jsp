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
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

<style>
    /*<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet"> */
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

/* CSS STYLE SHOPEE */
    .shopee-bg { background-color: #fff; }
    .text-shopee-orange { color: #ee4d2d; }
    .text-star-gold { color: #ffc107; }
    .text-star-gray { color: #e4e5e9; }
    
    /* Header tổng quan */
    .review-header-container {
        background-color: #fffbf8; border: 1px solid #f9ede5;
        padding: 30px; border-radius: 4px; display: flex; align-items: center;
    }
    .average-score { font-size: 40px; color: #ee4d2d; }
    
    /* Danh sách review */
    .review-item { padding: 20px 0; border-bottom: 1px solid rgba(0,0,0,.09); display: flex; }
    .shopee-avatar { width: 40px; height: 40px; border-radius: 50%; margin-right: 15px; }
    .reviewer-name { font-size: 12px; font-weight: bold; }
    .review-time { font-size: 12px; color: rgba(0,0,0,.54); }
    .review-text { font-size: 14px; margin-top: 5px; color: rgba(0,0,0,.87); }

    /* Form đánh giá */
    .shopee-review-form { background: #fafafa; padding: 20px; border: 1px solid #e5e5e5; border-radius: 4px; margin-top: 20px; }
    .starrating { display: inline-flex; flex-direction: row-reverse; }
    .starrating > input { display: none; }
    .starrating > label { color: #ccc; font-size: 30px; margin: 0 2px; cursor: pointer; }
    .starrating > label:before { content: "★"; }
    .starrating > input:checked ~ label,
    .starrating > label:hover, .starrating > label:hover ~ label { color: #ffc107; }
    
    .shopee-textarea { width: 100%; padding: 10px; border: 1px solid #ddd; margin-top: 10px; font-size: 14px; }
    .btn-shopee-submit { background-color: #ee4d2d; color: white; border: none; padding: 8px 25px; margin-top: 10px; cursor: pointer; }
    .btn-shopee-submit:hover { background-color: #d03e1e; }
    /* CSS Nút bộ lọc */
.filter-btn {
    background: #fff;
    border: 1px solid rgba(0,0,0,.09);
    padding: 5px 15px;
    margin-right: 10px;
    margin-bottom: 5px;
    border-radius: 2px;
    color: rgba(0,0,0,.8);
    cursor: pointer;
    transition: all 0.2s;
}
.filter-btn:hover {
    color: #ee4d2d;
    border-color: #ee4d2d;
}
/* Trạng thái đang chọn */
.filter-btn.active {
    border-color: #ee4d2d;
    color: #ee4d2d;
    background: #fff; /* Hoặc màu nhạt hơn nếu thích */
}

/* Nút Xem thêm */
.btn-load-more {
    display: block;
    width: 200px;
    margin: 20px auto;
    padding: 10px;
    border: 1px solid #ddd;
    background: #fff;
    color: #555;
    text-align: center;
    cursor: pointer;
}
.btn-load-more:hover { background: #f8f8f8; }

/* Class ẩn dùng cho JS */
.d-none-custom { display: none !important; }
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

            
        <div class="mt-5 p-4 shadow-sm rounded bg-white">
    <h4 class="mb-4">ĐÁNH GIÁ SẢN PHẨM</h4>

    <div class="review-header-container mb-4">
        <div class="mr-5 text-center">
            <div>
                <span class="average-score">${avgVote}</span>
                <span class="text-shopee-orange" style="font-size: 20px;"> trên 5</span>
            </div>
            <div class="text-star-gold" style="font-size: 24px;">
                 <c:forEach begin="1" end="5" var="i">
                    <c:choose>
                        <c:when test="${i <= avgVote}">★</c:when>
                        <c:otherwise><span class="text-star-gray">★</span></c:otherwise>
                    </c:choose>
                </c:forEach>
            </div>
        </div>
        
        <div class="d-flex flex-wrap align-items-center">
            <button class="filter-btn active" onclick="filterReviews('all', this)">Tất cả (${countReview})</button>
            <button class="filter-btn" onclick="filterReviews('5', this)">5 Sao</button>
            <button class="filter-btn" onclick="filterReviews('4', this)">4 Sao</button>
            <button class="filter-btn" onclick="filterReviews('3', this)">3 Sao</button>
            <button class="filter-btn" onclick="filterReviews('2', this)">2 Sao</button>
            <button class="filter-btn" onclick="filterReviews('1', this)">1 Sao</button>
            <button class="filter-btn" onclick="filterReviews('comment', this)">Có Bình luận</button>
        </div>
    </div>

    <c:if test="${canReview}">
        <div class="shopee-review-form mb-4">
            <h6 class="text-success mb-2">✍️ Viết đánh giá của bạn (Còn ${luotConLai} lượt)</h6>
            <form action="review" method="post">
                <input type="hidden" name="pid" value="${productDetail.maSanPham}">
                
                <div class="d-flex align-items-center">
                    <span class="mr-3">Chất lượng sản phẩm:</span>
                    <div class="starrating">
                        <input type="radio" id="star5" name="rating" value="5" checked /><label for="star5" title="Tuyệt vời"></label>
                        <input type="radio" id="star4" name="rating" value="4" /><label for="star4" title="Tốt"></label>
                        <input type="radio" id="star3" name="rating" value="3" /><label for="star3" title="Bình thường"></label>
                        <input type="radio" id="star2" name="rating" value="2" /><label for="star2" title="Kém"></label>
                        <input type="radio" id="star1" name="rating" value="1" /><label for="star1" title="Tệ"></label>
                    </div>
                    <span class="ml-2 text-warning" id="rating-text">Tuyệt vời</span>
                </div>
                
                <textarea name="comment" class="shopee-textarea" rows="4" placeholder="Hãy chia sẻ nhận xét cho sản phẩm này bạn nhé!" required></textarea>
                
                <div class="text-right">
                    <button type="submit" class="btn-shopee-submit">Gửi Đánh Giá</button>
                </div>
            </form>
        </div>
        <script>
            const labels = {1:'Tệ', 2:'Kém', 3:'Bình thường', 4:'Tốt', 5:'Tuyệt vời'};
            document.querySelectorAll('.starrating input').forEach(i => {
                i.addEventListener('change', function() { document.getElementById('rating-text').innerText = labels[this.value]; });
            });
        </script>
    </c:if>
    
    <c:if test="${!canReview}">
        <div class="alert alert-secondary mt-3 mb-4"><i class="fa fa-info-circle"></i> ${reviewMessage}</div>
    </c:if>

    <div class="review-list" id="reviewContainer">
        
        <c:forEach items="${listReview}" var="r" varStatus="status">
            <div class="review-item ${status.index >= 5 ? 'hidden-init' : ''}" 
                 data-star="${r.soSao}" 
                 data-has-comment="${not empty r.noiDung && r.noiDung.length() > 0}">
                 
                <img class="shopee-avatar" src="https://ui-avatars.com/api/?name=${r.tenUser}&background=random&color=fff" alt="User">
                
                <div style="flex: 1;">
                    <div class="reviewer-name">${r.tenUser}</div>
                    <div class="d-flex align-items-center">
                        <span class="text-star-gold mr-2">
                            <c:forEach begin="1" end="5" var="i">
                                <c:choose><c:when test="${i <= r.soSao}">★</c:when><c:otherwise><span class="text-star-gray">★</span></c:otherwise></c:choose>
                            </c:forEach>
                        </span>
                        <span class="review-time">${r.ngayDanhGia} | Phân loại hàng: Mặc định</span>
                    </div>
                     <div class="review-text">${r.noiDung}</div>
                     
                     <c:if test="${not empty r.phanHoi}">
    <div class="mt-3 p-3 rounded" style="background-color: #f6f6f6; border: 1px solid #eee;">
        <div style="font-size: 13px; color: #ee4d2d; font-weight: bold; margin-bottom: 5px;">
            Phản hồi của Người Bán:
        </div>
        <div style="font-size: 14px; color: #555;">
            ${r.phanHoi}
        </div>
    </div>
</c:if>

                </div>               
            </div>
        </c:forEach>

        <c:if test="${countReview == 0}">
            <p class="text-center text-muted py-4">Chưa có đánh giá nào.</p>
        </c:if>
        
        <p id="no-result-msg" class="text-center text-muted py-4 d-none-custom">Không có đánh giá nào phù hợp với bộ lọc này.</p>
    </div>

    <c:if test="${countReview > 5}">
        <div id="toggleReviewBtn" class="btn-load-more" onclick="toggleReviews()" data-expanded="false">
            Xem thêm đánh giá <i class="fas fa-chevron-down ml-1"></i>
        </div>
    </c:if>
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
<script>
    // CSS class ban đầu để ẩn các review thứ 6 trở đi
    const style = document.createElement('style');
    style.innerHTML = `
        .hidden-init { display: none; } 
    `;
    document.head.appendChild(style);

    // 1. HÀM LỌC ĐÁNH GIÁ
    function filterReviews(criteria, btnElement) {
        // A. Xử lý giao diện nút bấm (Active)
        // Xóa class active ở tất cả các nút
        document.querySelectorAll('.filter-btn').forEach(btn => btn.classList.remove('active'));
        // Thêm class active vào nút vừa bấm
        btnElement.classList.add('active');

        // B. Xử lý ẩn/hiện review
        const reviews = document.querySelectorAll('.review-item');
        let countVisible = 0;

        reviews.forEach(review => {
            const star = review.getAttribute('data-star');
            const hasComment = review.getAttribute('data-has-comment');

            let isMatch = false;

            if (criteria === 'all') {
                isMatch = true;
            } else if (criteria === 'comment') {
                isMatch = (hasComment === 'true');
            } else {
                // Lọc theo số sao (1, 2, 3, 4, 5)
                isMatch = (star === criteria);
            }

            if (isMatch) {
                review.classList.remove('d-none-custom'); // Hiện
                countVisible++;
            } else {
                review.classList.add('d-none-custom'); // Ẩn
            }
            
            // QUAN TRỌNG: Khi đã lọc thì bỏ qua chế độ "Xem thêm" (Hiện tất cả kết quả tìm được)
            review.classList.remove('hidden-init'); 
        });

        // C. Xử lý thông báo "Không tìm thấy" và nút "Xem thêm"
        const noResultMsg = document.getElementById('no-result-msg');
        const loadMoreBtn = document.getElementById('loadMoreBtn');

        // Nếu không có kết quả nào -> Hiện thông báo
        if (countVisible === 0) {
            noResultMsg.classList.remove('d-none-custom');
        } else {
            noResultMsg.classList.add('d-none-custom');
        }

        // Khi đang lọc thì ẩn nút "Xem thêm" đi (vì đã show hết kết quả lọc rồi)
        if (loadMoreBtn) {
            if (criteria === 'all' && ${countReview} > 5) {
                // Nếu bấm lại "Tất cả" mà số lượng > 5 thì logic hơi phức tạp xíu
                // Để đơn giản: Khi bấm lại Tất cả -> Hiện hết luôn, khỏi ẩn lại.
                loadMoreBtn.style.display = 'none'; 
            } else {
                loadMoreBtn.style.display = 'none';
            }
        }
    }

    // 2. HÀM XEM THÊM (Chỉ dùng cho mặc định ban đầu)
    function toggleReviews() {
        const btn = document.getElementById('toggleReviewBtn');
        const isExpanded = btn.getAttribute('data-expanded') === 'true';
        const hiddenItems = document.querySelectorAll('.review-item');

        if (!isExpanded) {
            // === TRƯỜNG HỢP 1: BẤM ĐỂ MỞ RỘNG ===
            hiddenItems.forEach(item => {
                // Xóa class ẩn để hiện ra hết
                item.classList.remove('hidden-init');
            });

            // Đổi giao diện nút
            btn.innerHTML = 'Thu gọn <i class="fas fa-chevron-up ml-1"></i>';
            btn.setAttribute('data-expanded', 'true');
            
        } else {
            // === TRƯỜNG HỢP 2: BẤM ĐỂ THU GỌN ===
            hiddenItems.forEach((item, index) => {
                // Nếu là cái thứ 6 trở đi (index >= 5) thì ẩn lại
                if (index >= 5) {
                    item.classList.add('hidden-init');
                }
            });

            // Đổi giao diện nút về ban đầu
            btn.innerHTML = 'Xem thêm đánh giá <i class="fas fa-chevron-down ml-1"></i>';
            btn.setAttribute('data-expanded', 'false');
            // [QUAN TRỌNG] Tự động cuộn lên đầu phần đánh giá (UX xịn)
            // Tìm cái thẻ bao quanh danh sách review để cuộn tới đó
            document.querySelector('.review-header-container').scrollIntoView({ 
                behavior: 'smooth', 
                block: 'start' 
            });
        }
    }
</script>
</body>
</html>
