<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Về Chúng Tôi | Phụ Kiện Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">

    <style>
        body { font-family: 'Segoe UI', sans-serif; color: #333; overflow-x: hidden; }
        
        /* Hero Banner với hiệu ứng Parallax */
        .about-hero {
            background: linear-gradient(rgba(0,0,0,0.7), rgba(0,0,0,0.6)), url('https://images.unsplash.com/photo-1497215728101-856f4ea42174?q=80&w=2070&auto=format&fit=crop');
            background-size: cover;
            background-attachment: fixed; /* Tạo hiệu ứng chiều sâu khi cuộn */
            background-position: center;
            height: 350px;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            position: relative;
        }
        
        /* Section Titles */
        .section-title {
            color: #ff6600;
            font-weight: 800;
            text-transform: uppercase;
            position: relative;
            margin-bottom: 50px;
            text-align: center;
            letter-spacing: 1px;
        }
        .section-title::after {
            content: '';
            width: 80px;
            height: 4px;
            background: #ff6600;
            position: absolute;
            bottom: -15px;
            left: 50%;
            transform: translateX(-50%);
            border-radius: 2px;
        }

        /* Stats Counter Card */
        .stat-card {
            border: none;
            background: #fff;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            transition: all 0.4s ease;
            position: relative;
            overflow: hidden;
        }
        .stat-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; width: 100%; height: 5px;
            background: #ff6600;
            transform: scaleX(0);
            transform-origin: left;
            transition: transform 0.4s ease;
        }
        .stat-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 35px rgba(255, 102, 0, 0.15);
        }
        .stat-card:hover::before {
            transform: scaleX(1);
        }
        .stat-icon {
            font-size: 3.5rem;
            color: #ff6600;
            margin-bottom: 20px;
            opacity: 0.8;
        }
        .stat-number {
            font-size: 3rem;
            font-weight: 800;
            color: #222;
            line-height: 1;
            margin-bottom: 10px;
        }

        /* Team Members */
        .team-member {
            text-align: center;
            margin-bottom: 30px;
            position: relative;
        }
        .team-img-box {
            width: 200px;
            height: 200px;
            margin: 0 auto 20px;
            border-radius: 50%;
            overflow: hidden;
            border: 5px solid #fff;
            box-shadow: 0 8px 20px rgba(0,0,0,0.1);
            transition: all 0.5s ease;
            position: relative;
        }
        .team-member:hover .team-img-box {
            border-color: #ff6600;
            transform: scale(1.05) rotate(3deg);
            box-shadow: 0 10px 25px rgba(255, 102, 0, 0.3);
        }
        .team-img-box img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s;
        }
        .team-member:hover img {
            transform: scale(1.1);
        }
        .team-role {
            color: #ff6600;
            font-weight: 700;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        
        /* Contact CTA */
        .cta-section {
            background: linear-gradient(45deg, #222, #444);
            color: white;
            border-radius: 20px;
            overflow: hidden;
        }
        .btn-glow {
            background: #ff6600;
            color: white;
            border: none;
            box-shadow: 0 0 15px rgba(255, 102, 0, 0.5);
            transition: 0.3s;
        }
        .btn-glow:hover {
            background: #e65c00;
            box-shadow: 0 0 25px rgba(255, 102, 0, 0.8);
            transform: scale(1.05);
            color: white;
        }
    </style>
</head>
<body>
    <jsp:include page="header.jsp" />

    <div class="about-hero mb-5">
        <div data-aos="zoom-in" data-aos-duration="1000">
            <h1 class="display-3 fw-bold mb-3">Câu Chuyện Của Chúng Tôi</h1>
            <p class="lead fs-4">Đam mê công nghệ - Tận tâm phục vụ</p>
        </div>
    </div>

    <div class="container">
        
        <div class="row align-items-center mb-5 py-5">
            <div class="col-md-6" data-aos="fade-right" data-aos-duration="1000">
                <div class="position-relative">
                    <img src="https://images.unsplash.com/photo-1556761175-5973dc0f32e7?q=80&w=1932&auto=format&fit=crop" 
                         class="img-fluid rounded-4 shadow-lg" alt="Shop Image">
                    <div class="position-absolute bg-white p-3 rounded shadow" style="bottom: -20px; right: -20px; border-left: 5px solid #ff6600;">
                        <div class="fw-bold text-dark">Thành lập từ</div>
                        <div class="h4 text-danger mb-0">2025</div>
                    </div>
                </div>
            </div>
            <div class="col-md-6 mt-5 mt-md-0 ps-md-5" data-aos="fade-left" data-aos-duration="1000">
                <h6 class="text-uppercase text-danger fw-bold mb-2">Về Phụ Kiện Store</h6>
                <h2 class="fw-bold mb-4">Khởi Nguồn Từ Đam Mê Công Nghệ</h2>
                <p class="text-muted mb-4" style="line-height: 1.8;">
                    Chúng tôi không chỉ bán phụ kiện, chúng tôi cung cấp giải pháp để nâng tầm trải nghiệm công nghệ của bạn. Từ một cửa hàng nhỏ bé, bằng sự nỗ lực không ngừng nghỉ và niềm tin của khách hàng, Phụ Kiện Store đã vươn lên trở thành điểm đến tin cậy hàng đầu.
                </p>
                <div class="row g-3">
                    <div class="col-6">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-check-circle text-success me-2 fa-lg"></i>
                            <span class="fw-bold">Hàng Chính Hãng</span>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-bolt text-warning me-2 fa-lg"></i>
                            <span class="fw-bold">Giao Hỏa Tốc</span>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-undo text-primary me-2 fa-lg"></i>
                            <span class="fw-bold">Đổi Trả 30 Ngày</span>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-headset text-info me-2 fa-lg"></i>
                            <span class="fw-bold">Support 24/7</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="py-5 mb-5 bg-light rounded-4" data-aos="fade-up" data-aos-duration="800">
            <div class="text-center mb-5">
                <h2 class="section-title">Những Con Số Biết Nói</h2>
            </div>
            <div class="row text-center g-4 px-4">
                <div class="col-md-4">
                    <div class="stat-card h-100">
                        <div class="stat-icon"><i class="fas fa-calendar-check"></i></div>
                        <div class="stat-number counter" data-target="${yearsExp}">0</div>
                        <div class="text-uppercase fw-bold text-muted small">Năm Kinh Nghiệm</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card h-100">
                        <div class="stat-icon"><i class="fas fa-box-open"></i></div>
                        <div class="stat-number counter" data-target="${totalSold}">0</div>
                        <div class="text-uppercase fw-bold text-muted small">Sản Phẩm Đã Bán</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card h-100">
                        <div class="stat-icon"><i class="fas fa-users"></i></div>
                        <div class="stat-number counter" data-target="${totalCustomers}">0</div>
                        <div class="text-uppercase fw-bold text-muted small">Khách Hàng Tin Dùng</div>
                    </div>
                </div>
            </div>
        </div>

        <div class="mb-5 py-5">
            <h2 class="section-title" data-aos="fade-down">Biệt Đội Siêu Đẳng</h2>
            <p class="text-center text-muted mb-5 w-75 mx-auto" data-aos="fade-up">Những gương mặt trẻ trung đứng sau sự thành công của chúng tôi</p>
            
            <div class="row">
                <div class="col-md-3 col-sm-6 team-member" data-aos="fade-up" data-aos-delay="100">
                    <div class="team-img-box">
                        <img src="https://img.freepik.com/free-photo/portrait-white-man-isolated_53876-40306.jpg" alt="CEO">
                    </div>
                    <h5 class="fw-bold mb-1">Hoàng Xuân Tuấn</h5>
                    <div class="team-role">Leader</div>
                </div>

              

                <div class="col-md-3 col-sm-6 team-member" data-aos="fade-up" data-aos-delay="300">
                    <div class="team-img-box">
                        <img src="https://img.freepik.com/free-photo/handsome-young-man-with-new-stylish-haircut_176420-19637.jpg" alt="Support">
                    </div>
                    <h5 class="fw-bold mb-1">Vi Ngọc Thắng</h5>
                    <div class="team-role">Tech Lead</div>
                </div>

                <div class="col-md-3 col-sm-6 team-member" data-aos="fade-up" data-aos-delay="400">
                    <div class="team-img-box">
                        <img src="https://img.freepik.com/free-photo/close-up-portrait-curly-handsome-european-male_176532-8133.jpg" alt="Marketing">
                    </div>
                    <h5 class="fw-bold mb-1">Hà Đức Trọng</h5>
                    <div class="team-role">Marketing</div>
                </div>
            </div>
        </div>

        <div class="cta-section p-5 mb-5 shadow-lg" data-aos="zoom-in-up">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h3 class="fw-bold mb-2">Bạn Có Thắc Mắc Về Sản Phẩm?</h3>
                    <p class="mb-md-0 text-white-50">Đừng ngần ngại liên hệ, chúng tôi sẽ phản hồi trong vòng 5 phút.</p>
                </div>
                <div class="col-md-4 text-end text-center-sm">
                    <a href="#" class="btn btn-lg btn-glow rounded-pill px-5 fw-bold">Chat Ngay <i class="fas fa-comment-dots ms-2"></i></a>
                </div>
            </div>
        </div>

    </div>

    <jsp:include page="footer.jsp" />
   
    
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <script>
        // 1. Kích hoạt hiệu ứng cuộn (AOS)
        AOS.init({
            once: true, // Chỉ chạy hiệu ứng 1 lần khi cuộn xuống
            offset: 100, // Cách mép dưới 100px thì bắt đầu chạy
        });

        // 2. Hiệu ứng số chạy (Counter)
        const counters = document.querySelectorAll('.counter');
        const speed = 200; // Tốc độ chạy (càng nhỏ càng nhanh)

        const animateCounters = () => {
            counters.forEach(counter => {
                const updateCount = () => {
                    const target = +counter.getAttribute('data-target'); // Lấy số đích
                    const count = +counter.innerText; // Số hiện tại
                    
                    const inc = target / speed; // Bước nhảy

                    if (count < target) {
                        counter.innerText = Math.ceil(count + inc);
                        setTimeout(updateCount, 20); // Chạy đệ quy sau 20ms
                    } else {
                        counter.innerText = target; // Đảm bảo số cuối cùng chính xác
                    }
                };
                updateCount();
            });
        }

        // Chỉ chạy số khi người dùng cuộn tới phần Stats
        let hasRun = false;
        window.addEventListener('scroll', () => {
            const statsSection = document.querySelector('.stat-card');
            const position = statsSection.getBoundingClientRect().top;
            const screenPosition = window.innerHeight / 1.3;

            if (position < screenPosition && !hasRun) {
                animateCounters();
                hasRun = true; // Chỉ chạy 1 lần
            }
        });
    </script>
</body>
</html>