package com.example.corevo.domain.mapper;

import com.example.corevo.domain.dto.response.training_schedule.TrainingExerciseGroupDetailsResponseDto;
import com.example.corevo.domain.entity.training.training_schedule_details.TrainingExerciseGroupDetail;
import org.mapstruct.*;

@Mapper(componentModel = "spring", nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE, nullValueCheckStrategy = NullValueCheckStrategy.ALWAYS)
public interface TrainingExerciseGroupDetailMapper {

    @Mapping(target = "exerciseId", source = "exercise.id")
    @Mapping(target = "duration", source = ".", qualifiedByName = "combineDuration")
    TrainingExerciseGroupDetailsResponseDto trainingExerciseGroupDetailToDto(TrainingExerciseGroupDetail detail);

    @Named("combineDuration")
    default String combineDuration(TrainingExerciseGroupDetail detail) {
        String sets = detail.getSets() != null ? detail.getSets() : "";
        String reps = detail.getRepsPerSet();
        String time = detail.getDurationPerSet();

        if (reps != null) {
            return sets + " setsX" + reps + " reps";
        } else if (time != null) {
            return sets + " setsX" + time;
        } else {
            return sets + " sets";
        }
    }
}
