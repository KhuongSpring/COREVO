package com.example.corevo.domain.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;

@Entity
@Table(name = "user_health")
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class UserHealth {
    @Id
    String id;

    @OneToOne
    @MapsId
    @JoinColumn(name = "id")
    User user;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    Gender gender;

    @Column(nullable = false)
    int height;

    @Column(nullable = false)
    int weight;

    @Column(nullable = false)
    int age;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    ActivityLevel activityLevel;

    double basalMetabolicRate;

    int maximumHeartRate;

    double TDEE;
}
