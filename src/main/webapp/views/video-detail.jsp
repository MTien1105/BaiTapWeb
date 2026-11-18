<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${video.title} - Xem Video Chi Tiết</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: #f0f2f5; color: #333; }
        .detail-container { max-width: 1200px; margin: 25px auto; padding: 0 20px; display: grid; grid-template-columns: 2.2fr 1fr; gap: 25px; }
        @media (max-width: 850px) { .detail-container { grid-template-columns: 1fr; } }

        /* Main Video Player Area */
        .video-main { background: #fff; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 12px rgba(0,0,0,0.08); }
        .player-box { position: relative; width: 100%; aspect-ratio: 16/9; background: #000; display: flex; justify-content: center; align-items: center; }
        .player-box img { width: 100%; height: 100%; object-fit: cover; opacity: 0.85; }
        .play-overlay { position: absolute; width: 75px; height: 75px; background: rgba(220, 53, 69, 0.9); border-radius: 50%; display: flex; justify-content: center; align-items: center; color: #fff; font-size: 32px; cursor: pointer; box-shadow: 0 4px 20px rgba(0,0,0,0.4); transition: transform 0.2s, background 0.2s; }
        .play-overlay:hover { transform: scale(1.1); background: #c82333; }
        .play-overlay span { margin-left: 5px; }

        .video-content { padding: 22px 25px; }
        .video-title { font-size: 22px; font-weight: 700; color: #212529; margin-bottom: 12px; line-height: 1.35; }
        
        .video-stats { display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #e9ecef; padding-bottom: 15px; margin-bottom: 18px; font-size: 14px; color: #6c757d; }
        .views-badge { font-weight: 600; color: #007bff; background: #e7f3fe; padding: 4px 10px; border-radius: 4px; }

        /* Author Box (Quan he 1-N) */
        .author-card { background: #f8f9fa; border: 1px solid #e2e8f0; border-radius: 8px; padding: 15px 18px; margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 12px; }
        .author-meta { display: flex; align-items: center; gap: 12px; }
        .author-avatar { width: 48px; height: 48px; background: #007bff; color: #fff; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 20px; font-weight: bold; }
        .author-name { font-weight: 700; color: #212529; font-size: 15px; }
        .author-email { font-size: 13px; color: #6c757d; }
        .author-link { display: inline-block; padding: 6px 14px; background: #007bff; color: #fff; text-decoration: none; border-radius: 4px; font-size: 13px; font-weight: 600; transition: 0.2s; }
        .author-link:hover { background: #0056b3; }

        .video-description { font-size: 14.5px; line-height: 1.6; color: #495057; white-space: pre-line; background: #fff; padding: 10px 0; }
        .action-nav { margin-top: 25px; display: flex; gap: 12px; }
        .btn-nav { padding: 10px 18px; border-radius: 4px; text-decoration: none; font-weight: 600; font-size: 14px; transition: 0.2s; }
        .btn-back { background: #6c757d; color: #fff; }
        .btn-back:hover { background: #5a6268; }
        .btn-my-videos { background: #28a745; color: #fff; }
        .btn-my-videos:hover { background: #218838; }

        /* Sidebar Related Videos */
        .sidebar { display: flex; flex-direction: column; gap: 15px; }
        .sidebar-header { font-size: 17px; font-weight: 700; color: #007bff; border-bottom: 2px solid #007bff; padding-bottom: 8px; margin-bottom: 5px; }
        .side-card { background: #fff; border-radius: 6px; overflow: hidden; display: flex; gap: 12px; padding: 10px; box-shadow: 0 2px 6px rgba(0,0,0,0.05); text-decoration: none; color: inherit; transition: transform 0.2s; }
        .side-card:hover { transform: translateX(4px); box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
        .side-thumb { width: 120px; aspect-ratio: 16/9; border-radius: 4px; object-fit: cover; flex-shrink: 0; background: #000; }
        .side-info { display: flex; flex-direction: column; justify-content: center; }
        .side-title { font-size: 13.5px; font-weight: 600; line-height: 1.3; margin-bottom: 4px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; color: #212529; }
        .side-author { font-size: 12px; color: #6c757d; }
    </style>
</head>
<body>
    <jsp:include page="/views/topbar.jsp" />

    <div class="detail-container">
        <!-- Khu vực phát video chính -->
        <div class="video-main">
            <div class="player-box">
                <c:choose>
                    <c:when test="${not empty video.poster}">
                        <c:choose>
                            <c:when test="${video.poster.startsWith('http')}">
                                <img src="${video.poster}" alt="${video.title}" onerror="this.src='https://placehold.co/800x450?text=Playing+Video';">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/uploads/${video.poster}" alt="${video.title}" onerror="this.src='https://placehold.co/800x450?text=Playing+Video';">
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <img src="https://placehold.co/800x450?text=Playing+Video" alt="${video.title}">
                    </c:otherwise>
                </c:choose>
                <div class="play-overlay" title="Đang phát video">
                    <span>▶</span>
                </div>
            </div>

            <div class="video-content">
                <h1 class="video-title">${video.title}</h1>

                <div class="video-stats">
                    <div>
                        <span class="views-badge">👁️ ${video.views} lượt xem</span>
                        <span style="margin-left: 10px;">Mã Video: <strong>${video.videoId}</strong></span>
                    </div>
                    <div>
                        <span style="color: #28a745; font-weight: 600;">✅ Trạng thái: Đang hoạt động</span>
                    </div>
                </div>

                <!-- Thông tin tác giả sở hữu video (Quan hệ 1-N) -->
                <div class="author-card">
                    <div class="author-meta">
                        <div class="author-avatar">
                            ${video.user != null ? video.user.fullName.substring(0, 1).toUpperCase() : 'U'}
                        </div>
                        <div>
                            <div class="author-name">👤 ${video.user.fullName} (${video.user.userName})</div>
                            <div class="author-email">📧 ${video.user.email} | Vai trò: Role ID ${video.user.roleid}</div>
                        </div>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/video?userId=${video.user.id}" class="author-link">
                            Xem tất cả video của tác giả này »
                        </a>
                    </div>
                </div>

                <h3 style="font-size: 16px; margin-bottom: 8px; color: #212529;">Mô Tả Video:</h3>
                <div class="video-description">
                    ${video.description != null ? video.description : 'Chưa có mô tả chi tiết cho video này.'}
                </div>

                <div class="action-nav">
                    <a href="${pageContext.request.contextPath}/video" class="btn-nav btn-back">⬅ Danh Sách Video Của User</a>
                    <a href="${pageContext.request.contextPath}/home" class="btn-nav btn-my-videos">🏠 Về Trang Chủ</a>
                </div>
            </div>
        </div>

        <!-- Cột phải: Các video gợi ý -->
        <div class="sidebar">
            <div class="sidebar-header">🎬 CÁC VIDEO ĐỀ XUẤT KHÁC</div>
            <c:forEach var="rel" items="${relatedVideos}">
                <c:if test="${rel.videoId != video.videoId}">
                    <a href="${pageContext.request.contextPath}/video/detail?id=${rel.videoId}" class="side-card">
                        <c:choose>
                            <c:when test="${not empty rel.poster}">
                                <c:choose>
                                    <c:when test="${rel.poster.startsWith('http')}">
                                        <img src="${rel.poster}" alt="${rel.title}" class="side-thumb" onerror="this.src='https://placehold.co/120x68?text=Video';">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/uploads/${rel.poster}" alt="${rel.title}" class="side-thumb" onerror="this.src='https://placehold.co/120x68?text=Video';">
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                <img src="https://placehold.co/120x68?text=Video" alt="${rel.title}" class="side-thumb">
                            </c:otherwise>
                        </c:choose>
                        <div class="side-info">
                            <div class="side-title">${rel.title}</div>
                            <div class="side-author">👤 ${rel.user.fullName}</div>
                            <div style="font-size: 11px; color: #007bff; margin-top: 3px;">👁️ ${rel.views} views</div>
                        </div>
                    </a>
                </c:if>
            </c:forEach>
        </div>
    </div>
</body>
</html>
