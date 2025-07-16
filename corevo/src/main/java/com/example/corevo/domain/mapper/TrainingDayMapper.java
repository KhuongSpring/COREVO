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
        uses = TrainingScheduleMapperHelper.class,
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE,
        nullValueCheckStrategy = NullValueCheckStrategy.ALWAYS
)
public interface TrainingDayMapper {

    @Mapping(target = "exerciseGroups", source = "exerciseGroupIds")
    @Mapping(target = "trainingSchedule", ignore = true)
    TrainingDay trainingScheduleResponseDtoToTrainingSchedule(TrainingDayResponseDto dto);

    List<TrainingDay> listTrainingScheduleResponseDtoToListTrainingSchedule(List<TrainingDayResponseDto> listDto);

    @Mapping(target = "exerciseGroupIds", source = "exerciseGroups")
    TrainingDayResponseDto trainingScheduleToTrainingScheduleResponseDto(TrainingDay entity);

    List<TrainingDayResponseDto> listTrainingScheduleToListTrainingScheduleResponseDto(List<TrainingDay> listEntity);
}
