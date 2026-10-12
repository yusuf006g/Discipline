abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String username;
  final String password;

  LoginEvent({
    required this.username,
    required this.password,
  });
}

class RegisterEvent extends AuthEvent {
  final String username;
  final String email;
  final String password;
  final String password2;

  RegisterEvent({
    required this.username,
    required this.email,
    required this.password,
    required this.password2,
  });
}