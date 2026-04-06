import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:perla_app/features/auth/presentation/screens/auth_screens.dart';
import 'package:perla_app/features/auth/presentation/screens/otp_screen.dart';
import 'package:perla_app/features/auth/presentation/screens/register_screen.dart';
import 'package:perla_app/features/ai/presentation/screens/ai_chat_screen.dart';
import 'package:perla_app/features/ai/presentation/screens/appointment_confirmation_screen.dart';
import 'package:perla_app/features/ai/presentation/screens/voice_chat_screen.dart';
import 'package:perla_app/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:perla_app/features/calendar/presentation/screens/edit_calendar_screen.dart';
import 'package:perla_app/features/calendar/presentation/screens/symptoms_screen.dart';
import 'package:perla_app/features/home/presentation/screens/cycle_home_screen.dart';
import 'package:perla_app/features/onboarding/presentation/screens/onboarding_screens.dart';
import 'package:perla_app/features/onboarding/presentation/screens/set_goals_screen.dart';
import 'package:perla_app/features/onboarding/presentation/screens/set_last_period_screen.dart';
import 'package:perla_app/features/onboarding/presentation/screens/welcome_screen.dart';
import 'package:perla_app/features/profile/presentation/screens/profile_screens.dart';
import 'package:perla_app/features/self_care/presentation/screens/self_care_home_screen.dart';
import 'package:perla_app/features/self_care/presentation/screens/article_detail_screen.dart';
import 'package:perla_app/features/self_care/presentation/screens/activity_detail_screen.dart';
import 'package:perla_app/features/self_care/presentation/screens/activity_step_screen.dart';
import 'package:perla_app/features/self_care/presentation/screens/activity_timer_screen.dart';
import 'package:perla_app/features/self_care/presentation/screens/congratulations_screen.dart';
import 'package:perla_app/features/self_care/presentation/screens/meditation_screen.dart';
import 'package:perla_app/features/self_care/presentation/screens/skincare_screen.dart';
import 'package:perla_app/features/self_care/presentation/screens/strength_detail_screen.dart';

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
      path: '/ai',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context, state, const AiChatScreen()),
    ),
    GoRoute(
      path: '/ai/voice',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context, state, const VoiceChatScreen()),
    ),
    GoRoute(
      path: '/ai/appointment',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context, state, const AppointmentConfirmationScreen()),
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
    // self-care
    GoRoute(
      path: '/self-care',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context, state, const SelfCareHomeScreen()),
    ),
    GoRoute(
      path: '/self-care/article',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context, state, const ArticleDetailScreen()),
    ),
    GoRoute(
      path: '/self-care/activity-detail',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context, state, const ActivityDetailScreen()),
    ),
    GoRoute(
      path: '/self-care/activity-step',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context, state, const ActivityStepScreen()),
    ),
    GoRoute(
      path: '/self-care/timer',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context, state, const ActivityTimerScreen()),
    ),
    GoRoute(
      path: '/self-care/meditation',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context, state, const MeditationScreen()),
    ),
    GoRoute(
      path: '/self-care/skincare',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context, state, const SkincareScreen()),
    ),
    GoRoute(
      path: '/self-care/strength',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context, state, const StrengthDetailScreen()),
    ),
    GoRoute(
      path: '/self-care/congratulations',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context, state, const CongratulationsScreen()),
    ),
    GoRoute(
      path: '/notification',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context, state, const NotificationsScreen()),
    ),
    GoRoute(
      path: '/profile',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context, state, const ProfileScreen()),
    ),
    GoRoute(
      path: '/profile/personal-info',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context, state, const PersonalInformationScreen()),
    ),
    GoRoute(
      path: '/profile/settings',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context, state, const SettingsScreen()),
    ),
    GoRoute(
      path: '/profile/notifications',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context, state, const NotificationsScreen()),
    ),
    GoRoute(
      path: '/profile/account-security',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context, state, const AccountSecurityScreen()),
    ),
    GoRoute(
      path: '/profile/partner',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context, state, const PartnerScreen()),
    ),
    GoRoute(
      path: '/profile/partner/invite',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context, state, const InvitePartnerScreen()),
    ),
    GoRoute(
      path: '/profile/partner/pending',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context, state, const PartnerInvitationPendingScreen()),
    ),
    GoRoute(
      path: '/profile/partner/connected',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context, state, const ConnectedPartnerScreen()),
    ),
    GoRoute(
      path: '/profile/partner/sharing',
      pageBuilder: (context, state) => _buildSlideTransitionPage(
        context, state, const SharingSettingsScreen()),
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
