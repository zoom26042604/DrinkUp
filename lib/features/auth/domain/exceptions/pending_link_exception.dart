class PendingLinkException implements Exception {
  final String email;
  const PendingLinkException(this.email);
}
