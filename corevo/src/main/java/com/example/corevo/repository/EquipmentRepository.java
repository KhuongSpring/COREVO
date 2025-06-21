package com.example.corevo.repository;

import com.example.corevo.domain.entity.training.Equipment;
import org.springframework.data.jpa.repository.JpaRepository;

public interface EquipmentRepository extends JpaRepository<Equipment, Long> {
}
