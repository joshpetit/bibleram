import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:bibleram/home_page.dart';
import 'package:bibleram/models/passage_set.dart';
import 'package:bibleram/utils.dart';
import 'package:shared_storage/shared_storage.dart' as shared_storage;
import 'package:bibleram/main.dart';
import 'package:bibleram/models/app_version_info.dart';
import 'package:bibleram/models/verse_being_memorized.dart';
import 'package:bibleram/services/bible_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:isar/isar.dart';
import 'package:path/path.dart';
import 'package:reference_parser/reference_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/passage_being_memorized.dart';

class AppCubit extends Cubit<AppState> {
  final Random _numberGenerator = Random();
  final SharedPreferences sharedPreferences;

  AppCubit({
    AppState? initialState,
    required this.sharedPreferences,
  }) : super(
          initialState ??
              AppState(
                verse: VerseBeingMemorized(
                  version: "",
                  stage: 1,
                  verseText: "",
                  reference: "",
                  wordsRemoved: 1,
                  percentMemorized: 0,
                ),
                versesBeingMemorized:
                    isar.verseBeingMemorizeds.where().findAllSync(),
                passagesBeingMemorized:
                    isar.passageBeingMemorizeds.where().findAllSync(),
                passageSets: isar.passageSets
                    .where()
                    .sortByDateCreatedDesc()
                    .findAllSync(),
              ),
        );

  void removePassage({
    required PassageBeingMemorized passage,
  }) {
    List<VerseBeingMemorized> yeetedVerses =
        List.from(state.versesBeingMemorized);

    List<PassageBeingMemorized> yeetedPassages =
        List.from(state.passagesBeingMemorized);
    yeetedPassages.removeWhere((element) => element == passage);
    isar.writeTxnSync(() {
      for (final passageSet in state.passageSets) {
        passageSet.passages.removeWhere((_passage) => _passage == passage);
        passageSet.passages.saveSync();
      }
      isar.passageBeingMemorizeds.deleteSync(passage.id);
    });

    var newState = state.copyWith(
      passagesBeingMemorized: yeetedPassages,
      versesBeingMemorized: yeetedVerses,
    );
    emit(newState);
  }

  void addPassageToSet(int passageSetId, int passageBeingMemorizedId) {
    var passageSet =
        state.passageSets.firstWhere((element) => element.id == passageSetId);
    var passage = state.passagesBeingMemorized
        .firstWhere((element) => element.id == passageBeingMemorizedId);

    passageSet.passages.add(passage);
    isar.writeTxnSync(() {
      passageSet.passages.saveSync();
    });

    emit(state.copyWith());
  }

  void removePassageFromSet(int passageSetId, int passageBeingMemorizedId) {
    var passageSet =
        state.passageSets.firstWhere((element) => element.id == passageSetId);

    passageSet.passages.removeWhere((e) => e.id == passageBeingMemorizedId);
    isar.writeTxnSync(() {
      passageSet.passages.saveSync();
    });

    emit(state.copyWith());
  }

  AppState fillQueue(AppState state) {
    List<PassageBeingMemorized> options = switch (state.memorizationMode) {
      MemorizationMode.random => state.passagesBeingMemorized,
      MemorizationMode.review =>
        state.passagesBeingMemorized.where((e) => e.percentMemorized > 60),
      MemorizationMode.unfamiliar =>
        state.passagesBeingMemorized.where((e) => e.percentMemorized < 60)
    }
        .toList();
    if (options.isEmpty) {
      options = state.passagesBeingMemorized;
    }
    options.shuffle();
    var newState = state.copyWith(queue: options);
    return newState;
  }

  void setMemorizationMode(MemorizationMode? memorizationMode) => emit(state
      .copyWith(memorizationMode: memorizationMode, queueIndex: 0, queue: []));

