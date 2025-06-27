package com.example.corevo.domain.mapper;

import com.example.corevo.domain.dto.response.training_plan.TrainingPlanResponseDto;
import com.example.corevo.domain.entity.TrainingPlan;
import com.example.corevo.helper.IdToEntityHelper;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.NullValueCheckStrategy;
import org.mapstruct.NullValuePropertyMappingStrategy;

import java.util.List;

@Mapper(componentModel = "spring",
        uses = IdToEntityHelper.class,
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE,
        nullValueCheckStrategy = NullValueCheckStrategy.ALWAYS
)
public interface TrainingPlanMapper {
    @Mapping(target = "levels",     source = "levelIds")      // map thủ công
    @Mapping(target = "locations",  source = "locationIds")
    @Mapping(target = "equipments", source = "equipmentIds")
    TrainingPlan trainingPlanResponseDtoToTrainingPlan(TrainingPlanResponseDto dto);

    List<TrainingPlan> listTrainingPlanResponseDtoToListTrainingPlan(List<TrainingPlanResponseDto> dtoList);
}
