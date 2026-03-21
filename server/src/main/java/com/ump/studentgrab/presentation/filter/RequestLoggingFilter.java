package com.ump.studentgrab.presentation.filter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

@Slf4j
@Component
@Order(1)
public class RequestLoggingFilter extends OncePerRequestFilter {

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {

        long startTime = System.currentTimeMillis();

        filterChain.doFilter(request, response);

        long duration = System.currentTimeMillis() - startTime;
        int status = response.getStatus();
        String method = request.getMethod();
        String uri = request.getRequestURI();
        String query = request.getQueryString();
        String fullUri = query != null ? uri + "?" + query : uri;

        if (status >= 500) {
            log.error("[{}] {} {} — {}ms", status, method, fullUri, duration);
        } else if (status >= 400) {
            log.warn("[{}] {} {} — {}ms", status, method, fullUri, duration);
        } else if (status >= 300) {
            log.info("[{}] {} {} — {}ms", status, method, fullUri, duration);
        } else {
            log.debug("[{}] {} {} — {}ms", status, method, fullUri, duration);
        }
    }
}
