package com.example.corevo.service.impl;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import com.example.corevo.constant.ErrorMessage;
import com.example.corevo.domain.dto.pagination.PaginationRequestDto;
import com.example.corevo.domain.dto.pagination.PaginationResponseDto;
import com.example.corevo.domain.dto.pagination.PagingMeta;
import com.example.corevo.domain.dto.request.feed.CreatePostRequestDto;
import com.example.corevo.domain.dto.request.feed.UpdatePostRequestDto;
import com.example.corevo.domain.dto.response.feed.PostDetailResponseDto;
import com.example.corevo.domain.dto.response.feed.PostResponseDto;
import com.example.corevo.domain.dto.response.feed.PostStatsDto;
import com.example.corevo.domain.entity.feed.Post;
import com.example.corevo.domain.entity.feed.PostMedia;
import com.example.corevo.domain.entity.feed.PostPrivacy;
import com.example.corevo.domain.entity.user.User;
import com.example.corevo.domain.mapper.PostMapper;
import com.example.corevo.exception.VsException;
import com.example.corevo.repository.*;
import com.example.corevo.service.PostService;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class PostServiceImpl implements PostService {

    PostRepository postRepository;
    UserRepository userRepository;
    PostMediaRepository postMediaRepository;
    PostLikeRepository postLikeRepository;
    PostCommentRepository postCommentRepository;
    PostMapper postMapper;
    Cloudinary cloudinary;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public PostResponseDto createPost(UUID userId, CreatePostRequestDto request) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new VsException(HttpStatus.NOT_FOUND, ErrorMessage.User.ERR_USER_NOT_EXISTED));

        Post post = postMapper.toPost(request);
        post.setUser(user);
        post.setViewCount(0);
        post.setIsEdited(false);
        post.setIsDeleted(false);

        Post savedPost = postRepository.save(post);

        // Handle media upload
        if (request.getMediaFiles() != null && !request.getMediaFiles().isEmpty()) {
            int orderIndex = 0;
            for (MultipartFile file : request.getMediaFiles()) {
                uploadMedia(savedPost, file, orderIndex++);
            }
        }

        return getPostResponseDto(savedPost, userId);
    }

    @Override
    public PostDetailResponseDto getPostById(UUID postId, UUID currentUserId) {
        Post post = postRepository.findById(postId)
                .filter(p -> !p.getIsDeleted())
                .orElseThrow(() -> new VsException(HttpStatus.NOT_FOUND, ErrorMessage.Post.ERR_POST_NOT_FOUND));

        // TODO: Check privacy access (if PRIVATE and not owner, throw error)
        if (post.getPrivacy() == PostPrivacy.PRIVATE && !post.getUser().getId().equals(currentUserId)) {
            throw new VsException(HttpStatus.FORBIDDEN, ErrorMessage.Post.ERR_POST_NOT_BELONG_TO_USER);
        }

        PostResponseDto baseDto = getPostResponseDto(post, currentUserId);
        PostDetailResponseDto detailDto = new PostDetailResponseDto();
        // Manual mapping from baseDto
        detailDto.setId(baseDto.getId());
        detailDto.setAuthor(baseDto.getAuthor());
        detailDto.setContent(baseDto.getContent());
        detailDto.setPrivacy(baseDto.getPrivacy());
        detailDto.setMedia(baseDto.getMedia());
        detailDto.setStats(baseDto.getStats());
        detailDto.setIsLikedByCurrentUser(baseDto.getIsLikedByCurrentUser());
        detailDto.setIsDislikedByCurrentUser(baseDto.getIsDislikedByCurrentUser());
        detailDto.setIsEdited(baseDto.getIsEdited());
        detailDto.setCreatedAt(baseDto.getCreatedAt());
        detailDto.setUpdatedAt(baseDto.getUpdatedAt());
        detailDto.setHashtags(baseDto.getHashtags());
        detailDto.setMentions(baseDto.getMentions());

        return detailDto;
    }

    @Override
    public PaginationResponseDto<PostResponseDto> getAllPosts(UUID currentUserId, PaginationRequestDto request) {
        Pageable pageable = PageRequest.of(request.getPageNum(), request.getPageSize());
        Page<Post> postPage = postRepository.findAllByIsDeletedFalseOrderByCreatedAtDesc(pageable);

        return toPaginationResponseDto(postPage, currentUserId);
    }

    @Override
    public PaginationResponseDto<PostResponseDto> getPostsByUserId(UUID userId, UUID currentUserId,
            PaginationRequestDto request) {
        Pageable pageable = PageRequest.of(request.getPageNum(), request.getPageSize());
        Page<Post> postPage = postRepository.findByUserIdAndIsDeletedFalse(userId, pageable);

        return toPaginationResponseDto(postPage, currentUserId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public PostResponseDto updatePost(UUID postId, UUID userId, UpdatePostRequestDto request) {
        Post post = postRepository.findById(postId)
                .filter(p -> !p.getIsDeleted())
                .orElseThrow(() -> new VsException(HttpStatus.NOT_FOUND, ErrorMessage.Post.ERR_POST_NOT_FOUND));

        if (!post.getUser().getId().equals(userId)) {
            throw new VsException(HttpStatus.FORBIDDEN, ErrorMessage.Post.ERR_POST_NOT_BELONG_TO_USER);
        }

        postMapper.updatePostFromDto(request, post);
        Post updatedPost = postRepository.save(post);

        return getPostResponseDto(updatedPost, userId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deletePost(UUID postId, UUID userId) {
        Post post = postRepository.findById(postId)
                .filter(p -> !p.getIsDeleted())
                .orElseThrow(() -> new VsException(HttpStatus.NOT_FOUND, ErrorMessage.Post.ERR_POST_NOT_FOUND));

        if (!post.getUser().getId().equals(userId)) {
            throw new VsException(HttpStatus.FORBIDDEN, ErrorMessage.Post.ERR_POST_NOT_BELONG_TO_USER);
        }

        post.setIsDeleted(true);
        post.setDeletedAt(java.time.LocalDateTime.now());
        postRepository.save(post);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public PostResponseDto likePost(UUID postId, UUID userId, Boolean isLike) {
        // Logic for like/dislike in PostLikeRepository
        // ... omitted for brevity in this step, will implement fully
        return getPostResponseDto(postRepository.findById(postId).get(), userId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void unlikePost(UUID postId, UUID userId) {
        postLikeRepository.deleteByPostIdAndUserId(postId, userId);
    }

    @Override
    public PaginationResponseDto<PostResponseDto> searchPosts(String keyword, UUID currentUserId,
            PaginationRequestDto request) {
        Pageable pageable = PageRequest.of(request.getPageNum(), request.getPageSize());
        Page<Post> postPage = postRepository.findByContentContainingAndIsDeletedFalse(keyword, pageable);
        return toPaginationResponseDto(postPage, currentUserId);
    }

    @Override
    public PaginationResponseDto<PostResponseDto> getPostsByHashtag(String hashtag, UUID currentUserId,
            PaginationRequestDto request) {
        // Simple search in content for now
        return searchPosts("#" + hashtag, currentUserId, request);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void incrementViewCount(UUID postId) {
        postRepository.findById(postId).ifPresent(post -> {
            post.setViewCount(post.getViewCount() + 1);
            postRepository.save(post);
        });
    }

    private void uploadMedia(Post post, MultipartFile file, int orderIndex) {
        try {
            Map<?, ?> uploadResult = cloudinary.uploader().upload(file.getBytes(), ObjectUtils.emptyMap());
            PostMedia media = PostMedia.builder()
                    .post(post)
                    .mediaUrl((String) uploadResult.get("secure_url"))
                    .mediaPublicId((String) uploadResult.get("public_id"))
                    .mediaType(com.example.corevo.domain.entity.feed.MediaType.IMAGE) // Detect type if needed
                    .orderIndex(orderIndex)
                    .build();
            postMediaRepository.save(media);
        } catch (IOException e) {
            throw new VsException(HttpStatus.INTERNAL_SERVER_ERROR, ErrorMessage.ERR_UPLOAD_IMAGE_FAIL);
        }
    }

    private PostResponseDto getPostResponseDto(Post post, UUID currentUserId) {
        PostResponseDto dto = postMapper.toPostResponseDto(post);

        // Stats
        PostStatsDto stats = new PostStatsDto();
        stats.setLikeCount((int) postLikeRepository.countByPostIdAndIsLikeTrue(post.getId()));
        stats.setDislikeCount((int) postLikeRepository.countByPostIdAndIsLikeFalse(post.getId()));
        stats.setCommentCount((int) postCommentRepository.countByPostIdAndIsDeletedFalse(post.getId()));
        stats.setViewCount(post.getViewCount());
        dto.setStats(stats);

        // User status
        if (currentUserId != null) {
            postLikeRepository.findByPostIdAndUserId(post.getId(), currentUserId).ifPresent(like -> {
                dto.setIsLikedByCurrentUser(like.getIsLike());
                dto.setIsDislikedByCurrentUser(!like.getIsLike());
            });
        }

        return dto;
    }

    private PaginationResponseDto<PostResponseDto> toPaginationResponseDto(Page<Post> page, UUID currentUserId) {
        List<PostResponseDto> items = page.getContent().stream()
                .map(post -> getPostResponseDto(post, currentUserId))
                .collect(Collectors.toList());

        PagingMeta meta = new PagingMeta(
                page.getTotalElements(),
                page.getTotalPages(),
                page.getNumber() + 1,
                page.getSize(),
                null, null);

        return new PaginationResponseDto<>(meta, items);
    }
}
