package com.ump.studentgrab.application.exception;

public class TokenExpiredException extends RuntimeException {

    public TokenExpiredException(String message) {
        super(message);
    }
}
