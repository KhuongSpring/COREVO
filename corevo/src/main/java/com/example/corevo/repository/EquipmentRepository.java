package com.example.corevo.repository;

import com.example.corevo.domain.entity.training.Equipment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface EquipmentRepository extends JpaRepository<Equipment, Long> {
    boolean existsByEquipmentName(String equipmentName);
}
