import '../repositories/auth_repository.dart';

class UnlinkGoogle {
  final AuthRepository _repository;
  const UnlinkGoogle(this._repository);

  Future<void> call() => _repository.unlinkGoogle();
}
