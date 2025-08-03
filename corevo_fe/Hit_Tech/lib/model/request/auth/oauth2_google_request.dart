class Oauth2GoogleRequest {
  final String idToken;

  Oauth2GoogleRequest({required this.idToken});

  Map<String, dynamic> toJson() {
    return {'idToken': idToken};
  }
}
