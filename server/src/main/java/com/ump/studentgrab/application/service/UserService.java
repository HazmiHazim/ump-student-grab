package com.ump.studentgrab.application.service;

import com.ump.studentgrab.application.dto.request.UpdateUserRequest;
import com.ump.studentgrab.application.dto.response.UserResponse;
import com.ump.studentgrab.application.exception.ResourceNotFoundException;
import com.ump.studentgrab.application.mapper.UserMapper;
import com.ump.studentgrab.domain.model.User;
import com.ump.studentgrab.domain.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.regex.Pattern;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserService {

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile("^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,6}$", Pattern.CASE_INSENSITIVE);

    private final UserRepository userRepository;
    private final UserMapper userMapper;

    public List<UserResponse> getAllUsers() {
        return userMapper.toResponseList(userRepository.findAll());
    }

    public UserResponse getUserById(Long id) {
        return userMapper.toResponse(findById(id));
    }

    public UserResponse getUserByEmail(String email) {
        validateEmailFormat(email);
        return userMapper.toResponse(findByEmail(email));
    }

    @Transactional
    public UserResponse updateUser(Long id, UpdateUserRequest request) {
        log.info("Updating user: id={}", id);
        User user = findById(id);
        applyUpdates(user, request);
        UserResponse response = userMapper.toResponse(userRepository.save(user));
        log.info("User updated: id={}", id);
        return response;
    }

    @Transactional
    public void deleteUser(Long id) {
        log.info("Deleting user: id={}", id);
        User user = findById(id);
        userRepository.delete(user);
        log.info("User deleted: id={}", id);
    }

    // Internal — returns entity for use within the application layer
    public User findById(Long id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + id));
    }

    // Internal — returns entity for use within the application layer
    public User findByEmail(String email) {
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with email: " + email));
    }

    public void validateEmailFormat(String email) {
        if (email == null || email.isBlank()) {
            throw new IllegalArgumentException("Email cannot be blank");
        }
        if (!EMAIL_PATTERN.matcher(email).matches()) {
            throw new IllegalArgumentException("Invalid email format: " + email);
        }
    }

    private void applyUpdates(User user, UpdateUserRequest request) {
        if (request.email() != null) {
            validateEmailFormat(request.email());
            user.setEmail(request.email());
        }
        if (request.fullName() != null) user.setFullName(request.fullName());
        if (request.gender() != null) user.setGender(request.gender());
        if (request.birthDate() != null) user.setBirthDate(request.birthDate());
        if (request.matricNo() != null) user.setMatricNo(request.matricNo());
        if (request.phoneNo() != null) user.setPhoneNo(request.phoneNo());
        if (request.role() != null) user.setRole(request.role());
        if (request.attachmentId() != null) user.setAttachmentId(request.attachmentId());
    }
}
