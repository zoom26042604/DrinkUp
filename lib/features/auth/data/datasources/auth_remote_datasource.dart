import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/exceptions/pending_link_exception.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDatasource {
  Stream<UserModel?> get authStateChanges;
  UserModel? get currentUser;
  Future<UserModel> signIn({required String email, required String password});
  Future<UserModel> signUp({
    required String email,
    required String password,
    String? displayName,
  });
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signInAndLinkGoogle({
    required String email,
    required String password,
  });
  Future<void> linkWithGoogle();
  Future<void> unlinkGoogle();
  Future<void> updateDisplayName(String displayName);
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
  Future<void> signOut();
  void clearPendingGoogleCredential();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  OAuthCredential? _pendingGoogleCredential;

  AuthRemoteDatasourceImpl(this._auth, this._googleSignIn);

  @override
  Stream<UserModel?> get authStateChanges => _auth
      .userChanges()
      .map((user) => user != null ? UserModel.fromFirebaseUser(user) : null);

  @override
  UserModel? get currentUser {
    final user = _auth.currentUser;
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (_pendingGoogleCredential != null) {
        try {
          await credential.user!.linkWithCredential(_pendingGoogleCredential!);
        } catch (_) {
        } finally {
          _pendingGoogleCredential = null;
        }
      }
      return UserModel.fromFirebaseUser(_auth.currentUser!);
    } on FirebaseAuthException catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (displayName != null && displayName.isNotEmpty) {
        await credential.user!.updateDisplayName(displayName);
        await credential.user!.reload();
      }
      return UserModel.fromFirebaseUser(_auth.currentUser!);
    } on FirebaseAuthException catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    GoogleSignInAccount? googleUser;
    try {
      googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception('Google sign-in cancelled.');

      final methods = await _auth.fetchSignInMethodsForEmail(googleUser.email); // ignore: deprecated_member_use

      final googleAuth = await googleUser.authentication;
      _pendingGoogleCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      if (methods.contains('password') && !methods.contains('google.com')) {
        throw PendingLinkException(googleUser.email);
      }

      final userCredential =
          await _auth.signInWithCredential(_pendingGoogleCredential!);
      _pendingGoogleCredential = null;
      return UserModel.fromFirebaseUser(userCredential.user!);
    } on PendingLinkException {
      rethrow;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        throw PendingLinkException(e.email ?? googleUser?.email ?? '');
      }
      _pendingGoogleCredential = null;
      throw _mapException(e);
    } catch (e) {
      _pendingGoogleCredential = null;
      rethrow;
    }
  }

  @override
  Future<UserModel> signInAndLinkGoogle({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user!;
      final savedDisplayName = user.displayName;

      if (_pendingGoogleCredential != null) {
        await user.linkWithCredential(_pendingGoogleCredential!);
        _pendingGoogleCredential = null;
        await user.reload();
        if (savedDisplayName != null &&
            savedDisplayName.isNotEmpty &&
            _auth.currentUser?.displayName != savedDisplayName) {
          await _auth.currentUser!.updateDisplayName(savedDisplayName);
          await _auth.currentUser!.reload();
        }
      }
      return UserModel.fromFirebaseUser(_auth.currentUser!);
    } on FirebaseAuthException catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<void> linkWithGoogle() async {
    try {
      final user = _auth.currentUser!;
      final savedDisplayName = user.displayName;

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception('Google sign-in cancelled.');
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await user.linkWithCredential(credential);
      await user.reload();
      if (savedDisplayName != null &&
          savedDisplayName.isNotEmpty &&
          _auth.currentUser?.displayName != savedDisplayName) {
        await _auth.currentUser!.updateDisplayName(savedDisplayName);
        await _auth.currentUser!.reload();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'credential-already-in-use') {
        throw Exception('This Google account is already linked to another account.');
      }
      if (e.code == 'provider-already-linked') {
        throw Exception('Google account is already linked.');
      }
      throw _mapException(e);
    }
  }

  @override
  Future<void> unlinkGoogle() async {
    try {
      await _auth.currentUser!.unlink('google.com');
      await _auth.currentUser!.reload();
    } on FirebaseAuthException catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<void> updateDisplayName(String displayName) async {
    try {
      await _auth.currentUser!.updateDisplayName(displayName);
      await _auth.currentUser!.reload();
    } on FirebaseAuthException catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _auth.currentUser!;
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _mapException(e);
    }
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  @override
  void clearPendingGoogleCredential() {
    _pendingGoogleCredential = null;
  }

  Exception _mapException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return Exception('Incorrect email or password.');
      case 'email-already-in-use':
        return Exception('This email is already in use.');
      case 'account-exists-with-different-credential':
        return Exception(
          'An account already exists with this email. Please sign in with email & password.',
        );
      case 'weak-password':
        return Exception('Password too weak (6 characters minimum).');
      case 'invalid-email':
        return Exception('Invalid email format.');
      case 'too-many-requests':
        return Exception('Too many attempts. Please try again later.');
      case 'requires-recent-login':
        return Exception('Please sign in again before changing your password.');
      default:
        return Exception(e.message ?? 'Authentication error.');
    }
  }
}
