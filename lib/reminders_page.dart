import 'package:bibleram/guess_page.dart';
import 'package:bibleram/main.dart';
import 'package:bibleram/models/practice_reminder.dart';
import 'package:bibleram/utils.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

class RemindersPage extends StatefulWidget {
  const RemindersPage({
    super.key,
  });

  @override
  State<RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<RemindersPage> {
  late List<PracticeReminder> practiceReminders;
  @override
  void initState() {
    super.initState();
    practiceReminders = isar.txnSync(() {
      var reminders = isar.practiceReminders.where().findAllSync();
      reminders.sort(_reminderSorter);
      return reminders;
    });
  }

  int _reminderSorter(PracticeReminder a, PracticeReminder b) =>
      a.dateTime.compareTo(b.dateTime);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daily Reminders"),
        elevation: 0,
        backgroundColor: colorScheme.background,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: clearNotifications,
              child: RamTextIconButton(
                icon: Icons.delete_forever_rounded,
                text: "Clear All",
                horizontal: true,
                color: colorScheme.tertiary,
                iconSize: 22,
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListView.separated(
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  var reminder = practiceReminders[index];
                  return Padding(
                    key: Key("${reminder.id}"),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 5),
                    child: Row(
                      children: [
                        Text(
                          reminder.time.format(context),
                          style: textTheme.headlineSmall!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Spacer(),
                        RamTextIconButton(
                          icon: Icons.delete,
                          color: colorScheme.tertiary,
                          iconSize: 30,
                          onTap: () async {
                            await notificationService
                                .flutterLocalNotificationsPlugin
                                .cancel(reminder.id);
                            isar.writeTxnSync(() {
                              isar.practiceReminders.deleteSync(reminder.id);
                            });
                            setState(() {
                              practiceReminders = practiceReminders
                                  .where((element) => element != reminder)
                                  .toList();
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
                itemCount: practiceReminders.length,
                separatorBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        height: 1,
                        color: colorScheme.tertiaryContainer,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 30),
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () async {
                var time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time == null) {
                  return;
                }
                var newReminderTime =
                    PracticeReminder(dateTime: time.toDateTime());
                isar.writeTxnSync(() {
                  isar.practiceReminders.putSync(newReminderTime);
                });
                notificationService.scheduleDailyNotification(
                  notificationTime: newReminderTime.dateTime,
                  id: newReminderTime.id,
                );
                setState(() {
                  practiceReminders.add(newReminderTime);
                  practiceReminders.sort(_reminderSorter);
                });
                await notificationService.flutterLocalNotificationsPlugin
                    .cancel(-1);
              },
              child: RamTextIconButton(
                icon: Icons.add,
                color: colorScheme.onPrimary,
                iconSize: 50,
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            constraints: BoxConstraints(
              maxWidth: 220,
            ),
            child: Text(
              "tip: memorization is most effective in the morning and evening",
              style: textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ),
          Spacer()
        ],
      ),
    );
  }

  void clearNotifications() async {
    await notificationService.flutterLocalNotificationsPlugin.cancelAll();
    isar.writeTxnSync(() {
      isar.practiceReminders.where().deleteAllSync();
    });
    setState(() {
      practiceReminders = [];
    });
  }
}

extension on TimeOfDay {
  DateTime toDateTime() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }
}
