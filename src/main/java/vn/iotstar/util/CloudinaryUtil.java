package vn.iotstar.util;

import java.io.File;
import java.io.FileOutputStream;
import java.nio.file.Paths;
import java.util.Map;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

import jakarta.servlet.http.Part;

public class CloudinaryUtil {

    private static Cloudinary cloudinary;

    // Cấu hình Cloudinary (có thể tùy biến hoặc lấy từ biến môi trường)
    private static final String CLOUD_NAME = System.getenv("CLOUDINARY_CLOUD_NAME") != null 
            ? System.getenv("CLOUDINARY_CLOUD_NAME") : "dpmclpmsb";
    private static final String API_KEY = System.getenv("CLOUDINARY_API_KEY") != null 
            ? System.getenv("CLOUDINARY_API_KEY") : "667499696417742";
    private static final String API_SECRET = System.getenv("CLOUDINARY_API_SECRET") != null 
            ? System.getenv("CLOUDINARY_API_SECRET") : "9pG3Vz_H11x7gZJ86bE9xQeK9cI";

    public static synchronized Cloudinary getCloudinary() {
        if (cloudinary == null) {
            cloudinary = new Cloudinary(ObjectUtils.asMap(
                "cloud_name", CLOUD_NAME,
                "api_key", API_KEY,
                "api_secret", API_SECRET,
                "secure", true
            ));
        }
        return cloudinary;
    }

    /**
     * Upload file Part lên Cloudinary sử dụng Multipart
     * @param part Part nhận được từ form multipart/form-data
     * @param folder Thư mục lưu trữ trên Cloudinary (vd: "user_avatars")
     * @return URL ảnh an toàn (HTTPS) từ Cloudinary hoặc đường dẫn local dự phòng
     */
    @SuppressWarnings("rawtypes")
    public static String uploadImage(Part part, String folder) {
        if (part == null || part.getSize() == 0) {
            return null;
        }

        try {
            byte[] fileBytes = part.getInputStream().readAllBytes();
            if (fileBytes.length == 0) {
                return null;
            }

            // Gọi Cloudinary API upload sử dụng Multipart byte[]
            Map uploadResult = getCloudinary().uploader().upload(fileBytes, ObjectUtils.asMap(
                "folder", folder != null ? folder : "user_avatars",
                "resource_type", "image"
            ));

            if (uploadResult != null && uploadResult.containsKey("secure_url")) {
                String secureUrl = (String) uploadResult.get("secure_url");
                System.out.println("[CLOUDINARY SUCCESS] Đã upload ảnh đại diện lên Cloudinary thành công: " + secureUrl);
                return secureUrl;
            }
        } catch (Throwable e) {
            System.err.println("[CLOUDINARY NOTICE] Không thể upload qua Cloudinary API (" + e.getMessage() + "), chuyển sang lưu trữ cục bộ dự phòng...");
            try {
                String submitted = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                String ext = submitted.contains(".") ? submitted.substring(submitted.lastIndexOf(".")) : ".jpg";
                String fileName = "avatar_" + System.currentTimeMillis() + ext;
                File uploadDir = new File(Constant.DIR);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                File dest = new File(uploadDir, fileName);
                try (FileOutputStream fos = new FileOutputStream(dest)) {
                    fos.write(part.getInputStream().readAllBytes());
                }
                return "/uploads/" + fileName;
            } catch (Exception ex) {
                System.err.println("[CLOUDINARY FALLBACK ERROR] " + ex.getMessage());
            }
        }
        return null;
    }
}
