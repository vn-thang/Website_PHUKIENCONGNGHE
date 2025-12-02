<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Chatbot</title>
    
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <style>
        body {
            background-color: #ffffff !important;
            font-family: "Segoe UI", sans-serif !important;
            color: #333 !important;
        }

        h2, h5, h6 {
            color: #ff7e27 !important;
            font-weight: 700 !important;
        }

        /* BUTTON STYLE */
        .btn-primary {
            background-color: #ff7e27 !important;
            border: none !important;
            color: #fff !important;
            font-weight: 600;
        }
        .btn-primary:hover {
            background-color: #e25500 !important;
        }

        .btn-outline-primary {
            color: #ff7e27;
            border-color: #ff7e27;
        }
        .btn-outline-primary:hover {
            background-color: #ff7e27;
            color: #fff;
        }

        .btn-danger {
            background-color: #ff4d4f !important;
            border: none !important;
        }
        
        /* CARD STYLE */
        .card {
            border: 1px solid #f0f0f0;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.03);
            transition: all 0.3s;
        }
        .card:hover {
            box-shadow: 0 8px 20px rgba(0,0,0,0.06);
        }

        /* KEYWORD BADGE */
        .keyword-badge {
            background: #fff3e8; 
            color: #ff7e27;
            padding: 5px 10px; 
            border-radius: 20px; 
            font-size: 13px; 
            margin-right: 5px; 
            display: inline-block; 
            margin-bottom: 5px;
            border: 1px solid #ffcca3;
            font-weight: 500;
        }
        .keyword-badge a { 
            text-decoration: none; 
            color: #ff4d4f; 
            margin-left: 5px; 
            font-weight: bold; 
            cursor: pointer;
        }
        .keyword-badge a:hover { color: #d9363e; }

        /* LOG CONTAINER */
        .log-container {
            max-height: 80vh;
            overflow-y: auto;
            background-color: #fcfcfc;
            border: 1px solid #eee;
            border-radius: 8px;
        }
        .log-item {
            background: #fff;
            border-left: 4px solid #ffc107;
            margin-bottom: 10px;
            padding: 10px;
            border-radius: 4px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.02);
            transition: 0.3s;
        }
        .log-item:hover { background-color: #fffdf5; }
        
        /* SCROLLBAR */
        ::-webkit-scrollbar { width: 6px; }
        ::-webkit-scrollbar-track { background: #f1f1f1; }
        ::-webkit-scrollbar-thumb { background: #ccc; border-radius: 10px; }
        ::-webkit-scrollbar-thumb:hover { background: #ff7e27; }
    </style>
</head>
<body>

    <jsp:include page="header.jsp" />

    <div class="container-fluid mt-4 px-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="fas fa-robot mr-2"></i>Quản Lý Chatbot</h2>
        </div>

        <div class="row">
            
            <div class="col-md-8">
                
                <div class="card p-4 mb-4 border-0 bg-white" id="addTopicCard">
                    <h5 class="mb-3 text-primary"><i class="fas fa-plus-circle mr-2"></i>Dạy Bot Kịch Bản Mới</h5>
                    
                    <form action="managerBot" method="post" id="addTopicForm">
                        <input type="hidden" name="action" value="add_topic">
                        <input type="hidden" name="logIdToDelete" id="logIdToDelete" value="">
                        <input type="hidden" name="autoKeyword" id="autoKeyword" value="">

                        <div class="row">
                            <div class="col-md-4 form-group">
                                <label class="small text-muted">Tên chủ đề (Gợi nhớ)</label>
                                <input type="text" name="ten" id="add_ten" class="form-control" placeholder="VD: Hỏi giờ mở cửa" required>
                            </div>
                            <div class="col-md-3 form-group">
                                <label class="small text-muted">Loại hành động</label>
                                <select name="loai" class="form-control">
                                    <option value="CHAT">💬 Chat Text</option>
                                    <option value="MENU">📋 Menu Chọn</option>
                                    <option value="TIM_KIEM">🔍 Tìm Kiếm</option>
                                </select>
                            </div>
                            <div class="col-md-5 form-group">
                                <label class="small text-muted">Câu trả lời của Bot</label>
                                <div class="input-group">
                                    <input type="text" name="phanhoi" id="add_phanhoi" class="form-control" placeholder="Nội dung phản hồi..." required>
                                    <div class="input-group-append">
                                        <button type="submit" class="btn btn-primary fw-bold px-3">Lưu</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>

                <h5 class="mb-3 text-secondary border-bottom pb-2">Danh sách kịch bản hiện có</h5>
                
                <div style="max-height: 70vh; overflow-y: auto; padding-right: 5px;">
                    <c:forEach items="${listBot}" var="bot">
                        <div class="card mb-3">
                            <div class="card-header bg-white d-flex justify-content-between align-items-center py-3 border-bottom-0">
                                <div>
                                    <h6 class="mb-0 d-inline-block text-dark" style="font-size: 1.1rem;">
                                        ${bot.tenChuDe}
                                    </h6>
                                    <span class="badge badge-secondary ml-2">${bot.loaiHanhDong}</span>
                                </div>

                                <div>
                                    <button type="button" class="btn btn-outline-primary btn-sm mr-2" 
                                            data-toggle="modal" data-target="#editModal"
                                            data-id="${bot.maChuDe}"
                                            data-ten="${bot.tenChuDe}"
                                            data-loai="${bot.loaiHanhDong}"
                                            data-phanhoi="${bot.giaTriPhanHoi}"
                                            onclick="loadEditData(this)">
                                        <i class="fas fa-edit"></i> Sửa
                                    </button>

                                    <a href="managerBot?action=delete_topic&id=${bot.maChuDe}" 
                                       class="btn btn-outline-danger btn-sm" 
                                       onclick="return confirm('Xóa chủ đề này sẽ xóa hết từ khóa con. Bạn chắc chứ?')">
                                        <i class="fas fa-trash-alt"></i> Xóa
                                    </a>
                                </div>
                            </div>
                            
                            <div class="card-body pt-0">
                                <div class="p-2 rounded bg-light mb-3 border">
                                    <small class="text-muted font-weight-bold">Bot trả lời:</small><br>
                                    <span style="color: #555;">${bot.giaTriPhanHoi}</span>
                                </div>
                                
                                <div class="mb-3">
                                    <c:forEach items="${bot.listTuKhoa}" var="kw">
                                        <span class="keyword-badge">
                                            ${kw} 
                                            <a href="managerBot?action=delete_keyword&id=${bot.maChuDe}&key=${kw}" title="Xóa từ khóa">×</a>
                                        </span>
                                    </c:forEach>
                                    <c:if test="${empty bot.listTuKhoa}">
                                        <span class="text-muted small font-italic"><i class="fas fa-exclamation-circle"></i> Chưa có từ khóa kích hoạt</span>
                                    </c:if>
                                </div>

                                <form action="managerBot" method="post" class="d-flex" style="max-width: 400px;">
                                    <input type="hidden" name="action" value="add_keyword">
                                    <input type="hidden" name="id" value="${bot.maChuDe}">
                                    <div class="input-group input-group-sm">
                                        <input type="text" name="tukhoa" class="form-control" placeholder="Thêm từ khóa kích hoạt..." required>
                                        <div class="input-group-append">
                                            <button type="submit" class="btn btn-secondary"><i class="fas fa-plus"></i> Thêm</button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <div class="col-md-4">
                <div class="sticky-top" style="top: 20px;">
                    <h5 class="text-warning mb-3"><i class="fas fa-bug mr-2"></i>Câu hỏi Bot chưa hiểu</h5>
                    
                    <div class="card border-0 shadow-sm">
                        <div class="card-header bg-warning text-dark font-weight-bold">
                            <i class="fas fa-info-circle mr-1"></i> Cần dạy Bot ngay
                        </div>
                        <div class="card-body p-3 log-container">
                            <small class="text-muted d-block mb-3">
                                <b>Mẹo:</b> Ấn nút "Trả lời" để tạo nhanh kịch bản và xóa lỗi tự động.
                            </small>

                            <c:forEach items="${listLoi}" var="log">
                                <c:set var="parts" value="${log.split('###')}" />
                                
                                <div class="log-item">
                                    <div style="flex: 1; margin-right: 10px;">
                                        <i class="fas fa-question-circle text-warning mr-1"></i>
                                        <strong style="font-size: 14px; color: #333;">"${parts[1]}"</strong>
                                        <div style="font-size: 11px; color: #888;">ID: #${parts[0]}</div>
                                    </div>
                                    
                                    <div style="display: flex;">
                                        <button type="button" class="btn btn-sm btn-primary mr-1" 
                                                onclick="replyToLog('${parts[0]}', '${parts[1]}')"
                                                title="Trả lời và tạo chủ đề">
                                            <i class="fas fa-reply"></i>
                                        </button>

                                        <a href="managerBot?action=delete_log&id=${parts[0]}" 
                                           class="btn btn-sm btn-light text-danger border" 
                                           onclick="return confirm('Xóa dòng này?')"
                                           title="Xóa bỏ">
                                            <i class="fas fa-times"></i>
                                        </a>
                                    </div>
                                </div>
                            </c:forEach>

                            <c:if test="${empty listLoi}">
                                <div class="text-center text-success py-4">
                                    <i class="fas fa-check-circle fa-3x mb-2"></i>
                                    <h5>Tuyệt vời!</h5>
                                    <p class="small text-muted">Không có câu hỏi lỗi nào.</p>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <div class="modal fade" id="editModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <form action="managerBot" method="post">
                    <div class="modal-header text-white" style="background-color: #ff7e27;">
                        <h5 class="modal-title font-weight-bold"><i class="fas fa-edit mr-2"></i>Cập nhật kịch bản</h5>
                        <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="action" value="update_topic">
                        <input type="hidden" name="id" id="edit_id">
                        
                        <div class="form-group">
                            <label class="font-weight-bold">Tên chủ đề</label>
                            <input type="text" name="ten" id="edit_ten" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label class="font-weight-bold">Loại hành động</label>
                            <select name="loai" id="edit_loai" class="form-control">
                                <option value="CHAT">💬 CHAT (Trả lời text)</option>
                                <option value="MENU">📋 MENU (Hiện danh sách nút)</option>
                                <option value="TIM_KIEM">🔍 TÌM KIẾM (Tra sản phẩm)</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="font-weight-bold">Nội dung Phản hồi / Từ khóa tìm kiếm</label>
                            <textarea name="phanhoi" id="edit_phanhoi" class="form-control" rows="4" required></textarea>
                            <small class="text-muted">Nếu là MENU thì nhập các mục cách nhau bằng dấu chấm phẩy (;)</small>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        // 1. Hàm load dữ liệu vào Modal Sửa
        function loadEditData(btn) {
            var id = btn.getAttribute("data-id");
            var ten = btn.getAttribute("data-ten");
            var loai = btn.getAttribute("data-loai");
            var phanhoi = btn.getAttribute("data-phanhoi");
            
            document.getElementById("edit_id").value = id;
            document.getElementById("edit_ten").value = ten;
            document.getElementById("edit_loai").value = loai;
            document.getElementById("edit_phanhoi").value = phanhoi;
        }

        // 2. Hàm Xử lý Trả Lời Nhanh
        function replyToLog(id, question) {
            document.getElementById('add_ten').value = question;
            document.getElementById('logIdToDelete').value = id;
            document.getElementById('autoKeyword').value = question;
            
            // Cuộn mượt
            document.getElementById('addTopicForm').scrollIntoView({behavior: "smooth", block: "center"});
            
            var inputReply = document.getElementById('add_phanhoi');
            inputReply.value = ""; 
            inputReply.focus();
            inputReply.placeholder = "Nhập câu trả lời cho: " + question;
            
            var card = document.getElementById('addTopicCard');
            card.style.transition = "0.3s";
            card.style.boxShadow = "0 0 15px rgba(255, 126, 39, 0.5)";
            setTimeout(() => { card.style.boxShadow = "none"; }, 1000);
        }
    </script>

</body>
</html>