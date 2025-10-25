<%-- 
    Document   : addProduct
    Created on : Oct 24, 2025
    Author     : Phuoc
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add Product</title>
        <link rel="icon" href="/Project_SWP391_Group4/images/LG1.png" type="image/x-icon">
        <link href='https://fonts.googleapis.com/css?family=Quicksand' rel='stylesheet'>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Quicksand', sans-serif;
            }

            body {
                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                min-height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
                padding: 20px;
            }

            .container {
                background: white;
                border-radius: 15px;
                box-shadow: 0 20px 40px rgba(0,0,0,0.1);
                padding: 40px;
                width: 100%;
                max-width: 600px;
                margin: 20px;
            }

            .header {
                text-align: center;
                margin-bottom: 30px;
            }

            .header h1 {
                color: #a0816c;
                font-size: 2.5em;
                margin-bottom: 10px;
                font-weight: 600;
            }

            .header p {
                color: #666;
                font-size: 1.1em;
            }

            .form-group {
                margin-bottom: 25px;
                position: relative;
            }

            .form-group label {
                display: block;
                margin-bottom: 8px;
                color: #a0816c;
                font-weight: 600;
                font-size: 1.1em;
            }

            .form-group input {
                width: 100%;
                padding: 15px;
                border: 2px solid #e0e0e0;
                border-radius: 10px;
                font-size: 1em;
                transition: all 0.3s ease;
                background: #fafafa;
            }

            .form-group input:focus {
                outline: none;
                border-color: #a0816c;
                background: white;
                box-shadow: 0 0 0 3px rgba(160, 129, 108, 0.1);
                transform: translateY(-2px);
            }

            .form-row {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
            }

            .input-icon {
                position: relative;
            }

            .input-icon i {
                position: absolute;
                left: 15px;
                top: 50%;
                transform: translateY(-50%);
                color: #a0816c;
                font-size: 1.2em;
            }

            .input-icon input {
                padding-left: 45px;
            }

            .submit-btn {
                width: 100%;
                padding: 15px;
                background: linear-gradient(135deg, #a0816c 0%, #8a6e5b 100%);
                color: white;
                border: none;
                border-radius: 10px;
                font-size: 1.2em;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                text-transform: uppercase;
                letter-spacing: 1px;
            }

            .submit-btn:hover {
                transform: translateY(-3px);
                box-shadow: 0 10px 20px rgba(160, 129, 108, 0.3);
                background: linear-gradient(135deg, #8a6e5b 0%, #a0816c 100%);
            }

            .product-preview {
                text-align: center;
                margin: 20px 0;
                padding: 20px;
                background: #f8f9fa;
                border-radius: 10px;
                border: 2px dashed #a0816c;
            }

            .product-preview img {
                max-width: 200px;
                max-height: 200px;
                border-radius: 10px;
                margin-bottom: 10px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            }

            .preview-text {
                color: #666;
                font-style: italic;
            }

            .success-message {
                background: #d4edda;
                color: #155724;
                padding: 15px;
                border-radius: 10px;
                margin-bottom: 20px;
                border: 1px solid #c3e6cb;
                display: none;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1><i class="fas fa-plus-circle"></i> Add New Product</h1>
                <p>Enter product information below</p>
            </div>

            <!-- Success Message -->
            <div class="success-message" id="successMessage">
                <i class="fas fa-check-circle"></i> Product added successfully!
            </div>

            <!-- Product Preview -->
            <div class="product-preview">
                <img id="previewImage" src="${c.picURL}" alt="Product Preview" 
                     onerror="this.src='https://via.placeholder.com/200x200?text=No+Image'">
                <div class="preview-text">Product Image Preview</div>
            </div>

            <!-- Form Start -->
            <form action="${pageContext.request.contextPath}/addProduct" method="post" id="addForm">
                <div class="form-row">
                    <div class="form-group">
                        <label><i class="fas fa-tag"></i> Product Name</label>
                        <div class="input-icon">
                            <i class="fas fa-tag"></i>
                            <input type="text" name="name" required placeholder="Enter product name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label><i class="fas fa-dollar-sign"></i> Price</label>
                        <div class="input-icon">
                            <i class="fas fa-dollar-sign"></i>
                            <input type="number" name="price" min="0" required placeholder="Enter price">
                        </div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label><i class="fas fa-boxes"></i> Quantity</label>
                        <div class="input-icon">
                            <i class="fas fa-boxes"></i>
                            <input type="number" name="quantity" min="0" required placeholder="Enter quantity">
                        </div>
                    </div>

                    <div class="form-group">
                        <label><i class="fas fa-percentage"></i> Promotion</label>
                        <div class="input-icon">
                            <i class="fas fa-percentage"></i>
                            <select name="promo" required 
                                    style="width:100%; padding:15px; border:2px solid #e0e0e0; border-radius:10px; font-size:1em; background:#fafafa; padding-left:45px; appearance:none; -webkit-appearance:none;">
                                <option value="">-- Select Promo --</option>
                                <c:forEach var="p" items="${promoList}">
                                    <option value="${p.promoID}">
                                        ${p.promoPercent}% (${p.startDate} → ${p.endDate})
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>



                    <div class="form-group">
                        <label><i class="fas fa-layer-group"></i> Category</label>
                        <div class="input-icon">
                            <i class="fas fa-layer-group"></i>
                            <select name="category" required 
                                    style="width:100%; padding:15px; border:2px solid #e0e0e0; border-radius:10px; font-size:1em; background:#fafafa; padding-left:45px; appearance:none; -webkit-appearance:none;">
                                <option value="">-- Select Category --</option>
                                <c:forEach var="c" items="${cateList}">
                                    <option value="${c.category_id}">
                                        ${c.type} (${c.gender})
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>



                    <div class="form-group">
                        <label><i class="fas fa-image"></i> Image URL</label>
                        <div class="input-icon">
                            <i class="fas fa-image"></i>
                            <input type="text" name="pic" id="pro_pic" required placeholder="Enter image URL" oninput="updatePreview()">
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-align-left"></i> Description</label>
                    <div class="input-icon">
                        <i class="fas fa-align-left"></i>
                        <input type="text" name="des" required minlength="10" placeholder="Enter product description">
                    </div>
                </div>

                <button type="submit" class="submit-btn">
                    <i class="fas fa-save"></i> Add Product
                </button>
            </form>
        </div>

        <script src="js/jquery-3.7.0.min.js"></script> 
        <script src="js/jquery.validate.min.js"></script> 
        <script>
            function updatePreview() {
                const imageUrl = document.getElementById('pro_pic').value;
                const previewImage = document.getElementById('previewImage');
                previewImage.src = imageUrl || "https://via.placeholder.com/200x200?text=No+Image";
            }

            // Form validation
            $("#addForm").validate({
                rules: {
                    name: {required: true, minlength: 2},
                    price: {required: true, min: 0},
                    quantity: {required: true, min: 0},
                    promo: {required: true, min: 1, max: 2},
                    category: {required: true, min: 1, max: 4},
                    des: {required: true, minlength: 10},
                    pic: {required: true, url: true}
                },
                messages: {
                    name: {required: "Name is required"},
                    price: {required: "Price is required"},
                    quantity: {required: "Quantity is required"},
                    promo: {required: "Promo ID is required"},
                    category: {required: "Category ID is required"},
                    des: {required: "Description is required"},
                    pic: {required: "Image URL is required", url: "Invalid URL"}
                },
                errorPlacement: function (error, element) {
                    error.appendTo(element.parent().parent());
                },
                submitHandler: function (form) {
                    document.getElementById('successMessage').style.display = 'block';
                    window.scrollTo(0, 0);
                    setTimeout(() => {
                        form.submit();
                    }, 1500);
                    return false;
                }
            });
        </script>
    </body>
</html>
