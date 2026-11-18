<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${video.title} - Chi Tiết & Phát Video</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: #f0f2f5; color: #333; }
        .detail-container { max-width: 1200px; margin: 25px auto; padding: 0 20px; display: grid; grid-template-columns: 2.2fr 1fr; gap: 25px; }
        @media (max-width: 850px) { .detail-container { grid-template-columns: 1fr; } }

        /* Main Video Player Area */
        .video-main { background: #fff; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 12px rgba(0,0,0,0.08); }
        .player-box { position: relative; width: 100%; aspect-ratio: 16/9; background: #000; display: flex; justify-content: center; align-items: center; }
        .player-box video { width: 100%; height: 100%; object-fit: contain; background: #000; outline: none; }

        /* Player Toolbar Controls */
        .player-toolbar { background: #1a1a1a; padding: 10px 18px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 8px; color: #fff; font-size: 13px; }
        .toolbar-group { display: flex; align-items: center; gap: 8px; }
        .btn-ctrl { background: #333; color: #fff; border: 1px solid #444; border-radius: 4px; padding: 6px 12px; font-size: 13px; cursor: pointer; transition: 0.2s; }
        .btn-ctrl:hover { background: #007bff; border-color: #007bff; }
        .badge-live { background: #dc3545; color: #fff; padding: 3px 8px; border-radius: 3px; font-weight: bold; font-size: 11px; animation: pulse 1.5s infinite; }
        @keyframes pulse { 0% { opacity: 1; } 50% { opacity: 0.5; } 100% { opacity: 1; } }

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
        .side-card:hover .side-title { color: #007bff; }
        .side-author { font-size: 12px; color: #6c757d; }
    </style>
</head>
<body>
    <jsp:include page="/views/topbar.jsp" />

    <div class="detail-container">
        <!-- Khu vực phát video chính (Player + Thông tin chi tiết) -->
        <div class="video-main">
            <!-- Trình phát Video HTML5 thực tế -->
            <div class="player-box">
                <c:choose>
                    <c:when test="${not empty video.poster && video.poster.startsWith('http')}">
                        <c:set var="videoPoster" value="${video.poster}" />
                    </c:when>
                    <c:when test="${not empty video.poster}">
                        <c:set var="videoPoster" value="${pageContext.request.contextPath}/uploads/${video.poster}" />
                    </c:when>
                    <c:otherwise>
                        <c:set var="videoPoster" value="https://placehold.co/800x450?text=Playing+Video" />
                    </c:otherwise>
                </c:choose>

                <video id="mainVideoPlayer" controls autoplay playsinline preload="auto" poster="${videoPoster}">
                    <!-- Nguồn video MP4 phát trực tiếp -->
                    <c:choose>
                        <c:when test="${not empty video.poster && (video.poster.endsWith('.mp4') || video.poster.endsWith('.webm'))}">
                            <source src="${videoPoster}" type="video/mp4">
                        </c:when>
                        <c:otherwise>
                            <source src="https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4" type="video/mp4">
                            <source src="https://www.w3schools.com/html/mov_bbb.mp4" type="video/mp4">
                        </c:otherwise>
                    </c:choose>
                    Trình duyệt của bạn không hỗ trợ thẻ video HTML5.
                </video>
            </div>

            <!-- Thanh điều khiển nhanh trình phát -->
            <div class="player-toolbar">
                <div class="toolbar-group">
                    <span class="badge-live">🔴 ĐANG PHÁT</span>
                    <button class="btn-ctrl" onclick="togglePlay()" id="btnPlayPause">⏸️ Tạm dừng</button>
                    <button class="btn-ctrl" onclick="skipTime(-10)">⏪ Lùi 10s</button>
                    <button class="btn-ctrl" onclick="skipTime(10)">⏩ Tiến 10s</button>
                    <button class="btn-ctrl" onclick="toggleMute()" id="btnMute">🔊 Âm lượng</button>
                </div>
                <div class="toolbar-group">
                    <span>Tốc độ:</span>
                    <button class="btn-ctrl" onclick="setSpeed(1)">1x</button>
                    <button class="btn-ctrl" onclick="setSpeed(1.25)">1.25x</button>
                    <button class="btn-ctrl" onclick="setSpeed(1.5)">1.5x</button>
                    <button class="btn-ctrl" onclick="setSpeed(2)">2x</button>
                    <button class="btn-ctrl" onclick="toggleFullScreen()">⛶ Toàn màn hình</button>
                </div>
            </div>

            <!-- Nội dung chi tiết của Video -->
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
                            <div class="author-name">👤 Người đăng: ${video.user.fullName} (${video.user.userName})</div>
                            <div class="author-email">📧 ${video.user.email} | Vai trò: Role ID ${video.user.roleid}</div>
                        </div>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/video?userId=${video.user.id}" class="author-link" title="Xem tất cả video thuộc User này (Quan hệ 1-N)">
                            Xem tất cả video của tác giả này »
                        </a>
                    </div>
                </div>

                <h3 style="font-size: 16px; margin-bottom: 8px; color: #212529;">Mô Tả Chi Tiết Video:</h3>
                <div class="video-description">
                    ${video.description != null ? video.description : 'Chưa có mô tả chi tiết cho video này.'}
                </div>

                <div class="action-nav">
                    <a href="${pageContext.request.contextPath}/home" class="btn-nav btn-back">🏠 Về Trang Chủ</a>
                    <a href="${pageContext.request.contextPath}/video" class="btn-nav btn-my-videos">🎬 Tất Cả Video Của User (/video)</a>
                </div>
            </div>
        </div>

        <!-- Cột phải: Các video đề xuất khác (bấm vào tiêu đề cũng play video đó) -->
        <div class="sidebar">
            <div class="sidebar-header">🎬 CÁC VIDEO ĐỀ XUẤT KHÁC</div>
            <c:forEach var="rel" items="${relatedVideos}">
                <c:if test="${rel.videoId != video.videoId}">
                    <a href="${pageContext.request.contextPath}/video/detail?id=${rel.videoId}" class="side-card" title="Bấm vào để xem và phát video: ${rel.title}">
                        <c:choose>
                            <c:when test="${not empty rel.poster}">
                                <c:choose>
                                    <c:when test="${rel.poster.startsWith('http')}">
                                        <img src="${rel.poster}" alt="${rel.title}" class="side-thumb" onerror="this.src='https://placehold.co/120x68?text=Video';">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/uploads/${rel.poster}" alt="${rel.title}" class="side-thumb" onerror="this.src='https://placehold.co/800x450?text=Video';">
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

    <!-- Script điều khiển Video Player -->
    <script>
        const player = document.getElementById('mainVideoPlayer');
        const btnPlayPause = document.getElementById('btnPlayPause');
        const btnMute = document.getElementById('btnMute');

        // Tự động phát khi tải trang
        window.addEventListener('DOMContentLoaded', () => {
            if (player) {
                const playPromise = player.play();
                if (playPromise !== undefined) {
                    playPromise.catch(error => {
                        console.log("Trình duyệt yêu cầu người dùng tương tác để bật âm thanh autoplay:", error);
                        // Tự động phát ở chế độ tắt tiếng nếu bị chặn âm thanh
                        player.muted = true;
                        player.play();
                        if (btnMute) btnMute.innerText = "🔇 Đã tắt tiếng";
                    });
                }
            }
        });

        function togglePlay() {
            if (player.paused) {
                player.play();
                btnPlayPause.innerText = "⏸️ Tạm dừng";
            } else {
                player.pause();
                btnPlayPause.innerText = "▶ Tiếp tục";
            }
        }

        player.addEventListener('play', () => { btnPlayPause.innerText = "⏸️ Tạm dừng"; });
        player.addEventListener('pause', () => { btnPlayPause.innerText = "▶ Tiếp tục"; });

        function skipTime(seconds) {
            player.currentTime += seconds;
        }

        function toggleMute() {
            player.muted = !player.muted;
            btnMute.innerText = player.muted ? "🔇 Đã tắt tiếng" : "🔊 Âm lượng";
        }

        function setSpeed(rate) {
            player.playbackRate = rate;
        }

        function toggleFullScreen() {
            if (!document.fullscreenElement) {
                if (player.requestFullscreen) {
                    player.requestFullscreen();
                } else if (player.webkitRequestFullscreen) {
                    player.webkitRequestFullscreen();
                }
            } else {
                if (document.exitFullscreen) {
                    document.exitFullscreen();
                }
            }
        }
    </script>
</body>
</html>