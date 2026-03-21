import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignInAndLinkGoogle {
  final AuthRepository _repository;
  const SignInAndLinkGoogle(this._repository);

  Future<UserEntity> call({
    required String email,
    required String password,
  }) {
    if (email.trim().isEmpty || password.isEmpty) {
      throw Exception('Email and password are required.');
    }
    return _repository.signInAndLinkGoogle(
      email: email.trim(),
      password: password,
    );
  }
}
