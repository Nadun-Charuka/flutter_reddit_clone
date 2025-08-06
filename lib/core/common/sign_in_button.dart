import 'package:flutter/material.dart';
import 'package:flutter_reddit_clone/core/constants/constants.dart';

class SignInButton extends StatelessWidget {
  const SignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Image.asset(Constants.googleUrl, height: 40),
      label: const Text("SignIn with google", style: TextStyle(fontSize: 18)),
      style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
    );
  }
}
