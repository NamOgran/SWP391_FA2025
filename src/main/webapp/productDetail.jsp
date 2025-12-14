<%-- 
    Document    : productDetail.jsp
    Description : Upgraded UI with Animations & Micro-interactions
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.text.DecimalFormat"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-iYQeCzEYFbKjA/T2uDLTpkwGzCiq6soy8tYaI1GyVh/UjpbCx/TYkiZhlZB6+fzT" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <link href='https://fonts.googleapis.com/css?family=Quicksand:300,400,500,600,700&display=swap' rel='stylesheet'>
        <link rel="icon" href="${pageContext.request.contextPath}/images/LG2.png" type="image/x-icon">
        <title>${p.name} | GIO</title>

        <style>
            /* === CORE VARIABLES === */
            :root {
                --primary-color: #a0816c;
                --primary-hover: #8a6d5a;
                --text-dark: #2d2d2d;
                --text-gray: #6c757d;
                --border-color: #e5e5e5;
                --bg-light: #f8f9fa;
                --sale-color: #d70000;
                --shadow-soft: 0 10px 30px rgba(0,0,0,0.05);
                --shadow-hover: 0 15px 35px rgba(0,0,0,0.1);
            }

            * { margin: 0; padding: 0; font-family: 'Quicksand', sans-serif; box-sizing: border-box; }
            body { background-color: #fff; color: var(--text-dark); overflow-x: hidden; }
            img { max-width: 100%; display: block; }
            a { text-decoration: none; color: inherit; transition: color 0.3s; }

            /* === ANIMATIONS (KEYFRAMES) === */
            @keyframes fadeInUp {
                from { opacity: 0; transform: translateY(30px); }
                to { opacity: 1; transform: translateY(0); }
            }

            @keyframes fadeInScale {
                from { opacity: 0; transform: scale(0.95); }
                to { opacity: 1; transform: scale(1); }
            }

            /* Utility Classes for Animation */
            .reveal-element { opacity: 0; animation-fill-mode: forwards; /* Giữ trạng thái cuối cùng */ }
            .animate-up { animation: fadeInUp 0.8s cubic-bezier(0.2, 0.8, 0.2, 1) forwards; }
            .animate-scale { animation: fadeInScale 0.8s ease-out forwards; }

            /* Stagger Delays (Trễ nhịp để tạo hiệu ứng domino) */
            .delay-100 { animation-delay: 0.1s; }
            .delay-200 { animation-delay: 0.2s; }
            .delay-300 { animation-delay: 0.3s; }
            .delay-400 { animation-delay: 0.4s; }
            .delay-500 { animation-delay: 0.5s; }

            /* === LAYOUT === */
            .product-detail-wrapper {
                max-width: 1200px;
                margin: 40px auto 80px;
                padding: 0 20px;
            }

            /* Image Section */
            .col-sticky-image { position: sticky; top: 20px; align-self: start; z-index: 10; }
            .product-image-container { 
                position: relative;
                border-radius: 16px; 
                overflow: hidden; 
                box-shadow: var(--shadow-soft); 
                border: 1px solid #f0f0f0; 
                background: #fff;
                /* --- CODE MỚI THÊM VÀO --- */
                max-width: 400px; /* Giới hạn chiều rộng tối đa (bạn có thể chỉnh số này nhỏ hơn nếu muốn) */
                width: 100%;
                margin: 0 auto;   /* Căn giữa khung ảnh trong cột */
            }
            .product-image-container img { 
                width: 100%; 
                height: auto; 
                object-fit: cover; 
                transition: transform 0.7s cubic-bezier(0.2, 0.8, 0.2, 1); /* Smooth zoom */
            }

            /* Info Section */
            .product-info-wrapper { padding-left: 30px; }
            .product-title { font-size: 2.2rem; font-weight: 700; color: var(--text-dark); line-height: 1.2; margin-bottom: 10px; }
            .product-sku { font-size: 0.9rem; color: var(--text-gray); margin-bottom: 20px; letter-spacing: 1px; font-weight: 500; }

            /* Price */
            .price-wrapper { display: flex; align-items: center; gap: 15px; margin-bottom: 30px; padding-bottom: 20px; border-bottom: 1px solid var(--border-color); }
            .current-price { font-size: 2rem; font-weight: 700; color: var(--sale-color); }
            .old-price { font-size: 1.2rem; color: #aaa; text-decoration: line-through; }
            .discount-badge { 
                background-color: rgba(215, 0, 0, 0.1); color: var(--sale-color); 
                font-size: 0.85rem; font-weight: 700; padding: 6px 12px; border-radius: 30px; 
            }

            /* Selectors */
            .selector-label { font-size: 0.95rem; font-weight: 700; color: var(--text-dark); margin-bottom: 12px; display: block; }
            
            .size-selector { display: flex; flex-wrap: wrap; gap: 12px; margin-bottom: 30px; }
            .size-option-radio { display: none; }
            .size-option-label {
                min-width: 50px; height: 50px; padding: 0 15px; display: flex; align-items: center; justify-content: center;
                border: 1px solid #e0e0e0; border-radius: 10px; background: #fff; font-weight: 600; color: var(--text-dark); 
                cursor: pointer; transition: all 0.2s ease; user-select: none;
            }
            .size-option-label:hover { border-color: var(--primary-color); transform: translateY(-2px); box-shadow: 0 4px 8px rgba(0,0,0,0.05); }
            .size-option-radio:checked + .size-option-label { 
                background-color: var(--primary-color); color: #fff; border-color: var(--primary-color); 
                box-shadow: 0 5px 15px rgba(160, 129, 108, 0.4); transform: translateY(-1px);
            }
            .size-option-radio:disabled + .size-option-label { 
                background-color: #f8f9fa; color: #ccc; cursor: not-allowed; border-color: #f0f0f0; transform: none; box-shadow: none;
            }

            /* Quantity */
            .quantity-stock-wrapper { margin-bottom: 35px; }
            .quantity-control { 
                display: flex; align-items: center; 
                border: 1px solid #ddd; border-radius: 10px; 
                width: 150px; height: 50px; overflow: hidden; 
                transition: all 0.3s ease; background: #fff;
            }
            .quantity-control:hover:not(.disabled) { border-color: var(--primary-color); }
            .quantity-control.disabled { background-color: #f5f5f5; opacity: 0.6; pointer-events: none; border-color: #eee; }

            .quantity-btn { width: 45px; height: 100%; border: none; background: #fff; font-size: 1.2rem; cursor: pointer; color: var(--text-dark); transition: background 0.2s; }
            .quantity-btn:hover { background: #f8f9fa; color: var(--primary-color); }
            
            .quantity-input { 
                flex: 1; border: none; text-align: center; font-weight: 600; font-size: 1.1rem; color: var(--text-dark); background: transparent;
                -moz-appearance: textfield;
            }
            .quantity-input:focus { outline: none; }
            
            .stock-status { display: inline-block; margin-left: 8px; font-size: 0.9rem; font-weight: 600; transition: color 0.3s; }
            .stock-available { color: #27ae60; }
            .stock-out { color: var(--sale-color); font-style: italic; }

            /* Action Buttons */
            .action-buttons { display: flex; gap: 20px; margin-bottom: 40px; }
            .btn-action {
                /* --- ĐÃ XÓA flex: 1 --- */
                display: inline-flex; /* Thay đổi từ flex sang inline-flex hoặc giữ flex nhưng bỏ flex:1 */
                min-width: 200px;     /* Đặt chiều rộng tối thiểu để nút trông vẫn đẹp, không quá ngắn */
                padding: 16px 24px;   /* Chỉnh lại padding */
                border-radius: 50px; 
                font-weight: 700; 
                font-size: 1rem; 
                text-transform: uppercase; 
                letter-spacing: 0.5px;
                transition: all 0.3s cubic-bezier(0.2, 0.8, 0.2, 1);
                align-items: center; 
                justify-content: center; 
                gap: 10px; 
                cursor: pointer;
                position: relative; 
                overflow: hidden;
            }
            
            /* Add to Cart */
            .btn-add-cart { background: #fff; border: 2px solid var(--text-dark); color: var(--text-dark); }
            .btn-add-cart:hover { background: var(--text-dark); color: #fff; transform: translateY(-4px); box-shadow: 0 10px 20px rgba(45, 45, 45, 0.2); }
            .btn-add-cart:active { transform: translateY(-1px); }

            /* Buy Now */
            .btn-buy-now { background: var(--primary-color); border: 2px solid var(--primary-color); color: #fff; box-shadow: 0 8px 20px rgba(160, 129, 108, 0.3); }
            .btn-buy-now:hover { background: var(--primary-hover); border-color: var(--primary-hover); transform: translateY(-4px); box-shadow: 0 12px 25px rgba(160, 129, 108, 0.4); }
            .btn-buy-now:active { transform: translateY(-1px); }
            
            .btn-action:disabled { opacity: 0.6; cursor: not-allowed; transform: none !important; box-shadow: none !important; }

            /* Accordion */
            .accordion-item { border-bottom: 1px solid var(--border-color); overflow: hidden; }
            .accordion-header { padding: 20px 0; cursor: pointer; display: flex; justify-content: space-between; align-items: center; transition: color 0.3s ease; }
            .accordion-header h6 { margin: 0; font-weight: 700; font-size: 1.05rem; color: var(--text-dark); }
            .accordion-header .icon { font-size: 0.9rem; transition: transform 0.4s cubic-bezier(0.4, 0, 0.2, 1); color: var(--text-gray); }
            
            .accordion-content { max-height: 0; opacity: 0; overflow: hidden; transition: max-height 0.4s cubic-bezier(0.4, 0, 0.2, 1), opacity 0.4s ease; color: var(--text-gray); font-size: 0.95rem; line-height: 1.7; }
            .accordion-content p { padding-bottom: 20px; }
            .accordion-content img { margin-top: 10px; border-radius: 12px; border: 1px solid #eee; margin-bottom: 20px; box-shadow: 0 4px 10px rgba(0,0,0,0.03); }
            
            .accordion-item.active .accordion-header h6 { color: var(--primary-color); }
            .accordion-item.active .accordion-content { opacity: 1; }
            .accordion-item.active .accordion-header .icon { transform: rotate(180deg); color: var(--primary-color); }

            /* Reviews Section (Scroll Animation Target) */
            .reviews-section { 
                margin-top: 80px; padding-top: 50px; border-top: 1px solid var(--border-color); 
                opacity: 0; transform: translateY(50px); transition: all 1s ease-out; /* Hidden initially */
            }
            .reviews-section.visible { opacity: 1; transform: translateY(0); }

            .reviews-title { text-align: center; font-weight: 700; font-size: 2rem; margin-bottom: 50px; color: var(--text-dark); position: relative; display: inline-block; left: 50%; transform: translateX(-50%); }
            .reviews-title::after { content: ''; position: absolute; bottom: -10px; left: 50%; transform: translateX(-50%); width: 60px; height: 3px; background: var(--primary-color); border-radius: 2px; }

            .review-summary-card { 
                border: none; border-radius: 16px; padding: 40px 20px; text-align: center; background: #fff; 
                box-shadow: var(--shadow-soft); height: 100%; display: flex; flex-direction: column; justify-content: center; align-items: center; 
                transition: transform 0.3s;
            }
            .review-summary-card:hover { transform: translateY(-5px); box-shadow: var(--shadow-hover); }

            .rating-number { font-size: 4.5rem; font-weight: 700; color: var(--text-dark); line-height: 1; margin-bottom: 15px; }
            .rating-stars { font-size: 1.6rem; color: #f1c40f; margin-bottom: 15px; letter-spacing: 2px; }
            /* Thêm vào phần style trên đầu trang */
.review-item-stars {
    color: #f1c40f; /* Màu vàng */
    font-size: 1rem; /* Chỉnh lại kích thước nếu cần */
}
            
            .review-card-item { 
                background: #fff; border-radius: 12px; padding: 25px; margin-bottom: 20px; border: 1px solid #f0f0f0; 
                box-shadow: 0 4px 10px rgba(0,0,0,0.02); transition: all 0.3s ease;
            }
            .review-card-item:hover { border-color: var(--primary-color); box-shadow: 0 8px 20px rgba(0,0,0,0.05); }
            
            .review-card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; }
            .review-user-name { font-weight: 700; color: var(--text-dark); font-size: 1.1rem; }
            
            /* No reviews */
            .no-reviews-container { text-align: center; padding: 60px; background: #f8f9fa; border-radius: 16px; border: 1px dashed #d1d1d1; }
            .no-reviews-icon { font-size: 3.5rem; color: #ccc; margin-bottom: 20px; display: block; }

            /* Modern Glassmorphism Popup */
            .stock-popup { 
                position: fixed; top: 30px; right: 30px; /* Top Right */
                padding: 15px 30px; 
                background: rgba(30, 30, 30, 0.85); /* Semi-transparent black */
                backdrop-filter: blur(10px); -webkit-backdrop-filter: blur(10px); /* Blur background */
                color: #fff; border-radius: 12px; 
                font-size: 0.95rem; font-weight: 500; 
                box-shadow: 0 15px 40px rgba(0,0,0,0.25); 
                opacity: 0; transform: translateX(50px); pointer-events: none; 
                transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275); 
                z-index: 10000; border: 1px solid rgba(255,255,255,0.1);
                display: flex; align-items: center; gap: 10px;
            }
            .stock-popup::before { content: '\F332'; font-family: "bootstrap-icons"; font-size: 1.2rem; } /* Info Icon */
            .stock-popup.show { opacity: 1; transform: translateX(0); }
            .stock-popup.success::before { content: '\F26A'; color: #2ecc71; } /* Check circle */
            .stock-popup.error::before { content: '\F332'; color: #e74c3c; } /* Exclamation circle */

            @media (max-width: 992px) { 
                .col-sticky-image { position: static; } 
                .product-info-wrapper { padding-left: 0; margin-top: 40px; } 
                .product-title { font-size: 1.8rem; }
            }
        </style>
    </head>

    <body>
        <%@ include file="header.jsp" %>

        <main class="product-detail-wrapper">
            <form action="cartInsert" method="get" id="productForm">
                <div class="row align-items-start"> 
                    <div class="col-lg-6 mb-4 col-sticky-image reveal-element animate-scale">
                        <div class="product-image-container">
                            <img src="${p.picURL}" alt="${p.name}">
                        </div>
                    </div>

                    <div class="col-lg-6">
                        <div class="product-info-wrapper">
                            <h1 class="product-title reveal-element animate-up delay-100">${p.name}</h1>
                            <div class="product-sku reveal-element animate-up delay-100">SKU: ${p.id}</div>

                            <c:set var="formattedPrice2"><fmt:formatNumber type="number" value="${p.price}" pattern="###,###" /></c:set>
                            <c:set var="formattedPrice"><fmt:formatNumber type="number" value="${p.price - ((p.price * voucherMap[p.voucherID])/100)}" pattern="###,###" /></c:set>

                            <div class="price-wrapper reveal-element animate-up delay-200">
                                <span class="current-price">${formattedPrice} VND</span>
                                <c:if test="${voucherMap[p.voucherID] > 0}">
                                    <span class="old-price">${formattedPrice2} VND</span>
                                    <span class="discount-badge">-${voucherMap[p.voucherID]}%</span>
                                </c:if>
                            </div>

                            <div class="reveal-element animate-up delay-300">
    <label class="selector-label">Select Size:</label>
    <div class="size-selector">
        <%-- 1. Tạo biến quy định thứ tự mong muốn --%>
        <c:set var="sizeOrder" value="S,M,L" />

        <%-- 2. Lặp qua danh sách thứ tự (S trước, rồi đến M, L...) --%>
        <c:forEach items="${fn:split(sizeOrder, ',')}" var="targetSize">
            
            <%-- 3. Quét trong sizeList xem có size này không --%>
            <c:forEach items="${sizeList}" var="s">
                <%-- Nếu tên size trong DB khớp với tên size đang lặp --%>
                <c:if test="${s.size_name eq targetSize}">
                    <div class="size-option-item">
                        <input type="radio" id="size${s.size_name}" name="size" value="${s.size_name}" class="size-option-radio" data-stock="${s.quantity}">
                        <label for="size${s.size_name}" class="size-option-label">${s.size_name}</label>
                    </div>
                </c:if>
            </c:forEach>
            
        </c:forEach>
    </div>
</div>

                            <div class="quantity-stock-wrapper reveal-element animate-up delay-300">
                                <label class="selector-label">Quantity: <span id="stock-display" class="stock-status"></span></label>
                                <div class="quantity-control" id="qtyControl">
                                    <button id="decrementButton" type="button" class="quantity-btn"><i class="bi bi-dash"></i></button>
<input type="number" id="quantityInput" name="quantity" value="1" min="1" 
       class="quantity-input" readonly>
                                    <button id="incrementButton" type="button" class="quantity-btn"><i class="bi bi-plus"></i></button>
                                </div>
                            </div>

                            <div class="action-buttons reveal-element animate-up delay-400">
                                <button id="check" type="button" class="btn-action btn-add-cart">
                                    <i class="bi bi-cart-plus" style="font-size: 1.2rem;"></i> Add to Cart
                                </button>
                                <button type="submit" formaction="productBuy" name="id" value="${p.id}" class="btn-action btn-buy-now">Buy Now</button>
                            </div>

                            <div class="product-accordion reveal-element animate-up delay-500">
                                <div class="accordion-item active"> 
                                    <div class="accordion-header" onclick="toggleAccordion(this)">
                                        <h6>Description</h6>
                                        <i class="icon bi bi-chevron-down"></i>
                                    </div>
                                    <div class="accordion-content" style="display: block;">
                                        <p>${p.description}</p>
                                    </div>
                                </div>
                                <div class="accordion-item">
                                    <div class="accordion-header" onclick="toggleAccordion(this)">
                                        <h6>Size Guide</h6>
                                        <i class="icon bi bi-chevron-down"></i>
                                    </div>
                                    <div class="accordion-content">
                                        <div class="mb-2"><b>1) Men's T-shirt:</b></div>
                                        <img src="${pageContext.request.contextPath}/images/male-tshirt-size.jpg" alt="Size Chart">
                                        <div class="my-2"><b>2) Men's Shorts:</b></div>
                                        <img src="${pageContext.request.contextPath}/images/male-short-size.jpg" alt="Size Chart">
                                        <div class="my-2"><b>3) Men's Pants:</b></div>
                                        <img src="${pageContext.request.contextPath}/images/male-pant-size.jpg" alt="Size Chart">
                                        <div class="my-2"><b>4) Women's T-shirt:</b></div>
                                        <img src="${pageContext.request.contextPath}/images/female-tshirt-size.jpg" alt="Size Chart">
                                        <div class="my-2"><b>5) Women's Pants:</b></div>
                                        <img src="${pageContext.request.contextPath}/images/female-pant-size.jpg" alt="Size Chart">
                                        <div class="my-2"><b>6) Women's Dress:</b></div>
                                        <img src="${pageContext.request.contextPath}/images/female-dress-size2.jpg" alt="Size Chart">
                                    </div>
                                </div>
                                <div class="accordion-item">
                                    <div class="accordion-header" onclick="toggleAccordion(this)">
                                        <h6>Shipping & Returns</h6>
                                        <i class="icon bi bi-chevron-down"></i>
                                    </div>
                                    <div class="accordion-content">
                                        <p>Free shipping on orders over 200,000 VND. Returns accepted within 30 days of delivery.</p>
                                    </div>
                                </div>
                            </div>
                            <input type="hidden" name="id" class="id" value="${p.id}">
                            <input type="hidden" name="price" class="price" value="${p.price - ((p.price * voucherMap[p.voucherID])/100)}">
                            <input type="hidden" name="name" value="${p.name}">
                            <input type="hidden" name="picURL" value="${p.picURL}">
                            <input type="hidden" name="voucherPct" value="${voucherMap[p.voucherID]}">
                        </div>
                    </div>
                </div>
            </form>

            <div class="reviews-section" id="reviewsSection">
                <h3 class="reviews-title">Customer Reviews</h3>
                <c:if test="${empty feedbackList}">
                    <div class="no-reviews-container">
                        <i class="bi bi-chat-quote no-reviews-icon"></i>
                        <p class="no-reviews-text">No reviews yet. Be the first to share your thoughts!</p>
                    </div>
                </c:if>
                <c:if test="${not empty feedbackList}">
                    <div class="row">
                        <div class="col-md-4 mb-4">
                            <div class="review-summary-card">
                                <div class="rating-number">
                                    <fmt:formatNumber value="${averageRating}" maxFractionDigits="1"/>
                                </div>
                                <div class="rating-stars">
                                    <c:forEach begin="1" end="5" var="i">
                                        <i class="bi ${i <= averageRating ? 'bi-star-fill' : (i - 0.5 <= averageRating ? 'bi-star-half' : 'bi-star')}"></i>
                                    </c:forEach>
                                </div>
                                <div class="rating-text">Based on ${reviewCount} reviews</div>
                            </div>
                        </div>
                        <div class="col-md-8">
                            <c:forEach var="fb" items="${feedbackList}">
                                <div class="review-card-item">
                                    <div class="review-card-header">
                                        <div class="review-user-name">${fb.customerName}</div>
                                        <div class="review-item-stars">
                                            <c:forEach begin="1" end="5" var="i">
                                                <i class="bi ${i <= fb.ratePoint ? 'bi-star-fill' : 'bi-star'}"></i>
                                            </c:forEach>
                                        </div>
                                    </div>
                                    <div class="review-content">${fb.content}</div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
            </div>
        </main>

        <%@ include file="footer.jsp" %>
        <div id="stock-popup" class="stock-popup"></div>

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <script>
            let stockPopupTimer = null;
            // Enhanced Popup Function
            function showPopup(message, type = 'normal') {
                const popup = document.getElementById('stock-popup');
                if (!popup) return;
                popup.textContent = message;
                
                // Reset classes
                popup.className = 'stock-popup';
                if(message.toLowerCase().includes('success') || message.toLowerCase().includes('added')) {
                    popup.classList.add('success');
                } else {
                    popup.classList.add('error');
                }
                
                // Force Reflow for animation reset
                void popup.offsetWidth; 
                popup.classList.add('show');
                
                if (stockPopupTimer) clearTimeout(stockPopupTimer);
                stockPopupTimer = setTimeout(() => popup.classList.remove('show'), 3500);
            }

            function toggleAccordion(header) {
                const item = header.parentElement;
                const content = header.nextElementSibling;
                const isOpen = item.classList.contains('active');
                if (!isOpen) {
                    item.classList.add('active');
                    content.style.maxHeight = content.scrollHeight + "px";
                } else {
                    item.classList.remove('active');
                    content.style.maxHeight = null;
                }
            }

            document.addEventListener('DOMContentLoaded', function () {
                // Scroll Animation Observer for Reviews
                const observerOptions = { threshold: 0.1 };
                const observer = new IntersectionObserver((entries) => {
                    entries.forEach(entry => {
                        if (entry.isIntersecting) {
                            entry.target.classList.add('visible');
                            observer.unobserve(entry.target); // Run once
                        }
                    });
                }, observerOptions);
                
                const reviewsSection = document.getElementById('reviewsSection');
                if(reviewsSection) observer.observe(reviewsSection);

                // Initialize Accordion
                const activeItems = document.querySelectorAll('.accordion-item.active');
                activeItems.forEach(item => {
                    const content = item.querySelector('.accordion-content');
                    if(content) content.style.maxHeight = content.scrollHeight + "px";
                });

                // Logic Variables
                const isLoggedIn = ${sessionScope.acc != null};
                const loginUrl = "${pageContext.request.contextPath}/login.jsp";
                const decBtn = document.getElementById('decrementButton');
                const incBtn = document.getElementById('incrementButton');
                const qtyInput = document.getElementById('quantityInput');
                const qtyControl = document.getElementById('qtyControl');
                const form = document.getElementById('productForm');
                const addToCartBtn = document.getElementById('check');
                const buyNowBtn = document.querySelector('.btn-buy-now');
                const stockDisplay = document.getElementById('stock-display');
                
                const sizeRadios = document.querySelectorAll("input[name='size']");
                let firstAvailableSize = null;

                // Size & Stock Logic
                sizeRadios.forEach(radio => {
                    const stock = parseInt(radio.getAttribute('data-stock')) || 0;
                    if (stock <= 0) {
                        radio.disabled = true;
                    } else if (!firstAvailableSize) {
                        firstAvailableSize = radio;
                    }
                    radio.addEventListener('change', function () {
                        updateStockUI(parseInt(this.getAttribute('data-stock')) || 0);
                    });
                });

                if (firstAvailableSize) {
                    firstAvailableSize.checked = true;
                    updateStockUI(parseInt(firstAvailableSize.getAttribute('data-stock')));
                } else {
                    stockDisplay.textContent = "(Temporarily out of stock)";
                    stockDisplay.className = "stock-status stock-out";
                    addToCartBtn.disabled = true;
                    buyNowBtn.disabled = true;
                    qtyInput.disabled = true;
                    qtyInput.value = 0;
                    qtyControl.classList.add('disabled');
                }

                function updateStockUI(maxStock) {
                    if (maxStock > 0) {
                        stockDisplay.textContent = "(" + maxStock + " available)";
                        stockDisplay.className = "stock-status stock-available";
                        qtyInput.disabled = false;
                        qtyInput.max = maxStock;
                        qtyInput.value = 1;
                        addToCartBtn.disabled = false;
                        buyNowBtn.disabled = false;
                        qtyControl.classList.remove('disabled');
                    } else {
                        stockDisplay.textContent = "(Out of stock)";
                        stockDisplay.className = "stock-status stock-out";
                        addToCartBtn.disabled = true;
                        buyNowBtn.disabled = true;
                        qtyInput.value = 0;
                        qtyInput.disabled = true;
                        qtyControl.classList.add('disabled');
                    }
                }

                function setQty(val) {
                    const max = parseInt(qtyInput.max) || 1;
                    let newVal = parseInt(val);
                    if (isNaN(newVal)) newVal = 1;
                    if (newVal < 1) newVal = 1;
                    if (newVal > max) {
                        newVal = max;
                        showPopup("Max quantity reached (" + max + ")");
                    }
                    qtyInput.value = newVal;
                }

                incBtn.addEventListener('click', () => setQty((parseInt(qtyInput.value) || 1) + 1));
                decBtn.addEventListener('click', () => setQty((parseInt(qtyInput.value) || 1) - 1));

                function checkStock() {
                    const sizeRadio = document.querySelector("input[name='size']:checked");
                    if (!sizeRadio) { showPopup("Please select a size."); return false; }
                    const stock = parseInt(sizeRadio.getAttribute('data-stock')) || 0;
                    const requested = parseInt(qtyInput.value) || 1;
                    if (stock <= 0) { showPopup("Size out of stock."); return false; }
                    if (requested > stock) { showPopup(`Only ${stock} items left.`); return false; }
                    return true;
                }

                // AJAX Add to Cart
addToCartBtn.addEventListener('click', function (e) {
    e.preventDefault();
    if (!isLoggedIn) { window.location.href = loginUrl; return; }
    if (!checkStock()) return;
    
    // Button Loading Effect
    const originalText = this.innerHTML;
    this.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Adding...';
    this.disabled = true;

    const formData = new FormData(form);
    const params = new URLSearchParams(formData);
    const url = form.getAttribute('action') + "?" + params.toString();
    
    fetch(url, {method: 'GET'})
        .then(res => { 
            // Nếu Server redirect (ví dụ: bắt đăng nhập lại), thì mới chuyển trang
            if (res.redirected) {
                window.location.href = res.url; 
                return null;
            }
            return res.text(); 
        })
    .then(text => { 
        // Khôi phục nút bấm
        this.innerHTML = originalText;
        this.disabled = false;

        if (text === null) return; // Đã redirect (login)

        const trimmed = text.trim();

        // Trường hợp thành công
        if (trimmed === "OK") {
            showPopup("Added to cart successfully!", "success");
            setQty(1);
            return;
        }

        // Nếu server trả về thông báo lỗi dạng "ERROR: ... "
        if (trimmed.startsWith("ERROR:")) {
            const msg = trimmed.substring("ERROR:".length).trim();
            showPopup(msg); // msg không có chữ 'success'/'added' nên popup sẽ là màu đỏ (error)
            return;
        }

        // Phòng hờ nếu server trả về chuỗi có chữ Login
        if (trimmed.includes("Login")) {
            window.location.href = loginUrl;
            return;
        }

        // Fallback – nếu có text khác lạ, cứ show ra cho user thấy
        showPopup(trimmed);
    })

});

                form.addEventListener('submit', function (e) {
                    if (!isLoggedIn) { e.preventDefault(); window.location.href = loginUrl; }
                    else if (!checkStock()) { e.preventDefault(); }
                });
            });
        </script>
    </body>
</html>