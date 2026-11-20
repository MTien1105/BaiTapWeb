<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hồ Sơ Cá Nhân - Cập Nhật Thông Tin</title>
    <style>
        .profile-header-bg {
            background: linear-gradient(135deg, #0d6efd 0%, #0a58ca 100%);
            border-radius: 12px 12px 0 0;
            height: 110px;
        }
        .avatar-wrapper {
            position: relative;
            margin-top: -60px;
            display: inline-block;
        }
        .profile-avatar-img {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 50%;
            border: 4px solid #fff;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            background-color: #f8f9fa;
        }
        .avatar-upload-badge {
            position: absolute;
            bottom: 5px;
            right: 5px;
            background-color: #0d6efd;
            color: #fff;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 2px 6px rgba(0,0,0,0.2);
            transition: transform 0.2s, background-color 0.2s;
        }
        .avatar-upload-badge:hover {
            transform: scale(1.1);
            background-color: #0b5ed7;
        }
        .otp-box {
            background: #f0f7ff;
            border: 2px dashed #0d6efd;
            border-radius: 10px;
        }
        .form-floating label {
            color: #6c757d;
        }
    </style>
</head>
<body>
<div class="container py-4">
    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb py-2 px-3 bg-white rounded shadow-sm">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home" class="text-decoration-none"><i class="bi bi-house-door-fill me-1"></i>Trang Chủ</a></li>
            <li class="breadcrumb-item active" aria-current="page">Hồ Sơ Cá Nhân</li>
        </ol>
    </nav>

    <!-- Global Alert Notifications -->
    <c:if test="${not empty flashMessage}">
        <div class="alert alert-success alert-dismissible fade show shadow-sm d-flex align-items-center gap-2 mb-4" role="alert">
            <i class="bi bi-check-circle-fill fs-5"></i>
            <div><strong>Thành công!</strong> <c:out value="${flashMessage}" /></div>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <c:if test="${not empty flashError || not empty error}">
        <div class="alert alert-danger alert-dismissible fade show shadow-sm d-flex align-items-center gap-2 mb-4" role="alert">
            <i class="bi bi-exclamation-triangle-fill fs-5"></i>
            <div><strong>Lỗi:</strong> <c:out value="${not empty error ? error : flashError}" /></div>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <c:if test="${not empty flashNotice}">
        <div class="alert alert-info alert-dismissible fade show shadow-sm d-flex align-items-center gap-2 mb-4" role="alert">
            <i class="bi bi-info-circle-fill fs-5"></i>
            <div><c:out value="${flashNotice}" /></div>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <!-- SECTION: XÁC THỰC OTP KHI CÓ EMAIL MỚI ĐANG CHỜ -->
    <c:if test="${not empty sessionScope.pendingNewEmail}">
        <div class="card shadow-sm border-primary mb-4">
            <div class="card-header bg-primary text-white d-flex align-items-center justify-content-between">
                <span class="fw-bold"><i class="bi bi-shield-lock-fill me-2"></i>Xác Thực Thay Đổi Địa Chỉ Email</span>
                <span class="badge bg-warning text-dark"><i class="bi bi-clock-history me-1"></i>Chờ xác nhận</span>
            </div>
            <div class="card-body otp-box p-4">
                <div class="row align-items-center">
                    <div class="col-lg-7 mb-3 mb-lg-0">
                        <h5 class="text-primary fw-bold mb-2">Đang chờ xác nhận Email mới</h5>
                        <p class="mb-1 text-muted">
                            Hệ thống đã gửi mã OTP xác nhận gồm 6 chữ số tới địa chỉ email: 
                            <strong class="text-dark fs-6"><c:out value="${sessionScope.pendingNewEmail}" /></strong>
                        </p>
                        <p class="small text-secondary mb-0">
                            Vui lòng kiểm tra hộp thư đến (hoặc hòm thư Spam) và nhập mã OTP để hoàn tất việc cập nhật email tài khoản của bạn.
                        </p>
                    </div>
                    <div class="col-lg-5">
                        <c:if test="${not empty otpError}">
                            <div class="alert alert-danger py-2 px-3 small mb-2">
                                <i class="bi bi-x-circle-fill me-1"></i><c:out value="${otpError}" />
                            </div>
                        </c:if>
                        <form action="${pageContext.request.contextPath}/profile/verify-email" method="post" class="d-flex flex-column gap-2">
                            <div class="input-group">
                                <span class="input-group-text bg-white"><i class="bi bi-key-fill text-primary"></i></span>
                                <input type="text" name="otp" id="otp" class="form-control text-center fw-bold fs-5 letter-spacing-2" placeholder="Nhập mã OTP 6 số" maxlength="6" required pattern="[0-9]{6}">
                                <button type="submit" class="btn btn-primary fw-semibold px-3">
                                    <i class="bi bi-check2-circle me-1"></i>Xác Nhận
                                </button>
                            </div>
                            <div class="d-flex justify-content-between mt-1">
                                <a href="${pageContext.request.contextPath}/profile/resend-otp" class="small text-decoration-none text-primary">
                                    <i class="bi bi-arrow-clockwise me-1"></i>Gửi lại mã OTP
                                </a>
                                <a href="${pageContext.request.contextPath}/profile/cancel-email-change" class="small text-decoration-none text-danger" onclick="return confirm('Bạn có chắc chắn muốn hủy yêu cầu đổi email này không?');">
                                    <i class="bi bi-x-circle me-1"></i>Hủy yêu cầu
                                </a>
                            </div>
                            <!-- Tiện ích hỗ trợ xem nhanh mã OTP khi test cục bộ -->
                            <div class="mt-2 p-2 bg-white bg-opacity-75 border border-warning rounded small">
                                <i class="bi bi-info-circle-fill text-primary me-1"></i>
                                <span>Mã OTP test nhanh: <strong class="badge bg-danger fs-6 px-2 py-1">${sessionScope.pendingEmailOtp}</strong> (hoặc xem tại cửa sổ đen Tomcat)</span>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </c:if>

    <!-- MAIN PROFILE SECTION -->
    <div class="row g-4">
        <!-- Cột Trái: Thẻ Tóm Tắt Thông Tin Người Dùng & Avatar -->
        <div class="col-lg-4">
            <div class="card shadow-sm border-0 text-center">
                <div class="profile-header-bg"></div>
                <div class="card-body pt-0 pb-4">
                    <div class="avatar-wrapper mb-3">
                        <c:choose>
                            <c:when test="${not empty user.avatar}">
                                <c:choose>
                                    <c:when test="${user.avatar.startsWith('http')}">
                                        <img src="${user.avatar}" alt="Avatar" id="avatarPreviewLeft" class="profile-avatar-img">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}${user.avatar}" alt="Avatar" id="avatarPreviewLeft" class="profile-avatar-img">
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                <img src="https://ui-avatars.com/api/?name=${user.fullName != null ? user.fullName : user.userName}&size=128&background=0d6efd&color=fff&bold=true" alt="Avatar" id="avatarPreviewLeft" class="profile-avatar-img">
                            </c:otherwise>
                        </c:choose>
                        <label for="avatarFile" class="avatar-upload-badge" title="Tải ảnh mới lên Cloudinary">
                            <i class="bi bi-camera-fill"></i>
                        </label>
                    </div>

                    <h4 class="card-title fw-bold text-dark mb-1">
                        <c:out value="${user.fullName != null && !user.fullName.isEmpty() ? user.fullName : user.userName}" />
                    </h4>
                    <p class="text-muted small mb-2">@<c:out value="${user.userName}" /></p>

                    <div class="d-flex justify-content-center gap-2 mb-3">
                        <c:choose>
                            <c:when test="${user.roleid == 1}">
                                <span class="badge bg-danger px-3 py-2"><i class="bi bi-shield-shaded me-1"></i>Quản Trị Viên (Admin)</span>
                            </c:when>
                            <c:when test="${user.roleid == 2}">
                                <span class="badge bg-warning text-dark px-3 py-2"><i class="bi bi-person-badge-fill me-1"></i>Quản Lý (Manager)</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-info text-dark px-3 py-2"><i class="bi bi-person-fill me-1"></i>Thành Viên (User)</span>
                            </c:otherwise>
                        </c:choose>
                        <span class="badge bg-success px-3 py-2"><i class="bi bi-check2 me-1"></i>Hoạt động</span>
                    </div>

                    <ul class="list-group list-group-flush text-start small border-top pt-2">
                        <li class="list-group-item d-flex justify-content-between align-items-center px-0 py-2">
                            <span class="text-muted"><i class="bi bi-envelope me-2 text-primary"></i>Email hiện tại</span>
                            <span class="fw-semibold text-truncate" style="max-width: 180px;"><c:out value="${user.email}" /></span>
                        </li>
                        <li class="list-group-item d-flex justify-content-between align-items-center px-0 py-2">
                            <span class="text-muted"><i class="bi bi-telephone me-2 text-success"></i>Số điện thoại</span>
                            <span class="fw-semibold"><c:out value="${user.phone != null ? user.phone : 'Chưa cập nhật'}" /></span>
                        </li>
                        <li class="list-group-item d-flex justify-content-between align-items-center px-0 py-2">
                            <span class="text-muted"><i class="bi bi-calendar3 me-2 text-info"></i>Ngày tham gia</span>
                            <span class="fw-semibold"><c:out value="${user.createdDate}" /></span>
                        </li>
                    </ul>

                    <div class="d-grid gap-2 mt-3">
                        <a href="${pageContext.request.contextPath}/admin/videos" class="btn btn-outline-primary btn-sm fw-semibold">
                            <i class="bi bi-collection-play-fill me-1"></i>Quản Lý Video Của Tôi
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Cột Phải: Form Cập Nhật Thông Tin Hồ Sơ -->
        <div class="col-lg-8">
            <div class="card shadow-sm border-0">
                <div class="card-header bg-white py-3 border-bottom d-flex align-items-center justify-content-between">
                    <h5 class="mb-0 fw-bold text-dark d-flex align-items-center gap-2">
                        <i class="bi bi-pencil-square text-primary"></i>
                        <span>Chỉnh Sửa Thông Tin Cá Nhân</span>
                    </h5>
                    <span class="badge bg-light text-secondary border">Cập nhật hồ sơ</span>
                </div>

                <div class="card-body p-4">
                    <form action="${pageContext.request.contextPath}/profile" method="post" enctype="multipart/form-data" id="profileForm" novalidate>
                        
                        <!-- Row 1: Username (Không sửa) & Full Name -->
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label for="userName" class="form-label fw-semibold text-muted">
                                    <i class="bi bi-person me-1"></i>Tên đăng nhập (Username)
                                </label>
                                <input type="text" class="form-control bg-light" id="userName" value="${user.userName}" readonly disabled>
                                <div class="form-text small">Tên đăng nhập là định danh duy nhất và không thể thay đổi.</div>
                            </div>

                            <div class="col-md-6">
                                <label for="fullName" class="form-label fw-semibold text-dark">
                                    <i class="bi bi-person-badge me-1 text-primary"></i>Họ và tên <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control" id="fullName" name="fullName" 
                                       value="${user.fullName}" required minlength="2" maxlength="100" 
                                       placeholder="Nhập họ và tên đầy đủ của bạn">
                                <div class="invalid-feedback">Họ và tên bắt buộc nhập (từ 2 đến 100 ký tự).</div>
                            </div>
                        </div>

                        <!-- Row 2: Phone & Email -->
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label for="phone" class="form-label fw-semibold text-dark">
                                    <i class="bi bi-telephone-fill me-1 text-success"></i>Số điện thoại <span class="text-danger">*</span>
                                </label>
                                <input type="tel" class="form-control" id="phone" name="phone" 
                                       value="${user.phone}" required pattern="^(0|\+84)[0-9]{9,10}$" 
                                       placeholder="Ví dụ: 0901234567">
                                <div class="form-text small">Định dạng số điện thoại Việt Nam (10 - 11 chữ số).</div>
                                <div class="invalid-feedback">Vui lòng nhập số điện thoại hợp lệ.</div>
                            </div>

                            <div class="col-md-6">
                                <label for="email" class="form-label fw-semibold text-dark">
                                    <i class="bi bi-envelope-at-fill me-1 text-primary"></i>Địa chỉ Email <span class="text-danger">*</span>
                                </label>
                                <input type="email" class="form-control" id="email" name="email" 
                                       value="${user.email}" required 
                                       placeholder="Ví dụ: email@domain.com">
                                <div class="form-text small text-info">
                                    <i class="bi bi-info-circle me-1"></i>Nếu thay đổi Email, hệ thống sẽ gửi mã OTP đến email mới để xác nhận.
                                </div>
                                <div class="invalid-feedback">Vui lòng nhập định dạng email hợp lệ.</div>
                            </div>
                        </div>

                        <!-- Row 3: Upload Avatar (Cloudinary Multipart) -->
                        <div class="mb-4">
                            <label for="avatarFile" class="form-label fw-semibold text-dark">
                                <i class="bi bi-cloud-arrow-up-fill me-1 text-info"></i>Ảnh Đại Diện (Upload lên Cloudinary)
                            </label>
                            <input class="form-control" type="file" id="avatarFile" name="avatarFile" accept="image/png, image/jpeg, image/jpg, image/gif, image/webp">
                            <div class="form-text small">
                                Định dạng hỗ trợ: JPG, JPEG, PNG, WEBP, GIF. Kích thước tối đa 5MB. Ảnh sẽ được tự động lưu trữ và tối ưu hóa qua Cloudinary.
                            </div>
                        </div>

                        <!-- Live Preview Box -->
                        <div id="previewContainer" class="d-none mb-4 p-3 bg-light rounded border d-flex align-items-center gap-3">
                            <img id="imagePreview" src="#" alt="Preview" style="width: 70px; height: 70px; object-fit: cover; border-radius: 50%; border: 2px solid #0d6efd;">
                            <div>
                                <span class="badge bg-primary mb-1"><i class="bi bi-image me-1"></i>Ảnh mới chọn</span>
                                <div class="small text-muted" id="previewFileName">filename.jpg</div>
                            </div>
                        </div>

                        <hr class="my-4">

                        <!-- Action Buttons -->
                        <div class="d-flex justify-content-end gap-2">
                            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary px-4">
                                <i class="bi bi-arrow-left me-1"></i>Quay Lại
                            </a>
                            <button type="submit" class="btn btn-primary px-4 fw-semibold" id="btnSaveProfile">
                                <i class="bi bi-save2-fill me-1"></i>Lưu Thay Đổi
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- CLIENT JAVASCRIPT VALIDATION & LIVE PREVIEW -->
<script>
    document.addEventListener("DOMContentLoaded", function() {
        const avatarInput = document.getElementById("avatarFile");
        const imagePreview = document.getElementById("imagePreview");
        const previewContainer = document.getElementById("previewContainer");
        const previewFileName = document.getElementById("previewFileName");
        const avatarPreviewLeft = document.getElementById("avatarPreviewLeft");

        if (avatarInput) {
            avatarInput.addEventListener("change", function() {
                const file = this.files[0];
                if (file) {
                    // Kiểm tra định dạng
                    const validTypes = ["image/jpeg", "image/jpg", "image/png", "image/webp", "image/gif"];
                    if (!validTypes.includes(file.type)) {
                        alert("Vui lòng chọn đúng file hình ảnh (.jpg, .jpeg, .png, .webp, .gif)!");
                        this.value = "";
                        previewContainer.classList.add("d-none");
                        return;
                    }

                    // Kiểm tra kích thước (5MB)
                    if (file.size > 5 * 1024 * 1024) {
                        alert("Kích thước file ảnh không được vượt quá 5MB!");
                        this.value = "";
                        previewContainer.classList.add("d-none");
                        return;
                    }

                    const reader = new FileReader();
                    reader.onload = function(e) {
                        imagePreview.src = e.target.result;
                        if (avatarPreviewLeft) {
                            avatarPreviewLeft.src = e.target.result;
                        }
                        previewFileName.textContent = file.name + " (" + (file.size / 1024).toFixed(1) + " KB)";
                        previewContainer.classList.remove("d-none");
                    };
                    reader.readAsDataURL(file);
                } else {
                    previewContainer.classList.add("d-none");
                }
            });
        }

        // Bootstrap Client Validation
        const form = document.getElementById("profileForm");
        if (form) {
            form.addEventListener("submit", function(event) {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                form.classList.add("was-validated");
            }, false);
        }
    });
</script>
</body>
</html>
