<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- ========== CSS & ICONS ========== -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<!-- Updated version without :root variables (CSS values applied directly) -->

<style>
/* ===========================================
   GLOBAL COLORS (direct values instead of :root)
   =========================================== */
/* Primary colors: #ff6f0f, #d65a3a, #f4a261, #ffffff */
/* Text colors: #2d2d2d, #555 */
/* Background soft: #fafafa */
/* Border soft: #f0f0f0 */

body {
  font-family: "Segoe UI", Arial, sans-serif;
  background-color: #fffefe;
  padding-top: 125px;
  color: #2d2d2d;
}

a { color: #2d2d2d; text-decoration: none; }

/* NAVBAR */
.navbar.shopee-nav {
  background: #f8f2f2;
  padding: 1rem 0;
  border-bottom: 1px solid #f0f0f0;
  position: fixed;
  width: 100%;
  z-index: 200;
  transition: transform 0.1s cubic-bezier(0.25,0.1,0.25,1), opacity 0.1s ease;
  will-change: transform;
}
.navbar.shopee-nav.hidden { transform: translateY(-100%); }

.navbar-brand {
  font-size: 2rem;
  font-weight: 700;
  color: #ff6f0f !important;
}

/* SEARCH BAR */
.shopee-search-form {
  max-width: 550px;
  width: 100%;
  position: relative;
}
.shopee-search-form .form-control {
  height: 42px;
  border-radius: 6px;
  border: 1.5px solid #f0f0f0;
  padding-left: 14px;
  background-color: #fafafa;
}
.shopee-search-form .form-control:focus {
  border-color: #ff6f0f;
  box-shadow: 0 0 6px rgba(231, 111, 81, 0.25);
}
.btn-search {
  position: absolute;
  right: 8px;
  top: 50%;
  transform: translateY(-50%);
  background: #ff6f0f;  
  border: none;
  color: #fff;
  height: 40px;    /* <-- đổi từ 32px thành 42px */
  width: 42px;     /* <-- để thành nút vuông, icon cân */
  border-radius: 8px !important;
  display: flex;
  justify-content: center;
  align-items: center;
}

.btn-search:hover { background: #d65a3a; }

/* NAV ICONS */
.nav-icons .nav-link,
.nav-icons .dropdown-toggle {
  color: #ff7e27;
  font-weight: 500;
  font-size: 1.2rem;
  transition: 0.2s;
  margin-right: 8px;
}
.nav-icons .nav-link:hover {
  color: #ff6f0f;
}

.cart-icon { position: relative; }
.cart-icon .badge {
  position: absolute;
  top: -5px;
  right: -4px;
  font-size: 0.6rem;
  background: #ff6f0f;
  color: white;
  border: 1px solid #fff;
}

/* CATEGORY BAR */
.category-bar {
  background: #fff;
  border-bottom: 1px solid #f0f0f0;
  padding: 10px 0;
  position: fixed;
  width: 100%;
  top: 74px;
  z-index: 1100;
  overflow-x: auto;
  white-space: nowrap;
}
.navbar.shopee-nav.hidden + .category-bar { top: 0; }

.category-menu {
  display: flex;
  gap: 12px;
  justify-content: center;
}

.category-link {
  padding: 6px 14px;
  font-size: 0.92rem;
  border-radius: 20px;
  background: #fafafa;
  color: #2d2d2d;
  transition: all 0.2s;
  font-weight: 500;
  font-family: "Segoe UI", Arial, sans-serif;
}
.category-link:hover {
  background: #ffffff;
  color: #ff6f0f;
}
.category-link.active {
  background: #ff7e27;
  color: #ffffff;
  border: 1px solid #ff6f0f;
  font-weight: 600;
}

/* PRODUCT CARD */
.shopee-product-card {
  background: #fff;
  border-radius: 12px !important;
  padding: 0;
  border: 1px solid #f0f0f0;
  transition: 0.25s;
}
.shopee-product-card:hover {
  transform: translateY(-3px);
  border-color: #ff6f0f;
  box-shadow: 0 4px 14px rgba(0,0,0,0.08);
}

.product-image {
  width: 100%;
  padding-top: 100%;
  position: relative;
}
.product-image img {
  position: absolute;
  width: 100%;
  height: 100%;
  object-fit: contain;
  border-radius: 12px 12px 0 0 !important;
}

.product-info { padding: 10px; }
.product-title {
  font-size: 0.92rem;
  font-weight: 500;
  height: 42px;
  line-height: 1.3;
  overflow: hidden;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}
.product-price {
  font-size: 1.15rem;
  font-weight: 700;
  color: #ff6f0f;
  margin-top: 8px;
}

/* BUTTON ROUNDING */
button,
.btn {
  border-radius: 12px ;
  font-size: 1.2rem ;
}
.btn-search-head { border-radius: 10px !important; }
.btn-search-head {
    position: absolute;
    right: 8px;
    top: 50%;
    transform: translateY(-50%);
    background: #ff6f0f;
    border: none;
    color: #fff;
    height: 40px;
    width: 42px;
    border-radius: 8px !important;
    display: flex;
    justify-content: center;
    align-items: center;
}
.navbar-toggler {
  border-radius: 12px !important;
  padding: 6px 10px;
  border: 1px solid #ddd;
}

.dropdown-menu .dropdown-item {
  border-radius: 8px;
  transition: 0.2s;
}
.dropdown-menu .dropdown-item:hover {
  background-color: #ff7a21 !important;
  color: #fff !important;
}

/* LOGIN BUTTON */
.nav-icons a[href="login"] {
  background: #ff6f0f !important;
  color: #fff !important;
  border: 1px solid #ff6f0f;
  border-radius: 999px !important;
  padding: 6px 16px !important;
  font-size: 14px !important;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 4px;
  transition: 0.25s;
}
.nav-icons a[href="login"]:hover {
  background: #d65a3a !important;
  border-color: #d65a3a !important;
}

/* REGISTER BUTTON */
.nav-icons a[href="register"] {
  background: #ffffff !important;
  color: #ff6f0f !important;
  border: 1.5px solid #ff6f0f;
  border-radius: 999px !important;
  padding: 6px 16px !important;
  font-size: 14px !important;
  font-weight: 600;
  display: flex;
  align-items: center;
  gap: 4px;
  transition: 0.25s;
}
.nav-icons a[href="register"]:hover {
  background: #ffffff !important;
  border-color: #d65a3a !important;
  color: #d65a3a !important;
}

/* CATEGORY DROPDOWN BUTTON */
.category-toggle-btn {
  background: #ff6f0f !important;
  color: #fff !important;
  border-radius: 20px !important;
  padding: 6px 14px !important;
  font-weight: 600;
  border: none !important;
  margin-left: -120px !important;
}
.category-toggle-btn:hover {
  background: #d65a3a !important;
}

.category-dropdown-menu {
  border-radius: 12px !important;
  padding: 0 !important;
  overflow: hidden;
  border: 1px solid #ff6f0f !important;
  margin-left: -200px !important;
}
.category-dropdown-menu .dropdown-item {
  padding: 10px 16px !important;
  color: #2d2d2d !important;
  background: #fff !important;
  border-bottom: 1px solid #f2f2f2 !important;
}
.category-dropdown-menu .dropdown-item:hover {
  background: #ffffff !important;
  color: #ff6f0f !important;
}
.category-dropdown-menu .dropdown-item.active {
  background: #ff6f0f !important;
  color: #fff !important;
}
</style>



<!-- ========== NAVBAR ========== -->
<nav class="navbar navbar-expand-lg shopee-nav fixed-top">
  <div class="container">
    <!-- Logo -->
    <a class="navbar-brand" href="home">
      <i class="fa-solid fa-store"></i>T store
    </a>

    <!-- Toggle -->
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarsMain">
      <span class="navbar-toggler-icon"></span>
    </button>

    <!-- Navbar Content -->
    <div class="collapse navbar-collapse" id="navbarsMain">
      <!-- Search -->
      <form class="shopee-search-form d-flex mx-lg-auto my-2 my-lg-0" action="home" method="get">
        <input class="form-control" type="search" name="search" placeholder="Tìm kiếm sản phẩm..." value="${searchQuery}">
        <button class="btn btn-search-head" type="submit"><i class="fas fa-search"></i></button>
      </form>
<!-- CATEGORY DROPDOWN BUTTON -->
<div class="dropdown ms-3">
    <button class="btn category-toggle-btn d-flex align-items-center" 
            type="button" data-bs-toggle="dropdown">
       <i class="fa-solid fa-list"></i> 
    </button>

    <ul class="dropdown-menu category-dropdown-menu">
        <li>
            <a class="dropdown-item ${empty activeCategoryId ? 'active' : ''}" href="home">
                Trang chủ
            </a>
        </li>

        <c:forEach items="${categoryList}" var="c">
            <li>
                <a class="dropdown-item ${activeCategoryId == c.maDanhMuc ? 'active' : ''}" 
                   href="home?cid=${c.maDanhMuc}">
                    ${c.tenDanhMuc}
                </a>
            </li>
        </c:forEach>
    </ul>
</div>


      <!-- Icons & User -->
      <div class="nav-icons d-flex align-items-center ms-lg-3">
        <!-- Cart -->
        <a class="nav-link cart-icon px-3" href="cart">
          <i class="fas fa-shopping-cart fs-4"></i>
          <c:if test="${not empty sessionScope.cart && not empty sessionScope.cart.items}">
            <span class="badge rounded-pill">${sessionScope.cart.totalItems}</span>
          </c:if>
        </a>

        <!-- User -->
        <c:choose>
  <c:when test="${sessionScope.acc != null}">
    <div class="dropdown">
      <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown">
        <i class="fas fa-user-circle fs-4"></i>
        <span class="d-none d-lg-inline ms-1">${sessionScope.acc.hoTen}</span>
      </a>
      <ul class="dropdown-menu dropdown-menu-end">
        <c:if test="${sessionScope.acc.vaiTro == 'admin'}">
            <li><a class="dropdown-item" href="manager-product">Quay lại Trang Admin</a></li>
                                <li><a class="dropdown-item" href="home">Quay lại Trang chủ</a></li>

          <li><a class="dropdown-item" href="manager-product">Quản Lý Sản Phẩm</a></li>
          <li><a class="dropdown-item" href="manage-user">Quản Lý Tài Khoản</a></li>
          <li><a class="dropdown-item" href="manage-order">Quản Lý Đơn Hàng</a></li>
          <li><a class="dropdown-item" href="managerBot">Quản Lý Chat Bot</a></li>
           <li><a class="dropdown-item" href="admin-reviews">Quản Lý đánh giá</a></li>
          <li><a class="dropdown-item" href="statistic">Xem Thống Kê</a></li>
                    

          <li><hr class="dropdown-divider"></li>
        </c:if>
        <li><a class="dropdown-item" href="profile">Thông Tin Tài Khoản</a></li>
        <li><a class="dropdown-item" href="change-password">Đổi Mật Khẩu</a></li>
        <li><a class="dropdown-item" href="order-history">Lịch sử mua hàng</a></li> 
        <li><a class="dropdown-item" href="logout">Đăng Xuất</a></li>
      </ul>
    </div>
  </c:when>
  <c:otherwise>
    <a href="login" class="nav-link px-3"><i class="fa-solid fa-right-to-bracket"></i>Đăng Nhập</a>
    <a href="register" class="nav-link px-2"><i class="fa-solid fa-user-plus"></i>Đăng Ký</a>
  </c:otherwise>
</c:choose>

      </div>
    </div>
  </div>
</nav>



<!-- ========== JS ========== -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
  // Ẩn/hiện navbar khi cuộn
  let lastScrollTop = 0;
  const navbar = document.querySelector(".navbar.shopee-nav");

  if (navbar) {
    const navbarHeight = navbar.offsetHeight;
    window.addEventListener("scroll", function() {
      let scrollTop = window.pageYOffset || document.documentElement.scrollTop;
      if (scrollTop > lastScrollTop && scrollTop > navbarHeight) {
        navbar.classList.add("hidden");
      } else {
        navbar.classList.remove("hidden");
      }
      lastScrollTop = scrollTop <= 0 ? 0 : scrollTop;
    });
  }
</script>
