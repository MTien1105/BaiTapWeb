<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- BOOTSTRAP 5 FOOTER (SITEMESH DECORATOR) -->
<footer class="bg-dark text-white pt-4 pb-3 mt-auto border-top border-secondary">
    <div class="container-fluid px-4">
        <div class="row gy-3">
            <div class="col-lg-5 col-md-6">
                <h5 class="fw-bold text-white d-flex align-items-center gap-2">
                    <i class="bi bi-play-circle-fill text-danger"></i>
                    <span>JPA <span class="text-primary">VIDEOS</span></span>
                </h5>
                <p class="text-secondary small mb-2">
                    Hệ thống Web Java Servlet / JSP áp dụng kiến trúc MVC 3 tầng, công nghệ ORM JPA Hibernate 6.4, kết nối CSDL SQL Server 2022 và định dạng giao diện bằng <strong>SiteMesh Decorator 3 & Bootstrap 5</strong>.
                </p>
                <div class="d-flex gap-2">
                    <span class="badge bg-primary">Jakarta EE 10</span>
                    <span class="badge bg-success">Tomcat 11</span>
                    <span class="badge bg-info text-dark">SiteMesh 3</span>
                    <span class="badge bg-warning text-dark">Bootstrap 5.3</span>
                </div>
            </div>

            <div class="col-lg-3 col-md-6">
                <h6 class="fw-bold text-uppercase text-light mb-3">Liên Kết Nhanh</h6>
                <ul class="list-unstyled small">
                    <li class="mb-1"><a href="${pageContext.request.contextPath}/home" class="text-decoration-none text-secondary">🏠 Trang Chủ</a></li>
                    <li class="mb-1"><a href="${pageContext.request.contextPath}/video" class="text-decoration-none text-secondary">🎬 Video Phân Trang (6sp/trang)</a></li>
                    <c:if test="${sessionScope.account != null}">
                        <li class="mb-1"><a href="${pageContext.request.contextPath}/admin/videos" class="text-decoration-none text-secondary">📺 Quản Lý Video (CRUD)</a></li>
                    </c:if>
                    <li class="mb-1"><a href="${pageContext.request.contextPath}/login" class="text-decoration-none text-secondary">🔑 Đăng Nhập Hệ Thống</a></li>
                </ul>
            </div>

            <div class="col-lg-4 col-md-12">
                <h6 class="fw-bold text-uppercase text-light mb-3">Thông Tin Học Phần</h6>
                <p class="text-secondary small mb-1">
                    <i class="bi bi-mortarboard-fill me-1 text-primary"></i> Môn học: <strong>Lập Trình Web (WEBPR330479)</strong>
                </p>
                <p class="text-secondary small mb-1">
                    <i class="bi bi-person-badge-fill me-1 text-success"></i> Giảng viên: <strong>ThS. Nguyễn Hữu Trung</strong>
                </p>
                <p class="text-secondary small mb-0">
                    <i class="bi bi-building me-1 text-warning"></i> Trường Đại học Sư Phạm Kỹ Thuật TP.HCM (HCMUTE)
                </p>
            </div>
        </div>

        <hr class="border-secondary my-3">

        <div class="d-flex flex-wrap justify-content-between align-items-center small text-secondary">
            <div>
                © 2026 <strong>JPA Video Management System</strong>. All rights reserved.
            </div>
            <div>
                Thiết kế giao diện chuẩn Bootstrap 5 & SiteMesh 3 Decorator
            </div>
        </div>
    </div>
</footer>
