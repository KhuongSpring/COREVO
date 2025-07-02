package com.example.corevo.domain.dto.response.training_exercise;

import lombok.*;
import lombok.experimental.FieldDefaults;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class TrainingExercisePreviewResponseDto {

    Long id;

    String name;

    String imageURL;

    String description;

}
