package com.webapi.ump_student_grab.DLL.Location;

import com.webapi.ump_student_grab.Model.Location;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Repository;

import java.util.concurrent.CompletableFuture;

@Repository
public class LocationRepository implements ILocationRepository {
    @PersistenceContext
    private EntityManager entityManager;

    @Override
    @Async
    @Transactional
    public CompletableFuture<Location> createUserLocation(Location location) {
        entityManager.persist(location);
        entityManager.flush();
        return CompletableFuture.completedFuture(location);
    }

    @Override
    @Async
    public CompletableFuture<Location> getUserLocationById(Long id) {
        Location location = entityManager.find(Location.class, id);
        return CompletableFuture.completedFuture(location);
    }

    @Override
    @Async
    @Transactional
    public CompletableFuture<Void> updateUserLocation(Location location) {
        entityManager.merge(location);
        return CompletableFuture.completedFuture(null);
    }
}
