package com.example.corevo.domain.mapper;

import com.example.corevo.domain.dto.request.feed.CreateCommentRequestDto;
import com.example.corevo.domain.dto.response.feed.CommentResponseDto;
import com.example.corevo.domain.dto.response.feed.UserBasicInfoResponseDto;
import com.example.corevo.domain.entity.feed.PostComment;
import com.example.corevo.domain.entity.user.User;
import org.mapstruct.*;

import java.util.List;

@Mapper(componentModel = "spring", nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE, nullValueCheckStrategy = NullValueCheckStrategy.ALWAYS)
public interface CommentMapper {

    @Mapping(target = "author", source = "user")
    @Mapping(target = "likeCount", ignore = true)
    @Mapping(target = "isLikedByCurrentUser", ignore = true)
    @Mapping(target = "replyCount", ignore = true)
    @Mapping(target = "replies", ignore = true)
    CommentResponseDto toCommentResponseDto(PostComment comment);

    UserBasicInfoResponseDto toUserBasicInfoResponseDto(User user);

    List<CommentResponseDto> toCommentResponseDtoList(List<PostComment> comments);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "post", ignore = true)
    @Mapping(target = "user", ignore = true)
    @Mapping(target = "parentComment", ignore = true)
    @Mapping(target = "replies", ignore = true)
    @Mapping(target = "isEdited", ignore = true)
    @Mapping(target = "createdAt", ignore = true)
    @Mapping(target = "updatedAt", ignore = true)
    @Mapping(target = "deletedAt", ignore = true)
    @Mapping(target = "isDeleted", ignore = true)
    @Mapping(target = "likes", ignore = true)
    PostComment toPostComment(CreateCommentRequestDto request);
}
