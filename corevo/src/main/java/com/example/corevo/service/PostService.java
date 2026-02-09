package com.example.corevo.service;

import java.util.UUID;

import com.example.corevo.domain.dto.request.feed.CreatePostRequestDto;
import com.example.corevo.domain.dto.request.feed.UpdatePostRequestDto;
import com.example.corevo.domain.dto.response.feed.PostDetailResponseDto;
import com.example.corevo.domain.dto.response.feed.PostResponseDto;
import com.example.corevo.domain.dto.pagination.PaginationRequestDto;
import com.example.corevo.domain.dto.pagination.PaginationResponseDto;

public interface PostService {
    // CRUD operations
    PostResponseDto createPost(UUID userId, CreatePostRequestDto request);

    PostDetailResponseDto getPostById(UUID postId, UUID currentUserId);

    PaginationResponseDto<PostResponseDto> getAllPosts(UUID currentUserId, PaginationRequestDto request);

    PaginationResponseDto<PostResponseDto> getPostsByUserId(UUID userId, UUID currentUserId,
            PaginationRequestDto request);

    PostResponseDto updatePost(UUID postId, UUID userId, UpdatePostRequestDto request);

    void deletePost(UUID postId, UUID userId);

    // Interaction operations
    PostResponseDto likePost(UUID postId, UUID userId, Boolean isLike);

    void unlikePost(UUID postId, UUID userId);

    // Search & Filter
    PaginationResponseDto<PostResponseDto> searchPosts(String keyword, UUID currentUserId,
            PaginationRequestDto request);

    PaginationResponseDto<PostResponseDto> getPostsByHashtag(String hashtag, UUID currentUserId,
            PaginationRequestDto request);

    // View tracking
    void incrementViewCount(UUID postId);

}
