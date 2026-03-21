package com.ump.studentgrab.presentation.filter;

import com.ump.studentgrab.application.exception.UnauthorizedException;
import com.ump.studentgrab.application.service.ApiKeyService;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Slf4j
@Component
@RequiredArgsConstructor
public class ApiKeyFilter extends OncePerRequestFilter {

    private final ApiKeyService apiKeyService;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {

        String apiKey = request.getHeader("X-Api-Key");

        if (apiKey == null || apiKey.isBlank()) {
            log.warn("Request rejected — missing X-Api-Key: {} {}", request.getMethod(), request.getRequestURI());
            sendUnauthorized(response, "Missing X-Api-Key header");
            return;
        }

        try {
            apiKeyService.validateApiKey(apiKey);
        } catch (UnauthorizedException ex) {
            log.warn("Request rejected — invalid API key: {} {}", request.getMethod(), request.getRequestURI());
            sendUnauthorized(response, ex.getMessage());
            return;
        }

        filterChain.doFilter(request, response);
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        String uri = request.getRequestURI();
        return uri.startsWith("/api/keys") || uri.startsWith("/api/setup") || uri.startsWith("/ws");
    }

    private void sendUnauthorized(HttpServletResponse response, String message) throws IOException {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.setContentType("application/json");
        String safeMessage = message.replace("\\", "\\\\").replace("\"", "\\\"");
        response.getWriter().write(
                "{\"status\":401,\"message\":\"" + safeMessage + "\",\"data\":null}"
        );
    }
}
