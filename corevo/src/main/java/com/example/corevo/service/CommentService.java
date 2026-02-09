package com.example.corevo.service;

import java.util.UUID;

import com.example.corevo.domain.dto.request.feed.CreateCommentRequestDto;
import com.example.corevo.domain.dto.response.feed.CommentResponseDto;
import com.example.corevo.domain.dto.pagination.PaginationRequestDto;
import com.example.corevo.domain.dto.pagination.PaginationResponseDto;

public interface CommentService {
    // CRUD operations
    CommentResponseDto createComment(UUID postId, UUID userId, CreateCommentRequestDto request);

    CommentResponseDto getCommentById(UUID commentId, UUID currentUserId);

    PaginationResponseDto<CommentResponseDto> getCommentsByPostId(UUID postId, UUID currentUserId,
            PaginationRequestDto request);

    PaginationResponseDto<CommentResponseDto> getRepliesByCommentId(UUID commentId, UUID currentUserId,
            PaginationRequestDto request);

    CommentResponseDto updateComment(UUID commentId, UUID userId, String newContent);

    void deleteComment(UUID commentId, UUID userId);

    // Interaction operations
    CommentResponseDto likeComment(UUID commentId, UUID userId);

    void unlikeComment(UUID commentId, UUID userId);

}
