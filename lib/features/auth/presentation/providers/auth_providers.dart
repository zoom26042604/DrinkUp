import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/exceptions/pending_link_exception.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/change_password.dart';
import '../../domain/usecases/link_with_google.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_in_and_link_google.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up.dart';
import '../../domain/usecases/unlink_google.dart';
import '../../domain/usecases/update_display_name.dart';


final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final googleSignInProvider =
    Provider<GoogleSignIn>((ref) => GoogleSignIn());

final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>(
  (ref) => AuthRemoteDatasourceImpl(
    ref.watch(firebaseAuthProvider),
    ref.watch(googleSignInProvider),
  ),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.watch(authRemoteDatasourceProvider)),
);


final signInProvider =
    Provider<SignIn>((ref) => SignIn(ref.watch(authRepositoryProvider)));
final signUpProvider =
    Provider<SignUp>((ref) => SignUp(ref.watch(authRepositoryProvider)));
final signOutProvider =
    Provider<SignOut>((ref) => SignOut(ref.watch(authRepositoryProvider)));
final signInWithGoogleProvider = Provider<SignInWithGoogle>(
    (ref) => SignInWithGoogle(ref.watch(authRepositoryProvider)));
final signInAndLinkGoogleProvider = Provider<SignInAndLinkGoogle>(
    (ref) => SignInAndLinkGoogle(ref.watch(authRepositoryProvider)));
final linkWithGoogleProvider = Provider<LinkWithGoogle>(
    (ref) => LinkWithGoogle(ref.watch(authRepositoryProvider)));
final unlinkGoogleProvider = Provider<UnlinkGoogle>(
    (ref) => UnlinkGoogle(ref.watch(authRepositoryProvider)));
final updateDisplayNameProvider = Provider<UpdateDisplayName>(
    (ref) => UpdateDisplayName(ref.watch(authRepositoryProvider)));
final changePasswordProvider = Provider<ChangePassword>(
    (ref) => ChangePassword(ref.watch(authRepositoryProvider)));


final authStateProvider = StreamProvider<UserEntity?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});


class AuthState {
  final bool isLoading;
  final String? error;
  final String? pendingLinkEmail;

  const AuthState({
    this.isLoading = false,
    this.error,
    this.pendingLinkEmail,
  });
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRemoteDatasource _datasource;
  final SignIn _signIn;
  final SignUp _signUp;
  final SignOut _signOut;
  final SignInWithGoogle _signInWithGoogle;
  final SignInAndLinkGoogle _signInAndLinkGoogle;
  final LinkWithGoogle _linkWithGoogle;
  final UnlinkGoogle _unlinkGoogle;
  final UpdateDisplayName _updateDisplayName;
  final ChangePassword _changePassword;

  AuthNotifier(
    this._datasource,
    this._signIn,
    this._signUp,
    this._signOut,
    this._signInWithGoogle,
    this._signInAndLinkGoogle,
    this._linkWithGoogle,
    this._unlinkGoogle,
    this._updateDisplayName,
    this._changePassword,
  ) : super(const AuthState());

  Future<void> signIn(String email, String password) async {
    state = const AuthState(isLoading: true);
    try {
      await _signIn(email: email, password: password);
      state = const AuthState();
    } catch (e) {
      state = AuthState(error: e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> signUp(
    String email,
    String password,
    String confirmPassword,
    String displayName,
  ) async {
    state = const AuthState(isLoading: true);
    try {
      await _signUp(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        displayName: displayName,
      );
      state = const AuthState();
    } catch (e) {
      state = AuthState(error: e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AuthState(isLoading: true);
    try {
      await _signInWithGoogle();
      state = const AuthState();
    } on PendingLinkException catch (e) {
      state = AuthState(pendingLinkEmail: e.email);
    } catch (e) {
      state = AuthState(error: e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> signInAndLinkGoogle(String email, String password) async {
    state = AuthState(isLoading: true, pendingLinkEmail: state.pendingLinkEmail);
    try {
      await _signInAndLinkGoogle(email: email, password: password);
      state = const AuthState();
    } catch (e) {
      state = AuthState(
        error: e.toString().replaceFirst('Exception: ', ''),
        pendingLinkEmail: state.pendingLinkEmail,
      );
    }
  }

  Future<void> linkWithGoogle() async {
    state = const AuthState(isLoading: true);
    try {
      await _linkWithGoogle();
      state = const AuthState();
    } catch (e) {
      state = AuthState(error: e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> unlinkGoogle() async {
    state = const AuthState(isLoading: true);
    try {
      await _unlinkGoogle();
      state = const AuthState();
    } catch (e) {
      state = AuthState(error: e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> updateDisplayName(String displayName) async {
    state = const AuthState(isLoading: true);
    try {
      await _updateDisplayName(displayName);
      state = const AuthState();
    } catch (e) {
      state = AuthState(error: e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    state = const AuthState(isLoading: true);
    try {
      await _changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      state = const AuthState();
    } catch (e) {
      state = AuthState(error: e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> signOut() async {
    await _signOut();
    state = const AuthState();
  }

  void clearPendingLink() {
    _datasource.clearPendingGoogleCredential();
    state = const AuthState();
  }
  void clearError() => state = AuthState(
        isLoading: state.isLoading,
        pendingLinkEmail: state.pendingLinkEmail,
      );
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.watch(authRemoteDatasourceProvider),
    ref.watch(signInProvider),
    ref.watch(signUpProvider),
    ref.watch(signOutProvider),
    ref.watch(signInWithGoogleProvider),
    ref.watch(signInAndLinkGoogleProvider),
    ref.watch(linkWithGoogleProvider),
    ref.watch(unlinkGoogleProvider),
    ref.watch(updateDisplayNameProvider),
    ref.watch(changePasswordProvider),
  );
});
