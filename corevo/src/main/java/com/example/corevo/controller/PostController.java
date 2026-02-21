package com.example.corevo.controller;

import com.example.corevo.base.RestApiV1;
import com.example.corevo.base.RestData;
import com.example.corevo.base.VsResponseUtil;
import com.example.corevo.constant.SuccessMessage;
import com.example.corevo.constant.UrlConstant;
import com.example.corevo.domain.dto.pagination.PaginationRequestDto;
import com.example.corevo.domain.dto.pagination.PaginationResponseDto;
import com.example.corevo.domain.dto.request.feed.CreatePostRequestDto;
import com.example.corevo.domain.dto.request.feed.UpdatePostRequestDto;
import com.example.corevo.domain.dto.response.feed.PostDetailResponseDto;
import com.example.corevo.domain.dto.response.feed.PostResponseDto;
import com.example.corevo.service.PostService;
import com.example.corevo.security.SecurityUtils;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import jakarta.validation.Valid;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import lombok.extern.slf4j.Slf4j;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestApiV1
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
@Slf4j
public class PostController {

    PostService postService;

    @Operation(summary = "Tạo bài đăng", description = "Dùng để tạo bài đăng", security = @SecurityRequirement(name = "Bearer Token"))
    @PostMapping(UrlConstant.Feed.CREATE_POST)
    public ResponseEntity<RestData<PostResponseDto>> createPost(@Valid @ModelAttribute CreatePostRequestDto request) {
        UUID userId = SecurityUtils.getCurrentUserId();
        PostResponseDto response = postService.createPost(userId, request);
        return VsResponseUtil.success(response);
    }

    @Operation(summary = "Lấy bài đăng theo ID", description = "Dùng để lấy bài đăng theo ID")
    @GetMapping(UrlConstant.Feed.GET_POST_BY_ID)
    public ResponseEntity<RestData<PostDetailResponseDto>> getPostById(@PathVariable UUID id) {
        UUID currentUserId = null;
        try {
            currentUserId = SecurityUtils.getCurrentUserId();
        } catch (Exception e) {
            // Anonymous user
        }
        PostDetailResponseDto response = postService.getPostById(id, currentUserId);
        return VsResponseUtil.success(response);
    }

    @Operation(summary = "Lấy tất cả bài đăng", description = "Dùng để lấy tất cả bài đăng")
    @GetMapping(UrlConstant.Feed.GET_ALL_POST)
    public ResponseEntity<RestData<PaginationResponseDto<PostResponseDto>>> getAllPosts(
            @ModelAttribute PaginationRequestDto request) {
        UUID currentUserId = null;
        try {
            currentUserId = SecurityUtils.getCurrentUserId();
            log.info("currentUserId: {}", currentUserId);
        } catch (Exception e) {
            // Anonymous user
            log.info("Kakaa");
        }
        PaginationResponseDto<PostResponseDto> response = postService.getAllPosts(currentUserId, request);
        return VsResponseUtil.success(response);
    }

    @Operation(summary = "Lấy bài đăng của user", description = "Dùng để lấy bài đăng của user")
    @GetMapping(UrlConstant.Feed.GET_USER_POST)
    public ResponseEntity<RestData<PaginationResponseDto<PostResponseDto>>> getPostsByUserId(
            @PathVariable UUID userId,
            @ModelAttribute PaginationRequestDto request) {
        UUID currentUserId = null;
        try {
            currentUserId = SecurityUtils.getCurrentUserId();
        } catch (Exception e) {
            // Anonymous user
        }
        PaginationResponseDto<PostResponseDto> response = postService.getPostsByUserId(userId, currentUserId, request);
        return VsResponseUtil.success(response);
    }

    @Operation(summary = "Cập nhật bài đăng", description = "Dùng để cập nhật bài đăng", security = @SecurityRequirement(name = "Bearer Token"))
    @PutMapping(UrlConstant.Feed.UPDATE_POST)
    public ResponseEntity<RestData<PostResponseDto>> updatePost(
            @PathVariable UUID id,
            @Valid @RequestBody UpdatePostRequestDto request) {
        UUID userId = SecurityUtils.getCurrentUserId();
        PostResponseDto response = postService.updatePost(id, userId, request);
        return VsResponseUtil.success(response);
    }

    @Operation(summary = "Xóa bài đăng", description = "Dùng để xóa bài đăng", security = @SecurityRequirement(name = "Bearer Token"))
    @DeleteMapping(UrlConstant.Feed.DELETE_POST)
    public ResponseEntity<RestData<String>> deletePost(@PathVariable UUID id) {
        UUID userId = SecurityUtils.getCurrentUserId();
        postService.deletePost(id, userId);
        return VsResponseUtil.success(SuccessMessage.Post.DELETE_POST_SUCCESS);
    }

    @Operation(summary = "Thích/Bỏ thích bài đăng", description = "Dùng để thích/bỏ thích bài đăng", security = @SecurityRequirement(name = "Bearer Token"))
    @PostMapping(UrlConstant.Feed.POST_LIKE)
    public ResponseEntity<RestData<PostResponseDto>> likePost(
            @PathVariable UUID id,
            @RequestParam Boolean isLike) {
        UUID userId = SecurityUtils.getCurrentUserId();
        PostResponseDto response = postService.likePost(id, userId, isLike);
        return VsResponseUtil.success(response);
    }

    @Operation(summary = "Bỏ thích bài đăng", description = "Dùng để bỏ thích bài đăng", security = @SecurityRequirement(name = "Bearer Token"))
    @DeleteMapping(UrlConstant.Feed.POST_UNLIKE)
    public ResponseEntity<RestData<String>> unlikePost(@PathVariable UUID id) {
        UUID userId = SecurityUtils.getCurrentUserId();
        postService.unlikePost(id, userId);
        return VsResponseUtil.success(SuccessMessage.Post.UNLIKE_POST_SUCCESS);
    }

    @Operation(summary = "Tìm kiếm bài đăng", description = "Dùng để tìm kiếm bài đăng")
    @GetMapping(UrlConstant.Feed.SEARCH_POST)
    public ResponseEntity<RestData<PaginationResponseDto<PostResponseDto>>> searchPosts(
            @RequestParam String keyword,
            @ModelAttribute PaginationRequestDto request) {
        UUID currentUserId = null;
        try {
            currentUserId = SecurityUtils.getCurrentUserId();
        } catch (Exception e) {
            // Anonymous user
        }
        PaginationResponseDto<PostResponseDto> response = postService.searchPosts(keyword, currentUserId, request);
        return VsResponseUtil.success(response);
    }
}
