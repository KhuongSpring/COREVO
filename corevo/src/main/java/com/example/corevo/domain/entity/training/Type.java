package com.example.corevo.domain.entity.training;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "type")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Type {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long id;
    String typeName;
}
