<%-- 
    Document   : admin_ImportManagement.jsp
    Description: Import Management (Modern UI Upgrade)
--%>
<%@page import="entity.Staff"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="BASE_URL" value="${pageContext.request.contextPath}" />
<%
    Staff s = (Staff) session.getAttribute("staff");
    Object c = session.getAttribute("acc");

    // SECURITY CHECK
    if (c != null && s == null) { response.sendRedirect(request.getContextPath() + "/"); return; }
    if (s == null) { response.sendRedirect(request.getContextPath() + "/login.jsp"); return; }
    if (!"admin".equalsIgnoreCase(s.getRole())) { response.sendRedirect(request.getContextPath() + "/staff"); return; }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin | Import Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://kit.fontawesome.com/1bd876819f.js" crossorigin="anonymous"></script>
    <link href='https://fonts.googleapis.com/css?family=Quicksand:400,500,600,700&display=swap' rel='stylesheet'>
    <link rel="icon" href="${BASE_URL}/images/LG2.png" type="image/x-icon">

    <style>
        :root {
            --primary-color: #4e73df;
            --success-color: #1cc88a;
            --warning-color: #f6c23e;
            --danger-color: #e74a3b;
            --light-bg: #f8f9fc;
            --card-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
        }

        body {
            font-family: 'Quicksand', sans-serif;
            background-color: var(--light-bg);
            color: #5a5c69;
        }

        /* --- CARD STYLE --- */
        .card-modern {
            background: #fff;
            border: none;
            border-radius: 15px;
            box-shadow: var(--card-shadow);
            margin-bottom: 25px;
            overflow: hidden;
        }

        .card-header-modern {
            background: #fff;
            padding: 20px 25px;
            border-bottom: 1px solid #e3e6f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .page-title {
            font-weight: 700;
            color: var(--primary-color);
            font-size: 1.5rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .stat-badge {
            background: rgba(78, 115, 223, 0.1);
            color: var(--primary-color);
            padding: 5px 12px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.9rem;
        }

        /* --- FILTER BAR --- */
        .filter-container {
            padding: 20px 25px;
            background-color: #fff;
            border-bottom: 1px solid #f0f0f0;
        }
        .search-input-group .input-group-text { background: transparent; border-right: none; color: #aaa; }
        .search-input-group .form-control { border-left: none; box-shadow: none; }
        .search-input-group .form-control:focus { border-color: #ced4da; }

        /* --- TABLE STYLES --- */
        .table-modern { width: 100%; margin-bottom: 0; }
        .table-modern thead th {
            background-color: #f8f9fc;
            color: #858796;
            font-weight: 700;
            text-transform: uppercase;
            font-size: 0.85rem;
            border-bottom: 2px solid #e3e6f0;
            padding: 15px;
            border-top: none;
        }
        .table-modern tbody td {
            padding: 15px;
            vertical-align: middle;
            border-bottom: 1px solid #e3e6f0;
            color: #5a5c69;
            font-size: 0.95rem;
        }
        .table-modern tbody tr:hover { background-color: #fcfcfc; }

        /* --- AVATAR --- */
        .avatar-circle {
            width: 40px; height: 40px; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            color: white; font-weight: bold; font-size: 1rem;
            margin-right: 12px; text-transform: uppercase; flex-shrink: 0;
        }
        .user-cell { display: flex; align-items: center; }

        /* --- BADGES & BUTTONS --- */
        .status-badge { padding: 5px 12px; border-radius: 20px; font-size: 0.85rem; font-weight: 700; }
        .badge-pending { background: #fff3cd; color: #856404; }
        .badge-delivered, .badge-done { background: #d1e7dd; color: #0f5132; }

        .btn-soft { border: none; border-radius: 8px; width: 32px; height: 32px; display: inline-flex; align-items: center; justify-content: center; transition: all 0.2s; margin: 0 2px; cursor: pointer; }
        .btn-soft:hover { transform: translateY(-2px); }
        .btn-soft-success { background: rgba(28, 200, 138, 0.15); color: #1cc88a; }
        .btn-soft-success:hover { background: #1cc88a; color: #fff; }
        .btn-soft-secondary { background: rgba(133, 135, 150, 0.15); color: #858796; }
        .btn-soft-secondary:hover { background: #858796; color: #fff; }
        .btn-soft-secondary.active { background: #4e73df; color: #fff; transform: rotate(180deg); }

        /* --- DETAIL ROW --- */
        .detail-row-container { background-color: #f8f9fc; padding: 20px; box-shadow: inset 0 0 10px rgba(0,0,0,0.05); }
        .detail-card { background: #fff; border-radius: 10px; border: 1px solid #e3e6f0; overflow: hidden; }
        .detail-header { background: #4e73df; color: white; padding: 10px 15px; font-weight: 600; display: flex; align-items: center; gap: 10px; }

        /* --- MODAL --- */
        .modal-content-modern { border-radius: 15px; border: none; overflow: hidden; }
        .modal-header-modern { background: #f8f9fc; padding: 20px; border-bottom: 1px solid #eee; }
        .form-control-modern { border-radius: 8px; padding: 10px; border: 1px solid #d1d3e2; }
        .btn-add-item { width: 100%; height: 42px; background: #2c3e50; color: white; font-weight: 600; border-radius: 8px; border: none; transition: 0.2s; }
        .btn-add-item:hover { background: #1a252f; }
        .import-list-box { max-height: 250px; overflow-y: auto; border: 1px solid #e3e6f0; border-radius: 8px; margin-top: 15px; }

        /* --- TOAST & LOADER --- */
        .toast-notification { position: fixed; top: 20px; left: 50%; transform: translateX(-50%); z-index: 1060; padding: 12px 20px; border-radius: 10px; background: #fff; box-shadow: 0 5px 15px rgba(0,0,0,0.15); display: none; align-items: center; gap: 10px; border-left: 4px solid #4e73df; animation: slideDown 0.4s ease; }
        @keyframes slideDown { from { top: -50px; opacity: 0; } to { top: 20px; opacity: 1; } }
        #table-loader { display: flex; justify-content: center; height: 200px; align-items: center; }

        .pagination-wrapper { margin-top: 20px; display: flex; justify-content: flex-end; }
        .custom-pagination { display: flex; list-style: none; gap: 5px; padding: 0; }
        .custom-page-link { width: 35px; height: 35px; display: flex; align-items: center; justify-content: center; border-radius: 8px; background: #fff; border: 1px solid #e3e6f0; color: #858796; text-decoration: none; transition: all 0.2s; cursor: pointer; }
        .custom-page-link:hover { background: #f8f9fc; }
        .custom-page-item.active .custom-page-link { background: var(--primary-color); color: white; border-color: var(--primary-color); }
        .btn-add-new {
                background: linear-gradient(45deg, #1cc88a, #13855c);
                border: none;
                box-shadow: 0 4px 10px rgba(28, 200, 138, 0.3);
                color: white;
                padding: 10px 20px;
                border-radius: 10px;
                font-weight: 600;
                transition: transform 0.2s;
            }
            .btn-add-new:hover {
                transform: translateY(-2px);
                color: whitesmoke !important;
                
            }
    </style>
</head>

<body id="admin-body">
    <div id="toast-message" class="toast-notification">
        <i class="bi bi-info-circle-fill text-primary"></i>
        <span id="toast-text" class="fw-bold text-dark">Notification</span>
    </div>

    <jsp:include page="admin_header-sidebar.jsp" />

    <div class="main-content p-4">
        <div class="card-modern">
            <div class="card-header-modern">
                <div class="page-title">
                    <i class="bi bi-box-arrow-in-down"></i> Import Management
                    <span class="stat-badge ms-2"><c:out value="${totalImports}" default="${fn:length(importList)}"/> Imports</span>
                </div>
                <button class="btn btn-add-new" data-bs-toggle="modal" data-bs-target="#createImportModal">
                    <i class="bi bi-plus-lg me-1"></i> Create New Import
                </button>
            </div>

            <div class="filter-container">
                <form action="${BASE_URL}/admin" method="GET" class="d-flex gap-3">
                    <input type="hidden" name="tab" value="import">
                    <div class="input-group search-input-group" style="max-width: 400px;">
                        <span class="input-group-text"><i class="bi bi-search"></i></span>
                        <input type="text" name="import_search" class="form-control" placeholder="Search by Staff Name..." value="${importSearch}">
                        <button class="btn btn-primary" type="submit">Search</button>
                    </div>
                </form>
            </div>

            <div id="table-loader"><div class="spinner-border text-primary"></div></div>

            <div id="import-content-container" style="display: none;">
                <div class="table-responsive">
                    <table class="table table-modern align-middle">
                        <thead>
                            <tr>
                                <th style="width: 10%">ID</th>
                                <th style="width: 25%">Staff</th>
                                <th style="width: 15%" class="text-center">Date</th>
                                <th style="width: 10%" class="text-center">Qty</th>
                                <th style="width: 15%" class="text-center">Status</th>
                                <th style="width: 15%" class="text-end">Total Price</th>
                                <th style="width: 10%" class="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty importList}">
                                    <c:forEach items="${importList}" var="imp">
                                        <tr>
                                            <td class="fw-bold text-muted">#${imp.id}</td>
                                            <td>
                                                <div class="user-cell">
                                                    <div class="avatar-circle" data-name="${imp.username}"></div>
                                                    <div><span class="fw-bold text-dark">${imp.username}</span></div>
                                                </div>
                                            </td>
                                            <td class="text-center"><fmt:formatDate value="${imp.date}" pattern="dd/MM/yyyy" /></td>
                                            <td class="text-center"><span class="badge bg-light text-dark border">${imp.quantity}</span></td>
                                            <td class="text-center">
                                                <span class="status-badge badge-${fn:toLowerCase(imp.status)}">${imp.status}</span>
                                            </td>
                                            <td class="text-end fw-bold text-danger">
                                                <fmt:formatNumber value="${imp.total}" pattern="###,###" /> VND
                                            </td>
                                            <td class="text-center">
                                                <button class="btn-soft btn-soft-secondary view-btn" onclick="toggleDetail(this)">
                                                    <i class="bi bi-chevron-down"></i>
                                                </button>
                                                <c:if test="${imp.status eq 'Pending'}">
                                                    <button class="btn-soft btn-soft-success ms-1" onclick="confirmImport(${imp.id})" title="Confirm Import">
                                                        <i class="bi bi-check-lg"></i>
                                                    </button>
                                                </c:if>
                                            </td>
                                        </tr>

                                        <tr class="import-detail-row" style="display: none;">
                                            <td colspan="7" class="p-0 border-0">
                                                <div class="detail-row-container">
                                                    <div class="detail-card">
                                                        <div class="detail-header">
                                                            <i class="bi bi-list-ul"></i> Import Details #${imp.id}
                                                        </div>
                                                        <div class="table-responsive">
                                                            <table class="table table-sm table-striped mb-0">
                                                                <thead class="bg-light text-secondary">
                                                                    <tr>
                                                                        <th class="ps-4">Product Name</th>
                                                                        <th class="text-center">Size</th>
                                                                        <th class="text-center">Quantity</th>
                                                                        <th class="text-end pe-4">Subtotal</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody>
                                                                    <c:choose>
                                                                        <c:when test="${not empty importDetailMap[imp.id]}">
                                                                            <c:forEach items="${importDetailMap[imp.id]}" var="d">
                                                                                <tr>
                                                                                    <td class="ps-4">
                                                                                        <span class="fw-bold text-dark">${d.productName}</span>
                                                                                        <br><small class="text-muted">ID: P-${d.productID}</small>
                                                                                    </td>
                                                                                    <td class="text-center align-middle"><span class="badge bg-secondary">${d.sizeName}</span></td>
                                                                                    <td class="text-center align-middle fw-bold">x${d.quantity}</td>
                                                                                    <td class="text-end align-middle pe-4 text-muted">
                                                                                        <fmt:formatNumber value="${d.price * d.quantity}" pattern="###,###"/> VND
                                                                                    </td>
                                                                                </tr>
                                                                            </c:forEach>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <tr><td colspan="4" class="text-center py-3 text-muted">No details found.</td></tr>
                                                                        </c:otherwise>
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

                <c:if test="${importTotalPages > 1}">
                    <div class="pagination-wrapper px-4 pb-3">
                        <ul class="custom-pagination">
                            <li class="custom-page-item ${importCurrentPage == 1 ? 'disabled' : ''}">
                                <a class="custom-page-link" href="${BASE_URL}/admin?tab=import&import_page=${importCurrentPage - 1}&import_search=${importSearch}"><i class="bi bi-chevron-left"></i></a>
                            </li>
                            <c:forEach begin="1" end="${importTotalPages}" var="i">
                                <li class="custom-page-item ${i == importCurrentPage ? 'active' : ''}">
                                    <a class="custom-page-link" href="${BASE_URL}/admin?tab=import&import_page=${i}&import_search=${importSearch}">${i}</a>
                                </li>
                            </c:forEach>
                            <li class="custom-page-item ${importCurrentPage == importTotalPages ? 'disabled' : ''}">
                                <a class="custom-page-link" href="${BASE_URL}/admin?tab=import&import_page=${importCurrentPage + 1}&import_search=${importSearch}"><i class="bi bi-chevron-right"></i></a>
                            </li>
                        </ul>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <div class="modal fade" id="createImportModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered"> 
            <div class="modal-content modal-content-modern">
                <div class="modal-header-modern d-flex justify-content-between">
                    <h5 class="fw-bold m-0"><i class="bi bi-box-seam-fill me-2"></i> Create New Import</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="row g-3 align-items-end"> 
                        <div class="col-md-5">
                            <label class="fw-bold small text-muted mb-1">Product</label>
                            <select id="import_product" class="form-select form-control-modern">
                                <option value="">-- Select Product --</option>
                                <c:forEach items="${productList}" var="p"><option value="${p.id}">${p.name}</option></c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="fw-bold small text-muted mb-1">Size</label>
                            <select id="import_size" class="form-select form-control-modern"><option>S</option><option>M</option><option>L</option></select>
                        </div>
                        <div class="col-md-2">
                            <label class="fw-bold small text-muted mb-1">Qty</label>
                            <input type="number" id="import_qty" class="form-control form-control-modern text-center" min="1" value="1">
                        </div>
                        <div class="col-md-2">
                            <button class="btn-add-item" onclick="addItemToTable()"><i class="bi bi-plus-lg"></i> Add</button>
                        </div>
                    </div>
                    
                    <div class="import-list-box">
                        <table class="table table-hover mb-0 align-middle">
                            <thead class="bg-light sticky-top">
                                <tr>
                                    <th class="ps-3">Product Name</th>
                                    <th class="text-center">Size</th>
                                    <th class="text-center">Qty</th>
                                    <th class="text-center">Remove</th>
                                </tr>
                            </thead>
                            <tbody id="import-items-list">
                                <tr id="empty-row"><td colspan="4" class="text-center text-muted py-4">List is empty. Add products above.</td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="modal-footer border-0 p-4 pt-0">
                    <button class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button class="btn btn-primary px-4 fw-bold" onclick="submitImport()">Submit Import</button>
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
            toast.css('border-left-color', type === 'error' ? '#e74a3b' : '#1cc88a');
            icon.attr('class', type === 'error' ? 'bi bi-exclamation-circle-fill text-danger' : 'bi bi-check-circle-fill text-success');
            
            toast.fadeIn().delay(3000).fadeOut();
        }

        function stringToColor(str) {
            let hash = 0;
            for (let i = 0; i < str.length; i++) { hash = str.charCodeAt(i) + ((hash << 5) - hash); }
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

        // --- INIT ---
        document.addEventListener("DOMContentLoaded", function () {
            setTimeout(() => {
                $('#table-loader').fadeOut(200, () => { 
                    $('#import-content-container').fadeIn(200); 
                    initAvatars();
                });
            }, 500);
        });

        // --- ACTIONS ---
        function toggleDetail(btn) {
            var row = $(btn).closest('tr');
            var detailRow = row.next('.import-detail-row');
            
            detailRow.toggle(); 
            $(btn).toggleClass('active');
            
            var icon = $(btn).find('i');
            if ($(btn).hasClass('active')) {
                icon.attr('class', 'bi bi-chevron-up');
                row.addClass('table-active'); // Add highlight
            } else {
                icon.attr('class', 'bi bi-chevron-down');
                row.removeClass('table-active');
            }
        }

        // --- IMPORT LOGIC ---
        let importItems = [];

        function addItemToTable() {
            const pId = $('#import_product').val();
            const pName = $('#import_product option:selected').text();
            const size = $('#import_size').val();
            const qty = parseInt($('#import_qty').val());

            if (!pId || qty <= 0) { showToast("Please select product and valid quantity", "error"); return; }
            
            const exists = importItems.find(i => i.productId === pId && i.size === size);
            if (exists) {
                exists.quantity += qty;
                showToast(`Updated qty for ${pName} (${size})`);
            } else {
                importItems.push({ productId: pId, productName: pName, size: size, quantity: qty });
            }
            
            renderImportTable();
            $('#import_qty').val(1);
        }

        function renderImportTable() {
            const tbody = document.getElementById('import-items-list');
            tbody.innerHTML = "";
            if (importItems.length === 0) {
                tbody.innerHTML = '<tr id="empty-row"><td colspan="4" class="text-center text-muted py-4">List is empty. Add products above.</td></tr>';
            } else {
                importItems.forEach((item, i) => {
                    tbody.innerHTML += `
                        <tr>
                            <td class="ps-3 fw-bold text-dark">${item.productName}</td>
                            <td class="text-center"><span class="badge bg-secondary">${item.size}</span></td>
                            <td class="text-center">${item.quantity}</td>
                            <td class="text-center">
                                <button class="btn btn-outline-danger btn-sm border-0" onclick="importItems.splice(${i},1);renderImportTable()">
                                    <i class="bi bi-trash-fill"></i>
                                </button>
                            </td>
                        </tr>`;
                });
            }
        }

        function submitImport() {
            if (importItems.length === 0) { showToast("Import list is empty!", "error"); return; }
            
            // Disable button
            $('.btn-submit-import').prop('disabled', true).text('Processing...');

            $.post('${BASE_URL}/admin', { action: 'create_import', items: JSON.stringify(importItems) }, function(res){
                if(res.isSuccess) {
                    location.reload(); 
                } else {
                    showToast(res.description, "error");
                    $('.btn-submit-import').prop('disabled', false).text('Submit Import');
                }
            }, 'json');
        }

        function confirmImport(id) {
            if (!confirm("Confirm import? Stock will be updated immediately.")) return;
            $.post('${BASE_URL}/admin', { action: 'update_import_status', id: id }, function(res){
                if(res.isSuccess) location.reload(); else showToast(res.description, "error");
            }, 'json');
        }
    </script>
</body>
</html>