package com.example.corevo.domain.mapper;

import com.example.corevo.domain.dto.response.training.EquipmentResponseDto;
import com.example.corevo.domain.entity.training.Equipment;
import org.mapstruct.Mapper;
import org.mapstruct.NullValueCheckStrategy;
import org.mapstruct.NullValuePropertyMappingStrategy;

import java.util.List;

@Mapper(componentModel = "spring",
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE,
        nullValueCheckStrategy = NullValueCheckStrategy.ALWAYS
)
public interface EquipmentMapper {

    List<EquipmentResponseDto> listEquipmentToListEquipmentResponseDto(List<Equipment> equipments);

}
