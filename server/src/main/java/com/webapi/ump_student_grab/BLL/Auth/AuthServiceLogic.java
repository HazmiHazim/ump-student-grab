package com.webapi.ump_student_grab.BLL.Auth;

import com.webapi.ump_student_grab.DLL.Token.ITokenRepository;
import com.webapi.ump_student_grab.DLL.User.IUserRepository;
import com.webapi.ump_student_grab.DTO.UserDTO.*;
import com.webapi.ump_student_grab.Mapper.TokenMapper;
import com.webapi.ump_student_grab.Mapper.UserMapper;
import com.webapi.ump_student_grab.Model.Token;
import com.webapi.ump_student_grab.Model.User;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.CompletableFuture;

@Service
public class AuthServiceLogic implements IAuthServiceLogic {

    private final IUserRepository _repo;
    private final UserMapper _mapper;
    private final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder(16);
    private final JavaMailSender _mailSender;
    private final ITokenRepository _tRepo;

    public AuthServiceLogic(IUserRepository repo, UserMapper mapper, JavaMailSender mailSender, ITokenRepository tRepo, TokenMapper tMapper) {
        this._repo = repo;
        this._mapper = mapper;
        this._mailSender = mailSender;
        this._tRepo = tRepo;
    }

    @Override
    public CompletableFuture<UserDTO> createUser(UserCreateDTO userCreateDTO) {
        // Check if email exists
        return _repo.getUserByEmail(userCreateDTO.getEmail()).thenCompose(existingUser -> {
            if (existingUser != null) {
                return CompletableFuture.completedFuture(null);
            }
            // Hash password
            String hashedPassword = encoder.encode(userCreateDTO.getPassword());
            userCreateDTO.setPassword(hashedPassword);

            // Map UserCreateDTO to User entity
            User user = _mapper.userCreateDTOToUser(userCreateDTO);

            // Save user and map the created User entity to UserDTO
            return _repo.createUser(user).thenApply(_mapper::userToUserDTO);
        });
    }

    @Override
    public CompletableFuture<UserDTO> getUserById(Long id) {
        // Get the data from repository and map User model to UserDTO
        return _repo.getUserById(id).thenApply(_mapper::userToUserDTO);
    }

    @Override
    public CompletableFuture<UserDTO> getUserByEmail(String email) {
        return _repo.getUserByEmail(email).thenApply(user -> {
            if (user == null) {
                return null;
            }

            // Map the User model data to UserDTO
            return _mapper.userToUserDTO(user);
        });
    }

    @Override
    public CompletableFuture<List<UserDTO>> getAllUsers() {
        return _repo.getAllUsers().thenApply(_mapper::userListToUserDTOList);
    }

