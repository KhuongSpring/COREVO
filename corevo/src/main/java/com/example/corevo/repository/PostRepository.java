package com.example.corevo.repository;

import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.corevo.domain.entity.feed.Post;
import com.example.corevo.domain.entity.feed.PostPrivacy;

@Repository
public interface PostRepository extends JpaRepository<Post, UUID> {
    Page<Post> findAllByIsDeletedFalseOrderByCreatedAtDesc(Pageable pageable);

    Page<Post> findByUserIdAndIsDeletedFalse(UUID userId, Pageable pageable);

    Page<Post> findByPrivacyAndIsDeletedFalse(PostPrivacy privacy, Pageable pageable);

    Page<Post> findByContentContainingAndIsDeletedFalse(String keyword, Pageable pageable);

}