  void addPassageToBeMemorized({
    required Reference selectedReference,
    required List<VerseBeingMemorized> refVerses,
    required String version,
    bool setAsVerseAfter = false,
  }) {
    List<VerseBeingMemorized> yeetedVerses =
        List.from(state.versesBeingMemorized);

    List<PassageBeingMemorized> yeetedPassages =
        List.from(state.passagesBeingMemorized);
    List<VerseBeingMemorized> versesInPassage = [];

    for (var verse in refVerses) {
      var alreadyAdded = yeetedVerses.contains(verse);
      if (!alreadyAdded) {
        isar.writeTxnSync(() {
          isar.verseBeingMemorizeds.putSync(verse);
        });
        yeetedVerses.add(verse);
        versesInPassage.add(verse);
      } else {
        versesInPassage
            .add(yeetedVerses.firstWhere((element) => element == verse));
      }
    }

    PassageBeingMemorized passage = PassageBeingMemorized(
      reference: selectedReference.reference!,
      version: version,
    );
    passage.versesInPassage.addAll(versesInPassage);
    var alreadyHavePassage = yeetedPassages.contains(passage);

    if (alreadyHavePassage) {
      if (setAsVerseAfter) {
        passage = yeetedPassages.firstWhere((e) => e == passage);
        var newState = _setPassageBeingMemorized(state, passage);
        emit(newState);
      }
      throw PassageAlreadyAddedException();
    }

    if (!alreadyHavePassage) {
      isar.writeTxnSync(() {
        isar.passageBeingMemorizeds.putSync(passage);
        passage.versesInPassage.saveSync();
      });
      passage = isar.passageBeingMemorizeds.getSync(passage.id)!;
      yeetedPassages.add(passage);
    }

    var newState = state.copyWith(
      passagesBeingMemorized: yeetedPassages,
      versesBeingMemorized: yeetedVerses,
    );
    if (setAsVerseAfter) {
      newState = _setPassageBeingMemorized(newState, passage);
    }
    emit(newState);
  }

  void start({
    PassageBeingMemorized? passage,
    List<PassageBeingMemorized>? passages,
  }) {
    var newState = state.copyWith(queueIndex: 0);
    newState = newState.copyWith(queue: passages ?? []);
    _selectNewPassage(newState, passage);
  }

  void nextPassage() {
    _selectNewPassage(state);
  }

  void previousPassage() {
    var newQueueIndex = state.queueIndex - 2;
    if (newQueueIndex <= -1) {
      newQueueIndex = state.queue.length - 2;
    }
    var newState = state.copyWith(queueIndex: newQueueIndex);
    _selectNewPassage(newState);
  }

  void _selectNewPassage(AppState newState, [PassageBeingMemorized? passage]) {
    if (newState.queue.isEmpty) {
      newState = fillQueue(newState);
    }

    if (newState.queue.contains(passage)) {
      var queue = newState.queue;
      queue.remove(passage);
      newState = newState.copyWith(queue: queue);
    }
    if (passage != null) {
      newState = newState.copyWith(queue: newState.queue..insert(0, passage));
    }

    passage ??= newState.queue[newState.queueIndex];

    int nextIndex = newState.queueIndex + 1;
    if (nextIndex >= newState.queue.length) {
      nextIndex = 0;
    }

    newState = newState.copyWith(queueIndex: nextIndex);
    newState = _setPassageBeingMemorized(newState, passage);
    emit(newState);
  }

  AppState _setPassageBeingMemorized(
      AppState newState, PassageBeingMemorized passage) {
    var verse = passage.verses[0];
    newState = newState.copyWith(
      verseBeingMemorized: verse,
      passageBeingMemorized: passage,
    );
    newState = _createNewIteration(newState);
    return newState;
  }

  AppState _createNewIteration(AppState newState) {
    newState = newState.copyWith(
      guessingReference: false,
      removedReferenceIndicies: [],
      hadWrongAnswerOnIteration: false,
    );
    newState = _removeRandomIndicies(newState);
    newState = _buildDisplayedTextParts(newState);
    newState = _buildReferenceDisplayedTextParts(newState);
    newState = _generateResponses(newState);
    return newState;
  }

  void refreshBoard() {
    var newState = _createNewIteration(state);
    emit(newState);
  }

  AppState _generateResponses(AppState newState) {
    int correctIndex = _numberGenerator.nextInt(4);
    List<DisplayOption> options = [];
    var rightOption = newState.splitVerse[newState.removedIndicies[0]];
    List<String> usedWrongOptions = [];
    String regex =
        r'[^\p{Alphabetic}\p{Mark}\p{Decimal_Number}\p{Connector_Punctuation}\p{Join_Control}\s]+';
    rightOption = rightOption.replaceAll(RegExp(regex, unicode: true), '');
    for (int i = 0; i < 4; i++) {
      if (correctIndex != i) {
        var wrongOptions = wrongAnswers
            .where(
              (e) =>
                  e.toLowerCase() != rightOption.toLowerCase() &&
                  !usedWrongOptions.contains(e.toLowerCase()),
            )
            .toList();
        var wrongIndex = _numberGenerator.nextInt(wrongOptions.length);
        var nextWrongAnswer = wrongOptions[wrongIndex];
        usedWrongOptions.add(nextWrongAnswer.toLowerCase());
        options.add(
          DisplayOption(
            correctAnswer: false,
            enterOption: answerWrong,
            value: nextWrongAnswer,
          ),
        );
        continue;
      }
      options.add(
        DisplayOption(
          correctAnswer: true,
          enterOption: answerRight,
          value: rightOption,
        ),
      );
    }

    newState = newState.copyWith(
      displayOptions: options,
    );
    return newState;
  }

