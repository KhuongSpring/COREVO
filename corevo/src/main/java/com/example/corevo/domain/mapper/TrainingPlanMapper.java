package com.example.corevo.domain.mapper;

import com.example.corevo.domain.dto.response.training_plan.TrainingPlanResponseDto;
import com.example.corevo.domain.entity.training.TrainingPlan;
import com.example.corevo.helper.training_helper.TrainingMapperHelper;
import org.mapstruct.*;

import java.util.List;

@Mapper(componentModel = "spring",
        uses = TrainingMapperHelper.class,
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE,
        nullValueCheckStrategy = NullValueCheckStrategy.ALWAYS
)
public interface TrainingPlanMapper {

    @Mapping(target = "levels", source = "levelIds")
    @Mapping(target = "locations", source = "locationIds")
    @Mapping(target = "equipments", source = "equipmentIds")
    TrainingPlan trainingPlanResponseDtoToTrainingPlan(TrainingPlanResponseDto dto);

    @Named("withoutId")
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "levels", source = "levelIds")
    @Mapping(target = "locations", source = "locationIds")
    @Mapping(target = "equipments", source = "equipmentIds")
    TrainingPlan trainingPlanResponseDtoToTrainingPlanWithoutId(TrainingPlanResponseDto dto);

    @IterableMapping(qualifiedByName = "withoutId")
    List<TrainingPlan> listTrainingPlanResponseDtoToListTrainingPlanWithoutId(List<TrainingPlanResponseDto> dtoList);

    List<TrainingPlan> listTrainingPlanResponseDtoToListTrainingPlan(List<TrainingPlanResponseDto> dtoList);

    @Mapping(target = "levelIds", source = "levels")
    @Mapping(target = "locationIds", source = "locations")
    @Mapping(target = "equipmentIds", source = "equipments")
    TrainingPlanResponseDto trainingPlanToTrainingPlanResponseDto(TrainingPlan entity);

    List<TrainingPlanResponseDto> listTrainingPlanToListTrainingPlanResponseDto(List<TrainingPlan> entityList);
}

