import 'package:go_router/go_router.dart';
import 'package:intellimeal/screens/auth/signin/signin_screen.dart';
import 'package:intellimeal/screens/auth/signup/signup_screen.dart';
import 'package:intellimeal/screens/main/main_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      path: '/signin',
      builder: (context, state) => const SigninScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
  ],
);
