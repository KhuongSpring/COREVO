class DefaultResponse {
  final String status;

  DefaultResponse({required this.status});

  factory DefaultResponse.fromJson(Map<String, dynamic> json) {
    return DefaultResponse(
      status: json['status'],
    );
  }
}
