package com.example.corevo.domain.dto.response.user.health;

import com.example.corevo.domain.entity.user.ActivityLevel;
import lombok.*;
import lombok.experimental.FieldDefaults;


@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class UserHealthResponseDto {

    String id;

    String userId;

    String gender;

    int height;

    int weight;

    int age;

    ActivityLevel activityLevel; 

    double basalMetabolicRate;

    int maximumHeartRate;

    double TDEE;

}