  AppState _generateReferenceResponses(AppState newState) {
    int correctIndex = _numberGenerator.nextInt(4);
    List<DisplayOption> options = [];
    var correctTing =
        newState.splitReference[newState.removedReferenceIndicies[0]];
    List<String> usedWrongOptions = [];
    bool isNumber = int.tryParse(correctTing) != null;
    for (int i = 0; i < 4; i++) {
      if (correctIndex == i) {
        options.add(
          DisplayOption(
            correctAnswer: true,
            enterOption: answerReferenceRight,
            value: correctTing,
          ),
        );
        continue;
      }

      String wrongOption;
      if (isNumber) {
        do {
          wrongOption = (_numberGenerator.nextInt(30) + 1).toString();
        } while (wrongOption.toString() == correctTing ||
            usedWrongOptions.contains(wrongOption));
      } else {
        List<String> wrongOptions = bookNames
            .where((e) => e != correctTing && !usedWrongOptions.contains(e))
            .toList();
        var wrongIndex = _numberGenerator.nextInt(wrongOptions.length);
        wrongOption = wrongOptions[wrongIndex];
      }

      options.add(
        DisplayOption(
          correctAnswer: false,
          // Don't do anything when you select a wrong reference option.
          enterOption: () {},
          value: wrongOption,
        ),
      );
      usedWrongOptions.add(wrongOption);
    }

    newState = newState.copyWith(
      displayOptions: options,
    );
    return newState;
  }

  AppState _removeRandomIndicies(AppState newState) {
    List<int> _currentlyRemovedIndicies = [];
    for (int i = 0; i < newState.wordsRemoved;) {
      bool removedAllWords =
          _currentlyRemovedIndicies.length == newState.wordsInVerse;
      if (removedAllWords) {
        break;
      }
      var positionToRemove = _numberGenerator.nextInt(newState.wordsInVerse);

      if (!_currentlyRemovedIndicies.contains(positionToRemove)) {
        _currentlyRemovedIndicies.add(positionToRemove);
        i++;
      }
    }
    _currentlyRemovedIndicies.sort();
    newState = newState.copyWith(
      removedIndicies: _currentlyRemovedIndicies,
    );
    return newState;
  }

  void createSet(String setName) {
    var newSet = PassageSet(name: setName, dateCreated: DateTime.now());
    var newState = state.copyWith(passageSets: [
      newSet,
      ...state.passageSets,
    ]);
    isar.writeTxnSync(() {
      isar.passageSets.putSync(newSet);
    });

    emit(newState);
  }

  AppState _buildDisplayedTextParts(AppState newState) {
    List<DisplayTextPart> newDisplaySpans = [];
    var numWordsInVerse = newState.splitVerse.length;
    for (int i = 0; i < numWordsInVerse; i++) {
      bool lastWordInVerse = i == numWordsInVerse;
      String append = "";
      String text = newState.splitVerse[i];
      if (!lastWordInVerse) {
        append = " ";
      }
      if (newState.removedIndicies.contains(i)) {
        bool firstBlank = newState.removedIndicies[0] == i;
        newDisplaySpans.add(
          DisplayTextPart(
            text: "${'_' * text.length}$append",
            type:
                firstBlank ? TextType.highlightedUnderline : TextType.underline,
          ),
        );
      } else {
        newDisplaySpans.add(
          DisplayTextPart(
            text: text + append,
            type: TextType.text,
          ),
        );
      }
    }
    return newState.copyWith(displaySpans: newDisplaySpans);
  }

  AppState _buildReferenceDisplayedTextParts(AppState newState) {
    List<DisplayTextPart> newDisplaySpans = [];
    var numWordsInReference = newState.splitReference.length;
    for (int i = 0; i < numWordsInReference; i++) {
      bool lastWordInVerse = i == numWordsInReference;
      bool secondToLastWordInRef = i == (numWordsInReference - 2);
      String append = "";
      String text = newState.splitReference[i];
      if (secondToLastWordInRef) {
        append = ":";
      } else if (!lastWordInVerse) {
        append = " ";
      }
      if (newState.removedReferenceIndicies.contains(i)) {
        bool firstBlank = newState.removedReferenceIndicies[0] == i;
        newDisplaySpans.add(
          DisplayTextPart(
            text: "${'_' * text.length}$append",
            type:
                firstBlank ? TextType.highlightedUnderline : TextType.underline,
          ),
        );
      } else {
        newDisplaySpans.add(
          DisplayTextPart(
            text: text + append,
            type: TextType.text,
          ),
        );
      }
    }
    return newState.copyWith(displayReferenceSpans: newDisplaySpans);
  }

