package com.example.corevo.domain.dto.response;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class TrainingPlanResponseDto {
    String name;
    String description;
    String aim;
    String goals;
    String type;
    String duration;
    String frequency;

    List<Long> levelIds;
    List<Long> locationIds;
    List<Long> equipmentIds;
}
