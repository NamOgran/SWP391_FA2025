<%-- 
    Document    : contact.jsp
    Updated     : Modern UI Overhaul + Parallax Hero + AOS Animation
--%>

<%@page import="java.text.NumberFormat"%>
<%@page import="java.text.DecimalFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

        <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">

        <link href='https://fonts.googleapis.com/css?family=Quicksand:300,400,500,600,700&display=swap' rel='stylesheet'> 
        <link rel="icon" href="${pageContext.request.contextPath}/images/LG2.png" type="image/x-icon">

        <title>Contact Us | GIO</title>

        <style>
            :root {
                --primary-color: #a0816c;
                --primary-hover: #8a6d5a;
                --secondary-color: #2c3e50;
                --bg-light: #f8f9fa;
                --text-dark: #333;
                --text-muted: #666;
                --card-radius: 15px;
                --shadow-soft: 0 10px 30px rgba(0, 0, 0, 0.05);
            }

            body {
                font-family: 'Quicksand', sans-serif;
                background-color: #fff;
                color: var(--text-dark);
                overflow-x: hidden;
            }

            /* --- HERO BANNER --- */
            .contact-hero {
                position: relative;
                height: 400px;
                background-image: url('https://theme.hstatic.net/1000296747/1000891809/14/gallery_item_4_img.jpg?v=55');
                background-size: cover;
                background-position: center;
                background-attachment: fixed; /* Parallax */
                display: flex;
                align-items: center;
                justify-content: center;
                color: #fff;
                margin-bottom: 60px;
            }
            .contact-hero::before {
                content: '';
                position: absolute;
                inset: 0;
                background: rgba(0,0,0,0.5); /* Overlay tối */
            }
            .hero-content {
                position: relative;
                z-index: 2;
                text-align: center;
            }
            .hero-title {
                font-size: 3rem;
                font-weight: 700;
                letter-spacing: 1px;
                margin-bottom: 10px;
            }
            .hero-subtitle {
                font-size: 1.1rem;
                opacity: 0.9;
                font-weight: 400;
            }

            /* --- CONTACT INFO CARDS --- */
            .info-card {
                background: #fff;
                padding: 30px;
                border-radius: var(--card-radius);
                box-shadow: var(--shadow-soft);
                height: 100%;
                transition: transform 0.3s ease;
                border: 1px solid #eee;
            }
            .info-card:hover {
                transform: translateY(-5px);
                border-color: var(--primary-color);
            }

            .info-item {
                display: flex;
                align-items: flex-start;
                margin-bottom: 30px;
            }
            .info-item:last-child {
                margin-bottom: 0;
            }

            .icon-box {
                width: 50px;
                height: 50px;
                min-width: 50px;
                background-color: rgba(160, 129, 108, 0.1);
                color: var(--primary-color);
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.4rem;
                margin-right: 20px;
                transition: all 0.3s ease;
            }
            .info-item:hover .icon-box {
                background-color: var(--primary-color);
                color: #fff;

            }

            .info-content h5 {
                font-size: 1.1rem;
                font-weight: 700;
                color: var(--secondary-color);
                margin-bottom: 5px;
            }
            .info-content p {
                color: var(--text-muted);
                font-size: 0.95rem;
                margin: 0;
                line-height: 1.6;
            }

            /* --- CONTACT FORM --- */
            .form-card {
                background: #fff;
                padding: 40px;
                border-radius: var(--card-radius);
                box-shadow: var(--shadow-soft);
                border: 1px solid #eee;
            }
            .section-title {
                font-size: 1.8rem;
                font-weight: 700;
                color: var(--secondary-color);
                margin-bottom: 10px;
            }
            .section-desc {
                color: var(--text-muted);
                margin-bottom: 30px;
            }

            .form-control {
                height: 55px;
                padding: 10px 20px;
                border-radius: 10px;
                border: 1px solid #e0e0e0;
                background-color: #fcfcfc;
                font-size: 0.95rem;
                transition: all 0.3s;
            }
            textarea.form-control {
                height: auto !important;
                padding-top: 15px;
            }
            .form-control:focus {
                background-color: #fff;
                border-color: var(--primary-color);
                box-shadow: 0 0 0 4px rgba(160, 129, 108, 0.1);
            }

            .btn-submit {
                background-color: var(--primary-color);
                color: #fff;
                font-weight: 600;
                padding: 15px 40px;
                border-radius: 30px;
                border: none;
                text-transform: uppercase;
                letter-spacing: 1px;
                transition: all 0.3s;
                width: 100%;
            }
            .btn-submit:hover {
                background-color: var(--secondary-color);
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            }

            /* --- MAP SECTION --- */
            .map-wrapper {
                margin-top: 80px;
                border-radius: var(--card-radius);
                overflow: hidden;
                box-shadow: var(--shadow-soft);
                height: 450px;
                position: relative;
            }
            .map-wrapper iframe {
                width: 100%;
                height: 100%;
                border: 0;
            }

            /* Responsive */
            @media (max-width: 768px) {
                .contact-hero {
                    height: 250px;
                }
                .hero-title {
                    font-size: 2rem;
                }
                .form-card, .info-card {
                    padding: 25px;
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

        <section class="contact-hero">
            <div class="hero-content" data-aos="fade-up">
                <h1 class="hero-title">Contact Us</h1>
                <p class="hero-subtitle">We'd love to hear from you. Get in touch today!</p>
            </div>
        </section>

        <main class="container mb-5">
            <div class="row g-5">

                <div class="col-lg-4" data-aos="fade-right" data-aos-delay="100">
                    <div class="info-card">
                        <h3 class="section-title mb-4">Get In Touch</h3>

                        <div class="info-item">
                            <div class="icon-box">
                                <i class="bi bi-geo-alt-fill"></i>
                            </div>
                            <div class="info-content">
                                <h5>Address</h5>
                                <p>100 Nguyen Van Cu, An Khanh Ward, Ninh Kieu District, Can Tho City.</p>
                            </div>
                        </div>

                        <div class="info-item">
                            <div class="icon-box">
                                <i class="bi bi-envelope-fill"></i>
                            </div>
                            <div class="info-content">
                                <h5>Email</h5>
                                <p>info@gio.vn</p>
                                <p>support@gio.vn</p>
                            </div>
                        </div>

                        <div class="info-item">
                            <div class="icon-box">
                                <i class="bi bi-telephone-fill"></i>
                            </div>
                            <div class="info-content">
                                <h5>Phone</h5>
                                <p>0123.456.789</p>
                                <p>0999.999.999</p>
                            </div>
                        </div>

                        <div class="info-item">
                            <div class="icon-box">
                                <i class="bi bi-clock-fill"></i>
                            </div>
                            <div class="info-content">
                                <h5>Working Hours</h5>
                                <p>Mon - Sun: 8:00 AM - 10:00 PM</p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-8" data-aos="fade-left" data-aos-delay="200">
                    <div class="form-card">
                        <h3 class="section-title">Send us a Message</h3>
                        <p class="section-desc">Have a question or feedback? Fill out the form below and we'll get back to you shortly.</p>

                        <form action="">
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold small text-muted">Your Name</label>
                                    <input type="text" class="form-control" id="contactName" placeholder="e.g. John Doe">
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold small text-muted">Your Email</label>
                                    <input type="email" class="form-control" id="contactEmail" placeholder="e.g. john@example.com">
                                </div>
                                <div class="col-12">
                                    <label class="form-label fw-bold small text-muted">Phone Number</label>
                                    <input type="tel" class="form-control" id="contactPhone" placeholder="Your phone number">
                                </div>
                                <div class="col-12">
                                    <label class="form-label fw-bold small text-muted">Message</label>
                                    <textarea class="form-control" id="contactContent" rows="5" placeholder="Write your message here..."></textarea>
                                </div>
                                <div class="col-12 mt-4">
                                    <button type="submit" class="btn-submit">
                                        Send Message <i class="bi bi-send-fill ms-2"></i>
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

            </div>

            <div class="map-wrapper">
                <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3928.841518408643!2d105.76842661533965!3d10.029933692830616!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31a0895a51d60719%3A0x9d76b0035f6d53d0!2sCan%20Tho%20University!5e0!3m2!1sen!2s!4v1677645123456!5m2!1sen!2s" 
                        allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade">
                </iframe>
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

        <script type="text/javascript">
            // Init AOS
            AOS.init({
                duration: 800,
                once: true,
                offset: 100
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