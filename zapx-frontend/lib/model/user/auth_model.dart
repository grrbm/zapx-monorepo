class AuthModelResponse {
  final String message;
  final ResponseData response;

  AuthModelResponse({required this.message, required this.response});

  factory AuthModelResponse.fromJson(Map<String, dynamic> json) {
    return AuthModelResponse(
      message: json['message'],
      response: ResponseData.fromJson(json['response']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'response': response.toJson(),
    };
  }
}

class ResponseData {
  final String token;
  final User user;

  ResponseData({required this.token, required this.user});

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      token: json['token'],
      user: User.fromJson(json['User']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'User': user.toJson(),
    };
  }
}

class User {
  final int id;
  final String role;
  final String email;
  final String? name;

  User(
      {required this.id,
      required this.role,
      required this.email,
      required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      role: json['role'],
      name: json['fullName'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'email': email,
      'fullName': name,
    };
  }
}
