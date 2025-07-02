package com.example.corevo.domain.entity.training;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

@Entity
@Table(name = "level")
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class Level {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long id;

    String levelName;

}
