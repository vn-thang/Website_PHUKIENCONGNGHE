//package Service;
//
//import java.util.Properties;
//import jakarta.mail.Authenticator;
//import jakarta.mail.Message;
//import jakarta.mail.PasswordAuthentication;
//import jakarta.mail.Session;
//import jakarta.mail.Transport;
//import jakarta.mail.internet.InternetAddress;
//import jakarta.mail.internet.MimeMessage;
//
//public class EmailService {
//    
//    // =================================================================================
//    // THAY THẾ BẰNG THÔNG TIN EMAIL VÀ MẬT KHẨU ỨNG DỤNG CỦA BẠN
//    // Hướng dẫn tạo mật khẩu ứng dụng: https://support.google.com/accounts/answer/185833
//    // =================================================================================
//    private static final String FROM_EMAIL = "tuanhoangdz133@gmail.com"; // <-- THAY EMAIL GMAIL CỦA BẠN
//    private static final String PASSWORD = "ujfiwxboybitrdyl";      // <-- THAY MẬT KHẨU ỨNG DỤNG 16 KÝ TỰ
//    
//    public boolean sendPasswordResetEmail(String toEmail, String newPassword) {
//        System.out.println("--- [DEBUG] Bat dau qua trinh gui email ---");
//        System.out.println("[DEBUG] Nguoi gui: " + FROM_EMAIL);
//        System.out.println("[DEBUG] Nguoi nhan: " + toEmail);
//
//        Properties props = new Properties();
//        props.put("mail.smtp.host", "smtp.gmail.com");
//        props.put("mail.smtp.port", "587");
//        props.put("mail.smtp.auth", "true");
//        props.put("mail.smtp.starttls.enable", "true");
//        System.out.println("[DEBUG] Da cau hinh xong Properties SMTP.");
//
//        Session session = Session.getInstance(props, new Authenticator() {
//            @Override
//            protected PasswordAuthentication getPasswordAuthentication() {
//                return new PasswordAuthentication(FROM_EMAIL, PASSWORD);
//            }
//        });
//
//        try {
//            System.out.println("[DEBUG] Dang tao MimeMessage...");
//            MimeMessage message = new MimeMessage(session);
//            message.setFrom(new InternetAddress(FROM_EMAIL));
//            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
//            message.setSubject("Yeu cau cap lai mat khau tai Phu Kien Store", "UTF-8");
//
//            StringBuilder emailContent = new StringBuilder();
//            emailContent.append("<html><body>");
//            emailContent.append("<h3>Xin chao,</h3>");
//            emailContent.append("<p>Ban da yeu cau cap lai mat khau tai Phu Kien Store.</p>");
//            emailContent.append("<p>Mat khau moi cua ban la: <strong style='font-size: 18px; color: #d9534f;'>").append(newPassword).append("</strong></p>");
//            emailContent.append("<p>Vui long dang nhap bang mat khau nay va doi lai mat khau de dam bao an toan.</p>");
//            emailContent.append("<p>Tran trong,<br>Doi ngu Phu Kien Store</p>");
//            emailContent.append("</body></html>");
//
//            message.setContent(emailContent.toString(), "text/html; charset=UTF-8");
//            
//            System.out.println("[DEBUG] Dang chuan bi gui email...");
//            Transport.send(message);
//
//            System.out.println("--- [DEBUG] Email da duoc gui thanh cong! ---");
//            return true;
//        } catch (Exception e) {
//            System.err.println("--- [DEBUG] GAP LOI KHI GUI EMAIL ---");
//            e.printStackTrace();
//            return false;
//        }
//    }
//}
//
