import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perla_app/core/repositories/user_repository.dart';
import 'package:perla_app/features/calendar/data/models/symptom_log.dart';
import 'package:perla_app/features/calendar/data/repositories/symptom_repository.dart';

final symptomUserRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final symptomRepositoryProvider = Provider<SymptomRepository>((ref) {
  return SymptomRepository(
    userRepository: ref.read(symptomUserRepositoryProvider),
  );
});

final symptomLogProvider =
    FutureProvider.family<SymptomLog?, DateTime>((ref, date) async {
  return ref.read(symptomRepositoryProvider).loadForDate(date);
});

final symptomLogsProvider = FutureProvider<List<SymptomLog>>((ref) async {
  return ref.read(symptomRepositoryProvider).loadAll();
});

DateTime _normalizeDay(DateTime value) => DateTime(value.year, value.month, value.day);

final symptomDaysProvider = Provider<Set<DateTime>>((ref) {
  final logs = ref.watch(symptomLogsProvider).value ?? const <SymptomLog>[];
  return logs
      .where((log) => log.hasContent)
      .map((log) => _normalizeDay(log.date))
      .toSet();
});
