package com.example.corevo.domain.dto.pagination;

import com.example.corevo.constant.CommonConstant;
import io.swagger.v3.oas.annotations.Parameter;
import lombok.*;
import lombok.experimental.FieldDefaults;

@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@FieldDefaults(level = AccessLevel.PRIVATE)
public class PaginationRequestDto {

    @Parameter(description = "Page you want to retrieve (0..N)")
    Integer pageNum = CommonConstant.ZERO_INT_VALUE;

    @Parameter(description = "Number of records per page.")
    Integer pageSize = CommonConstant.PAGE_SIZE_DEFAULT;

    public int getPageNum() {
        if (pageNum == null || pageNum < 1) {
            pageNum = CommonConstant.ONE_INT_VALUE;
        }
        return pageNum - 1;
    }

    public int getPageSize() {
        if (pageSize == null || pageSize < 1 || pageSize > 10) {
            pageSize = CommonConstant.PAGE_SIZE_DEFAULT;
        }
        return pageSize;
    }
}
