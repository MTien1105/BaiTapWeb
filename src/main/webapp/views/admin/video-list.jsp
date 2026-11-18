<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Danh Sách Video (JPA CRUD)</title>
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
        .user-tag { background: #e7f1ff; color: #004085; padding: 3px 8px; border-radius: 4px; font-weight: 500; font-size: 13px; }
        .empty-msg { text-align: center; padding: 40px; color: #6c757d; font-style: italic; }
    </style>
</head>
<body>
    <jsp:include page="/views/topbar.jsp" />

    <div class="container">
        <div class="header-section">
            <div class="header-title">
                <h2>📺 QUẢN LÝ VIDEO (JPA CRUD & QUAN HỆ 1-N VỚI USERS)</h2>
                <p>Thực hiện các thao tác Thêm, Sửa, Xóa và Tìm kiếm Video với Hibernate 6.x & Jakarta EE 10</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/admin/video/add" class="btn btn-success">+ Thêm Video Mới</a>
            </div>
        </div>

        <div class="actions-bar">
            <form action="${pageContext.request.contextPath}/admin/videos" method="get" class="search-box">
                <input type="text" name="keyword" placeholder="Nhập tiêu đề video cần tìm..." value="${keyword}">
                <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                <c:if test="${not empty keyword}">
                    <a href="${pageContext.request.contextPath}/admin/videos" class="btn btn-warning">Xem tất cả</a>
                </c:if>
            </form>
            <div>
                <span>Tổng số: <strong>${videoList.size()}</strong> video</span>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty videoList}">
                <div class="empty-msg">
                    <p>Chưa có video nào trong hệ thống hoặc không tìm thấy video phù hợp!</p>
                    <a href="${pageContext.request.contextPath}/admin/video/add" class="btn btn-primary" style="margin-top: 15px;">Thêm video đầu tiên ngay</a>
                </div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                        <tr>
                            <th style="width: 80px;">Mã Video</th>
                            <th style="width: 100px;">Hình ảnh</th>
                            <th>Tiêu đề & Mô tả</th>
                            <th style="width: 100px;">Lượt xem</th>
                            <th style="width: 110px;">Trạng thái</th>
                            <th style="width: 170px;">Người đăng (1-N)</th>
                            <th style="width: 140px; text-align: center;">Hành động</th>
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
                                    <div style="font-weight: 600; color: #212529; margin-bottom: 4px;">${item.title}</div>
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
                                            <span class="user-tag" title="User ID: ${item.user.id}">
                                                👤 ${item.user.fullName} (${item.user.userName})
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #999;">Chưa gán</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="text-align: center;">
                                    <a href="${pageContext.request.contextPath}/admin/video/edit?id=${item.videoId}" class="btn btn-warning btn-sm">Sửa</a>
                                    <a href="${pageContext.request.contextPath}/admin/video/delete?id=${item.videoId}" class="btn btn-danger btn-sm" onclick="return confirm('Bạn có chắc chắn muốn xóa video này?');">Xóa</a>
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
