package com.example.corevo.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.FieldDefaults;

import java.time.LocalDate;

@ConfigurationProperties("app.admin")
@Getter
@Setter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class UserInfoProperties {
    String username;
    String email;
    String password;
    String firstName;
    String lastName;
    String phone;
    String nationality;
    LocalDate birth;
}
