<%-- 
    Document   : admin_ProductManagement.jsp
    Description: Product Management (Refactored: Loading Effect & Smooth Blur Table & Fixed Delete AJAX)
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="entity.Staff" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="BASE_URL" value="${pageContext.request.contextPath}" />

<%
    // SECURITY CHECK
    Staff s = (Staff) session.getAttribute("staff");
    if (s == null || !"admin".equalsIgnoreCase(s.getRole())) {
        if (s == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/");
        }
        return; 
    }
%>

<!DOCTYPE html>
<html lang="en">

    <head> 
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin | Product Management</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <script src="https://kit.fontawesome.com/1bd876819f.js" crossorigin="anonymous"></script>
        <link href='https://fonts.googleapis.com/css?family=Quicksand:400,500,600,700&display=swap' rel='stylesheet'> 
        <link rel="icon" href="${pageContext.request.contextPath}/images/LG2.png" type="image/x-icon"> 

        <style>
            :root {
                --primary-color: #4e73df;
                --secondary-color: #858796;
                --success-color: #1cc88a;
                --info-color: #36b9cc;
                --warning-color: #f6c23e;
                --danger-color: #e74a3b;
                --light-bg: #f8f9fc;
                --card-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
            }

            body { font-family: 'Quicksand', sans-serif; background-color: var(--light-bg); color: #5a5c69; }

            /* --- Card & Container --- */
            .main-content { padding: 20px; }
            
            .card-modern { background: #fff; border: none; border-radius: 15px; box-shadow: var(--card-shadow); margin-bottom: 25px; overflow: hidden; }
            .card-header-modern { background: #fff; padding: 20px 25px; border-bottom: 1px solid #e3e6f0; display: flex; justify-content: space-between; align-items: center; }
            .page-title { font-weight: 700; color: var(--primary-color); font-size: 1.5rem; display: flex; align-items: center; gap: 10px; }
            .stat-badge { background: rgba(78, 115, 223, 0.1); color: var(--primary-color); padding: 5px 12px; border-radius: 20px; font-weight: 600; font-size: 0.9rem; }

            /* --- Filter Bar --- */
            .filter-container { padding: 20px 25px; background-color: #fff; border-bottom: 1px solid #f0f0f0; }
            .search-input-group .input-group-text { background: transparent; border-right: none; color: #aaa; }
            .search-input-group .form-control { border-left: none; box-shadow: none; }
            .search-input-group .form-control:focus { border-color: #ced4da; }

            /* --- Table Styles --- */
            .table-modern { width: 100%; margin-bottom: 0; }
            .table-modern thead th { background-color: #f8f9fc; color: #858796; font-weight: 700; text-transform: uppercase; font-size: 0.85rem; border-bottom: 2px solid #e3e6f0; padding: 15px; border-top: none; }
            .table-modern tbody td { padding: 15px; vertical-align: middle; border-bottom: 1px solid #e3e6f0; color: #5a5c69; font-size: 0.95rem; }
            .table-modern tbody tr:hover { background-color: #fcfcfc; }
            
            /* [NEW] Blur Effect for Data Loading */
            .table-blur { opacity: 0.5; pointer-events: none; transition: opacity 0.2s ease; }
            
            /* [NEW] Loader */
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
            
            .btn-soft-primary { background: rgba(78, 115, 223, 0.1); color: #4e73df; } .btn-soft-primary:hover { background: #4e73df; color: #fff; }
            .btn-soft-danger { background: rgba(231, 74, 59, 0.1); color: #e74a3b; } .btn-soft-danger:hover { background: #e74a3b; color: #fff; }
            .btn-soft-warning { background: rgba(246, 194, 62, 0.1); color: #f6c23e; } .btn-soft-warning:hover { background: #f6c23e; color: #fff; }
            .btn-soft-success { background: rgba(28, 200, 138, 0.1); color: #1cc88a; } .btn-soft-success:hover { background: #1cc88a; color: #fff; }
            .btn-soft-info { background: rgba(54, 185, 204, 0.1); color: #36b9cc; } .btn-soft-info:hover { background: #36b9cc; color: #fff; }

            /* --- Modal --- */
            .modal-content-modern { border-radius: 15px; border: none; overflow: hidden; }
            .modal-header-modern { padding: 20px; border-bottom: 1px solid #eee; }
            .modal-header-modern.bg-green { background: #d4edda; color: #155724; }
            .modal-header-modern.bg-blue { background: #cfe2ff; color: #084298; }
            
            .form-floating > .form-control, .form-floating > .form-select { border-radius: 10px; border: 1px solid #d1d3e2; }
            .form-floating > .form-control:focus, .form-floating > .form-select:focus { border-color: #4e73df; box-shadow: 0 0 0 0.2rem rgba(78, 115, 223, 0.25); }
            
            label.error { color: #e74a3b; font-size: 0.85rem; margin-top: 5px; display: block; margin-left: 5px; font-weight: 600; }
            .form-control.error { border-color: #e74a3b; background-color: #fff8f8; }
            
            .img-preview-box { width: 100%; height: 250px; border: 2px dashed #ddd; border-radius: 10px; display: flex; align-items: center; justify-content: center; overflow: hidden; background: #f8f9fa; position: relative; margin-bottom: 15px; }
            .img-preview-box img { max-width: 100%; max-height: 100%; object-fit: contain; }
            .img-placeholder { font-size: 3rem; color: #ccc; }

            /* --- Pagination --- */
            .pagination-wrapper { margin-top: 20px; display: flex; justify-content: flex-end; }
            .custom-pagination { display: flex; list-style: none; gap: 5px; padding: 0; }
            .custom-page-link { width: 35px; height: 35px; display: flex; align-items: center; justify-content: center; border-radius: 8px; background: #fff; border: 1px solid #e3e6f0; color: #858796; text-decoration: none; transition: all 0.2s; cursor: pointer; }
            .custom-page-link:hover { background: #f8f9fc; }
            .custom-page-item.active .custom-page-link { background: var(--primary-color); color: white; border-color: var(--primary-color); box-shadow: 0 3px 8px rgba(78, 115, 223, 0.3); }
            .custom-page-item.disabled .custom-page-link { opacity: 0.5; cursor: default; }

            /* --- Toast --- */
            .toast-notification { position: fixed; top: 20px; left: 50%; transform: translateX(-50%); z-index: 1060; padding: 12px 20px; border-radius: 10px; background: #fff; box-shadow: 0 5px 15px rgba(0,0,0,0.15); display: none; align-items: center; gap: 10px; border-left: 4px solid #4e73df; animation: slideDown 0.4s ease; }
            .toast-notification.active { display: flex; }
            .toast-success { border-left-color: #1cc88a; } .toast-success i { color: #1cc88a; }
            .toast-info { border-left-color: #36b9cc; } .toast-info i { color: #36b9cc; }
            .toast-warning { border-left-color: #f6c23e; } .toast-warning i { color: #f6c23e; }
            .toast-danger { border-left-color: #e74a3b; } .toast-danger i { color: #e74a3b; }
            @keyframes slideDown { from { top: -50px; opacity: 0; } to { top: 20px; opacity: 1; } }
            
            /* --- INACTIVE EFFECT --- */
            .row-inactive { background-color: #f8f9fa !important; opacity: 0.75; }
            .row-inactive img { filter: grayscale(100%); opacity: 0.8; }
            .row-inactive td { color: #999 !important; }
            .row-inactive .badge-inactive { opacity: 1; }
            .row-inactive .btn-soft { filter: grayscale(100%); }
            .row-inactive .btn-soft:hover { filter: none; }

            .btn-upload-pc { border: 1px dashed #4e73df; color: #4e73df; background: #f8f9fc; font-size: 0.85rem; padding: 8px; width: 100%; margin-top: 10px; border-radius: 8px; transition: all 0.2s; }
            .btn-upload-pc:hover { background: #4e73df; color: white; }
            .btn-add-new { background: linear-gradient(45deg, #1cc88a, #13855c); border: none; box-shadow: 0 4px 10px rgba(28, 200, 138, 0.3); color: white; padding: 10px 20px; border-radius: 10px; font-weight: 600; transition: transform 0.2s; }
            .btn-add-new:hover { transform: translateY(-2px); color: whitesmoke !important; }
        </style>
    </head>

    <body id="admin-body">

        <%-- Toast Container --%>
        <div id="toast-message" class="toast-notification">
            <i class="fas"></i>
            <span id="toast-text"></span>
        </div>

        <jsp:include page="admin_header-sidebar.jsp" />

        <div class="main-content">
            <div class="card-modern">
                <div class="card-header-modern">
                    <div class="page-title">
                        <i class="bi bi-box-seam-fill"></i> Product Management
                        <span class="stat-badge" id="total-product-badge">
                            <c:out value="${totalProducts}" default="${fn:length(list)}"/> Products
                        </span>
                    </div>
                    <button class="btn btn-add-new" data-bs-toggle="modal" data-bs-target="#addProductModal">
                        <i class="bi bi-plus-lg me-1"></i> Add Product
                    </button>
                </div>

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
                                <option value="0">--All Categories--</option>
                                <c:forEach var="cate" items="${cateList}">
                                    <option value="${cate.category_id}" ${selectedCategory == cate.category_id ? 'selected' : ''}>${cate.type} (${cate.gender})</option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <div class="col-md-2">
                            <select id="filter-status" class="form-select">
                                <option value="all" ${selectedStatus == 'all' ? 'selected' : ''}>--All Status--</option>
                                <option value="active" ${selectedStatus == 'active' ? 'selected' : ''}>Active</option>
                                <option value="inactive" ${selectedStatus == 'inactive' ? 'selected' : ''}>Inactive</option>
                            </select>
                        </div>
                        
                        <div class="col-md-2">
                            <select id="filter-sort" class="form-select">
                                <option value="">--Sort By--</option>
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

                <%-- [NEW] Table Loader --%>
                <div id="table-loader">
                    <div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div>
                </div>

                <%-- THIS CONTAINER WILL BE REPLACED BY AJAX, HIDDEN INITIALLY --%>
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
                                    <th width="20%" class="text-center">Actions</th>
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
                                                    <span class="fw-bold text-primary">
                                                        <fmt:formatNumber value="${p.price}" pattern="###,###"/> 
                                                    </span> <small class="text-muted">VND</small>
                                                </td>
                                                <td class="text-center">
                                                    <span class="status-badge ${p.is_active ? 'badge-active' : 'badge-inactive'}">
                                                        ${p.is_active ? 'Active' : 'Inactive'}
                                                    </span>
                                                </td>
                                                <td class="text-center">
                                                    <div class="d-flex flex-column align-items-center gap-2">
                                                        
                                                        <c:set var="vValStr" value="${voucherMap[p.voucherID]}" />
                                                        <c:set var="vPercent" value="0" />
                                                        <c:if test="${not empty vValStr and vValStr != 'None'}">
                                                            <c:set var="vPercent" value="${fn:replace(vValStr, '%', '')}" />
                                                        </c:if>

                                                        <%-- HÀNG 1: Edit & Delete --%>
                                                        <div class="d-flex gap-2">
                                                            <button type="button" class="btn-soft btn-soft-primary" data-bs-toggle="modal" data-bs-target="#updateProductModal"
                                                                    data-id="${p.id}" data-name="${p.name}" data-price="${p.price}" 
                                                                    data-picurl="${p.picURL}" data-description="${p.description}" 
                                                                    data-categoryid="${p.categoryID}" 
                                                                    data-voucher-percent="${vPercent}" 
                                                                    title="Edit">
                                                                <i class="bi bi-pencil-fill"></i>
                                                            </button>

                                                            <button type="button" class="btn-soft btn-soft-danger" data-bs-toggle="modal" data-bs-target="#deleteConfirmationModal"
                                                                    data-product-id="${p.id}" data-product-name="${p.name}" title="Delete">
                                                                <i class="bi bi-trash-fill"></i>
                                                            </button>
                                                        </div>

                                                        <%-- HÀNG 2: Deactive & Detail --%>
                                                        <div class="d-flex gap-2">
                                                            <c:choose>
                                                                <c:when test="${p.is_active}">
                                                                    <button type="button" class="btn-soft btn-soft-warning" data-bs-toggle="modal" data-bs-target="#toggleStatusModal"
                                                                                data-id="${p.id}" data-action-type="Deactivate" title="Deactivate">
                                                                        <i class="bi bi-eye-slash-fill"></i>
                                                                    </button>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <button type="button" class="btn-soft btn-soft-success" data-bs-toggle="modal" data-bs-target="#toggleStatusModal"
                                                                                data-id="${p.id}" data-action-type="Reactivate" title="Reactivate">
                                                                        <i class="bi bi-eye-fill"></i>
                                                                    </button>
                                                                </c:otherwise>
                                                            </c:choose>

                                                            <button type="button" class="btn-soft btn-soft-info" data-bs-toggle="modal" data-bs-target="#viewProductModal"
                                                                    data-id="${p.id}" data-name="${p.name}" data-img="${p.picURL}"
                                                                    data-cat="${categoryMap[p.categoryID]}"
                                                                    data-size-s="${sizes['S']}" data-size-m="${sizes['M']}" data-size-l="${sizes['L']}"
                                                                    data-price="${p.price}" data-voucher="${voucherMap[p.voucherID]}"
                                                                    data-status="${p.is_active ? 'Active' : 'Inactive'}" data-desc="${p.description}"
                                                                    title="View Details">
                                                                <i class="bi bi-info-circle"></i>
                                                            </button>
                                                        </div>
                                                    </div>
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

        <%-- Modal Add Product --%>
        <div class="modal fade" id="addProductModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-xl modal-dialog-centered">
                <div class="modal-content modal-content-modern">
                    <div class="modal-header-modern bg-green d-flex justify-content-between">
                        <h5 class="text-success"><i class="bi bi-plus-circle-fill me-2"></i> Add New Product</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <form action="${BASE_URL}/admin" method="post" id="addForm" enctype="multipart/form-data">
                            <input type="hidden" name="action" value="add_product">
                            <div class="row g-4">
                                <div class="col-md-4">
                                    <div class="img-preview-box" id="addPreviewBox">
                                        <i class="bi bi-image img-placeholder"></i>
                                        <img id="addPreviewImage" src="" style="display:none;">
                                    </div>
                                    <div class="form-floating mb-2">
                                        <input type="text" name="pic" id="add_pic" class="form-control" placeholder="Image URL" oninput="previewImage(this, 'addPreviewImage', 'addPreviewBox')">
                                        <label>Image URL</label>
                                    </div>
                                    <div class="text-center">
                                        <span class="text-muted small">OR</span>
                                        <input type="file" id="add_file_input" name="file" class="d-none" accept="image/*" onchange="handleFileUpload(this, 'add_pic', 'addPreviewImage', 'addPreviewBox')">
                                        <button type="button" class="btn-upload-pc" onclick="$('#add_file_input').click()">
                                            <i class="bi bi-cloud-arrow-up-fill me-2"></i> Upload from PC
                                        </button>
                                    </div>
                                </div>
                                <div class="col-md-8">
                                    <div class="row g-3">
                                        <div class="col-md-12">
                                            <div class="form-floating">
                                                <input type="text" name="name" class="form-control" placeholder="Name" maxlength="100" required>
                                                <label>Product Name</label>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-floating">
                                                <select name="category" class="form-select" required>
                                                    <option value="">-- Select Category --</option>
                                                    <c:forEach var="cate" items="${cateList}">
                                                        <option value="${cate.category_id}">${cate.type} (${cate.gender})</option>
                                                    </c:forEach>
                                                </select>
                                                <label>Category</label>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-floating">
                                                <select name="voucher" class="form-select">
                                                    <option value="">None</option>
                                                    <c:forEach var="p" items="${voucherList}">
                                                        <option value="${p.voucherPercent}">${p.voucherPercent}% Off</option>
                                                    </c:forEach>
                                                </select>
                                                <label>Discount</label>
                                            </div>
                                        </div>
                                        <div class="col-md-12">
                                            <div class="form-floating">
                                                <input type="number" name="price" class="form-control" placeholder="Price" min="1" max="999999999" required>
                                                <label>Price (VND)</label>
                                            </div>
                                        </div>
                                        <div class="col-md-12">
                                            <div class="form-floating">
                                                <textarea name="des" class="form-control" placeholder="Description" style="height: 100px" maxlength="255" required></textarea>
                                                <label>Description</label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="mt-4 text-end border-top pt-3">
                                <button type="button" class="btn btn-light me-2" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="submit-btn btn btn-success px-4 fw-bold">Add Product</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <%-- Modal Update Product --%>
        <div class="modal fade" id="updateProductModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-xl modal-dialog-centered">
                <div class="modal-content modal-content-modern">
                    <div class="modal-header-modern bg-blue d-flex justify-content-between">
                        <h5 class="text-primary"><i class="bi bi-pencil-square me-2"></i> Update Product</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <form action="${BASE_URL}/admin" method="post" id="updateForm" enctype="multipart/form-data">
                            <input type="hidden" name="action" value="update_product">
                            <input type="hidden" name="id" id="update_id">
                            
                            <div class="row g-4">
                                <div class="col-md-4">
                                    <div class="img-preview-box" id="updatePreviewBox">
                                        <img id="updatePreviewImage" src="">
                                    </div>
                                    <div class="form-floating mb-2">
                                        <input type="text" name="pic" id="update_pic" class="form-control" placeholder="Image URL" oninput="previewImage(this, 'updatePreviewImage', 'updatePreviewBox')">
                                        <label>Image URL</label>
                                    </div>
                                    <div class="text-center">
                                        <span class="text-muted small">OR</span>
                                        <input type="file" id="update_file_input" name="file" class="d-none" accept="image/*" onchange="handleFileUpload(this, 'update_pic', 'updatePreviewImage', 'updatePreviewBox')">
                                        <button type="button" class="btn-upload-pc" onclick="$('#update_file_input').click()">
                                            <i class="bi bi-cloud-arrow-up-fill me-2"></i> Upload from PC
                                        </button>
                                    </div>
                                </div>
                                <div class="col-md-8">
                                    <div class="row g-3">
                                        <div class="col-md-12">
                                            <div class="form-floating">
                                                <input type="text" name="name" id="update_name" class="form-control" maxlength="100" required>
                                                <label>Product Name</label>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-floating">
                                                <select name="category" id="update_category" class="form-select" required>
                                                    <option value="">-- Select Category --</option>
                                                    <c:forEach var="cate" items="${cateList}">
                                                        <option value="${cate.category_id}">${cate.type} (${cate.gender})</option>
                                                    </c:forEach>
                                                </select>
                                                <label>Category</label>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-floating">
                                                <select name="voucher" id="update_voucher" class="form-select">
                                                    <option value="0">None</option>
                                                    <c:forEach var="p" items="${voucherList}">
                                                        <option value="${p.voucherPercent}">${p.voucherPercent}% Off</option>
                                                    </c:forEach>
                                                </select>
                                                <label>Discount</label>
                                            </div>
                                        </div>
                                        <div class="col-md-12">
                                            <div class="form-floating">
                                                <input type="number" name="price" id="update_price" class="form-control" min="1" max="999999999" required>
                                                <label>Price (VND)</label>
                                            </div>
                                        </div>
                                        <div class="col-md-12">
                                            <div class="form-floating">
                                                <textarea name="des" id="update_des" class="form-control" style="height: 100px" maxlength="255" required></textarea>
                                                <label>Description</label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="mt-4 text-end border-top pt-3">
                                <button type="button" class="btn btn-light me-2" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="submit-btn btn btn-primary px-4 fw-bold">Save Changes</button>
                            </div>
                        </form>
                    </div>
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
                                    <h3 id="view_price" class="text-primary fw-bold mb-0 me-3"></h3>
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

        <%-- Modal Delete Confirmation --%>
        <div class="modal fade" id="deleteConfirmationModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-scrollable modal-dialog-centered">
                <div class="modal-content border-danger border-top border-5">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold text-danger" id="deleteConfirmationModalLabel">Delete Product: <span></span></h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div id="deleteStatusAlert"></div>
                        <div id="relatedDataLoading" class="text-center p-4">
                            <div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div>
                            <p class="mt-2 text-muted">Checking for related data...</p>
                        </div>
                        <div id="relatedDataContent" style="display: none;">
                            <p class="fw-bold small text-uppercase text-muted">Related product data:</p>
                            <ul class="nav nav-tabs nav-justified mb-3" id="relatedDataTab" role="tablist">
                                <li class="nav-item"><button class="nav-link active" data-bs-toggle="tab" data-bs-target="#sizes-content" type="button">Sizes <span class="badge bg-secondary" id="sizes-count">0</span></button></li>
                                <li class="nav-item"><button class="nav-link" data-bs-toggle="tab" data-bs-target="#carts-content" type="button">Carts <span class="badge bg-secondary" id="carts-count">0</span></button></li>
                                <li class="nav-item"><button class="nav-link" data-bs-toggle="tab" data-bs-target="#orders-content" type="button">Orders <span class="badge bg-secondary" id="orders-count">0</span></button></li>
                                <li class="nav-item"><button class="nav-link" data-bs-toggle="tab" data-bs-target="#imports-content" type="button">Imports <span class="badge bg-secondary" id="imports-count">0</span></button></li>
                                <li class="nav-item"><button class="nav-link" data-bs-toggle="tab" data-bs-target="#feedbacks-content" type="button">Feedbacks <span class="badge bg-secondary" id="feedbacks-count">0</span></button></li>
                            </ul>
                            
                            <div class="tab-content" id="relatedDataTabContent">
                                <div class="tab-pane fade show active" id="sizes-content">
                                    <table class="table table-sm table-bordered mb-0">
                                        <thead class="table-light"><tr><th>Size Name</th><th>Quantity</th></tr></thead>
                                        <tbody id="sizes-table-body"></tbody>
                                    </table>
                                    <p id="sizes-none" class="text-muted small text-center py-3 mt-2 border-top" style="display: none;">No data found.</p>
                                </div>

                                <div class="tab-pane fade" id="carts-content">
                                    <table class="table table-sm table-bordered mb-0">
                                        <thead class="table-light"><tr><th>Cart ID</th><th>Customer ID</th><th>Size</th><th>Quantity</th></tr></thead>
                                        <tbody id="carts-table-body"></tbody>
                                    </table>
                                    <p id="carts-none" class="text-muted small text-center py-3 mt-2 border-top" style="display: none;">No data found.</p>
                                </div>

                                <div class="tab-pane fade" id="orders-content">
                                    <table class="table table-sm table-bordered mb-0">
                                        <thead class="table-light"><tr><th>Order ID</th><th>Size</th><th>Quantity</th></tr></thead>
                                        <tbody id="orders-table-body"></tbody>
                                    </table>
                                    <p id="orders-none" class="text-muted small text-center py-3 mt-2 border-top" style="display: none;">No data found.</p>
                                </div>

                                <div class="tab-pane fade" id="imports-content">
                                    <table class="table table-sm table-bordered mb-0">
                                        <thead class="table-light"><tr><th>Import ID</th><th>Date</th><th>Total</th><th>Status</th></tr></thead>
                                        <tbody id="imports-table-body"></tbody>
                                    </table>
                                    <p id="imports-none" class="text-muted small text-center py-3 mt-2 border-top" style="display: none;">No data found.</p>
                                </div>

                                <div class="tab-pane fade" id="feedbacks-content">
                                    <table class="table table-sm table-bordered mb-0">
                                        <thead class="table-light"><tr><th>ID</th><th>Customer</th><th>Rating</th></tr></thead>
                                        <tbody id="feedbacks-table-body"></tbody>
                                    </table>
                                    <p id="feedbacks-none" class="text-muted small text-center py-3 mt-2 border-top" style="display: none;">No data found.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer border-0">
                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Close</button>
                        <button id="confirmDeleteButton" type="button" class="btn btn-danger" style="display: none;"><i class="bi bi-trash-fill me-2"></i> Confirm Delete</button>
                    </div>
                </div>
            </div>
        </div>

        <%-- Modal Toggle Status --%>
        <div class="modal fade" id="toggleStatusModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title fw-bold">Confirm Action</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body text-center py-4">
                        <p class="mb-0 fs-5">Are you sure you want to change this product's status?</p>
                    </div>
                    <div class="modal-footer justify-content-center border-0">
                        <button type="button" class="btn btn-light px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" id="confirmToggleButton" class="btn btn-primary px-4">Confirm</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.5/dist/jquery.validate.min.js"></script>

        <script>
            // --- GLOBAL HELPERS ---
            function previewImage(input, imgId, boxId) {
                const url = input.value;
                const img = document.getElementById(imgId);
                const box = document.getElementById(boxId);
                const placeholder = box.querySelector('.img-placeholder');
                if(url) {
                    img.src = url; img.style.display = 'block';
                    img.onload = function() { if(placeholder) placeholder.style.display = 'none'; };
                    img.onerror = function() { img.style.display = 'none'; if(placeholder) placeholder.style.display = 'block'; };
                } else {
                    img.style.display = 'none'; if(placeholder) placeholder.style.display = 'block';
                }
            }

            function handleFileUpload(input, urlInputId, imgId, boxId) {
                if (input.files && input.files[0]) {
                    var file = input.files[0];
                    const maxSize = 10 * 1024 * 1024; // 10MB
                    if (file.size > maxSize) {
                        alert("File is too large! Please upload an image smaller than 10MB.");
                        input.value = ""; return;
                    }
                    var objectURL = URL.createObjectURL(file);
                    $('#' + imgId).attr('src', objectURL).show();
                    $('#' + boxId + ' .img-placeholder').hide();
                    $('#' + urlInputId).val("File: " + file.name);
                }
            }

            function showToast(message, type = 'success') {
                const toast = $('#toast-message');
                const icon = toast.find('i');
                const text = $('#toast-text');

                toast.removeClass('toast-success toast-danger toast-warning toast-info').addClass('active');
                icon.removeClass('fa-check-circle fa-exclamation-circle fa-eye-slash fa-info-circle');

                if (type === 'danger') {
                    toast.addClass('toast-danger'); icon.addClass('fa-exclamation-circle');
                } else if (type === 'warning') {
                    toast.addClass('toast-warning'); icon.addClass('fa-eye-slash');
                } else if (type === 'info') {
                    toast.addClass('toast-info'); icon.addClass('fa-info-circle');
                } else {
                    toast.addClass('toast-success'); icon.addClass('fa-check-circle');
                }
                text.text(message);
                setTimeout(() => { toast.removeClass('active'); }, 4000);
            }

            // --- [UPDATED] SPA LOGIC WITH LOADER & BLUR ---
            
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
                }, 400); // 400ms delay for smooth entrance
            });

            function getFilterUrl(page) {
                let params = {
                    tab: 'product',
                    search: $('#filter-search').val(),
                    category: $('#filter-category').val(),
                    status: $('#filter-status').val(),
                    sort: $('#filter-sort').val(),
                    page: page || $('#current-page').val() || 1
                };
                return "${BASE_URL}/admin?" + $.param(params);
            }

            function loadTable(url, pushState = true) {
                toggleTableBlur(true); // START BLUR

                $.ajax({
                    url: url,
                    type: 'GET',
                    success: function(response) {
                        let newContent = $(response).find('#product-content-container').html();
                        let newBadge = $(response).find('#total-product-badge').html();
                        
                        // Update Content
                        $('#product-content-container').html(newContent);
                        $('#total-product-badge').html(newBadge);
                        
                        if (pushState) {
                            window.history.pushState({path: url}, '', url);
                        }
                        let newPageVal = $(response).find('#current-page').val();
                        if (newPageVal) $('#current-page').val(newPageVal);
                        
                        // END BLUR with slight delay for smoothness
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
                    // Visual feedback: blur immediately
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

            // --- CRUD AJAX HANDLERS ---

            // ADD
            $("#addForm").validate({
                rules: { 
                    name: {required: true, maxlength: 100}, price: {required: true, number: true, min: 1, max: 999999999}, category: {required: true}, des: {required: true, maxlength: 255}, 
                    pic: { required: function(element) { return $('#add_file_input')[0].files.length === 0; } } 
                },
                messages: { price: { max: "Max Price is 999.999.999" } },
                errorElement: "label", errorClass: "error", errorPlacement: function (error, element) { error.insertAfter(element.closest('.form-floating') || element); },
                submitHandler: function (form) {
                    var $btn = $(form).find('.submit-btn');
                    $btn.prop('disabled', true).html('<span class="spinner-border spinner-border-sm"></span> Adding...');
                    
                    $.ajax({
                        url: $(form).attr('action'), type: 'POST', data: new FormData(form),
                        processData: false, contentType: false, dataType: 'json',
                        success: function (data) {
                            if (data.isSuccess) {
                                $('#addProductModal').modal('hide');
                                form.reset();
                                $('#addPreviewImage').hide();
                                $('.img-placeholder').show();
                                showToast('Product added successfully!', 'success');
                                loadTable(getFilterUrl(1)); 
                            } else { alert(data.description); }
                            $btn.prop('disabled', false).text('Add Product');
                        },
                        error: function() { alert('Error adding product'); $btn.prop('disabled', false).text('Add Product'); }
                    });
                }
            });

            // UPDATE
            $("#updateForm").validate({
                rules: { 
                    name: {required: true, maxlength: 100}, price: {required: true, number: true, min: 1, max: 999999999}, category: {required: true}, des: {required: true, maxlength: 255},
                    pic: { required: function(element) { return $('#update_file_input')[0].files.length === 0; } } 
                },
                messages: { price: { max: "Max Price is 999.999.999" } },
                errorElement: "label", errorClass: "error", errorPlacement: function (error, element) { error.insertAfter(element.closest('.form-floating') || element); },
                submitHandler: function (form) {
                    var $btn = $(form).find('.submit-btn');
                    $btn.prop('disabled', true).html('<span class="spinner-border spinner-border-sm"></span> Saving...');
                    
                    $.ajax({
                        url: $(form).attr('action'), type: 'POST', data: new FormData(form),
                        processData: false, contentType: false, dataType: 'json',
                        success: function (data) {
                            if (data.isSuccess) {
                                $('#updateProductModal').modal('hide');
                                showToast('Product updated successfully!', 'info');
                                loadTable(getFilterUrl()); 
                            } else { alert(data.description); }
                            $btn.prop('disabled', false).text('Save Changes');
                        },
                        error: function() { alert('Error updating product'); $btn.prop('disabled', false).text('Save Changes'); }
                    });
                }
            });

            // DELETE
            $('#confirmDeleteButton').off('click').on('click', function () {
                var btn = $(this); 
                var productId = btn.data('product-id');
                btn.prop('disabled', true).html('<span class="spinner-border spinner-border-sm"></span> Deleting...');
                toggleTableBlur(true); // Blur background while processing

                $.ajax({
                    url: '${BASE_URL}/admin', type: 'POST', data: { action: 'delete_product', id: productId }, dataType: 'json',
                    success: function (data) {
                        if (data.isSuccess) { 
                            $('#deleteConfirmationModal').modal('hide');
                            showToast('Product deleted!', 'danger');
                            loadTable(getFilterUrl()); 
                        } else { 
                            alert('Error: ' + data.description); 
                            toggleTableBlur(false); 
                        }
                        btn.prop('disabled', false).html('<i class="bi bi-trash-fill me-2"></i> Confirm Delete');
                    },
                    error: function () { 
                        alert('Server error.'); 
                        btn.prop('disabled', false).html('<i class="bi bi-trash-fill me-2"></i> Confirm Delete');
                        toggleTableBlur(false);
                    }
                });
            });

            // TOGGLE STATUS
            const toggleModal = document.getElementById('toggleStatusModal');
            if (toggleModal) {
                toggleModal.addEventListener('show.bs.modal', function (event) {
                    const btn = event.relatedTarget;
                    const id = btn.getAttribute('data-id');
                    const type = btn.getAttribute('data-action-type');
                    const confirmBtn = $('#confirmToggleButton');
                    confirmBtn.data('id', id).data('type', type);
                    if (type === 'Deactivate') {
                        confirmBtn.removeClass('btn-primary btn-success').addClass('btn-warning');
                    } else {
                        confirmBtn.removeClass('btn-warning btn-primary').addClass('btn-success');
                    }
                });
            }

            $('#confirmToggleButton').click(function() {
                const btn = $(this);
                const id = btn.data('id');
                const type = btn.data('type'); 
                const url = '${BASE_URL}/toggleProductStatus?id=' + id + '&tab=product'; 
                
                $.ajax({
                    url: url,
                    type: 'GET', 
                    success: function() {
                        $('#toggleStatusModal').modal('hide');
                        let msg = type === 'Deactivate' ? 'Product deactivated!' : 'Product reactivated!';
                        let msgType = type === 'Deactivate' ? 'warning' : 'success';
                        showToast(msg, msgType);
                        loadTable(getFilterUrl());
                    },
                    error: function() {
                        alert('Error changing status');
                    }
                });
            });

            // Modal Populate Logic (Keep existing)
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

            const updateModalEl = document.getElementById('updateProductModal');
            if (updateModalEl) {
                updateModalEl.addEventListener('show.bs.modal', function (event) {
                    const btn = event.relatedTarget;
                    $('#update_id').val(btn.getAttribute('data-id'));
                    $('#update_name').val(btn.getAttribute('data-name'));
                    $('#update_price').val(btn.getAttribute('data-price'));
                    $('#update_pic').val(btn.getAttribute('data-picurl'));
                    $('#update_des').val(btn.getAttribute('data-description'));
                    $('#update_category').val(btn.getAttribute('data-categoryid'));
                    $('#update_voucher').val(btn.getAttribute('data-voucher-percent'));
                    previewImage(document.getElementById('update_pic'), 'updatePreviewImage', 'updatePreviewBox');
                });
            }

            // DELETE MODAL LOGIC (FIXED)
            const deleteModalEl = document.getElementById('deleteConfirmationModal');
            if (deleteModalEl) {
                deleteModalEl.addEventListener('show.bs.modal', function (event) {
                    var button = event.relatedTarget;
                    var productId = button.getAttribute('data-product-id');
                    var productName = button.getAttribute('data-product-name');
                    
                    var modalTitle = deleteModalEl.querySelector('#deleteConfirmationModalLabel span');
                    if(modalTitle) modalTitle.textContent = productName;
                    
                    $('#confirmDeleteButton').data('product-id', productId);
                    
                    $('#relatedDataLoading').show();
                    $('#relatedDataContent').hide();
                    $('#deleteStatusAlert').empty();
                    $('#confirmDeleteButton').hide().removeClass('disabled').html('<i class="bi bi-trash-fill me-2"></i> Confirm Delete');
                    
                    $('#sizes-table-body, #carts-table-body, #orders-table-body, #imports-table-body, #feedbacks-table-body').empty();
                    $('#sizes-none, #carts-none, #orders-none, #imports-none, #feedbacks-none').hide();
                    
                    $('#sizes-count, #carts-count, #orders-count, #imports-count, #feedbacks-count')
                        .text('0').removeClass('bg-danger bg-success bg-warning').addClass('bg-secondary');

                    var firstTabEl = document.querySelector('#relatedDataTab button[data-bs-target="#sizes-content"]');
                    if(firstTabEl) {
                        var firstTab = new bootstrap.Tab(firstTabEl);
                        firstTab.show();
                    }

                    // --- AJAX CALL (CORRECTED) ---
                    $.ajax({
                        url: '${BASE_URL}/admin', // Points to the main servlet
                        type: 'GET',
                        data: {
                            action: 'get_product_related_data', // Identify the specific operation
                            productId: productId
                        },
                        dataType: 'json',
                        success: function (data) {
                            var reasons = [];
                            var canDelete = true;
                            
                            // 1. SIZES
                            if (data.sizes && data.sizes.length > 0) {
                                var totalStock = 0;
                                $.each(data.sizes, function (i, item) { 
                                    var rowClass = item.quantity > 0 ? 'table-danger' : '';
                                    $('#sizes-table-body').append('<tr class="'+rowClass+'"><td>' + item.size_name + '</td><td>' + item.quantity + '</td></tr>'); 
                                    totalStock += item.quantity;
                                });
                                $('#sizes-count').text(data.sizes.length).removeClass('bg-secondary').addClass('bg-danger');
                                if (totalStock > 0) {
                                    reasons.push("Product still has physical stock (Total: " + totalStock + ").");
                                    canDelete = false;
                                }
                            } else { 
                                $('#sizes-count').text(0).addClass('bg-secondary'); 
                                $('#sizes-none').show(); 
                            }
                            
                            // 2. CARTS
                            if (data.carts && data.carts.length > 0) { 
                                $('#carts-count').text(data.carts.length).removeClass('bg-secondary').addClass('bg-danger'); 
                                $.each(data.carts, function (i, item) { $('#carts-table-body').append('<tr><td>' + item.cart_id + '</td><td>' + item.customer_id + '</td><td>' + item.size_name + '</td><td>' + item.quantity + '</td></tr>'); }); 
                                reasons.push("Product is currently in " + data.carts.length + " shopping carts.");
                                canDelete = false;
                            } else { 
                                $('#carts-count').text(0).addClass('bg-secondary'); 
                                $('#carts-none').show(); 
                            }

                            // 3. ORDERS
                            if (data.orders && data.orders.length > 0) { 
                                $('#orders-count').text(data.orders.length).removeClass('bg-secondary').addClass('bg-danger'); 
                                $.each(data.orders, function (i, item) { $('#orders-table-body').append('<tr><td>' + item.orderID + '</td><td>' + item.size_name + '</td><td>' + item.quantity + '</td></tr>'); }); 
                                reasons.push("Product exists in " + data.orders.length + " orders."); canDelete = false;
                            } else { 
                                $('#orders-count').text(0).addClass('bg-secondary'); 
                                $('#orders-none').show(); 
                            }

                            // 4. IMPORTS
                            if (data.imports && data.imports.length > 0) { 
                                $('#imports-count').text(data.imports.length).removeClass('bg-secondary').addClass('bg-danger'); 
                                $.each(data.imports, function (i, item) { $('#imports-table-body').append('<tr><td>' + item.id + '</td><td>' + item.date + '</td><td>' + item.total + '</td><td>' + item.status + '</td></tr>'); }); 
                                reasons.push("Product has import history."); canDelete = false;
                            } else { 
                                $('#imports-count').text(0).addClass('bg-secondary'); 
                                $('#imports-none').show(); 
                            }

                            // 5. FEEDBACKS
                            if (data.feedbacks && data.feedbacks.length > 0) { 
                                $('#feedbacks-count').text(data.feedbacks.length).removeClass('bg-secondary').addClass('bg-danger'); 
                                $.each(data.feedbacks, function (i, item) { $('#feedbacks-table-body').append('<tr><td>' + item.feedback_id + '</td><td>' + item.customer_id + '</td><td>' + item.rate_point + '</td></tr>'); }); 
                                reasons.push("Product has user feedbacks."); canDelete = false;
                            } else { 
                                $('#feedbacks-count').text(0).addClass('bg-secondary'); 
                                $('#feedbacks-none').show(); 
                            }

                            $('#relatedDataLoading').hide(); 
                            $('#relatedDataContent').show();
                            
                            if (!canDelete) {
                                let html = '<div class="alert alert-danger"><strong>Cannot Delete:</strong><ul class="mb-0 ps-3">';
                                reasons.forEach(function(r) { html += '<li>' + r + '</li>'; });
                                html += '</ul></div>';
                                $('#deleteStatusAlert').html(html); $('#confirmDeleteButton').hide();
                            } else {
                                $('#deleteStatusAlert').html('<div class="alert alert-success"><strong>Safe to Delete:</strong> Product has no active stock or dependencies.</div>');
                                $('#confirmDeleteButton').show();
                            }
                        },
                        error: function (jqXHR, textStatus, errorThrown) { 
                            console.log("Error details:", jqXHR.responseText);
                            var errorMsg = "Unknown Error";
                            if (jqXHR.responseJSON && jqXHR.responseJSON.message) {
                                errorMsg = jqXHR.responseJSON.message;
                            } else if (jqXHR.responseText) {
                                if (jqXHR.responseText.includes("<!DOCTYPE html>")) {
                                    errorMsg = "Server returned HTML instead of JSON. Check Login or URL path.";
                                } else {
                                    errorMsg = jqXHR.responseText;
                                }
                            } else {
                                errorMsg = errorThrown;
                            }
                            $('#relatedDataLoading').html('<div class="alert alert-danger"><strong>Error checking data:</strong> ' + errorMsg + '</div>'); 
                        }
                    });
                });
            }
        </script>
    </body>
</html>