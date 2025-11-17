class User {
  String id;
  String name;
  String email;
  bool isAdmin;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.isAdmin,
  });

  // تحويل من JSON إلى كائن User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      isAdmin: json['isAdmin'],
    );
  }

  // تحويل من كائن User إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'isAdmin': isAdmin,
    };
  }
}

class LoginResponse {
  String message;
  String token;
  User user;

  LoginResponse({
    required this.message,
    required this.token,
    required this.user,
  });

  // تحويل من JSON إلى كائن LoginResponse
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'],
      token: json['token'],
      user: User.fromJson(json['user']),
    );
  }

  // تحويل من كائن LoginResponse إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'token': token,
      'user': user.toJson(),
    };
  }
}
