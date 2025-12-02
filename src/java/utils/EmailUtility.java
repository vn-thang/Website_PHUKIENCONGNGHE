package utils;

import jakarta.mail.Authenticator;
import java.util.Date;
import java.util.Properties;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;


public class EmailUtility {

    private static final String FROM_EMAIL = "tuanhoangdz133@gmail.com";
    private static final String PASSWORD = "fuxtaieipvfczlav"; // App password 16 ký tự

    public static void sendEmail(String toEmail, String subject, String messageContent) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587"); // TLS
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
// [THÊM DÒNG NÀY ĐỂ XEM LOG CHI TIẾT]
        props.put("mail.debug", "true");
        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, PASSWORD);
            }
        });

        try {
            MimeMessage msg = new MimeMessage(session);
            msg.addHeader("Content-type", "text/HTML; charset=UTF-8");
            msg.setFrom(new InternetAddress(FROM_EMAIL, "Phu Kien Store Support"));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail, false));
            msg.setSubject(subject, "UTF-8");
            msg.setText(messageContent, "UTF-8");
            msg.setSentDate(new Date());
            
            Transport.send(msg);
            System.out.println("Gửi email thành công đến: " + toEmail);
        } catch (Exception e) {
           
            System.out.println("Lỗi gửi email!");
             e.printStackTrace();
        }
    }
}
