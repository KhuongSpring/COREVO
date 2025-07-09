package com.example.corevo.service.impl;

import com.example.corevo.constant.ErrorMessage;
import com.example.corevo.constant.SuccessMessage;
import com.example.corevo.domain.dto.response.CommonResponseDto;
import com.example.corevo.domain.dto.response.training_plan.TrainingPlanFlowResponseDto;
import com.example.corevo.domain.dto.response.training_plan.TrainingPlanResponseDto;
import com.example.corevo.domain.entity.training.Equipment;
import com.example.corevo.domain.entity.training.Level;
import com.example.corevo.domain.entity.training.Location;
import com.example.corevo.domain.entity.training.TrainingPlan;
import com.example.corevo.domain.entity.user.User;
import com.example.corevo.exception.VsException;
import com.example.corevo.helper.StringToTrainingIDHelper;
import com.example.corevo.repository.TrainingPlanRepository;
import com.example.corevo.repository.UserRepository;
import com.example.corevo.service.TrainingPlanFlowService;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class TrainingPlanFlowServiceImpl implements TrainingPlanFlowService {

    TrainingPlanRepository trainingPlanRepository;

    UserRepository userRepository;

    @Override
    public TrainingPlanFlowResponseDto processStep(
            String currentStep,
            List<String> selectedValue,
            Map<String, List<String>> selectedValues) {
        if (selectedValue != null && currentStep != null) {
            selectedValues.put(currentStep, selectedValue);
        }

        String nextStep = switch (Objects.requireNonNullElse(currentStep, "")) {
            case "goals" -> "level";
            case "level" -> "duration";
            case "duration" -> "type";
            case "type" -> "frequency";
            case "frequency" -> "location";
            case "location" -> "equipment";
            default -> null;
        };

        List<Long> levelIds = parseIds("level", selectedValues.get("level"));
        List<Long> locationIds = parseIds("location", selectedValues.get("location"));
        List<Long> equipmentIds = parseIds("equipment", selectedValues.get("equipment"));

        boolean hasLevelFilter = levelIds != null && !levelIds.isEmpty();
        boolean hasLocationFilter = locationIds != null && !locationIds.isEmpty();
        boolean hasEquipmentFilter = equipmentIds != null && !equipmentIds.isEmpty();

        List<TrainingPlan> matchingPlans;

        try {
            matchingPlans = trainingPlanRepository.searchPlans(
                    getFirst(selectedValues.get("goals")),
                    getFirst(selectedValues.get("type")),
                    getFirst(selectedValues.get("duration")),
                    getFirst(selectedValues.get("frequency")),
                    hasLevelFilter,
                    hasLocationFilter,
                    hasEquipmentFilter,
                    levelIds,
                    locationIds,
                    equipmentIds);
        } catch (Exception e) {
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
                    null);
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
                        : List.of());

        dto.setLocationIds(
                plan.getLocations() != null
                        ? plan.getLocations().stream()
                                .map(Location::getId)
                                .collect(Collectors.toList())
                        : List.of());

        dto.setEquipmentIds(
                plan.getEquipments() != null
                        ? plan.getEquipments().stream()
                                .map(Equipment::getId)
                                .collect(Collectors.toList())
                        : List.of());

        return dto;
    }

    private String getFirst(List<String> list) {
        return (list != null && !list.isEmpty()) ? list.getFirst() : null;
    }

    private List<Long> parseIds(String key, List<String> list) {
        List<Long> ids = switch (key) {
            case "level" -> StringToTrainingIDHelper.Level.toIds(list);
            case "location" -> StringToTrainingIDHelper.Location.toIds(list);
            case "equipment" -> StringToTrainingIDHelper.Equipment.toIds(list);
            default -> List.of();
        };
        return (ids == null || ids.isEmpty()) ? null : ids;
    }

    @Override
    public CommonResponseDto resetTrainingPlan() {
        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

            if (authentication == null || !authentication.isAuthenticated()) {
                throw new VsException(HttpStatus.UNAUTHORIZED, ErrorMessage.UNAUTHORIZED);
            }

            String username = authentication.getName();

            User user = userRepository.findByUsername(username);

            if (user == null) {
                throw new VsException(HttpStatus.NOT_FOUND, ErrorMessage.User.ERR_USER_NOT_EXISTED);
            }

            user.setTrainingPlans(null);
            userRepository.save(user);

            return new CommonResponseDto(HttpStatus.OK, SuccessMessage.TrainingPlan.RESET_TRAINING_PLAN_SUCCESS);

        } catch (Exception e) {
            throw new VsException(HttpStatus.INTERNAL_SERVER_ERROR, ErrorMessage.TrainingPlanFlow.ERR_SOMETHING_WRONG);
        }
    }

}
