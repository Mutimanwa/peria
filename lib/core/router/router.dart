import 'package:flutter/material.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:peria_app/core/router/app_back_navigation.dart';
import 'package:peria_app/core/theme/app_colors.dart';
import 'package:peria_app/features/onboarding/presentation/widgets/minimum_age_gate.dart';
import 'package:peria_app/l10n/app_localizations.dart';
import 'package:peria_app/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:peria_app/features/calendar/presentation/screens/edit_calendar_screen.dart';
import 'package:peria_app/features/calendar/presentation/screens/symptoms_screen.dart';
import 'package:peria_app/features/journal/presentation/screens/journal_detail_screen.dart';
import 'package:peria_app/features/journal/presentation/screens/journal_editor_screen.dart';
import 'package:peria_app/features/journal/presentation/screens/journal_screens.dart';
import 'package:peria_app/features/onboarding/presentation/screens/splash.dart';
import 'package:peria_app/features/auth/presentation/screens/auth_screens.dart';
import 'package:peria_app/features/auth/presentation/screens/otp_screen.dart';
import 'package:peria_app/features/auth/presentation/screens/register_screen.dart';
import 'package:peria_app/features/home/presentation/screens/cycle_home_screen.dart';
import 'package:peria_app/features/journal/presentation/screens/journal_timeline_screen.dart';
import 'package:peria_app/features/journal/presentation/screens/journal_search_screen.dart';
import 'package:peria_app/features/journal/presentation/screens/journal_insights_screen.dart';
import 'package:peria_app/features/journal/presentation/screens/journal_sync_settings_screen.dart';
import 'package:peria_app/features/onboarding/presentation/screens/onboarding_screens.dart';
import 'package:peria_app/features/onboarding/presentation/screens/set_goals_screen.dart';
import 'package:peria_app/features/onboarding/presentation/screens/set_last_period_screen.dart';
import 'package:peria_app/features/onboarding/presentation/screens/welcome_screen.dart';
import 'package:peria_app/features/privacy/presentation/screens/privacy_policy_screen.dart';
import 'package:peria_app/core/services/privacy_policy_consent_service.dart';
import 'package:peria_app/features/educatif/presentation/screens/education_home_screen.dart';
import 'package:peria_app/features/educatif/presentation/screens/education_article_detail_screen.dart';
import 'package:peria_app/core/router/shell_navigation.dart';
import 'package:peria_app/features/profile/presentation/screens/connect_partner.dart';
import 'package:peria_app/features/profile/presentation/screens/invite_partner_pending.dart';
import 'package:peria_app/features/profile/presentation/screens/invite_partner_screen.dart';
import 'package:peria_app/features/profile/presentation/screens/notification.dart';
import 'package:peria_app/features/profile/presentation/screens/partner_screen.dart';
import 'package:peria_app/features/profile/presentation/screens/personal_info.dart';
import 'package:peria_app/features/profile/presentation/screens/profile_screens.dart';
import 'package:peria_app/features/profile/presentation/screens/help_support.dart';
import 'package:peria_app/features/profile/presentation/screens/security.dart';
import 'package:peria_app/features/profile/presentation/screens/settings.dart';
import 'package:peria_app/features/profile/presentation/screens/sharing_screen.dart';
import 'package:peria_app/features/journal/presentation/guards/journal_lock_guard.dart';
import 'package:firebase_auth/firebase_auth.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

bool hasCompletedOnboarding = false;

// Authentication state managed by Firebase AuthProvider

final GoRouterRefreshStream routerRefresh =
    GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges());

// Function to update onboarding state
void updateOnboardingState(bool completed) {
  final changed = hasCompletedOnboarding != completed;
  hasCompletedOnboarding = completed;
  if (changed) routerRefresh.refresh();
}

const _completedOnboardingLocations = <String>{
  '/splash',
  '/welcome',
  '/ask-name',
  '/date-of-birth',
  '/set-goals',
  '/last-period',
};

