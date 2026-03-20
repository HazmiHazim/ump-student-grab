package com.ump.studentgrab.application.port;

public interface EmailService {

    void sendPasswordResetEmail(String to, String resetToken);

    void sendVerificationEmail(String to, String verificationToken);
}
