import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/features/onboarding/presentation/screens/splash.dart';
import 'package:perla_app/features/auth/presentation/screens/auth_screens.dart';
import 'package:perla_app/features/auth/presentation/screens/otp_screen.dart';
import 'package:perla_app/features/auth/presentation/screens/register_screen.dart';
import 'package:perla_app/features/home/presentation/screens/cycle_home_screen.dart';
import 'package:perla_app/features/journal/presentation/screens/journal_screens.dart';
import 'package:perla_app/features/onboarding/presentation/screens/onboarding_screens.dart';
import 'package:perla_app/features/onboarding/presentation/screens/set_goals_screen.dart';
import 'package:perla_app/features/onboarding/presentation/screens/set_last_period_screen.dart';
import 'package:perla_app/features/onboarding/presentation/screens/welcome_screen.dart';
import 'package:perla_app/features/educatif/presentation/screens/self_care_home_screen.dart';
import 'package:perla_app/core/router/shell_navigation.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

// Authentication state - replace with actual auth service
bool isAuthenticated = true; // Assume user is authenticated for MVP
bool hasCompletedOnboarding = false; // Will be updated when onboarding completes

// Function to update onboarding state
void updateOnboardingState(bool completed) {
  hasCompletedOnboarding = completed;
}

// Modifie l'initialLocation pour pointer vers /check-onboarding
final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/splash',
  redirect: (context, state) {
    // Redirect logic for authentication and onboarding flow
    final isGoingSplash = state.matchedLocation == '/splash';
    final isGoingAuth = state.matchedLocation.startsWith('/welcome') ||
        state.matchedLocation.startsWith('/register') ||
        state.matchedLocation.startsWith('/email') ||
        state.matchedLocation.startsWith('/create-account') ||
        state.matchedLocation.startsWith('/otp') ||
        state.matchedLocation.startsWith('/ask-name') ||
        state.matchedLocation.startsWith('/date-of-birth') ||
        state.matchedLocation.startsWith('/cycle-length') ||
        state.matchedLocation.startsWith('/set-goals') ||
        state.matchedLocation.startsWith('/last-period');

    // If on splash, stay there (loading state)
    if (isGoingSplash) {
      return null;
    }

    // If not authenticated and not going to auth flow, redirect to welcome
    if (!isAuthenticated && !isGoingAuth) {
      return '/welcome';
    }

    // If authenticated but hasn't completed onboarding and not on onboarding screens
    if (isAuthenticated && !hasCompletedOnboarding && !isGoingAuth) {
      return '/ask-name';
    }

    // If authenticated and completed onboarding, allow access to main app
    if (isAuthenticated && hasCompletedOnboarding && isGoingAuth) {
      return '/cycle';
    }

    // No redirect needed
    return null;
  },
  routes: [
    GoRoute(
      path: '/splash',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context,
        state,
        const SplashScreen(),
      ),
    ),
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
    // Shell route for main app navigation with CustomBottomNav
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      pageBuilder: (context, state, child) {
        return _buildSlideTransitionPage(
          context,
          state,
          ShellNavigation(child: child),
        );
      },
      routes: [
        // CYCLE - Main cycle tracking and calendar
        GoRoute(
          path: '/cycle',
          pageBuilder: (context, state) => _buildSlideTransitionPage(
            context,
            state,
            const CycleHomeScreen(),
          ),
        ),
        // JOURNAL - Personal mood and symptom tracking
        GoRoute(
          path: '/journal',
          pageBuilder: (context, state) =>
              _buildSlideTransitionPage(context, state, const JournalScreen()),
        ),
        GoRoute(
          path: '/journal/new',
          pageBuilder: (context, state) => _buildSlideTransitionPage(
              context, state, const JournalEditorScreen()),
        ),
        GoRoute(
          path: '/journal/edit/:id',
          pageBuilder: (context, state) => _buildSlideTransitionPage(
            context,
            state,
            JournalEditorScreen(entryId: state.pathParameters['id']),
          ),
        ),
        // EDUCATION - Educational content about cycles, fertility, health
        GoRoute(
          path: '/education',
          pageBuilder: (context, state) => _buildSlideTransitionPage(
            context,
            state,
            const SelfCareHomeScreen(), // Will be renamed to EducationHomeScreen
          ),
        ),
      ],
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
