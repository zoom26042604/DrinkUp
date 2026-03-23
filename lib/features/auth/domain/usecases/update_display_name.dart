import '../repositories/auth_repository.dart';

class UpdateDisplayName {
  final AuthRepository _repository;
  const UpdateDisplayName(this._repository);

  Future<void> call(String displayName) {
    if (displayName.trim().isEmpty) throw Exception('Username cannot be empty.');
    return _repository.updateDisplayName(displayName.trim());
  }
}
