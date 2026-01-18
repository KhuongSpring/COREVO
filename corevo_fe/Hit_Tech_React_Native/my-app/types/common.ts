/**
 * Common TypeScript types used across the app
 */

// API Response wrapper
export interface ApiResponse<T = any> {
    status: 'SUCCESS' | 'ERROR' | 'FAIL';
    message?: string;
    data: T;
    error?: string;
}

// Pagination
export interface PaginationParams {
    page: number;
    pageSize: number;
}

export interface PaginatedResponse<T> {
    items: T[];
    total: number;
    page: number;
    pageSize: number;
    totalPages: number;
}

// Error response
export interface ErrorResponse {
    status: 'ERROR' | 'FAIL';
    message: string;
    error?: string;
    code?: string;
}

// Date range
export interface DateRange {
    startDate: string;
    endDate: string;
}

// ID param
export interface IdParam {
    id: number | string;
}
