import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

part 'practice_reminder.g.dart';

@collection
class PracticeReminder {
  Id id = Isar.autoIncrement;
  final DateTime dateTime;

  PracticeReminder({
    required this.dateTime,
  });

  @ignore
  TimeOfDay get time => TimeOfDay.fromDateTime(dateTime);
}
