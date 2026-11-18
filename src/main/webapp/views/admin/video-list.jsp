<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Video (Phân Quyền CRUD Theo User)</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: #f0f2f5; }
        .container { max-width: 1100px; margin: 30px auto; background: #fff; padding: 25px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); }
        .header-section { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 2px solid #007bff; padding-bottom: 12px; }
        .header-title h2 { color: #007bff; font-size: 22px; }
        .header-title p { font-size: 13px; color: #6c757d; margin-top: 4px; }
        .actions-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; gap: 15px; flex-wrap: wrap; }
        .search-box { display: flex; gap: 8px; flex: 1; max-width: 450px; }
        .search-box input { flex: 1; padding: 8px 12px; border: 1px solid #ced4da; border-radius: 4px; outline: none; }
        .btn { display: inline-block; padding: 8px 16px; border-radius: 4px; font-weight: 600; text-decoration: none; font-size: 14px; cursor: pointer; border: none; transition: 0.2s; }
        .btn-primary { background: #007bff; color: #fff; }
        .btn-primary:hover { background: #0056b3; }
        .btn-success { background: #28a745; color: #fff; }
        .btn-success:hover { background: #218838; }
        .btn-warning { background: #ffc107; color: #212529; }
        .btn-warning:hover { background: #e0a800; }
        .btn-danger { background: #dc3545; color: #fff; }
        .btn-danger:hover { background: #bd2130; }
        .btn-sm { padding: 5px 10px; font-size: 13px; }
        table { width: 100%; border-collapse: collapse; margin-top: 10px; font-size: 14px; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #dee2e6; vertical-align: middle; }
        th { background: #f8f9fa; color: #495057; font-weight: 600; }
        tr:hover { background: #fcfcfc; }
        .poster-img { width: 90px; height: 55px; object-fit: cover; border-radius: 4px; border: 1px solid #dee2e6; }
        .badge { display: inline-block; padding: 4px 8px; border-radius: 4px; font-size: 12px; font-weight: 600; }
        .badge-active { background: #d4edda; color: #155724; }
        .badge-inactive { background: #f8d7da; color: #721c24; }
        .badge-role { background: #e7f3fe; color: #0056b3; padding: 3px 8px; border-radius: 4px; font-weight: 600; font-size: 12px; }
        .user-tag { background: #e7f1ff; color: #004085; padding: 3px 8px; border-radius: 4px; font-weight: 500; font-size: 13px; }
        .user-tag-me { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .empty-msg { text-align: center; padding: 40px; color: #6c757d; }
        .alert-error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; padding: 12px 16px; border-radius: 6px; margin-bottom: 18px; font-size: 14px; }
        .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; padding: 12px 16px; border-radius: 6px; margin-bottom: 18px; font-size: 14px; }
    </style>
</head>
<body>
    <jsp:include page="/views/topbar.jsp" />

    <div class="container">
        <!-- Thông báo lỗi hoặc thành công nếu có -->
        <c:if test="${not empty flashError}">
            <div class="alert-error">⚠️ ${flashError}</div>
        </c:if>
        <c:if test="${not empty flashMessage}">
            <div class="alert-success">✅ ${flashMessage}</div>
        </c:if>

        <div class="header-section">
            <div class="header-title">
                <h2>
                    🎬 
                    <c:choose>
                        <c:when test="${isAdmin}">
                            QUẢN LÝ TẤT CẢ VIDEO HỆ THỐNG <span class="badge-role">QUYỀN ADMIN</span>
                        </c:when>
                        <c:otherwise>
                            QUẢN LÝ VIDEO CỦA TÔI: <strong>${sessionScope.account.fullName}</strong> (${sessionScope.account.userName})
                        </c:otherwise>
                    </c:choose>
                </h2>
                <p>
                    <c:choose>
                        <c:when test="${isAdmin}">
                            Bạn đang đăng nhập với tư cách Quản trị viên (Admin) — được phép xem, thêm, sửa, xóa toàn bộ video của tất cả người dùng.
                        </c:when>
                        <c:otherwise>
                            🔒 <strong>Quy định bảo mật:</strong> Mỗi người dùng chỉ có quyền Xem, Thêm, Chỉnh sửa và Xóa video do chính mình tạo ra!
                        </c:otherwise>
                    </c:choose>
                </p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/admin/video/add" class="btn btn-success">+ Đăng Video Mới</a>
            </div>
        </div>

        <div class="actions-bar">
            <form action="${pageContext.request.contextPath}/admin/videos" method="get" class="search-box">
                <input type="text" name="keyword" placeholder="Nhập tiêu đề video của bạn..." value="${keyword}">
                <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                <c:if test="${not empty keyword}">
                    <a href="${pageContext.request.contextPath}/admin/videos" class="btn btn-warning">Xem tất cả</a>
                </c:if>
            </form>
            <div>
                <span>Số lượng: <strong>${videoList != null ? videoList.size() : 0}</strong> video</span>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty videoList}">
                <div class="empty-msg">
                    <p style="font-size: 16px; margin-bottom: 12px;">
                        <c:choose>
                            <c:when test="${isAdmin}">
                                Chưa có video nào trong toàn bộ hệ thống!
                            </c:when>
                            <c:otherwise>
                                Bạn (${sessionScope.account.userName}) hiện chưa đăng video nào!
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <a href="${pageContext.request.contextPath}/admin/video/add" class="btn btn-success">+ Đăng video đầu tiên của bạn ngay</a>
                </div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                        <tr>
                            <th style="width: 80px;">Mã Video</th>
                            <th style="width: 100px;">Hình ảnh</th>
                            <th>Tiêu đề & Mô tả</th>
                            <th style="width: 90px;">Lượt xem</th>
                            <th style="width: 100px;">Trạng thái</th>
                            <th style="width: 160px;">Chủ sở hữu (1-N)</th>
                            <th style="width: 140px; text-align: center;">Thao tác CRUD</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${videoList}">
                            <tr>
                                <td><strong>${item.videoId}</strong></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty item.poster}">
                                            <c:choose>
                                                <c:when test="${item.poster.startsWith('http')}">
                                                    <img src="${item.poster}" alt="Poster" class="poster-img" onerror="this.src='https://placehold.co/90x55?text=No+Image';">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${pageContext.request.contextPath}/uploads/${item.poster}" alt="Poster" class="poster-img" onerror="this.src='https://placehold.co/90x55?text=No+Image';">
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            <img src="https://placehold.co/90x55?text=No+Poster" alt="No poster" class="poster-img">
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div style="font-weight: 600; color: #212529; margin-bottom: 4px;">
                                        <a href="${pageContext.request.contextPath}/video/detail?id=${item.videoId}" style="text-decoration: none; color: inherit;" title="Xem chi tiết và phát video">
                                            ${item.title}
                                        </a>
                                    </div>
                                    <div style="color: #6c757d; font-size: 13px; max-width: 320px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                        ${item.description != null ? item.description : 'Chưa có mô tả'}
                                    </div>
                                </td>
                                <td>👁️ ${item.views}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${item.active == 1}">
                                            <span class="badge badge-active">Hoạt động</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-inactive">Tạm ẩn</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${item.user != null}">
                                            <span class="user-tag ${sessionScope.account != null && sessionScope.account.id == item.user.id ? 'user-tag-me' : ''}">
                                                👤 ${item.user.fullName}
                                                <c:if test="${sessionScope.account != null && sessionScope.account.id == item.user.id}">
                                                    <strong>(Tôi)</strong>
                                                </c:if>
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999;">Chưa gán</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="text-align: center;">
                                    <c:choose>
                                        <c:when test="${isAdmin || (sessionScope.account != null && item.user != null && item.user.id == sessionScope.account.id)}">
                                            <a href="${pageContext.request.contextPath}/admin/video/edit?id=${item.videoId}" class="btn btn-warning btn-sm">✏️ Sửa</a>
                                            <a href="${pageContext.request.contextPath}/admin/video/delete?id=${item.videoId}" class="btn btn-danger btn-sm" onclick="return confirm('Bạn có chắc chắn muốn xóa video này không?');">🗑️ Xóa</a>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999; font-size: 12px; font-style: italic;">Không có quyền</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>