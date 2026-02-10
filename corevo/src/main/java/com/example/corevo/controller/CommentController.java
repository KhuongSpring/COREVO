package com.example.corevo.controller;

import com.example.corevo.base.RestApiV1;
import com.example.corevo.base.RestData;
import com.example.corevo.base.VsResponseUtil;
import com.example.corevo.constant.SuccessMessage;
import com.example.corevo.constant.UrlConstant;
import com.example.corevo.domain.dto.pagination.PaginationRequestDto;
import com.example.corevo.domain.dto.pagination.PaginationResponseDto;
import com.example.corevo.domain.dto.request.feed.CreateCommentRequestDto;
import com.example.corevo.domain.dto.response.feed.CommentResponseDto;
import com.example.corevo.service.CommentService;
import com.example.corevo.security.SecurityUtils;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import jakarta.validation.Valid;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestApiV1
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class CommentController {

    CommentService commentService;

    @Operation(summary = "Tạo bình luận", description = "Dùng để tạo bình luận", security = @SecurityRequirement(name = "Bearer Token"))
    @PostMapping(UrlConstant.Feed.CREATE_COMMENT)
    public ResponseEntity<RestData<CommentResponseDto>> createComment(
            @PathVariable UUID postId,
            @Valid @RequestBody CreateCommentRequestDto request) {
        UUID userId = SecurityUtils.getCurrentUserId();
        CommentResponseDto response = commentService.createComment(postId, userId, request);
        return VsResponseUtil.success(response);
    }

    @Operation(summary = "Lấy tất cả bình luận", description = "Dùng để lấy tất cả bình luận")
    @GetMapping(UrlConstant.Feed.GET_COMMENT_BY_POST_ID)
    public ResponseEntity<RestData<PaginationResponseDto<CommentResponseDto>>> getCommentsByPostId(
            @PathVariable UUID postId,
            @ModelAttribute PaginationRequestDto request) {
        UUID currentUserId = null;
        try {
            currentUserId = SecurityUtils.getCurrentUserId();
        } catch (Exception e) {
            // Anonymous user
        }
        PaginationResponseDto<CommentResponseDto> response = commentService.getCommentsByPostId(postId, currentUserId,
                request);
        return VsResponseUtil.success(response);
    }

    @Operation(summary = "Lấy bình luận theo id", description = "Dùng để lấy bình luận theo id")
    @GetMapping(UrlConstant.Feed.GET_COMMENT_BY_ID)
    public ResponseEntity<RestData<CommentResponseDto>> getCommentById(@PathVariable UUID id) {
        UUID currentUserId = null;
        try {
            currentUserId = SecurityUtils.getCurrentUserId();
        } catch (Exception e) {
            // Anonymous user
        }
        CommentResponseDto response = commentService.getCommentById(id, currentUserId);
        return VsResponseUtil.success(response);
    }

    @Operation(summary = "Lấy bình luận trả lời", description = "Dùng để lấy bình luận trả lời")
    @GetMapping(UrlConstant.Feed.GET_COMMENT_REPLIES)
    public ResponseEntity<RestData<PaginationResponseDto<CommentResponseDto>>> getRepliesByCommentId(
            @PathVariable UUID id,
            @ModelAttribute PaginationRequestDto request) {
        UUID currentUserId = null;
        try {
            currentUserId = SecurityUtils.getCurrentUserId();
        } catch (Exception e) {
            // Anonymous user
        }
        PaginationResponseDto<CommentResponseDto> response = commentService.getRepliesByCommentId(id, currentUserId,
                request);
        return VsResponseUtil.success(response);
    }

    @Operation(summary = "Cập nhật bình luận", description = "Dùng để cập nhật bình luận", security = @SecurityRequirement(name = "Bearer Token"))
    @PutMapping(UrlConstant.Feed.UPDATE_COMMENT)
    public ResponseEntity<RestData<CommentResponseDto>> updateComment(
            @PathVariable UUID id,
            @RequestParam String content) {
        UUID userId = SecurityUtils.getCurrentUserId();
        CommentResponseDto response = commentService.updateComment(id, userId, content);
        return VsResponseUtil.success(response);
    }

    @Operation(summary = "Xóa bình luận", description = "Dùng để xóa bình luận", security = @SecurityRequirement(name = "Bearer Token"))
    @DeleteMapping(UrlConstant.Feed.DELETE_COMMENT)
    public ResponseEntity<RestData<String>> deleteComment(@PathVariable UUID id) {
        UUID userId = SecurityUtils.getCurrentUserId();
        commentService.deleteComment(id, userId);
        return VsResponseUtil.success(SuccessMessage.Comment.DELETE_COMMENT_SUCCESS);
    }

    @Operation(summary = "Thích bình luận", description = "Dùng để thích bình luận", security = @SecurityRequirement(name = "Bearer Token"))
    @PostMapping(UrlConstant.Feed.COMMENT_LIKE)
    public ResponseEntity<RestData<CommentResponseDto>> likeComment(@PathVariable UUID id) {
        UUID userId = SecurityUtils.getCurrentUserId();
        CommentResponseDto response = commentService.likeComment(id, userId);
        return VsResponseUtil.success(response);
    }

    @Operation(summary = "Bỏ thích bình luận", description = "Dùng để bỏ thích bình luận", security = @SecurityRequirement(name = "Bearer Token"))
    @DeleteMapping(UrlConstant.Feed.COMMENT_UNLIKE)
    public ResponseEntity<RestData<String>> unlikeComment(@PathVariable UUID id) {
        UUID userId = SecurityUtils.getCurrentUserId();
        commentService.unlikeComment(id, userId);
        return VsResponseUtil.success(SuccessMessage.Comment.UNLIKE_COMMENT_SUCCESS);
    }
}
