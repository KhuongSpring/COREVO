package com.example.corevo.repository;

import com.example.corevo.domain.entity.user.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, String> {

        Optional<User> findUserDetailByUsername(String username);

        Optional<User> findByUsername(String username);

        boolean existsUserByUsername(String emailOrUsername);

        boolean existsUserByEmail(String email);

        Optional<User> findByEmail(String email);

        boolean existsUsersByPhone(String phone);

        @Query("SELECT u FROM User u WHERE u.email = :email AND u.isDeleted = true")
        Optional<User> findDeletedUserByEmail(@Param("email") String email);

        @Query("SELECT u FROM User u WHERE u.isDeleted = true AND u.deletedAt < :expiredDate")
        List<User> findExpiredDeletedUsers(@Param("expiredDate") LocalDateTime expiredDate);

        @Query("SELECT COUNT(u) FROM User u WHERE u.address.id = :addressId")
        long countByAddressId(String addressId);

        Page<User> findUserByUsernameContainingIgnoreCase(String username, Pageable pageable);

        Page<User> findUserByEmailContainingIgnoreCase(String email, Pageable pageable);

        Page<User> findUserByPhoneContaining(String phone, Pageable pageable);

        @Query("SELECT DATE(u.createdAt) as date, COUNT(u) as count " +
                        "FROM User u " +
                        "WHERE u.createdAt >= :startDate " +
                        "GROUP BY DATE(u.createdAt)")
        List<Object[]> countUserByDay(@Param("startDate") LocalDate startDate);

        @Query("SELECT FUNCTION('DATE_FORMAT', u.createdAt, '%Y-%m'), COUNT(u) " +
                        "FROM User u " +
                        "WHERE u.createdAt >= :startDate " +
                        "GROUP BY FUNCTION('DATE_FORMAT', u.createdAt, '%Y-%m') " +
                        "ORDER BY FUNCTION('DATE_FORMAT', u.createdAt, '%Y-%m') ASC")
        List<Object[]> countUserByMonth(@Param("startDate") LocalDate startDate);

}
