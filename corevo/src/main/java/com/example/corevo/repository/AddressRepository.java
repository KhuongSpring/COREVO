package com.example.corevo.repository;

import com.example.corevo.domain.entity.Address;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface AddressRepository extends JpaRepository<Address, String> {
    Optional<Address> findByProvinceAndDistrict(String province, String district);
}
