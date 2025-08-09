package com.example.corevo.helper.training_helper;

import com.example.corevo.domain.entity.training.*;
import com.example.corevo.repository.*;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.mapstruct.Named;
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

    @Named("mapEquipmentToEntity")
    public List<Equipment> mapEquipmentIds(List<Long> ids) {
        return ids == null ? List.of() : equipmentRepo.findAllById(ids);
    }

    @Named("mapGoalToEntity")
    public List<Goal> mapGoalIds(List<Long> ids) {
        return ids == null ? List.of() : goalRepository.findAllById(ids);
    }

    @Named("mapLevelToEntity")
    public List<Level> mapLevelIds(List<Long> ids) {
        return ids == null ? List.of() : levelRepo.findAllById(ids);
    }

    @Named("mapLocationToEntity")
    public List<Location> mapLocationIds(List<Long> ids) {
        return ids == null ? List.of() : locationRepo.findAllById(ids);
    }

    @Named("mapTargetMuscleToEntity")
    public List<TargetMuscle> mapTargetMuscleIds(List<Long> ids) {
        return ids == null ? List.of() : targetMuscleRepository.findAllById(ids);
    }

    @Named("mapTypeToEntity")
    public List<Type> mapTypeIds(List<Long> ids) {
        return ids == null ? List.of() : typeRepository.findAllById(ids);
    }

    @Named("mapEquipmentToId")
    public List<Long> mapEquipmentToIds(List<Equipment> ids) {
        return ids == null ? null : ids.stream().map(Equipment::getId).toList();
    }

    @Named("mapGoalToId")
    public List<Long> mapGoalToIds(List<Goal> ids) {
        return ids == null ? null : ids.stream().map(Goal::getId).toList();
    }

    @Named("mapLevelToId")
    public List<Long> mapLevelToIds(List<Level> ids) {
        return ids == null ? null : ids.stream().map(Level::getId).toList();
    }

    @Named("mapLocationToId")
    public List<Long> mapLocationToIds(List<Location> ids) {
        return ids == null ? null : ids.stream().map(Location::getId).toList();
    }

    @Named("mapTargetMuscleToId")
    public List<Long> mapTargetMuscleToIds(List<TargetMuscle> ids) {
        return ids == null ? null : ids.stream().map(TargetMuscle::getId).toList();
    }

    @Named("mapTypeToId")
    public List<Long> mapTypeToIds(List<Type> ids) {
        return ids == null ? null : ids.stream().map(Type::getId).toList();
    }
}
