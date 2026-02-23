package com.example.corevo.repository;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.corevo.domain.entity.feed.PostLike;

@Repository
public interface PostLikeRepository extends JpaRepository<PostLike, UUID> {
    Optional<PostLike> findByPostIdAndUserId(UUID postId, UUID userId);

    long countByPostIdAndIsLikeTrue(UUID postId);

    long countByPostIdAndIsLikeFalse(UUID postId);

    // Like or unlike
    void deleteByPostIdAndUserId(UUID postId, UUID userId);
}
