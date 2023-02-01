// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

enum AuthStatus { initial, loading, success, failed }

class AuthState {
  const AuthState({
    this.token,
    this.expiryDate,
    this.userId,
    this.authTimer,
    this.status = AuthStatus.initial,
  });
  final String? token;
  final DateTime? expiryDate;
  final String? userId;
  final Timer? authTimer;
  final AuthStatus status;

  bool get isAuth {
    return token != null;
  }

  String? get getToken {
    if (expiryDate != null && expiryDate!.isAfter(DateTime.now())) {
      return token;
    }
    return null;
  }

  AuthState initialState() {
    return const AuthState();
  }

  AuthState copyWith({
    String? token,
    DateTime? expiryDate,
    String? userId,
    Timer? authTimer,
    AuthStatus? status,
  }) {
    return AuthState(
      token: token ?? this.token,
      expiryDate: expiryDate ?? this.expiryDate,
      userId: userId ?? this.userId,
      authTimer: authTimer ?? this.authTimer,
      status: status ?? this.status,
    );
  }
}