  VerseBeingMemorized determineConfigurationByMemorization(
      VerseBeingMemorized verse) {
    return switch (verse.percentMemorized) {
      < 10 => verse.copyWith(wordsRemoved: 1, stage: 1),
      < 20 =>
        verse.copyWith(wordsRemoved: min(2, verse.wordsRemoved), stage: 2),
      < 33 =>
        verse.copyWith(wordsRemoved: min(3, verse.wordsInVerse), stage: 3),
      < 60 =>
        verse.copyWith(wordsRemoved: min(4, verse.wordsInVerse), stage: 4),
      < 80 => verse.copyWith(
          wordsRemoved: max((verse.wordsInVerse * .8).ceil(), 5),
          stage: 4,
        ),
      _ => verse.copyWith(wordsRemoved: verse.wordsInVerse, stage: 5),
    };
  }

  Future<void> exportData(String? outputDir, Uri? selectedUri) async {
    var timeStamp = DateFormat('MM-dd-yy-Hmmss').format(DateTime.now());
    var versesToBeExported = state.passagesBeingMemorized
        .map((e) => e.versesInPassage.toList())
        .toList();
    var realVersesToBeExported = [];
    for (var element in versesToBeExported) {
      realVersesToBeExported.addAll(element);
    }

    var verses = realVersesToBeExported;
    var versesJson = verses
        .map((e) => {
              'percentMemorized': e.percentMemorized,
              'reference': e.reference,
              'version': e.version,
            })
        .toList();
    var passages = state.passagesBeingMemorized;
    var passagesJson = passages
        .map((e) => {
              'version': e.version,
              'reference': e.reference,
            })
        .toList();
    var sets = state.passageSets;
    var setsJson = sets
        .map(
          (e) => {
            'passages': e.passages.map((e) => e.id).toList(),
            'dateCreated': e.dateCreated.toIso8601String(),
            'name': e.name
          },
        )
        .toList();
    var appData = {
      'verses': versesJson,
      'passages': passagesJson,
      'sets': setsJson,
      'serializationVersion': AppVersionInfo.serializationVersion,
    };
    var appJson = jsonEncode(appData);

    if (outputDir != null) {
      var path = join(outputDir, '$timeStamp-bibleram-data.json');
      var file = File(path);
      await file.writeAsString(appJson);
    } else {
      await shared_storage.createFileAsString(
        selectedUri!,
        content: appJson,
        mimeType: 'application/json',
        displayName: '$timeStamp-bibleram-data',
      );
    }
  }

  /// Merges the first list passed in into the second list
  List<T> mergeLists<T>(
    List<T> source,
    List<T> toBeOverwritten,
  ) {
    var sourceSet = source.toSet();
    for (var item in toBeOverwritten) {
      if (!sourceSet.contains(item)) {
        sourceSet.add(item);
      }
    }
    return sourceSet.toList();
  }

  Future<void> clearData() async {
    isar.writeTxn(() async {
      await isar.clear();
    });
    var newState = AppState(
        verse: VerseBeingMemorized(
          verseText: '',
          reference: '',
          version: '',
          percentMemorized: 0,
          wordsRemoved: 0,
          stage: 1,
        ),
        passagesBeingMemorized: [],
        versesBeingMemorized: [],
        passageSets: []);
    emit(newState);
  }

