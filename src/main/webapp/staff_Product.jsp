<%-- 
    Document    : staff_Product.jsp
    Description: Product Management for Staff (Read-Only Mode)
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="entity.Staff" %>
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
        <title>Staff | Product Management</title>
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

            /* --- Card & Container --- */
            .main-content { padding: 20px; }
            
            .card-modern { background: #fff; border: none; border-radius: 15px; box-shadow: var(--card-shadow); margin-bottom: 25px; overflow: hidden; }
            .card-header-modern { background: #fff; padding: 20px 25px; border-bottom: 1px solid #e3e6f0; display: flex; justify-content: space-between; align-items: center; }
            .page-title { font-weight: 700; color: var(--primary-color); font-size: 1.5rem; display: flex; align-items: center; gap: 10px; }
            .stat-badge { background: var(--primary-light); color: var(--primary-color); padding: 5px 12px; border-radius: 20px; font-weight: 600; font-size: 0.9rem; }

            /* --- Filter Bar --- */
            .filter-container { padding: 20px 25px; background-color: #fff; border-bottom: 1px solid #f0f0f0; }
            .search-input-group .input-group-text { background: transparent; border-right: none; color: #aaa; }
            .search-input-group .form-control { border-left: none; box-shadow: none; }
            .search-input-group .form-control:focus { border-color: #d1d1d1; }

            /* --- Table Styles --- */
            .table-modern { width: 100%; margin-bottom: 0; }
            .table-modern thead th { background-color: #f8f9fc; color: #858796; font-weight: 700; text-transform: uppercase; font-size: 0.85rem; border-bottom: 2px solid #e3e6f0; padding: 15px; border-top: none; }
            .table-modern tbody td { padding: 15px; vertical-align: middle; border-bottom: 1px solid #e3e6f0; color: #5a5c69; font-size: 0.95rem; }
            .table-modern tbody tr:hover { background-color: #fcfcfc; }
            
            .table-blur { opacity: 0.5; pointer-events: none; transition: opacity 0.2s ease; }
            #table-loader { min-height: 200px; display: flex; align-items: center; justify-content: center; }

            .product-img-thumb { width: 60px; height: 60px; object-fit: cover; border-radius: 8px; border: 1px solid #eee; }
            .product-name-cell { font-weight: 600; color: #333; display: block; max-width: 250px; white-space: normal; overflow: hidden; text-overflow: ellipsis; line-height: 1.4; }
            .product-cat-cell { font-size: 0.8rem; color: #888; margin-top: 4px; }

            /* --- Badges & Buttons --- */
            .status-badge { padding: 5px 12px; border-radius: 20px; font-size: 0.8rem; font-weight: 700; }
            .badge-active { background: #d1e7dd; color: #0f5132; }
            .badge-inactive { background: #f8d7da; color: #842029; }
            
            .stock-line { display: block; font-size: 0.8rem; margin-bottom: 2px; }
            .stock-label { font-weight: 700; color: #555; width: 15px; display: inline-block; }
            .stock-val { color: #333; }

            .btn-soft { border: none; border-radius: 8px; width: 32px; height: 32px; display: inline-flex; align-items: center; justify-content: center; transition: all 0.2s; margin: 0 2px; cursor: pointer; }
            .btn-soft:hover { transform: translateY(-2px); }
            
            /* Staff Info Button Color */
            .btn-soft-info { background: rgba(141, 110, 99, 0.1); color: #8D6E63; } 
            .btn-soft-info:hover { background: #8D6E63; color: #fff; }

            /* --- Modal --- */
            .modal-content-modern { border-radius: 15px; border: none; overflow: hidden; }
            .modal-header-modern { padding: 20px; border-bottom: 1px solid #eee; }
            
            /* --- Pagination --- */
            .pagination-wrapper { margin-top: 20px; display: flex; justify-content: flex-end; }
            .custom-pagination { display: flex; list-style: none; gap: 5px; padding: 0; }
            .custom-page-link { width: 35px; height: 35px; display: flex; align-items: center; justify-content: center; border-radius: 8px; background: #fff; border: 1px solid #e3e6f0; color: #858796; text-decoration: none; transition: all 0.2s; cursor: pointer; }
            .custom-page-link:hover { background: #f8f9fc; }
            .custom-page-item.active .custom-page-link { background: var(--primary-color); color: white; border-color: var(--primary-color); box-shadow: 0 3px 8px rgba(121, 85, 72, 0.3); }
            .custom-page-item.disabled .custom-page-link { opacity: 0.5; cursor: default; }
            
            /* --- INACTIVE EFFECT --- */
            .row-inactive { background-color: #f8f9fa !important; opacity: 0.75; }
            .row-inactive img { filter: grayscale(100%); opacity: 0.8; }
            .row-inactive td { color: #999 !important; }
            .row-inactive .badge-inactive { opacity: 1; }
        </style>
    </head>

    <body id="staff-body">

        <jsp:include page="staff_header-sidebar.jsp" />

        <div class="main-content">
            <div class="card-modern">
                <div class="card-header-modern">
                    <div class="page-title">
                        <i class="bi bi-box-seam-fill"></i> Product Management
                        <span class="stat-badge" id="total-product-badge">
                            <c:out value="${totalProducts}" default="${fn:length(list)}"/> Products
                        </span>
                    </div>
                    <%-- No Add Button for Staff --%>
                </div>

                <%-- Filter Bar --%>
                <div class="filter-container">
                    <div class="row g-2 align-items-center">
                        <input type="hidden" id="current-page" value="${currentPage}">
                        
                        <div class="col-md-3">
                            <div class="input-group search-input-group">
                                <span class="input-group-text"><i class="bi bi-search"></i></span>
                                <input type="text" id="filter-search" class="form-control" placeholder="Search by Name..." value="${searchName}">
                            </div>
                        </div>
                        
                        <div class="col-md-2">
                            <select id="filter-category" class="form-select">
                                <option value="0">All Categories</option>
                                <c:forEach var="cate" items="${cateList}">
                                    <option value="${cate.category_id}" ${selectedCategory == cate.category_id ? 'selected' : ''}>${cate.type} (${cate.gender})</option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <div class="col-md-2">
                            <select id="filter-status" class="form-select">
                                <option value="all" ${selectedStatus == 'all' ? 'selected' : ''}>All Status</option>
                                <option value="active" ${selectedStatus == 'active' ? 'selected' : ''}>Active</option>
                                <option value="inactive" ${selectedStatus == 'inactive' ? 'selected' : ''}>Inactive</option>
                            </select>
                        </div>
                        
                        <div class="col-md-2">
                            <select id="filter-sort" class="form-select">
                                <option value="">Sort By</option>
                                <option value="price_asc" ${sortBy == 'price_asc' ? 'selected' : ''}>Price: Low to High</option>
                                <option value="price_desc" ${sortBy == 'price_desc' ? 'selected' : ''}>Price: High to Low</option>
                                <option value="name_asc" ${sortBy == 'name_asc' ? 'selected' : ''}>Name: A-Z</option>
                                <option value="name_desc" ${sortBy == 'name_desc' ? 'selected' : ''}>Name: Z-A</option>
                            </select>
                        </div>
                        
                        <div class="col-md-1">
                             <button onclick="resetFilters()" class="btn btn-light w-100 border" title="Reset Filters"><i class="bi bi-arrow-counterclockwise"></i></button>
                        </div>
                    </div>
                </div>

                <%-- Table Loader --%>
                <div id="table-loader">
                    <div class="spinner-border text-secondary" role="status"><span class="visually-hidden">Loading...</span></div>
                </div>

                <%-- Product Table Container --%>
                <div id="product-content-container" style="display: none;">
                    <div class="table-responsive">
                        <table class="table table-modern align-middle" id="productTableMain">
                            <thead>
                                <tr>
                                    <th width="8%">Image</th>
                                    <th width="30%">Product Info</th>
                                    <th width="15%">Stock</th>
                                    <th width="15%" class="text-end">Price</th>
                                    <th width="12%" class="text-center">Status</th>
                                    <th width="10%" class="text-center">Actions</th> <%-- Reduced width --%>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${not empty list}">
                                        <c:forEach var="p" items="${list}">
                                            <tr class="${p.is_active ? '' : 'row-inactive'}">
                                                <td><img src="${p.picURL}" class="product-img-thumb" alt="Img" onerror="this.src='https://via.placeholder.com/60?text=No+Img'"></td>
                                                <td>
                                                    <span class="product-name-cell" title="${p.name}">${p.name}</span>
                                                    <span class="product-cat-cell">${categoryMap[p.categoryID]}</span>
                                                </td>
                                                <td>
                                                    <c:set var="sizes" value="${productSizeMap[p.id]}" />
                                                    <span class="stock-line"><span class="stock-label">S:</span> <span class="stock-val">${sizes['S'] != null ? sizes['S'] : 0}</span></span>
                                                    <span class="stock-line"><span class="stock-label">M:</span> <span class="stock-val">${sizes['M'] != null ? sizes['M'] : 0}</span></span>
                                                    <span class="stock-line"><span class="stock-label">L:</span> <span class="stock-val">${sizes['L'] != null ? sizes['L'] : 0}</span></span>
                                                </td>
                                                <td class="text-end">
                                                    <c:set var="voucherVal" value="${voucherMap[p.voucherID]}" />
                                                    <c:if test="${not empty voucherVal and voucherVal != 'None'}">
                                                        <span class="badge bg-danger rounded-pill mb-1" style="font-size: 0.75rem;">-${voucherVal}</span><br>
                                                    </c:if>
                                                    <span class="fw-bold" style="color: var(--primary-color);">
                                                        <fmt:formatNumber value="${p.price}" pattern="###,###"/> 
                                                    </span> <small class="text-muted">VND</small>
                                                </td>
                                                <td class="text-center">
                                                    <span class="status-badge ${p.is_active ? 'badge-active' : 'badge-inactive'}">
                                                        ${p.is_active ? 'Active' : 'Inactive'}
                                                    </span>
                                                </td>
                                                <td class="text-center">
                                                    <%-- Only View Button for Staff --%>
                                                    <button type="button" class="btn-soft btn-soft-info" data-bs-toggle="modal" data-bs-target="#viewProductModal"
                                                            data-id="${p.id}" data-name="${p.name}" data-img="${p.picURL}"
                                                            data-cat="${categoryMap[p.categoryID]}"
                                                            data-size-s="${sizes['S']}" data-size-m="${sizes['M']}" data-size-l="${sizes['L']}"
                                                            data-price="${p.price}" data-voucher="${voucherMap[p.voucherID]}"
                                                            data-status="${p.is_active ? 'Active' : 'Inactive'}" data-desc="${p.description}"
                                                            title="View Details">
                                                        <i class="bi bi-info-circle"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr><td colspan="6" class="text-center py-4 text-muted">No products found.</td></tr>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <%-- PAGINATION --%>
                    <c:if test="${totalPages > 1}">
                        <div class="pagination-wrapper px-4 pb-3">
                            <ul class="custom-pagination">
                                <li class="custom-page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="custom-page-link ajax-page" href="javascript:void(0)" data-page="${currentPage - 1}"><i class="bi bi-chevron-left"></i></a>
                                </li>
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="custom-page-item ${i == currentPage ? 'active' : ''}">
                                        <a class="custom-page-link ajax-page" href="javascript:void(0)" data-page="${i}">${i}</a>
                                    </li>
                                </c:forEach>
                                <li class="custom-page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="custom-page-link ajax-page" href="javascript:void(0)" data-page="${currentPage + 1}"><i class="bi bi-chevron-right"></i></a>
                                </li>
                            </ul>
                        </div>
                    </c:if>
                </div> 
            </div>
        </div>

        <%-- Modal View Product --%>
        <div class="modal fade" id="viewProductModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content modal-content-modern">
                    <div class="modal-header border-bottom-0 pb-0 text-end">
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4 pt-0">
                        <div class="row">
                            <div class="col-md-5 text-center">
                                <div class="p-3 border rounded bg-light mb-3">
                                    <img id="view_img" src="" class="img-fluid rounded" style="max-height: 300px;">
                                </div>
                            </div>
                            <div class="col-md-7">
                                <h4 id="view_name" class="fw-bold text-dark mb-1"></h4>
                                <p id="view_cat" class="text-muted small mb-3"></p>
                                <div class="d-flex align-items-center mb-3">
                                    <h3 id="view_price" class="text-primary fw-bold mb-0 me-3" style="color: var(--primary-color) !important;"></h3>
                                    <span id="view_voucher" class="badge bg-danger rounded-pill"></span>
                                </div>
                                <div class="mb-3">
                                    <label class="fw-bold text-secondary small d-block mb-1">STOCK STATUS</label>
                                    <div class="d-flex gap-2">
                                        <span class="badge bg-light text-dark border">S: <span id="view_s">0</span></span>
                                        <span class="badge bg-light text-dark border">M: <span id="view_m">0</span></span>
                                        <span class="badge bg-light text-dark border">L: <span id="view_l">0</span></span>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label class="fw-bold text-secondary small d-block mb-1">STATUS</label>
                                    <span id="view_status"></span>
                                </div>
                                <div class="bg-light p-3 rounded small text-secondary">
                                    <label class="fw-bold text-dark mb-1">Description:</label>
                                    <p id="view_desc_text" class="m-0"></p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>

        <script>

            $(document).ready(function() {
                // 1. Xóa class active ở các li khác (nếu cần thiết, để tránh duplicate)
                $('.nav-list li').removeClass('active');
                
                // 2. Tìm thẻ li có data-target='product-manage' và thêm class active
                $('.nav-list li[data-target="product-list"]').addClass('active');
            });

            // Toggle table blur effect
            function toggleTableBlur(active) {
                if(active) $('#productTableMain tbody').addClass('table-blur');
                else $('#productTableMain tbody').removeClass('table-blur');
            }

            // Initial Page Load
            $(document).ready(function() {
                setTimeout(function() {
                    $('#table-loader').fadeOut(200, function() {
                        $('#product-content-container').fadeIn(200);
                    });
                }, 400); 
            });

            function getFilterUrl(page) {
                let params = {
                    search: $('#filter-search').val(),
                    category: $('#filter-category').val(),
                    status: $('#filter-status').val(),
                    sort: $('#filter-sort').val(),
                    page: page || $('#current-page').val() || 1
                };
                return "${BASE_URL}/staff/product?" + $.param(params);
            }

            function loadTable(url, pushState = true) {
                toggleTableBlur(true); 

                $.ajax({
                    url: url,
                    type: 'GET',
                    success: function(response) {
                        let newContent = $(response).find('#product-content-container').html();
                        let newBadge = $(response).find('#total-product-badge').html();
                        
                        $('#product-content-container').html(newContent);
                        $('#total-product-badge').html(newBadge);
                        
                        if (pushState) {
                            window.history.pushState({path: url}, '', url);
                        }
                        let newPageVal = $(response).find('#current-page').val();
                        if (newPageVal) $('#current-page').val(newPageVal);
                        
                        setTimeout(() => toggleTableBlur(false), 200);
                    },
                    error: function() {
                        alert("Error loading data.");
                        toggleTableBlur(false);
                    }
                });
            }

            // Event Listeners for Filters
            $(document).ready(function() {
                $('#filter-category, #filter-status, #filter-sort').on('change', function() {
                    loadTable(getFilterUrl(1)); 
                });

                let searchTimeout;
                $('#filter-search').on('input', function() {
                    toggleTableBlur(true);
                    clearTimeout(searchTimeout);
                    searchTimeout = setTimeout(() => {
                        loadTable(getFilterUrl(1));
                    }, 500);
                });

                $(document).on('click', '.ajax-page', function(e) {
                    e.preventDefault();
                    let page = $(this).data('page');
                    loadTable(getFilterUrl(page));
                });
                
                window.onpopstate = function(event) {
                    if (event.state && event.state.path) {
                        loadTable(event.state.path, false);
                    }
                };
            });

            function resetFilters() {
                $('#filter-search').val('');
                $('#filter-category').val('0');
                $('#filter-status').val('all');
                $('#filter-sort').val('');
                loadTable(getFilterUrl(1));
            }

            // Modal Populate Logic
            const viewModalEl = document.getElementById('viewProductModal');
            if (viewModalEl) {
                viewModalEl.addEventListener('show.bs.modal', function (event) {
                    const btn = event.relatedTarget;
                    document.getElementById('view_name').textContent = btn.getAttribute('data-name');
                    document.getElementById('view_cat').textContent = btn.getAttribute('data-cat');
                    document.getElementById('view_price').textContent = parseInt(btn.getAttribute('data-price')).toLocaleString() + ' VND';
                    document.getElementById('view_img').src = btn.getAttribute('data-img');
                    const voucher = btn.getAttribute('data-voucher');
                    document.getElementById('view_voucher').textContent = (voucher && voucher !== 'None') ? '-' + voucher + '%' : '';
                    document.getElementById('view_s').textContent = btn.getAttribute('data-size-s');
                    document.getElementById('view_m').textContent = btn.getAttribute('data-size-m');
                    document.getElementById('view_l').textContent = btn.getAttribute('data-size-l');
                    const status = btn.getAttribute('data-status');
                    const statusEl = document.getElementById('view_status');
                    statusEl.textContent = status;
                    statusEl.className = status === 'Active' ? 'badge bg-success' : 'badge bg-danger';
                    document.getElementById('view_desc_text').textContent = btn.getAttribute('data-desc');
                });
            }
        </script>
    </body>
</html>