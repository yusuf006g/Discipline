class RegisterResponseModel {
  final String username;
  final String email;

  RegisterResponseModel({
    required this.username,
    required this.email,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
    );
  }
}