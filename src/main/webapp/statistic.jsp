<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" >
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet"
              integrity="sha384-iYQeCzEYFbKjA/T2uDLTpkwGzCiq6soy8tYaI1GyVh/UjpbCx/TYkiZhlZB6+fzT" crossorigin="anonymous">
        <!-- bootstrap -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <!-- bootstrap icon -->
        <link href='https://fonts.googleapis.com/css?family=Quicksand' rel='stylesheet'> <!-- font family -->
        <link rel="icon" href="/Project_SWP391_Group4/images/LG1.png" type="image/x-icon">

        <script src="https://kit.fontawesome.com/1bd876819f.js" crossorigin="anonymous"></script>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }
            :root {
                --logo-color: #a0816c;
                --nav-list-color: #a0816c;
                --icon-color: #a0816c;
                --text-color: #a0816c;
                --bg-color: #a0816c;
            }

            html,
            body,
            .main,
            nav,
            .nav-list {
                height: 100%;
            }

            header {
                height: 50px;
                background-color: #a0816c;
            }

            .header-top,
            .admin-info {
                display: flex;
            }

            .header-top {
                max-width: 1200px;
                height: 100%;
                margin: 0 auto;
                align-items: center;
                justify-content: space-between;
            }

            .header-top * {
                color: white;
            }

            .logo {
                font-size: 1.5em;
            }

            .admin-name,
            .signout {
                margin: 0 10px;
            }

            .signout a:hover {
                color: #e9c0c0;
            }

            .main {
                display: flex;
                height: calc(100% - 50px);
            }

            nav {
                width: 17%;
            }

            .nav-list {
                list-style-type: none;
                background-color: #b4acac;
                padding: 0;
            }

            .nav-list li {
                padding: 10px;
                cursor: pointer;
            }

            .nav-list li:hover {
                background-color: rgb(122, 117, 120);
            }

            .nav-list li * {
                text-decoration: none;
                color: white;
            }

            .main-content {
                width: 100%;
                padding: 70px;
                overflow-y: scroll;
                /*scrollbar-width: none;*/
            }
            .main-content > div {
                display: none;
            }

            /* product management */
            .filter {
                padding: 8px;
            }

            .filter-add-btn {
                float: right;
                border: none;
                background-color: #2f2b2b;
                color: white;
                padding: 8px;
                border-radius: 5px;

            }

            .product-table .table tbody tr th {
                width: 6%;
            }

            .product-table .table tbody tr th img {
                width: 100%;
            }

            .product-table .td-button {
                width: 15%;
            }
            .btn-update, .btn-delete {
                width: 77px;
            }

            /* product management */

            /* personal-info  */
            .personal-main {
                width: 50%;
                margin: 50px auto;
                box-shadow: rgba(0, 0, 0, 0.3) 0px 19px 38px, rgba(0, 0, 0, 0.22) 0px 15px 12px;
            }
            .personal-main table {
                width: 100%;
                border-collapse: collapse;
            }
            .personal-main table th, td {
                padding: 8px;
                text-align: left;
                border-bottom: 1px solid #ddd;
            }

            .personal-btn {
                text-align: center;
                margin: 20px 0;
            }

            .personal-btn button {
                border: none;
                background-color: #a0816c;
                color: white;
                padding: 5px;
                border-radius: 5px;
                transition: all 0.3s ease;
            }

            .personal-btn button:hover {
                background-color: #af907b;
                transition: all 0.3s ease;
            }

            #edit-personal {
                display: none;
            }
            /* personal-info  */

            /* accout-manage */
            .account-search {
                padding: 5px;
                outline: none;
                width: 20%;
            }
            .phoneNum-col {
                width: 12%;
            }
            .account-main .table tr>* {
                vertical-align: middle;
            }

            .account-main .table thead tr th:last-child {
                width: 10%;
            }

            .add-box {
                max-width: 50%;
                margin: 0 auto;
                padding: 20px;
                border: 1px solid #a0816c;
                border-radius: 5px;
            }

            .back-btn {
                position: absolute;
                border-radius: 5px;
                padding: 5px 10px;
                color: white;
                font-size: 1.5em;
                top: 15%;
                left: 15%;
                border: none;
                background-color: #a0816c;
            }

            .add-box h1 {
                text-align: center;
                color: #a0816c;
            }

            .add-box input {
                width: 100%;
                border: none;
                border-bottom: 1px solid #a0816c;
                margin: 15px 0;
                padding: 10px 5px;
                outline: none;
            }

            .add-box .row button {
                background-color: #a0816c;
                width: 100%;
                color: white;
                border: none;
                height: 35px;
            }
            .add-box select {
                width: 100%;
                border: none;
                border: 1px solid var(--bg-color);
                margin: 15px 0;
                padding: 10px 5px;
                outline: none;
            }

            .add-box select option {
                border: none;
            }

            ::file-selector-button {
                display: none;
            }

            .file-input input {
                cursor: pointer;
                border: 1px dashed var(--bg-color);
            }

            input[type='file'] {
                color: rgba(0, 0, 0, 0);
                display: flex;
                position: relative;
            }

            input[type='file']::before {
                content: "Click or drag an image to upload";
                color: var(--text-color);
                /* text-align: center; */
                font-size: 1em;
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
            }

            .edit-profile {
                display: none;
            }
            /* accout-manage */

            /* statistic */
            .card-container {
                display: grid;
                grid-template-columns: 1fr 1fr 1fr 1fr;
                gap: 20px;
                margin: 20px 0;
            }
            .card {
                display: flex;
                flex-direction: column;
                justify-content: space-around;
                padding: 25px;
                color: white;
                border-radius: 30px;
                box-shadow: 0 6px 7px -4px rgba(0, 0, 0, 0.2);
            }
            .card:first-child {
                background-color: red;
            }
            .card:nth-child(2){
                background-color: green;
            }
            .card:nth-child(3){
                background-color: orange;
            }
            .card:nth-child(4){
                background-color: blue;
            }
            .card-inner {
                display: flex;
                align-items: center;
                justify-content: space-between;
            }
            .card-inner > span {
                font-size: 50px;
            }
            input[type="date"] {
                border-radius: 5px;
                padding: 5px;
                font-size: 1.2em;
                color: white;
                background-color: mediumaquamarine;
                border: none;
                outline: none;
            }
            ::-webkit-calendar-picker-indicator {
                cursor: pointer;
                padding: 5px;
                background-color: white;
                border-radius: 2px;
                text-align: center;
            }
            #date, #mySelect {
                border: none;
                background-color: #e56e89;
                padding: 5px 10px;
                color: white;
                border-radius: 5px;
                outline: none;
            }
            #mySelect:after {
                outline: none;
                border-radius: 5px;
                border: none;
            }
            button#date:hover {
                background-color: #b97777;
            }
            .form-date {
                position: relative;
            }
            .form-date label{
                position: absolute;
                top: 100%;
                left: 0;
            }
            /* statistic */
            .error {
                color: red;
            }

            .chart {
                display: flex;
                align-items: center;
            }
            .chart-heading {
                font-family: "Rubik", sans-serif;
                color: #023047;
                text-transform: uppercase;
                font-size: 24px;
                text-align: center;
            }

            .chart-container {
                width: 40%;
            }

            .chart-container-col{
                width: 50%;
            }

            .programming-stats {
                font-family: "Rubik", sans-serif;
                display: flex;
                align-items: center;
                gap: 24px;
                margin: 0 auto;
                width: fit-content;
                box-shadow: 0 4px 12px -2px rgba(0, 0, 0, 0.3);
                border-radius: 20px;
                padding: 8px 32px;
                color: #023047;
                transition: all 400ms ease;
            }

            .programming-stats:hover {
                transform: scale(1.02);
                box-shadow: 0 4px 16px -7px rgba(0, 0, 0, 0.3);
            }

            .programming-stats .details ul {
                list-style: none;
                padding: 0;
            }

            .programming-stats .details ul li {
                font-size: 16px;
                margin: 12px 0;
                text-transform: uppercase;
            }

            .programming-stats .details .percentage {
                font-weight: 700;
                color: #e63946;
            }
            @media (max-width: 1100px) {
                .card-container {
                    grid-template-columns: 2fr 2fr;
                }
            }
            @media (max-width: 651px) {
                .card-container {
                    grid-template-columns: none;
                }
            }
        </style>
    </head>

    <body>
        <header>
            <div class="header-top">
                <div class="logo">DOTAI</div>
                <div class="admin-info">
                    <div class="admin-name"><i class="bi bi-person-fill"></i>: Admin</div>
                    <div class="signout"><a href="cookieHandle"><i class="bi bi-box-arrow-right"></i> Sign out</a></div>
                </div>
            </div>
        </header>

        <div class="main">
            <nav>
                <ul class="nav-list">
                    <li class="nav-link" data-target="statistic">
                        <a href="#"><i class="fa-solid fa-chart-line"></i> <span>Dashboard</span> </a>
                    </li>

                    <li class="nav-link" data-target="product-manage">
                        <a href="#" ><i class="bi bi-box"></i> <span>Product Management</span> </a>
                    </li>
                    <li class="nav-link" data-target="account-manage">
                        <a href="#" ><i class="bi bi-person-badge-fill"></i> <span>Account management</span> </a>
                    </li>
                    <li class="nav-link" data-target="personal-info">
                        <a href="#" ><i class="bi bi-person-fill"></i> <span>Personal information</span> </a>
                    </li>
                </ul>
            </nav>

            <div class="main-content">
                <!-- product management -->
                <div class="product-manage">
                    <h3>Product Management</h3>
                    <hr>
                    <div id="product-main">
                        <div class="filter">
                            <!--<form action="" method="">-->
                            <select id="sortID"  id="filter-price" onchange="sort()">
                                <option value="Increase">Sort by price ascending</option>
                                <option value="Decrease">Sort by price in descending</option>
                            </select>
                            <!--<button class="btn-sort"> Submit</button>-->
                            <!--</form>-->
                            <!--<form action="" method="">-->
                            <input id="search-product" type="text" placeholder="Search" oninput="searchProduct()">
                            <!--<button class="btn-search"> Search</button>-->

                            <!--</form>-->
                            <button class="filter-add-btn" onclick="toggleAddProduct()">Add new product</button> 
                        </div>
                        <div class="product-table">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th scope="col">Picture</th>
                                        <th scope="col">Name</th>
                                        <th scope="col">Category ID</th>
                                        <th scope="col">Price</th>
                                        <th scope="col">Quantity</th>
                                        <th scope="col"></th>
                                    </tr>
                                </thead>
                                <tbody id="product-value">



                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="add-box container" id="add-product" style="display: none;">
                        <h1>Add Product</h1>
                        <hr>
                        <div class="row">
                            <div class="col-md-12">
                                <input type="text" placeholder="Name" id="product-name-add">
                            </div>
                            <div class="col-md-12">
                                <input type="text" placeholder="Quantity" id="product-quantity-add">
                            </div>
                            <div class="col-md-12">
                                <input type="text" placeholder="Promo Percent" id="product-promo-add">
                            </div>
                            <div class="col-md-12   ">
                                <input type="text" placeholder="Price" id="product-price-add">
                            </div>
                            <div class="col-md-6">
                                <select id="gender-slct">
                                    <option value="Gender">Gender</option>
                                    <!-- <option value="Men">Men</option>
                                    <option value="Women">Women</option> -->
                                </select>
                            </div>
                            <div class="col-md-6">
                                <select id="type-slct">
                                    <option value="Type">Type</option>
                                </select>
                            </div>
                            <div class="col-md-12"><textarea style="width: 100%"  id="product-des-add" placeholder="Description" rows="4" cols="45"></textarea></div>

                            <div class="col-md-12 file-input">
                                <input type="file" accept="" id="product-url-add" title="Click or drag a file to this area to upload">
                            </div>
                            <div class="col-md-6">
                                <button onclick="toggleCancelProduct()">CANCEL</button>
                            </div>
                            <div class="col-md-6 ">
                                <button onclick="addProduct()">ADD</button>
                            </div>
                        </div>
                    </div>
                    <div class="add-box container" id="update-product" style="display: none;">
                        <h1>Update Product</h1>
                        <hr>
                        <div class="row">
                            <div class="col-md-12">
                                <input type="text" placeholder="Name" name="name" id="product-name">
                            </div>
                            <div class="col-md-12">
                                <input type="text" placeholder="Promo Percent" name="promo-id" id="promo-id">
                            </div>
                            <div class="col-md-12">
                                <input type="text" placeholder="Price" name="price" id="product-price">
                            </div>
                            <div class="col-md-12">
                                <input type="text" placeholder="Description" name="description" id="product-des">
                            </div>
                            <div class="col-md-6">
                                <button onclick="toggleCancelProduct()">CANCEL</button>
                            </div>
                            <div class="col-md-6 ">
                                <button  onclick="updateProduct(this)" data-id="" id="update-product-btn">UPDATE</button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="statistic" style="display: block;">
                    <h3>Dashboard</h3>
                    
                    <input type="submit" value="Export to excel" />
                    <hr>
                    <div class="card-container">
                        <div class="card">
                            <div class="card-inner">
                                <h2>Products</h2>
                                <span><i class="bi bi-box"></i></span>
                            </div>
                            <h1>${numberOfProduct}</h1>
                        </div>

                        <div class="card">
                            <div class="card-inner">
                                <h2>Orders</h2>
                                <span><i class="bi bi-cart-fill"></i></span>
                            </div>
                            <h1>${numberOfOrder}</h1>
                        </div>

                        <div class="card">
                            <div class="card-inner">
                                <h2>Revenue</h2>
                                <span><i class="bi bi-currency-dollar"></i></span>
                            </div>
                            <h1>${revenue}</h1>
                        </div>

                        <div class="card">
                            <div class="card-inner">
                                <h2>Customers</h2>
                                <span><i class="bi bi-people"></i></span>
                            </div>
                            <h1>${numberOfCustomer}</h1>
                        </div>
                    </div>
                    <div>
                        <form action="statistic" method="get" id="formDate" class="form-date">
                            <select id="mySelect" name="year" required>
                                <option value="">-- Select Year --</option>
                                <option value="2024">2024</option>
                                <option value="2023">2023</option>
                                <option value="2022">2022</option>
                                <option value="2021">2021</option>
                            </select>
                            <button name="date" value="date" id="date">Submit</button>
                            <h1>   </h1>
                        </form>
                    </div>

                    <div class="chart">
                        <div class="chart-container">
                            <canvas class="my-chart"></canvas>
                        </div>

                        <div class="chart-container-col">
                            <canvas class="my-chart-line" width="1000"  height="900"></canvas>
                        </div>
                    </div>

                </div>

                <div class="order-manage">
                    <h3>Order Management</h3>
                    <hr>
                    <div class="order-main">

                    </div>
                </div>

                <div class="account-manage">
                    <h3>Account Management</h3>
                    <hr>
                    <input type="text" id="search-account" placeholder="Enter name to search" oninput="searchAccount()" class="account-search form-control">
                    <button type="button" class="btn btn-secondary" onclick="toggleAddAccount()" id="add-btn">Add Staff</button>
                    <div class="account-main" id="account-main">
                        <table class="table table-striped table-hover" id="table">
                            <thead>
                                <tr>
                                    <th scope="col">#</th>
                                    <th scope="col">Username</th>
                                    <th scope="col">Email</th>
                                    <th scope="col">Address</th>
                                    <th scope="col">Full name</th>
                                    <th scope="col" class="phoneNum-col">Phone number</th>
                                </tr>
                            </thead>
                            <tbody id="account-value">



                            </tbody>
                        </table>
                    </div>

                    <div class="edit-profile" id="edit-profile">
                        <div class="add-box container">
                            <h1>Update account</h1>
                            <hr>
                            <div class="row">
                                <div class="col-md-12">
                                    <input type="email" placeholder="Email" id="update-acc-email">
                                </div>
                                <div class="col-md-12">
                                    <input type="text" placeholder="Address" id="update-acc-address">
                                </div>
                                <div class="col-md-12">
                                    <input type="text" placeholder="Fullname" id="update-acc-fullname">
                                </div>
                                <div class="col-md-12">
                                    <input type="text" placeholder="Phone number" id="update-acc-phone">
                                </div>
                                <div class="col-md-6">
                                    <button onclick="toggleEditAcount(this)">CANCEL</button>
                                </div>
                                <div class="col-md-6">
                                    <button id="update-acc-btn" onclick="updateAccount(this)" data-id="">UPDATE</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="edit-profile" id="add-account" >
                        <div class="add-box container">
                            <form action="" method="" id="signUp-form">

                                <h1>Add staff</h1>
                                <hr>
                                <div class="row">
                                    <div class="col-md-12">
                                        <input type="text" placeholder="Username" name="username" id="add-staff-username" required true>
                                    </div>
                                    <div class="col-md-12">
                                        <input type="password" placeholder="Password" name="password" id="add-staff-password" required true>
                                    </div>
                                    <div class="col-md-12">
                                        <input type="email" placeholder="Email" name="email" id="add-staff-email" required true>
                                    </div>
                                    <div class="col-md-12">
                                        <input type="text" placeholder="Address" name="address" id="add-staff-address" required true> 
                                    </div>
                                    <div class="col-md-12">
                                        <input type="text" placeholder="Full name" name="fullName" id="add-staff-name" required true>
                                    </div>
                                    <div class="col-md-12">
                                        <input type="tel" placeholder="Phone number" name="phoneNumber" id="add-staff-phone" required true>
                                    </div>
                                    <div id="message"></div>
                                    <div class="col-md-6">
                                        <button id="cancel-btn">CANCEL</button>
                                    </div>
                                    <div class="col-md-6">
                                        <!--<button onclick="addStaff()">ADD</button>-->
                                        <button >ADD</button>

                                    </div>
                                </div>
                            </form>

                        </div>

                    </div>


                </div>

                <div class="personal-info">
                    <h3>Personal Information</h3>
                    <hr>
                    <div class="personal-box" id="personal-box">
                        <div class="personal-btn">
                            <button id="update-pro-btn" onclick="toggleEditPersonal(this)" data-name="" data-phone="" data-email="" data-address="">Edit personal information</button>
                        </div>
                        <div class="personal-main">
                            <table>
                                <tr id="fullName">
                                    <th>Fullname:</th>
                                    <!--<td>Thanh Dy</td>-->
                                </tr>
                                <tr id="phoneNumber">
                                    <th>Phone number:</th>
                                    <!--<td>12345</td>-->
                                </tr>
                                <tr id="email">
                                    <th>Email:</th>
                                    <!--<td>xyz@gmail.com</td>-->
                                </tr>
                                <tr id="address">
                                    <th>Address:</th>
                                    <!--<td>Can Tho</td>-->
                                </tr>
                            </table>
                        </div>
                        <div class="personal-btn">
                            <button onclick="toggleChangePassword()">Change password</button>
                        </div>
                    </div>

                    <div class="add-box container" id="edit-personal">
                        <h1>Edit information</h1>
                        <hr>
                        <div class="row">
                            <div class="col-md-12">
                                <input type="text" id="update-profile-name" placeholder="Fullname" >
                            </div>
                            <div class="col-md-12">
                                <input type="text" placeholder="Phone number" id="update-profile-phone">
                            </div>
                            <div class="col-md-12">
                                <input type="email" placeholder="Email" id="update-profile-email">
                            </div>
                            <div class="col-md-12">
                                <input type="text" placeholder="Address" id="update-profile-address">
                            </div>
                            <div class="col-md-6">
                                <button onclick="toggleEditPersonal(this)">CANCEL</button>
                            </div>
                            <div class="col-md-6">
                                <button id="edit-profile-btn" onclick="updateProfile(this)" data-id="">UPDATE</button>
                            </div>
                        </div>
                    </div>

                    <div class="add-box container" id="change-password" style="display: none">
                        <form action="" method="">

                            <h1>Change password</h1>
                            <hr>                           
                            <div class="row">
                                <div class="col-md-12">
                                    <input type="password" placeholder="Current password" id="currentPassword">
                                </div>
                                <div class="col-md-12">
                                    <input type="password" placeholder="New password" id="newPassword1">
                                </div>

                                <div class="col-md-12">
                                    <input type="password" placeholder="Confirm password" id="newPassword2">
                                </div>

                                <div id="message-changepass" class="message"></div>


                                <div class="col-md-6">
                                    <button id="cancel-changepass-btn">CANCEL</button>
                                </div>
                                <div class="col-md-6">
                                    <button class="btn-changePass" >CHANGE</button>
                                </div>
                            </div>
                        </form>

                    </div>
                </div>
            </div>

            <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
            <script src="/Project_SWP391_Group4/js/jquery-3.7.0.min.js"></script>
            <script src="/Project_SWP391_Group4/js/jquery.validate.min.js"></script>
            <script>
                                    function profile() {
                                        var input = getCookie("input");
                                        $.ajax({
                                            method: "POST",
                                            url: "http://localhost:8080/Project_SWP391_Group4/staff/profile",
                                            data: {
                                                input: input
                                            }
                                        })
                                                .done(function (data) {
                                                    var data1 = JSON.parse(data);
                                                    var cells = document.querySelectorAll("table td");
                                                    cells.forEach(function (cell) {
                                                        cell.remove();
                                                    });
                                                    if (data1.isSuccess) {

                                                        var trName = document.getElementById("fullName");
                                                        var trEmail = document.getElementById("email");
                                                        var trAddress = document.getElementById("address");
                                                        var trPhone = document.getElementById("phoneNumber");
                                                        var info = data1.data;
                                                        var fullName = document.createElement("td");
                                                        var phoneNumber = document.createElement("td");
                                                        var address = document.createElement("td");
                                                        var email = document.createElement("td");
                                                        document.getElementById('update-pro-btn').setAttribute('data-name', info.fullName);
                                                        document.getElementById('update-pro-btn').setAttribute('data-phone', info.phoneNumber);
                                                        document.getElementById('update-pro-btn').setAttribute('data-email', info.email);
                                                        document.getElementById('update-pro-btn').setAttribute('data-address', info.address);
                                                        document.getElementById('update-pro-btn').setAttribute('data-id', info.username);
                                                        // ??t n?i dung cho c?c ? d? li?u
                                                        fullName.textContent = info.fullName;
                                                        phoneNumber.textContent = info.phoneNumber;
                                                        address.textContent = info.address;
                                                        email.textContent = info.email;
                                                        trName.appendChild(fullName);
                                                        trEmail.appendChild(email);
                                                        trAddress.appendChild(address);
                                                        trPhone.appendChild(phoneNumber);
                                                    }
                                                });
                                    }

                                    $(document).ready(function (e) {
                                        $('.btn-changePass').click(function (e) {
                                            e.preventDefault();
                                            var currentPass = document.getElementById("currentPassword").value;
                                            var newPassword1 = document.getElementById("newPassword1").value;
                                            var newPassword2 = document.getElementById("newPassword2").value;
                                            var input = getCookie("input");
                                            if (newPassword1 === newPassword2) {
                                                $.ajax({
                                                    method: "POST",
                                                    url: "http://localhost:8080/Project_SWP391_Group4/staff/profile/changepass",
                                                    data: {
                                                        input: input,
                                                        currentPassword: currentPass,
                                                        newPassword: newPassword2
                                                    }
                                                })
                                                        .done(function (data) {
                                                            var data1 = JSON.parse(data);
                                                            console.log(data1);
                                                            if (data1.isSuccess) {
                                                                alert('Change password successfully')
////                     
                                                            } else {
                                                                $("#message-changepass").html("Your current password is incorrect");
                                                                document.getElementById("message-changepass").style.color = "red";
                                                            }
                                                        });
                                            } else {
                                                $("#message-changepass").html("Password is not match!");
                                                document.getElementById("message-changepass").style.color = "red";
                                            }


                                        })

                                        $("#cancel-changepass-btn").click(function (event) {
                                            event.preventDefault(); // Prevent default form submission behavior
                                            toggleChangePassword(); // Hide the form
                                        });



                                        $.validator.addMethod("phone_valid", function (value, element) {
                                            return this.optional(element) || /^[0]{1}[0-9]{9}$/i.test(value);
                                        });
                                        $.validator.addMethod("username_valid", function (value, element) {
                                            return this.optional(element) || /^[a-zA-Z]([._-](?![._])|[a-zA-Z0-9]){3,18}[a-zA-Z0-9]$/i.test(value);
                                            //bat dau = ki tu hoac chu so, ki tu tiep theo co the la ._ nhung k the la lien tiep, ki tu cuoi cung la ki tu hoac so

                                        });
                                        $.validator.addMethod("password_valid", function (value, element) {
                                            return this.optional(element) || /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$/.test(value);
                                            //it nhat 6 ki tu chua it nhat 1 so, 1 ki tu dac biet va 1 chu hoa
                                        });
                                        $("#signUp-form").validate({
                                            rules: {
                                                "password": {
                                                    minlength: 6,
                                                    password_valid: true
                                                },
                                                "phoneNumber": {
                                                    minlength: 10,
                                                    phone_valid: true
                                                },
                                                "username": {
                                                    minlength: 5,
                                                    username_valid: true
                                                }
                                            },
                                            messages: {
                                                "username": {
                                                    minlength: "Please enter username more than 5 character",
                                                    required: "*This field is required! (Please enter your Username)",
                                                    username_valid: "Username can not have special character except ._ or start/end with special character"
                                                },
                                                "password": {
                                                    minlength: "Please enter password more than 6 character",
                                                    required: "*This field is required! (Please enter your Password)",
                                                    password_valid: "Password contain at least one uppercase letter, one number and one special character"
                                                },
                                                "phoneNumber": {
                                                    minlength: "Please enter phone number have 10 character",
                                                    required: "*This field is required! (Please enter your phone number)",
                                                    phone_valid: "Incorrect phone number! (Enter all 10 digits 0xxxxxxxxx)"
                                                },
                                                "address": {
                                                    required: "*This field is required! (Please enter your address)"
                                                },
                                                "email": {
                                                    required: "*This field is required! (Please enter your email)"
                                                },
                                                "fullName": {
                                                    required: "*This field is required! (Please enter your full name)"
                                                }
                                            },
                                            submitHandler: function (form) {
                                                // Form is valid, trigger AJAX call
                                                var username = document.getElementById('add-staff-username').value;
                                                var password = document.getElementById('add-staff-password').value;
                                                var email = document.getElementById('add-staff-email').value;
                                                var address = document.getElementById('add-staff-address').value;
                                                var fullName = document.getElementById('add-staff-name').value;
                                                var phone = document.getElementById('add-staff-phone').value;
                                                $.ajax({
                                                    method: "POST",
                                                    url: "http://localhost:8080/Project_SWP391_Group4/staff/account/add",
                                                    data: {
                                                        username: username,
                                                        password: password,
                                                        email: email,
                                                        address: address,
                                                        fullName: fullName,
                                                        phone: phone
                                                    },
                                                    success: function (data) {
                                                        var data1 = JSON.parse(data);
                                                        if (data1.isSuccess) {
                                                            alert('add successfully');
                                                            accountList();
                                                        } else {
                                                            $("#message").html("Your username or email is already exists");
                                                            document.getElementById("message").style.color = "red";
                                                        }
                                                    },
                                                    error: function (xhr, textStatus, errorThrown) {
                                                        console.log("AJAX Error: " + textStatus + " (" + errorThrown + ")");
                                                    }
                                                });
                                            }
                                        });
                                        $("#cancel-btn").click(function (event) {
                                            event.preventDefault(); // Prevent default form submission behavior
                                            toggleAddAccount(); // Hide the form
                                        });
                                    })

                                    function addProduct() {
                                        var name = document.getElementById('product-name-add');
                                        var quantity = document.getElementById('product-quantity-add');
                                        var promo = document.getElementById('product-promo-add');
                                        var price = document.getElementById('product-price-add');
                                        var gender = document.getElementById('gender-slct');
                                        var type = document.getElementById('type-slct');
                                        var des = document.getElementById('product-des-add');
                                        var url = document.getElementById('product-url-add');
                                        $.ajax({
                                            method: "POST",
                                            url: "http://localhost:8080/Project_SWP391_Group4/staff/product/add",
                                            data: {
                                                name: name.value,
                                                quantity: quantity.value,
                                                promo: promo.value,
                                                price: price.value,
                                                gender: gender.value,
                                                type: type.value,
                                                des: des.value,
                                                url: url.value
                                            }

                                        })
                                                .done(function (data) {

                                                    var data1 = JSON.parse(data);
                                                    if (data1.isSuccess) {
                                                        alert('add successfully');
                                                        productList();
                                                    } else {
                                                        alert('fail')
                                                    }
                                                })
                                    }

                                    function toggleAddProduct() {
                                        var main = document.getElementById('product-main');
                                        var add = document.getElementById('add-product');
                                        var update = document.getElementById('update-product');
                                        if (add.style.display === "none") {
                                            add.style.display = "block";
                                            main.style.display = "none";
                                            update.style.display = "none";
                                        }
                                    }

                                    function toggleAddAccount() {
                                        var box = document.getElementById('add-account');
                                        var addBtn = document.getElementById('add-btn');
                                        var addMain = document.getElementById('account-main');
                                        var searchAccount = document.getElementById('search-account');
                                        if (box.style.display === "none") {
                                            box.style.display = "block";
                                            addBtn.style.display = "none";
                                            addMain.style.display = "none";
                                            searchAccount.style.display = "none";
                                        } else {
                                            box.style.display = "none";
                                            addBtn.style.display = "block";
                                            addMain.style.display = "block";
                                            searchAccount.style.display = "block";
                                        }
                                    }

                                    function toggleUpdateProduct(product) {
                                        var main = document.getElementById('product-main');
                                        var add = document.getElementById('add-product');
                                        var add = document.getElementById('add-product');
                                        var update = document.getElementById('update-product');
                                        if (update.style.display === "none") {
                                            update.style.display = "block";
                                            main.style.display = "none";
                                            add.style.display = "none";
                                        } else {
                                            add.style.display = "none";
                                            main.style.display = "block";
                                            add.style.display = "block";
                                            productList();
                                        }
                                        var id = product.getAttribute('data-index');
                                        document.getElementById('update-product-btn').setAttribute('data-id', id);
                                        var name = document.getElementById('product-name');
                                        name.value = product.getAttribute('data-name');
                                        var promo = document.getElementById('promo-id');
                                        
//                                        promo.value = product.getAttribute('data-promo');
                                        
                                        var price = document.getElementById('product-price');
                                        price.value = product.getAttribute('data-price');
                                        var description = document.getElementById('product-des');
                                        description.value = product.getAttribute('data-description');
                                    }

                                    function updateProduct(product) {
                                        var id = product.getAttribute('data-id');
                                        var name = document.getElementById('product-name').value;
                                        var promo = document.getElementById('promo-id').value;
                                        var price = document.getElementById('product-price').value;
                                        var description = document.getElementById('product-des').value;
                                        $.ajax({
                                            method: "POST",
                                            url: "http://localhost:8080/Project_SWP391_Group4/staff/product/update",
                                            data: {
                                                id: id,
                                                name: name,
                                                promo: promo,
                                                price: price,
                                                description: description
                                            }
                                        })
                                                .done(function (data) {
                                                    var data1 = JSON.parse(data);
                                                    //                                                    console.log(data1);
                                                    if (data1.isSuccess) {
                                                        alert("update successfully");
                                                        productList();
                                                    } else {
                                                        alert("fail")
                                                    }
                                                })
                                    }

                                    function updateAccount(acc) {
                                        var username = acc.getAttribute('data-id');
                                        var email = document.getElementById('update-acc-email').value;
                                        var address = document.getElementById('update-acc-address').value;
                                        var fullname = document.getElementById('update-acc-fullname').value;
                                        var phone = document.getElementById('update-acc-phone').value;
                                        $.ajax({
                                            method: "POST",
                                            url: "http://localhost:8080/Project_SWP391_Group4/staff/account/update",
                                            data: {
                                                username: username,
                                                email: email,
                                                address: address,
                                                fullname: fullname,
                                                phone: phone
                                            }
                                        })
                                                .done(function (data) {
                                                    var data1 = JSON.parse(data);
                                                    //                                                    console.log(data1);
                                                    if (data1.isSuccess) {
                                                        alert("update successfully");
                                                        accountList();
                                                    } else {
                                                        alert("fail")
                                                    }
                                                })
                                    }

                                    function updateProfile(pro) {
                                        var username = pro.getAttribute('data-id');

                                        var email = document.getElementById('update-profile-email').value;
                                        var address = document.getElementById('update-profile-address').value;
                                        var fullname = document.getElementById('update-profile-name').value;
                                        var phone = document.getElementById('update-profile-phone').value;
                                        $.ajax({
                                            method: "POST",
                                            url: "http://localhost:8080/Project_SWP391_Group4/staff/profile/update",
                                            data: {
                                                username: username,
                                                email: email,
                                                address: address,
                                                fullname: fullname,
                                                phone: phone
                                            }
                                        })
                                                .done(function (data) {
                                                    var data1 = JSON.parse(data);
                                                    //                                                    console.log(data1);
                                                    if (data1.isSuccess) {
                                                        alert("update successfully");
                                                        profile();
                                                    } else {
                                                        alert("fail")
                                                    }
                                                })
                                    }


                                    function toggleCancelProduct() {
                                        var main = document.getElementById('product-main');
                                        var add = document.getElementById('add-product');
                                        var add = document.getElementById('add-product');
                                        var update = document.getElementById('update-product');
                                        if (update.style.display === "block") {
                                            update.style.display = "none";
                                            main.style.display = "block";
                                            add.style.display = "none";
                                        } else if (add.style.display === "block") {
                                            add.style.display = "none";
                                            main.style.display = "block";
                                            update.style.display = "none";
                                        }
                                    }

                                    function toggleAddStaff() {
                                        var box = document.getElementById('edit-profile');
                                        var addBtn = document.getElementById('add-btn');
                                        var addMain = document.getElementById('account-main');
                                        var searchAccount = document.getElementById('search-account');
                                        if (box.style.display === "none") {
                                            box.style.display = "block";
                                            addBtn.style.display = "none";
                                            addMain.style.display = "none";
                                            searchAccount.style.display = "none";
                                        } else {
                                            box.style.display = "none";
                                            addBtn.style.display = "block";
                                            addMain.style.display = "block";
                                            searchAccount.style.display = "block";
                                        }
                                    }

                                    function toggleEditAcount(account) {
                                        var box = document.getElementById('edit-profile');
                                        var addBtn = document.getElementById('add-btn');
                                        var addMain = document.getElementById('account-main');
                                        var searchAccount = document.getElementById('search-account');
                                        if (box.style.display === "none") {
                                            box.style.display = "block";
                                            addBtn.style.display = "none";
                                            addMain.style.display = "none";
                                            searchAccount.style.display = "none";
                                        } else {
                                            box.style.display = "none";
                                            addBtn.style.display = "block";
                                            addMain.style.display = "block";
                                            searchAccount.style.display = "block";
                                        }

                                        var id = account.getAttribute('data-index');
                                        document.getElementById('update-product-btn').setAttribute('data-id', id);
                                        var email = document.getElementById('update-acc-email');
                                        email.value = account.getAttribute('data-email');
                                        var address = document.getElementById('update-acc-address');
                                        address.value = account.getAttribute('data-address');
                                        var fullname = document.getElementById('update-acc-fullname');
                                        fullname.value = account.getAttribute('data-fullname');
                                        var phone = document.getElementById('update-acc-phone');
                                        phone.value = account.getAttribute('data-phone');
                                    }

                                    function toggleEditPersonal(profile) {
                                        var edit = document.getElementById('edit-personal');
                                        var personal = document.getElementById('personal-box');
                                        if (edit.style.display === "none") {
                                            edit.style.display = "block";
                                            personal.style.display = "none";
                                        } else {
                                            edit.style.display = "none";
                                            personal.style.display = "block";
                                        }

                                        var id = profile.getAttribute('data-id');
                                        document.getElementById('edit-profile-btn').setAttribute('data-id', id);

                                        var email = document.getElementById('update-profile-email');
                                        email.value = profile.getAttribute('data-email');
                                        var address = document.getElementById('update-profile-address');
                                        address.value = profile.getAttribute('data-address');
                                        var fullname = document.getElementById('update-profile-name');
                                        fullname.value = profile.getAttribute('data-name');
                                        var phone = document.getElementById('update-profile-phone');
                                        phone.value = profile.getAttribute('data-phone');
                                    }

                                    function toggleChangePassword() {
                                        var edit = document.getElementById('change-password');
                                        var personal = document.getElementById('personal-box');
                                        if (edit.style.display === "none") {
                                            edit.style.display = "block";
                                            personal.style.display = "none";
                                        } else {
                                            edit.style.display = "none";
                                            personal.style.display = "block";
                                        }
                                    }

                                    function searchProduct(e) {
                                        var input = document.getElementById('search-product').value;
                                        $.ajax({
                                            method: "POST",
                                            url: "http://localhost:8080/Project_SWP391_Group4/staff/product/search",
                                            data: {
                                                input: input
                                            }
                                        })
                                                .done(function (data) {
                                                    var data1 = JSON.parse(data);
                                                    //                                                                    console.log(data1)
                                                    if (data1.isSuccess) {
                                                        document.querySelector("table tbody").innerHTML = ""
                                                        var productList = data1.data;
                                                        productList.forEach(function (product) {
                                                            // T?o m?t h?ng m?i
                                                            var newRow = document.createElement("tr");
                                                            // T?o c?c ? d? li?u cho t?ng tr??ng
                                                            var pictureCell = document.createElement("td");
                                                            var nameCell = document.createElement("td");
                                                            var categoryIdCell = document.createElement("td");
                                                            var priceCell = document.createElement("td");
                                                            var quantityCell = document.createElement("td");
                                                            var btnCell = document.createElement("td");
                                                            btnCell.innerHTML = '<button type="button" class="btn btn-primary btn-update" onclick="toggleUpdateProduct(this)" data-name="' + product.name + '" data-promo="' + product.promoID + '" data-price="' + product.price + '" data-description="' + product.description + '"  data-index="' + product.id + '">Update</button>\n<button type="button" class="btn btn-danger btn-delete" onclick="deleteProduct(this)" data-index="' + product.id + '">Delete</button>'

                                                            // ??t n?i dung cho c?c ? d? li?u
                                                            pictureCell.innerHTML = '<img  style="width: 100px; height: 100px;object-fit: cover;" src="' + product.picURL + '" alt="Product Picture">';
                                                            nameCell.textContent = product.name;
                                                            categoryIdCell.textContent = product.categoryID;
                                                            priceCell.textContent = product.price.toLocaleString('vi-VN') + ' VND';
                                                            quantityCell.textContent = product.quantity;
                                                            // Th?m c?c ? d? li?u v?o h?ng m?i
                                                            newRow.appendChild(pictureCell);
                                                            newRow.appendChild(nameCell);
                                                            newRow.appendChild(categoryIdCell);
                                                            newRow.appendChild(priceCell);
                                                            newRow.appendChild(quantityCell);
                                                            newRow.appendChild(btnCell);
                                                            // Th?m h?ng m?i v?o tbody c?a b?ng
                                                            document.querySelector("#product-value").appendChild(newRow);
                                                        })
                                                    } else {

                                                    }
                                                })
                                    }

                                    function sort(e) {
                                        var option = document.getElementById('sortID').value;
                                        $.ajax({
                                            method: "POST",
                                            url: "http://localhost:8080/Project_SWP391_Group4/staff/product/sort",
                                            data: {
                                                option: option
                                            }

                                        })
                                                .done(function (data) {
                                                    var data1 = JSON.parse(data);
                                                    console.log(data1)
                                                    if (data1.isSuccess) {
                                                        document.querySelector("table tbody").innerHTML = ""
                                                        var productList = data1.data;
                                                        productList.forEach(function (product) {

                                                            var newRow = document.createElement("tr");
                                                            var pictureCell = document.createElement("td");
                                                            var nameCell = document.createElement("td");
                                                            var categoryIdCell = document.createElement("td");
                                                            var priceCell = document.createElement("td");
                                                            var quantityCell = document.createElement("td");
                                                            var btnCell = document.createElement("td");
                                                            btnCell.innerHTML = '<button type="button" class="btn btn-primary btn-update" onclick="toggleUpdateProduct(this)" data-name="' + product.name + '" data-promo="' + product.promoID + '" data-price="' + product.price + '" data-description="' + product.description + '"  data-index="' + product.id + '">Update</button>\n<button type="button" class="btn btn-danger btn-delete" onclick="deleteProduct(this)" data-index="' + product.id + '">Delete</button>'

                                                            pictureCell.innerHTML = '<img  style="width: 100px; height: 100px;object-fit: cover;" src="' + product.picURL + '" alt="Product Picture">';
                                                            nameCell.textContent = product.name;
                                                            categoryIdCell.textContent = product.categoryID;
                                                            priceCell.textContent = product.price.toLocaleString('vi-VN') + ' VND';
                                                            quantityCell.textContent = product.quantity;
                                                            newRow.appendChild(pictureCell);
                                                            newRow.appendChild(nameCell);
                                                            newRow.appendChild(categoryIdCell);
                                                            newRow.appendChild(priceCell);
                                                            newRow.appendChild(quantityCell);
                                                            newRow.appendChild(btnCell);
                                                            document.querySelector("#product-value").appendChild(newRow);
                                                        })
                                                    } else {
                                                        alert("fail")
                                                    }
                                                });
                                    }

                                    function getCookie(name) {
                                        // T?ch c?c cookie th?nh m?ng c?c c?p key-value
                                        var cookies = document.cookie.split(';');
                                        // Duy?t qua t?ng cookie ?? t?m ki?m cookie c? t?n mong mu?n
                                        for (var i = 0; i < cookies.length; i++) {
                                            var cookie = cookies[i].trim(); // Lo?i b? kho?ng tr?ng ? ??u v? cu?i

                                            // Ki?m tra xem cookie c? b?t ??u b?ng t?n mong mu?n kh?ng
                                            if (cookie.indexOf(name + '=') === 0) {
                                                // Tr? v? gi? tr? c?a cookie
                                                return cookie.substring(name.length + 1); // L?y ph?n gi? tr? c?a cookie (sau d?u '=')
                                            }
                                        }

                                        // N?u kh?ng t?m th?y cookie c? t?n mong mu?n, tr? v? null
                                        return null;
                                    }

                                    function productList() {
                                        $.ajax({
                                            method: "POST",
                                            url: "http://localhost:8080/Project_SWP391_Group4/staff/product",
                                            data: {

                                            }

                                        })
                                                .done(function (data) {

                                                    var data1 = JSON.parse(data);
                                                    document.querySelector("table tbody").innerHTML = ""
                                                    //                                            console.log(data1.data);
                                                    if (data1.isSuccess) {
                                                        var productList = data1.data;
                                                        productList.forEach(function (product) {
                                                            // T?o m?t h?ng m?i
                                                            var newRow = document.createElement("tr");
                                                            // T?o c?c ? d? li?u cho t?ng tr??ng
                                                            var pictureCell = document.createElement("td");
                                                            var nameCell = document.createElement("td");
                                                            var categoryIdCell = document.createElement("td");
                                                            var priceCell = document.createElement("td");
                                                            var quantityCell = document.createElement("td");
                                                            var btnCell = document.createElement("td");
                                                            btnCell.innerHTML = '<button type="button" class="btn btn-primary btn-update" onclick="toggleUpdateProduct(this)" data-name="' + product.name + '" data-promo="' + product.promoID + '" data-price="' + product.price + '" data-description="' + product.description + '"  data-index="' + product.id + '">Update</button>\n<button type="button" class="btn btn-danger btn-delete" onclick="deleteProduct(this)" data-index="' + product.id + '">Delete</button>'
                                                            pictureCell.innerHTML = '<img  style="width: 100px; height: 100px;object-fit: cover;" src="' + product.picURL + '" alt="Product Picture">';
                                                            nameCell.textContent = product.name;
                                                            categoryIdCell.textContent = product.categoryID;
                                                            priceCell.textContent = product.price.toLocaleString('vi-VN') + ' VND';
                                                            quantityCell.textContent = product.quantity;
                                                            // Th?m c?c ? d? li?u v?o h?ng m?i
                                                            newRow.appendChild(pictureCell);
                                                            newRow.appendChild(nameCell);
                                                            newRow.appendChild(categoryIdCell);
                                                            newRow.appendChild(priceCell);
                                                            newRow.appendChild(quantityCell);
                                                            newRow.appendChild(btnCell);
                                                            document.querySelector("#product-value").appendChild(newRow);
                                                        })
                                                    } else {
                                                        alert('fail');
                                                    }
                                                });
                                    }


                                    function deleteProduct(button) {
                                        var id = button.getAttribute('data-index');
                                        $.ajax({
                                            method: "POST",
                                            url: "http://localhost:8080/Project_SWP391_Group4/staff/product/delete",
                                            data: {
                                                id: id
                                            }
                                        })
                                                .done(function (data) {
                                                    var data1 = JSON.parse(data);
                                                    if (data1.isSuccess) {
                                                        alert('Delete successfully');
                                                        productList();
                                                    } else {
                                                        alert('Cannot be deleted because the product is in the cart or being ordered')
                                                    }
                                                })


                                    }

                                    function deleteCustomer(acc) {
                                        var username = acc.getAttribute('data-value');
                                        $.ajax({
                                            method: "POST",
                                            url: "http://localhost:8080/Project_SWP391_Group4/staff/account/delete-customer",
                                            data: {
                                                username: username
                                            }
                                        })
                                                .done(function (data) {
                                                    var data1 = JSON.parse(data);
                                                    if (data1.isSuccess) {
                                                        alert('Delete successfully');
                                                        accountList();
                                                    }
                                                })


                                    }

                                    function deleteAccount(acc) {
                                        var username = acc.getAttribute('data-value');
                                        $.ajax({
                                            method: "POST",
                                            url: "http://localhost:8080/Project_SWP391_Group4/staff/account/delete-both",
                                            data: {
                                                username: username
                                            }
                                        })
                                                .done(function (data) {
                                                    var data1 = JSON.parse(data);
                                                    if (data1.isSuccess) {
                                                        alert('Delete successfully');
                                                        accountList();
                                                    }
                                                })


                                    }

                                    function deleteStaff(acc) {
                                        var username = acc.getAttribute('data-value');
                                        $.ajax({
                                            method: "POST",
                                            url: "http://localhost:8080/Project_SWP391_Group4/staff/product/delete-staff",
                                            data: {
                                                username: username
                                            }
                                        })
                                                .done(function (data) {
                                                    var data1 = JSON.parse(data);
                                                    if (data1.isSuccess) {
                                                        alert('Delete successfully');
                                                        accountList();
                                                    }
                                                })


                                    }

                                    function accountList() {
                                        $.ajax({
                                            method: "POST",
                                            url: "http://localhost:8080/Project_SWP391_Group4/staff/account",
                                            data: {
                                            }
                                        })
                                                .done(function (data) {
                                                    var data1 = JSON.parse(data);
                                                    document.querySelector("#account-value").innerHTML = ""

                                                    var customerList = data1.data.customers;
                                                    var staffList = data1.data.staffs;
                                                    var i = 0;
                                                    if (data1.isSuccess) {
                                                        customerList.forEach(function (customer) {
                                                            var newRow = document.createElement("tr");
                                                            var numCell = document.createElement("td");
                                                            var usernameCell = document.createElement("td");
                                                            var emailCell = document.createElement("td");
                                                            var addressCell = document.createElement("td");
                                                            var fullNameCell = document.createElement("td");
                                                            var phoneNumberCell = document.createElement("td");
                                                            var btnCell = document.createElement("td");
                                                            btnCell.innerHTML = '<button class="btn btn-primary" onclick="toggleEditAcount(this)" data-email="' + customer.email + '" data-address="' + customer.address + '" data-fullName="' + customer.fullName + '" data-phone="' + customer.phoneNumber + '"  data-index="' + customer.username + '"><i class="fa-solid fa-user-pen"></i></button><button class="btn btn-danger" onclick="deleteCustomer(this)" data-value="' + customer.username + '" "><i class="bi bi-trash3-fill"></i></button>'
                                                            numCell.textContent = ++i;
                                                            usernameCell.textContent = customer.username;
                                                            emailCell.textContent = customer.email;
                                                            addressCell.textContent = customer.address;
                                                            fullNameCell.textContent = customer.fullName;
                                                            phoneNumberCell.textContent = customer.phoneNumber;
                                                            // Th?m c?c ? d? li?u v?o h?ng m?i
                                                            newRow.appendChild(numCell);
                                                            newRow.appendChild(usernameCell);
                                                            newRow.appendChild(emailCell);
                                                            newRow.appendChild(addressCell);
                                                            newRow.appendChild(fullNameCell);
                                                            newRow.appendChild(phoneNumberCell);
                                                            newRow.appendChild(btnCell);
                                                            document.querySelector("#account-value").appendChild(newRow);
                                                        })

                                                        staffList.forEach(function (staff) {
                                                            var newRow = document.createElement("tr");
                                                            var numCell = document.createElement("td");
                                                            var usernameCell = document.createElement("td");
                                                            var emailCell = document.createElement("td");
                                                            var addressCell = document.createElement("td");
                                                            var fullNameCell = document.createElement("td");
                                                            var phoneNumberCell = document.createElement("td");
                                                            var btnCell = document.createElement("td");
                                                            btnCell.innerHTML = '<button class="btn btn-primary" onclick="toggleEditAcount(this)" data-email="' + staff.email + '" data-address="' + staff.address + '" data-fullName="' + staff.fullName + '" data-phone="' + staff.phoneNumber + '"  data-index="' + staff.username + '"><i class="fa-solid fa-user-pen"></i></button><button class="btn btn-danger" onclick="deleteStaff(this)" data-value="' + staff.username + '" ><i class="bi bi-trash3-fill"></i></button>'
                                                            numCell.textContent = ++i;
                                                            usernameCell.textContent = staff.username;
                                                            emailCell.textContent = staff.email;
                                                            addressCell.textContent = staff.address;
                                                            fullNameCell.textContent = staff.fullName;
                                                            phoneNumberCell.textContent = staff.phoneNumber;
                                                            // Th?m c?c ? d? li?u v?o h?ng m?i
                                                            newRow.appendChild(numCell);
                                                            newRow.appendChild(usernameCell);
                                                            newRow.appendChild(emailCell);
                                                            newRow.appendChild(addressCell);
                                                            newRow.appendChild(fullNameCell);
                                                            newRow.appendChild(phoneNumberCell);
                                                            newRow.appendChild(btnCell);
                                                            document.querySelector("#account-value").appendChild(newRow);
                                                        })
                                                    }
                                                })
                                    }

                                    function searchAccount(e) {
                                        var input = document.getElementById('search-account').value;
                                        $.ajax({
                                            method: "POST",
                                            url: "http://localhost:8080/Project_SWP391_Group4/staff/account/search",
                                            data: {
                                                input: input
                                            }
                                        })
                                                .done(function (data) {
                                                    var data1 = JSON.parse(data);
                                                    //                                                                    console.log(data1)
                                                    if (data1.isSuccess) {
                                                        document.querySelector("#account-value").innerHTML = ""

                                                        var list = data1.data;
                                                        var i = 0;
                                                        if (data1.isSuccess) {
                                                            list.forEach(function (account) {
                                                                var newRow = document.createElement("tr");
                                                                var numCell = document.createElement("td");
                                                                var usernameCell = document.createElement("td");
                                                                var emailCell = document.createElement("td");
                                                                var addressCell = document.createElement("td");
                                                                var fullNameCell = document.createElement("td");
                                                                var phoneNumberCell = document.createElement("td");
                                                                var btnCell = document.createElement("td");
                                                                btnCell.innerHTML = '<button class="btn btn-primary" onclick="toggleEditAcount(this)"  data-email="' + account.email + '" data-address="' + account.address + '" data-fullName="' + account.fullName + '" data-phone="' + account.phoneNumber + '"  data-index="' + account.username + '"><i class="fa-solid fa-user-pen"></i></button><button class="btn btn-danger" onclick="deleteAccount(this)" data-value="' + account.username + '"><i class="bi bi-trash3-fill"></i></button>'

                                                                numCell.textContent = ++i;
                                                                usernameCell.textContent = account.username;
                                                                emailCell.textContent = account.email;
                                                                addressCell.textContent = account.address;
                                                                fullNameCell.textContent = account.fullName;
                                                                phoneNumberCell.textContent = account.phoneNumber;
                                                                // Th?m c?c ? d? li?u v?o h?ng m?i
                                                                newRow.appendChild(numCell);
                                                                newRow.appendChild(usernameCell);
                                                                newRow.appendChild(emailCell);
                                                                newRow.appendChild(addressCell);
                                                                newRow.appendChild(fullNameCell);
                                                                newRow.appendChild(phoneNumberCell);
                                                                newRow.appendChild(btnCell);
                                                                document.querySelector("#account-value").appendChild(newRow);
                                                            })
                                                        }
                                                    }
                                                }
                                                )
                                    }

                                    document.addEventListener('DOMContentLoaded', function () {
                                        const links = document.querySelectorAll('.nav-link');
                                        links.forEach(function (link) {
                                            link.addEventListener('click', function (e) {
                                                e.preventDefault();
                                                const target = this.getAttribute('data-target');
                                                //                                        console.log(target);
                                                const contentDivs = document.querySelectorAll('.main-content > div');
                                                contentDivs.forEach(function (div) {
                                                    if (div.classList.contains(target)) {
                                                        div.style.display = 'block';
                                                    } else {
                                                        div.style.display = 'none';
                                                    }
                                                });
                                                switch (target) {
                                                    case 'product-manage':
                                                        productList();
                                                        break;
                                                    case 'personal-info':
                                                        profile();
                                                        break;
                                                    case 'statistic':
                                                        break;
                                                    case 'order-manage':
                                                        break;
                                                    case 'account-manage':
                                                        accountList();
                                                        break;
                                                }
                                            });
                                        });
                                    });
                                    function doDelete(id) {
                                        if (confirm("Do you want to delete this product (" + id + ")?")) {
                                            window.location = "deleteProduct?id=" + id;
                                        }
                                    }

                                    let gender = ["Male", "Female"];
                                    let menType = ["T-shirt", "Pant", "Short"];
                                    let womenType = ["T-shirt", "Pant", "Dress"];
                                    let slct1 = document.getElementById("gender-slct");
                                    let slct2 = document.getElementById("type-slct");
                                    gender.forEach(function addGender(item) {
                                        let option = document.createElement("option");
                                        option.text = item;
                                        option.value = item;
                                        slct1.appendChild(option);
                                    });
                                    slct1.onchange = function () {
                                        slct2.innerHTML = "<option>Type</option>";
                                        if (this.value == "Male") {
                                            addToSlct2(menType);
                                        }
                                        if (this.value == "Female") {
                                            addToSlct2(womenType);
                                        }
                                    }

                                    function addToSlct2(arr) {
                                        arr.forEach(function (item) {
                                            let option = document.createElement("option");
                                            option.text = item;
                                            option.value = item;
                                            slct2.appendChild(option);
                                        });
                                    }


                                    $(document).ready(function () {
                                        $('#formDate').validate({
                                            rules: {
                                                date: {
                                                    required: true // ??m b?o m?t l?a ch?n ???c ch?n
                                                }
                                            },
                                            messages: {
                                                date: {
                                                    required: "Please choose an option." // Thông báo khi không có l?a ch?n nào ???c ch?n
                                                }
                                            }
                                        });
                                    });


            </script>

            <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
            <script>
                                    document.addEventListener('DOMContentLoaded', function () {
                                        const links = document.querySelectorAll('.nav-link');
                                        links.forEach(function (link) {
                                            link.addEventListener('click', function (e) {
                                                e.preventDefault();
                                                const target = this.getAttribute('data-target');
                                                const contentDivs = document.querySelectorAll('.main-content > div');
                                                contentDivs.forEach(function (div) {
                                                    if (div.classList.contains(target)) {
                                                        div.style.display = 'block';
                                                    } else {
                                                        div.style.display = 'none';
                                                    }
                                                });
                                            });
                                        });
                                    });



                                    const chartData = {
                                        labels: ["quarter 1", "quarter 2", "quarter 3", "quarter 4"],
                                        data: [${quarter1},${quarter2},${quarter3},${quarter4}],
                                    };
