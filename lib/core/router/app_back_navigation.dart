/// Where the system back button should go when the navigator stack is empty.
///
/// `context.go` replaces the stack, so Android otherwise finishes the activity.
/// Returns null for true roots (`/cycle`, `/welcome`, `/ask-name`, `/splash`),
/// which should ask for a second press before leaving the app.
String? resolveAppBackTarget(String location) {
  final path = Uri.parse(location).path;
  if (path.isEmpty || path == '/') return null;

  const exact = <String, String>{
    '/date-of-birth': '/ask-name',
    '/set-goals': '/date-of-birth',
    '/last-period': '/date-of-birth',
    '/calendar': '/cycle',
    '/edit-calendar': '/calendar',
    '/symptoms': '/cycle',
    '/profile': '/cycle',
    '/profile/personal-info': '/profile',
    '/profile/notifications': '/profile',
    '/profile/account-security': '/profile',
    '/profile/partner': '/profile',
    '/profile/invite-partner': '/profile/partner',
    '/profile/partner-pending': '/profile/partner',
    '/profile/connected-partner': '/profile/partner',
    '/profile/sharing-settings': '/profile/partner',
    '/profile/settings': '/profile',
    '/profile/journal-sync': '/profile/settings',
    '/profile/help-support': '/profile',
    '/notification': '/cycle',
    '/notifications': '/cycle',
    '/journal': '/cycle',
    '/journal/new': '/journal',
    '/journal/timeline': '/journal',
    '/journal/search': '/journal',
    '/journal/insights': '/journal',
    '/education': '/cycle',
    '/register': '/welcome',
    '/email': '/register',
    '/create-account': '/email',
    '/otp': '/email',
    '/privacy-policy': '/welcome',
  };

  final mapped = exact[path];
  if (mapped != null) return mapped;
  if (path.startsWith('/journal/detail/') || path.startsWith('/journal/edit/')) {
    return '/journal';
  }
  if (path.startsWith('/education/article/')) return '/education';
  if (path.startsWith('/profile/')) return '/profile';
  if (path.startsWith('/self-care/')) return '/cycle';
  return null;
}

/// Routes that must stay reachable even when a saved birth date is underage,
/// so the person can correct it instead of being locked out of the form.
bool isAgeGateExempt(String location) {
  final path = Uri.parse(location).path;
  const exempt = <String>{
    '/splash',
    '/welcome',
    '/privacy-policy',
    '/register',
    '/email',
    '/create-account',
    '/otp',
    '/ask-name',
    '/date-of-birth',
    '/set-goals',
    '/last-period',
  };
  return exempt.contains(path) || path.startsWith('/register');
}
