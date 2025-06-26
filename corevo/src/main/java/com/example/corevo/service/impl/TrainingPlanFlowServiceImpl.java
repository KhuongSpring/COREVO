package com.example.corevo.service.impl;

import com.example.corevo.constant.ErrorMessage;
import com.example.corevo.domain.dto.response.training.TrainingPlanFlowResponseDto;
import com.example.corevo.domain.dto.response.training.TrainingPlanResponseDto;
import com.example.corevo.domain.entity.training.Equipment;
import com.example.corevo.domain.entity.training.Level;
import com.example.corevo.domain.entity.training.Location;
import com.example.corevo.domain.entity.TrainingPlan;
import com.example.corevo.exception.VsException;
import com.example.corevo.repository.TrainingPlanRepository;
import com.example.corevo.service.TrainingPlanFlowService;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
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
    public TrainingPlanFlowResponseDto processStep(
            String currentStep,
            List<String> selectedValue,
            Map<String, List<String>> selectedValues) {
        if (selectedValue != null && currentStep != null) {
            selectedValues.put(currentStep, selectedValue);
        }

        String nextStep = switch (currentStep) {
            case "goals" -> "level";
            case "level" -> "duration";
            case "duration" -> "type";
            case "type" -> "frequency";
            case "frequency" -> "location";
            case "location" -> "equipment";
            case "equipment" -> null;
            default -> null;
        };

        List<TrainingPlan> matchingPlans = new ArrayList<>();

        try {
            matchingPlans = trainingPlanRepository.searchPlans(
                    getFirst(selectedValues.get("goals")),
                    getFirst(selectedValues.get("type")),
                    getFirst(selectedValues.get("duration")),
                    getFirst(selectedValues.get("frequency")),
                    parseIds(selectedValues.get("level")),
                    parseIds(selectedValues.get("location")),
                    parseIds(selectedValues.get("equipment"))
            );
        } catch (Exception e){
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.TrainingPlanFlow.ERR_SOMETHING_WRONG);
        }

        if (nextStep == null) {
            List<TrainingPlanResponseDto> responseDtos = matchingPlans.stream()
                    .map(this::mapToDto)
                    .toList();
            return new TrainingPlanFlowResponseDto(
                    null,
                    true,
                    selectedValues,
                    responseDtos,
                    null
            );
        }

        List<Object> options = extractOptionsForStep(matchingPlans, nextStep);

        return new TrainingPlanFlowResponseDto(
                nextStep,
                false,
                selectedValues,
                null,
                options);
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

    private String getFirst(List<String> list) {
        return (list != null && !list.isEmpty()) ? list.get(0) : null;
    }

    private List<Long> parseIds(List<String> list) {
        if (list == null || list.isEmpty()) return List.of();
        return list.stream()
                .filter(Objects::nonNull)
                .map(s -> {
                    try {
                        return Long.valueOf(s);
                    } catch (NumberFormatException e) {
                        return null;
                    }
                })
                .filter(Objects::nonNull)
                .toList();
    }


}
