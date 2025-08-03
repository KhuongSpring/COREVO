class DefaultResponse<T> {
  final String status;
  final T data;

  DefaultResponse({required this.status, required this.data});

  factory DefaultResponse.fromJson(Map<String, dynamic> json) {
    return DefaultResponse(
      status: json['status'],
      data: json['data']
    );
  }
}