String? resolveRouterRedirect({
  required String location,
  required bool isAuthenticated,
  required bool hasAcceptedPrivacyPolicy,
  required bool hasCompletedOnboarding,
}) {
  // Until the current policy is accepted, only Welcome and the policy itself
  // may be opened. This applies to already-authenticated users as well.
  if (!hasAcceptedPrivacyPolicy) {
    if (location == '/welcome' || location == '/privacy-policy') return null;
    return '/welcome';
  }

  final isAuthRoute = location == '/welcome' ||
      location == '/privacy-policy' ||
      location == '/splash' ||
      location.startsWith('/register') ||
      location == '/email' ||
      location == '/create-account' ||
      location == '/otp';

  if (!isAuthenticated) {
    if (isAuthRoute) return null;
    return '/welcome';
  }

  if (hasCompletedOnboarding &&
      _completedOnboardingLocations.contains(location)) {
    return '/cycle';
  }

  if (location == '/splash' || location == '/welcome') {
    return '/ask-name';
  }

  return null;
}

String? routerRedirect(BuildContext context, GoRouterState state) {
  final user = FirebaseAuth.instance.currentUser;
  final location = state.matchedLocation;
  debugPrint('[Router] redirect check location=$location uid=${user?.uid}');

  final destination = resolveRouterRedirect(
    location: location,
    isAuthenticated: user != null,
    hasAcceptedPrivacyPolicy:
        PrivacyPolicyConsentService.hasAcceptedCurrentVersion,
    hasCompletedOnboarding: hasCompletedOnboarding,
  );
  if (destination != null) {
    debugPrint('[Router] redirect -> $destination');
  }
  return destination;
}

// Utilitaire pour lier les changements d'auth Firebase au GoRouter
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  void refresh() => notifyListeners();

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

/// System back must not finish the activity when [GoRouter.go] replaced the
/// stack. Pop a real route first, otherwise walk to the logical parent, and
/// only leave the app after a second press on a root screen.
class PeriaBackButtonDispatcher extends RootBackButtonDispatcher {
  PeriaBackButtonDispatcher(this.router);

  final GoRouter router;
  DateTime? _lastRootBackAt;

  @override
  Future<bool> didPopRoute() async {
    final root = navigatorKey.currentState;
    if (root != null && root.canPop()) {
      root.pop();
      _lastRootBackAt = null;
      return true;
    }
    final shell = shellNavigatorKey.currentState;
    if (shell != null && shell.canPop()) {
      shell.pop();
      _lastRootBackAt = null;
      return true;
    }
    final popped = await router.routerDelegate.popRoute();
    if (popped) {
      _lastRootBackAt = null;
      return true;
    }

    final path = router.routerDelegate.currentConfiguration.uri.path;
    final target = resolveAppBackTarget(path);
    if (target != null && target != path) {
      _lastRootBackAt = null;
      router.go(target);
      return true;
    }

    final now = DateTime.now();
    final last = _lastRootBackAt;
    if (last != null && now.difference(last) < const Duration(seconds: 2)) {
      return false;
    }
    _lastRootBackAt = now;
    _showExitHint();
    return true;
  }

  void _showExitHint() {
    final context = navigatorKey.currentContext;
    if (context == null) return;
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;
    final message = AppLocalizations.of(context).pressBackAgainToExit;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );
  }
}

