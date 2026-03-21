import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _datasource;

  AuthRepositoryImpl(this._datasource);

  @override
  Stream<UserEntity?> get authStateChanges => _datasource.authStateChanges;

  @override
  UserEntity? get currentUser => _datasource.currentUser;

  @override
  Future<UserEntity> signIn({
    required String email,
    required String password,
  }) => _datasource.signIn(email: email, password: password);

  @override
  Future<UserEntity> signUp({
    required String email,
    required String password,
    String? displayName,
  }) => _datasource.signUp(
        email: email,
        password: password,
        displayName: displayName,
      );

  @override
  Future<UserEntity> signInWithGoogle() => _datasource.signInWithGoogle();

  @override
  Future<UserEntity> signInAndLinkGoogle({
    required String email,
    required String password,
  }) => _datasource.signInAndLinkGoogle(email: email, password: password);

  @override
  Future<void> linkWithGoogle() => _datasource.linkWithGoogle();

  @override
  Future<void> unlinkGoogle() => _datasource.unlinkGoogle();

  @override
  Future<void> updateDisplayName(String displayName) =>
      _datasource.updateDisplayName(displayName);

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) => _datasource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

  @override
  Future<void> signOut() => _datasource.signOut();
}
