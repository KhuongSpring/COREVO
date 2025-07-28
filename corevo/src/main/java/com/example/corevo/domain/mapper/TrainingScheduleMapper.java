package com.example.corevo.domain.mapper;

import com.example.corevo.domain.dto.response.training_schedule.TrainingScheduleResponseDto;
import com.example.corevo.domain.entity.training.training_schedule_details.TrainingSchedule;
import com.example.corevo.helper.training_helper.TrainingScheduleMapperHelper;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.NullValueCheckStrategy;
import org.mapstruct.NullValuePropertyMappingStrategy;

import java.util.List;

@Mapper(componentModel = "spring",
        uses = {TrainingScheduleMapperHelper.class, TrainingDayMapper.class},
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE,
        nullValueCheckStrategy = NullValueCheckStrategy.ALWAYS
)
public interface TrainingScheduleMapper {

    @Mapping(target = "user", source = "userId")
    @Mapping(target = "trainingPlan", source = "trainingPlanId")
    @Mapping(target = "days", source = "days")
    TrainingSchedule trainingScheduleResponseDtoToTrainingSchedule(TrainingScheduleResponseDto dto);

    List<TrainingSchedule> listTrainingScheduleResponseDtoToListTrainingSchedule(List<TrainingScheduleResponseDto> listDto);

    @Mapping(target = "userId", source = "user")
    @Mapping(target = "trainingPlanId", source = "trainingPlan")
    @Mapping(target = "days", source = "days")
    TrainingScheduleResponseDto trainingScheduleToTrainingScheduleResponseDto(TrainingSchedule entity);

    List<TrainingScheduleResponseDto> listTrainingScheduleToListTrainingScheduleResponseDto(List<TrainingSchedule> listEntity);
}