//    data: [${quarter1},${quarter2},${quarter3},${quarter4}],     

                                    const myChart = document.querySelector(".my-chart");
                                    const ul = document.querySelector(".programming-stats .details ul");

                                    new Chart(myChart, {
                                        type: "doughnut",
                                        data: {
                                            labels: chartData.labels,
                                            datasets: [
                                                {
                                                    label: "Quarter revenue",
                                                    data: chartData.data,
                                                },
                                            ],
                                        }

                                    });


                                    const ctx = document.querySelector('.my-chart-line');


                                    new Chart(ctx, {
                                        type: 'bar',
                                        data: {
                                            labels: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'],
                                            datasets: [{
                                                    label: 'monthly revenue',
                                                    data: [${revenue1},${revenue2},${revenue3},${revenue4},${revenue5},${revenue6},${revenue7},${revenue8},${revenue9},${revenue10},${revenue11},${revenue12}],
                                                    borderWidth: 1,
                                                    backgroundColor: 'rgba(231, 189, 111, 0.799)',
                                                    barThickness: 30
                                                }]
                                        },
                                        options: {
                                            scales: {
                                                y: {
                                                    beginAtZero: true
                                                }
                                            }
                                        }
                                    });

//            const populateUl = () => {
//                chartData.labels.forEach((l, i) => {
//                    let li = document.createElement("li");
//                    li.innerHTML = `${l}: <span class='percentage'>${chartData.data[i]}%</span>`;
//                    ul.appendChild(li);
//                });
//            };
//
//            populateUl();
            </script>

    </body>

</html>

