import "package:test/test.dart";
import 'package:vnote_app/services/auth/auth_exceptions.dart';
import 'package:vnote_app/services/auth/auth_provider.dart';
import 'package:vnote_app/services/auth/auth_user.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();

    test("Should not be initialized to begin with", () {
      expect(provider.isInitialized, false);
    });

    test("Cannot log if not initialized", () {
      expect(
        provider.logOut(),
        throwsA(
          const TypeMatcher<NotInitializedAuthException>(),
        ),
      );
    });

    test("Should be able to initialized", () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test("User should be null after initialized", () {
      expect(provider.currentUser, null);
    });

    test(
      "Should be able to initialized in less than 2 seconds",
      () async {
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(
        Duration(seconds: 2),
      ),
    );

    test("Create user should delegate to login function", () async {
      final badEmailUser = provider.createUser(
        email: "foobar@gmail.com",
        password: "anypassword",
      );

      expect(
        badEmailUser,
        throwsA(
          const TypeMatcher<UserNotFoundAuthExcepton>(),
        ),
      );

      final badPasswordUser = provider.createUser(
        email: "someone@gmail.com",
        password: "foobar",
      );

      expect(
        badPasswordUser,
        throwsA(
          const TypeMatcher<UserNotFoundAuthExcepton>(),
        ),
      );

      final user = await provider.createUser(
        email: "foo",
        password: "bar",
      );

      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test("login user should be able to verified", () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test("should be able to logout and login again", () async {
      await provider.logOut();
      await provider.login(
        email: "email",
        password: "password",
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedAuthException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedAuthException();
    await Future.delayed(const Duration(seconds: 1));
    return login(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedAuthException();
    if (_user != null) throw UserNotFoundAuthExcepton();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedAuthException();
    if (email == "foo@bar.com") throw UserNotFoundAuthExcepton();
    if (password == "foobar") throw WrongPasswordAuthExcepton();
    const user = AuthUser(isEmailVerified: false, email: "", id: "");
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedAuthException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthExcepton();
    const newUser = AuthUser(isEmailVerified: true, email: "", id: "");
    _user = newUser;
  }
  
  @override
  Future<void> sendPasswordReset({required String toEmail}) {
    throw UnimplementedError();
  }
}
