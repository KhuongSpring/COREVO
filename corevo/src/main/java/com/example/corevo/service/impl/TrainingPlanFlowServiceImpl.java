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
import com.example.corevo.repository.TrainingExerciseCompletionRepository;
import com.example.corevo.repository.TrainingPlanRepository;
import com.example.corevo.repository.UserRepository;
import com.example.corevo.service.TrainingPlanFlowService;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
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

    TrainingExerciseCompletionRepository trainingExerciseCompletionRepository;

    @Override
    public TrainingPlanFlowResponseDto processStep(
            String currentStep,
            List<String> selectedValue,
            Map<String, List<String>> selectedValues,
            Authentication authentication
    ) {
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

        List<String> goals = selectedValues.getOrDefault("goals", List.of());
        List<String> types = selectedValues.getOrDefault("type", List.of());
        List<String> durations = selectedValues.getOrDefault("duration", List.of());
        List<String> frequencies = selectedValues.getOrDefault("frequency", List.of());

        List<Long> levelIds = parseIds("level", selectedValues.get("level"));
        List<Long> locationIds = parseIds("location", selectedValues.get("location"));
        List<Long> equipmentIds = parseIds("equipment", selectedValues.get("equipment"));

        boolean hasGoalsFilter = goals != null && !goals.isEmpty();
        boolean hasTypeFilter = types != null && !types.isEmpty();
        boolean hasDurationFilter = durations != null && !durations.isEmpty();
        boolean hasFrequencyFilter = frequencies != null && !frequencies.isEmpty();
        boolean hasLevelFilter = levelIds != null && !levelIds.isEmpty();
        boolean hasLocationFilter = locationIds != null && !locationIds.isEmpty();
        boolean hasEquipmentFilter = equipmentIds != null && !equipmentIds.isEmpty();

        List<TrainingPlan> matchingPlans;

        try {
            matchingPlans = trainingPlanRepository.searchPlans(
                    hasGoalsFilter, hasTypeFilter, hasDurationFilter, hasFrequencyFilter,
                    hasLevelFilter, hasLocationFilter, hasEquipmentFilter,
                    goals, types, durations, frequencies,
                    levelIds, locationIds, equipmentIds);
        } catch (Exception e) {
            throw new VsException(HttpStatus.BAD_REQUEST, ErrorMessage.TrainingPlanFlow.ERR_SOMETHING_WRONG);
        }

        if (nextStep == null) {
            List<TrainingPlanResponseDto> responseDtos = matchingPlans.stream()
                    .map(this::mapToDto)
                    .toList();

            if (authentication == null || !authentication.isAuthenticated()) {
                throw new VsException(HttpStatus.UNAUTHORIZED, ErrorMessage.UNAUTHORIZED);
            }

            String username = authentication.getName();

            User user = userRepository.findByUsername(username);

            if (user == null) {
                throw new VsException(HttpStatus.NOT_FOUND, ErrorMessage.User.ERR_USER_NOT_EXISTED);
            }

            if (!user.getTrainingPlans().contains(matchingPlans.getFirst())) {
                user.getTrainingPlans().add(matchingPlans.getFirst());

                userRepository.save(user);
            }

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
    @Transactional
    public CommonResponseDto resetTrainingPlan(Authentication authentication) {
        try {
            if (authentication == null || !authentication.isAuthenticated()) {
                throw new VsException(HttpStatus.UNAUTHORIZED, ErrorMessage.UNAUTHORIZED);
            }

            String username = authentication.getName();

            User user = userRepository.findByUsername(username);

            if (user == null) {
                throw new VsException(HttpStatus.NOT_FOUND, ErrorMessage.User.ERR_USER_NOT_EXISTED);
            }

            List<TrainingPlan> currentTrainingPlans = user.getTrainingPlans();
            if (currentTrainingPlans != null && !currentTrainingPlans.isEmpty()) {
                List<Long> trainingPlanIds = currentTrainingPlans.stream()
                        .map(TrainingPlan::getId)
                        .toList();

                for (Long trainingPlanId : trainingPlanIds) {
                    trainingExerciseCompletionRepository.deleteByUser_IdAndTrainingPlanId(user.getId(), trainingPlanId);
                }

                user.getTrainingPlans().clear();
            }

            userRepository.save(user);

            return new CommonResponseDto(HttpStatus.OK, SuccessMessage.TrainingPlan.RESET_TRAINING_PLAN_SUCCESS);

        } catch (Exception e) {
            throw new VsException(HttpStatus.INTERNAL_SERVER_ERROR, ErrorMessage.TrainingPlanFlow.ERR_SOMETHING_WRONG);
        }
    }

}
