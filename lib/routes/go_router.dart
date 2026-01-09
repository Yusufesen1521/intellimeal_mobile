import 'package:go_router/go_router.dart';
import 'package:intellimeal/screens/auth/signin/signin_screen.dart';
import 'package:intellimeal/screens/auth/signup/signup_screen.dart';
import 'package:intellimeal/screens/main/main_control_screen.dart';
import 'package:intellimeal/screens/main/main_screen.dart';
import 'package:intellimeal/screens/profile/get_meal_recommendation.dart';
import 'package:intellimeal/screens/profile/personal_info_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      path: '/main',
      builder: (context, state) => MainControlScreen(),
    ),

    GoRoute(
      path: '/signin',
      builder: (context, state) => const SigninScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/profile/get-meal-recommendation',
      builder: (context, state) => const GetMealRecommendation(),
    ),
    GoRoute(
      path: '/profile/personal-info',
      builder: (context, state) => const PersonalInfoScreen(),
    ),
  ],
);
