<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Cập Nhật Video (JPA Entity Video)</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: #f0f2f5; }
        .container { max-width: 650px; margin: 30px auto; background: #fff; padding: 30px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); }
        h2 { color: #ffc107; margin-bottom: 8px; text-align: center; font-size: 22px; color: #d39e00; }
        .subtitle { text-align: center; color: #6c757d; font-size: 13px; margin-bottom: 24px; }
        .form-group { margin-bottom: 18px; }
        label { display: block; font-weight: 600; margin-bottom: 6px; color: #333; font-size: 14px; }
        input[type="text"], input[type="number"], textarea, select {
            width: 100%; padding: 10px 12px; border: 1px solid #ced4da; border-radius: 4px; font-size: 14px; outline: none;
        }
        input:focus, textarea:focus, select:focus { border-color: #ffc107; box-shadow: 0 0 0 2px rgba(255,193,7,0.25); }
        .btn-group { display: flex; gap: 12px; margin-top: 24px; }
        .btn { flex: 1; padding: 12px; border-radius: 4px; font-weight: 600; text-align: center; text-decoration: none; cursor: pointer; border: none; font-size: 15px; }
        .btn-update { background: #ffc107; color: #212529; }
        .btn-update:hover { background: #e0a800; }
        .btn-cancel { background: #6c757d; color: #fff; }
        .btn-cancel:hover { background: #5a6268; }
        .hint { font-size: 12px; color: #888; margin-top: 4px; }
        .current-poster { margin-top: 8px; display: flex; align-items: center; gap: 12px; }
        .current-poster img { width: 120px; height: 70px; object-fit: cover; border-radius: 4px; border: 1px solid #dee2e6; }
        .relation-box { background: #e7f3fe; border: 1px solid #b8daff; border-radius: 6px; padding: 12px; margin-bottom: 18px; }
        .relation-box label { color: #004085; }
    </style>
</head>
<body>
    <div class="container">
        <h2>✏️ CẬP NHẬT THÔNG TIN VIDEO</h2>
        <p class="subtitle">Chỉnh sửa thông tin video và cập nhật liên kết sở hữu với tài khoản Users</p>

        <c:if test="${not empty error}">
            <div style="background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; padding: 12px 16px; border-radius: 6px; margin-bottom: 20px; font-size: 14px; line-height: 1.5;">
                ⚠️ <strong>Lỗi:</strong> ${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/admin/video/update" method="post" enctype="multipart/form-data" id="editVideoForm" novalidate>
            <div class="form-group">
                <label for="videoId">Mã Video (Khóa chính - Không đổi):</label>
                <input type="text" id="videoId" name="videoId" value="${video.videoId}" readonly style="background-color: #e9ecef; cursor: not-allowed;">
            </div>

            <div class="form-group">
                <label for="title">Tiêu Đề Video <span style="color: red;">*</span>:</label>
                <input type="text" id="title" name="title" value="${video.title}" required placeholder="Nhập tên / tiêu đề video (tối thiểu 3 ký tự)...">
                <div id="title-error" style="color: #dc3545; font-size: 12.5px; margin-top: 4px; display: none;"></div>
            </div>

            <div class="form-group">
                <label for="description">Mô Tả Chi Tiết:</label>
                <textarea id="description" name="description" rows="3" placeholder="Nhập mô tả nội dung video...">${video.description}</textarea>
            </div>

            <div class="relation-box">
                <label>🔗 Người Đăng / Sở Hữu Video (Quan hệ 1 - N với Users):</label>
                <c:choose>
                    <c:when test="${isAdmin}">
                        <select id="userId" name="userId" required>
                            <c:forEach var="u" items="${userList}">
                                <option value="${u.id}" ${video.user != null && video.user.id == u.id ? 'selected' : ''}>
                                    👤 ${u.fullName} (Username: ${u.userName} | Email: ${u.email})
                                </option>
                            </c:forEach>
                        </select>
                        <div class="hint" style="color: #004085; margin-top: 5px;">(Admin) Bạn có quyền đổi chủ sở hữu video.</div>
                    </c:when>
                    <c:otherwise>
                        <div style="padding: 10px; background: #fff; border: 1px solid #ced4da; border-radius: 4px; font-weight: 600; color: #155724;">
                            👤 ${video.user != null ? video.user.fullName : sessionScope.account.fullName} (${video.user != null ? video.user.userName : sessionScope.account.userName})
                        </div>
                        <input type="hidden" name="userId" value="${video.user != null ? video.user.id : sessionScope.account.id}">
                        <div class="hint" style="color: #004085; margin-top: 5px;">Bạn chỉ có quyền chỉnh sửa video do chính bạn sở hữu.</div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="form-group">
                <label for="posterUrl">Hình Ảnh Poster (URL):</label>
                <input type="text" id="posterUrl" name="posterUrl" value="${video.poster}" placeholder="https://example.com/image.jpg">
                <c:if test="${not empty video.poster}">
                    <div class="current-poster">
                        <span style="font-size: 13px; color: #555;">Poster hiện tại:</span>
                        <c:choose>
                            <c:when test="${video.poster.startsWith('http')}">
                                <img src="${video.poster}" alt="Current Poster" onerror="this.src='https://placehold.co/120x70?text=No+Image';">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/uploads/${video.poster}" alt="Current Poster" onerror="this.src='https://placehold.co/120x70?text=No+Image';">
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>
            </div>

            <div class="form-group">
                <label for="posterFile">Hoặc Tải Lên Ảnh Poster Mới:</label>
                <input type="file" id="posterFile" name="posterFile" accept="image/*">
                <div id="posterFile-error" style="color: #dc3545; font-size: 12.5px; margin-top: 4px; display: none;"></div>
                <div class="hint">Bỏ trống nếu muốn giữ nguyên ảnh hiện tại.</div>
            </div>

            <div style="display: flex; gap: 15px;">
                <div class="form-group" style="flex: 1;">
                    <label for="views">Lượt Xem (Views):</label>
                    <input type="number" id="views" name="views" value="${video.views}" min="0">
                    <div id="views-error" style="color: #dc3545; font-size: 12.5px; margin-top: 4px; display: none;"></div>
                </div>

                <div class="form-group" style="flex: 1;">
                    <label for="active">Trạng Thái:</label>
                    <select id="active" name="active">
                        <option value="1" ${video.active == 1 ? 'selected' : ''}>✅ Hoạt động (Hiển thị)</option>
                        <option value="0" ${video.active == 0 ? 'selected' : ''}>❌ Tạm ẩn</option>
                    </select>
                </div>
            </div>

            <div class="btn-group">
                <button type="submit" class="btn btn-update">Cập Nhật Video</button>
                <a href="${pageContext.request.contextPath}/admin/videos" class="btn btn-cancel">Hủy Bỏ</a>
            </div>
        </form>

        <script>
            document.getElementById('editVideoForm').addEventListener('submit', function(e) {
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

                const title = document.getElementById('title').value.trim();
                const views = document.getElementById('views').value;
                const posterFile = document.getElementById('posterFile');

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
