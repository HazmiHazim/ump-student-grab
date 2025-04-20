package com.webapi.ump_student_grab.DLL.Location;

import com.webapi.ump_student_grab.Model.Entity.Location;

import java.util.concurrent.CompletableFuture;

public interface ILocationRepository {
    CompletableFuture<Location> createUserLocation(Location location);
    CompletableFuture<Location> getUserLocationById(Long id);
    CompletableFuture<Void> updateUserLocation(Location location);
}
