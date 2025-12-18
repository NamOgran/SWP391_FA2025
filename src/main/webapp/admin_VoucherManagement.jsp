<%-- 
    Document   : admin_VoucherManagement.jsp
    Description: Voucher Management (Full CRUD + Date Filters + Max Discount Amount)
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="entity.Staff" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="BASE_URL" value="${pageContext.request.contextPath}" />

<%
    Staff s = (Staff) session.getAttribute("staff");
    if (s == null || !"admin".equalsIgnoreCase(s.getRole())) {
        response.sendRedirect(request.getContextPath() + (s == null ? "/login.jsp" : "/"));
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
    <head> 
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin | Voucher Management</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
        <script src="https://kit.fontawesome.com/1bd876819f.js" crossorigin="anonymous"></script>
        <link href='https://fonts.googleapis.com/css?family=Quicksand:400,500,600,700&display=swap' rel='stylesheet'> 
        <link rel="icon" href="${pageContext.request.contextPath}/images/LG2.png" type="image/x-icon"> 

        <style>
            :root {
                --primary-color: #4e73df;
                --light-bg: #f8f9fc;
                --card-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
            }
            body {
                font-family: 'Quicksand', sans-serif;
                background-color: var(--light-bg);
                color: #5a5c69;
            }
            .main-content {
                padding: 20px;
            }
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

            /* Filter & Search */
            .filter-container {
                padding: 20px 25px;
                background-color: #fff;
                border-bottom: 1px solid #f0f0f0;
            }
            .search-input-group .input-group-text {
                background: transparent;
                border-right: none;
                color: #aaa;
            }
            .search-input-group .form-control {
                border-left: none;
                box-shadow: none;
            }
            .search-input-group .form-control:focus {
                border-color: #ced4da;
            }
            .filter-label {
                font-size: 0.75rem;
                font-weight: 700;
                color: #b7b9cc;
                text-transform: uppercase;
                margin-bottom: 4px;
                display: block;
            }

            /* Table Styles */
            .table-modern {
                width: 100%;
                margin-bottom: 0;
            }
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
            .table-modern tbody tr:hover {
                background-color: #fcfcfc;
            }

            .table-blur {
                opacity: 0.5;
                pointer-events: none;
                transition: opacity 0.2s ease;
            }
            #table-loader {
                min-height: 200px;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            /* Badges & Buttons */
            .voucher-badge {
                background-color: #ffeeba;
                color: #856404;
                font-weight: 700;
                padding: 5px 12px;
                border-radius: 20px;
                font-size: 0.9rem;
                border: 1px solid #ffe8a1;
            }
            .btn-soft {
                border: none;
                border-radius: 8px;
                width: 32px;
                height: 32px;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                transition: all 0.2s;
                margin: 0 2px;
                cursor: pointer;
            }
            .btn-soft:hover {
                transform: translateY(-2px);
            }
            .btn-soft-primary {
                background: rgba(78, 115, 223, 0.1);
                color: #4e73df;
            }
            .btn-soft-primary:hover {
                background: #4e73df;
                color: #fff;
            }
            .btn-soft-danger {
                background: rgba(231, 74, 59, 0.1);
                color: #e74a3b;
            }
            .btn-soft-danger:hover {
                background: #e74a3b;
                color: #fff;
            }
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

            /* Modal & Form */
            .modal-content-modern {
                border-radius: 15px;
                border: none;
                overflow: hidden;
            }
            .modal-header-modern {
                padding: 20px;
                border-bottom: 1px solid #eee;
            }
            .modal-header-modern.bg-green {
                background: #d4edda;
                color: #155724;
            }
            .modal-header-modern.bg-blue {
                background: #cfe2ff;
                color: #084298;
            }
            .form-floating > .form-control {
                border-radius: 10px;
                border: 1px solid #d1d3e2;
            }
            .form-floating > .form-control:focus {
                border-color: #4e73df;
                box-shadow: 0 0 0 0.2rem rgba(78, 115, 223, 0.25);
            }

            /* Validation */
            label.error {
                color: #e74a3b;
                font-size: 0.85rem;
                margin-top: 2px;
                display: block;
                margin-left: 5px;
                font-weight: 600;
            }
            .form-control.error {
                border-color: #e74a3b !important;
                background-color: #fff8f8 !important;
            }

            /* Pagination */
            .pagination-wrapper {
                margin-top: 20px;
                display: flex;
                justify-content: flex-end;
            }
            .custom-pagination {
                display: flex;
                list-style: none;
                gap: 5px;
                padding: 0;
            }
            .custom-page-link {
                width: 35px;
                height: 35px;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 8px;
                background: #fff;
                border: 1px solid #e3e6f0;
                color: #858796;
                text-decoration: none;
                transition: all 0.2s;
                cursor: pointer;
            }
            .custom-page-link:hover {
                background: #f8f9fc;
            }
            .custom-page-item.active .custom-page-link {
                background: var(--primary-color);
                color: white;
                border-color: var(--primary-color);
            }
            .custom-page-item.disabled .custom-page-link {
                opacity: 0.5;
                cursor: default;
            }

            /* Toast */
            .toast-notification {
                position: fixed;
                top: 20px;
                left: 50%;
                transform: translateX(-50%);
                z-index: 1060;
                padding: 12px 20px;
                border-radius: 10px;
                background: #fff;
                box-shadow: 0 5px 15px rgba(0,0,0,0.15);
                display: none;
                align-items: center;
                gap: 10px;
                border-left: 4px solid #4e73df;
                animation: slideDown 0.4s ease;
            }
            .toast-notification.active {
                display: flex;
            }
            .toast-success {
                border-left-color: #1cc88a;
            }
            .toast-success i {
                color: #1cc88a;
            }
            .toast-danger {
                border-left-color: #e74a3b;
            }
            .toast-danger i {
                color: #e74a3b;
            }
            @keyframes slideDown {
                from {
                    top: -50px;
                    opacity: 0;
                }
                to {
                    top: 20px;
                    opacity: 1;
                }
            }
        </style>
    </head>

    <body id="admin-body">

        <%-- Toast Message Container --%>
        <div id="toast-message" class="toast-notification">
            <i class="fas"></i> <span id="toast-text"></span>
        </div>

        <jsp:include page="admin_header-sidebar.jsp" />

        <div class="main-content">
            <div class="card-modern">
                <div class="card-header-modern">
                    <div class="page-title">
                        <i class="bi bi-tags-fill"></i> Voucher Management
                        <span class="stat-badge" id="totalVouchersBadge">0 Vouchers</span>
                    </div>
                    <button class="btn-add-new" data-bs-toggle="modal" data-bs-target="#addVoucherModal">
                        <i class="bi bi-plus-lg me-1"></i> Add Voucher
                    </button>
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

                        <%-- Start Date Filter --%>
                        <div class="col-md-3">
                            <span class="filter-label">Start From</span>
                            <input type="date" id="startDateFilter" class="form-control">
                        </div>

                        <%-- End Date Filter --%>
                        <div class="col-md-3">
                            <span class="filter-label">End To</span>
                            <input type="date" id="endDateFilter" class="form-control">
                        </div>

                        <%-- Reset Button --%>
                        <div class="col-md-2">
                            <button onclick="resetFilters()" class="btn btn-light border w-100 text-muted" title="Reset Filters">
                                <i class="bi bi-arrow-counterclockwise me-1"></i>
                            </button>
                        </div>
                    </div>
                </div>

                <%-- Table Loader --%>
                <div id="table-loader">
                    <div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div>
                </div>

                <%-- Table Container (Hidden initially) --%>
                <div id="voucher-content-container" style="display: none;">
                    <div class="table-responsive">
                        <table class="table table-modern align-middle" id="voucherTableMain">
                            <thead>
                                <tr>
                                    <th width="20%">Code (ID)</th>
                                    <th width="15%">Discount</th>
                                    <th width="15%">Max Amount</th> <%-- [MỚI] Cột Max Discount --%>
                                    <th width="15%">Start Date</th>
                                    <th width="15%">End Date</th>
                                    <th width="20%" class="text-center">Actions</th>
                                </tr>
                            </thead>
                            <tbody id="tableBody"></tbody>
                        </table>
                    </div>
                    <%-- Pagination Container --%>
                    <div class="pagination-wrapper px-4 pb-3" id="paginationContainer"></div>
                </div> 
            </div>
        </div>

        <%-- Modal Definitions (Add/Edit/Delete) --%>
        <div class="modal fade" id="addVoucherModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content modal-content-modern">
                    <div class="modal-header-modern bg-green d-flex justify-content-between">
                        <h5 class="text-success"><i class="bi bi-plus-circle-fill me-2"></i> Add New Voucher</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <form id="addVoucherForm">
                            <input type="hidden" name="action" value="add">

                            <div class="mb-3">
                                <div class="form-floating">
                                    <input type="text" name="id" id="addVoucherID" class="form-control" placeholder="Voucher Code" style="text-transform: uppercase;" required maxlength="50">
                                    <label for="addVoucherID">Voucher Code (ID)</label>
                                </div>
                            </div>

                            <div class="row g-3">
                                <div class="col-6">
                                    <div class="form-floating mb-3">
                                        <input type="number" name="percent" id="addPercent" class="form-control" placeholder="Percent" required>
                                        <label for="addPercent">Discount Percent (%)</label>
                                    </div>
                                </div>
                                <div class="col-6">
                                    <%-- [MỚI] Trường Max Discount Amount --%>
                                    <div class="form-floating mb-3">
                                        <input type="number" name="maxDiscount" id="addMaxDiscount" class="form-control" placeholder="Max Discount" required value="0">
                                        <label for="addMaxDiscount">Max Discount (VND)</label>
                                        <div class="form-text text-end small mt-0">0 = Unlimited</div>
                                    </div>
                                </div>
                            </div>

                            <div class="row g-3">
                                <div class="col-6">
                                    <div class="mb-3"> 
                                        <div class="form-floating">
                                            <input type="date" name="startDate" id="addStartDate" class="form-control" required>
                                            <label for="addStartDate">Start Date</label>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-6">
                                    <div class="mb-3"> 
                                        <div class="form-floating">
                                            <input type="date" name="endDate" id="addEndDate" class="form-control" required>
                                            <label for="addEndDate">End Date</label>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="mt-4 text-end">
                                <button type="button" class="btn btn-light me-2" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-success px-4 fw-bold">Create Voucher</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="editVoucherModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content modal-content-modern">
                    <div class="modal-header-modern bg-blue d-flex justify-content-between">
                        <h5 class="text-primary"><i class="bi bi-pencil-square me-2"></i> Edit Voucher</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <form id="editVoucherForm">
                            <input type="hidden" name="action" value="edit">
                            <div class="form-floating mb-3">
                                <input type="text" name="id" id="editVoucherID" class="form-control bg-light" readonly>
                                <label for="editVoucherID">Voucher Code (ID)</label>
                            </div>

                            <div class="row g-3">
                                <div class="col-6">
                                    <div class="form-floating mb-3">
                                        <input type="number" name="percent" id="editPercent" class="form-control" required>
                                        <label for="editPercent">Discount Percent (%)</label>
                                    </div>
                                </div>
                                <div class="col-6">
                                    <%-- [MỚI] Trường Max Discount Amount cho Edit --%>
                                    <div class="form-floating mb-3">
                                        <input type="number" name="maxDiscount" id="editMaxDiscount" class="form-control" placeholder="Max Discount" required>
                                        <label for="editMaxDiscount">Max Discount (VND)</label>
                                        <div class="form-text text-end small mt-0">0 = Unlimited</div>
                                    </div>
                                </div>
                            </div>

                            <div class="row g-3">
                                <div class="col-6">
                                    <div class="form-floating">
                                        <input type="date" name="startDate" id="editStartDate" class="form-control" required>
                                        <label for="editStartDate">Start Date</label>
                                    </div>
                                </div>
                                <div class="col-6">
                                    <div class="form-floating">
                                        <input type="date" name="endDate" id="editEndDate" class="form-control" required>
                                        <label for="editEndDate">End Date</label>
                                    </div>
                                </div>
                            </div>
                            <div class="mt-4 text-end">
                                <button type="button" class="btn btn-light me-2" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-primary px-4 fw-bold">Save Changes</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="deleteVoucherModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content modal-content-modern border-danger border-top border-5">
                    <div class="modal-header border-0">
                        <h5 class="modal-title text-danger fw-bold"><i class="bi bi-trash-fill me-2"></i> Delete Voucher</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4 text-center">
                        <h5 class="mb-3" id="deleteVoucherModalLabel">Delete Voucher: <span></span>?</h5>
                        <div id="voucherDataLoading" class="py-3">
                            <div class="spinner-border text-danger"></div>
                            <div class="small mt-2 text-muted">Checking usage...</div>
                        </div>
                        <div id="deleteVoucherWarning" class="alert alert-danger text-start small" style="display: none;">
                            <i class="bi bi-exclamation-triangle-fill me-1"></i> <strong>Cannot Delete:</strong> Used by active products.
                        </div>
                        <div id="deleteVoucherSuccess" class="alert alert-success text-start small" style="display: none;">
                            <i class="bi bi-check-circle-fill me-1"></i> <strong>Safe to Delete:</strong> No products linked.
                        </div>
                        <div id="voucherDataContent" style="display: none; max-height: 150px; overflow-y: auto;" class="border rounded mt-2 text-start p-2 bg-light small">
                            <table class="table table-sm table-borderless mb-0">
                                <tbody id="voucher-products-table-body"></tbody>
                            </table>
                        </div>
                    </div>
                    <div class="modal-footer border-0 justify-content-center">
                        <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">Close</button>
                        <form id="confirmDeleteVoucherForm" style="display: none;">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id" id="confirmDeleteVoucherId">
                            <button type="submit" class="btn btn-danger px-4 fw-bold">Confirm Delete</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/jquery-validation@1.19.5/dist/jquery.validate.min.js"></script>

        <script>
                                // --- GLOBAL VARIABLES ---
                                const BASE_URL = '${BASE_URL}';
                                let currentPage = 1;
                                let currentSearch = "";
                                let currentStart = "";
                                let currentEnd = "";

                                // --- UTILS ---
                                function toggleTableBlur(active) {
                                    if (active)
                                        $('#voucherTableMain tbody').addClass('table-blur');
                                    else
                                        $('#voucherTableMain tbody').removeClass('table-blur');
                                }

                                function showToast(type, message) {
                                    const toast = $('#toast-message');
                                    const icon = toast.find('i');
                                    const text = $('#toast-text');
                                    toast.removeClass('toast-success toast-danger').addClass(type === 'success' ? 'toast-success' : 'toast-danger');
                                    icon.removeClass().addClass(type === 'success' ? 'fas fa-check-circle' : 'fas fa-exclamation-circle');
                                    text.text(message);
                                    toast.addClass('active');
                                    setTimeout(() => {
                                        toast.removeClass('active');
                                    }, 3000);
                                }

                                function formatDateForInput(dateString) {
                                    if (!dateString)
                                        return "";
                                    const d = new Date(dateString);
                                    if (isNaN(d.getTime()))
                                        return "";
                                    const year = d.getFullYear();
                                    const month = String(d.getMonth() + 1).padStart(2, '0');
                                    const day = String(d.getDate()).padStart(2, '0');
                                    return `\${year}-\${month}-\${day}`;
                                }

                                function formatDateForDisplay(dateString) {
                                    if (!dateString)
                                        return "";
                                    const d = new Date(dateString);
                                    if (isNaN(d.getTime()))
                                        return "";
                                    return d.toLocaleDateString('en-GB');
                                }

                                // Format currency VND
                                function formatCurrency(amount) {
                                    if (!amount)
                                        return "0";
                                    return new Intl.NumberFormat('vi-VN').format(amount);
                                }

                                // --- CORE: FETCH DATA ---
                                function fetchVouchers(page = 1) {
                                    currentPage = page;
                                    toggleTableBlur(true);

                                    $.ajax({
                                        url: BASE_URL + '/admin',
                                        type: 'GET',
                                        data: {
                                            action: 'voucher_data',
                                            page: page,
                                            search: currentSearch,
                                            startDate: currentStart,
                                            endDate: currentEnd
                                        },
                                        dataType: 'json',
                                        success: function (response) {
                                            renderTable(response.list);
                                            renderPagination(response.totalPages, response.currentPage);
                                            $('#totalVouchersBadge').text(response.totalItems + " Vouchers");
                                            setTimeout(() => {
                                                toggleTableBlur(false);
                                            }, 150);
                                        },
                                        error: function () {
                                            showToast('error', 'Failed to load data');
                                            toggleTableBlur(false);
                                        }
                                    });
                                }

                                function renderTable(list) {
                                    const tbody = $('#tableBody');
                                    tbody.empty();
                                    if (!list || list.length === 0) {
                                        tbody.append('<tr><td colspan="6" class="text-center py-4 text-muted">No vouchers found.</td></tr>');
                                        return;
                                    }

                                    list.forEach(p => {
                                        const displayStart = formatDateForDisplay(p.startDate);
                                        const displayEnd = formatDateForDisplay(p.endDate);
                                        const inputStart = formatDateForInput(p.startDate);
                                        const inputEnd = formatDateForInput(p.endDate);

                                        // [MỚI] Xử lý hiển thị Max Discount
                                        const maxDiscountVal = p.maxDiscountAmount || 0; // Backup nếu null
                                        const displayMax = maxDiscountVal > 0 ? formatCurrency(maxDiscountVal) + ' VND' : '<span class="text-success small">Unlimited</span>';

                                        const row = `
                        <tr>
                            <td class="fw-bold text-primary">\${p.voucherID}</td>
                            <td><span class="voucher-badge">\${p.voucherPercent}% OFF</span></td>
                            <td>\${displayMax}</td> <td><i class="bi bi-calendar-event me-2 text-muted"></i>\${displayStart}</td>
                            <td><i class="bi bi-calendar-check me-2 text-muted"></i>\${displayEnd}</td>
                            <td class="text-center">
                                <button type="button" class="btn-soft btn-soft-primary" 
                                        data-bs-toggle="modal" data-bs-target="#editVoucherModal"
                                        data-id="\${p.voucherID}" 
                                        data-percent="\${p.voucherPercent}"
                                        data-max-discount="\${maxDiscountVal}"  
                                        data-start="\${inputStart}" 
                                        data-end="\${inputEnd}" 
                                        title="Edit">
                                    <i class="bi bi-pencil-fill"></i>
                                </button>
                                <button type="button" class="btn-soft btn-soft-danger" 
                                        data-bs-toggle="modal" data-bs-target="#deleteVoucherModal"
                                        data-voucher-id="\${p.voucherID}" 
                                        data-voucher-percent="\${p.voucherPercent}" 
                                        title="Delete">
                                    <i class="bi bi-trash-fill"></i>
                                </button>
                            </td>
                        </tr>
                    `;
                                        tbody.append(row);
                                    });
                                }

                                function renderPagination(totalPages, current) {
                                    const container = $('#paginationContainer');
                                    container.empty();
                                    if (totalPages <= 1)
                                        return;

                                    let html = '<ul class="custom-pagination">';

                                    // Prev
                                    html += `<li class="custom-page-item \${current == 1 ? 'disabled' : ''}">
                            <a class="custom-page-link" onclick="fetchVouchers(\${current - 1})"><i class="bi bi-chevron-left"></i></a>
                         </li>`;

                                    // Numbers
                                    for (let i = 1; i <= totalPages; i++) {
                                        html += `<li class="custom-page-item \${i == current ? 'active' : ''}">
                                <a class="custom-page-link" onclick="fetchVouchers(\${i})">\${i}</a>
                             </li>`;
                                    }

                                    // Next
                                    html += `<li class="custom-page-item \${current == totalPages ? 'disabled' : ''}">
                            <a class="custom-page-link" onclick="fetchVouchers(\${current + 1})"><i class="bi bi-chevron-right"></i></a>
                         </li>`;

                                    html += '</ul>';
                                    container.html(html);
                                }

                                function resetFilters() {
                                    $('#liveSearchInput').val('');
                                    $('#startDateFilter').val('');
                                    $('#endDateFilter').val('');
                                    currentSearch = "";
                                    currentStart = "";
                                    currentEnd = "";
                                    toggleTableBlur(true);
                                    fetchVouchers(1);
                                }

                                function handleFormSubmit(formId, modalId) {
                                    const form = $(formId);
                                    if (!form.valid())
                                        return;

                                    toggleTableBlur(true);

                                    $.ajax({
                                        url: BASE_URL + '/admin',
                                        type: 'POST',
                                        data: form.serialize(),
                                        dataType: 'json',
                                        success: function (resp) {
                                            if (resp.isSuccess) {
                                                showToast('success', resp.description);
                                                $(modalId).modal('hide');
                                                fetchVouchers(currentPage);
                                                form[0].reset();
                                            } else {
                                                showToast('error', resp.description);
                                                toggleTableBlur(false);
                                            }
                                        },
                                        error: function () {
                                            showToast('error', 'Server connection failed.');
                                            toggleTableBlur(false);
                                        }
                                    });
                                }

                                document.addEventListener("DOMContentLoaded", function () {
                                    // Initial Load
                                    setTimeout(function () {
                                        $('#table-loader').fadeOut(200, function () {
                                            $('#voucher-content-container').fadeIn(200);
                                            fetchVouchers(1);
                                        });
                                    }, 400);

                                    // LIVE SEARCH
                                    let searchTimeout;
                                    $('#liveSearchInput').on('input', function () {
                                        currentSearch = $(this).val();
                                        toggleTableBlur(true);
                                        clearTimeout(searchTimeout);
                                        searchTimeout = setTimeout(() => {
                                            fetchVouchers(1);
                                        }, 300);
                                    });

                                    // DATE FILTERS
                                    $('#startDateFilter, #endDateFilter').on('change', function () {
                                        currentStart = $('#startDateFilter').val();
                                        currentEnd = $('#endDateFilter').val();
                                        toggleTableBlur(true);
                                        fetchVouchers(1);
                                    });

                                    // VALIDATION RULES
                                    $.validator.addMethod("greaterThanEqual", function (value, element, param) {
                                        var startDate = $(param).val();
                                        if (!startDate || !value)
                                            return true;
                                        return new Date(value) >= new Date(startDate);
                                    }, "End date must be >= start date.");

                                    $.validator.addMethod("regexCode", function (value, element) {
                                        return this.optional(element) || /^[A-Z0-9]+$/.test(value);
                                    }, "Only uppercase letters (A-Z) and numbers (0-9) allowed.");

                                    const validationConfig = {
                                        errorElement: "label", errorClass: "error",
                                        errorPlacement: function (error, element) {
                                            if (element.closest('.form-floating').length)
                                                error.insertAfter(element.closest('.form-floating'));
                                            else
                                                error.insertAfter(element);
                                        }
                                    };

                                    $("#addVoucherForm").validate({
                                        ...validationConfig,
                                        rules: {
                                            id: {required: true, regexCode: true},
                                            percent: {required: true, digits: true, min: 1, max: 100},
                                            maxDiscount: {required: true, digits: true, min: 0}, // [MỚI] Validate Max Discount
                                            startDate: {required: true, date: true},
                                            endDate: {required: true, date: true, greaterThanEqual: "#addStartDate"}
                                        },
                                        submitHandler: function () {
                                            handleFormSubmit('#addVoucherForm', '#addVoucherModal');
                                        }
                                    });

                                    $("#editVoucherForm").validate({
                                        ...validationConfig,
                                        rules: {
                                            percent: {required: true, digits: true, min: 1, max: 100},
                                            maxDiscount: {required: true, digits: true, min: 0}, // [MỚI] Validate Max Discount
                                            startDate: {required: true, date: true},
                                            endDate: {required: true, date: true, greaterThanEqual: "#editStartDate"}
                                        },
                                        submitHandler: function () {
                                            handleFormSubmit('#editVoucherForm', '#editVoucherModal');
                                        }
                                    });

                                    $('#confirmDeleteVoucherForm').on('submit', function (e) {
                                        e.preventDefault();
                                        handleFormSubmit('#confirmDeleteVoucherForm', '#deleteVoucherModal');
                                    });

                                    // EDIT MODAL POPULATE
                                    const editVoucherModal = document.getElementById('editVoucherModal');
                                    if (editVoucherModal) {
                                        editVoucherModal.addEventListener('show.bs.modal', function (event) {
                                            $("#editVoucherForm").validate().resetForm();
                                            const btn = event.relatedTarget;
                                            $('#editVoucherID').val(btn.getAttribute('data-id'));
                                            $('#editPercent').val(btn.getAttribute('data-percent'));
                                            $('#editStartDate').val(btn.getAttribute('data-start'));
                                            $('#editEndDate').val(btn.getAttribute('data-end'));
                                            // [MỚI] Đổ dữ liệu Max Discount vào form edit
                                            $('#editMaxDiscount').val(btn.getAttribute('data-max-discount'));
                                        });
                                    }


                                    // ... Code phía trên giữ nguyên

// Delete Modal Logic
                                    const deleteVoucherModal = document.getElementById('deleteVoucherModal');
                                    if (deleteVoucherModal) {
                                        deleteVoucherModal.addEventListener('show.bs.modal', function (event) {
                                            const btn = event.relatedTarget;
                                            const voucherId = btn.getAttribute('data-voucher-id');
                                            const percent = btn.getAttribute('data-voucher-percent');

                                            $('#deleteVoucherModalLabel span').text(percent + "% (Code: " + voucherId + ")");
                                            $('#confirmDeleteVoucherId').val(voucherId);

                                            $('#voucherDataLoading').show();
                                            $('#deleteVoucherWarning, #deleteVoucherSuccess, #confirmDeleteVoucherForm, #voucherDataContent').hide();
                                            $('#voucher-products-table-body').empty();

                                            // [SỬA LẠI ĐOẠN AJAX NÀY]
                                            $.ajax({
                                                url: BASE_URL + '/admin', // URL chung của admin controller
                                                type: 'GET',
                                                data: {
                                                    action: 'get_voucher_related_data', // Action khớp với Controller
                                                    voucherId: voucherId
                                                },
                                                dataType: 'json',
                                                success: function (products) {
                                                    $('#voucherDataLoading').hide();
                                                    // Kiểm tra dữ liệu trả về
                                                    if (products && products.length > 0) {
                                                        // Trường hợp có sản phẩm đang dùng voucher -> Không cho xóa
                                                        $('#deleteVoucherWarning').show();
                                                        $('#voucherDataContent').show();
                                                        products.forEach(p => {
                                                            $('#voucher-products-table-body').append(`<tr><td><strong>\${p.name}</strong></td><td class="text-end text-muted small">ID: \${p.id}</td></tr>`);
                                                        });
                                                    } else {
                                                        // Trường hợp an toàn -> Cho phép xóa
                                                        $('#deleteVoucherSuccess').show();
                                                        $('#confirmDeleteVoucherForm').show();
                                                    }
                                                },
                                                error: function (xhr, status, error) {
                                                    // Xử lý lỗi nếu gọi API thất bại
                                                    $('#voucherDataLoading').hide();
                                                    console.error("Error checking voucher data:", error);
                                                    showToast('error', 'Cannot check voucher usage status.');
                                                }
                                            });
                                        });
                                    }

                                    $('#addVoucherID').on('input', function () {
                                        $(this).val($(this).val().toUpperCase());
                                    });
                                });
        </script>
    </body>
</html>