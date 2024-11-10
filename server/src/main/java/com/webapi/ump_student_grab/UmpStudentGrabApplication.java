package com.webapi.ump_student_grab;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableAsync;

@SpringBootApplication
@EnableAsync
public class UmpStudentGrabApplication {

	public static void main(String[] args) {
		SpringApplication.run(UmpStudentGrabApplication.class, args);
	}

}
