import 'package:flutter/material.dart';
import 'package:flutter_reddit_clone/core/constants/constants.dart';
import 'package:flutter_reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInButton extends ConsumerWidget {
  const SignInButton({super.key});

  void signInWithGoogle(WidgetRef ref, BuildContext context) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () {
        signInWithGoogle(ref, context);
      },
      icon: Image.asset(Constants.googleUrl, height: 40),
      label: const Text(
        "SignIn with google",
        style: TextStyle(fontSize: 18),
      ),
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
      ),
    );
  }
}
