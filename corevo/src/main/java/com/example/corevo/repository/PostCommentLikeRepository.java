package com.example.corevo.repository;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.corevo.domain.entity.feed.CommentLike;

@Repository
public interface PostCommentLikeRepository extends JpaRepository<CommentLike, UUID> {
    Optional<CommentLike> findByCommentIdAndUserId(UUID commentId, UUID userId);

    long countByCommentId(UUID commentId);

    void deleteByCommentIdAndUserId(UUID commentId, UUID userId);
}
