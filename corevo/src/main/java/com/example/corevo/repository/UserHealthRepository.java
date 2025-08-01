package com.example.corevo.repository;

import com.example.corevo.domain.entity.user.UserHealth;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserHealthRepository extends JpaRepository<UserHealth, String> {
}
