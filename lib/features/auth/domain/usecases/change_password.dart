import '../repositories/auth_repository.dart';

class ChangePassword {
  final AuthRepository _repository;
  const ChangePassword(this._repository);

  Future<void> call({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) {
    if (currentPassword.isEmpty || newPassword.isEmpty) {
      throw Exception('All password fields are required.');
    }
    if (newPassword != confirmPassword) {
      throw Exception('New passwords do not match.');
    }
    if (newPassword.length < 6) {
      throw Exception('Password must be at least 6 characters.');
    }
    return _repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
