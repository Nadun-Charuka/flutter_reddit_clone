import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reddit_clone/core/utils.dart';
import 'package:flutter_reddit_clone/features/auth/repository/auth_repository.dart';
import 'package:flutter_reddit_clone/model/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

// This provider listens for real-time authentication changes from Firebase.
final authStateChangesProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChanges;
});

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({required AuthRepository authRepository, required Ref ref})
    : _authRepository = authRepository,
      _ref = ref,
      super(false) {
    // This part is crucial for state persistence.
    // We listen to Firebase Auth state changes and get the user's data.
    authStateChanges.listen((user) {
      if (user != null) {
        getUserData(user.uid).then((userModel) {
          _ref.read(userProvider.notifier).update((state) => userModel);
        });
      } else {
        _ref.read(userProvider.notifier).update((state) => null);
      }
    });
  }

  Stream<User?> get authStateChanges => _authRepository.authStateChanges;

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogle();
    state = false;
    user.fold(
      (l) => showSnackBar(context, l.message),
      (userModel) => _ref
          .read(userProvider.notifier)
          .update(
            (state) => userModel,
          ),
    );
  }

  Future<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid).first;
  }

  void logOut(BuildContext context) async {
    final result = await _authRepository.logOut();
    result.fold(
      (l) => showSnackBar(context, l.message),
      (r) =>
          null, // On success, nothing needs to be done here as the stream will handle it
    );
  }
}