// Modifie l'initialLocation pour pointer vers /check-onboarding
final GoRouter appRouter = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/splash',
  refreshListenable: routerRefresh,
  redirect: routerRedirect,
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
      path: '/privacy-policy',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context,
        state,
        const PrivacyPolicyScreen(),
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
      path: '/calendar',
      pageBuilder: (context, state) =>
          _buildSlideTransitionPage(context, state, const CalendarScreen()),
    ),
    GoRoute(
      path: '/edit-calendar',
      pageBuilder: (context, state) =>
          _buildSlideTransitionPage(context, state, const EditCalendarScreen()),
    ),
    GoRoute(
      path: '/symptoms',
      pageBuilder: (context, state) =>
          _buildSlideTransitionPage(context, state, const SymptomsScreen()),
    ),
    GoRoute(
      path: '/profile',
      pageBuilder: (context, state) =>
          _buildSlideTransitionPage(context, state, const ProfileScreen()),
    ),
    GoRoute(
        path: '/profile/personal-info',
        pageBuilder: (context, state) => _buildSlideTransitionPage(
            context, state, const PersonalInformationScreen())),
    GoRoute(
        path: '/profile/notifications',
        pageBuilder: (context, state) => _buildSlideTransitionPage(
            context, state, const NotificationsScreen())),
    // Older buttons still call `/notification`. Keep the alias so that tap
    // opens the screen instead of a missing-route error.
    GoRoute(
      path: '/notification',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context,
        state,
        const NotificationsScreen(),
      ),
    ),
    GoRoute(
      path: '/notifications',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context,
        state,
        const NotificationsScreen(),
      ),
    ),
    GoRoute(
        path: '/profile/account-security',
        pageBuilder: (context, state) => _buildSlideTransitionPage(
            context, state, const AccountSecurityScreen())),
    GoRoute(
        path: '/profile/partner',
        pageBuilder: (context, state) =>
            _buildSlideTransitionPage(context, state, const PartnerScreen())),
    GoRoute(
        path: '/profile/invite-partner',
        pageBuilder: (context, state) => _buildSlideTransitionPage(
            context, state, const InvitePartnerScreen())),
    GoRoute(
        path: '/profile/partner-pending',
        pageBuilder: (context, state) => _buildSlideTransitionPage(
            context, state, const PartnerInvitationPendingScreen())),
    GoRoute(
        path: '/profile/connected-partner',
        pageBuilder: (context, state) => _buildSlideTransitionPage(
            context, state, const ConnectedPartnerScreen())),
    GoRoute(
        path: '/profile/sharing-settings',
        pageBuilder: (context, state) => _buildSlideTransitionPage(
            context, state, const SharingSettingsScreen())),
    GoRoute(
      path: '/profile/settings',
      pageBuilder: (context, state) =>
          _buildSlideTransitionPage(context, state, const SettingScreen()),
    ),
    GoRoute(
      path: '/profile/journal-sync',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context,
        state,
        const JournalSyncSettingsScreen(),
      ),
    ),
    GoRoute(
      path: '/profile/help-support',
      pageBuilder: (context, state) =>
          _buildSlideTransitionPage(context, state, const HelpSupportScreen()),
    ),

    // JOURNAL - Personal mood and symptom tracking

    GoRoute(
      path: '/journal/detail/:id',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context,
        state,
        JournalLockGuard(
          child: JournalDetailScreen(entryId: state.pathParameters['id'] ?? ''),
        ),
      ),
    ),
    GoRoute(
      path: '/journal/new',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context,
        state,
        const JournalLockGuard(child: JournalEditorScreen()),
      ),
    ),
    GoRoute(
      path: '/journal/edit/:id',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context,
        state,
        JournalLockGuard(
          child: JournalEditorScreen(entryId: state.pathParameters['id']),
        ),
      ),
    ),
    GoRoute(
      path: '/journal/timeline',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context,
        state,
        const JournalLockGuard(child: JournalTimelineScreen()),
      ),
    ),
            GoRoute(
          path: '/journal/search',
          pageBuilder: (context, state) => _buildSlideTransitionPage(
            context,
            state,
            const JournalLockGuard(child: JournalSearchScreen()),
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
        GoRoute(
          path: '/journal',
          pageBuilder: (context, state) => _buildSlideTransitionPage(
            context,
            state,
            const JournalLockGuard(child: JournalScreens()),
          ),
        ),

        GoRoute(
          path: '/journal/insights',
          pageBuilder: (context, state) => _buildSlideTransitionPage(
            context,
            state,
            const JournalLockGuard(child: JournalInsightsScreen()),
          ),
        ),

        // EDUCATION - Educational content about cycles, fertility, health
        GoRoute(
          path: '/education',
          pageBuilder: (context, state) => _buildSlideTransitionPage(
            context,
            state,
            const EducationHomeScreen(),
          ),
        ),
        GoRoute(
          path: '/education/article/:id',
          pageBuilder: (context, state) => _buildSlideTransitionPage(
            context,
            state,
            EducationArticleDetailScreen(
              articleId: state.pathParameters['id'] ?? '',
            ),
          ),
        ),
      ],
    ),
  ],
);

final PeriaBackButtonDispatcher periaBackButtonDispatcher =
    PeriaBackButtonDispatcher(appRouter);

CustomTransitionPage _buildSlideTransitionPage(
  BuildContext context,
  GoRouterState state,
  Widget child,
) {
  final location = state.matchedLocation;
  final pageChild = ColoredBox(
    color: AppColors.white,
    child: isAgeGateExempt(location)
        ? child
        : MinimumAgeGate(child: child),
  );
  return CustomTransitionPage(
    key: state.pageKey,
    child: pageChild,
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
