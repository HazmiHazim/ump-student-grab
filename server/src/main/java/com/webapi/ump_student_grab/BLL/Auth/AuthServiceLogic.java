package com.webapi.ump_student_grab.BLL.Auth;

import com.webapi.ump_student_grab.BLL.ApiKey.IApiKeyServiceLogic;
import com.webapi.ump_student_grab.BLL.Token.ITokenServiceLogic;
import com.webapi.ump_student_grab.DLL.User.IUserRepository;
import com.webapi.ump_student_grab.DTO.UserDTO.*;
import com.webapi.ump_student_grab.Mapper.UserMapper;
import com.webapi.ump_student_grab.Model.Entity.User;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import org.springframework.core.io.FileSystemResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import java.io.File;
import java.time.LocalDateTime;
import java.util.List;
import java.util.concurrent.CompletableFuture;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
public class AuthServiceLogic implements IAuthServiceLogic {

    private final IUserRepository repo;
    private final UserMapper mapper;
    private final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder(16);
    private final JavaMailSender mailSender;
    private final ITokenServiceLogic tokenService;
    private final TemplateEngine templateEngine;
    private final IApiKeyServiceLogic apiService;

    public AuthServiceLogic(IUserRepository repo, UserMapper mapper, JavaMailSender mailSender,
                            ITokenServiceLogic tokenService, TemplateEngine templateEngine,
                            IApiKeyServiceLogic apiService) {
        this.repo = repo;
        this.mapper = mapper;
        this.mailSender = mailSender;
        this.tokenService = tokenService;
        this.templateEngine = templateEngine;
        this.apiService = apiService;
    }

    @Override
    public CompletableFuture<UserDTO> createUser(UserCreateDTO userCreateDTO, String apiKey) {
        return apiService.checkApiKey(apiKey).thenCompose(isValid -> {
            if (!isValid) {
                // Fail fast if API key is invalid
                return CompletableFuture.failedFuture(new SecurityException("Invalid API key"));
            }

            // Check if the request has email
            if (userCreateDTO.getEmail() == null || userCreateDTO.getEmail().isBlank()) {
                // Throw exception
                return CompletableFuture.failedFuture(new IllegalArgumentException("Email cannot be null or empty"));
            }

            // Pattern for email regex
            Pattern emailPattern = Pattern.compile("^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,6}$", Pattern.CASE_INSENSITIVE);
            Matcher emailMatcher = emailPattern.matcher(userCreateDTO.getEmail());

            if (!emailMatcher.matches()) {
                // Throw exception
                return CompletableFuture.failedFuture(new IllegalArgumentException("Invalid email format"));
            }

            // Check if email exists
            return repo.getUserByEmail(userCreateDTO.getEmail()).thenCompose(existingUser -> {
                if (existingUser != null) {
                    return CompletableFuture.completedFuture(null);
                }
                // Hash password
                String hashedPassword = encoder.encode(userCreateDTO.getPassword());
                userCreateDTO.setPassword(hashedPassword);

                // Map UserCreateDTO to User entity
                User user = mapper.userCreateDTOToUser(userCreateDTO);

                // Save user and map the created User entity to UserDTO
                return repo.createUser(user).thenApply(mapper::userToUserDTO);
            });
        });
    }

    @Override
    public CompletableFuture<UserDTO> getUserById(Long id) {
        // Get the data from repository and map User model to UserDTO
        return repo.getUserById(id).thenApply(mapper::userToUserDTO);
    }

    @Override
    public CompletableFuture<UserDTO> getUserById(Long id, String apiKey) {
        return apiService.checkApiKey(apiKey).thenCompose(isValid -> {
            if (!isValid) {
                // Fail fast if API key is invalid
                return CompletableFuture.failedFuture(new SecurityException("Invalid API key"));
            }

            // Get the data from repository and map User model to UserDTO
            return repo.getUserById(id).thenApply(mapper::userToUserDTO);
        });
    }

    @Override
    public CompletableFuture<UserDTO> getUserByEmail(String email, String apiKey) {
        return apiService.checkApiKey(apiKey).thenCompose(isValid -> {
            if (!isValid) {
                // Fail fast if API key is invalid
                return CompletableFuture.failedFuture(new SecurityException("Invalid API key"));
            }

            // Check if the request has email
            if (email == null || email.isBlank()) {
                // Throw exception
                return CompletableFuture.failedFuture(new IllegalArgumentException("Email cannot be null or empty"));
            }

            // Pattern for email regex
            Pattern emailPattern = Pattern.compile("^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,6}$", Pattern.CASE_INSENSITIVE);
            Matcher emailMatcher = emailPattern.matcher(email);

            if (!emailMatcher.matches()) {
                // Throw exception
                return CompletableFuture.failedFuture(new IllegalArgumentException("Invalid email format"));
            }

            return repo.getUserByEmail(email).thenApply(user -> {
                if (user == null) {
                    return null;
                }

                // Map the User model data to UserDTO
                return mapper.userToUserDTO(user);
            });
        });
    }

