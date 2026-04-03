import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/features/auth/presentation/screens/auth_screens.dart';
import 'package:perla_app/features/auth/presentation/screens/otp_screen.dart';
import 'package:perla_app/features/auth/presentation/screens/register_screen.dart';
import 'package:perla_app/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:perla_app/features/calendar/presentation/screens/edit_calendar_screen.dart';
import 'package:perla_app/features/calendar/presentation/screens/symptoms_screen.dart';
import 'package:perla_app/features/home/presentation/screens/cycle_home_screen.dart';
import 'package:perla_app/features/onboarding/presentation/screens/onboarding_screens.dart';
import 'package:perla_app/features/onboarding/presentation/screens/set_goals_screen.dart';
import 'package:perla_app/features/onboarding/presentation/screens/set_last_period_screen.dart';
import 'package:perla_app/features/onboarding/presentation/screens/welcome_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/welcome',
  routes: [
    GoRoute(
      path: '/welcome',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context,
        state,
        const WelcomeScreen(),
      ),
    ),
    GoRoute(
      path: '/register',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context,
        state,
        const RegisterScreen(),
      ),
    ),
    GoRoute(
      path: '/email',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context,
        state,
        const ContinueWithEmailScreen(),
      ),
    ),
    GoRoute(
      path: '/create-account',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context,
        state,
        const CreateAccountScreen(),
      ),
    ),
    GoRoute(
      path: '/otp',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context,
        state,
        const OtpScreen(),
      ),
    ),
    GoRoute(
      path: '/ask-name',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context,
        state,
        const AskNameScreen(),
      ),
    ),
    GoRoute(
      path: '/date-of-birth',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context,
        state,
        const DateOfBirthScreen(),
      ),
    ),
    GoRoute(
      path: '/set-goals',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context,
        state,
        const SetGoalsScreen(),
      ),
    ),
    GoRoute(
      path: '/last-period',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context,
        state,
        const SetLastPeriodScreen(),
      ),
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context,
        state,
        const CycleHomeScreen(),
      ),
    ),
    // calendrier 
    GoRoute(
      path: '/calendar',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context, state, const CalendarScreen()),
    ),
    GoRoute(
      path: '/edit-calendar',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context, state, const EditCalendarScreen()),
    ),
    GoRoute(
      path: '/symptoms',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context, state, const SymptomsScreen()),
    ),
  ],
);

CustomTransitionPage _buildSlideTransitionPage(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          ),
        ),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}
