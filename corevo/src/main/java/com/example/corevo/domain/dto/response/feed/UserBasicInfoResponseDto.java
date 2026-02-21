package com.example.corevo.domain.dto.response.feed;

import java.util.UUID;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.FieldDefaults;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class UserBasicInfoResponseDto {
    UUID id;

    String username;

    String firstName;

    String lastName;

    String linkAvatar;

}
