package com.example.corevo.domain.mapper;

import com.example.corevo.domain.dto.response.training_plan.PersonalTrainingDayResponseDto;
import com.example.corevo.domain.entity.training.training_personal.PersonalTrainingDay;
import org.mapstruct.*;

@Mapper(componentModel = "spring",
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE,
        nullValueCheckStrategy = NullValueCheckStrategy.ALWAYS
)
public interface PersonalTrainingMapper {

    @Mapping(target = "dayId", source = "id")
    @Mapping(target = "planId", source = "personalTrainingPlan.id")
    PersonalTrainingDayResponseDto personalTrainingDayToPersonalTrainingDayResponseDto(PersonalTrainingDay personalTrainingDay);

}
