import 'package:flutter/material.dart';
import 'package:vnote_app/services/auth/auth_user.dart';
import 'package:equatable/equatable.dart';

// State
@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateUnInitialize extends AuthState {
  const AuthStateUnInitialize();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

class AuthStateNeedVerification extends AuthState {
  const AuthStateNeedVerification();
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering(this.exception);
}

class AuthStateLoggedOut extends AuthState with EquatableMixin{
  final Exception? exception;
  final bool isLoading;
  const AuthStateLoggedOut({
    required this.exception,
    required this.isLoading,
  });
  
  @override
  
  List<Object?> get props => [exception, isLoading];
}
