<%-- 
    Document   : addProductForm
    Created on : Feb 28, 2024, 4:14:32 PM
    Author     : LENOVO
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="icon" href="/Project_SWP391_Group4/images/LG1.png" type="image/x-icon">
    </head>
    <body>
        <form action="addProduct" method="get" id="form">
            Enter quan: <input type="number" name="quantity" id="pro_quan" ><br>
            Enter name <input type="text" name="name" id="pro_name" ><br>
            Enter promo ID <input type="number" name="promo" id="pro_sale" min="0" max="2"><br>
            Enter category ID <input type="number" name="category" id="pro_sale" min="0" max="4"><br>
            Enter price <input type="number" name="price" id="price" ><br>
            Enter pic <input type="text" name="pic" id="pro_pic" ><br>
            Enter des <input type="text" name="des" id="pro_des" ><br>
            <input type="submit"/>
        </form>
        
        <script src="js/jquery-3.7.0.min.js"></script> 
        <script src="js/jquery.validate.min.js"></script> 
        <script>
            var validator = $("#form").validate({
                rules: {
                    quantity: {
                        required: true
                    },
                    id: {
                        required: true
                    },
                    name: "required",
                    promo: {
                        required: true,
                        min: 1,
                        max: 2
                    },
                    category: {
                        required: true,
                        min: 1,
                        max: 4
                    },
                    price: {
                        required: true,
                        min: 0
                    },
                    des: "required",
                    pic: "required"
                },
                messages: {
                    quantity: {
                        required: "Quantity is required",
                    },
                    id: {
                        required: "Id product is required",
                    },
                    name: "Name is required",
                    promo: {
                        required: "Promo ID is required",
                        min: "Promo ID is invalid",
                        max: "Promo ID is invalid",
                    },
                    category: {
                        required: "Category ID is required",
                        min: "Category ID is invalid",
                        max: "Category ID is invalid",
                    },
                    price: {
                        required: "Price is required",
                        min: "Price is not less than 0"
                    },
                    des: "Description is required",
                    pic: "Picture URL is required"
                }
            });
        </script> 
    </body>
</html>