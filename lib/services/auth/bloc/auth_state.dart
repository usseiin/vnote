import 'package:flutter/material.dart';
import 'package:vnote_app/services/auth/auth_user.dart';
import 'package:equatable/equatable.dart';

// State
@immutable
abstract class AuthState {
  final bool isLoading;
  final String? loadingText;
  const AuthState({
    required this.isLoading,
    this.loadingText = "Please wait a moment",
  });
}

class AuthStateUnInitialize extends AuthState {
  const AuthStateUnInitialize({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({
    required this.user,
    required bool isLoading,
  }) : super(isLoading: isLoading);
}

class AuthStateNeedVerification extends AuthState {
  const AuthStateNeedVerification({required bool isloading})
      : super(isLoading: isloading);
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;

  const AuthStateRegistering({
    required this.exception,
    required bool isLoading,
    String? loadngText,
  }) : super(
          isLoading: isLoading,
          loadingText: loadngText,
        );
}

class AuthStateForgetPassword extends AuthState {
  final Exception? exception;
  final bool hasSentEmail;

  const AuthStateForgetPassword({
    required this.exception,
    required this.hasSentEmail,
    required bool isLoading,
  }) : super(isLoading: isLoading);
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthStateLoggedOut({
    required this.exception,
    required bool isLoading,
    String? loadingText,
  }) : super(
          isLoading: isLoading,
          loadingText: loadingText,
        );

  @override
  List<Object?> get props => [exception, isLoading];
}
