<%-- 
    Document   : staff_Voucher.jsp
    Description: Voucher Management for Staff (View Only with Date Filters)
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="entity.Staff" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="BASE_URL" value="${pageContext.request.contextPath}" />

<%
    // SECURITY CHECK: STAFF ONLY
    Staff s = (Staff) session.getAttribute("staff");
    if (s == null || !"staff".equalsIgnoreCase(s.getRole())) {
        response.sendRedirect(request.getContextPath() + (s == null ? "/login.jsp" : "/"));
        return; 
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head> 
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Staff | Voucher List</title>
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

            .main-content { padding: 20px; }
            .card-modern { background: #fff; border: none; border-radius: 15px; box-shadow: var(--card-shadow); margin-bottom: 25px; overflow: hidden; }
            .card-header-modern { background: #fff; padding: 20px 25px; border-bottom: 1px solid #e3e6f0; display: flex; justify-content: space-between; align-items: center; }
            .page-title { font-weight: 700; color: var(--primary-color); font-size: 1.5rem; display: flex; align-items: center; gap: 10px; }
            .stat-badge { background: var(--primary-light); color: var(--primary-color); padding: 5px 12px; border-radius: 20px; font-weight: 600; font-size: 0.9rem; }
            
            .filter-container { padding: 20px 25px; background-color: #fff; border-bottom: 1px solid #f0f0f0; }
            .search-input-group .input-group-text { background: transparent; border-right: none; color: #aaa; }
            .search-input-group .form-control { border-left: none; box-shadow: none; }
            .search-input-group .form-control:focus { border-color: #d1d1d1; }
            .filter-label { font-size: 0.75rem; font-weight: 700; color: #b7b9cc; text-transform: uppercase; margin-bottom: 4px; display: block; }

            .table-modern { width: 100%; margin-bottom: 0; }
            .table-modern thead th { background-color: #f8f9fc; color: #858796; font-weight: 700; text-transform: uppercase; font-size: 0.85rem; border-bottom: 2px solid #e3e6f0; padding: 15px; border-top: none; }
            .table-modern tbody td { padding: 15px; vertical-align: middle; border-bottom: 1px solid #e3e6f0; color: #5a5c69; font-size: 0.95rem; }
            .table-modern tbody tr:hover { background-color: #fcfcfc; }
            .table-blur { opacity: 0.5; pointer-events: none; transition: opacity 0.2s ease; }
            #table-loader { min-height: 200px; display: flex; align-items: center; justify-content: center; }

            .voucher-badge { background-color: #ffeeba; color: #856404; font-weight: 700; padding: 5px 12px; border-radius: 20px; font-size: 0.9rem; border: 1px solid #ffe8a1; }
            
            .pagination-wrapper { margin-top: 20px; display: flex; justify-content: flex-end; }
            .custom-pagination { display: flex; list-style: none; gap: 5px; padding: 0; }
            .custom-page-link { width: 35px; height: 35px; display: flex; align-items: center; justify-content: center; border-radius: 8px; background: #fff; border: 1px solid #e3e6f0; color: #858796; text-decoration: none; transition: all 0.2s; cursor: pointer; }
            .custom-page-link:hover { background: #f8f9fc; }
            .custom-page-item.active .custom-page-link { background: var(--primary-color); color: white; border-color: var(--primary-color); }
            
            .toast-notification { position: fixed; top: 20px; left: 50%; transform: translateX(-50%); z-index: 1060; padding: 12px 20px; border-radius: 10px; background: #fff; box-shadow: 0 5px 15px rgba(0,0,0,0.15); display: none; align-items: center; gap: 10px; border-left: 4px solid var(--primary-color); animation: slideDown 0.4s ease; }
            .toast-icon { font-size: 1.4rem; }
            .toast-text { color: #333; flex-grow: 1; }
            @keyframes slideDown { from { top: -60px; opacity: 0; } to { top: 20px; opacity: 1; } }
        </style>
    </head>

    <body id="staff-body">

        <div id="toast-message" class="toast-notification">
            <i class="fas fa-info-circle toast-icon text-primary"></i> <span id="toast-text" class="toast-text"></span>
        </div>

        <jsp:include page="staff_header-sidebar.jsp" />

        <div class="main-content">
            <div class="card-modern">
                <div class="card-header-modern">
                    <div class="page-title">
                        <i class="bi bi-tags-fill"></i> Voucher List
                        <span class="stat-badge" id="totalVouchersBadge">0 Vouchers</span>
                    </div>
                </div>

                <%-- Filter Bar --%>
                <div class="filter-container">
                    <div class="row g-2 align-items-end">
                        <%-- Search Input --%>
                        <div class="col-md-4">
                            <span class="filter-label">Search</span>
                            <div class="input-group search-input-group">
                                <span class="input-group-text"><i class="bi bi-search"></i></span>
                                <input type="text" id="liveSearchInput" class="form-control" placeholder="Search Code, Percent..." autocomplete="off">
                            </div>
                        </div>

                        <%-- [NEW] Start Date Filter --%>
                        <div class="col-md-3">
                            <span class="filter-label">Start From</span>
                            <input type="date" id="startDateFilter" class="form-control">
                        </div>

                        <%-- [NEW] End Date Filter --%>
                        <div class="col-md-3">
                            <span class="filter-label">End To</span>
                            <input type="date" id="endDateFilter" class="form-control">
                        </div>

                        <%-- [NEW] Reset Button --%>
                        <div class="col-md-2">
                            <button onclick="resetFilters()" class="btn btn-light border w-100 text-muted" title="Reset Filters">
                                <i class="bi bi-arrow-counterclockwise me-1"></i> Reset
                            </button>
                        </div>
                    </div>
                </div>

                <div id="table-loader">
                    <div class="spinner-border text-secondary" role="status"><span class="visually-hidden">Loading...</span></div>
                </div>

                <div id="voucher-content-container" style="display: none;">
                    <div class="table-responsive">
                        <table class="table table-modern align-middle" id="voucherTableMain">
                            <thead>
                                <tr>
                                    <th width="30%">Code (ID)</th>
                                    <th width="20%">Discount</th>
                                    <th width="25%">Start Date</th>
                                    <th width="25%">End Date</th>
                                </tr>
                            </thead>
                            <tbody id="tableBody"></tbody>
                        </table>
                    </div>
                    <div class="pagination-wrapper px-4 pb-3" id="paginationContainer"></div>
                </div> 
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>

        <script>
            const BASE_URL = '${BASE_URL}';
            let currentPage = 1;
            let currentSearch = "";
            // [NEW] Date Variables
            let currentStart = "";
            let currentEnd = "";

            function toggleTableBlur(active) {
                if(active) $('#voucherTableMain tbody').addClass('table-blur');
                else $('#voucherTableMain tbody').removeClass('table-blur');
            }

            function showToast(message) {
                const toast = $('#toast-message');
                const text = $('#toast-text');
                text.text(message);
                toast.addClass('active');
                setTimeout(() => { toast.removeClass('active'); }, 3000);
            }

            function formatDateForDisplay(dateString) {
                if (!dateString) return "";
                const d = new Date(dateString);
                if (isNaN(d.getTime())) return "";
                return d.toLocaleDateString('en-GB'); 
            }

            function fetchVouchers(page = 1) {
                currentPage = page;
                toggleTableBlur(true);

                $.ajax({
                    url: BASE_URL + '/staff/voucher/data',
                    type: 'GET',
                    // [NEW] Added startDate and endDate parameters
                    data: { 
                        page: page, 
                        search: currentSearch,
                        startDate: currentStart,
                        endDate: currentEnd
                    },
                    dataType: 'json',
                    success: function(response) {
                        renderTable(response.list);
                        renderPagination(response.totalPages, response.currentPage);
                        $('#totalVouchersBadge').text(response.totalItems + " Vouchers");
                        setTimeout(() => { toggleTableBlur(false); }, 150);
                    },
                    error: function() {
                        showToast('Failed to load data');
                        toggleTableBlur(false);
                    }
                });
            }

            function renderTable(list) {
                const tbody = $('#tableBody');
                tbody.empty();
                if (!list || list.length === 0) {
                    tbody.append('<tr><td colspan="4" class="text-center py-4 text-muted">No vouchers found.</td></tr>');
                    return;
                }
                
                list.forEach(p => {
                    const displayStart = formatDateForDisplay(p.startDate);
                    const displayEnd = formatDateForDisplay(p.endDate);

                    const row = `
                        <tr>
                            <td class="fw-bold" style="color: var(--primary-color);">\${p.voucherID}</td>
                            <td><span class="voucher-badge">\${p.voucherPercent}% OFF</span></td>
                            <td><i class="bi bi-calendar-event me-2 text-muted"></i>\${displayStart}</td>
                            <td><i class="bi bi-calendar-check me-2 text-muted"></i>\${displayEnd}</td>
                        </tr>
                    `;
                    tbody.append(row);
                });
            }

            function renderPagination(totalPages, current) {
                const container = $('#paginationContainer');
                container.empty();
                if (totalPages <= 1) return;

                let html = '<ul class="custom-pagination">';
                html += `<li class="custom-page-item \${current == 1 ? 'disabled' : ''}">
                            <a class="custom-page-link" onclick="fetchVouchers(\${current - 1})"><i class="bi bi-chevron-left"></i></a>
                         </li>`;
                
                for (let i = 1; i <= totalPages; i++) {
                    html += `<li class="custom-page-item \${i == current ? 'active' : ''}">
                                <a class="custom-page-link" onclick="fetchVouchers(\${i})">\${i}</a>
                             </li>`;
                }

                html += `<li class="custom-page-item \${current == totalPages ? 'disabled' : ''}">
                            <a class="custom-page-link" onclick="fetchVouchers(\${current + 1})"><i class="bi bi-chevron-right"></i></a>
                         </li>`;
                
                html += '</ul>';
                container.html(html);
            }

            // [NEW] Reset function
            function resetFilters() {
                $('#liveSearchInput').val('');
                $('#startDateFilter').val('');
                $('#endDateFilter').val('');
                
                currentSearch = "";
                currentStart = "";
                currentEnd = "";
                
                fetchVouchers(1);
            }

            document.addEventListener("DOMContentLoaded", function () {
                setTimeout(function() {
                    $('#table-loader').fadeOut(200, function() {
                        $('#voucher-content-container').fadeIn(200);
                        fetchVouchers(1);
                    });
                }, 400);

                let searchTimeout;
                $('#liveSearchInput').on('input', function() {
                    currentSearch = $(this).val();
                    toggleTableBlur(true);
                    clearTimeout(searchTimeout);
                    searchTimeout = setTimeout(() => { fetchVouchers(1); }, 300);
                });

                // [NEW] Date filter listeners
                $('#startDateFilter, #endDateFilter').on('change', function() {
                    currentStart = $('#startDateFilter').val();
                    currentEnd = $('#endDateFilter').val();
                    toggleTableBlur(true);
                    fetchVouchers(1); // Reset to page 1 on filter change
                });
            });
                        $(document).ready(function() {
                // 1. Xóa class active ở các li khác (nếu cần thiết, để tránh duplicate)
                $('.nav-list li').removeClass('active');
                
                // 2. Tìm thẻ li có data-target='product-manage' và thêm class active
                $('.nav-list li[data-target="voucher-list"]').addClass('active');
            });
        </script>
    </body>
</html>