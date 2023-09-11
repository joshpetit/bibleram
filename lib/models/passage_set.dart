import 'package:bibleram/models/passage_being_memorized.dart';
import 'package:bibleram/utils.dart';
import 'package:isar/isar.dart';

part 'passage_set.g.dart';

@collection
class PassageSet {
  Id get id => fastHash("$name${dateCreated.millisecond}");
  String name;

  final passages = IsarLinks<PassageBeingMemorized>();
  DateTime dateCreated;

  PassageSet({
    required this.name,
    required this.dateCreated,
  });

  @ignore
  int get percentMemorized {
    var totalPercent = passages.fold<int>(
      0,
      (newVal, value) => newVal + value.percentMemorized,
    );
    var passagePercent = totalPercent / passages.length;
    return totalPercent != 0 ? passagePercent.floor() : 0;
  }
}

extension Yeet on PassageSet {
  String get description =>
      passages.map((e) => e.reference).join(", ").truncateTo(100);
}
