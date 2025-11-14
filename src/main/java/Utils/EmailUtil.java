/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Utils;

import java.util.Properties;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class EmailUtil {

    
    private static final String FROM_EMAIL = "gioshop.system@gmail.com";
    private static final String APP_PASSWORD = "eljfdrdvdvvvouwm";

    public static void sendEmail(String toEmail, String subject, String content) throws MessagingException {
        
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587"); 
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
        
        
        props.put("mail.smtp.ssl.protocols", "TLSv1.2");
        
        props.put("mail.debug", "true");

        Session mailSession = Session.getInstance(props, new jakarta.mail.Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });

        // Tạo message
        MimeMessage message = new MimeMessage(mailSession);
        message.setFrom(new InternetAddress(FROM_EMAIL));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject(subject, "UTF-8"); // Thêm UTF-8 cho tiêu đề
        message.setText(content, "UTF-8"); // Thêm UTF-8 cho nội dung

        // Gửi mail
        // Transport.send sẽ tự connect, gửi và close
        Transport.send(message);
        
        System.out.println("Email sent successfully to " + toEmail);
    }
}