<%-- 
    Document    : policy.jsp
    Updated     : Modern UI, Parallax Hero, AOS Animation, Card Layout
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Exchange Policy | GIO</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

        <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">

        <link href='https://fonts.googleapis.com/css?family=Quicksand:300,400,500,600,700&display=swap' rel='stylesheet'>
        <link rel="icon" href="${pageContext.request.contextPath}/images/LG2.png" type="image/x-icon">

        <style>
            /* === GLOBAL VARIABLES (Synced with About Us) === */
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

            body {
                font-family: 'Quicksand', sans-serif;
                color: var(--text-dark);
                background-color: #fff;
                overflow-x: hidden;
            }

            /* --- 1. HERO BANNER --- */
            .policy-hero {
                position: relative;
                height: 400px;
                /* Sử dụng ảnh banner giống About Us hoặc ảnh Gallery 5 làm nền */
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
            .policy-hero::before {
                content: '';
                position: absolute;
                inset: 0;
                background: rgba(0,0,0,0.5); /* Lớp phủ tối hơn để chữ rõ hơn */
            }
            .policy-hero-content {
                position: relative;
                z-index: 2;
                text-align: center;
            }
            .policy-hero-title {
                font-size: 3.5rem;
                font-weight: 700;
                margin-bottom: 15px;
                letter-spacing: 2px;
            }
            .policy-hero-subtitle {
                font-size: 1.2rem;
                font-weight: 500;
                opacity: 0.9;
            }

            /* --- 2. POLICY CARDS --- */
            .section-padding {
                padding: 40px 0 80px 0;
            }

            .policy-card {
                background: #fff;
                padding: 40px;
                border-radius: var(--card-radius);
                box-shadow: 0 10px 30px rgba(0,0,0,0.05);
                height: 100%;
                border: 1px solid rgba(0,0,0,0.05);
                transition: var(--transition-smooth);
                position: relative;
                overflow: hidden;
            }
            .policy-card:hover {
                transform: translateY(-10px);
                box-shadow: 0 20px 40px rgba(0,0,0,0.1);
                border-color: rgba(160, 129, 108, 0.3);
            }

            /* Icon tròn phía trên card (giống Core Values) */
            .card-icon-box {
                width: 70px;
                height: 70px;
                background-color: var(--bg-light);
                color: var(--primary-color);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.8rem;
                margin-bottom: 25px;
                transition: var(--transition-smooth);
            }
            .policy-card:hover .card-icon-box {
                background-color: var(--primary-color);
                color: #fff;
                transform: scale(1.1);
            }

            .card-title {
                font-size: 1.5rem;
                font-weight: 700;
                color: var(--secondary-color);
                margin-bottom: 20px;
                padding-bottom: 15px;
                border-bottom: 2px solid var(--bg-light);
            }

            /* Custom List Styling */
            .custom-list {
                list-style: none;
                padding-left: 0;
            }
            .custom-list li {
                position: relative;
                padding-left: 30px;
                margin-bottom: 15px;
                font-size: 1rem;
                color: var(--text-muted);
                line-height: 1.6;
            }
            .custom-list li::before {
                content: '\F26A'; /* Bootstrap Icon Check code */
                font-family: 'bootstrap-icons';
                position: absolute;
                left: 0;
                top: 2px;
                color: var(--primary-color);
                font-weight: bold;
            }

            /* --- 3. ADDRESS BOX --- */
            .address-box {
                background-color: var(--secondary-color);
                color: #fff;
                padding: 40px;
                border-radius: var(--card-radius);
                margin-top: 40px;
                position: relative;
                overflow: hidden;
            }
            .address-box::after {
                content: '\F1E0'; /* Icon map */
                font-family: 'bootstrap-icons';
                position: absolute;
                right: -20px;
                bottom: -30px;
                font-size: 10rem;
                opacity: 0.1;
                transform: rotate(-20deg);
            }
            .address-title {
                color: var(--primary-color);
                font-weight: 700;
                margin-bottom: 20px;
            }
            .address-detail {
                font-size: 1.1rem;
                margin-bottom: 10px;
                display: flex;
                align-items: start;
                gap: 10px;
            }
            .address-detail i {
                color: var(--primary-color);
                margin-top: 4px;
            }

            /* Responsive */
            @media (max-width: 768px) {
                .policy-hero {
                    height: 300px;
                }
                .policy-hero-title {
                    font-size: 2.5rem;
                }
                .policy-card {
                    padding: 30px 20px;
                }
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
        </style>
    </head>

    <body>

        <%-- === HEADER === --%>
        <jsp:include page="header.jsp" />

        <section class="policy-hero">
            <div class="policy-hero-content" data-aos="fade-up">
                <h1 class="policy-hero-title">Exchange Policy</h1>
                <p class="policy-hero-subtitle">Simple, Transparent, and Customer-Centric.</p>
            </div>
        </section>

        <main class="container section-padding">

            <div class="row g-4 justify-content-center">

                <div class="col-lg-6" data-aos="fade-right" data-aos-delay="100">
                    <div class="policy-card">
                        <div class="card-icon-box">
                            <i class="bi bi-shop-window"></i>
                        </div>
                        <h3 class="card-title">In-Store Purchase</h3>
                        <ul class="custom-list">
                            <li><strong>Deadline:</strong> Exchange within 2 days of purchase.</li>
                            <li><strong>Condition:</strong> Products must have original tags attached.</li>
                            <li>Items must be unwashed, unused, and in original condition.</li>
                            <li>Please bring your receipt for faster processing.</li>
                        </ul>
                    </div>
                </div>

                <div class="col-lg-6" data-aos="fade-left" data-aos-delay="200">
                    <div class="policy-card">
                        <div class="card-icon-box">
                            <i class="bi bi-box-seam"></i>
                        </div>
                        <h3 class="card-title">Online Orders</h3>
                        <ul class="custom-list">
                            <li><strong>Deadline:</strong> Exchange within 5 days from the date of receipt (based on delivery carrier timestamp).</li>
                            <li><strong>Condition:</strong> Tags intact, unwashed, and unused.</li>
                            <li><strong>Fees:</strong> Customers cover all shipping costs incurred.</li>
                            <li><strong>Note:</strong> We do not accept returns for refunds; exchange only.</li>
                            <li>Please order the new item on our website (New order value >= Exchange order value).</li>
                        </ul>
                    </div>
                </div>
            </div>

            <div class="row justify-content-center" data-aos="zoom-in" data-aos-delay="300">
                <div class="col-lg-10">
                    <div class="address-box">
                        <div class="row align-items-center">
                            <div class="col-md-8">
                                <h4 class="address-title">Where to send your return?</h4>
                                <p class="mb-3 opacity-75">Please send the products you wish to exchange to our main warehouse:</p>
                                <div class="address-detail">
                                    <i class="bi bi-geo-alt-fill"></i>
                                    <span>100 Nguyen Van Cu, An Khanh Ward, Ninh Kieu District, Can Tho City.</span>
                                </div>
                                <div class="address-detail">
                                    <i class="bi bi-telephone-fill"></i>
                                    <span>0123.456.789 - 0999.999.999</span>
                                </div>
                            </div>
                            <div class="col-md-4 text-center d-none d-md-block">
                                <i class="bi bi-box2-heart" style="font-size: 5rem; color: rgba(255,255,255,0.2);"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </main>

        <button type="button" class="btn" id="btn-back-to-top">
            <i class="bi bi-arrow-up"></i>
        </button>
        <%-- === FOOTER === --%>
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