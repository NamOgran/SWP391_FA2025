<%-- 
    Document   : staff_Customer.jsp
    Description: Customer List for Staff (Read-Only Mode)
--%>
<%@page import="entity.Staff"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="BASE_URL" value="${pageContext.request.contextPath}" />

<%
    // SECURITY CHECK: STAFF ONLY
    Staff s = (Staff) session.getAttribute("staff");
    if (s == null || !"staff".equalsIgnoreCase(s.getRole())) {
        if (s == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        } else {
            // Nếu là admin thì về trang admin, user thường về trang chủ
            if("admin".equalsIgnoreCase(s.getRole())){
                 response.sendRedirect(request.getContextPath() + "/admin");
            } else {
                 response.sendRedirect(request.getContextPath() + "/"); 
            }
        }
        return; 
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff | Customer Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://kit.fontawesome.com/1bd876819f.js" crossorigin="anonymous"></script>
    <link href='https://fonts.googleapis.com/css?family=Quicksand:400,500,600,700&display=swap' rel='stylesheet'>
    <link rel="icon" href="${BASE_URL}/images/LG2.png" type="image/x-icon">

    <style>
        /* --- STAFF THEME (Milky Brown) --- */
        :root {
            --primary-color: #795548;       /* Staff Brown */
            --primary-light: rgba(121, 85, 72, 0.1);
            --secondary-color: #858796;
            --success-color: #1cc88a;
            --info-color: #36b9cc;
            --warning-color: #f6c23e;
            --danger-color: #e74a3b;
            --light-bg: #f4f7f6;
            --card-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.1);
        }

        body { font-family: 'Quicksand', sans-serif; background-color: var(--light-bg); color: #5a5c69; }

        /* --- CARD & GENERAL --- */
        .card-modern { background: #fff; border: none; border-radius: 15px; box-shadow: var(--card-shadow); margin-bottom: 25px; overflow: hidden; }
        .card-header-modern { background: #fff; padding: 20px 25px; border-bottom: 1px solid #e3e6f0; display: flex; justify-content: space-between; align-items: center; }
        .page-title { font-weight: 700; color: var(--primary-color); font-size: 1.5rem; display: flex; align-items: center; gap: 10px; }
        .stat-badge { background: var(--primary-light); color: var(--primary-color); padding: 5px 12px; border-radius: 20px; font-weight: 600; font-size: 0.9rem; }
        .filter-container { padding: 20px 25px; background-color: #fff; border-bottom: 1px solid #f0f0f0; }
        .search-input-group .input-group-text { background: transparent; border-right: none; color: #aaa; }
        .search-input-group .form-control { border-left: none; box-shadow: none; }
        .search-input-group .form-control:focus { border-color: #d1d1d1; }

        /* --- TABLE STYLES --- */
        .table-modern { width: 100%; margin-bottom: 0; table-layout: fixed; }
        .table-modern thead th { background-color: #f8f9fc; color: #858796; font-weight: 700; text-transform: uppercase; font-size: 0.85rem; border-bottom: 2px solid #e3e6f0; padding: 15px; border-top: none; }
        .table-modern tbody td { padding: 15px; vertical-align: middle; border-bottom: 1px solid #e3e6f0; color: #5a5c69; font-size: 0.95rem; }
        .table-modern tbody tr:hover { background-color: #fcfcfc; }
        
        /* Blur Effect */
        .table-blur { opacity: 0.5; pointer-events: none; transition: opacity 0.2s ease; }
        /* Loader */
        #table-loader { min-height: 200px; display: flex; align-items: center; justify-content: center; }

        /* --- TRUNCATION HELPERS --- */
        .text-truncate-2 { 
            display: -webkit-box; 
            -webkit-line-clamp: 2; 
            -webkit-box-orient: vertical; 
            overflow: hidden; 
            text-overflow: ellipsis; 
            white-space: normal; 
            line-height: 1.4;
        }
        .cell-truncate { white-space: nowrap; overflow: hidden; text-overflow: ellipsis; display: block; }

        /* --- AVATAR & INFO --- */
        .avatar-circle { width: 45px; height: 45px; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-weight: bold; font-size: 1.2rem; margin-right: 15px; text-transform: uppercase; flex-shrink: 0; }
        .user-profile { display: flex; align-items: center; overflow: hidden; }
        .user-info { overflow: hidden; }
        .user-info .name { font-weight: 700; color: var(--primary-color); font-size: 1rem; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .user-info .sub-text { font-size: 0.85rem; color: #858796; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        
        /* --- ACTION GRID BUTTONS --- */
        .action-grid { display: flex; justify-content: center; gap: 8px; }
        .btn-soft { border: none; border-radius: 6px; width: 36px; height: 36px; display: inline-flex; align-items: center; justify-content: center; transition: all 0.2s; }
        
        /* Info Button (Brown Theme) */
        .btn-soft-info { background: rgba(141, 110, 99, 0.1); color: #8D6E63; }
        .btn-soft-info:hover { background: #8D6E63; color: #fff; }

        .btn-soft-gray { background: rgba(108, 117, 125, 0.15); color: #6c757d; }
        .btn-soft-gray:hover { background: #6c757d; color: #fff; transform: translateY(-2px); box-shadow: 0 3px 8px rgba(108, 117, 125, 0.25); }
        .btn-soft-gray.active { background: #6c757d; color: #fff; box-shadow: inset 0 2px 4px rgba(0,0,0,0.2); }

        /* --- MODAL --- */
        .modal-content-modern { border-radius: 15px; border: none; overflow: hidden; }
        .modal-header-modern { padding: 15px 20px; border-bottom: 1px solid #eee; }
        
        /* --- PAGINATION --- */
        .pagination-wrapper { margin-top: 20px; display: flex; justify-content: flex-end; }
        .custom-pagination { display: flex; list-style: none; gap: 5px; padding: 0; }
        .custom-page-link { width: 35px; height: 35px; display: flex; align-items: center; justify-content: center; border-radius: 8px; background: #fff; border: 1px solid #e3e6f0; color: #858796; text-decoration: none; transition: all 0.2s; cursor: pointer; }
        .custom-page-link:hover { background: #f8f9fc; }
        .custom-page-item.active .custom-page-link { background: var(--primary-color); color: white; border-color: var(--primary-color); }

        /* Toasts */
        .toast-notification { position: fixed; top: 20px; left: 50%; transform: translateX(-50%); z-index: 1060; padding: 12px 20px; border-radius: 10px; background: #fff; box-shadow: 0 5px 15px rgba(0,0,0,0.15); display: none; align-items: center; gap: 10px; border-left: 4px solid var(--primary-color); animation: slideDown 0.4s ease; }
        @keyframes slideDown { from { top: -50px; opacity: 0; } to { top: 20px; opacity: 1; } }
    </style>
</head>

<body id="staff-body">
    
    <div id="toast-message" class="toast-notification">
        <i class="bi bi-info-circle-fill" style="color: var(--primary-color);"></i>
        <span id="toast-text" class="fw-bold text-dark">Notification</span>
    </div>

    <jsp:include page="staff_header-sidebar.jsp" />

    <div class="main-content p-4">
        
        <div class="card-modern">
            <div class="card-header-modern">
                <div class="page-title">
                    <i class="bi bi-people-fill"></i> Customer Management
                    <span class="stat-badge"><c:out value="${custTotal}" default="0"/> Customers</span>
                </div>
                </div>

            <div class="filter-container">
                <div class="row g-2">
                    <div class="col-md-3">
                        <div class="input-group search-input-group">
                            <span class="input-group-text"><i class="bi bi-search"></i></span>
                            <input type="text" id="sUser" class="form-control" placeholder="Search Username...">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="input-group search-input-group">
                            <span class="input-group-text"><i class="bi bi-person"></i></span>
                            <input type="text" id="sName" class="form-control" placeholder="Search Fullname...">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="input-group search-input-group">
                            <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                            <input type="text" id="sEmail" class="form-control" placeholder="Search Email...">
                        </div>
                    </div>
                    <div class="col-md-2">
                         <div class="input-group search-input-group">
                            <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                            <input type="text" id="sPhone" class="form-control" placeholder="Phone...">
                        </div>
                    </div>
                    <div class="col-md-1 text-end">
                        <button class="btn btn-light border w-100 text-muted" onclick="resetFilters()" title="Reset Filters"><i class="bi bi-arrow-counterclockwise"></i></button>
                    </div>
                </div>
            </div>

            <%-- Table Loader --%>
            <div id="table-loader">
                <div class="spinner-border text-secondary" role="status"><span class="visually-hidden">Loading...</span></div>
            </div>

            <%-- Hidden initially --%>
            <div id="customer-content-container" style="display: none;">
                <div class="table-responsive">
                    <table class="table table-modern align-middle" id="customer-table">
                        <thead>
                            <tr>
                                <th style="width: 8%">ID</th>
                                <th style="width: 25%">Customer Profile</th>
                                <th style="width: 25%">Contact Info</th>
                                <th style="width: 27%">Address</th>
                                <th style="width: 15%" class="text-center">Actions</th>
                            </tr>
                        </thead>
                        <tbody id="customer-table-body">
                            <c:forEach items="${customerList}" var="c">
                                <tr class="customer-summary-row" id="row-${c.customer_id}">
                                    <td class="fw-bold text-muted" data-id="${c.customer_id}">C-${c.customer_id}</td>
                                    <td>
                                        <div class="user-profile">
                                            <div class="avatar-circle" data-name="${c.username}"></div>
                                            <div class="user-info">
                                                <div class="name user-username" title="${c.username}">${c.username}</div>
                                                <div class="sub-text user-fullname" title="${c.fullName}">${c.fullName}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="d-flex flex-column" style="max-width: 100%;">
                                            <small class="cell-truncate text-muted user-email" title="${c.email}">
                                                <i class="bi bi-envelope me-2"></i>${c.email}
                                            </small>
                                            <small class="cell-truncate text-muted user-phone" title="${c.phoneNumber}">
                                                <i class="bi bi-telephone me-2"></i>${c.phoneNumber}
                                            </small>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="text-truncate-2 text-muted small user-address" title="${c.address}">
                                            ${c.address}
                                        </div>
                                    </td>
                                    <td class="text-center">
                                        <div class="action-grid">
                                            <%-- No Edit Button for Staff --%>
                                            
                                            <button class="btn-soft btn-soft-info" title="View Details" 
                                                    onclick="openInfoModal('${c.customer_id}', '${c.username}', '${c.fullName}', '${c.email}', '${c.phoneNumber}', '${c.address}', '${c.google_id}')">
                                                <i class="bi bi-info-circle"></i>
                                            </button>

                                            <button class="btn-soft btn-soft-gray btn-history" onclick="viewOrderHistory(${c.customer_id}, '${c.username}', '${c.fullName}')" title="Order History">
                                                <i class="bi bi-clock-history"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                <div id="customer-pagination" class="pagination-wrapper px-4 pb-3"></div>
            </div>
        </div>
    </div>

    <%-- MODAL VIEW INFO --%>
    <div class="modal fade" id="customerInfoModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content modal-content-modern shadow-lg">
                <div class="modal-body p-0">
                    <div class="p-4 text-white text-center position-relative" style="background: var(--primary-color);">
                        <button type="button" class="btn-close btn-close-white position-absolute top-0 end-0 m-3" data-bs-dismiss="modal"></button>
                        <div class="avatar-circle mx-auto mb-3 border border-3 border-white" id="modal-avatar" style="width: 80px; height: 80px; font-size: 2.5rem; background: rgba(255,255,255,0.2);"></div>
                        <h4 id="modal-username" class="fw-bold mb-1"></h4>
                        <div id="modal-id" class="badge bg-light text-dark rounded-pill px-3"></div>
                    </div>
                    <div class="p-4">
                        <div class="d-flex justify-content-between border-bottom py-2"><span class="text-muted fw-bold">Full Name:</span> <span id="modal-fullname" class="text-dark text-end"></span></div>
                        <div class="d-flex justify-content-between border-bottom py-2"><span class="text-muted fw-bold">Email:</span> <span id="modal-email" class="text-dark text-end text-break" style="max-width: 250px;"></span></div>
                        <div class="d-flex justify-content-between border-bottom py-2"><span class="text-muted fw-bold">Phone:</span> <span id="modal-phone" class="text-dark text-end"></span></div>
                        <div class="py-2"><span class="text-muted fw-bold d-block mb-1">Address:</span> <span id="modal-addr" class="text-dark bg-light p-2 rounded d-block text-break"></span></div>
                        <div class="py-2 text-center text-muted small mt-2 border-top pt-3">Google ID: <span id="modal-google"></span></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <%-- MODAL ORDER HISTORY WITH PAGINATION --%>
    <div class="modal fade" id="orderHistoryModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content modal-content-modern">
                <div class="modal-header-modern d-flex justify-content-between align-items-center">
                    <div>
                        <h5 class="fw-bold mb-1"><i class="bi bi-clock-history me-2"></i> Order History</h5>
                        <small class="text-muted" id="history-customer-name">Loading...</small>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div id="history-loader" class="text-center py-5">
                        <div class="spinner-border text-secondary" role="status"></div>
                        <p class="mt-2 text-muted">Loading orders...</p>
                    </div>
                    <div id="history-content" style="display:none;">
                        <div class="table-responsive">
                            <table class="table table-bordered table-hover align-middle mb-0">
                                <thead class="bg-light text-secondary">
                                    <tr>
                                        <th style="width: 15%">Order ID</th>
                                        <th style="width: 30%">Date</th>
                                        <th style="width: 25%">Status</th>
                                        <th style="width: 30%" class="text-end">Total</th>
                                    </tr>
                                </thead>
                                <tbody id="history-table-body">
                                    </tbody>
                            </table>
                        </div>
                        <div id="history-pagination" class="pagination-wrapper pt-3 justify-content-center">
                            </div>
                    </div>
                    <div id="history-empty" class="text-center py-5 text-muted" style="display:none;">
                        <i class="bi bi-inbox fs-1 d-block mb-2 text-gray-300"></i>
                        No order history found for this customer.
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>

    <script>
        // --- UTILS: TOAST & AVATAR ---
        function showToast(msg, type = 'success') {
            const toast = $('#toast-message');
            const icon = toast.find('i');
            toast.find('#toast-text').text(msg);
            toast.css('border-left-color', type === 'error' ? '#e74a3b' : '#795548');
            icon.attr('class', type === 'error' ? 'bi bi-exclamation-circle-fill text-danger' : 'bi bi-check-circle-fill text-success');
            toast.fadeIn().delay(3000).fadeOut();
        }

        function stringToColor(str) {
            let hash = 0;
            for (let i = 0; i < str.length; i++) hash = str.charCodeAt(i) + ((hash << 5) - hash);
            const c = (hash & 0x00FFFFFF).toString(16).toUpperCase();
            return "#" + "00000".substring(0, 6 - c.length) + c;
        }

        function initAvatars() {
            $('.avatar-circle').each(function() {
                const name = $(this).data('name') || "U";
                const initial = name.charAt(0).toUpperCase();
                $(this).css('background-color', stringToColor(name)).text(initial);
            });
        }
        
        // Blur Table Function
        function toggleTableBlur(active) {
            if(active) $('#customer-table tbody').addClass('table-blur');
            else $('#customer-table tbody').removeClass('table-blur');
        }

        // --- INIT & FILTER ---
        let allRowsData = [], filteredRows = [], currentPage = 1, perPage = 8;

        document.addEventListener("DOMContentLoaded", function() {
            setTimeout(function() {
                $('#table-loader').fadeOut(200, function() {
                    $('#customer-content-container').fadeIn(200);
                    initPagination();
                    initAvatars();
                });
            }, 400);

            $('#sUser, #sName, #sEmail, #sPhone').on('input', function() { 
                toggleTableBlur(true);
                setTimeout(() => {
                    applyFilters(); 
                    toggleTableBlur(false);
                }, 200);
            });
        });

        function initPagination() {
            let tbody = document.getElementById('customer-table-body');
            let rows = tbody.querySelectorAll('.customer-summary-row');
            allRowsData = [];
            
            rows.forEach(r => {
                let dID = r.querySelector('[data-id]').getAttribute('data-id');
                let dUser = r.querySelector('.user-username').innerText.toLowerCase();
                let dName = r.querySelector('.user-fullname').innerText.toLowerCase();
                let dEmail = r.querySelector('.user-email').innerText.toLowerCase(); 
                let dPhone = r.querySelector('.user-phone').innerText.toLowerCase();
                let dAddr = r.querySelector('.user-address').innerText.toLowerCase();

                allRowsData.push({ 
                    summary: r, 
                    data: { id: dID, user: dUser, name: dName, email: dEmail, phone: dPhone, addr: dAddr }
                });
            });
            filteredRows = allRowsData;
            renderPage(1);
        }

        function applyFilters() {
            let vUser = $('#sUser').val().toLowerCase();
            let vName = $('#sName').val().toLowerCase();
            let vEmail = $('#sEmail').val().toLowerCase();
            let vPhone = $('#sPhone').val().toLowerCase();

            filteredRows = allRowsData.filter(item => {
                let d = item.data;
                return (!vUser || d.user.includes(vUser)) &&
                        (!vName || d.name.includes(vName)) &&
                        (!vEmail || d.email.includes(vEmail)) &&
                        (!vPhone || d.phone.includes(vPhone));
            });
            renderPage(1);
        }

        function resetFilters() {
            toggleTableBlur(true);
            setTimeout(() => {
                $('.filter-container input').val('');
                applyFilters();
                toggleTableBlur(false);
            }, 200);
        }

        function renderPage(page) {
            currentPage = page;
            allRowsData.forEach(item => { item.summary.style.display = 'none'; });

            let start = (page - 1) * perPage;
            let end = start + perPage;
            let pageItems = filteredRows.slice(start, end);

            pageItems.forEach(r => { r.summary.style.display = 'table-row'; });

            let total = Math.ceil(filteredRows.length / perPage);
            let html = '<ul class="custom-pagination">';
            if(total > 1) {
                if(page > 1) html += `<li class="custom-page-item"><a class="custom-page-link" href="#" onclick="changePage(event, \${page-1})"><i class="bi bi-chevron-left"></i></a></li>`;
                for(let i=1; i<=total; i++) {
                      if (i === 1 || i === total || (i >= page - 1 && i <= page + 1)) {
                        html += `<li class="custom-page-item \${i===currentPage?'active':''}"><a class="custom-page-link" href="#" onclick="changePage(event, \${i})">\${i}</a></li>`;
                    } else if (i === page - 2 || i === page + 2) {
                        html += `<li class="custom-page-item"><span class="custom-page-link border-0">...</span></li>`;
                    }
                }
                if(page < total) html += `<li class="custom-page-item"><a class="custom-page-link" href="#" onclick="changePage(event, \${page+1})"><i class="bi bi-chevron-right"></i></a></li>`;
            }
            html += '</ul>';
            if(filteredRows.length === 0) html = '<div class="text-center text-muted py-3 w-100">No customers found.</div>';
            document.getElementById('customer-pagination').innerHTML = html;
        }

        function changePage(e, page) {
            if(e) e.preventDefault(); 
            toggleTableBlur(true);
            setTimeout(() => {
                renderPage(page);
                toggleTableBlur(false);
            }, 150);
        }

        // --- HISTORY MODAL & PAGINATION LOGIC ---
        let currentHistoryData = [];
        let currentHistoryPage = 1;
        const historyPerPage = 10;

        // Note: URL must be handled in StaffController to support 'get_customer_orders'
        // If StaffController doesn't have it, we might need to route to AdminController 
        // or add logic to StaffController.
        // Assuming StaffController handles this or we reuse AdminController's endpoint if permitted.
        // BUT staff usually cannot access /admin.
        // -> Need to add 'get_customer_orders' logic to StaffController.
        
        function viewOrderHistory(custId, username, fullname) {
            $('#history-customer-name').text(username + ' - ' + fullname);
            
            $('#history-loader').show();
            $('#history-content').hide();
            $('#history-empty').hide();
            
            const historyModal = new bootstrap.Modal(document.getElementById('orderHistoryModal'));
            historyModal.show();

            // Using /staff URL assuming StaffController handles this action
            $.post('${BASE_URL}/staff/customer/detail', { action: 'get_customer_orders', id: custId }, function(res) {
                $('#history-loader').hide();
                if (res.isSuccess && res.data && res.data.length > 0) {
                    currentHistoryData = res.data;
                    currentHistoryPage = 1;
                    renderHistoryTable();
                    $('#history-content').fadeIn();
                } else {
                    $('#history-empty').fadeIn();
                }
            }, 'json').fail(function() {
                $('#history-loader').hide();
                $('#history-empty').html('<span class="text-danger">Failed to load data.</span>').show();
            });
        }

        function renderHistoryTable() {
            let tbody = $('#history-table-body');
            tbody.empty();

            let start = (currentHistoryPage - 1) * historyPerPage;
            let end = start + historyPerPage;
            let pageItems = currentHistoryData.slice(start, end);

            pageItems.forEach(o => {
                let badge = 'bg-secondary';
                if(o.status === 'Completed' || o.status === 'Delivered') badge = 'bg-success';
                else if(o.status === 'Cancelled') badge = 'bg-danger';
                else if(o.status === 'Pending' || o.status === 'Processing') badge = 'bg-warning text-dark';
                else if(o.status === 'Delivering') badge = 'bg-info text-dark';

                let row = `
                    <tr>
                        <td class="fw-bold">#\${o.order_id}</td>
                        <td>\${o.dateString}</td>
                        <td><span class="badge \${badge} rounded-pill">\${o.status}</span></td>
                        <td class="text-end fw-bold text-primary">\${o.totalString}</td>
                    </tr>
                `;
                tbody.append(row);
            });
            renderHistoryPagination();
        }

        function renderHistoryPagination() {
            let total = Math.ceil(currentHistoryData.length / historyPerPage);
            let container = $('#history-pagination');
            if(total <= 1) {
                container.empty();
                return;
            }

            let html = '<ul class="custom-pagination">';
            
            if(currentHistoryPage > 1) {
                html += `<li class="custom-page-item"><a class="custom-page-link" href="#" onclick="changeHistoryPage(event, \${currentHistoryPage-1})"><i class="bi bi-chevron-left"></i></a></li>`;
            }

            for(let i=1; i<=total; i++) {
                if (i === 1 || i === total || (i >= currentHistoryPage - 1 && i <= currentHistoryPage + 1)) {
                      html += `<li class="custom-page-item \${i===currentHistoryPage?'active':''}"><a class="custom-page-link" href="#" onclick="changeHistoryPage(event, \${i})">\${i}</a></li>`;
                } else if (i === currentHistoryPage - 2 || i === currentHistoryPage + 2) {
                    html += `<li class="custom-page-item"><span class="custom-page-link border-0">...</span></li>`;
                }
            }

            if(currentHistoryPage < total) {
                html += `<li class="custom-page-item"><a class="custom-page-link" href="#" onclick="changeHistoryPage(event, \${currentHistoryPage+1})"><i class="bi bi-chevron-right"></i></a></li>`;
            }
            html += '</ul>';
            container.html(html);
        }

        function changeHistoryPage(e, page) {
            if(e) {
                e.preventDefault(); 
                e.stopPropagation(); 
            }
            currentHistoryPage = page;
            renderHistoryTable();
        }

        function openInfoModal(id, user, name, email, phone, addr, google) {
            $('#modal-id').text('C-' + id);
            $('#modal-username').text(user);
            $('#modal-fullname').text(name);
            $('#modal-email').text(email);
            $('#modal-phone').text(phone);
            $('#modal-addr').text(addr);
            $('#modal-google').text((google && google !== 'null') ? google : 'Not linked');
            $('#modal-avatar').text(user.charAt(0).toUpperCase()).css('background-color', stringToColor(user));
            new bootstrap.Modal(document.getElementById('customerInfoModal')).show();
        }
                    $(document).ready(function() {
                // 1. Xóa class active ở các li khác (nếu cần thiết, để tránh duplicate)
                $('.nav-list li').removeClass('active');
                
                // 2. Tìm thẻ li có data-target='product-manage' và thêm class active
                $('.nav-list li[data-target="customer-list"]').addClass('active');
            });
    </script>
</body>
</html>