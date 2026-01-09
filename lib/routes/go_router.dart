import 'package:go_router/go_router.dart';
import 'package:intellimeal/nutritionist/screens/nutritionist_main_screen.dart';
import 'package:intellimeal/screens/auth/signin/signin_screen.dart';
import 'package:intellimeal/screens/auth/signup/signup_screen.dart';
import 'package:intellimeal/screens/home/ingredients_screen.dart';
import 'package:intellimeal/screens/main/main_control_screen.dart';
import 'package:intellimeal/screens/main/main_screen.dart';
import 'package:intellimeal/screens/profile/get_meal_recommendation.dart';
import 'package:intellimeal/screens/profile/personal_info_screen.dart';
import 'package:intellimeal/screens/profile/profile_settings_screen.dart';

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
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return PersonalInfoScreen(
          userId: extra['userId']!,
          token: extra['token']!,
        );
      },
    ),
    GoRoute(
      path: '/profile/settings',
      builder: (context, state) => const ProfileSettingsScreen(),
    ),
    GoRoute(
      path: '/home/ingredients',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return IngredientsScreen(
          initialExpandedMealName: extra?['mealName'] as String?,
        );
      },
    ),
    GoRoute(
      path: '/nutritionist/main',
      builder: (context, state) => const NutritionistMainScreen(),
    ),
  ],
);
