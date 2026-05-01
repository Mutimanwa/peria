import 'package:flutter_test/flutter_test.dart';
import 'package:peria_app/features/cycle/data/models/period_log.dart';
import 'package:peria_app/features/cycle/domain/cycle_engine.dart';
import 'package:peria_app/features/cycle/domain/cycle_regularity.dart';

void main() {
  group('CycleEngine - Regular Cycles', () {
    test('should correctly predict next period for regular 28-day cycle', () {
      final logs = [
        PeriodLog(id: '1', startDate: DateTime(2024, 1, 1), endDate: DateTime(2024, 1, 5), isEstimated: false),
        PeriodLog(id: '2', startDate: DateTime(2024, 1, 29), endDate: DateTime(2024, 2, 2), isEstimated: false),
        PeriodLog(id: '3', startDate: DateTime(2024, 2, 26), endDate: DateTime(2024, 3, 1), isEstimated: false),
      ];
      
      final status = CycleEngine.computeFromLogs(
        logs: logs,
        userCycleLengthDays: 28,
        userPeriodLengthDays: 5,
        pmsDaysSetting: 5,
        now: DateTime(2024, 3, 15),
      );
      
      expect(status, isNotNull);
      expect(status!.cycleRegularity, CycleRegularity.regular);
      expect(status.confidenceScore, greaterThan(0.5));
      expect(status.isEstimated, false);
      expect(status.nextPeriodStart, DateTime(2024, 3, 25));
    });
  });
  
  group('CycleEngine - Irregular Cycles', () {
    test('should detect irregular cycles and reduce confidence', () {
      final logs = [
        PeriodLog(id: '1', startDate: DateTime(2024, 1, 1), endDate: DateTime(2024, 1, 5), isEstimated: false),
        PeriodLog(id: '2', startDate: DateTime(2024, 1, 22), endDate: DateTime(2024, 1, 26), isEstimated: false), // 21 days
        PeriodLog(id: '3', startDate: DateTime(2024, 2, 20), endDate: DateTime(2024, 2, 24), isEstimated: false), // 29 days
      ];
      
      final status = CycleEngine.computeFromLogs(
        logs: logs,
        userCycleLengthDays: 28,
        userPeriodLengthDays: 5,
        pmsDaysSetting: 5,
        now: DateTime(2024, 3, 10),
      );
      
      expect(status, isNotNull);
      expect(status!.cycleRegularity, CycleRegularity.irregular);
      expect(status.cycleVariance, greaterThan(5));
      expect(status.confidenceScore, lessThan(0.6));
    });
  });
  
  group('CycleEngine - Missing Logs', () {
    test('should fallback to user-defined values with low confidence', () {
      final logs = [
        PeriodLog(id: '1', startDate: DateTime(2024, 1, 1), endDate: DateTime(2024, 1, 5), isEstimated: false),
      ];
      
      final status = CycleEngine.computeFromLogs(
        logs: logs,
        userCycleLengthDays: 30,
        userPeriodLengthDays: 6,
        pmsDaysSetting: 4,
        now: DateTime(2024, 1, 20),
      );
      
      expect(status, isNotNull);
      expect(status!.cycleLengthDays, 30); // Fallback to user value
      expect(status.periodLengthDays, 6);
      expect(status.confidenceScore, lessThan(0.4));
      expect(status.isEstimated, true);
    });
    
    test('should return null when no logs exist', () {
      final status = CycleEngine.computeFromLogs(
        logs: [],
        userCycleLengthDays: 28,
        userPeriodLengthDays: 5,
        pmsDaysSetting: 5,
      );
      
      expect(status, isNull);
    });
  });
  
  group('CycleEngine - Overdue Detection', () {
    test('should not mark as overdue when within tolerance period', () {
      final logs = [
        PeriodLog(id: '1', startDate: DateTime(2024, 1, 1), endDate: DateTime(2024, 1, 5), isEstimated: false),
      ];
      
      final status = CycleEngine.computeFromLogs(
        logs: logs,
        userCycleLengthDays: 28,
        userPeriodLengthDays: 5,
        pmsDaysSetting: 5,
        now: DateTime(2024, 1, 30), // Day 29 (1 day over expected)
      );
      
      expect(status, isNotNull);
      expect(status!.isOverdue, false); // Within 2-day tolerance
    });
    
    test('should mark as overdue after tolerance period', () {
      final logs = [
        PeriodLog(id: '1', startDate: DateTime(2024, 1, 1), endDate: DateTime(2024, 1, 5), isEstimated: false),
      ];
      
      final status = CycleEngine.computeFromLogs(
        logs: logs,
        userCycleLengthDays: 28,
        userPeriodLengthDays: 5,
        pmsDaysSetting: 5,
        now: DateTime(2024, 2, 1), // Day 32 (4 days over expected)
      );
      
      expect(status, isNotNull);
      expect(status!.isOverdue, true);
    });
    
    test('should not mark as overdue when in active period', () {
      final logs = [
        PeriodLog(id: '1', startDate: DateTime(2024, 2, 26), endDate: DateTime(2024, 3, 2), isEstimated: false),
      ];
      
      final status = CycleEngine.computeFromLogs(
        logs: logs,
        userCycleLengthDays: 28,
        userPeriodLengthDays: 5,
        pmsDaysSetting: 5,
        now: DateTime(2024, 2, 28), // During period
      );
      
      expect(status, isNotNull);
      expect(status!.isInPeriod, true);
      expect(status.isOverdue, false);
    });
  });
  
  group('CycleEngine - Data Priority', () {
    test('should prioritize real logs over predictions', () {
      final logs = [
        PeriodLog(id: '1', startDate: DateTime(2024, 2, 1), endDate: DateTime(2024, 2, 5), isEstimated: false),
      ];
      
      final status = CycleEngine.computeFromLogs(
        logs: logs,
        userCycleLengthDays: 28,
        userPeriodLengthDays: 5,
        pmsDaysSetting: 5,
        now: DateTime(2024, 2, 3), // During real period
      );
      
      expect(status, isNotNull);
      expect(status!.useRealData, true);
      expect(status.isInPeriod, true);
    });
  });
  
  group('CycleEngine - Ovulation Range', () {
    test('should return ovulation range instead of fixed date', () {
      final logs = [
        PeriodLog(id: '1', startDate: DateTime(2024, 1, 1), endDate: DateTime(2024, 1, 5), isEstimated: false),
        PeriodLog(id: '2', startDate: DateTime(2024, 1, 29), endDate: DateTime(2024, 2, 2), isEstimated: false),
      ];
      
      final status = CycleEngine.computeFromLogs(
        logs: logs,
        userCycleLengthDays: 28,
        userPeriodLengthDays: 5,
        pmsDaysSetting: 5,
        now: DateTime(2024, 2, 10),
      );
      
      expect(status, isNotNull);
      expect(status!.ovulationRangeStart, isNotNull);
      expect(status.ovulationRangeEnd, isNotNull);
      expect(status.ovulationRangeEnd.difference(status.ovulationRangeStart).inDays, equals(4)); // ±2 days = 5 day range
    });
  });
  
  group('CycleEngine - PMS Configurability', () {
    test('should use custom PMS days from user settings', () {
      final logs = [
        PeriodLog(id: '1', startDate: DateTime(2024, 1, 1), endDate: DateTime(2024, 1, 5), isEstimated: false),
      ];
      
      final status = CycleEngine.computeFromLogs(
        logs: logs,
        userCycleLengthDays: 28,
        userPeriodLengthDays: 5,
        pmsDaysSetting: 3, // User wants 3 days of PMS
        now: DateTime(2024, 1, 20),
      );
      
      expect(status, isNotNull);
      expect(status!.pmsDays.length, equals(3));
    });
  });
}