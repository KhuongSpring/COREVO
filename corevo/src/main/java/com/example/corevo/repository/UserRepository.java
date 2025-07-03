package com.example.corevo.repository;

import com.example.corevo.domain.entity.user.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, String> {

    Optional<User> findUserDetailByUsername(String username);

    User findByUsername(String username);

    boolean existsUserByUsername(String emailOrUsername);

    boolean existsUserByEmail(String email);

    User findByEmail(String email);

    boolean existsUsersByPhone(String phone);

    @Query("SELECT u FROM User u WHERE u.email = :email AND u.isDeleted = true")
    Optional<User> findDeletedUserByEmail(@Param("email") String email);

    @Query("SELECT u FROM User u WHERE u.isDeleted = true AND u.deletedAt < :expiredDate")
    List<User> findExpiredDeletedUsers(@Param("expiredDate") LocalDateTime expiredDate);

    @Query("SELECT COUNT(u) FROM User u WHERE u.address.id = :addressId")
    long countByAddressId(String addressId);

}
