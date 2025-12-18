<%-- 
    Document    : staff_Import.jsp
    Description : Import Management for Staff (Updated: Full Filters + AJAX Reload + Validations)
--%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="entity.Product"%>
<%@page import="java.util.List"%>
<%@page import="entity.Staff"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="BASE_URL" value="${pageContext.request.contextPath}" />
<%
    Staff s = (Staff) session.getAttribute("staff");
    if (s == null || !"staff".equalsIgnoreCase(s.getRole())) {
        response.sendRedirect(request.getContextPath() + (s == null ? "/login.jsp" : "/"));
        return; 
    }

    // --- PREPARE PRODUCT MAP FOR QUICK LOOKUP IN DETAILS ---
    List<Product> pList = (List<Product>) request.getAttribute("productList");
    Map<Integer, Product> prodMap = new HashMap<>();
    if(pList != null) {
        for(Product p : pList) {
            prodMap.put(p.getId(), p);
        }
    }
    request.setAttribute("prodMap", prodMap);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff | Import Management</title>
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
            --light-bg: #f4f7f6;
            --card-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.1);
        }
        body { font-family: 'Quicksand', sans-serif; background-color: var(--light-bg); color: #5a5c69; }

        /* --- UI ELEMENTS --- */
        .main-content { padding: 20px; }
        .card-modern { background: #fff; border: none; border-radius: 15px; box-shadow: var(--card-shadow); margin-bottom: 25px; overflow: hidden; }
        .card-header-modern { background: #fff; padding: 20px 25px; border-bottom: 1px solid #e3e6f0; display: flex; justify-content: space-between; align-items: center; }
        .page-title { font-weight: 700; color: var(--primary-color); font-size: 1.5rem; display: flex; align-items: center; gap: 10px; }
        .stat-badge { background: var(--primary-light); color: var(--primary-color); padding: 5px 12px; border-radius: 20px; font-weight: 600; font-size: 0.9rem; }
        
        /* Filter Bar */
        .filter-container { padding: 20px 25px; background-color: #fff; border-bottom: 1px solid #f0f0f0; }
        .search-input-group .input-group-text { background: transparent; border-right: none; color: #aaa; }
        .search-input-group .form-control { border-left: none; box-shadow: none; }
        .search-input-group .form-control:focus { border-color: #d1d1d1; }
        .form-label-small { font-size: 0.8rem; font-weight: 700; color: #b7b9cc; text-transform: uppercase; margin-bottom: 5px; display: block; }

        /* --- TABLE --- */
        .table-modern { width: 100%; margin-bottom: 0; }
        .table-modern thead th { background-color: #f8f9fc; color: #858796; font-weight: 700; text-transform: uppercase; font-size: 0.85rem; border-bottom: 2px solid #e3e6f0; padding: 15px; border-top: none; }
        .table-modern tbody td { padding: 15px; vertical-align: middle; border-bottom: 1px solid #e3e6f0; color: #5a5c69; font-size: 0.95rem; }
        .table-modern tbody tr:hover { background-color: #fcfcfc; }
        .table-blur { opacity: 0.4; pointer-events: none; transition: opacity 0.2s ease; filter: blur(1px); }
        #table-loader { min-height: 200px; display: flex; align-items: center; justify-content: center; }
        
        /* Highlight Selected Row */
        .table-modern tr.selected-row td { background-color: #fdf2ef !important; border-top: 2px solid var(--primary-color); border-bottom: none; }
        .table-modern tr.selected-row td:first-child { border-left: 2px solid var(--primary-color); }
        .table-modern tr.selected-row td:last-child { border-right: 2px solid var(--primary-color); }

        /* --- PRODUCT INFO IN DETAIL --- */
        .product-img-thumb { width: 50px; height: 50px; object-fit: cover; border-radius: 6px; border: 1px solid #eee; margin-right: 10px; }
        .product-name-cell { font-weight: 600; color: #333; display: block; line-height: 1.2; }
        .product-meta-cell { font-size: 0.8rem; color: #888; display: flex; align-items: center; margin-top: 4px; }

        /* --- BADGES & BUTTONS --- */
        .status-badge { padding: 5px 12px; border-radius: 20px; font-size: 0.85rem; font-weight: 700; }
        .badge-pending { background: #fff3cd; color: #856404; }
        .badge-delivered, .badge-done, .badge-confirmed { background: #d1e7dd; color: #0f5132; }
        .badge-cancelled { background: #f8d7da; color: #842029; }

        .btn-soft { border: none; border-radius: 8px; width: 32px; height: 32px; display: inline-flex; align-items: center; justify-content: center; transition: all 0.2s; margin: 0 2px; cursor: pointer; }
        .btn-soft:hover { transform: translateY(-2px); }
        .btn-soft-secondary { background: rgba(121, 85, 72, 0.15); color: #795548; } 
        .btn-soft-secondary:hover { background: #795548; color: #fff; }
        .btn-soft-secondary.active { background: #795548; color: #fff; transform: rotate(180deg); }
        
        .btn-add-new { background: linear-gradient(45deg, #795548, #5D4037); border: none; box-shadow: 0 4px 10px rgba(121, 85, 72, 0.3); color: white; padding: 10px 20px; border-radius: 10px; font-weight: 600; transition: transform 0.2s; }
        .btn-add-new:hover { transform: translateY(-2px); color: whitesmoke !important; }

        /* --- DETAIL ROW --- */
        .detail-row-container { background-color: #f8f9fc; padding: 20px; box-shadow: inset 0 0 10px rgba(0,0,0,0.05); }
        .detail-card { background: #fff; border-radius: 10px; border: 1px solid #e3e6f0; overflow: hidden; }
        .detail-header { background: #795548; color: white; padding: 10px 15px; font-weight: 600; display: flex; align-items: center; gap: 10px; }

        /* --- MODAL --- */
        .modal-content-modern { border-radius: 15px; border: none; overflow: hidden; }
        .modal-header-modern { background: #f8f9fc; padding: 20px; border-bottom: 1px solid #eee; }
        .form-control-modern { border-radius: 8px; padding: 10px; border: 1px solid #d1d3e2; }
        .btn-add-item { width: 100%; height: 42px; background: #2c3e50; color: white; font-weight: 600; border-radius: 8px; border: none; transition: 0.2s; }
        .btn-add-item:hover { background: #1a252f; }
        .import-list-box { max-height: 250px; overflow-y: auto; border: 1px solid #e3e6f0; border-radius: 8px; margin-top: 15px; }

        /* --- PAGINATION & TOAST --- */
        .pagination-wrapper { margin-top: 20px; display: flex; justify-content: flex-end; }
        .custom-pagination { display: flex; list-style: none; gap: 5px; padding: 0; }
        .custom-page-link { width: 35px; height: 35px; display: flex; align-items: center; justify-content: center; border-radius: 8px; background: #fff; border: 1px solid #e3e6f0; color: #858796; text-decoration: none; transition: all 0.2s; cursor: pointer; }
        .custom-page-link:hover { background: #f8f9fc; }
        .custom-page-item.active .custom-page-link { background: var(--primary-color); color: white; border-color: var(--primary-color); }
        .toast-notification { position: fixed; top: 20px; left: 50%; transform: translateX(-50%); z-index: 1060; padding: 12px 20px; border-radius: 10px; background: #fff; box-shadow: 0 5px 15px rgba(0,0,0,0.15); display: none; align-items: center; gap: 10px; border-left: 4px solid var(--primary-color); animation: slideDown 0.4s ease; }
        .toast-success { border-left-color: #1cc88a; } .toast-success i { color: #1cc88a; }
        .toast-danger { border-left-color: #e74a3b; } .toast-danger i { color: #e74a3b; }
        @keyframes slideDown { from { top: -50px; opacity: 0; } to { top: 20px; opacity: 1; } }
        
        .avatar-circle { width: 40px; height: 40px; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-weight: bold; font-size: 1rem; margin-right: 12px; text-transform: uppercase; flex-shrink: 0; }
        .user-cell { display: flex; align-items: center; }
        
        /* Validation Error */
        .is-invalid-custom { border-color: #e74a3b !important; background-color: #fff9fa; }
    </style>
</head>

<body id="staff-body">
    
    <div id="toast-message" class="toast-notification">
        <i class="fas"></i> <span id="toast-text"></span>
    </div>

    <jsp:include page="staff_header-sidebar.jsp" />

    <div class="main-content">
        <div class="card-modern">
            <div class="card-header-modern">
                <div class="page-title">
                    <i class="bi bi-box-arrow-in-down"></i> Import Management
                    <span class="stat-badge ms-2" id="totalImportBadge">
                        <c:out value="${totalImports}" default="${fn:length(importList)}"/> Imports
                    </span>
                </div>
                <button class="btn btn-add-new" data-bs-toggle="modal" data-bs-target="#createImportModal" onclick="resetModal()">
                    <i class="bi bi-plus-lg me-1"></i> Create New Import
                </button>
            </div>

            <%-- Filter Bar (Identical to Admin but styled for Staff) --%>
            <div class="filter-container">
                <div class="row g-3">
                    <%-- Search ID/Name --%>
                    <div class="col-md-4">
                        <span class="form-label-small">Search</span>
                        <div class="input-group search-input-group">
                            <span class="input-group-text"><i class="bi bi-search"></i></span>
                            <input type="text" id="filterSearch" class="form-control" placeholder="Search ID, Userame...">
                        </div>
                    </div>
                    <%-- Date --%>
                    <div class="col-md-2">
                        <span class="form-label-small">Date</span>
                        <input type="date" id="filterDate" class="form-control">
                    </div>
                    <%-- Status --%>
                    <div class="col-md-2">
                        <span class="form-label-small">Status</span>
                        <select id="filterStatus" class="form-select">
                            <option value="">All Status</option>
                            <option value="Pending">Pending</option>
                            <option value="Delivered">Delivered</option>
                            <option value="Cancelled">Cancelled</option>
                        </select>
                    </div>
                    <%-- Price Range --%>
                    <div class="col-md-3">
                        <span class="form-label-small">Price Range</span>
                        <div class="input-group">
                            <input type="number" id="filterPriceMin" class="form-control" placeholder="Min">
                            <span class="input-group-text bg-white">-</span>
                            <input type="number" id="filterPriceMax" class="form-control" placeholder="Max">
                        </div>
                    </div>
                    <%-- Reset --%>
                    <div class="col-md-1 d-flex align-items-end">
                        <button class="btn btn-light border w-100 text-muted" onclick="resetFilters()" title="Reset Filters">
                            <i class="bi bi-arrow-counterclockwise"></i>
                        </button>
                    </div>
                </div>
            </div>

            <%-- Loader --%>
            <div id="table-loader">
                <div class="spinner-border text-secondary" role="status"><span class="visually-hidden">Loading...</span></div>
            </div>

            <%-- Content Container --%>
            <div id="import-content-container" style="display: none;">
                <div class="table-responsive">
                    <table class="table table-modern align-middle" id="importTableMain">
                        <thead>
                            <tr>
                                <th style="width: 10%">ID</th>
                                <th style="width: 25%">Username</th>
                                <th style="width: 15%" class="text-center">Date</th>
                                <th style="width: 10%" class="text-center">Quantity</th>
                                <th style="width: 15%" class="text-center">Status</th>
                                <th style="width: 15%" class="text-end">Total Amount</th>
                                <th style="width: 10%" class="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody id="tableBody">
                            <c:choose>
                                <c:when test="${not empty importList}">
                                    <c:forEach items="${importList}" var="imp">
                                        <tr class="import-summary-row">
                                            <td class="fw-bold" style="color: var(--primary-color)">#${imp.id}</td>
                                            <td>
                                                <div class="user-cell">
                                                    <div class="avatar-circle" data-name="${imp.username}"></div>
                                                    <div><span class="fw-bold text-dark staff-name-text">${imp.username}</span></div>
                                                </div>
                                            </td>
                                            <td class="text-center import-date"><fmt:formatDate value="${imp.date}" pattern="dd/MM/yyyy" /></td>
                                            <td class="text-center"><span class="badge bg-light text-dark border">${imp.quantity}</span></td>
                                            <td class="text-center import-status">
                                                <span class="status-badge badge-${fn:toLowerCase(imp.status)}">${imp.status}</span>
                                            </td>
                                            <td class="text-end fw-bold import-price" style="color: var(--primary-color);">
                                                <fmt:formatNumber value="${imp.total}" pattern="###,###" /> <small class="text-muted">VND</small>
                                            </td>
                                            <td class="text-center">
                                                <%-- NO CONFIRM BUTTON FOR STAFF - View Only --%>
                                                <button class="btn-soft btn-soft-secondary view-btn" onclick="toggleDetail(this)" title="View Details">
                                                    <i class="bi bi-chevron-down"></i>
                                                </button>
                                            </td>
                                        </tr>
                                        
                                        <%-- Detail Row --%>
                                        <tr class="import-detail-row" style="display: none;">
                                            <td colspan="7" class="p-0 border-0">
                                                <div class="detail-row-container">
                                                    <div class="detail-card">
                                                        <div class="detail-header"><i class="bi bi-list-ul"></i> Import Details #${imp.id}</div>
                                                        <div class="table-responsive">
                                                            <table class="table table-sm table-striped mb-0 align-middle">
                                                                <thead class="bg-light text-secondary">
                                                                    <tr>
                                                                        <th class="ps-4" style="width: 40%">Product Info</th>
                                                                        <th class="text-center" style="width: 20%">Size</th>
                                                                        <th class="text-center" style="width: 20%">Quantity</th>
                                                                        <th class="text-end pe-4" style="width: 20%">Subtotal</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <c:choose>
                                                                        <c:when test="${not empty importDetailMap[imp.id]}">
                                                                            <c:forEach items="${importDetailMap[imp.id]}" var="d">
                                                                                <c:set var="fullProd" value="${prodMap[d.productID]}" />
                                                                                <tr>
                                                                                    <td class="ps-4">
                                                                                        <div class="d-flex align-items-center">
                                                                                            <img src="${fullProd.picURL}" class="product-img-thumb" alt="img" onerror="this.src='https://via.placeholder.com/50'">
                                                                                            <div>
                                                                                                <span class="product-name-cell">${fullProd.name}</span>
                                                                                                <div class="product-meta-cell">
                                                                                                    <small class="badge bg-light text-secondary border text-uppercase me-1" style="font-size: 0.7rem;">
                                                                                                        ${productCategoryMap[d.productID]}
                                                                                                    </small>
                                                                                                    <span><fmt:formatNumber value="${d.price}" pattern="#,###"/> VND</span>
                                                                                                </div>
                                                                                            </div>
                                                                                        </div>
                                                                                    </td>
                                                                                    <td class="text-center"><span class="badge bg-secondary">${d.sizeName}</span></td>
                                                                                    <td class="text-center fw-bold">x${d.quantity}</td>
                                                                                    <td class="text-end pe-4 text-muted"><fmt:formatNumber value="${d.price * d.quantity}" pattern="###,###"/> VND</td>
                                                                                </tr>
                                                                            </c:forEach>
                                                                        </c:when>
                                                                        <c:otherwise><tr><td colspan="4" class="text-center py-3 text-muted">No details found.</td></tr></c:otherwise>
                                                                    </c:choose>
                                                                </tbody>
                                                            </table>
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr><td colspan="7" class="text-center py-5 text-muted">No imports found.</td></tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
                <div id="paginationContainer" class="pagination-wrapper px-4 pb-3"></div>
            </div>
        </div>
    </div>

    <%-- Modal Create Import --%>
    <div class="modal fade" id="createImportModal" tabindex="-1" aria-hidden="true" data-bs-backdrop="static">
        <div class="modal-dialog modal-lg modal-dialog-centered"> 
            <div class="modal-content modal-content-modern">
                <div class="modal-header-modern d-flex justify-content-between">
                    <h5 class="fw-bold m-0"><i class="bi bi-box-seam-fill me-2"></i> Create New Import</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="row g-3 align-items-end"> 
                        <div class="col-md-5">
                            <label class="fw-bold small text-muted mb-1">Product <span class="text-danger">*</span></label>
                            <select id="import_product" class="form-select form-control-modern" onchange="this.classList.remove('is-invalid-custom')">
                                <option value="">-- Select Product --</option>
                                <c:forEach items="${productList}" var="p"><option value="${p.id}">${p.name}</option></c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="fw-bold small text-muted mb-1">Size</label>
                            <select id="import_size" class="form-select form-control-modern"><option>S</option><option>M</option><option>L</option></select>
                        </div>
                        <div class="col-md-2">
    <label class="fw-bold small text-muted mb-1">Quantity</label>
    <input type="number" id="import_qty" class="form-control form-control-modern text-center" min="1" value="1" oninput="if(this.value > 0) this.classList.remove('is-invalid-custom')">
</div>
                        <div class="col-md-2">
                            <button type="button" class="btn-add-item" onclick="addItemToTable()"><i class="bi bi-plus-lg"></i> Add</button>
                        </div>
                    </div>
                    
                    <div class="import-list-box">
                        <table class="table table-hover mb-0 align-middle">
                            <thead class="bg-light sticky-top">
                                <tr><th class="ps-3">Product Name</th><th class="text-center">Size</th><th class="text-center">Quantity</th><th class="text-center">Remove</th></tr>
                            </thead>
                            <tbody id="import-items-list">
                                <tr id="empty-row"><td colspan="4" class="text-center text-muted py-4">List is empty. Add products above.</td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="modal-footer border-0 p-4 pt-0">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button id="btn-submit-import" class="btn btn-primary px-4 fw-bold btn-submit-import" onclick="submitImport()" disabled>Submit Import</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>

    <script>
        const BASE_URL = '${BASE_URL}';
        let importItems = [];

        // --- UTILS ---
        function showToast(msg, type = 'success') {
            const toast = $('#toast-message');
            const icon = toast.find('i');
            const text = $('#toast-text');
            toast.removeClass('toast-success toast-danger').addClass(type === 'success' ? 'toast-success' : 'toast-danger');
            icon.removeClass().addClass(type === 'success' ? 'fas fa-check-circle' : 'fas fa-exclamation-circle');
            text.text(msg);
            toast.addClass('active');
            setTimeout(() => { toast.removeClass('active'); }, 3000);
        }

        function stringToColor(str) {
            let hash = 0;
            for (let i = 0; i < str.length; i++) hash = str.charCodeAt(i) + ((hash << 5) - hash);
            let c = (hash & 0x00FFFFFF).toString(16).toUpperCase();
            return "#" + "00000".substring(0, 6 - c.length) + c;
        }

        function initAvatars() {
            $('.avatar-circle').each(function() {
                let name = $(this).data('name') || "U";
                let initial = name.charAt(0).toUpperCase();
                $(this).css('background-color', stringToColor(name)).text(initial);
            });
        }

        function toggleTableBlur(active) {
            if(active) {
                $('#importTableMain tbody').addClass('table-blur');
                $('.btn').addClass('disabled-pointer');
            } else {
                $('#importTableMain tbody').removeClass('table-blur');
                $('.btn').removeClass('disabled-pointer');
            }
        }

        // --- CLIENT SIDE PAGINATION & FILTERING (Identical to Admin) ---
        let allRowsData = [], filteredRows = [], currentPage = 1, perPage = 8;

        document.addEventListener("DOMContentLoaded", function () {
            setTimeout(() => {
                $('#table-loader').fadeOut(200, () => { 
                    $('#import-content-container').fadeIn(200); 
                    initPagination(); 
                });
            }, 400);

            // Filter Event Listeners
            $('#filterSearch, #filterDate, #filterStatus, #filterPriceMin, #filterPriceMax').on('input change', function() {
                toggleTableBlur(true);
                setTimeout(() => {
                    applyFilters();
                    toggleTableBlur(false);
                }, 200);
            });
        });

        function initPagination() {
            let tbody = document.getElementById('tableBody');
            if(!tbody) return;
            let rows = tbody.querySelectorAll('.import-summary-row');
            allRowsData = [];

            rows.forEach(r => {
                let idText = r.querySelector('td:first-child').innerText.replace('#', '').trim();
                let staffName = r.querySelector('.staff-name-text').innerText.toLowerCase();
                let dateStr = r.querySelector('.import-date').innerText.trim();
                let statusText = r.querySelector('.import-status span').innerText.trim();
                let priceRaw = r.querySelector('.import-price').innerText.replace(/[^\d]/g, '');

                // Parse Date (dd/MM/yyyy -> yyyy-MM-dd for comparison)
                let parts = dateStr.split('/');
                let isoDate = parts.length === 3 ? parts[2] + '-' + parts[1] + '-' + parts[0] : '';

                allRowsData.push({
                    el: r,
                    detail: r.nextElementSibling, // The detail row
                    data: {
                        fullText: (idText + ' ' + staffName).toLowerCase(),
                        date: isoDate,
                        status: statusText,
                        price: parseInt(priceRaw) || 0
                    }
                });
            });
            
            filteredRows = allRowsData;
            initAvatars();
            applyFilters();
        }

        function applyFilters() {
            let sText = $('#filterSearch').val().toLowerCase();
            let sDate = $('#filterDate').val();
            let sStatus = $('#filterStatus').val();
            let pMin = parseInt($('#filterPriceMin').val());
            let pMax = parseInt($('#filterPriceMax').val());

            filteredRows = allRowsData.filter(item => {
                let d = item.data;
                let matchText = !sText || d.fullText.includes(sText);
                let matchDate = !sDate || d.date === sDate;
                let matchStatus = !sStatus || d.status === sStatus;
                let matchMin = isNaN(pMin) || d.price >= pMin;
                let matchMax = isNaN(pMax) || d.price <= pMax;

                return matchText && matchDate && matchStatus && matchMin && matchMax;
            });
            renderPage(currentPage > Math.ceil(filteredRows.length/perPage) ? 1 : currentPage);
        }

        function resetFilters() {
            toggleTableBlur(true);
            setTimeout(() => {
                $('.filter-container input, .filter-container select').val('');
                applyFilters();
                toggleTableBlur(false);
            }, 200);
        }

        function renderPage(page) {
            currentPage = page;
            // Hide all rows first
            allRowsData.forEach(item => { 
                item.el.style.display = 'none'; 
                item.detail.style.display = 'none'; 
                item.el.classList.remove('selected-row'); 
                let btn = item.el.querySelector('.view-btn');
                if(btn) { btn.classList.remove('active'); $(btn).find('i').attr('class', 'bi bi-chevron-down'); }
            });

            let start = (page - 1) * perPage;
            let end = start + perPage;
            let pageItems = filteredRows.slice(start, end);

            pageItems.forEach(item => { item.el.style.display = 'table-row'; });

            // Render Pagination Controls
            let total = Math.ceil(filteredRows.length / perPage);
            let container = document.getElementById('paginationContainer');
            let html = '<ul class="custom-pagination">';
            
            if(total > 1) {
                if(page > 1) html += `<li class="custom-page-item"><a class="custom-page-link" onclick="changePage(\${page-1})"><i class="bi bi-chevron-left"></i></a></li>`;
                
                for(let i=1; i<=total; i++) {
                     if (i === 1 || i === total || (i >= page - 1 && i <= page + 1)) {
                        html += `<li class="custom-page-item \${i===currentPage?'active':''}"><a class="custom-page-link" onclick="changePage(\${i})">\${i}</a></li>`;
                    } else if (i === page - 2 || i === page + 2) {
                        html += `<li class="custom-page-item"><span class="custom-page-link border-0">...</span></li>`;
                    }
                }

                if(page < total) html += `<li class="custom-page-item"><a class="custom-page-link" onclick="changePage(\${page+1})"><i class="bi bi-chevron-right"></i></a></li>`;
            }
            html += '</ul>';
            
            if(filteredRows.length === 0) {
                html = '<div class="text-center text-muted py-3 w-100">No imports match criteria.</div>';
            }
            container.innerHTML = html;
        }

        function changePage(page) {
            toggleTableBlur(true);
            setTimeout(() => {
                renderPage(page);
                toggleTableBlur(false);
            }, 150);
        }

        // --- REFRESH TABLE DATA (AJAX RELOAD) ---
        function refreshTableData() {
            toggleTableBlur(true);
            // Fetch current URL to get updated HTML
            $.get(window.location.href, function(response) {
                var newDoc = new DOMParser().parseFromString(response, 'text/html');
                var newTbody = newDoc.getElementById('tableBody').innerHTML;
                var newCount = newDoc.getElementById('totalImportBadge').innerText;
                
                $('#tableBody').html(newTbody);
                $('#totalImportBadge').text(newCount);
                
                initPagination();
                toggleTableBlur(false);
            }).fail(function() {
                showToast("Failed to refresh table data.", "error");
                toggleTableBlur(false);
            });
        }

        // --- CREATE IMPORT LOGIC ---
        function resetModal() {
            importItems = [];
            renderImportTable();
            $('#import_product').val('');
            $('#import_size').val('S');
            $('#import_qty').val(1);
            $('#import_product').removeClass('is-invalid-custom');
        }

        function addItemToTable() {
            const pId = $('#import_product').val();
            const pName = $('#import_product option:selected').text(); 
            const size = $('#import_size').val();
            const qty = parseInt($('#import_qty').val());

            // Validations
            if (!pId || pId === "") {
                showToast("Please select a product info!", "error");
                $('#import_product').addClass('is-invalid-custom');
                return;
            } else {
                $('#import_product').removeClass('is-invalid-custom');
            }

            if (qty <= 0 || isNaN(qty)) {
                showToast("Quantity must be greater than 0", "error");
                $('#import_qty').addClass('is-invalid-custom'); 
                return;
            } else {
                $('#import_qty').removeClass('is-invalid-custom');
            }
            
            const exists = importItems.find(i => i.productId === pId && i.size === size);
            if (exists) {
                exists.quantity += qty;
                showToast(`Updated quantity for ${pName} (${size})`);
            } else {
                importItems.push({ productId: pId, productName: pName, size: size, quantity: qty });
            }
            
            renderImportTable();
            $('#import_qty').val(1);
        }

        function renderImportTable() {
            const tbody = document.getElementById('import-items-list');
            const submitBtn = document.getElementById('btn-submit-import');
            tbody.innerHTML = "";
            
            if (importItems.length === 0) {
                tbody.innerHTML = '<tr id="empty-row"><td colspan="4" class="text-center text-muted py-4">List is empty. Add products above.</td></tr>';
                submitBtn.disabled = true; // Disable if empty
            } else {
                submitBtn.disabled = false; // Enable if has items
                importItems.forEach((item, i) => {
                    tbody.innerHTML += `
                        <tr>
                            <td class="ps-3 fw-bold text-dark">\${item.productName}</td>
                            <td class="text-center"><span class="badge bg-secondary">\${item.size}</span></td>
                            <td class="text-center">\${item.quantity}</td>
                            <td class="text-center">
                                <button type="button" class="btn btn-outline-danger btn-sm border-0" onclick="removeItem(\${i})">
                                    <i class="bi bi-trash-fill"></i>
                                </button>
                            </td>
                        </tr>`;
                });
            }
        }
        
        function removeItem(index) {
            importItems.splice(index, 1);
            renderImportTable();
        }

        function submitImport() {
            if (importItems.length === 0) { showToast("Import list is empty!", "error"); return; }
            
            $('.btn-submit-import').prop('disabled', true).text('Processing...');
            
            // Post to Staff Controller
            $.post('${BASE_URL}/staff', { action: 'create_import', items: JSON.stringify(importItems) }, function(res){
                if(res.isSuccess) {
                    showToast("Import created successfully!");
                    $('#createImportModal').modal('hide');
                    resetModal();
                    refreshTableData(); // AJAX Reload
                    $('.btn-submit-import').prop('disabled', false).text('Submit Import');
                } else {
                    showToast(res.description, "error");
                    $('.btn-submit-import').prop('disabled', false).text('Submit Import');
                }
            }, 'json')
            .fail(function() { 
                showToast("Server error", "error"); 
                $('.btn-submit-import').prop('disabled', false).text('Submit Import');
            });
        }

        function toggleDetail(btn) {
            var row = $(btn).closest('tr');
            var detailRow = row.next('.import-detail-row');
            detailRow.toggle(); 
            $(btn).toggleClass('active');
            var icon = $(btn).find('i');
            if ($(btn).hasClass('active')) {
                icon.attr('class', 'bi bi-chevron-up');
                row.addClass('selected-row'); 
            } else {
                icon.attr('class', 'bi bi-chevron-down');
                row.removeClass('selected-row');
            }
        }
                    $(document).ready(function() {
                // 1. Xóa class active ở các li khác (nếu cần thiết, để tránh duplicate)
                $('.nav-list li').removeClass('active');
                
                // 2. Tìm thẻ li có data-target='product-manage' và thêm class active
                $('.nav-list li[data-target="import-manage"]').addClass('active');
            });
    </script>
</body>
</html>