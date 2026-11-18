import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peria_app/core/services/app_notification.dart';
import 'package:peria_app/core/services/notification_schedule_planner.dart';
import 'package:peria_app/core/theme/app_colors.dart';
import 'package:peria_app/features/profile/presentation/widgets/notification_card.dart';

AppNotification _notification({
  bool read = false,
  LocalReminderKind kind = LocalReminderKind.period,
  String id = 'period-2026-05-10',
}) =>
    AppNotification(
      id: id,
      kind: kind,
      scheduledAt: DateTime(2026, 5, 10, 9),
      read: read,
    );

Widget _wrap(Widget child) => MaterialApp(
      home: Scaffold(
        body: Padding(padding: const EdgeInsets.all(20), child: child),
      ),
    );

void main() {
  testWidgets('shows the title, the message and the time', (tester) async {
    await tester.pumpWidget(
      _wrap(
        NotificationCard(
          notification: _notification(),
          title: 'Début des règles',
          body: 'Ta période est peut-être arrivée.',
          timeLabel: '09:00',
        ),
      ),
    );

    expect(find.text('Début des règles'), findsOneWidget);
    expect(find.text('Ta période est peut-être arrivée.'), findsOneWidget);
    expect(find.text('09:00'), findsOneWidget);
  });

  testWidgets('flags an unread message and opens it when tapped',
      (tester) async {
    var taps = 0;

    await tester.pumpWidget(
      _wrap(
        NotificationCard(
          notification: _notification(),
          title: 'Début des règles',
          body: 'Ta période est peut-être arrivée.',
          timeLabel: '09:00',
          onTap: () => taps++,
        ),
      ),
    );

    // Unread cards carry the accent border and an unread dot.
    final material = tester.widget<Material>(
      find
          .descendant(
            of: find.byType(NotificationCard),
            matching: find.byType(Material),
          )
          .first,
    );
    expect(material.elevation, 2);
    expect(find.byIcon(Icons.water_drop_outlined), findsOneWidget);

    await tester.tap(find.text('Début des règles'));
    expect(taps, 1);
  });

  testWidgets('a read message is toned down', (tester) async {
    await tester.pumpWidget(
      _wrap(
        NotificationCard(
          notification: _notification(read: true),
          title: 'Début des règles',
          body: 'Ta période est peut-être arrivée.',
          timeLabel: '09:00',
        ),
      ),
    );

    final material = tester.widget<Material>(
      find
          .descendant(
            of: find.byType(NotificationCard),
            matching: find.byType(Material),
          )
          .first,
    );
    expect(material.elevation, 0);

    final icon = tester.widget<Icon>(find.byIcon(Icons.water_drop_outlined));
    expect(icon.color, AppColors.grey600);
  });

  testWidgets('swiping a message to the left deletes it', (tester) async {
    var deleted = 0;
    var visible = true;

    await tester.pumpWidget(
      _wrap(
        StatefulBuilder(
          builder: (context, setState) => visible
              ? NotificationCard(
                  notification: _notification(),
                  title: 'Début des règles',
                  body: 'Ta période est peut-être arrivée.',
                  timeLabel: '09:00',
                  deleteLabel: 'Supprimer',
                  onDelete: () {
                    deleted++;
                    setState(() => visible = false);
                  },
                )
              : const SizedBox.shrink(),
        ),
      ),
    );

    await tester.drag(find.byType(NotificationCard), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(deleted, 1);
  });

  testWidgets('long pressing a message opens the actions', (tester) async {
    var deleted = 0;

    await tester.pumpWidget(
      _wrap(
        NotificationCard(
          notification: _notification(),
          title: 'Début des règles',
          body: 'Ta période est peut-être arrivée.',
          timeLabel: '09:00',
          onDelete: () => deleted++,
        ),
      ),
    );

    await tester.longPress(find.text('Début des règles'));
    expect(deleted, 1);
  });

  testWidgets('each reminder kind has its own icon', (tester) async {
    Future<void> pumpKind(LocalReminderKind kind) async {
      await tester.pumpWidget(
        _wrap(
          NotificationCard(
            notification: _notification(kind: kind, id: kind.name),
            title: kind.name,
            body: 'Message',
            timeLabel: '09:00',
          ),
        ),
      );
    }

    await pumpKind(LocalReminderKind.fertileWindow);
    expect(find.byIcon(Icons.auto_awesome_outlined), findsOneWidget);

    await pumpKind(LocalReminderKind.ovulation);
    expect(find.byIcon(Icons.brightness_5_outlined), findsOneWidget);

    await pumpKind(LocalReminderKind.dailyCheckIn);
    expect(find.byIcon(Icons.edit_note_rounded), findsOneWidget);
  });
}
