package com.example.corevo.domain.dto.response.feed;

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
    String id;

    String username;

    String firstName;

    String lastName;

    String linkAvatar;

}
