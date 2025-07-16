package com.example.corevo.helper.training_helper;

import com.example.corevo.domain.entity.training.*;
import com.example.corevo.repository.*;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@RequiredArgsConstructor
public class TrainingMapperHelper {

    EquipmentRepository equipmentRepo;
    GoalRepository goalRepository;
    LevelRepository levelRepo;
    LocationRepository locationRepo;
    TargetMuscleRepository targetMuscleRepository;
    TypeRepository typeRepository;

    public List<Equipment> mapEquipmentIds(List<Long> ids) {
        return ids == null ? List.of() : equipmentRepo.findAllById(ids);
    }

    public List<Goal> mapGoalIds(List<Long> ids) {
        return ids == null ? List.of() : goalRepository.findAllById(ids);
    }

    public List<Level> mapLevelIds(List<Long> ids) {
        return ids == null ? List.of() : levelRepo.findAllById(ids);
    }

    public List<Location> mapLocationIds(List<Long> ids) {
        return ids == null ? List.of() : locationRepo.findAllById(ids);
    }

    public List<TargetMuscle> mapTargetMuscleIds(List<Long> ids) {
        return ids == null ? List.of() : targetMuscleRepository.findAllById(ids);
    }

    public List<Type> mapTypeIds(List<Long> ids) {
        return ids == null ? List.of() : typeRepository.findAllById(ids);
    }

    public List<Long> mapEquipmentToIds(List<Equipment> ids) {
        return ids == null ? null : ids.stream().map(Equipment::getId).toList();
    }

    public List<Long> mapGoalToIds(List<Goal> ids) {
        return ids == null ? null : ids.stream().map(Goal::getId).toList();
    }

    public List<Long> mapLevelToIds(List<Level> ids) {
        return ids == null ? null : ids.stream().map(Level::getId).toList();
    }

    public List<Long> mapLocationToIds(List<Location> ids) {
        return ids == null ? null : ids.stream().map(Location::getId).toList();
    }

    public List<Long> mapTargetMuscleToIds(List<TargetMuscle> ids) {
        return ids == null ? null : ids.stream().map(TargetMuscle::getId).toList();
    }

    public List<Long> mapTypeToIds(List<Type> ids) {
        return ids == null ? null : ids.stream().map(Type::getId).toList();
    }
}
