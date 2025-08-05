package com.example.corevo.domain.mapper;

import com.example.corevo.domain.dto.response.training_plan.TrainingPlanResponseDto;
import com.example.corevo.domain.entity.training.TrainingPlan;
import com.example.corevo.helper.training_helper.TrainingMapperHelper;
import org.hibernate.Internal;
import org.mapstruct.*;

import java.util.List;

@Mapper(componentModel = "spring",
        uses = TrainingMapperHelper.class,
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE,
        nullValueCheckStrategy = NullValueCheckStrategy.ALWAYS
)
public interface TrainingPlanMapper {

    @Mapping(target = "levels", source = "levelIds", qualifiedByName = "mapLevelToEntity")
    @Mapping(target = "locations", source = "locationIds", qualifiedByName = "mapLocationToEntity")
    @Mapping(target = "equipments", source = "equipmentIds", qualifiedByName = "mapEquipmentToEntity")
    TrainingPlan trainingPlanResponseDtoToTrainingPlan(TrainingPlanResponseDto dto);

    @Named("withoutId")
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "levels", source = "levelIds", qualifiedByName = "mapLevelToEntity")
    @Mapping(target = "locations", source = "locationIds", qualifiedByName = "mapLocationToEntity")
    @Mapping(target = "equipments", source = "equipmentIds", qualifiedByName = "mapEquipmentToEntity")
    TrainingPlan trainingPlanResponseDtoToTrainingPlanWithoutId(TrainingPlanResponseDto dto);

    @IterableMapping(qualifiedByName = "withoutId")
    List<TrainingPlan> listTrainingPlanResponseDtoToListTrainingPlanWithoutId(List<TrainingPlanResponseDto> dtoList);

    List<TrainingPlan> listTrainingPlanResponseDtoToListTrainingPlan(List<TrainingPlanResponseDto> dtoList);

    @Mapping(target = "levelIds", source = "levels", qualifiedByName = "mapLevelToId")
    @Mapping(target = "locationIds", source = "locations", qualifiedByName = "mapLocationToId")
    @Mapping(target = "equipmentIds", source = "equipments", qualifiedByName = "mapEquipmentToId")
    TrainingPlanResponseDto trainingPlanToTrainingPlanResponseDto(TrainingPlan entity);

    @Named("withoutId")
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "levelIds", source = "levels", qualifiedByName = "mapLevelToId")
    @Mapping(target = "locationIds", source = "locations", qualifiedByName = "mapLocationToId")
    @Mapping(target = "equipmentIds", source = "equipments", qualifiedByName = "mapEquipmentToId")
    TrainingPlanResponseDto trainingPlanToTrainingPlanResponseDtoWithoutId(TrainingPlan entity);

    @IterableMapping(qualifiedByName = "withoutId")
    List<TrainingPlanResponseDto> listTrainingPlanToListTrainingPlanResponseDtoWithoutId(List<TrainingPlan> entityList);

    List<TrainingPlanResponseDto> listTrainingPlanToListTrainingPlanResponseDto(List<TrainingPlan> entityList);
}

