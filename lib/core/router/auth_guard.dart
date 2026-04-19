import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

// Deprecated: authRedirect (replaced by synchronous routerRedirect in router.dart)
// String? authRedirect(BuildContext context, GoRouterState state, WidgetRef ref) {
//   final authState = ref.read(authProvider);
//   
//   // Loading - stay on splash
//   if (authState.isLoading) return '/splash';
//   
//   // No user - redirect to onboarding/auth
//   if (authState.user == null) {
//     if (state.matchedLocation == '/splash') return null;
//     return '/splash';
//   }
//   
//   // Authenticated - block auth routes
//   if (state.matchedLocation.startsWith('/register') || 
//       state.matchedLocation.startsWith('/otp')) {
//     return '/cycle';
//   }
//   
//   return null;
// }

