package com.example.corevo.repository;

import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.corevo.domain.entity.feed.PostComment;

@Repository
public interface PostCommentRepository extends JpaRepository<PostComment, UUID> {
    Page<PostComment> findByPostIdAndIsDeletedFalseOrderByCreatedAtDesc(UUID postId, Pageable pageable);

    Page<PostComment> findByParentCommentIdAndIsDeletedFalseOrderByCreatedAtAsc(UUID parentId, Pageable pageable);

    long countByPostIdAndIsDeletedFalse(UUID postId);
}
