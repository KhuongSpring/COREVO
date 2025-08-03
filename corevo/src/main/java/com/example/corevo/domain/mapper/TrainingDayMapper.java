package com.example.corevo.domain.mapper;

import com.example.corevo.domain.dto.response.training_schedule.TrainingDayResponseDto;
import com.example.corevo.domain.entity.training.training_schedule_details.TrainingDay;
import com.example.corevo.helper.training_helper.TrainingScheduleMapperHelper;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.NullValueCheckStrategy;
import org.mapstruct.NullValuePropertyMappingStrategy;

import java.util.List;

@Mapper(componentModel = "spring",
        uses = {TrainingExerciseGroupMapper.class, TrainingScheduleMapperHelper.class},
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE,
        nullValueCheckStrategy = NullValueCheckStrategy.ALWAYS
)
public interface TrainingDayMapper {

    @Mapping(target = "exerciseGroup", source = "exerciseGroups")
    @Mapping(target = "trainingSchedule", ignore = true)
    TrainingDay trainingDayResponseDtoToTrainingDay(TrainingDayResponseDto dto);

    List<TrainingDay> listTrainingDayResponseDtoToListTrainingDay(List<TrainingDayResponseDto> listDto);

    @Mapping(target = "exerciseGroups", source = "exerciseGroup")
    TrainingDayResponseDto trainingDayToTrainingDayResponseDto(TrainingDay entity);

    List<TrainingDayResponseDto> listTrainingDayToListTrainingDayResponseDto(List<TrainingDay> listEntity);
}
