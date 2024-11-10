package com.webapi.ump_student_grab.DLL.User;

import com.webapi.ump_student_grab.Model.User;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.transaction.Transactional;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.concurrent.CompletableFuture;

@Repository
public class UserRepository implements IUserRepository {

    @PersistenceContext
    private EntityManager entityManager;

    @Override
    @Async
    @Transactional
    public CompletableFuture<User> createUser(User user) {
        entityManager.persist(user);
        entityManager.flush();
        return CompletableFuture.completedFuture(user);
    }

    @Override
    @Async
    public CompletableFuture<User> getUserById(Long id) {
        User user = entityManager.find(User.class, id);
        return CompletableFuture.completedFuture(user);
    }

    @Override
    @Async
    public CompletableFuture<User> getUserByEmail(String email) {
        List<User> users = entityManager.createQuery("SELECT u FROM User u WHERE u.email = :email", User.class)
                .setParameter("email", email)
                .getResultList();

        return CompletableFuture.completedFuture(users.isEmpty() ? null : users.getFirst());
    }

    @Override
    @Async
    public CompletableFuture<List<User>> getAllUsers() {
        List<User> users = entityManager.createQuery("SELECT u FROM User u", User.class).getResultList();
        return CompletableFuture.completedFuture(users);
    }

    @Override
    @Async
    @Transactional
    public CompletableFuture<User> updateUser(User user) {
        User updatedUser = entityManager.merge(user);
        return CompletableFuture.completedFuture(updatedUser);
    }

    @Override
    @Async
    @Transactional
    public CompletableFuture<Void> deleteUser(Long id) {
        User user = entityManager.find(User.class, id);
        if (user != null) {
            entityManager.remove(user);
        }

        return CompletableFuture.completedFuture(null);
    }

}
