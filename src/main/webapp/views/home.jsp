<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang Chủ - 10 Video Mới Nhất</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background: #f0f2f5; color: #333; }
        .main-container { max-width: 1200px; margin: 25px auto; padding: 0 20px; }
        
        /* Banner & Profile */
        .user-welcome-box { background: #fff; padding: 20px 25px; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); margin-bottom: 30px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 15px; }
        .user-welcome-info h2 { color: #28a745; font-size: 20px; margin-bottom: 6px; }
        .user-welcome-info p { color: #6c757d; font-size: 14px; }
        .user-meta-tags { display: flex; gap: 10px; margin-top: 8px; flex-wrap: wrap; }
        .badge { display: inline-block; padding: 4px 10px; border-radius: 4px; font-size: 12px; font-weight: 600; }
        .badge-active { background: #d4edda; color: #155724; }
        .badge-sec { background: #d1ecf1; color: #0c5460; }
        .badge-role { background: #cce5ff; color: #004085; }
        
        .guest-banner { background: linear-gradient(135deg, #007bff, #0056b3); color: #fff; padding: 30px; border-radius: 8px; text-align: center; margin-bottom: 30px; box-shadow: 0 4px 12px rgba(0,123,255,0.25); }
        .guest-banner h2 { font-size: 26px; margin-bottom: 8px; }
        .guest-banner p { font-size: 15px; opacity: 0.9; margin-bottom: 18px; }
        .guest-banner a { display: inline-block; padding: 10px 22px; background: #fff; color: #007bff; font-weight: 600; text-decoration: none; border-radius: 4px; margin: 0 6px; transition: 0.2s; }
        .guest-banner a:hover { background: #f8f9fa; }

        .btn-manage-video { display: inline-block; padding: 10px 20px; background: #28a745; color: #fff; text-decoration: none; border-radius: 6px; font-weight: 600; transition: background 0.2s; }
        .btn-manage-video:hover { background: #218838; }

        /* Video Section */
        .section-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 2px solid #007bff; padding-bottom: 10px; }
        .section-header h3 { font-size: 22px; color: #007bff; display: flex; align-items: center; gap: 8px; }
        .section-header span { color: #6c757d; font-size: 14px; }

        /* Video Grid Layout */
        .video-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(260px, 1fr)); gap: 22px; }
        .video-card { background: #fff; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 8px rgba(0,0,0,0.06); transition: transform 0.2s, box-shadow 0.2s; display: flex; flex-direction: column; }
        .video-card:hover { transform: translateY(-4px); box-shadow: 0 6px 16px rgba(0,0,0,0.12); }
        .video-thumbnail-box { position: relative; width: 100%; aspect-ratio: 16/9; background: #000; overflow: hidden; }
        .video-thumbnail-box img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.3s; }
        .video-card:hover .video-thumbnail-box img { transform: scale(1.05); }
        .video-badge-new { position: absolute; top: 10px; left: 10px; background: #dc3545; color: #fff; font-size: 11px; font-weight: bold; padding: 3px 7px; border-radius: 3px; text-transform: uppercase; }
        .video-badge-views { position: absolute; bottom: 8px; right: 8px; background: rgba(0,0,0,0.75); color: #fff; font-size: 11px; padding: 3px 7px; border-radius: 3px; }

        .video-body { padding: 14px; display: flex; flex-direction: column; flex: 1; }
        .video-title { font-size: 15px; font-weight: 600; color: #212529; margin-bottom: 6px; line-height: 1.35; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; min-height: 40px; }
        .video-desc { font-size: 12.5px; color: #6c757d; margin-bottom: 12px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; flex: 1; line-height: 1.4; }

        .video-footer { border-top: 1px solid #f1f1f1; padding-top: 10px; display: flex; justify-content: space-between; align-items: center; font-size: 12px; color: #495057; }
        .uploader-tag { font-weight: 500; color: #0056b3; background: #e7f1ff; padding: 2px 7px; border-radius: 3px; display: inline-flex; align-items: center; gap: 4px; }
        
        .empty-box { background: #fff; padding: 50px; text-align: center; border-radius: 8px; color: #6c757d; }
    </style>
</head>
<body>
    <jsp:include page="topbar.jsp" />

    <div class="main-container">
        <!-- Khu vực thông tin người dùng nếu đã đăng nhập -->
        <c:choose>
            <c:when test="${sessionScope.account != null}">
                <div class="user-welcome-box">
                    <div class="user-welcome-info">
                        <h2>👋 Chào mừng trở lại, ${sessionScope.account.fullName}!</h2>
                        <p>Tài khoản: <strong>${sessionScope.account.userName}</strong> | Email: ${sessionScope.account.email}</p>
                        <div class="user-meta-tags">
                            <span class="badge badge-active">✅ Kích hoạt qua OTP</span>
                            <span class="badge badge-sec">🔒 BCrypt Hash</span>
                            <span class="badge badge-role">Role ID: ${sessionScope.account.roleid}</span>
                        </div>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/admin/videos" class="btn-manage-video">📺 Vào Quản Lý Video (CRUD)</a>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="guest-banner">
                    <h2>🎬 CHÀO MỪNG BẠN ĐẾN VỚI HỆ THỐNG VIDEO & JPA!</h2>
                    <p>Khám phá kho video học tập chất lượng cao với công nghệ JPA 3.0 & Hibernate 6.x</p>
                    <div>
                        <a href="${pageContext.request.contextPath}/login">Đăng Nhập</a>
                        <a href="${pageContext.request.contextPath}/register" style="background: #28a745; color: #fff;">Đăng Ký Tài Khoản</a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>

        <!-- Danh sách 10 Video Mới Nhất -->
        <div class="section-header">
            <h3>🔥 10 VIDEO MỚI NHẤT TRÊN HỆ THỐNG</h3>
            <span>Tự động sắp xếp theo thứ tự mới nhất (JPA Query)</span>
        </div>

        <c:choose>
            <c:when test="${empty top10Videos}">
                <div class="empty-box">
                    <p style="font-size: 16px; margin-bottom: 12px;">Hiện tại chưa có video nào trong hệ thống!</p>
                    <c:if test="${sessionScope.account != null}">
                        <a href="${pageContext.request.contextPath}/admin/video/add" class="btn-manage-video">+ Thêm video đầu tiên ngay</a>
                    </c:if>
                </div>
            </c:when>
            <c:otherwise>
                <div class="video-grid">
                    <c:forEach var="v" items="${top10Videos}" varStatus="loop">
                        <div class="video-card">
                            <div class="video-thumbnail-box">
                                <span class="video-badge-new">#${loop.index + 1} MỚI</span>
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
                                        <img src="https://placehold.co/400x225?text=Video+HD" alt="${v.title}">
                                    </c:otherwise>
                                </c:choose>
                                <span class="video-badge-views">👁️ ${v.views} lượt xem</span>
                            </div>

                            <div class="video-body">
                                <div class="video-title" title="${v.title}">${v.title}</div>
                                <div class="video-desc" title="${v.description}">${v.description != null ? v.description : 'Không có mô tả nội dung.'}</div>
                                <div class="video-footer">
                                    <span class="uploader-tag" title="Mối quan hệ 1-N: Video thuộc về User ID ${v.user != null ? v.user.id : ''}">
                                        👤 ${v.user != null ? v.user.fullName : 'Hệ thống'}
                                    </span>
                                    <span style="color: #888; font-size: 11px;">Mã: ${v.videoId}</span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>
