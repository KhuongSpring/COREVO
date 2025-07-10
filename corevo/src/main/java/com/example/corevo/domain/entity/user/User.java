package com.example.corevo.domain.entity.user;

import com.example.corevo.constant.CommonConstant;
import com.example.corevo.domain.entity.training.Equipment;
import com.example.corevo.domain.entity.training.TrainingPlan;
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;
import org.hibernate.annotations.GenericGenerator;
import org.hibernate.annotations.Nationalized;

import java.time.LocalDate;
import java.util.List;

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
    @GeneratedValue(generator = "uuid2")
    @GenericGenerator(name = "uuid2", strategy = "org.hibernate.id.UUIDGenerator")
    @Column(insertable = false, updatable = false, nullable = false, columnDefinition = "CHAR(36)")
    String id;

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

    String provider;

    @Column(nullable = false)
    LocalDate createdAt;

    Boolean isLocked;

    LocalDate deletedAt;

    Boolean isDeleted = CommonConstant.FALSE;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    Role role;

    @ManyToOne
    @JoinColumn(name = "address_id")
    Address address;

    @OneToOne(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    UserHealth userHealth;

    @ManyToMany
    @JoinTable(
            name = "user_training_plans",
            joinColumns = @JoinColumn(name = "user_id"),
            inverseJoinColumns = @JoinColumn(name = "training_plan_id")
    )
    List<TrainingPlan> trainingPlans;

}
