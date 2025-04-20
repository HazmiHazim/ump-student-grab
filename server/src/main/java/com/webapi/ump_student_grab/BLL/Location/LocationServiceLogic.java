package com.webapi.ump_student_grab.BLL.Location;

import com.webapi.ump_student_grab.DLL.Location.ILocationRepository;
import com.webapi.ump_student_grab.DLL.User.IUserRepository;
import com.webapi.ump_student_grab.DTO.LocationDTO.LocationCreateDTO;
import com.webapi.ump_student_grab.DTO.LocationDTO.LocationDTO;
import com.webapi.ump_student_grab.DTO.LocationDTO.LocationUpdateDTO;
import com.webapi.ump_student_grab.Mapper.LocationMapper;
import com.webapi.ump_student_grab.Model.Entity.Location;
import jakarta.transaction.Transactional;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.concurrent.CompletableFuture;

@Service
public class LocationServiceLogic implements ILocationServiceLogic{

    private ILocationRepository _repo;
    private IUserRepository _uRepo;
    private LocationMapper _mapper;

    public LocationServiceLogic(ILocationRepository repo, IUserRepository uRepo, LocationMapper mapper) {
        this._repo = repo;
        this._uRepo = uRepo;
        this._mapper = mapper;
    }

    @Override
    public CompletableFuture<LocationDTO> createUserLocation(LocationCreateDTO locationCreateDTO) {
        // Check if email exists
        return _uRepo.getUserById(locationCreateDTO.getUserId()).thenCompose(existingUser -> {
            if (existingUser != null) {
                return _repo.getUserLocationById(locationCreateDTO.getUserId()).thenCompose(existingLocation -> {
                    if (existingLocation == null) {
                        return CompletableFuture.completedFuture(null);
                    }

                    // Map the return data to LocationDTO
                    return CompletableFuture.completedFuture(_mapper.locationToLocationDTO(existingLocation));
                });
            }

            Location location = _mapper.locationCreateDTOToLocation(locationCreateDTO);

            return _repo.createUserLocation(location).thenApply(_mapper::locationToLocationDTO);
        });
    }

    @Override
    @Async
    @Transactional
    public void updateUserLocation(LocationUpdateDTO locationUpdateDTO) {
        _repo.updateUserLocation(_mapper.locationUpdateDTOToLocation(locationUpdateDTO));
        CompletableFuture.completedFuture(null);
    }
}
