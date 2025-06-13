package com.example.corevo.domain.dto.response.user;

import com.example.corevo.domain.entity.Address;
import com.example.corevo.domain.entity.Role;
import com.example.corevo.domain.entity.UserHealth;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class UserResponseDto {
    String id;

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

    UserHealth userHealth;
}
