import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthLoggedIn extends AuthState {
  final User user;
  AuthLoggedIn(this.user);
}

class AuthResetPasswordSuccess extends AuthState {
  final String message;
  AuthResetPasswordSuccess(this.message);
}

class AuthSuccess extends AuthState {
  final String message;
  AuthSuccess(this.message);
}

class AuthLoggedOut extends AuthState {}
