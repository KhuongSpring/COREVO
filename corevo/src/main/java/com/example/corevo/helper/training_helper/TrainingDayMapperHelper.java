package com.example.corevo.helper.training_helper;

import com.example.corevo.constant.ErrorMessage;
import com.example.corevo.domain.entity.training.training_schedule_details.TrainingExerciseGroup;
import com.example.corevo.domain.entity.training.training_schedule_details.TrainingSchedule;
import com.example.corevo.exception.VsException;
import com.example.corevo.repository.TrainingExerciseGroupRepository;
import com.example.corevo.repository.TrainingScheduleRepository;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;

import java.util.List;

@Component
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@RequiredArgsConstructor
public class TrainingDayMapperHelper {

    TrainingScheduleRepository trainingScheduleRepository;

    TrainingExerciseGroupRepository trainingExerciseGroupRepository;

    public TrainingSchedule mapTrainingSchedule(Long id) {
        return trainingScheduleRepository.findById(id)
                .orElseThrow(() -> new VsException(HttpStatus.NOT_FOUND, ErrorMessage.Training.ERR_TRAINING_SCHEDULE_NOT_EXISTS));
    }

    public List<TrainingExerciseGroup> mapTrainingExerciseGroup(List<Long> ids) {
        return trainingExerciseGroupRepository.findAllById(ids);
    }

}
