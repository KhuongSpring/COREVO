package com.example.corevo.domain.dto.response.training_schedule;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class TrainingDayResponseDto {

    String dayOfWeek;

    String name;

    String duration;

    String location;

    String description;

    List<Long> exerciseGroupIds;
}
