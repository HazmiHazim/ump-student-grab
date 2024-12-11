package com.webapi.ump_student_grab.Controller;

import com.webapi.ump_student_grab.BLL.Location.ILocationServiceLogic;
import com.webapi.ump_student_grab.DTO.LocationDTO.LocationCreateDTO;
import com.webapi.ump_student_grab.DTO.LocationDTO.LocationDTO;
import com.webapi.ump_student_grab.DTO.LocationDTO.LocationUpdateDTO;
import com.webapi.ump_student_grab.Model.ApiResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.scheduling.annotation.Async;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.concurrent.CompletableFuture;

@RestController
@RequestMapping("/api/locations")
public class LocationController {

    private final ILocationServiceLogic _service;

    public LocationController(ILocationServiceLogic service) {
        this._service = service;
    }

    @PostMapping("/createLocation")
    @Async
    public CompletableFuture<ResponseEntity<ApiResponse<LocationDTO>>> createUserLocation(@RequestBody LocationCreateDTO locationCreateDTO) {
        return _service.createUserLocation(locationCreateDTO).thenApply(createdLocation -> {
            ApiResponse<LocationDTO> response;
            HttpStatus status;
            String message;

            if (createdLocation == null) {
                status = HttpStatus.NOT_FOUND;
                message = "Failed to retrieved location.";
                response = new ApiResponse<>(status.value(), null, message);
            } else {
                status = HttpStatus.CREATED;
                message = "Location retrieved successfully.";
                response = new ApiResponse<>(status.value(), createdLocation, message);
            }

            return new ResponseEntity<>(response, status);
        });
    }


    @MessageMapping("/location")
    @SendTo("/topic/location")
    public LocationUpdateDTO updateUserLocationSocket(@Payload LocationUpdateDTO locationUpdateDTO) {
        // Save the location to the database asynchronously
        CompletableFuture.runAsync(() -> {
            _service.updateUserLocation(locationUpdateDTO); // Save location in the background
        });

        return locationUpdateDTO; // Return the input DTO to be broadcasted to clients
    }
}
