/// Hides most of an address before it is shown on screen.
///
/// `sogandasari77@gmail.com` becomes `so***@gmail.com`: the user still
/// recognises her address without exposing it in screenshots.
String maskEmail(String email) {
  final trimmed = email.trim();
  if (trimmed.isEmpty) return trimmed;
  final at = trimmed.indexOf('@');
  if (at <= 0 || at >= trimmed.length - 1) return trimmed;
  final local = trimmed.substring(0, at);
  final domain = trimmed.substring(at);
  if (local.length <= 2) return '${local.substring(0, 1)}***$domain';
  return '${local.substring(0, 2)}***$domain';
}
