package com.webapi.ump_student_grab.BLL.Location;

import com.webapi.ump_student_grab.DTO.LocationDTO.LocationCreateDTO;
import com.webapi.ump_student_grab.DTO.LocationDTO.LocationDTO;
import com.webapi.ump_student_grab.DTO.LocationDTO.LocationUpdateDTO;

import java.util.concurrent.CompletableFuture;

public interface ILocationServiceLogic {
    CompletableFuture<LocationDTO> createUserLocation(LocationCreateDTO locationCreateDTO);
    void updateUserLocation(LocationUpdateDTO locationUpdateDTO);
}
