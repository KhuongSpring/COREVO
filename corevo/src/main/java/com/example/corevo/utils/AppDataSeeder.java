package com.example.corevo.utils;

import com.example.corevo.domain.dto.response.TrainingPlanResponseDto;
import com.example.corevo.domain.entity.training.Equipment;
import com.example.corevo.domain.entity.training.Level;
import com.example.corevo.domain.entity.training.Location;
import com.example.corevo.domain.entity.training.TrainingPlan;
import com.example.corevo.repository.EquipmentRepository;
import com.example.corevo.repository.LevelRepository;
import com.example.corevo.repository.LocationRepository;
import com.example.corevo.repository.TrainingPlanRepository;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

@Component
@RequiredArgsConstructor
@Slf4j
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class AppDataSeeder implements ApplicationRunner {

    ObjectMapper objectMapper;

    LevelRepository levelRepository;
    LocationRepository locationRepository;
    EquipmentRepository equipmentRepository;
    TrainingPlanRepository trainingPlanRepository;

    @Override
    public void run(ApplicationArguments args) throws Exception {
        seedLevels();
        seedLocations();
        seedEquipments();
        seedTrainingPlans();
    }

    void seedLevels() throws IOException {
        if (levelRepository.count() == 0) {
            log.info("Seeding levels from JSON...");
            try (InputStream is = getClass().getResourceAsStream("/data/level.json")) {
                List<Level> levels = objectMapper.readValue(is, new TypeReference<>() {});
                levelRepository.saveAll(levels);
            }
        }
    }

    void seedLocations() throws IOException {
        if (locationRepository.count() == 0) {
            log.info("Seeding locations from JSON...");
            try (InputStream is = getClass().getResourceAsStream("/data/location.json")) {
                List<Location> locations = objectMapper.readValue(is, new TypeReference<>() {});
                locationRepository.saveAll(locations);
            }
        }
    }

    void seedEquipments() throws IOException {
        if (equipmentRepository.count() == 0) {
            log.info("Seeding equipment from JSON...");
            try (InputStream is = getClass().getResourceAsStream("/data/equipment.json")) {
                List<Equipment> equipments = objectMapper.readValue(is, new TypeReference<>() {});
                equipmentRepository.saveAll(equipments);
            }
        }
    }

    void seedTrainingPlans() throws IOException {
        if (trainingPlanRepository.count() == 0) {
            log.info("Seeding training plans...");
            try (InputStream is = getClass().getResourceAsStream("/data/training_plan.json")) {
                List<TrainingPlanResponseDto> dtos = objectMapper.readValue(is, new TypeReference<>() {
                });
                for (TrainingPlanResponseDto dto : dtos) {
                    TrainingPlan plan = TrainingPlan.builder()
                            .name(dto.getName())
                            .description(dto.getDescription())
                            .aim(dto.getAim())
                            .goals(dto.getGoals())
                            .type(dto.getType())
                            .duration(dto.getDuration())
                            .frequency(dto.getFrequency())
                            .levels(levelRepository.findAllById(dto.getLevelIds()))
                            .locations(locationRepository.findAllById(dto.getLocationIds()))
                            .equipments(equipmentRepository.findAllById(dto.getEquipmentIds()))
                            .build();

                    trainingPlanRepository.save(plan);
                }
            }
        }
    }
}
