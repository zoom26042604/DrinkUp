import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignIn {
  final AuthRepository _repository;

  const SignIn(this._repository);

  Future<UserEntity> call({
    required String email,
    required String password,
  }) {
    if (email.trim().isEmpty || password.isEmpty) {
      throw Exception('Email and password are required.');
    }
    return _repository.signIn(email: email.trim(), password: password);
  }
}
