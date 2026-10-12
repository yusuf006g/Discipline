class RegisterModel {
  final String username;
  final String email;
  final String password;
  final String password2;

  RegisterModel({
    required this.username,
    required this.email,
    required this.password,
    required this.password2,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'password2': password2,
    };
  }
}