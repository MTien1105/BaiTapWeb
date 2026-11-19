<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm Video Mới (JPA Entity Video)</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: #f0f2f5; }
        .container { max-width: 650px; margin: 30px auto; background: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); }
        h2 { color: #28a745; margin-bottom: 8px; text-align: center; font-size: 22px; }
        .subtitle { text-align: center; color: #6c757d; font-size: 13px; margin-bottom: 24px; }
        .form-group { margin-bottom: 18px; }
        label { display: block; font-weight: 600; margin-bottom: 6px; color: #333; font-size: 14px; }
        input[type="text"], input[type="number"], textarea, select {
            width: 100%; padding: 10px 12px; border: 1px solid #ced4da; border-radius: 4px; font-size: 14px; outline: none;
        }
        input:focus, textarea:focus, select:focus { border-color: #28a745; box-shadow: 0 0 0 2px rgba(40,167,69,0.2); }
        .btn-group { display: flex; gap: 12px; margin-top: 24px; }
        .btn { flex: 1; padding: 12px; border-radius: 4px; font-weight: 600; text-align: center; text-decoration: none; cursor: pointer; border: none; font-size: 15px; }
        .btn-save { background: #28a745; color: #fff; }
        .btn-save:hover { background: #218838; }
        .btn-cancel { background: #6c757d; color: #fff; }
        .btn-cancel:hover { background: #5a6268; }
        .hint { font-size: 12px; color: #888; margin-top: 4px; }
        .relation-box { background: #e7f3fe; border: 1px solid #b8daff; border-radius: 6px; padding: 12px; margin-bottom: 18px; }
        .relation-box label { color: #004085; }
    </style>
</head>
<body>
    <div class="container">
        <h2>➕ THÊM VIDEO MỚI</h2>
        <p class="subtitle">Thêm mới video vào hệ thống với mối quan hệ 1-N liên kết tới tài khoản Users</p>

        <c:if test="${not empty error}">
            <div style="background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; padding: 12px 16px; border-radius: 6px; margin-bottom: 20px; font-size: 14px; line-height: 1.5;">
                ⚠️ <strong>Lỗi:</strong> ${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/admin/video/insert" method="post" enctype="multipart/form-data" id="addVideoForm" novalidate>
            <div class="form-group">
                <label for="videoId">Mã Video (Video ID) <span style="color: red;">*</span>:</label>
                <input type="text" id="videoId" name="videoId" value="${videoId}" required placeholder="Ví dụ: V01, V02, JAVA01...">
                <div id="videoId-error" style="color: #dc3545; font-size: 12.5px; margin-top: 4px; display: none;"></div>
                <div class="hint">Khóa chính (Primary Key) dạng chuỗi từ 2-50 ký tự, không dấu, không khoảng trắng.</div>
            </div>

            <div class="form-group">
                <label for="title">Tiêu Đề Video <span style="color: red;">*</span>:</label>
                <input type="text" id="title" name="title" value="${title}" required placeholder="Nhập tên / tiêu đề video (tối thiểu 3 ký tự)...">
                <div id="title-error" style="color: #dc3545; font-size: 12.5px; margin-top: 4px; display: none;"></div>
            </div>

            <div class="form-group">
                <label for="description">Mô Tả Chi Tiết:</label>
                <textarea id="description" name="description" rows="3" placeholder="Nhập mô tả nội dung video...">${description}</textarea>
            </div>

            <div class="relation-box">
                <label>🔗 Người Đăng / Sở Hữu Video (Quan hệ 1 - N với Users):</label>
                <c:choose>
                    <c:when test="${isAdmin}">
                        <select id="userId" name="userId" required>
                            <c:forEach var="u" items="${userList}">
                                <option value="${u.id}" ${chosenUserId == u.id || (empty chosenUserId && sessionScope.account != null && sessionScope.account.id == u.id) ? 'selected' : ''}>
                                    👤 ${u.fullName} (Username: ${u.userName} | Email: ${u.email})
                                </option>
                            </c:forEach>
                        </select>
                        <div class="hint" style="color: #004085; margin-top: 5px;">(Admin) Bạn có quyền chỉ định người sở hữu video.</div>
                    </c:when>
                    <c:otherwise>
                        <div style="padding: 10px; background: #fff; border: 1px solid #ced4da; border-radius: 4px; font-weight: 600; color: #155724;">
                            👤 ${sessionScope.account.fullName} (${sessionScope.account.userName} - Email: ${sessionScope.account.email})
                        </div>
                        <input type="hidden" name="userId" value="${sessionScope.account.id}">
                        <div class="hint" style="color: #004085; margin-top: 5px;">Video này sẽ được tự động liên kết với tài khoản của bạn.</div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="form-group">
                <label for="posterUrl">Hình Ảnh Poster (Nhập link URL):</label>
                <input type="text" id="posterUrl" name="posterUrl" value="${posterUrl}" placeholder="https://example.com/image.jpg">
                <div id="posterUrl-error" style="color: #dc3545; font-size: 12.5px; margin-top: 4px; display: none;"></div>
            </div>

            <div class="form-group">
                <label for="posterFile">Hoặc Tải File Ảnh Từ Máy:</label>
                <input type="file" id="posterFile" name="posterFile" accept="image/*">
                <div id="posterFile-error" style="color: #dc3545; font-size: 12.5px; margin-top: 4px; display: none;"></div>
            </div>

            <div style="display: flex; gap: 15px;">
                <div class="form-group" style="flex: 1;">
                    <label for="views">Lượt Xem (Views):</label>
                    <input type="number" id="views" name="views" value="${not empty views ? views : '0'}" min="0">
                    <div id="views-error" style="color: #dc3545; font-size: 12.5px; margin-top: 4px; display: none;"></div>
                </div>

                <div class="form-group" style="flex: 1;">
                    <label for="active">Trạng Thái:</label>
                    <select id="active" name="active">
                        <option value="1" ${active == '1' || empty active ? 'selected' : ''}>✅ Hoạt động (Hiển thị)</option>
                        <option value="0" ${active == '0' ? 'selected' : ''}>❌ Tạm ẩn</option>
                    </select>
                </div>
            </div>

            <div class="btn-group">
                <button type="submit" class="btn btn-save">Lưu Video</button>
                <a href="${pageContext.request.contextPath}/admin/videos" class="btn btn-cancel">Hủy Bỏ</a>
            </div>
        </form>

        <script>
            document.getElementById('addVideoForm').addEventListener('submit', function(e) {
                let valid = true;

                function showError(inputId, errorId, msg) {
                    const err = document.getElementById(errorId);
                    err.textContent = msg;
                    err.style.display = 'block';
                    if (valid) {
                        document.getElementById(inputId).focus();
                    }
                    valid = false;
                }

                document.querySelectorAll('[id$="-error"]').forEach(el => el.style.display = 'none');

                const videoId = document.getElementById('videoId').value.trim();
                const title = document.getElementById('title').value.trim();
                const views = document.getElementById('views').value;
                const posterFile = document.getElementById('posterFile');

                // Validate videoId
                if (!videoId) {
                    showError('videoId', 'videoId-error', 'Vui lòng nhập Mã Video!');
                } else if (!/^[a-zA-Z0-9_-]{2,50}$/.test(videoId)) {
                    showError('videoId', 'videoId-error', 'Mã video phải từ 2-50 ký tự, chỉ gồm chữ cái, số, gạch ngang, không dấu!');
                }

                // Validate title
                if (!title) {
                    showError('title', 'title-error', 'Vui lòng nhập Tiêu đề Video!');
                } else if (title.length < 3) {
                    showError('title', 'title-error', 'Tiêu đề video phải có ít nhất 3 ký tự!');
                } else if (title.length > 500) {
                    showError('title', 'title-error', 'Tiêu đề video không được vượt quá 500 ký tự!');
                }

                // Validate views
                if (views !== '' && (isNaN(views) || parseInt(views) < 0)) {
                    showError('views', 'views-error', 'Lượt xem phải là số nguyên không âm (>= 0)!');
                }

                // Validate file ảnh nếu có chọn
                if (posterFile.files && posterFile.files.length > 0) {
                    const file = posterFile.files[0];
                    const validExts = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];
                    const fileName = file.name.toLowerCase();
                    const isValidExt = validExts.some(ext => fileName.endsWith(ext));
                    if (!isValidExt) {
                        showError('posterFile', 'posterFile-error', 'File không đúng định dạng ảnh (.jpg, .jpeg, .png, .gif, .webp)!');
                    } else if (file.size > 10 * 1024 * 1024) {
                        showError('posterFile', 'posterFile-error', 'Kích thước file ảnh không được vượt quá 10MB!');
                    }
                }

                if (!valid) {
                    e.preventDefault();
                }
            });
        </script>
    </div>
</body>
</html>
