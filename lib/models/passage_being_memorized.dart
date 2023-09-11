import 'package:bibleram/models/verse_being_memorized.dart';
import 'package:bibleram/utils.dart';
import 'package:isar/isar.dart';
import 'package:reference_parser/reference_parser.dart';

part 'passage_being_memorized.g.dart';

@collection
class PassageBeingMemorized {
  Id get id => fastHash(reference + version);
  String reference;
  String version;
  @ignore
  String? _cachedText;

  @Backlink(to: "passagesWithin")
  var versesInPassage = IsarLinks<VerseBeingMemorized>();
  @ignore
  late List<VerseBeingMemorized> verses = versesInPassage.toList()
    ..sort(_versesComparator);

  int _versesComparator(
      VerseBeingMemorized verse1, VerseBeingMemorized verse2) {
    var ref1 = verse1.smartReference;
    var ref2 = verse2.smartReference;
    if (ref1.startChapterNumber < ref2.startChapterNumber) {
      return -1;
    } else if (ref1.startChapterNumber > ref2.startChapterNumber) {
      return 1;
    } else if (ref1.startVerseNumber < ref2.startVerseNumber) {
      return -1;
    } else if (ref1.startVerseNumber > ref2.startVerseNumber) {
      return 1;
    }

    return 0;
  }

  PassageBeingMemorized({
    required this.reference,
    this.version = "NKJV",
  });

  int get percentMemorized {
    var totalPercent = verses.fold<int>(
      0,
      (newVal, value) => newVal + value.percentMemorized,
    );
    var passagePercent = totalPercent / versesInPassage.length;
    return totalPercent != 0 ? passagePercent.floor() : 0;
  }

  String passageText() {
    if (_cachedText != null) return _cachedText!;
    // I can remove this regex+trim stuff in a couple weeks when everyone has redownloaded the app
    List<String> verseTexts = verses
        .map((e) => e.verseText.trim().replaceAll(RegExp(' +'), ' '))
        .toList();
    String text = verseTexts.join(" ");
    _cachedText = text;
    return text;
  }

  @ignore
  Reference get smartReference => parseReference(reference);

  @override
  bool operator ==(other) {
    if (other is! PassageBeingMemorized) return false;

    return version == other.version && reference == other.reference;
  }

  @ignore
  @override
  int get hashCode => id;

  @override
  String toString() {
    return """
PassageBeingMemorized:[
reference: $reference
version: $version
_cachedText: $_cachedText
verses: $verses
]
""";
  }
}
