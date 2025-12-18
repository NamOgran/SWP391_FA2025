<%-- 
    Document    : footer.jsp
    Description : Common footer for all customer pages
--%>
<%@ page pageEncoding="UTF-8" %>

<style>
    /* === FOOTER STYLES === */
    footer {
        background-color: #f5f5f5;
        padding-bottom: 0px;
        margin-top: 50px;
        /* ĐÃ SỬA: Thay viền xám mỏng thành đường nâu sữa dày 5px */
        border-top: 5px solid #b59a7c;
    }
    .content-footer {
        text-align: center;
        padding: 30px 0;
    }
    .content-footer h3 {
        margin-bottom: 5px;
        font-weight: 700;
        font-size: 1.5rem;
        color: #b59a7c; /* Màu nâu sữa */
    }
    .content-footer p {
        font-size: 1rem;
        color: #555;
        margin: 0;
    }

    /* Gallery Images */
    #img-footer {
        margin: 0 auto;
        max-width: 100%;
    }
    #img-footer img {
        padding: 0;
        width: 100%;
        height: 180px;
        object-fit: cover;
        transition: opacity 0.3s ease;
    }
    #img-footer img:hover {
        opacity: 0.8;
    }

    /* Footer Info Columns */
    .items-footer {
        margin: 40px 5% 40px 5%;
    }
    .items-footer h4 {
        color: #b59a7c; /* Màu nâu sữa */
        font-weight: 700;
        font-size: 1.1rem;
        margin-bottom: 15px;
        text-transform: uppercase;
    }
    .items-footer p, .items-footer li a {
        font-size: 0.9rem;
        color: #555;
        line-height: 1.6;
        margin-bottom: 8px;
    }
    .items-footer ul.CS {
        list-style: none;
        padding: 0;
        margin: 0;
    }
    .items-footer ul.CS li a {
        text-decoration: none;
        transition: color 0.2s;
    }
    .items-footer ul.CS li a:hover {
        color: #b59a7c;
        text-decoration: underline;
    }

    /* BCT Logo */
    .bct {
        max-width: 150px;
        margin-top: 10px;
    }

    /* Contact Info */
    .phone {
        display: flex;
        align-items: center;
        margin-bottom: 15px;
    }
    .phone .icon {
        font-size: 2rem;
        color: #b59a7c; /* Icon màu nâu sữa */
        margin-right: 10px;
    }
    .phone h4 {
        margin: 0;
        font-size: 1.2rem;
        color: #b59a7c; /* SĐT màu nâu sữa */
    }
    .phone a {
        text-decoration: none;
        color: #555;
        font-size: 0.9rem;
    }

    /* Social Icons */
    .items-footer h5 {
        font-size: 1rem;
        font-weight: 700;
        color: #b59a7c; /* Màu nâu sữa */
        margin-bottom: 10px;
        margin-top: 10px;
    }
    .contact-item {
        display: flex;
        gap: 10px;
    }
    .contact-link {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 35px;
        height: 35px;
        border: 1px solid #b59a7c;
        border-radius: 5px;
        color: #b59a7c;
        text-decoration: none;
        transition: all 0.3s ease;
    }
    .contact-link:hover {
        background-color: #b59a7c;
        color: #fff;
    }
    .contact-link i {
        font-size: 1.1rem;
    }

    /* Copyright Section */
    .footer-copyright {
        background-color: #b59a7c; /* Nền xám đậm */
        color: whitesmoke;
        font-size: 0.85rem;
        padding: 15px 0;
        margin-top: 20px;
    }
</style>

<footer>
    <div class="content-footer">
        <h3 id="highlight">Follow us on Instagram</h3>
        <p>@gio.vn & @fired.vn</p>
    </div>

    <div class="row g-0" id="img-footer">
        <div class="col-6 col-md-2"><img src="https://theme.hstatic.net/1000296747/1000891809/14/gallery_item_1_img.jpg?v=55" alt="Gallery 1"></div>
        <div class="col-6 col-md-2"><img src="https://theme.hstatic.net/1000296747/1000891809/14/gallery_item_2_img.jpg?v=55" alt="Gallery 2"></div>
        <div class="col-6 col-md-2"><img src="https://theme.hstatic.net/1000296747/1000891809/14/gallery_item_3_img.jpg?v=55" alt="Gallery 3"></div>
        <div class="col-6 col-md-2"><img src="https://theme.hstatic.net/1000296747/1000891809/14/gallery_item_4_img.jpg?v=55" alt="Gallery 4"></div>
        <div class="col-6 col-md-2"><img src="https://theme.hstatic.net/1000296747/1000891809/14/gallery_item_5_img.jpg?v=55" alt="Gallery 5"></div>
        <div class="col-6 col-md-2"><img src="https://theme.hstatic.net/1000296747/1000891809/14/gallery_item_6_img.jpg?v=55" alt="Gallery 6"></div>
    </div>

    <div class="items-footer">
        <div class="row">
            <div class="col-md-3 mb-4 mb-md-0">
                <h4>About GIO</h4>
                <p>Curate a refined and timeless wardrobe for both men and women, where classic vintage pieces meet essential basics.</p>
                <img src="//theme.hstatic.net/1000296747/1000891809/14/footer_logobct_img.png?v=55" alt="Bo Cong Thuong" class="bct">
            </div>
            <div class="col-md-3 mb-4 mb-md-0">
                <h4>Contact Us</h4>
                <p><b>Address:</b> 100 Nguyen Van Cu, An Khanh Ward, Ninh Kieu District, Can Tho City</p>
                <p><b>Phone:</b> 0123.456.789 - 0999.999.999</p>
                <p><b>Email:</b> info@gio.vn</p>
            </div>
            <div class="col-md-3 mb-4 mb-md-0">
                <h4>Customer Support</h4>
                <ul class="CS">
                    <li><a href="javascript:void(0)" onclick="openSearchDrawer()">Search</a></li>
                    <li><a href="${pageContext.request.contextPath}/aboutUs.jsp">Introduction</a></li>
                    <li><a href="${pageContext.request.contextPath}/policy.jsp">Exchange Policy</a></li>
                </ul>
            </div>
            <div class="col-md-3">
                <h4>Customer Care</h4>
                <div class="phone">
                    <i class="bi bi-telephone icon"></i>
                    <div>
                        <h4>0123.456.789</h4>
                        <a href="mailto:info@gio.vn">info@gio.vn</a>
                    </div>
                </div>
                <h5>Follow Us</h5>
                <div class="contact-item">
                    <a href="#" class="contact-link" aria-label="Facebook"><i class="bi bi-facebook"></i></a>
                    <a href="#" class="contact-link" aria-label="Instagram"><i class="bi bi-instagram"></i></a>
                </div>
            </div>
        </div>
    </div>

    <div class="text-center footer-copyright w-100">
        &copy; 2025 GIO Shop. All rights reserved.
    </div>
</footer>