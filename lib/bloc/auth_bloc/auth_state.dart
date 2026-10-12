abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class LoginSuccess extends AuthState {
  final String access;
  final String refresh;

  LoginSuccess({
    required this.access,
    required this.refresh,
  });
}

class RegisterSuccess extends AuthState {
  final String username;
  final String email;

  RegisterSuccess({
    required this.username,
    required this.email,
  });
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}