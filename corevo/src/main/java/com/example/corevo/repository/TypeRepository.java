package com.example.corevo.repository;

import com.example.corevo.domain.entity.training.Type;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TypeRepository extends JpaRepository<Type, Long> {

    boolean existsByTypeName(String typeName);

}
