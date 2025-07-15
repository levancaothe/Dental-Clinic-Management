package utils;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

public class EmailUtil {
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String EMAIL = "thelvche187139@fpt.edu.vn";
    private static final String APP_PASSWORD = "rpdconklwwogtwgo"; 
    private static final Logger logger = Logger.getLogger(EmailUtil.class.getName());
    
    public static boolean sendOTPEmail(String toEmail, String otp) {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            props.put("mail.smtp.ssl.trust", SMTP_HOST);
            props.put("mail.debug", "false");
            
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(EMAIL, APP_PASSWORD);
                }
            });
            
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL, "SWP System"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Password Reset OTP - SWP System");
            
            String emailContent = createEmailContent(otp);
            message.setContent(emailContent, "text/html; charset=utf-8");
            
            Transport.send(message);
            logger.info("OTP email sent successfully to: " + toEmail);
            return true;
            
        } catch (MessagingException e) {
            logger.log(Level.SEVERE, "Failed to send OTP email to: " + toEmail, e);
            return false;
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Unexpected error while sending email: " + e.getMessage(), e);
            return false;
        }
    }
    
    private static String createEmailContent(String otp) {
        return "<!DOCTYPE html>" +
                "<html>" +
                "<head>" +
                "<style>" +
                "body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }" +
                ".container { max-width: 600px; margin: 0 auto; padding: 20px; }" +
                ".header { background-color: #007bff; color: white; padding: 20px; text-align: center; }" +
                ".content { padding: 20px; background-color: #f8f9fa; }" +
                ".otp-code { font-size: 24px; font-weight: bold; color: #007bff; text-align: center; " +
                "padding: 15px; background-color: white; border: 2px dashed #007bff; margin: 20px 0; }" +
                ".footer { padding: 20px; text-align: center; color: #666; font-size: 12px; }" +
                "</style>" +
                "</head>" +
                "<body>" +
                "<div class='container'>" +
                "<div class='header'>" +
                "<h1>Password Reset Request</h1>" +
                "</div>" +
                "<div class='content'>" +
                "<p>Dear User,</p>" +
                "<p>You have requested to reset your password. Please use the following OTP to proceed:</p>" +
                "<div class='otp-code'>" + otp + "</div>" +
                "<p><strong>Important:</strong></p>" +
                "<ul>" +
                "<li>This OTP will expire in <strong>5 minutes</strong></li>" +
                "<li>Do not share this code with anyone</li>" +
                "<li>If you did not request this password reset, please ignore this email</li>" +
                "</ul>" +
                "</div>" +
                "<div class='footer'>" +
                "<p>Best regards,<br>SWP System Team</p>" +
                "</div>" +
                "</div>" +
                "</body>" +
                "</html>";
    }
}
