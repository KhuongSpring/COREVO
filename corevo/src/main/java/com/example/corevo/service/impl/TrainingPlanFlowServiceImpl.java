package com.example.corevo.service.impl;

import com.example.corevo.domain.dto.response.TrainingPlanFlowResponseDto;
import com.example.corevo.domain.dto.response.TrainingPlanResponseDto;
import com.example.corevo.domain.entity.training.Equipment;
import com.example.corevo.domain.entity.training.Level;
import com.example.corevo.domain.entity.training.Location;
import com.example.corevo.domain.entity.training.TrainingPlan;
import com.example.corevo.repository.TrainingPlanRepository;
import com.example.corevo.service.TrainingPlanFlowService;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class TrainingPlanFlowServiceImpl implements TrainingPlanFlowService {

    TrainingPlanRepository trainingPlanRepository;

    @Override
    public TrainingPlanFlowResponseDto processStep(String currentStep, String selectedValue, Map<String, String> selectedValues) {
        if (selectedValue != null && currentStep != null) {
            selectedValues.put(currentStep, selectedValue);
        }

        String nextStep = switch (currentStep){
            case "goals" -> nextStep = "level";
            case "level" -> nextStep = "duration";
            case "duration" -> nextStep = "type";
            case "type" -> nextStep = "frequency";
            case "frequency" -> nextStep = "location";
            case "location" -> nextStep = "equipment";
            case "equipment" -> null;
            default -> null;
        };

        List<TrainingPlan> matchingPlans = trainingPlanRepository.searchPlans(
                selectedValues.get("goals"),
                selectedValues.get("type"),
                selectedValues.get("duration"),
                selectedValues.get("frequency"),
                convertLevelToId(selectedValues.get("level")),
                convertLocationToId(selectedValues.get("location")),
                convertEquipmentToId(selectedValues.get("equipment"))
        );

        if (nextStep == null){
            List<TrainingPlanResponseDto> responseDtos = matchingPlans.stream()
                    .map(this::mapToDto)
                    .toList();
            return new TrainingPlanFlowResponseDto(responseDtos.get(0));
        }

        List<Object> options = extractOptionsForStep(matchingPlans, nextStep);

        return new TrainingPlanFlowResponseDto(nextStep, options);
    }

    private List<Object> extractOptionsForStep(List<TrainingPlan> plans, String step) {
        return plans.stream()
                .map(plan -> switch (step) {
                    case "goals" -> plan.getGoals();
                    case "type" -> plan.getType();
                    case "duration" -> plan.getDuration();
                    case "frequency" -> plan.getFrequency();
                    case "level" -> plan.getLevels();
                    case "location" -> plan.getLocations();
                    case "equipment" -> plan.getEquipments();
                    default -> null;
                })
                .filter(Objects::nonNull)
                .distinct()
                .toList();
    }

    public Long convertLevelToId(String level) {
        if (level == null) return null;
        switch (level.toUpperCase()) {
            case "BEGINNER": return 1L;
            case "INTERMEDIATE": return 2L;
            case "ADVANCED": return 3L;
            default: throw new IllegalArgumentException("Unknown level: " + level);
        }
    }

    public Long convertLocationToId(String location) {
        if (location == null) return null;
        switch (location.toUpperCase()) {
            case "HOME": return 1L;
            case "GYM": return 2L;
            case "OUTSIDE": return 3L;
            case "ANYWHERE": return 4L;
            default: throw new IllegalArgumentException("Unknown level: " + location);
        }
    }

    public Long convertEquipmentToId(String equipment) {
        if (equipment == null) return null;
        switch (equipment.toUpperCase()) {
            case "NONE": return 1L;
            case "YOGA MAT": return 2L;
            case "TREADMILL": return 3L;
            case "RESISTANCE BAND": return 4L;
            case "GYM EQUIPMENT": return 5L;
            case "PULL UP BAR": return 6L;
            case "PARALLEL BARS": return 7L;
            default: throw new IllegalArgumentException("Unknown level: " + equipment);
        }
    }

    private TrainingPlanResponseDto mapToDto(TrainingPlan plan) {
        TrainingPlanResponseDto dto = new TrainingPlanResponseDto();

        dto.setName(plan.getName());
        dto.setDescription(plan.getDescription());
        dto.setAim(plan.getAim());
        dto.setGoals(plan.getGoals());
        dto.setType(plan.getType());
        dto.setDuration(plan.getDuration());
        dto.setFrequency(plan.getFrequency());

        dto.setLevelIds(
                plan.getLevels() != null
                        ? plan.getLevels().stream()
                        .map(Level::getId)
                        .collect(Collectors.toList())
                        : List.of()
        );

        dto.setLocationIds(
                plan.getLocations() != null
                        ? plan.getLocations().stream()
                        .map(Location::getId)
                        .collect(Collectors.toList())
                        : List.of()
        );

        dto.setEquipmentIds(
                plan.getEquipments() != null
                        ? plan.getEquipments().stream()
                        .map(Equipment::getId)
                        .collect(Collectors.toList())
                        : List.of()
        );

        return dto;
    }


}
