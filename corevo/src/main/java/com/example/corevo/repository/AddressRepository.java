package com.example.corevo.repository;

import com.example.corevo.domain.entity.user.Address;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface AddressRepository extends JpaRepository<Address, String> {
    Optional<Address> findByProvinceAndDistrict(String province, String district);
}
