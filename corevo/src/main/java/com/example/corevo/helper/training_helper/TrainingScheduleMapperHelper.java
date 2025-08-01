package com.example.corevo.helper.training_helper;

import com.example.corevo.constant.ErrorMessage;
import com.example.corevo.domain.entity.training.TrainingPlan;
import com.example.corevo.domain.entity.training.training_schedule_details.TrainingExerciseGroup;
import com.example.corevo.domain.entity.user.User;
import com.example.corevo.exception.VsException;
import com.example.corevo.repository.TrainingExerciseGroupRepository;
import com.example.corevo.repository.TrainingPlanRepository;
import com.example.corevo.repository.UserRepository;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Component
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@RequiredArgsConstructor
public class TrainingScheduleMapperHelper {

    UserRepository userRepository;

    TrainingPlanRepository trainingPlanRepository;

    public User mapUser(String id) {
        return userRepository.findById(id)
                .orElseThrow(() -> new VsException(HttpStatus.NOT_FOUND, ErrorMessage.User.ERR_USER_NOT_EXISTED));
    }

    public TrainingPlan mapTrainingPlan(Long id) {
        return trainingPlanRepository.findById(id)
                .orElseThrow(() -> new VsException(HttpStatus.NOT_FOUND, ErrorMessage.Training.ERR_TRAINING_PLAN_NOT_EXISTS));
    }

    public String mapUserToId(User user) {
        return user != null ? user.getId() : null;
    }

    public Long mapTrainingPlanToId(TrainingPlan plan) {
        return plan != null ? plan.getId() : null;
    }

}
