package com.example.corevo.repository;

import com.example.corevo.domain.entity.training.Location;
import org.springframework.data.jpa.repository.JpaRepository;

public interface LocationRepository extends JpaRepository<Location, Long> {
}
