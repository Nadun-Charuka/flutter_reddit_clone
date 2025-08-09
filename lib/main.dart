import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:flutter_reddit_clone/features/auth/screen/login_screen.dart';
import 'package:flutter_reddit_clone/firebase_options.dart';
import 'package:flutter_reddit_clone/theme/pallete.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_reddit_clone/features/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(ProviderScope(child: MyApp()));
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangesProvider);
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          // Check if the user is logged in
          return authState.when(
            data: (user) =>
                user == null ? const LoginScreen() : const HomeScreen(),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Text('Error: $err'),
          );
        },
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
    ],
    // Redirect logic to handle authentication state changes
    redirect: (BuildContext context, GoRouterState state) {
      final loggedIn = authState.value != null;
      final loggingIn = state.uri.toString() == '/login';
      final homeRoute = state.uri.toString() == '/home';

      // If not logged in and not on the login page, redirect to login
      if (!loggedIn && !loggingIn) {
        return '/login';
      }
      // If logged in and on the login page, redirect to home
      if (loggedIn && loggingIn) {
        return '/home';
      }
      // If logged in and on the home page, no redirect is needed
      if (loggedIn && homeRoute) {
        return null;
      }
      // No redirect otherwise
      return null;
    },
  );
});

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: "Reddit Clone",
      theme: Pallete.darkModeAppTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
