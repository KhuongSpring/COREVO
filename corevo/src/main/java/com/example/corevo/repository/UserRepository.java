package com.example.corevo.repository;

import com.example.corevo.domain.entity.User;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, String> {
    Optional<User> findUserDetailByUsername(String username);

    User findByUsername(String username);

    boolean existsUserByUsername(String emailOrUsername);

    boolean existsUserByEmail(String email);
}