  Future<void> importData(File file) async {
    BibleService bible = BibleService();
    bible.setDatabaseVersion(version: "NKJV");
    var realFile = File(file.path);
    var data = await realFile.readAsString();
    var decoded = jsonDecode(data);
    List<PassageBeingMemorized> importedPassages = [];
    List<VerseBeingMemorized> importedVerses = [];

    for (var verseData in decoded['verses']) {
      await bible.setDatabaseVersion(version: verseData['version']);
      var verseTexts = await bible
          .getVersesBeingMemorized(parseReference(verseData['reference']));
      var wordsRemoved = _getWordsRemovedFor(
        percentMemorized: verseData['percentMemorized'],
        wordsInVerse: verseTexts[0].wordsInVerse,
      );
      var verse = verseTexts[0].copyWith(
        reference: verseData['reference'],
        version: verseData['version'],
        percentMemorized: verseData['percentMemorized'],
        wordsRemoved: wordsRemoved,
      );
      verse = verse.copyWith(
        stage: _getStageFor(
            percentMemorized: verse.percentMemorized,
            percentRemoved: verse.percentRemoved),
      );
      importedVerses.add(verse);
    }

    for (var passageData in decoded['passages']) {
      await bible.setDatabaseVersion(version: passageData['version']);
      var verseTexts = await bible
          .getVersesBeingMemorized(parseReference(passageData['reference']));
      var passage = PassageBeingMemorized(
        reference: passageData['reference'],
        version: passageData['version'],
      );
      VerseBeingMemorized verseToAdd;
      for (var verse in verseTexts) {
        if (importedVerses.contains(verse)) {
          verseToAdd = importedVerses.firstWhere((element) => element == verse);
        } else {
          verseToAdd = verse;
        }
        passage.versesInPassage.add(verseToAdd);
      }
      importedPassages.add(passage);
    }

    var newVerses = mergeLists(importedVerses, state.versesBeingMemorized);
    var newPassages =
        mergeLists(importedPassages, state.passagesBeingMemorized);

    List<PassageSet> newSets = [];
    if (decoded['sets'] != null) {
      for (var setData in decoded['sets']) {
        var newSet = PassageSet(
            name: setData['name'],
            dateCreated: DateTime.parse(setData['dateCreated']));

        newSet.passages.addAll(newPassages.where((e) {
          print(e.id);
          print(setData['passages']);
          return setData['passages'].contains(e.id);
        }));
        newSets.add(newSet);
      }
    }

    await isar.writeTxn(() async {
      await isar.verseBeingMemorizeds.putAll(newVerses);
      await isar.passageBeingMemorizeds.putAll(newPassages);
      await isar.passageSets.putAll(newSets);
      for (var passage in newPassages) {
        await passage.versesInPassage.save();
      }
      for (var passage in newSets) {
        await passage.passages.save();
      }
      newPassages = await isar.passageBeingMemorizeds.where().findAll();
      newSets = await isar.passageSets.where().findAll();
    });

    var newState = state.copyWith(
      versesBeingMemorized: newVerses,
      passagesBeingMemorized: newPassages,
      passageSets: newSets,
    );
    emit(newState);
  }

  void fastForward() {
    var verse = state.verseBeingMemorized;
    var newVerse = switch (verse.percentMemorized) {
      < 35 => verse.copyWith(percentMemorized: 50),
      < 60 => verse.copyWith(percentMemorized: 70),
      _ => verse.copyWith(percentMemorized: max(verse.percentMemorized, 90)),
    };
    newVerse = determineConfigurationByMemorization(newVerse);
    var newState = state.copyWith(
      guessingReference: false,
      removedReferenceIndicies: [],
      verseBeingMemorized: newVerse,
    );

    newState = _createNewIteration(newState);
    newState = saveVerseData(newState);
    emit(newState);
  }

  void startOver() {
    var newVerse = state.verseBeingMemorized.copyWith(percentMemorized: 0);
    newVerse = determineConfigurationByMemorization(newVerse);
    var newState = state.copyWith(
      guessingReference: false,
      removedReferenceIndicies: [],
      verseBeingMemorized: newVerse,
    );
    newState = _createNewIteration(newState);
    newState = saveVerseData(newState);
    emit(newState);
  }

  void answerWrong() {
    var newVerse = state.verseBeingMemorized.copyWith();
    if (state.hadWrongAnswerOnIteration) return;
    newVerse = switch (newVerse.stage) {
      1 => newVerse.copyWith(
          percentMemorized:
              (newVerse.percentMemorized - stage1MemorizationGain).clamp(0, 10),
        ),
      2 => newVerse.copyWith(
          percentMemorized:
              (newVerse.percentMemorized - stage2MemorziationPenalty)
                  .clamp(0, 100),
          wordsRemoved: 2,
        ),
      3 => newVerse.copyWith(
          percentMemorized: newVerse.percentMemorized - 5,
          wordsRemoved: (newVerse.wordsRemoved - 1).clamp(2, 100),
        ),
      4 => newVerse.copyWith(
          percentMemorized: (newVerse.percentMemorized - 5).clamp(0, 100),
          wordsRemoved: (newVerse.wordsRemoved - 1).clamp(2, 100),
        ),
      5 => newVerse.copyWith(
          percentMemorized: newVerse.percentMemorized - 10,
          wordsRemoved: newVerse.wordsInVerse - 1,
        ),
      6 => newVerse.copyWith(
          wordsRemoved: newVerse.wordsInVerse, percentMemorized: 90),
      _ => newVerse
    };
    newVerse = newVerse.copyWith(
      stage: _getStageFor(
        percentMemorized: newVerse.percentMemorized,
        percentRemoved: newVerse.percentRemoved,
      ),
    );
    var newState = state.copyWith(
      verseBeingMemorized: newVerse,
      hadWrongAnswerOnIteration: true,
    );
    emit(newState);
  }

