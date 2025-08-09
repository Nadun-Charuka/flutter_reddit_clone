import 'package:flutter/material.dart';
import 'package:flutter_reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void logOut(WidgetRef ref, BuildContext context) {
    ref.read(authControllerProvider.notifier).logOut(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              logOut(ref, context);
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          'You are logged in! \nWelcome to the Home Screen.\n Mr/Mr :${user?.name ?? ""} ',
        ),
      ),
    );
  }
}
