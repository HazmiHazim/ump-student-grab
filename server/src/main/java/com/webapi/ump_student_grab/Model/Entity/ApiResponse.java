package com.webapi.ump_student_grab.Model.Entity;

public class ApiResponse<T> {
    private Integer status;
    private T data;
    private String message;

    public ApiResponse() {
    }

    public ApiResponse(Integer status, T data, String message) {
        this.status = status;
        this.data = data;
        this.message = message;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }
}

