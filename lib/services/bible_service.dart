import 'package:bibleram/add_passage_page/add_passage_cubit.dart';
import 'package:bibleram/book_mapping.dart';
import 'package:bibleram/confs.dart';
import 'package:bibleram/constants.dart';
import 'package:bibleram/main.dart';
import 'package:bibleram/models/verse_being_memorized.dart';
import 'package:reference_parser/reference_parser.dart';
import 'package:path/path.dart' as path_lib;
import 'package:sqflite_sqlcipher/sqflite.dart';

class BibleService {
  Database? _database;
  String _version = "";

  String get version => _version;

  Future<void> setDatabaseVersion({required String version}) async {
    if (_database != null) {
      await _database!.close();
    }
    if (version == _version && _database != null && _database!.isOpen) return;

    var databasesPath = await getDatabasesPath();
    String path = path_lib.join(databasesPath, '${version.toLowerCase()}.db');
    _database = await openDatabase(path,
        version: 1, password: dbpasses[version.toLowerCase()]);
    _version = version;
    sharedPreferences.setString(preferredTranslationKey, version.toUpperCase());
  }

  /// Retrieves the verses being memorized. Initializes to default unlearned state
  /// Doesn't account for if these verses are already being memorized
  Future<List<VerseBeingMemorized>> getVersesBeingMemorized(
    Reference ref,
  ) async {
    assert(
      _database != null,
      "YOU FORGOT TO INITIALIZE THE BIBLE SERVICE DUDE",
    );
    var bookNumber = ref.bookNumber!;
    var databaseBookNumber = withApocryphaMapping[bookNumber];
    var chapterNumber = ref.startChapterNumber;

    List<VerseBeingMemorized> verses = [];
    for (var verseRef in ref.verses!) {
      var verseNumber = verseRef.verseNumber;
      var verse = await _database!.rawQuery(
        "SELECT text FROM verses WHERE book_number=$databaseBookNumber AND chapter=$chapterNumber AND verse=$verseNumber",
      );

      String text = verse[0]['text'] as String;
      text = text.trim();
      text = text.replaceAll(RegExp(' +'), ' ');
      verses.add(
        VerseBeingMemorized(
          verseText: text,
          reference: verseRef.reference!,
          version: _version.toUpperCase(),
          percentMemorized: 0,
          wordsRemoved: 1,
          stage: 1,
        ),
      );
    }

    return verses;
  }

  /// Retrieves the verses being memorized. Initializes to default unlearned state
  /// Doesn't account for if these verses are already being memorized
  Future<List<VerseInfo>> getVersesInRef(
    Reference ref,
  ) async {
    assert(
      _database != null,
      "YOU FORGOT TO INITIALIZE THE BIBLE SERVICE DUDE",
    );
    var bookNumber = ref.bookNumber!;
    var databaseBookNumber = withApocryphaMapping[bookNumber];
    var chapterNumber = ref.startChapterNumber;

    List<VerseInfo> verses = [];
    for (var verseRef in ref.verses!) {
      var verseNumber = verseRef.verseNumber;
      var verse = await _database!.rawQuery(
        "SELECT text FROM verses WHERE book_number=$databaseBookNumber AND chapter=$chapterNumber AND verse=$verseNumber",
      );

      String text = verse[0]['text'] as String;
      text = text.trim();
      text = text.replaceAll(RegExp(' +'), ' ');
      verses.add(
        VerseInfo(
          reference: Reference.verse(
            verseRef.book,
            verseRef.chapterNumber!,
            verseRef.verseNumber,
          ),
          text: text,
        ),
      );
    }

    return verses;
  }
}
