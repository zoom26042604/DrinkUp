import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignUp {
  final AuthRepository _repository;

  const SignUp(this._repository);

  Future<UserEntity> call({
    required String email,
    required String password,
    required String confirmPassword,
    String? displayName,
  }) {
    if (email.trim().isEmpty || password.isEmpty) {
      throw Exception('Email and password are required.');
    }
    if (password != confirmPassword) {
      throw Exception('Passwords do not match.');
    }
    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters.');
    }
    return _repository.signUp(
      email: email.trim(),
      password: password,
      displayName: displayName?.trim().isEmpty == true ? null : displayName?.trim(),
    );
  }
}
