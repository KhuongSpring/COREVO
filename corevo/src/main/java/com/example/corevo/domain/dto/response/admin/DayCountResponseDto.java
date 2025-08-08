package com.example.corevo.domain.dto.response.admin;

import lombok.*;
import lombok.experimental.FieldDefaults;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)

public class DayCountResponseDto {
    String day;
    Long count;
}
