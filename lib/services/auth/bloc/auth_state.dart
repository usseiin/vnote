import 'package:flutter/material.dart';
import 'package:vnote_app/services/auth/auth_user.dart';

// State
@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn(this.user);
}

class AuthStateLogedInFailure extends AuthState {
  final Exception exception;
  const AuthStateLogedInFailure(this.exception);
}

class AuthStateNeedVerification extends AuthState {
  const AuthStateNeedVerification();
}

class AuthStateLoggedOut extends AuthState {
  const AuthStateLoggedOut();
}

class AuthStateLogedOutFailure extends AuthState {
  final Exception exception;
  const AuthStateLogedOutFailure(this.exception);
}

