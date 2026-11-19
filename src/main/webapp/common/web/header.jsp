<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- BOOTSTRAP 5 NAVBAR HEADER (SITEMESH DECORATOR) -->
<header>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm py-2">
        <div class="container-fluid px-4">
            <!-- Brand Logo -->
            <a class="navbar-brand d-flex align-items-center gap-2 fw-bold text-white fs-4" href="${pageContext.request.contextPath}/home">
                <i class="bi bi-play-circle-fill text-danger fs-3"></i>
                <span>JPA <span class="text-primary">VIDEOS</span></span>
            </a>

            <!-- Mobile Hamburger Toggle -->
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMain" aria-controls="navbarMain" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <!-- Navbar Links -->
            <div class="collapse navbar-collapse" id="navbarMain">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0 align-items-lg-center">
                    <li class="nav-item">
                        <a class="nav-link px-3 active fw-semibold" href="${pageContext.request.contextPath}/home">
                            <i class="bi bi-house-door-fill me-1"></i> Trang Chủ
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link px-3 text-light" href="${pageContext.request.contextPath}/video">
                            <i class="bi bi-film me-1 text-info"></i> Video User (/video)
                        </a>
                    </li>
                    <c:if test="${sessionScope.account != null}">
                        <li class="nav-item">
                            <a class="nav-link px-3 text-warning fw-semibold" href="${pageContext.request.contextPath}/admin/videos">
                                <c:choose>
                                    <c:when test="${sessionScope.account.roleid == 1}">
                                        <i class="bi bi-gear-fill me-1"></i> Quản Lý Tất Cả Video (Admin)
                                    </c:when>
                                    <c:otherwise>
                                        <i class="bi bi-camera-video-fill me-1"></i> Quản Lý Video Của Tôi
                                    </c:otherwise>
                                </c:choose>
                            </a>
                        </li>
                    </c:if>
                </ul>

                <!-- Right Side: Auth / User Profile -->
                <div class="d-flex align-items-center gap-2 mt-3 mt-lg-0">
                    <c:choose>
                        <c:when test="${sessionScope.account == null}">
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-light btn-sm px-3 fw-semibold">
                                <i class="bi bi-box-arrow-in-right me-1"></i> Đăng Nhập
                            </a>
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-success btn-sm px-3 fw-semibold">
                                <i class="bi bi-person-plus-fill me-1"></i> Đăng Ký
                            </a>
                        </c:when>
                        <c:otherwise>
                            <div class="dropdown">
                                <button class="btn btn-secondary dropdown-toggle d-flex align-items-center gap-2 py-1 px-3 rounded-pill bg-dark border-secondary" type="button" id="userMenuBtn" data-bs-toggle="dropdown" aria-expanded="false">
                                    <span class="rounded-circle bg-primary text-white d-inline-flex justify-content-center align-items-center fw-bold" style="width: 28px; height: 28px; font-size: 13px;">
                                        <c:choose>
                                            <c:when test="${not empty sessionScope.account.fullName}">
                                                ${sessionScope.account.fullName.substring(0, 1).toUpperCase()}
                                            </c:when>
                                            <c:otherwise>
                                                ${sessionScope.account.userName.substring(0, 1).toUpperCase()}
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                    <span class="text-white fw-semibold small">${sessionScope.account.fullName}</span>
                                </button>
                                <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2" aria-labelledby="userMenuBtn">
                                    <li class="px-3 py-2 border-bottom">
                                        <div class="fw-bold text-dark">${sessionScope.account.fullName}</div>
                                        <div class="small text-muted">@${sessionScope.account.userName} | Role ${sessionScope.account.roleid}</div>
                                        <div class="small text-muted text-truncate" style="max-width: 200px;">${sessionScope.account.email}</div>
                                    </li>
                                    <li>
                                        <a class="dropdown-item py-2" href="${pageContext.request.contextPath}/video?userId=${sessionScope.account.id}">
                                            <i class="bi bi-collection-play me-2 text-primary"></i> Video của tôi
                                        </a>
                                    </li>
                                    <li>
                                        <a class="dropdown-item py-2" href="${pageContext.request.contextPath}/admin/videos">
                                            <i class="bi bi-sliders me-2 text-success"></i> Quản lý Video (CRUD)
                                        </a>
                                    </li>
                                    <li><hr class="dropdown-divider my-1"></li>
                                    <li>
                                        <a class="dropdown-item py-2 text-danger fw-semibold" href="${pageContext.request.contextPath}/logout">
                                            <i class="bi bi-box-arrow-right me-2"></i> Đăng Xuất
                                        </a>
                                    </li>
                                </ul>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </nav>
</header>
