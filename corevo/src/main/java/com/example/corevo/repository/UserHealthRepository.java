package com.example.corevo.repository;

import com.example.corevo.domain.entity.user.UserHealth;

import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserHealthRepository extends JpaRepository<UserHealth, UUID> {
}
