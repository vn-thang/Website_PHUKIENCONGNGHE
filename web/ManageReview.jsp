<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <title>Quản Lý Đánh Giá</title>
    
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <style>
        body {
            background-color: #ffffff !important;
            font-family: "Segoe UI", sans-serif !important;
            color: #333 !important;
        }

        h2 {
            color: #ff7e27 !important;
            font-weight: 700 !important;
            letter-spacing: 0.5px !important;
        }

        /* BUTTON STYLE */
        .btn-primary {
            background-color: #ff7e27 !important;
            border: none !important;
            color: #fff !important;
            transition: all 0.3s;
        }
        .btn-primary:hover {
            background-color: #e25500 !important;
            transform: translateY(-1px);
        }

        .btn-danger {
            background-color: #ff4d4f !important;
            border: none !important;
            transition: all 0.3s;
        }
        .btn-danger:hover {
            background-color: #d9363e !important;
            transform: translateY(-1px);
        }
        
        /* TABLE STYLE */
        table {
            border-radius: 14px !important;
            overflow: hidden !important;
            background: #ffffff !important;
            border: 1px solid #f3f3f3 !important;
            box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        }

        thead.table-dark {
            background-color: #ff7e27 !important;
            border-bottom: none;
        }

        thead.table-dark th {
            color: #fff !important;
            text-align: center !important;
            font-weight: 600 !important;
            padding: 14px !important;
            background-color: #ff7e27 !important;
            border: none;
        }

        tbody tr:hover {
            background-color: #fff3e8 !important;
        }

        .table td, .table th {
            vertical-align: middle !important;
            padding: 12px 10px !important;
            border-color: #f5f5f5 !important;
        }

        /* REVIEW SPECIFIC */
        .star-gold { color: #ffc107; }
        .star-gray { color: #e4e5e9; }
        
        .review-text-short {
            max-width: 250px;
            white-space: nowrap; 
            overflow: hidden; 
            text-overflow: ellipsis;
            color: #555;
        }

        .product-link { color: #333; text-decoration: none; font-weight: 500; }
        .product-link:hover { color: #ff7e27; }

        /* Badge Custom */
        .badge-success { background-color: #ff7e27 !important; color: #fff; } 
        .badge-secondary { background-color: #999 !important; color: #fff; }
    </style>
</head>

<body>

    <jsp:include page="header.jsp" />

    <div class="container mt-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Quản Lý Đánh Giá</h2>
        </div>

        <c:if test="${not empty sessionScope.msg}">
            <div class="alert alert-success alert-dismissible fade show" role="alert" style="border-left: 5px solid #ff7e27;">
                ${sessionScope.msg}
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <% session.removeAttribute("msg"); %>
        </c:if>

        <div class="card mb-4 border-0 shadow-sm bg-light">
            <div class="card-body py-3">
                <div class="row align-items-center">
                    <div class="col-md-5">
                        <div class="input-group">
                            <div class="input-group-prepend">
                                <span class="input-group-text bg-white border-right-0"><i class="fas fa-search text-muted"></i></span>
                            </div>
                            <input type="text" id="searchInput" onkeyup="searchTable()" class="form-control border-left-0" placeholder="Tìm tên khách, sản phẩm...">
                        </div>
                    </div>
                    <div class="col-md-4 ml-auto d-flex align-items-center justify-content-end">
                        <label class="font-weight-bold mr-2 text-muted">Lọc:</label>
                        <select class="form-control w-auto" id="statusFilter" onchange="filterTable()">
                            <option value="all">Tất cả trạng thái</option>
                            <option value="visible">✅ Đang hiển thị</option>
                            <option value="hidden">⛔ Đã ẩn</option>
                            <option value="no-reply">💬 Chưa trả lời</option>
                            <option value="replied">👌 Đã trả lời</option>
                        </select>
                    </div>
                </div>
            </div>
        </div>

        <table class="table table-bordered table-hover" id="reviewTable">
            <thead class="table-dark">
                <tr>
                    <th scope="col">ID</th>
                    <th scope="col" style="text-align: left; padding-left: 20px;">Sản Phẩm</th>
                    <th scope="col">Khách Hàng</th>
                    <th scope="col" style="min-width: 100px;">Đánh Giá</th>
                    <th scope="col" style="text-align: left;">Nội Dung</th>
                    <th scope="col">Trạng Thái</th>
                    <th scope="col">Phản Hồi</th>
                    <th scope="col" style="width: 180px;">Hành Động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${listR}" var="r">
                    <tr class="review-row" 
                        data-status="${r.trangThai}" 
                        data-reply="${not empty r.phanHoi ? 'yes' : 'no'}">
                        
                        <td class="text-center font-weight-bold text-secondary">#${r.maDanhGia}</td>
                        
                        <td style="padding-left: 20px;">
                            <div class="d-flex align-items-center">
                                <c:if test="${not empty r.product.hinhAnh}">
                                    <img src="${r.product.hinhAnh}" width="40" height="40" class="rounded border mr-2" style="object-fit: cover;">
                                </c:if>
                                <c:if test="${empty r.product.hinhAnh}">
                                    <div class="bg-light rounded d-flex align-items-center justify-content-center mr-2 border" style="width: 40px; height: 40px;">
                                        <i class="fas fa-box text-secondary"></i>
                                    </div>
                                </c:if>
                                <a href="detail?pid=${r.maSanPham}" target="_blank" class="product-link">
                                    ${r.product.tenSanPham} 
                                </a>
                            </div>
                        </td>

                        <td class="text-center">
                            <div class="d-flex flex-column align-items-center">
                                <span class="font-weight-bold">${r.tenUser}</span>
                                <small class="text-muted" style="font-size: 11px;">${r.ngayDanhGia}</small>
                            </div>
                        </td>

                        <td class="text-center">
                            <div class="text-nowrap">
                                <c:forEach begin="1" end="5" var="i">
                                    <c:choose>
                                        <c:when test="${i <= r.soSao}"><i class="fas fa-star star-gold small"></i></c:when>
                                        <c:otherwise><i class="fas fa-star star-gray small"></i></c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </div>
                        </td>

                        <td>
                            <div class="review-text-short" title="${r.noiDung}">
                                ${r.noiDung}
                            </div>
                        </td>

                        <td class="text-center">
                            <c:if test="${r.trangThai == 1}"><span class="badge badge-success">Hiển thị</span></c:if>
                            <c:if test="${r.trangThai == 0}"><span class="badge badge-secondary">Đã ẩn</span></c:if>
                        </td>

                        <td class="text-center">
                            <c:if test="${not empty r.phanHoi}">
                                <i class="fas fa-check-circle text-success" style="font-size: 1.2rem;" title="Đã trả lời"></i>
                            </c:if>
                            <c:if test="${empty r.phanHoi}">
                                <i class="fas fa-comment-dots text-secondary" style="font-size: 1.2rem;" title="Chưa trả lời"></i>
                            </c:if>
                        </td>

                        <td class="text-center">
                            <div class="d-flex justify-content-center">
                                <button class="btn btn-primary btn-sm mr-2" 
                                        onclick="openReplyModal('${r.maDanhGia}', '${r.phanHoi}', ${r.trangThai})" 
                                        title="Trả lời / Sửa">
                                    <i class="fas fa-edit"></i> Sửa
                                </button>
                                
                                <a href="admin-reviews?action=delete&id=${r.maDanhGia}" 
                                   class="btn btn-danger btn-sm"
                                   onclick="return confirm('CẢNH BÁO: Bạn có chắc chắn muốn xóa vĩnh viễn?')" 
                                   title="Xóa vĩnh viễn">
                                    <i class="fas fa-trash"></i> Xóa
                                </a>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        
        <div id="noDataAlert" class="alert alert-warning text-center mt-3" style="display: none;">
            Không tìm thấy đánh giá nào phù hợp.
        </div>
    </div>

    <jsp:include page="footer.jsp" />

    <div class="modal fade" id="replyModal" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <form action="admin-reviews" method="post">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="id" id="modal_id">
                    
                    <div class="modal-header text-white" style="background-color: #ff7e27;">
                        <h5 class="modal-title font-weight-bold">Xử lý Đánh giá</h5>
                        <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    
                    <div class="modal-body">
                        <div class="mb-3 p-3 bg-light rounded border">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="modal_status" name="status" value="1" style="cursor: pointer;">
                                <label class="form-check-label font-weight-bold" for="modal_status" style="cursor: pointer;">
                                    Cho phép hiển thị đánh giá này
                                </label>
                            </div>
                            <small class="text-muted">Tắt đi nếu đây là spam hoặc nội dung không phù hợp.</small>
                        </div>
                        
                        <div class="mb-3">
                            <label class="font-weight-bold" style="color: #ff7e27;">Phản hồi của Shop:</label>
                            <textarea class="form-control" name="reply" id="modal_reply" rows="5" 
                                      placeholder="Nhập câu trả lời... (Ví dụ: Cảm ơn bạn đã ủng hộ shop!)"></textarea>
                        </div>
                    </div>
                    
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary">Lưu Thay Đổi</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script>
        // 1. Hàm mở Modal (Dùng jQuery chuẩn BS4)
        function openReplyModal(id, currentReply, status) {
            document.getElementById('modal_id').value = id;
            var replyText = currentReply ? currentReply : "";
            replyText = replyText.replace(/\\n/g, "\n").replace(/\\'/g, "'").replace(/\\"/g, '"');
            document.getElementById('modal_reply').value = replyText;
            document.getElementById('modal_status').checked = (status == 1);
            
            // Dùng jQuery để mở Modal (BS4)
            $('#replyModal').modal('show');
        }

        // 2. Hàm Lọc Trạng Thái
        function filterTable() {
            var filterValue = document.getElementById("statusFilter").value;
            var rows = document.querySelectorAll(".review-row");
            var hasVisibleRow = false;

            rows.forEach(function(row) {
                var status = row.getAttribute("data-status");
                var reply = row.getAttribute("data-reply");
                var show = false;

                if (filterValue === "all") show = true;
                else if (filterValue === "visible" && status === "1") show = true;
                else if (filterValue === "hidden" && status === "0") show = true;
                else if (filterValue === "no-reply" && reply === "no") show = true;
                else if (filterValue === "replied" && reply === "yes") show = true;

                row.style.display = show ? "" : "none";
                if(show) hasVisibleRow = true;
            });
            
            document.getElementById("noDataAlert").style.display = hasVisibleRow ? "none" : "block";
        }

        // 3. Hàm Tìm Kiếm
        function searchTable() {
            var input = document.getElementById("searchInput");
            var filter = input.value.toUpperCase();
            var rows = document.querySelectorAll(".review-row");
            var hasVisibleRow = false;

            rows.forEach(function(row) {
                // Chỉ tìm trong những dòng đang hiển thị
                if (row.style.display !== "none" || input.value === "") {
                    var text = row.innerText || row.textContent;
                    if (text.toUpperCase().indexOf(filter) > -1) {
                        row.style.display = "";
                        hasVisibleRow = true;
                    } else {
                        row.style.display = "none";
                    }
                }
            });
            
            if(input.value === "") {
                filterTable(); // Reset lại nếu xóa hết ô tìm kiếm
            } else {
                document.getElementById("noDataAlert").style.display = hasVisibleRow ? "none" : "block";
            }
        }
    </script>
</body>
</html>