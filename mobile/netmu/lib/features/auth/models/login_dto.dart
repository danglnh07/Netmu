class LoginRequest {
  final String username;
  final String password;

  const LoginRequest({required this.username, required this.password});

  Map<String, dynamic> toJson() {
    return {"username": username, "password": password};
  }
}

class LoginResponse {
  final String accessToken;
  final String refreshToken;

  const LoginResponse({required this.accessToken, required this.refreshToken});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }
}

class ChangePassword {
  final String oldPassword;
  final String newPassword;

  const ChangePassword({required this.oldPassword, required this.newPassword});

  Map<String, dynamic> toJson() {
    return {"oldPassword": oldPassword, "newPassword": newPassword};
  }
}