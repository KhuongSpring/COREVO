package com.example.corevo.service.impl;

import com.example.corevo.constant.ErrorMessage;
import com.example.corevo.domain.dto.pagination.PaginationRequestDto;
import com.example.corevo.domain.dto.pagination.PaginationResponseDto;
import com.example.corevo.domain.dto.pagination.PagingMeta;
import com.example.corevo.domain.dto.request.feed.CreateCommentRequestDto;
import com.example.corevo.domain.dto.response.feed.CommentResponseDto;
import com.example.corevo.domain.entity.feed.CommentLike;
import com.example.corevo.domain.entity.feed.Post;
import com.example.corevo.domain.entity.feed.PostComment;
import com.example.corevo.domain.entity.user.User;
import com.example.corevo.domain.mapper.CommentMapper;
import com.example.corevo.exception.VsException;
import com.example.corevo.repository.PostCommentLikeRepository;
import com.example.corevo.repository.PostCommentRepository;
import com.example.corevo.repository.PostRepository;
import com.example.corevo.repository.UserRepository;
import com.example.corevo.service.CommentService;
import lombok.AccessLevel;
import lombok.RequiredArgsConstructor;
import lombok.experimental.FieldDefaults;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE, makeFinal = true)
public class CommentServiceImpl implements CommentService {

    PostCommentRepository postCommentRepository;
    PostRepository postRepository;
    UserRepository userRepository;
    PostCommentLikeRepository postCommentLikeRepository;
    CommentMapper commentMapper;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public CommentResponseDto createComment(UUID postId, UUID userId, CreateCommentRequestDto request) {
        Post post = postRepository.findById(postId)
                .filter(p -> !p.getIsDeleted())
                .orElseThrow(() -> new VsException(HttpStatus.NOT_FOUND, ErrorMessage.Post.ERR_POST_NOT_FOUND));

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new VsException(HttpStatus.NOT_FOUND, ErrorMessage.User.ERR_USER_NOT_EXISTED));

        PostComment comment = commentMapper.toPostComment(request);
        comment.setPost(post);
        comment.setUser(user);
        comment.setIsEdited(false);
        comment.setIsDeleted(false);

        if (request.getParentCommentId() != null) {
            PostComment parent = postCommentRepository.findById(UUID.fromString(request.getParentCommentId()))
                    .orElseThrow(() -> new VsException(HttpStatus.NOT_FOUND,
                            ErrorMessage.Comment.ERR_PARENT_COMMENT_NOT_FOUND));
            comment.setParentComment(parent);
        }

        PostComment savedComment = postCommentRepository.save(comment);
        return getCommentResponseDto(savedComment, userId);
    }

    @Override
    public CommentResponseDto getCommentById(UUID commentId, UUID currentUserId) {
        PostComment comment = postCommentRepository.findById(commentId)
                .filter(c -> !c.getIsDeleted())
                .orElseThrow(() -> new VsException(HttpStatus.NOT_FOUND, ErrorMessage.Comment.ERR_COMMENT_NOT_FOUND));

        return getCommentResponseDto(comment, currentUserId);
    }

    @Override
    public PaginationResponseDto<CommentResponseDto> getCommentsByPostId(UUID postId, UUID currentUserId,
            PaginationRequestDto request) {
        Pageable pageable = PageRequest.of(request.getPageNum(), request.getPageSize());
        Page<PostComment> commentPage = postCommentRepository.findByPostIdAndIsDeletedFalseOrderByCreatedAtDesc(postId,
                pageable);

        return toPaginationResponseDto(commentPage, currentUserId);
    }

    @Override
    public PaginationResponseDto<CommentResponseDto> getRepliesByCommentId(UUID commentId, UUID currentUserId,
            PaginationRequestDto request) {
        Pageable pageable = PageRequest.of(request.getPageNum(), request.getPageSize());
        Page<PostComment> replyPage = postCommentRepository
                .findByParentCommentIdAndIsDeletedFalseOrderByCreatedAtAsc(commentId, pageable);

        return toPaginationResponseDto(replyPage, currentUserId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public CommentResponseDto updateComment(UUID commentId, UUID userId, String newContent) {
        PostComment comment = postCommentRepository.findById(commentId)
                .filter(c -> !c.getIsDeleted())
                .orElseThrow(() -> new VsException(HttpStatus.NOT_FOUND, ErrorMessage.Comment.ERR_COMMENT_NOT_FOUND));

        if (!comment.getUser().getId().equals(userId)) {
            throw new VsException(HttpStatus.FORBIDDEN, ErrorMessage.Comment.ERR_COMMENT_NOT_BELONG_TO_USER);
        }

        comment.setContent(newContent);
        comment.setIsEdited(true);
        PostComment updatedComment = postCommentRepository.save(comment);

        return getCommentResponseDto(updatedComment, userId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteComment(UUID commentId, UUID userId) {
        PostComment comment = postCommentRepository.findById(commentId)
                .filter(c -> !c.getIsDeleted())
                .orElseThrow(() -> new VsException(HttpStatus.NOT_FOUND, ErrorMessage.Comment.ERR_COMMENT_NOT_FOUND));

        if (!comment.getUser().getId().equals(userId)) {
            throw new VsException(HttpStatus.FORBIDDEN, ErrorMessage.Comment.ERR_COMMENT_NOT_BELONG_TO_USER);
        }

        comment.setIsDeleted(true);
        comment.setDeletedAt(java.time.LocalDateTime.now());
        postCommentRepository.save(comment);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public CommentResponseDto likeComment(UUID commentId, UUID userId) {
        PostComment comment = postCommentRepository.findById(commentId)
                .filter(c -> !c.getIsDeleted())
                .orElseThrow(() -> new VsException(HttpStatus.NOT_FOUND, ErrorMessage.Comment.ERR_COMMENT_NOT_FOUND));

        User user = userRepository.findById(userId).get();

        if (postCommentLikeRepository.findByCommentIdAndUserId(commentId, userId).isEmpty()) {
            CommentLike like = CommentLike.builder()
                    .comment(comment)
                    .user(user)
                    .build();
            postCommentLikeRepository.save(like);
        }

        return getCommentResponseDto(comment, userId);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void unlikeComment(UUID commentId, UUID userId) {
        postCommentLikeRepository.deleteByCommentIdAndUserId(commentId, userId);
    }

    private CommentResponseDto getCommentResponseDto(PostComment comment, UUID currentUserId) {
        CommentResponseDto dto = commentMapper.toCommentResponseDto(comment);
        dto.setLikeCount((int) postCommentLikeRepository.countByCommentId(comment.getId()));
        dto.setReplyCount((int) postCommentRepository.countByPostIdAndIsDeletedFalse(comment.getId()));
        if (currentUserId != null) {
            dto.setIsLikedByCurrentUser(
                    postCommentLikeRepository.findByCommentIdAndUserId(comment.getId(), currentUserId).isPresent());
        }

        return dto;
    }

    private PaginationResponseDto<CommentResponseDto> toPaginationResponseDto(Page<PostComment> page,
            UUID currentUserId) {
        List<CommentResponseDto> items = page.getContent().stream()
                .map(comment -> getCommentResponseDto(comment, currentUserId))
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
