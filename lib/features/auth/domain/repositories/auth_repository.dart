import '../entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get authStateChanges;
  UserEntity? get currentUser;

  Future<UserEntity> signIn({
    required String email,
    required String password,
  });

  Future<UserEntity> signUp({
    required String email,
    required String password,
    String? displayName,
  });

  Future<UserEntity> signInWithGoogle();

  Future<UserEntity> signInAndLinkGoogle({
    required String email,
    required String password,
  });

  Future<void> linkWithGoogle();

  Future<void> unlinkGoogle();

  Future<void> updateDisplayName(String displayName);

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<void> signOut();
}
