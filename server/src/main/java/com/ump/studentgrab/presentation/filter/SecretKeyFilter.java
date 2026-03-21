package com.ump.studentgrab.presentation.filter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Component
public class SecretKeyFilter extends OncePerRequestFilter {

    @Value("${app.secret-key}")
    private String appSecretKey;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {

        String secretKey = request.getHeader("X-Secret-Key");

        if (secretKey == null || secretKey.isBlank()) {
            sendUnauthorized(response, "Missing X-Secret-Key header");
            return;
        }

        if (!appSecretKey.equals(secretKey)) {
            sendUnauthorized(response, "Invalid secret key");
            return;
        }

        filterChain.doFilter(request, response);
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        return !request.getRequestURI().startsWith("/api/keys");
    }

    private void sendUnauthorized(HttpServletResponse response, String message) throws IOException {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.setContentType("application/json");
        response.getWriter().write(
                "{\"status\":401,\"message\":\"" + message + "\",\"data\":null}"
        );
    }
}
