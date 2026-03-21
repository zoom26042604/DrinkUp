import '../repositories/auth_repository.dart';

class LinkWithGoogle {
  final AuthRepository _repository;

  const LinkWithGoogle(this._repository);

  Future<void> call() => _repository.linkWithGoogle();
}
