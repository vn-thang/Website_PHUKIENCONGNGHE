<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý Chatbot</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body { background-color: #f0f2f5; font-family: Arial, sans-serif; }
        
        /* Badge từ khóa */
        .keyword-badge {
            background: #e3f2fd; 
            color: #007bff; 
            padding: 5px 10px; 
            border-radius: 20px; 
            font-size: 13px; 
            margin-right: 5px; 
            display: inline-block; 
            margin-bottom: 5px;
            border: 1px solid #b3d7ff;
        }
        .keyword-badge a { 
            text-decoration: none; 
            color: #dc3545; 
            margin-left: 8px; 
            font-weight: bold; 
            cursor: pointer;
        }
        
        /* Cột nhật ký lỗi bên phải */
        .log-container {
            max-height: 80vh;
            overflow-y: auto;
        }
        .log-item {
            background: #fff3cd;
            border-left: 4px solid #ffc107;
            margin-bottom: 8px;
            padding: 10px;
            border-radius: 4px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-dark bg-primary mb-4 shadow-sm">
    <span class="navbar-brand mb-0 h1">🤖 TStore Chatbot Manager</span>
    <a href="home" class="btn btn-light btn-sm">Về trang chủ</a>
</nav>

<div class="container-fluid px-4">
    <div class="row">
        
        <div class="col-md-8">
            <h5 class="text-primary mb-3">📚 Kiến thức của Bot</h5>

            <div class="card p-3 mb-4 shadow-sm border-0">
                <h6 class="text-success mb-3">+ Thêm kịch bản mới</h6>
                <form action="managerBot" method="post">
                    <input type="hidden" name="action" value="add_topic">
                    <div class="form-row">
                        <div class="col-md-3">
                            <input type="text" name="ten" class="form-control" placeholder="Tên chủ đề (VD: Hỏi Trả Góp)" required>
                        </div>
                        <div class="col-md-2">
                            <select name="loai" class="form-control">
                                <option value="CHAT">CHAT</option>
                                <option value="MENU">MENU</option>
                                <option value="TIM_KIEM">TÌM KIẾM</option>
                            </select>
                        </div>
                        <div class="col-md-5">
                            <input type="text" name="phanhoi" class="form-control" placeholder="Nội dung phản hồi / Từ khóa tìm kiếm" required>
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-success btn-block">Lưu</button>
                        </div>
                    </div>
                </form>
            </div>

            <c:forEach items="${listBot}" var="bot">
                <div class="card mb-3 shadow-sm border-0">
                    <div class="card-header bg-white d-flex justify-content-between align-items-center py-2">
                        <h6 class="mb-0 text-dark font-weight-bold">
                            ${bot.tenChuDe} 
                            <span class="badge badge-info ml-2">${bot.loaiHanhDong}</span>
                        </h6>

                        <div>
                            <button type="button" class="btn btn-outline-warning btn-sm mr-1" 
                                    data-toggle="modal" data-target="#editModal"
                                    data-id="${bot.maChuDe}"
                                    data-ten="${bot.tenChuDe}"
                                    data-loai="${bot.loaiHanhDong}"
                                    data-phanhoi="${bot.giaTriPhanHoi}"
                                    onclick="loadEditData(this)">
                                ✏️ Sửa
                            </button>

                            <a href="managerBot?action=delete_topic&id=${bot.maChuDe}" 
                               class="btn btn-outline-danger btn-sm" 
                               onclick="return confirm('Xóa chủ đề này sẽ xóa hết từ khóa con. Bạn chắc chứ?')">🗑️ Xóa</a>
                        </div>
                    </div>
                    
                    <div class="card-body py-2">
                        <p class="mb-2 text-muted" style="font-size: 14px;">
                            <strong>Bot trả lời:</strong> ${bot.giaTriPhanHoi}
                        </p>
                        <hr class="my-2">
                        
                        <div class="mb-2">
                            <c:forEach items="${bot.listTuKhoa}" var="kw">
                                <span class="keyword-badge">
                                    ${kw} 
                                    <a href="managerBot?action=delete_keyword&id=${bot.maChuDe}&key=${kw}" title="Xóa từ khóa">×</a>
                                </span>
                            </c:forEach>
                            <c:if test="${empty bot.listTuKhoa}">
                                <span class="text-muted small">⚠️ Chưa có từ khóa kích hoạt</span>
                            </c:if>
                        </div>

                        <form action="managerBot" method="post" class="form-inline">
                            <input type="hidden" name="action" value="add_keyword">
                            <input type="hidden" name="id" value="${bot.maChuDe}">
                            <input type="text" name="tukhoa" class="form-control form-control-sm mr-2" placeholder="Thêm từ khóa..." style="width: 300px;" required>
                            <button type="submit" class="btn btn-primary btn-sm">+</button>
                        </form>
                    </div>
                </div>
            </c:forEach>
        </div>

        <div class="col-md-4">
            <div class="sticky-top" style="top: 20px;">
                <h5 class="text-warning mb-3">⚠️ Câu hỏi Bot chưa hiểu</h5>
                <div class="card border-warning shadow-sm">
                    <div class="card-header bg-warning text-dark py-2">
                        <small><b>Quy trình:</b> Xem câu hỏi lạ ➔ Tạo chủ đề bên trái ➔ Xóa dòng lỗi này.</small>
                    </div>
                    <div class="card-body p-2 log-container">
                        
                        <c:forEach items="${listLoi}" var="log">
                            <c:set var="parts" value="${log.split('###')}" />
                            
                            <div class="log-item">
                                <div>
                                    <strong style="font-size: 14px;">"${parts[1]}"</strong>
                                </div>
                                <a href="managerBot?action=delete_log&id=${parts[0]}" class="btn btn-sm btn-danger ml-2" title="Xóa sau khi đã xử lý">✕</a>
                            </div>
                        </c:forEach>

                        <c:if test="${empty listLoi}">
                            <div class="text-center text-success mt-3 mb-3">
                                <h5>✨ Sạch sẽ!</h5>
                                <p class="small">Bot đang hiểu hết các câu hỏi.</p>
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
          <div class="modal-header">
            <h5 class="modal-title">✏️ Cập nhật kịch bản</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
              <input type="hidden" name="action" value="update_topic">
              <input type="hidden" name="id" id="edit_id"> <div class="form-group">
                  <label>Tên chủ đề</label>
                  <input type="text" name="ten" id="edit_ten" class="form-control" required>
              </div>
              <div class="form-group">
                  <label>Loại hành động</label>
                  <select name="loai" id="edit_loai" class="form-control">
                        <option value="CHAT">CHAT (Trả lời text)</option>
                        <option value="MENU">MENU (Hiện danh sách nút)</option>
                        <option value="TIM_KIEM">TÌM KIẾM (Tra sản phẩm)</option>
                  </select>
              </div>
              <div class="form-group">
                  <label>Nội dung Phản hồi / Từ khóa tìm kiếm</label>
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

<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>

<script>
    // Hàm đẩy dữ liệu từ nút bấm vào Modal Sửa
    function loadEditData(btn) {
        var id = btn.getAttribute("data-id");
        var ten = btn.getAttribute("data-ten");
        var loai = btn.getAttribute("data-loai");
        var phanhoi = btn.getAttribute("data-phanhoi");
        
        // Gán giá trị vào các ô input trong Modal
        document.getElementById("edit_id").value = id;
        document.getElementById("edit_ten").value = ten;
        document.getElementById("edit_loai").value = loai;
        document.getElementById("edit_phanhoi").value = phanhoi;
    }
</script>

</body>
</html>