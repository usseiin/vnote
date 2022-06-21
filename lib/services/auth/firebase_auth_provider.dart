import 'package:firebase_core/firebase_core.dart';
import 'package:vnote_app/firebase_options.dart';
import 'auth_user.dart';
import 'auth_provider.dart';
import 'auth_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoginAuthExcepton();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        throw WeakPasswordAuthExcepton();
      } else if (e.code == "email-already-in-use") {
        throw EmailAlreadyInUseAuthExcepton();
      } else if (e.code == "invalid-email") {
        throw InvalidEmailAuthExcepton();
      } else if (e.code == "network-request-failed") {
        throw NetworkRequestFaildAuthExcepton();
      } else {
        throw GenericAuthExcepton();
      }
    } catch (e) {
      throw GenericAuthExcepton();
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoginAuthExcepton();
    }
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoginAuthExcepton();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        throw UserNotFoundAuthExcepton();
      } else if (e.code == "wrong-password") {
        throw WrongPasswordAuthExcepton();
      } else if (e.code == "network-request-failed") {
        throw NetworkRequestFaildAuthExcepton();
      } else {
        throw GenericAuthExcepton();
      }
    } catch (_) {
      throw GenericAuthExcepton();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    }
    throw UserNotLoginAuthExcepton();
  }
}
