<%-- 
    Document    : aboutUs.jsp
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>About Us | GIO</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

        <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">

        <link href='https://fonts.googleapis.com/css?family=Quicksand:300,400,500,600,700&display=swap' rel='stylesheet'>

        <link rel="icon" href="${pageContext.request.contextPath}/images/LG2.png" type="image/x-icon">

        <style>
            /* --- GLOBAL VARIABLES --- */
            :root {
                --primary-color: #a0816c;
                --primary-hover: #8a6d5a;
                --secondary-color: #2c3e50;
                --bg-light: #f9f9f9;
                --text-dark: #333;
                --text-muted: #666;
                --card-radius: 20px;
                --transition-smooth: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
            }

            html {
                scroll-behavior: smooth;
            }

            body {
                font-family: 'Quicksand', sans-serif;
                color: var(--text-dark);
                background-color: #fff;
                overflow-x: hidden;
            }

            /* --- 1. HERO BANNER --- */
            .about-hero {
                position: relative;
                height: 400px;
                background-image: url('https://theme.hstatic.net/1000296747/1000891809/14/gallery_item_4_img.jpg?v=55');
                background-size: cover;
                background-position: center;
                background-attachment: fixed; /* Parallax Effect */
                display: flex;
                align-items: center;
                justify-content: center;
                color: #fff;
                margin-bottom: 60px;
            }
            .about-hero::before {
                content: '';
                position: absolute;
                inset: 0;
                background: rgba(0,0,0,0.5);
            }
            .about-hero-content {
                position: relative;
                z-index: 2;
                text-align: center;
            }
            .about-hero-title {
                font-size: 3.5rem;
                font-weight: 700;
                margin-bottom: 15px;
                letter-spacing: 2px;
                animation: floatText 3s ease-in-out infinite;
            }

            @keyframes floatText {
                0%, 100% {
                    transform: translateY(0);
                }
                50% {
                    transform: translateY(-10px);
                }
            }

            .about-hero-subtitle {
                font-size: 1.2rem;
                font-weight: 500;
                opacity: 0.9;
                max-width: 600px;
                margin: 0 auto;
            }

            /* --- 2. CONTENT SECTIONS --- */
            .section-padding {
                padding: 60px 0;
            }

            .text-highlight {
                color: var(--primary-color);
                font-weight: 600;
            }

            .about-heading {
                font-size: 2.2rem;
                font-weight: 700;
                color: var(--secondary-color);
                margin-bottom: 20px;
                position: relative;
                display: inline-block;
            }
            .about-heading::after {
                content: '';
                display: block;
                width: 60px;
                height: 3px;
                background: var(--primary-color);
                margin-top: 10px;
                transition: width 0.3s;
            }
            .about-heading:hover::after {
                width: 100%;
            }

            .about-desc {
                font-size: 1.05rem;
                line-height: 1.8;
                color: var(--text-muted);
                margin-bottom: 20px;
            }

            /* Image Styling with SHINE Effect */
            .about-img-frame {
                position: relative;
                border-radius: var(--card-radius);
                overflow: hidden;
                box-shadow: 0 15px 40px rgba(0,0,0,0.15);
                cursor: pointer;
            }
            .about-img-frame img {
                width: 100%;
                height: auto;
                transition: transform 0.8s ease;
            }
            /* Shine Animation Layer */
            .about-img-frame::before {
                position: absolute;
                top: 0;
                left: -75%;
                z-index: 2;
                display: block;
                content: '';
                width: 50%;
                height: 100%;
                background: linear-gradient(to right, rgba(255,255,255,0) 0%, rgba(255,255,255,0.3) 100%);
                transform: skewX(-25deg);
            }
            .about-img-frame:hover::before {
                animation: shine 0.75s;
            }
            .about-img-frame:hover img {
                transform: scale(1.08);
            }

            @keyframes shine {
                100% {
                    left: 125%;
                }
            }

            /* --- 3. STATS COUNTER --- */
            .stats-section {
                background-color: var(--secondary-color);
                color: #fff;
                padding: 60px 0;
                margin: 60px 0;
                background-image: linear-gradient(rgba(44, 62, 80, 0.9), rgba(44, 62, 80, 0.9)), url('${pageContext.request.contextPath}/images/pattern.png');
                background-attachment: fixed;
            }
            .stat-item {
                text-align: center;
                padding: 20px;
                border-right: 1px solid rgba(255,255,255,0.1);
            }
            .stat-item:last-child {
                border-right: none;
            }
            .stat-number {
                font-size: 3.5rem;
                font-weight: 700;
                color: var(--primary-color);
                display: block;
                margin-bottom: 5px;
            }
            .stat-label {
                font-size: 1rem;
                text-transform: uppercase;
                letter-spacing: 2px;
                opacity: 0.8;
                font-weight: 600;
            }

            /* --- 4. CORE VALUES (Updated with Circle Hover Effect) --- */
            .values-section {
                background-color: var(--bg-light);
                padding: 80px 0;
                margin-bottom: 60px;
            }

            .value-card {
                background: #fff;
                padding: 45px 30px;
                border-radius: var(--card-radius);
                text-align: center;
                transition: all 0.4s cubic-bezier(0.25, 0.8, 0.25, 1);
                border: 1px solid rgba(0,0,0,0.03);
                height: 100%;
                position: relative;
                z-index: 1;
            }

            /* Tạo khối tròn bao quanh icon */
            .value-icon-box {
                width: 90px;
                height: 90px;
                margin: 0 auto 25px auto;
                border-radius: 50%;
                background-color: #fff; /* Nền mặc định trắng */
                color: var(--primary-color); /* Icon mặc định nâu */
                border: 1px solid var(--primary-color); /* Viền mỏng màu nâu */

                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 2.2rem;

                transition: all 0.4s ease;
                position: relative;
            }

            /* Hiệu ứng khi di chuột vào Card */
            .value-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 20px 40px rgba(0,0,0,0.08);
                border-color: transparent;
            }

            /* Đổi màu ô tròn và icon khi Hover */
            .value-card:hover .value-icon-box {
                background-color: var(--primary-color); /* Nền chuyển nâu */
                color: #fff; /* Icon chuyển trắng */
                box-shadow: 0 0 0 8px rgba(160, 129, 108, 0.15); /* Hiệu ứng lan tỏa nhẹ (Ring) */
                transform: scale(1.1); /* Phóng to nhẹ vòng tròn */
            }

            .value-card:hover .value-icon-box i {
                animation: shakeIcon 0.4s ease; /* Icon lắc nhẹ khi chạm vào */
            }

            @keyframes shakeIcon {
                0% {
                    transform: rotate(0deg);
                }
                25% {
                    transform: rotate(-10deg);
                }
                75% {
                    transform: rotate(10deg);
                }
                100% {
                    transform: rotate(0deg);
                }
            }

            .value-title {
                font-size: 1.4rem;
                font-weight: 700;
                color: var(--secondary-color);
                margin-bottom: 15px;
            }
            .value-text {
                color: var(--text-muted);
                font-size: 0.95rem;
                line-height: 1.6;
            }

            /* --- 5. QUOTE SECTION --- */
            .quote-box {
                text-align: center;
                max-width: 800px;
                margin: 0 auto;
                font-style: italic;
                font-size: 1.3rem;
                color: var(--secondary-color);
                border-left: 4px solid var(--primary-color);
                padding-left: 20px;
                background: #fff;
                box-shadow: 0 5px 15px rgba(0,0,0,0.05);
                padding: 20px;
                border-radius: 0 10px 10px 0;
            }
            .quote-icon {
                font-size: 2rem;
                color: var(--primary-color);
                margin-bottom: 15px;
                display: block;
            }

            /* Back to Top Button */
            #btn-back-to-top {
                position: fixed;
                bottom: 30px;
                right: 30px;
                display: none;
                background-color: var(--primary-color);
                color: white;
                border: none;
                width: 50px;
                height: 50px;
                border-radius: 50%;
                font-size: 1.5rem;
                z-index: 100;
                cursor: pointer;
                box-shadow: 0 4px 10px rgba(0,0,0,0.3);
                transition: all 0.3s;
            }
            #btn-back-to-top:hover {
                background-color: var(--primary-color);
                transform: translateY(-5px);
            }

            /* Responsive Fixes */
            @media (max-width: 768px) {
                .about-hero {
                    height: 350px;
                }
                .about-hero-title {
                    font-size: 2.5rem;
                }
                .stat-item {
                    border-right: none;
                    border-bottom: 1px solid rgba(255,255,255,0.1);
                    padding-bottom: 30px;
                    margin-bottom: 10px;
                }
                .stat-item:last-child {
                    border-bottom: none;
                }
            }
        </style>
    </head>

    <body>

        <jsp:include page="header.jsp" />

        <section class="about-hero">
            <div class="about-hero-content" data-aos="fade-up">
                <h1 class="about-hero-title">About GIO</h1>
                <p class="about-hero-subtitle">Simplicity, Sophistication, and Timeless Style.</p>
            </div>
        </section>

        <main class="container">

            <section class="section-padding">
                <div class="row align-items-center g-5">
                    <div class="col-md-6" data-aos="fade-right">
                        <h2 class="about-heading">Our Story</h2>
                        <div class="about-desc">
                            <p>First of all, <span class="text-highlight">GIO</span> would like to sincerely thank you for your continued interest and follow-up over the years.</p>
                            <p>Developed from a small online store hidden in an alley in Can Tho City, starting with a modest inventory. We have expanded our scale by adding many new fashion items, always updating trends, and opening new sales channels through social media and e-commerce platforms.</p>
                            <p>We believe that fashion is not just about wearing clothes, but an expression of one's lifestyle.</p>
                        </div>
                    </div>
                    <div class="col-md-6" data-aos="fade-left">
                        <div class="about-img-frame">
                            <img src="https://theme.hstatic.net/1000296747/1000891809/14/gallery_item_1_img.jpg?v=55" alt="Our Story Image">
                        </div>
                    </div>
                </div>
            </section>

        </main>


        <main class="container">
            <section class="section-padding">
                <div class="row align-items-center g-5 flex-row-reverse">
                    <div class="col-md-6" data-aos="fade-left">
                        <h2 class="about-heading">Our Mission</h2>
                        <div class="about-desc">
                            <p><span class="text-highlight">GIO</span> strives to bring customers high-quality products at reasonable prices. The fashion pieces we select are guaranteed to be consistent in aesthetic style.</p>
                            <div class="quote-box py-3 my-4">
                                <i class="bi bi-quote quote-icon"></i>
                                <p class="mb-0">Bringing the unique color that shapes <span class="text-highlight">GIO</span>: <br><strong>Simplicity, Sophistication, and Harmony.</strong></p>
                            </div>
                            <p>We don't just follow trends; we focus on harmonious aesthetic elements and clothes that you can wear over and over again for many years to come, never going out of style.</p>
                        </div>
                    </div>
                    <div class="col-md-6" data-aos="fade-right">
                        <div class="about-img-frame">
                            <img src="https://theme.hstatic.net/1000296747/1000891809/14/gallery_item_3_img.jpg?v=55" alt="Our Mission Image">
                        </div>
                    </div>
                </div>
            </section>
        </main>

        <section class="values-section">
            <div class="container">
                <div class="text-center mb-5" data-aos="fade-up">
                    <span class="text-highlight text-uppercase fw-bold">Why Choose Us</span>
                    <h2 class="fw-bold mt-2" style="color: var(--secondary-color);">Our Core Values</h2>
                </div>

                <div class="row g-4">
                    <div class="col-md-4" data-aos="fade-up" data-aos-delay="100">
                        <div class="value-card">
                            <div class="value-icon-box">
                                <i class="bi bi-gem"></i>
                            </div>
                            <h5 class="value-title">Quality First</h5>
                            <p class="value-text">We select the finest materials to ensure every piece feels as good as it looks and lasts for years.</p>
                        </div>
                    </div>

                    <div class="col-md-4" data-aos="fade-up" data-aos-delay="200">
                        <div class="value-card">
                            <div class="value-icon-box">
                                <i class="bi bi-flower1"></i>
                            </div>
                            <h5 class="value-title">Simplicity & Style</h5>
                            <p class="value-text">Our designs are timeless. Minimalist aesthetic that brings out the sophistication in you.</p>
                        </div>
                    </div>

                    <div class="col-md-4" data-aos="fade-up" data-aos-delay="300">
                        <div class="value-card">
                            <div class="value-icon-box">
                                <i class="bi bi-heart"></i>
                            </div>
                            <h5 class="value-title">Customer Focus</h5>
                            <p class="value-text">Your satisfaction is our top priority. We are committed to providing the best shopping experience.</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <button type="button" class="btn" id="btn-back-to-top">
            <i class="bi bi-arrow-up"></i>
        </button>

        <jsp:include page="footer.jsp" />

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>

        <script>
            // Init AOS Animation
            AOS.init({
                duration: 800,
                once: true,
                offset: 50
            });

            // --- 1. NUMBER COUNTER ANIMATION ---
            const statsSection = document.querySelector('.stats-section');
            const counters = document.querySelectorAll('.stat-number');
            let started = false; // Flag to ensure animation runs only once

            function startCount(el) {
                const target = +el.getAttribute('data-target');
                const duration = 2000; // Animation runs for 2 seconds
                const step = target / (duration / 16); // 60fps

                let current = 0;
                const timer = setInterval(() => {
                    current += step;
                    if (current >= target) {
                        el.innerText = target + "+";
                        clearInterval(timer);
                    } else {
                        el.innerText = Math.ceil(current);
                    }
                }, 16);
            }

            const observer = new IntersectionObserver((entries) => {
                if (entries[0].isIntersecting && !started) {
                    counters.forEach(counter => startCount(counter));
                    started = true;
                }
            }, {threshold: 0.5}); // Start when 50% of section is visible

            if (statsSection) {
                observer.observe(statsSection);
            }

            // --- 2. BACK TO TOP BUTTON ---
            let mybutton = document.getElementById("btn-back-to-top");

            window.onscroll = function () {
                scrollFunction();
            };

            function scrollFunction() {
                if (document.body.scrollTop > 300 || document.documentElement.scrollTop > 300) {
                    mybutton.style.display = "block";
                } else {
                    mybutton.style.display = "none";
                }
            }

            mybutton.addEventListener("click", backToTop);

            function backToTop() {
                document.body.scrollTop = 0;
                document.documentElement.scrollTop = 0;
            }
        </script>

    </body>
</html>