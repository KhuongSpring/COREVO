package com.example.corevo.domain.progress;

import lombok.*;
import lombok.experimental.FieldDefaults;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
public class UserProgress implements Serializable {

    String userId;
    String currentStep;
    Map<String, String> selectedValue = new HashMap<>();

}
