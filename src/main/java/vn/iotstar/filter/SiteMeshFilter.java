package vn.iotstar.filter;

import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;

import jakarta.servlet.annotation.WebFilter;

@WebFilter(filterName = "sitemesh", urlPatterns = "/*")
public class SiteMeshFilter extends ConfigurableSiteMeshFilter {

    @Override
    protected void applyCustomConfiguration(SiteMeshFilterBuilder builder) {
        // Cấu hình Decorator Bootstrap cho khu vực Quản trị Admin
        builder.addDecoratorPath("/admin/*", "/decorators/admin.jsp")
               // Cấu hình Decorator Bootstrap 5 mặc định cho toàn bộ website
               .addDecoratorPath("/*", "/decorators/web.jsp")
               // Loại trừ các trang xác thực (Auth) và tài nguyên tĩnh
               .addExcludedPath("/login*")
               .addExcludedPath("/register*")
               .addExcludedPath("/verify-code*")
               .addExcludedPath("/forgot-password*")
               .addExcludedPath("/reset-password*")
               .addExcludedPath("/uploads/*")
               .addExcludedPath("/static/*")
               .addExcludedPath("/assets/*");
    }
}
