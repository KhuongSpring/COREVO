package com.example.corevo.domain.dto.request.training;

import lombok.*;
import lombok.experimental.FieldDefaults;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class TrainingExerciseSearchingRequestDto {
    String keyType;
    String searchSentence;
}