    @Override
    public CompletableFuture<UserDTO> updateUser(Long id, UserUpdateDTO userUpdateDTO) {
        return _repo.getUserById(id).thenCompose(existingUser -> {
            if (existingUser == null) {
                return CompletableFuture.completedFuture(null);
            }

            if (userUpdateDTO.getEmail() != null) {
                existingUser.setEmail(userUpdateDTO.getEmail());
            }
            if (userUpdateDTO.getFullName() != null) {
                existingUser.setFullName(userUpdateDTO.getFullName());
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
            return _repo.updateUser(existingUser).thenApply(_mapper::userToUserDTO);
        });
    }

    @Override
    public CompletableFuture<Boolean> deleteUser(Long id) {
        return _repo.getUserById(id).thenCompose(existingUser -> {
            if (existingUser == null) {
                return CompletableFuture.completedFuture(false);
            }

            return _repo.deleteUser(id).thenApply(v -> true);
        });
    }

    @Override
    public CompletableFuture<UserDTO> loginUser(AuthDTO authDTO) {
        return _repo.getUserByEmail(authDTO.getEmail()).thenCompose(existingUser -> {
            if (existingUser == null || !encoder.matches(authDTO.getPassword(), existingUser.getPassword())) {
                return CompletableFuture.completedFuture(null);
            }

            // Generate a unique token (using UUID)
            String generatedToken = UUID.randomUUID().toString().replace("-", "");
            // Set the token expiration to 15 minutes from now
            LocalDateTime createdAt = LocalDateTime.now();
            LocalDateTime modifiedAt = LocalDateTime.now();

            Token token = new Token(null, generatedToken, existingUser.getId(), null, createdAt, modifiedAt);

            return _tRepo.createToken(token).thenCompose(createdToken -> {
                if (createdToken == null) {
                    return CompletableFuture.completedFuture(null);
                }

                existingUser.setToken(generatedToken);

                return _repo.updateUser(existingUser).thenCompose(updatedUser -> CompletableFuture.completedFuture(_mapper.userToUserDTO(existingUser)));
            });
        });
    }

    @Override
    public CompletableFuture<Boolean> logoutUser(String token) {
        return _tRepo.getTokenByToken(token).thenCompose(existingToken -> {
            if (existingToken == null) {
                return CompletableFuture.completedFuture(false); // Token is invalid or expired
            }

            // Update expired at
            existingToken.setExpiredAt(LocalDateTime.now());
            existingToken.setModifiedAt(LocalDateTime.now());

            return _tRepo.updateToken(existingToken).thenApply(v -> true);
        });
    }

    @Override
    public CompletableFuture<Integer> forgotPassword(String email) {
        return _repo.getUserByEmail(email).thenCompose(existingUser -> {
            if (existingUser == null) {
                return CompletableFuture.completedFuture(1);
            }

            // Generate a unique token (using UUID)
            String generatedToken = UUID.randomUUID().toString().replace("-", "");

            // Set the token expiration to 15 minutes from now
            LocalDateTime expiredAt = LocalDateTime.now().plusMinutes(15);
            LocalDateTime createdAt = LocalDateTime.now();
            LocalDateTime modifiedAt = LocalDateTime.now();

            Token token = new Token(null, generatedToken, existingUser.getId(), expiredAt, createdAt, modifiedAt);

            // Create the token in the database
            return _tRepo.createToken(token).thenCompose(createdToken -> {
                if (createdToken == null) {
                    return CompletableFuture.completedFuture(2);
                }

                // Create and send the email message
                SimpleMailMessage message = new SimpleMailMessage();
                message.setFrom("umpsa.studentgrab@service.com");
                message.setTo(email);
                message.setSubject("Request for reset password");
                message.setText("Please click the link to reset your password: \n"
                        + "http://127.0.0.1/resetPasswrodPage/" + generatedToken);

                _mailSender.send(message);
                return CompletableFuture.completedFuture(0);
            });
        });
    }

    @Override
    public CompletableFuture<Integer> resetPassword(UserResetPassDTO userResetPassDTO) {
        return _tRepo.getTokenByToken(userResetPassDTO.getToken()).thenCompose(token -> {
            if (token == null || token.getExpiredAt().isBefore(LocalDateTime.now())) {
                return CompletableFuture.completedFuture(1); // Token is invalid or expired
            }

            return _repo.getUserById(token.getUserId()).thenCompose(user -> {
                if (user == null) {
                    return CompletableFuture.completedFuture(2); // User not found
                }

                if (!userResetPassDTO.getNewPassword().equals(userResetPassDTO.getConfirmPassword())) {
                    return CompletableFuture.completedFuture(3); // new pass and confirm pass not match
                }

                // Hashed password
                String hashedPassword = encoder.encode(userResetPassDTO.getNewPassword());
                user.setPassword(hashedPassword); // Update new password

                return _repo.updateUser(user).thenCompose(savedPassword -> {
                    // Expire the token after password reset
                    token.setExpiredAt(LocalDateTime.now());
                    return _tRepo.updateToken(token).thenApply(v -> 0);
                });
            });
        });
    }

    @Override
    public CompletableFuture<Boolean> verifyEmail(String email) {
        return _repo.getUserByEmail(email).thenCompose(existingUser -> {
            if (existingUser == null) {
                return CompletableFuture.completedFuture(false);
            }

            // Generate a unique token (using UUID)
            String generatedToken = UUID.randomUUID().toString().replace("-", "");

            // Set the token expiration to 2 days from now
            LocalDateTime expiredAt = LocalDateTime.now().plusMinutes(5);
            LocalDateTime createdAt = LocalDateTime.now();
            LocalDateTime modifiedAt = LocalDateTime.now();

            Token token = new Token(null, generatedToken, existingUser.getId(), expiredAt, createdAt, modifiedAt);

            // Create the token in the database
            return _tRepo.createToken(token).thenCompose(createdToken -> {
                // Create and send the email message
                SimpleMailMessage message = new SimpleMailMessage();
                message.setFrom("umpsa.studentgrab@service.com");
                message.setTo(email);
                message.setSubject("Account Verification");
                message.setText("Please click the link to verify your account: \n"
                        + "http://127.0.0.1/api/users/verifyUser/" + generatedToken);

                _mailSender.send(message);
                return CompletableFuture.completedFuture(true);
            });
        });
    }

    @Override
    public CompletableFuture<Boolean> verifyUser(String token) {
        return _tRepo.getTokenByToken(token).thenCompose(existingToken -> {
            if (existingToken == null || existingToken.getExpiredAt().isBefore(LocalDateTime.now())) {
                return CompletableFuture.completedFuture(false); // Token is invalid or expired
            }

            return _repo.getUserById(existingToken.getUserId()).thenCompose(user -> {
                user.setIsVerified(true); // Mark user as verified
                return _repo.updateUser(user).thenCompose(userVerified -> {
                    // Expire the token after user successful verified
                    existingToken.setExpiredAt(LocalDateTime.now());
                    return _tRepo.updateToken(existingToken).thenApply(v -> true);
                });
            });
        });
    }
}
