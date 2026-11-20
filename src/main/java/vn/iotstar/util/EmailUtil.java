package vn.iotstar.util;

import java.util.Properties;
import java.util.Random;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class EmailUtil {

    // Cấu hình SMTP Gmail (Có thể thay bằng tài khoản Gmail thật và Mật khẩu ứng dụng 16 ký tự khi muốn gửi email thực tế qua Internet)
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String FROM_EMAIL = "your-email@gmail.com";
    private static final String FROM_PASSWORD = "your-app-password";

    // Lưu mã OTP gần nhất và email tương ứng để phục vụ kiểm thử cục bộ tiện lợi
    private static volatile String lastOtp = "";
    private static volatile String lastEmail = "";

    public static String getLastOtp() {
        return lastOtp;
    }

    public static String getLastEmail() {
        return lastEmail;
    }

    /**
     * Sinh mã xác nhận OTP ngẫu nhiên gồm 6 chữ số
     */
    public static String generateOtp() {
        Random random = new Random();
        int number = random.nextInt(900000) + 100000; // Tạo số từ 100000 đến 999999
        String otp = String.valueOf(number);
        lastOtp = otp;
        return otp;
    }

    /**
     * Gửi email HTML với Jakarta Mail API và Angus Mail Implementation
     */
    public static boolean sendEmail(String toEmail, String subject, String htmlContent) {
        lastEmail = toEmail;

        System.out.println("==================================================================");
        System.out.println("[EMAIL NOTIFICATION] Gửi thông báo đến email: " + toEmail);
        System.out.println("[EMAIL SUBJECT] " + subject);
        System.out.println("[EMAIL CONTENT]\n" + htmlContent);
        System.out.println("==================================================================");

        try {
            Properties props = new Properties();
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            props.put("mail.smtp.connectiontimeout", "3000");
            props.put("mail.smtp.timeout", "3000");

            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(FROM_EMAIL, FROM_PASSWORD);
                }
            });

            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL, "Shopping System"));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject(subject, "UTF-8");
            message.setContent(htmlContent, "text/html; charset=UTF-8");

            Transport.send(message);
            System.out.println("[EMAIL SUCCESS] Đã gửi email thực tế thành công qua SMTP tới: " + toEmail);
            return true;
        } catch (Exception e) {
            System.err.println("[EMAIL NOTICE] Chưa kết nối SMTP thực tế: " + e.getMessage());
            System.out.println("[EMAIL DEMO] Mã OTP đã được lưu vào CSDL và xuất ra console để kiểm thử.");
            return false;
        }
    }

    /**
     * Tạo mẫu email kích hoạt tài khoản
     */
    public static String buildActivationEmail(String fullName, String otp) {
        lastOtp = otp;
        return "<div style=\"font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 8px;\">"
                + "<h2 style=\"color: #28a745; text-align: center;\">XÁC THỰC KÍCH HOẠT TÀI KHOẢN</h2>"
                + "<p>Xin chào <strong>" + fullName + "</strong>,</p>"
                + "<p>Cảm ơn bạn đã đăng ký tài khoản. Để kích hoạt tài khoản của bạn, vui lòng nhập mã OTP xác thực bên dưới:</p>"
                + "<div style=\"background-color: #f8f9fa; border: 2px dashed #28a745; padding: 15px; text-align: center; font-size: 32px; font-weight: bold; letter-spacing: 6px; color: #28a745; margin: 20px 0;\">"
                + otp
                + "</div>"
                + "<p style=\"color: #6c757d; font-size: 13px;\">Mã OTP có hiệu lực trong vòng 10 phút. Vui lòng không chia sẻ mã này cho bất kỳ ai khác.</p>"
                + "<hr style=\"border: none; border-top: 1px solid #eee; margin: 20px 0;\">"
                + "<p style=\"font-size: 12px; color: #999; text-align: center;\">Đây là thư tự động từ hệ thống Shopping System. Vui lòng không trả lời thư này.</p>"
                + "</div>";
    }

    /**
     * Tạo mẫu email đặt lại mật khẩu (quên mật khẩu)
     */
    public static String buildResetPasswordEmail(String fullName, String otp) {
        lastOtp = otp;
        return "<div style=\"font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 8px;\">"
                + "<h2 style=\"color: #007bff; text-align: center;\">YÊU CẦU ĐẶT LẠI MẬT KHẨU</h2>"
                + "<p>Xin chào <strong>" + fullName + "</strong>,</p>"
                + "<p>Chúng tôi nhận được yêu cầu khôi phục mật khẩu từ bạn. Vui lòng sử dụng mã OTP bên dưới để xác nhận đặt lại mật khẩu mới:</p>"
                + "<div style=\"background-color: #f8f9fa; border: 2px dashed #007bff; padding: 15px; text-align: center; font-size: 32px; font-weight: bold; letter-spacing: 6px; color: #007bff; margin: 20px 0;\">"
                + otp
                + "</div>"
                + "<p style=\"color: #6c757d; font-size: 13px;\">Nếu bạn không thực hiện yêu cầu này, vui lòng bỏ qua thư này để giữ an toàn cho tài khoản.</p>"
                + "<hr style=\"border: none; border-top: 1px solid #eee; margin: 20px 0;\">"
                + "<p style=\"font-size: 12px; color: #999; text-align: center;\">Đây là thư tự động từ hệ thống Shopping System. Vui lòng không trả lời thư này.</p>"
                + "</div>";
    }

    /**
     * Tạo mẫu email xác nhận cập nhật địa chỉ Email mới
     */
    public static String buildUpdateEmailOtp(String fullName, String otp, String newEmail) {
        lastOtp = otp;
        return "<div style=\"font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 20px; border: 1px solid #e0e0e0; border-radius: 8px;\">"
                + "<h2 style=\"color: #0d6efd; text-align: center;\">XÁC NHẬN CẬP NHẬT EMAIL MỚI</h2>"
                + "<p>Xin chào <strong>" + (fullName != null ? fullName : "Quý khách") + "</strong>,</p>"
                + "<p>Hệ thống nhận được yêu cầu cập nhật địa chỉ email tài khoản của bạn thành: <strong style=\"color: #0d6efd;\">" + newEmail + "</strong>.</p>"
                + "<p>Để xác nhận và hoàn tất việc cập nhật, vui lòng nhập mã OTP bên dưới vào trang thông tin cá nhân của bạn:</p>"
                + "<div style=\"background-color: #f8f9fa; border: 2px dashed #0d6efd; padding: 15px; text-align: center; font-size: 32px; font-weight: bold; letter-spacing: 6px; color: #0d6efd; margin: 20px 0;\">"
                + otp
                + "</div>"
                + "<p style=\"color: #6c757d; font-size: 13px;\">Mã OTP có hiệu lực trong vòng 10 phút. Nếu bạn không thực hiện yêu cầu này, vui lòng bỏ qua thư này để bảo vệ tài khoản.</p>"
                + "<hr style=\"border: none; border-top: 1px solid #eee; margin: 20px 0;\">"
                + "<p style=\"font-size: 12px; color: #999; text-align: center;\">Đây là thư tự động từ hệ thống Shopping System. Vui lòng không trả lời thư này.</p>"
                + "</div>";
    }
}
