import 'package:bibleram/models/passage_being_memorized.dart';
import 'package:bibleram/utils.dart';
import 'package:isar/isar.dart';
import 'package:reference_parser/reference_parser.dart';

part 'verse_being_memorized.g.dart';

@collection
class VerseBeingMemorized {
  Id get id => fastHash(reference + version);

  final passagesWithin = IsarLinks<PassageBeingMemorized>();
  String verseText;
  String reference;
  String version;
  int percentMemorized;
  int wordsRemoved;
  int stage;

  int wordsInVerse;
  int get percentRemoved => (wordsRemoved / wordsInVerse * 100).floor();

  @ignore
  Reference get smartReference => parseReference(reference);

  VerseBeingMemorized({
    required this.verseText,
    required this.reference,
    required this.version,
    required this.percentMemorized,
    required this.wordsRemoved,
    required this.stage,
  }) : wordsInVerse = verseText.split(" ").length;

  VerseBeingMemorized copyWith({
    int? percentMemorized,
    int? wordsRemoved,
    int? stage,
    String? reference,
    String? verseText,
    String? version,
  }) =>
      VerseBeingMemorized(
        percentMemorized: percentMemorized ?? this.percentMemorized,
        wordsRemoved: wordsRemoved ?? this.wordsRemoved,
        stage: stage ?? this.stage,
        reference: reference ?? this.reference,
        verseText: verseText ?? this.verseText,
        version: version ?? this.version,
      );

  @override
  bool operator ==(other) {
    if (other is! VerseBeingMemorized) return false;

    return version == other.version && reference == other.reference;
  }

  @ignore
  @override
  int get hashCode => id;

  @override
  String toString() {
    return """
VerseBeingMemorized:[
verseText: $verseText
reference: $reference
version: $version
percentMemorized: $percentMemorized
wordsRemoved: $wordsRemoved
stage: $stage
wordsInVerse: $wordsInVerse
]
""";
  }
}
