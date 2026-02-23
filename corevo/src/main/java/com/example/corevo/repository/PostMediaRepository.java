package com.example.corevo.repository;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.corevo.domain.entity.feed.PostMedia;

@Repository
public interface PostMediaRepository extends JpaRepository<PostMedia, UUID> {
    List<PostMedia> findByPostIdOrderByOrderIndex(UUID postId);

    void deleteByPostId(UUID postId);
}
