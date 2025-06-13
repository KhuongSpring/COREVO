package com.example.corevo.domain.entity;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;
import org.hibernate.annotations.GenericGenerator;

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

    @Column(nullable = false)
    String gender;

    @Column(nullable = false)
    int height;

    @Column(nullable = false)
    int weight;

    @Column(nullable = false)
    int age;

    @Column(nullable = false)
    double activityFactor;

    double basalMetabolicRate;

    int maximumHeartRate;

    double TDEE;
}
