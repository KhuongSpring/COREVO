package com.example.corevo.repository;

import com.example.corevo.domain.entity.Address;
import com.example.corevo.domain.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, String> {
    Optional<User> findUserDetailByUsername(String username);

    User findByUsername(String username);

    boolean existsUserByUsername(String emailOrUsername);

    boolean existsUserByEmail(String email);

    User findByEmail(String email);

    boolean existsUsersByPhone(String phone);

    boolean existsByAddress(Address address);

}
