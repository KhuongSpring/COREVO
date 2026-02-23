package com.example.corevo.domain.entity.user;

import com.example.corevo.domain.entity.training.TrainingPlan;
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;
import org.hibernate.annotations.Nationalized;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "user")
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@Builder
@FieldDefaults(level = AccessLevel.PRIVATE)
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    @Column(nullable = false)
    UUID id;

    @Column(nullable = false, unique = true)
    String username;

    @Column(nullable = false)
    @JsonIgnore
    String password;

    @Column(nullable = false)
    String email;

    @Nationalized
    String firstName;

    @Nationalized
    String lastName;

    LocalDate birth;

    String phone;

    @Nationalized
    String nationality;

    String linkAvatar;

    String avatarPublicId;

    String provider;

    @Column(nullable = false)
    LocalDate createdAt;

    Boolean isLocked;

    LocalDate deletedAt;

    @Builder.Default
    Boolean isDeleted = false;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    Role role;

    @ManyToOne
    @JoinColumn(name = "address_id")
    Address address;

    @OneToOne(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    UserHealth userHealth;

    @ManyToMany
    @JoinTable(name = "user_training_plans", joinColumns = @JoinColumn(name = "user_id"), inverseJoinColumns = @JoinColumn(name = "training_plan_id"))
    List<TrainingPlan> trainingPlans;

}
