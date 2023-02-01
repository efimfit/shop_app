import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shop_app/auth/auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthState()) {
    on<SignupSubmitted>(_onSignupSubmitted);
    on<AutoLoginSubmitted>(_onAutoLoginSubmitted);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<AutoLogoutSubmitted>(_onAutoLogoutSubmitted);
    on<LogoutSubmitted>(_onLogoutSubmitted);
  }

  final AuthRepository _authRepository;

  Future<void> _onSignupSubmitted(
      SignupSubmitted event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final Map<String, Object> authData = await _authRepository.autheticate(
        event.email, event.password, 'signUp');
    emit(state.copyWith(
      token: authData['token'] as String,
      userId: authData['userId'] as String,
      expiryDate: authData['expiryDate'] as DateTime,
      status: AuthStatus.success,
    ));
    add(const AutoLogoutSubmitted());
  }

  Future<void> _onAutoLoginSubmitted(
      AutoLoginSubmitted event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final extractedData = await _authRepository.fetchSharedPreferences();
    if (extractedData.isEmpty) {
      emit(state.copyWith(status: AuthStatus.failed));
    } else {
      emit(state.copyWith(
        token: extractedData['token'],
        userId: extractedData['userId'],
        expiryDate: DateTime.parse(extractedData['expiryDate']),
        status: AuthStatus.success,
      ));
      add(const AutoLogoutSubmitted());
    }
  }

  Future<void> _onLoginSubmitted(
      LoginSubmitted event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final Map<String, Object> authData = await _authRepository.autheticate(
        event.email, event.password, 'signInWithPassword');
    emit(state.copyWith(
      token: authData['token'] as String,
      userId: authData['userId'] as String,
      expiryDate: authData['expiryDate'] as DateTime,
      status: AuthStatus.success,
    ));
    add(const AutoLogoutSubmitted());
  }

  void _onAutoLogoutSubmitted(
      AutoLogoutSubmitted event, Emitter<AuthState> emit) {
    if (state.authTimer != null) {
      state.authTimer!.cancel();
    }
    final timeToExpiry = state.expiryDate!.difference(DateTime.now()).inSeconds;
    emit(state.copyWith(
        authTimer: Timer(Duration(seconds: timeToExpiry),
            () => add(const LogoutSubmitted()))));
  }

  Future<void> _onLogoutSubmitted(
      LogoutSubmitted event, Emitter<AuthState> emit) async {
    if (state.authTimer != null) {
      state.authTimer!.cancel();
    }

    emit(state.initialState());
    await _authRepository.clearSharedPreferences();
  }
}