  void answerReferenceRight() {
    var newReferenceIndicies = List<int>.from(state.removedReferenceIndicies);
    AppState newState;
    if (newReferenceIndicies.length <= 1) {
      newState = state.copyWith(
        removedReferenceIndicies: [],
        guessingReference: false,
      );
      if (newState.verseBeingMemorized.percentMemorized >= 100) {
        newState = _goToNextVerse(newState);
      }
      newState = _createNewIteration(newState);
      emit(newState);
      return;
    }
    newReferenceIndicies.removeAt(0);
    newState = state.copyWith(removedReferenceIndicies: newReferenceIndicies);
    newState = _buildReferenceDisplayedTextParts(newState);
    newState = _generateReferenceResponses(newState);
    emit(newState);
  }

  void startGuessingReference(AppState newState) {
    newState = newState.copyWith(guessingReference: true);
    List<int> _currentlyRemovedIndicies = [];
    for (int i = 0; i < newState.splitReference.length; i++) {
      _currentlyRemovedIndicies.add(i);
    }
    _currentlyRemovedIndicies.sort();
    newState = newState.copyWith(
      removedReferenceIndicies: _currentlyRemovedIndicies,
    );
    newState = _buildReferenceDisplayedTextParts(newState);
    newState = _generateReferenceResponses(newState);
    emit(newState);
  }

  void answerRight() {
    var newRemovedIndicies = List<int>.from(state.removedIndicies);
    newRemovedIndicies.removeAt(0);
    AppState newState = state.copyWith(
      removedIndicies: newRemovedIndicies,
    );
    if (newRemovedIndicies.isNotEmpty) {
      newState = _generateResponses(newState);
      newState = _buildDisplayedTextParts(newState);
      emit(newState);
      return;
    }
    newState = _buildDisplayedTextParts(newState);
    var newVerse = state.verseBeingMemorized.copyWith();
    if (!state.hadWrongAnswerOnIteration) {
      newVerse = switch (newVerse.stage) {
        1 => newVerse.copyWith(
            percentMemorized:
                (newVerse.percentMemorized + stage1MemorizationGain)
                    .clamp(0, 10),
          ),
        2 => newVerse.copyWith(
            percentMemorized:
                (newVerse.percentMemorized + stage2MemorizationGain)
                    .clamp(0, 100),
            wordsRemoved: 2,
          ),
        3 => newVerse.copyWith(
            percentMemorized: max(
              newVerse.percentMemorized + 2,
              (newVerse.percentRemoved * 2).clamp(0, 60),
            ),
            wordsRemoved: newVerse.wordsRemoved + 1,
          ),
        4 => newVerse.copyWith(
            percentMemorized: max(
              newVerse.percentMemorized + 5,
              60,
            ).clamp(0, 80),
            wordsRemoved: max(
              newVerse.wordsRemoved,
              (newVerse.wordsInVerse * .80).ceil(),
            ),
          ),
        5 => newVerse.copyWith(
            percentMemorized:
                max(newVerse.percentMemorized + 5, 80).clamp(0, 100),
            wordsRemoved: newVerse.wordsInVerse,
          ),
        _ => newVerse
      };
    }
    newState = newState.copyWith(hadWrongAnswerOnIteration: false);

    newVerse = newVerse.copyWith(
      stage: _getStageFor(
        percentMemorized: newVerse.percentMemorized,
        percentRemoved: newVerse.percentRemoved,
      ),
    );

    newState = newState.copyWith(
      verseBeingMemorized: newVerse,
    );
    newState = saveVerseData(newState);
    startGuessingReference(newState);
    return;
  }

  void goToPreviousVerse() {
    var newState = _goToPreviousVerse(state);
    newState = _createNewIteration(newState);
    emit(newState);
  }

  void goToNextVerse() {
    var newState = _goToNextVerse(state);
    newState = _createNewIteration(newState);
    emit(newState);
  }

  AppState _goToPreviousVerse(AppState newState) {
    var indexInMemorization = newState.indexInMemorization;
    int newIndexInMemorization = indexInMemorization - 1;
    if (newIndexInMemorization == -1) {
      newIndexInMemorization = newState.totalBeingMemorized - 1;
    }
    var newVerse = newState.passageBeingMemorized!.verses
        .elementAt(newIndexInMemorization);
    newState = newState.copyWith(verseBeingMemorized: newVerse);
    return newState;
  }

  AppState _goToNextVerse(AppState newState) {
    var indexInMemorization = newState.indexInMemorization;
    int newIndexInMemorization = indexInMemorization + 1;
    if (newIndexInMemorization == newState.totalBeingMemorized) {
      newIndexInMemorization = 0;
    }
    var newVerse = newState.passageBeingMemorized!.verses
        .elementAt(newIndexInMemorization);
    newState = newState.copyWith(verseBeingMemorized: newVerse);
    return newState;
  }

