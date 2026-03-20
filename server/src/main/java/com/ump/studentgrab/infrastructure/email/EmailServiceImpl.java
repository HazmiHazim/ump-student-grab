package com.ump.studentgrab.infrastructure.email;

import com.ump.studentgrab.application.port.EmailService;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.ClassPathResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;

import java.util.Map;

@Service
@RequiredArgsConstructor
public class EmailServiceImpl implements EmailService {

    private static final String FROM_ADDRESS = "studentgrab.service@umpsa.com.my";

    private final JavaMailSender mailSender;
    private final TemplateEngine templateEngine;

    @Async
    @Override
    public void sendPasswordResetEmail(String to, String resetToken) {
        sendEmail(
                to,
                "Request for reset password",
                "email/forgot-password",
                resetToken,
                Map.of(
                        "umpsaLogo", "static/images/logo-umpsa.png",
                        "illustration", "static/images/e-hailing-illustration.png"
                )
        );
    }

    @Async
    @Override
    public void sendVerificationEmail(String to, String verificationToken) {
        sendEmail(
                to,
                "Account Verification",
                "email/account-verification",
                verificationToken,
                Map.of("umpsaLogo", "static/images/logo-umpsa.png")
        );
    }

    private void sendEmail(String to, String subject, String template, String token, Map<String, String> inlineImages) {
        try {
            MimeMessage mimeMessage = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "utf-8");

            helper.setFrom(FROM_ADDRESS);
            helper.setTo(to);
            helper.setSubject(subject);

            Context context = new Context();
            context.setVariable("token", token);
            helper.setText(templateEngine.process(template, context), true);

            for (Map.Entry<String, String> image : inlineImages.entrySet()) {
                helper.addInline(image.getKey(), new ClassPathResource(image.getValue()));
            }

            mailSender.send(mimeMessage);
        } catch (MessagingException e) {
            throw new RuntimeException("Failed to send email to " + to, e);
        }
    }
}
