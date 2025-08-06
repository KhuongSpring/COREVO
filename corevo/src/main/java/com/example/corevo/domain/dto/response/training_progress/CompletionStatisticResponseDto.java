package com.example.corevo.domain.dto.response.training_progress;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@AllArgsConstructor
@NoArgsConstructor
@Setter
@Getter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class CompletionStatisticResponseDto {

    String month;

    Integer year;

    List<Boolean> currentMonthCompletions;

    Integer currentStreak;

    Integer longestStreak;

}
