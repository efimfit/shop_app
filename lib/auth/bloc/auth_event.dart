part of 'auth_bloc.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class AutoLoginSubmitted extends AuthEvent {
  const AutoLoginSubmitted();
}

class AutoLogoutSubmitted extends AuthEvent {
  const AutoLogoutSubmitted();
}

class LogoutSubmitted extends AuthEvent {
  const LogoutSubmitted();
}

class SignupSubmitted extends AuthEvent {
  const SignupSubmitted(this.email, this.password);

  final String email;
  final String password;
}

class LoginSubmitted extends AuthEvent {
  const LoginSubmitted(this.email, this.password);

  final String email;
  final String password;
}