  _getWordsRemovedFor({
    required int percentMemorized,
    required int wordsInVerse,
  }) {
    return switch (percentMemorized) {
      < 10 => 1,
      < 20 => 2,
      < 60 => min(wordsInVerse, 4),
      < 80 => (wordsInVerse * .80).ceil(),
      _ => wordsInVerse,
    };
  }

  _getStageFor({
    required int percentMemorized,
    required int percentRemoved,
  }) {
    return switch ((percentMemorized, percentRemoved)) {
      (< 10, _) => 1,
      (< 20, _) => 2,
      (_, < 33) => 3,
      // Baseline for stage for is 80%, so once you've guessed 4 right (5% inc each time)
      // Move on to stage 5
      (< 80, < 100) => 4,
      (< 100, <= 100) => 5,
      (100, 100) => 6,
      (_, _) => 6
    };
  }

  AppState saveVerseData(AppState newState) {
    var verse = newState.verseBeingMemorized;
    isar.writeTxnSync(() {
      isar.verseBeingMemorizeds.putSync(verse);
    });

    replaceWithNewVerse(VerseBeingMemorized e) => e == verse ? verse : e;

    var newList =
        newState.versesBeingMemorized.map(replaceWithNewVerse).toList();
    var newPassages = <PassageBeingMemorized>[];
    for (var passage in newState.passagesBeingMemorized) {
      var newVerseList = passage.verses.map(replaceWithNewVerse).toList();
      passage.verses = newVerseList;
      newPassages.add(passage);
    }
    var newSets = <PassageSet>[];
    for (var passageSet in newState.passageSets) {
      for (var passage in passageSet.passages) {
        var newVerseList = passage.verses.map(replaceWithNewVerse).toList();
        passage.verses = newVerseList;
      }
      newSets.add(passageSet);
    }
    return newState.copyWith(
      versesBeingMemorized: newList,
      passagesBeingMemorized: newPassages,
      passageSets: newSets,
    );
  }

  void setPracticeMode(PracticeMode? selectedMode) {
    var newState = state.copyWith(practiceMode: selectedMode);
    emit(newState);
  }

  void onPeekText() {
    var newState = state.copyWith(hadWrongAnswerOnIteration: true);
    emit(newState);
  }

  void practiceSet(PassageSet passageSet) {
    var queue = passageSet.passages.toList();
    start(passages: queue);
  }
}

class PassageAlreadyAddedException implements Exception {}

class AppState {
  final VerseBeingMemorized verseBeingMemorized;
  final List<DisplayTextPart> displaySpans;
  final List<DisplayTextPart> displayReferenceSpans;
  final List<String> splitVerse;
  final List<String> splitReference;
  final List<DisplayOption> displayOptions;
  final List<PassageBeingMemorized> queue;
  final int queueIndex;

  final MemorizationMode memorizationMode;
  final PracticeMode practiceMode;

  final List<int> removedIndicies;
  final List<int> removedReferenceIndicies;
  final bool hadWrongAnswerOnIteration;
  final bool guessingReference;

  final PassageBeingMemorized? passageBeingMemorized;
  final List<PassageBeingMemorized> passagesBeingMemorized;
  final List<VerseBeingMemorized> versesBeingMemorized;
  final List<PassageSet> passageSets;

  int get wordsInVerse => splitVerse.length;
  int get wordsRemoved => verseBeingMemorized.wordsRemoved;
  int get indexInMemorization =>
      passageBeingMemorized!.verses.indexOf(verseBeingMemorized);
  int get totalBeingMemorized => passageBeingMemorized!.verses.length;

  AppState._({
    required this.verseBeingMemorized,
    this.guessingReference = false,
    this.displaySpans = const [],
    this.displayReferenceSpans = const [],
    this.displayOptions = const [],
    this.removedIndicies = const [],
    this.queue = const [],
    this.queueIndex = 0,
    this.removedReferenceIndicies = const [],
    this.hadWrongAnswerOnIteration = false,
    this.passageBeingMemorized,
    this.passagesBeingMemorized = const [],
    this.versesBeingMemorized = const [],
    this.passageSets = const [],
    this.memorizationMode = MemorizationMode.random,
    this.practiceMode = PracticeMode.normal,
  })  : splitVerse = verseBeingMemorized.verseText.trim().split(" ")
          ..removeWhere((e) => e.isEmpty),
        splitReference = _parseReference(verseBeingMemorized.reference);

  static List<String> _parseReference(String referenceBeingGuessed) {
    final List<String> finalRef = [];
    var partsOfReference = referenceBeingGuessed.split(" ");
    var numbers = partsOfReference.removeLast();
    finalRef.addAll(partsOfReference);
    finalRef.addAll(numbers.split(":"));
    return finalRef;
  }

