class UserEntity {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final List<String> providerIds;

  const UserEntity({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.providerIds = const [],
  });

  bool get isGoogleLinked => providerIds.contains('google.com');
  bool get hasPasswordProvider => providerIds.contains('password');
}