    @Override
    public CompletableFuture<List<UserDTO>> getAllUsers(String apiKey) {
        return apiService.checkApiKey(apiKey).thenCompose(isValid -> {
            if (!isValid) {
                // Fail fast if API key is invalid
                return CompletableFuture.failedFuture(new SecurityException("Invalid API key"));
            }

            return repo.getAllUsers().thenApply(mapper::userListToUserDTOList);
        });
    }

    @Override
    public CompletableFuture<UserDTO> updateUser(Long id, UserUpdateDTO userUpdateDTO, String apiKey) {
        return apiService.checkApiKey(apiKey).thenCompose(isValid -> {
            if (!isValid) {
                // Fail fast if API key is invalid
                return CompletableFuture.failedFuture(new SecurityException("Invalid API key"));
            }

            return repo.getUserById(id).thenCompose(existingUser -> {
                if (existingUser == null) {
                    return CompletableFuture.completedFuture(null);
                }

                if (userUpdateDTO.getEmail() != null) {
                    // Pattern for email regex
                    Pattern emailPattern = Pattern.compile("^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,6}$", Pattern.CASE_INSENSITIVE);
                    Matcher emailMatcher = emailPattern.matcher(userUpdateDTO.getEmail());

                    if (!userUpdateDTO.getEmail().isBlank() && emailMatcher.matches()) {
                        existingUser.setEmail(userUpdateDTO.getEmail());
                    } else {
                        // Throw exception
                        return CompletableFuture.failedFuture(new IllegalArgumentException("Invalid email format"));
                    }
                }
                if (userUpdateDTO.getFullName() != null) {
                    existingUser.setFullName(userUpdateDTO.getFullName());
                }
                if (userUpdateDTO.getGender() != null) {
                    existingUser.setGender(userUpdateDTO.getGender());
                }
                if (userUpdateDTO.getBirthDate() != null) {
                    existingUser.setBirthDate(userUpdateDTO.getBirthDate());
                }
                if (userUpdateDTO.getMatricNo() != null) {
                    existingUser.setMatricNo(userUpdateDTO.getMatricNo());
                }
                if (userUpdateDTO.getPhoneNo() != null) {
                    existingUser.setPhoneNo(userUpdateDTO.getPhoneNo());
                }
                if (userUpdateDTO.getRole() != null) {
                    existingUser.setRole(userUpdateDTO.getRole());
                }
                if (userUpdateDTO.getAttachmentId() != null) {
                    existingUser.setAttachmentId(userUpdateDTO.getAttachmentId());
                }

                // Save user and map the created User entity to UserDTO
                return repo.updateUser(existingUser).thenApply(mapper::userToUserDTO);
            });
        });
    }

    @Override
    public CompletableFuture<Boolean> deleteUser(Long id, String apiKey) {
        return apiService.checkApiKey(apiKey).thenCompose(isValid -> {
            if (!isValid) {
                // Fail fast if API key is invalid
                return CompletableFuture.failedFuture(new SecurityException("Invalid API key"));
            }

            return repo.getUserById(id).thenCompose(existingUser -> {
                if (existingUser == null) {
                    return CompletableFuture.completedFuture(false);
                }

                return repo.deleteUser(id).thenApply(v -> true);
            });
        });
    }

    @Override
    public CompletableFuture<UserDTO> loginUser(AuthDTO authDTO, String apiKey) {
        return apiService.checkApiKey(apiKey).thenCompose(isValid -> {
            if (!isValid) {
                // Fail fast if API key is invalid
                return CompletableFuture.failedFuture(new SecurityException("Invalid API key"));
            }

            // Check if the request has email
            if (authDTO.getEmail() == null || authDTO.getEmail().isBlank()) {
                // Throw exception
                return CompletableFuture.failedFuture(new IllegalArgumentException("Email cannot be null or empty"));
            }

            // Pattern for email regex
            Pattern emailPattern = Pattern.compile("^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,6}$", Pattern.CASE_INSENSITIVE);
            Matcher emailMatcher = emailPattern.matcher(authDTO.getEmail());

            if (!emailMatcher.matches()) {
                // Throw exception
                return CompletableFuture.failedFuture(new IllegalArgumentException("Invalid email format"));
            }

            return repo.getUserByEmail(authDTO.getEmail()).thenCompose(existingUser -> {
                if (existingUser == null || !encoder.matches(authDTO.getPassword(), existingUser.getPassword())) {
                    return CompletableFuture.completedFuture(null);
                }

                return tokenService.refreshToken(existingUser.getId()).thenCompose(newToken -> {
                    if (newToken == null) {
                        return CompletableFuture.completedFuture(null);
                    }

                    existingUser.setToken(newToken.getToken());
                    return repo.updateUser(existingUser).thenApply(mapper::userToUserDTO);
                });
            });
        });
    }

