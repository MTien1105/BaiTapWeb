<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh Sách Video Của User (Phân Trang 6 Video/Trang)</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: #f0f2f5; color: #333; }
        .main-container { max-width: 1200px; margin: 25px auto; padding: 0 20px; }
        
        /* Filter & Header */
        .page-header { background: #fff; padding: 22px 25px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); margin-bottom: 25px; }
        .header-top { display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 15px; margin-bottom: 15px; border-bottom: 2px solid #007bff; padding-bottom: 12px; }
        .header-top h2 { font-size: 22px; color: #007bff; display: flex; align-items: center; gap: 8px; }
        .header-top .subtitle { font-size: 13px; color: #6c757d; margin-top: 4px; }
        
        .filter-bar { display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 12px; }
        .filter-group { display: flex; align-items: center; gap: 10px; }
        .filter-group label { font-size: 14px; font-weight: 600; color: #495057; }
        .filter-group select { padding: 8px 12px; border: 1px solid #ced4da; border-radius: 4px; font-size: 14px; outline: none; background: #fff; }
        
        .badge { display: inline-block; padding: 4px 10px; border-radius: 4px; font-size: 12px; font-weight: 600; }
        .badge-user { background: #e7f3fe; color: #0056b3; border: 1px solid #b8daff; }
        .badge-my-video { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .btn-add { display: inline-block; padding: 8px 16px; background: #28a745; color: #fff; text-decoration: none; border-radius: 4px; font-weight: 600; font-size: 14px; transition: 0.2s; }
        .btn-add:hover { background: #218838; }

        /* Grid 6 items / page */
        .video-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 24px; margin-bottom: 30px; }
        .video-card { background: #fff; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.06); transition: transform 0.2s, box-shadow 0.2s; display: flex; flex-direction: column; }
        .video-card:hover { transform: translateY(-4px); box-shadow: 0 6px 16px rgba(0,0,0,0.12); }
        .video-thumbnail-box { position: relative; width: 100%; aspect-ratio: 16/9; background: #000; overflow: hidden; }
        .video-thumbnail-box img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.3s; }
        .video-card:hover .video-thumbnail-box img { transform: scale(1.05); }
        .badge-views { position: absolute; bottom: 8px; right: 8px; background: rgba(0,0,0,0.75); color: #fff; font-size: 11px; padding: 3px 7px; border-radius: 3px; }
        .badge-id { position: absolute; top: 8px; left: 8px; background: rgba(0,123,255,0.85); color: #fff; font-size: 11px; font-weight: bold; padding: 3px 7px; border-radius: 3px; }

        .video-body { padding: 16px; display: flex; flex-direction: column; flex: 1; }
        .video-title { font-size: 16px; font-weight: 600; color: #212529; margin-bottom: 8px; line-height: 1.4; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; min-height: 44px; transition: color 0.2s; }
        .video-title-link { text-decoration: none; color: inherit; display: block; }
        .video-title-link:hover .video-title { color: #007bff; text-decoration: underline; cursor: pointer; }
        .video-desc { font-size: 13px; color: #6c757d; margin-bottom: 14px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; flex: 1; line-height: 1.4; }

        .video-footer { border-top: 1px solid #f1f1f1; padding-top: 12px; display: flex; justify-content: space-between; align-items: center; font-size: 12.5px; }
        .uploader-info { font-weight: 500; color: #0056b3; background: #e7f1ff; padding: 3px 8px; border-radius: 3px; }

        /* Pagination Bar */
        .pagination-container { background: #fff; padding: 18px 25px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 15px; }
        .pagination-info { font-size: 14px; color: #6c757d; }
        .pagination-info strong { color: #212529; }
        .pagination-list { display: flex; gap: 6px; list-style: none; }
        .page-link { display: inline-block; padding: 7px 13px; border: 1px solid #dee2e6; border-radius: 4px; text-decoration: none; color: #007bff; font-weight: 600; font-size: 13.5px; background: #fff; transition: 0.2s; }
        .page-link:hover { background: #e9ecef; }
        .page-link.active { background: #007bff; color: #fff; border-color: #007bff; }
        .page-link.disabled { color: #adb5bd; pointer-events: none; background: #f8f9fa; border-color: #dee2e6; }

        .empty-box { background: #fff; padding: 60px 20px; text-align: center; border-radius: 8px; color: #6c757d; box-shadow: 0 2px 8px rgba(0,0,0,0.06); }
    </style>
</head>
<body>
    <jsp:include page="/views/topbar.jsp" />

    <div class="main-container">
        <!-- Khung tiêu đề và Bộ lọc theo User -->
        <div class="page-header">
            <div class="header-top">
                <div>
                    <h2>
                        🎬 
                        <c:choose>
                            <c:when test="${targetUser != null}">
                                Tất Cả Video Của: <strong>${targetUser.fullName}</strong>
                                <c:if test="${sessionScope.account != null && sessionScope.account.id == targetUser.id}">
                                    <span class="badge badge-my-video" style="margin-left: 8px;">(Video Của Tôi)</span>
                                </c:if>
                            </c:when>
                            <c:otherwise>
                                Tất Cả Video Trên Hệ Thống
                            </c:otherwise>
                        </c:choose>
                    </h2>
                    <p class="subtitle">Hiển thị danh sách video theo từng User với cơ chế phân trang 6 sản phẩm/trang (JPA Pagination)</p>
                </div>
                <c:if test="${sessionScope.account != null}">
                    <div>
                        <a href="${pageContext.request.contextPath}/admin/video/add" class="btn-add">+ Đăng Video Mới</a>
                    </div>
                </c:if>
            </div>

            <!-- Bộ lọc chọn User -->
            <div class="filter-bar">
                <form action="${pageContext.request.contextPath}/video" method="get" class="filter-group">
                    <label for="userFilter">👤 Lọc theo User chủ sở hữu:</label>
                    <select id="userFilter" name="userId" onchange="this.form.submit()">
                        <option value="0" ${targetUserId == null ? 'selected' : ''}>-- Xem Tất Cả Video Hệ Thống --</option>
                        <c:forEach var="u" items="${userList}">
                            <option value="${u.id}" ${targetUserId != null && targetUserId == u.id ? 'selected' : ''}>
                                👤 ${u.fullName} (${u.userName}) ${sessionScope.account != null && sessionScope.account.id == u.id ? '★ [Tôi]' : ''}
                            </option>
                        </c:forEach>
                    </select>
                </form>

                <div>
                    <span class="badge badge-user">📦 Quy định: <strong>6 video / trang</strong></span>
                </div>
            </div>
        </div>

        <!-- Danh sách Video (6 video / trang) -->
        <c:choose>
            <c:when test="${empty videoList}">
                <div class="empty-box">
                    <p style="font-size: 16px; margin-bottom: 12px;">Chưa có video nào của người dùng này!</p>
                    <c:choose>
                        <c:when test="${sessionScope.account != null}">
                            <a href="${pageContext.request.contextPath}/admin/video/add" class="btn-add">+ Đăng video đầu tiên</a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/video?userId=0" class="btn-add">Xem video của các tác giả khác</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:when>
            <c:otherwise>
                <div class="video-grid">
                    <c:forEach var="v" items="${videoList}">
                        <div class="video-card">
                            <a href="${pageContext.request.contextPath}/video/detail?id=${v.videoId}" style="text-decoration: none; color: inherit; display: block;">
                                <div class="video-thumbnail-box">
                                    <span class="badge-id">${v.videoId}</span>
                                    <c:choose>
                                        <c:when test="${not empty v.poster}">
                                            <c:choose>
                                                <c:when test="${v.poster.startsWith('http')}">
                                                    <img src="${v.poster}" alt="${v.title}" onerror="this.src='https://placehold.co/400x225?text=Video+Image';">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${pageContext.request.contextPath}/uploads/${v.poster}" alt="${v.title}" onerror="this.src='https://placehold.co/400x225?text=Video+Image';">
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            <img src="https://placehold.co/400x225?text=No+Poster" alt="${v.title}">
                                        </c:otherwise>
                                    </c:choose>
                                    <span class="badge-views">👁️ ${v.views} views</span>
                                </div>
                            </a>

                            <div class="video-body">
                                <a href="${pageContext.request.contextPath}/video/detail?id=${v.videoId}" class="video-title-link" title="Bấm vào tiêu đề để xem chi tiết và phát video">
                                    <div class="video-title">▶ ${v.title}</div>
                                </a>
                                <div class="video-desc" title="${v.description}">${v.description != null ? v.description : 'Không có mô tả chi tiết.'}</div>
                                <div class="video-footer">
                                    <span class="uploader-info" title="Quan hệ 1-N: Video thuộc User ID ${v.user.id}">
                                        👤 ${v.user.fullName}
                                    </span>
                                    <c:if test="${sessionScope.account != null && sessionScope.account.id == v.user.id}">
                                        <a href="${pageContext.request.contextPath}/admin/video/edit?id=${v.videoId}" style="color: #ffc107; font-weight: 600; text-decoration: none;">✏️ Sửa</a>
                                    </c:if>
                                </div>
                                <div style="margin-top: 10px;">
                                    <a href="${pageContext.request.contextPath}/video/detail?id=${v.videoId}" style="display: block; text-align: center; padding: 7px 12px; border-radius: 4px; text-decoration: none; font-weight: 600; font-size: 13px; background: #007bff; color: #fff;">
                                        🎬 Xem Chi Tiết & Play
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Thanh Phân Trang 6 video / trang -->
                <div class="pagination-container">
                    <div class="pagination-info">
                        Hiển thị <strong>6</strong> video/trang | Tổng cộng: <strong>${totalVideos}</strong> video | Trang <strong>${currentPage}</strong> / <strong>${totalPages}</strong>
                    </div>

                    <div class="pagination-list">
                        <!-- Nút Về Trang Đầu -->
                        <c:url var="firstPageUrl" value="/video">
                            <c:if test="${targetUserId != null}">
                                <c:param name="userId" value="${targetUserId}" />
                            </c:if>
                            <c:param name="page" value="1" />
                        </c:url>
                        <a href="${firstPageUrl}" class="page-link ${currentPage == 1 ? 'disabled' : ''}">« Đầu</a>

                        <!-- Nút Trang Trước -->
                        <c:url var="prevPageUrl" value="/video">
                            <c:if test="${targetUserId != null}">
                                <c:param name="userId" value="${targetUserId}" />
                            </c:if>
                            <c:param name="page" value="${currentPage - 1}" />
                        </c:url>
                        <a href="${prevPageUrl}" class="page-link ${currentPage == 1 ? 'disabled' : ''}">‹ Trước</a>

                        <!-- Các Nút Số Trang (1, 2, 3...) -->
                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <c:url var="pageUrl" value="/video">
                                <c:if test="${targetUserId != null}">
                                    <c:param name="userId" value="${targetUserId}" />
                                </c:if>
                                <c:param name="page" value="${i}" />
                            </c:url>
                            <a href="${pageUrl}" class="page-link ${currentPage == i ? 'active' : ''}">${i}</a>
                        </c:forEach>

                        <!-- Nút Trang Sau -->
                        <c:url var="nextPageUrl" value="/video">
                            <c:if test="${targetUserId != null}">
                                <c:param name="userId" value="${targetUserId}" />
                            </c:if>
                            <c:param name="page" value="${currentPage + 1}" />
                        </c:url>
                        <a href="${nextPageUrl}" class="page-link ${currentPage == totalPages ? 'disabled' : ''}">Sau ›</a>

                        <!-- Nút Về Trang Cuối -->
                        <c:url var="lastPageUrl" value="/video">
                            <c:if test="${targetUserId != null}">
                                <c:param name="userId" value="${targetUserId}" />
                            </c:if>
                            <c:param name="page" value="${totalPages}" />
                        </c:url>
                        <a href="${lastPageUrl}" class="page-link ${currentPage == totalPages ? 'disabled' : ''}">Cuối »</a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>
