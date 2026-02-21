package com.example.corevo.domain.dto.response.user;

import com.example.corevo.domain.dto.response.training_plan.TrainingPlanResponseDto;
import com.example.corevo.domain.dto.response.user.health.UserHealthResponseDto;
import com.example.corevo.domain.entity.user.Address;
import com.example.corevo.domain.entity.user.Role;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class UserResponseDto {
    UUID id;

    String username;

    String email;

    String firstName;

    String lastName;

    LocalDate birth;

    String phone;

    String nationality;

    String linkAvatar;

    LocalDate createdAt;

    Role role;

    Address address;

    UserHealthResponseDto userHealth;

    List<TrainingPlanResponseDto> trainingPlans;

}