    @Override
    public CompletableFuture<Boolean> logoutUser(String token, String apiKey) {
        return apiService.checkApiKey(apiKey).thenCompose(isValid -> {
            if (!isValid) {
                // Fail fast if API key is invalid
                return CompletableFuture.failedFuture(new SecurityException("Invalid API key"));
            }

            return tokenService.expireToken(token).thenCompose(expiredToken -> {
                if (expiredToken == null) {
                    return CompletableFuture.completedFuture(false); // Token is invalid or expired
                }

                return repo.getUserById(expiredToken.getUserId()).thenCompose(existingUser -> {
                    if (existingUser == null) {
                        return CompletableFuture.completedFuture(false); // User not found
                    }

                    // Remove token from user
                    existingUser.setToken(null);
                    return repo.updateUser(existingUser).thenApply(updatedUser -> true);
                });
            });
        });
    }

    @Override
    public CompletableFuture<Integer> forgotPassword(ForgotPasswordDTO forgotPasswordDTO, String apiKey) {
        return apiService.checkApiKey(apiKey).thenCompose(isValid -> {
            if (!isValid) {
                // Fail fast if API key is invalid
                return CompletableFuture.failedFuture(new SecurityException("Invalid API key"));
            }

            // Check if the request has email
            if (forgotPasswordDTO.getEmail() == null || forgotPasswordDTO.getEmail().isBlank()) {
                // Throw exception
                return CompletableFuture.failedFuture(new IllegalArgumentException("Email cannot be null or empty"));
            }

            // Pattern for email regex
            Pattern emailPattern = Pattern.compile("^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,6}$", Pattern.CASE_INSENSITIVE);
            Matcher emailMatcher = emailPattern.matcher(forgotPasswordDTO.getEmail());

            if (!emailMatcher.matches()) {
                // Throw exception
                return CompletableFuture.failedFuture(new IllegalArgumentException("Invalid email format"));
            }

            return repo.getUserByEmail(forgotPasswordDTO.getEmail()).thenCompose(existingUser -> {
                if (existingUser == null) {
                    return CompletableFuture.completedFuture(1);
                }

                // Set the token expiration to 15 minutes from now
                LocalDateTime expiredAt = LocalDateTime.now().plusMinutes(15);

                // Create the token in the database
                return tokenService.createToken(existingUser.getId(), expiredAt).thenCompose(createdToken -> {
                    if (createdToken == null) {
                        return CompletableFuture.completedFuture(2);
                    }

                    // Create and send the email message
                    try {
                        MimeMessage mimeMessage = mailSender.createMimeMessage();
                        MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "utf-8");
                        helper.setFrom("studentgrab.service@umpsa.com.my");
                        helper.setTo(forgotPasswordDTO.getEmail());
                        helper.setSubject("Request for reset password");

                        Context thymeleafContext = new Context();
                        thymeleafContext.setVariable("token", createdToken.getToken());
                        // Load HTML template
                        String htmlContent = templateEngine.process("email/forgot-password", thymeleafContext);
                        helper.setText(htmlContent, true);

                        // ==========================================================
                        //  USE THIS PART ONLY IN DEV. IF IN PROD, COMMENT THIS PART
                        // ==========================================================
                        // Embed the image
                        FileSystemResource image1 = new FileSystemResource(new File("src/main/resources/static/images/logo-umpsa.png"));
                        FileSystemResource image2 = new FileSystemResource(new File("src/main/resources/static/images/e-hailing-illustration.png"));
                        helper.addInline("umpsaLogo", image1); // Pass the cid in the html template
                        helper.addInline("illustration", image2); // Pass the cid in the html template
                        // ==========================================================

                        mailSender.send(mimeMessage);

                        return CompletableFuture.completedFuture(0);
                    } catch (MessagingException ex) {
                        return CompletableFuture.completedFuture(3);
                    }
                });
            });
        });
    }

    @Override
    public CompletableFuture<Integer> resetPassword(UserResetPassDTO userResetPassDTO, String apiKey) {
        return apiService.checkApiKey(apiKey).thenCompose(isValid -> {
            if (!isValid) {
                // Fail fast if API key is invalid
                return CompletableFuture.failedFuture(new SecurityException("Invalid API key"));
            }

            return tokenService.getTokenByToken(userResetPassDTO.getToken()).thenCompose(token -> {
                if (token == null || token.getExpiredAt().isBefore(LocalDateTime.now())) {
                    return CompletableFuture.completedFuture(1); // Token is invalid or expired
                }

                return repo.getUserById(token.getUserId()).thenCompose(user -> {
                    if (user == null) {
                        return CompletableFuture.completedFuture(2); // User not found
                    }

                    if (!userResetPassDTO.getNewPassword().equals(userResetPassDTO.getConfirmPassword())) {
                        return CompletableFuture.completedFuture(3); // new pass and confirm pass not match
                    }

                    // Hashed password
                    String hashedPassword = encoder.encode(userResetPassDTO.getNewPassword());
                    user.setPassword(hashedPassword); // Update new password

                    return repo.updateUser(user).thenCompose(savedPassword -> {
                        // Expire the token after password reset
                        return tokenService.expireToken(token.getToken()).thenApply(v -> 0);
                    });
                });
            });
        });
    }

    @Override
    public CompletableFuture<Boolean> verifyEmail(VerifyUserDTO verifyUserDTO, String apiKey) {
        return apiService.checkApiKey(apiKey).thenCompose(isValid -> {
            if (!isValid) {
                // Fail fast if API key is invalid
                return CompletableFuture.failedFuture(new SecurityException("Invalid API key"));
            }

            // Check if the request has email
            if (verifyUserDTO.getEmail() == null || verifyUserDTO.getEmail().isBlank()) {
                // Throw exception
                return CompletableFuture.failedFuture(new IllegalArgumentException("Email cannot be null or empty"));
            }

            // Pattern for email regex
            Pattern emailPattern = Pattern.compile("^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,6}$", Pattern.CASE_INSENSITIVE);
            Matcher emailMatcher = emailPattern.matcher(verifyUserDTO.getEmail());

            if (!emailMatcher.matches()) {
                // Throw exception
                return CompletableFuture.failedFuture(new IllegalArgumentException("Invalid email format"));
            }

            return repo.getUserByEmail(verifyUserDTO.getEmail()).thenCompose(existingUser -> {
                if (existingUser == null) {
                    return CompletableFuture.completedFuture(false);
                }

                // Set the token expiration to 5 minutes from now
                LocalDateTime expiredAt = LocalDateTime.now().plusMinutes(5);

                // Create the token in the database
                return tokenService.createToken(existingUser.getId(), expiredAt).thenCompose(createdToken -> {

                    // Create and send the email message
                    try {
                        MimeMessage mimeMessage = mailSender.createMimeMessage();
                        MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "utf-8");
                        helper.setFrom("studentgrab.service@umpsa.com.my");
                        helper.setTo(verifyUserDTO.getEmail());
                        helper.setSubject("Account Verification");

                        Context thymeleafContext = new Context();
                        thymeleafContext.setVariable("token", createdToken.getToken());
                        // Load HTML template
                        String htmlContent = templateEngine.process("email/account-verification", thymeleafContext);
                        helper.setText(htmlContent, true);

                        // ==========================================================
                        //  USE THIS PART ONLY IN DEV. IF IN PROD, COMMENT THIS PART
                        // ==========================================================
                        // Embed the image
                        FileSystemResource image1 = new FileSystemResource(new File("src/main/resources/static/images/logo-umpsa.png"));
                        helper.addInline("umpsaLogo", image1); // Pass the cid in the html template
                        // ==========================================================

                        mailSender.send(mimeMessage);

                        return CompletableFuture.completedFuture(true);
                    } catch (MessagingException ex) {
                        return CompletableFuture.completedFuture(false);
                    }
                });
            });
        });
    }

    @Override
    public CompletableFuture<Boolean> verifyUser(String token, String apiKey) {
        return apiService.checkApiKey(apiKey).thenCompose(isValid -> {
            if (!isValid) {
                // Fail fast if API key is invalid
                return CompletableFuture.failedFuture(new SecurityException("Invalid API key"));
            }

            return tokenService.getTokenByToken(token).thenCompose(existingToken -> {
                if (existingToken == null || existingToken.getExpiredAt().isBefore(LocalDateTime.now())) {
                    return CompletableFuture.completedFuture(false); // Token is invalid or expired
                }

                return repo.getUserById(existingToken.getUserId()).thenCompose(user -> {
                    user.setIsVerified(true); // Mark user as verified
                    return repo.updateUser(user).thenCompose(userVerified -> {
                        // Expire the token after user successful verified
                        return tokenService.expireToken(existingToken.getToken()).thenApply(v -> true);
                    });
                });
            });
        });
    }
}