  AppState({
    required VerseBeingMemorized verse,
    required List<PassageBeingMemorized> passagesBeingMemorized,
    required List<VerseBeingMemorized> versesBeingMemorized,
    required List<PassageSet> passageSets,
  }) : this._(
          verseBeingMemorized: verse,
          passagesBeingMemorized: passagesBeingMemorized,
          passageSets: passageSets,
        );

  AppState copyWith({
    List<DisplayTextPart>? displaySpans,
    List<DisplayTextPart>? displayReferenceSpans,
    List<int>? removedIndicies,
    List<int>? removedReferenceIndicies,
    List<DisplayOption>? displayOptions,
    bool? hadWrongAnswerOnIteration,
    String? referenceBeingGuessed,
    bool? guessingReference,
    String? versionOfVerse,
    VerseBeingMemorized? verseBeingMemorized,
    PassageBeingMemorized? passageBeingMemorized,
    List<VerseBeingMemorized>? versesBeingMemorized,
    List<PassageBeingMemorized>? passagesBeingMemorized,
    List<PassageBeingMemorized>? queue,
    int? queueIndex,
    List<PassageSet>? passageSets,
    MemorizationMode? memorizationMode,
    PracticeMode? practiceMode,
  }) =>
      AppState._(
        queue: queue ?? this.queue,
        queueIndex: queueIndex ?? this.queueIndex,
        versesBeingMemorized: versesBeingMemorized ?? this.versesBeingMemorized,
        passageSets: passageSets ?? this.passageSets,
        passagesBeingMemorized:
            passagesBeingMemorized ?? this.passagesBeingMemorized,
        verseBeingMemorized: verseBeingMemorized ?? this.verseBeingMemorized,
        displaySpans: displaySpans ?? this.displaySpans,
        guessingReference: guessingReference ?? this.guessingReference,
        displayReferenceSpans:
            displayReferenceSpans ?? this.displayReferenceSpans,
        removedIndicies: removedIndicies ?? this.removedIndicies,
        removedReferenceIndicies:
            removedReferenceIndicies ?? this.removedReferenceIndicies,
        displayOptions: displayOptions ?? this.displayOptions,
        hadWrongAnswerOnIteration:
            hadWrongAnswerOnIteration ?? this.hadWrongAnswerOnIteration,
        passageBeingMemorized:
            passageBeingMemorized ?? this.passageBeingMemorized,
        memorizationMode: memorizationMode ?? this.memorizationMode,
        practiceMode: practiceMode ?? this.practiceMode,
      );

  @override
  String toString() {
    return """
    AppState:[
verseBeingMemorized: $verseBeingMemorized
displaySpans: $displaySpans
displayReferenceSpans: $displayReferenceSpans
splitVerse: $splitVerse
splitReference: $splitReference
displayOptions: $displayOptions
memorizationMode: $memorizationMode
removedIndicies: $removedIndicies
removedReferenceIndicies: $removedReferenceIndicies
hadWrongAnswerOnIteration: $hadWrongAnswerOnIteration
guessingReference: $guessingReference
passageBeingMemorized: $passageBeingMemorized
passagesBeingMemorized: $passagesBeingMemorized
versesBeingMemorized: $versesBeingMemorized
passageSets: $passageSets
]
""";
  }
}

const stage1MemorizationGain = 2;
const stage1MemorziationPenalty = 2;
const stage1WordsRemoved = 1;

const stage2MemorizationGain = 5;
const stage2MemorziationPenalty = 5;
const stage2WordsRemoved = 2;

const stage3RemovedRate = 1;

class DisplayTextPart {
  final String text;
  final TextType type;

  DisplayTextPart({
    required this.text,
    required this.type,
  });
  @override
  String toString() {
    return """
DisplayTextPart: [
text: $text
type: $type
]
""";
  }
}

enum TextType {
  text,
  underline,
  highlightedUnderline,
}

class DisplayOption {
  final bool correctAnswer;
  final String value;
  final void Function() enterOption;

  DisplayOption({
    required this.correctAnswer,
    required this.value,
    required this.enterOption,
  });

  @override
  String toString() {
    return """
DisplayOption: [
correctAnswer: $correctAnswer
value: $value
]
""";
  }
}

List<String> wrongAnswers = [
  "LORD",
  "God",
  "Jesus",
  "that",
  "I",
  "even",
  "then",
  "He",
  "he",
  "though",
  "come",
  "eternal",
  "sacrifice",
  "sacrifices",
  "they",
  "them",
  "blots",
  "blemish"
];

List<String> bookNames = [
  "Exodus",
  "Leviticus",
  "James",
  "Numbers",
  "Matthew",
  "John",
  "Mark",
  "Luke",
  "Philemon",
  "Isaiah",
  "Philippians",
  "Genesis",
  "Ephesians",
  "Psalms",
  "Romans",
  "Revelation",
];
