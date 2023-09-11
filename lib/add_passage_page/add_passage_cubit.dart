import 'package:bibleram/services/bible_service.dart';
import 'package:bibleram/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reference_parser/reference_parser.dart';
import 'package:reference_parser/theologian.dart';

class AddPassageCubit extends Cubit<AddPassageState> {
  AddPassageCubit()
      : super(
          AddPassageState(
            selectionMode: SelectionMode.book,
            version: getPreferredTranslation(),
            previewVerses: [],
            bookList: BibleData.bookNames.map((e) => e[2]).toList(),
          ),
        );

  AddPassageState _selectReference(
    AddPassageState newState,
    Reference textFieldReference, {
    bool setToNextMode = true,
  }) {
    newState = setSelectionByReference(newState, textFieldReference,
        setToNextMode: setToNextMode);
    newState = updateReference(newState);
    newState = generateSuggestions(newState);
    return newState;
  }

  Future<void> selectReference(Reference reference) async {
    var newState = _selectReference(state, reference);
    newState = await generatePreviews(newState);
    emit(newState);
  }

  Future<void> setVersion(String version) async {
    var newState = state.copyWith(version: version);
    newState = await generatePreviews(newState);
    emit(newState);
  }

  Future<void> onTextFieldUpdate(String value) async {
    var newState = state.copyWith(filter: value);
    var textFieldReference = parseReference(value);

    newState =
        _selectReference(newState, textFieldReference, setToNextMode: false);
    newState = await generatePreviews(newState);
    emit(newState);
  }

  Future<void> selectNumber(int number) async {
    switch (state.selectionMode) {
      case SelectionMode.chapter:
        await selectChapter(number);
        break;
      case SelectionMode.startVerse:
        await selectStartVerse(number);
        break;
      case SelectionMode.endVerse:
        await selectEndVerse(number);
        break;
      case SelectionMode.book:
        throw Exception(
            "How are you selecting a chapter in book selection mode 🤔");
    }
  }

  Future<void> selectChapter(int chapter) async {
    var newState = _selectReference(
      state,
      Reference(
        state.selectedBook!,
        chapter,
      ),
    );

    newState = await generatePreviews(newState);
    emit(newState);
  }

  void reset() {
    var newState = AddPassageState(
      selectionMode: SelectionMode.book,
      version: getPreferredTranslation(),
      previewVerses: [],
      bookList: BibleData.bookNames.map((e) => e[2]).toList(),
    );
    emit(newState);

    newState = generateSuggestions(newState);
    emit(newState);
  }

  void selectBook(String book) {
    var newState = setSelectionByReference(
      state,
      Reference(
        book,
      ),
    );

    newState = updateReference(newState);
    newState = generateSuggestions(newState);
    emit(newState);
  }

  Future<void> selectStartVerse(int startVerse) async {
    var newState = setSelectionByReference(
      state,
      Reference.verse(
        state.selectedBook!,
        state.selectedChapter!,
        startVerse,
      ),
    );

    newState = updateReference(newState);
    newState = generateSuggestions(newState);
    newState = await generatePreviews(newState);
    emit(newState);
  }

  Future<void> selectEndVerse(int endVerse) async {
    var newState = setSelectionByReference(
      state,
      Reference.verseRange(
        state.selectedBook!,
        state.selectedChapter!,
        state.selectedStartVerse!,
        endVerse,
      ),
    );

    newState = updateReference(newState);
    newState = generateSuggestions(newState);
    newState = await generatePreviews(newState);
    emit(newState);
  }

  void verseClicked(int verseNumber) {
    var newState = setSelectedByClick(verseNumber);
    newState = setSelectionByReference(
      newState,
      Reference(
        newState.selectedBook!,
        newState.selectedChapter,
        newState.selectedStartVerse,
        newState.selectedChapter,
        newState.selectedEndVerse,
      ),
    );

    newState = updateReference(newState);
    newState = generateSuggestions(newState);
    newState = setDisplayVerses(newState);
    emit(newState);
  }

  AddPassageState setSelectedByClick(int verseNumber) {
    return switch ((state.selectedStartVerse, state.selectedEndVerse)) {
      //  start verse not selected
      (null, null) => state.copyWith(selectedStartVerse: () => verseNumber),
      (int start, null) when start == verseNumber => state.copyWith(
          selectedStartVerse: () => null,
        ),
      (int start, null) when start < verseNumber => state.copyWith(
          selectedEndVerse: () => verseNumber,
        ),
      (int start, null) when start > verseNumber => state.copyWith(
          selectedStartVerse: () => verseNumber,
          selectedEndVerse: () => start,
        ),
      (int start, int end)
          when end - start == 1 &&
              (verseNumber == start || verseNumber == end) =>
        state.copyWith(
          selectedEndVerse: () => null,
          selectedStartVerse: () => verseNumber == start ? end : start,
        ),
      (int start, int _) when start == verseNumber => state.copyWith(
          selectedStartVerse: () => verseNumber + 1,
        ),
      (int start, int _) when start > verseNumber => state.copyWith(
          selectedStartVerse: () => verseNumber,
        ),
      (int _, int end) when end == verseNumber => state.copyWith(
          selectedEndVerse: () => end - 1,
        ),
      (int _, int _) => state.copyWith(
          selectedEndVerse: () => verseNumber,
        ),
      (_, _) => state.copyWith(),
    };
  }

  Future<AddPassageState> generatePreviews(AddPassageState newState) async {
    // Cache getting preview from bible service
    if (newState.reference == null || newState.selectedChapter == null) {
      return newState.copyWith(previewVerses: [], verses: []);
    }
    var chapterReference =
        Reference.chapter(newState.selectedBook!, newState.selectedChapter!);
    var oldChapterReference =
        Reference.chapter(state.selectedBook ?? "", state.selectedChapter ?? 0);

    if (chapterReference.reference != oldChapterReference.reference ||
        newState.version != state.version) {
      var bibleService = BibleService();
      await bibleService.setDatabaseVersion(version: newState.version);
      List<VerseInfo> verseInfos =
          await bibleService.getVersesInRef(chapterReference);
      newState = newState.copyWith(verses: verseInfos);
    }

    newState = setDisplayVerses(newState);
    return newState;
  }

  AddPassageState setDisplayVerses(AddPassageState newState) {
    var highlightStart = newState.selectedStartVerse;
    var highlightEnd = newState.selectedEndVerse;

    var displayVerses = newState.verses
        .map(
          (e) => DisplayVerse(
            displayType: highlightStart != null &&
                    e.reference.startVerseNumber
                        .betweenOrEqual(highlightStart, highlightEnd ?? 0)
                ? DisplayType.highlighted
                : DisplayType.normal,
            verseInfo: e,
          ),
        )
        .toList();

    newState = newState.copyWith(previewVerses: displayVerses);
    return newState;
  }

  AddPassageState updateReference(AddPassageState newState) {
    if (newState.selectedBook != null) {
      newState = newState.copyWith(
        reference: () => Reference(
          newState.selectedBook!,
          newState.selectedChapter,
          newState.selectedStartVerse,
          newState.selectedChapter,
          newState.selectedEndVerse,
        ),
      );
    } else {
      newState = newState.copyWith(
        previewVerses: null,
      );
    }
    return newState;
  }

  AddPassageState setSelectionByReference(
    AddPassageState newState,
    Reference reference, {
    setToNextMode = true,
  }) {
    newState = switch (reference.referenceType) {
      ReferenceType.VERSE_RANGE => newState.copyWith(
          selectionMode: SelectionMode.endVerse,
          selectedBook: () => reference.book,
          selectedChapter: () => reference.startChapterNumber,
          selectedStartVerse: () => reference.startVerseNumber,
          selectedEndVerse: () => reference.endVerseNumber,
        ),
      ReferenceType.VERSE => newState.copyWith(
          selectionMode:
              setToNextMode ? SelectionMode.endVerse : SelectionMode.startVerse,
          selectedBook: () => reference.book,
          selectedChapter: () => reference.startChapterNumber,
          selectedStartVerse: () => reference.startVerseNumber,
          selectedEndVerse: () => null,
        ),
      ReferenceType.CHAPTER_RANGE => newState.copyWith(
          selectionMode: SelectionMode.chapter,
          selectedStartVerse: () => null,
          selectedEndVerse: () => null,
        ),
      ReferenceType.CHAPTER => newState.copyWith(
          selectionMode:
              setToNextMode ? SelectionMode.startVerse : SelectionMode.chapter,
          selectedBook: () => reference.book,
          selectedChapter: () => reference.startChapterNumber,
          selectedStartVerse: () => null,
          selectedEndVerse: () => null,
        ),
      ReferenceType.BOOK => newState.copyWith(
          selectionMode:
              setToNextMode ? SelectionMode.chapter : SelectionMode.book,
          selectedBook: () => reference.book,
          selectedChapter: () => null,
          selectedStartVerse: () => null,
          selectedEndVerse: () => null,
        ),
      null => newState,
    };

    return newState;
  }

  AddPassageState generateSuggestions(AddPassageState newState) {
    newState = switch (newState.selectionMode) {
      SelectionMode.startVerse => newState.copyWith(
          numberSuggestions: getVerseNumbersInChapterState(newState),
        ),
      SelectionMode.endVerse => newState.copyWith(
          numberSuggestions: getVerseNumbersInChapterState(newState)
              .where((e) => e > newState.selectedStartVerse!)
              .toList(),
        ),
      SelectionMode.chapter => newState.copyWith(
          numberSuggestions: getChapterNumbersInState(newState)),
      SelectionMode.book => newState.copyWith(
          filteredBookList: newState.bookList
              .where((e) => e.containsIgnoreCase(newState.filter))
              .toList(),
        ),
    };
    return newState;
  }

  List<int> getChapterNumbersInState(AddPassageState newState) => List.generate(
        Librarian.getLastChapterNumber(newState.selectedBook)!,
        (index) => index + 1,
      );

  List<int> getVerseNumbersInChapterState(AddPassageState newState) =>
      List.generate(
        Librarian.getLastVerseNumber(
          newState.selectedBook,
          newState.selectedChapter,
        )!,
        (index) => index + 1,
      );
}

class AddPassageState {
  final SelectionMode selectionMode;
  final String? selectedBook;
  final String filter;
  final Reference? reference;

  final int? selectedChapter;
  final int? selectedStartVerse;
  final int? selectedEndVerse;

  final List<String> bookList;
  final List<String> filteredBookList;

  final String version;
  final List<DisplayVerse> previewVerses;
  final List<VerseInfo> verses;

  final List<int> numberSuggestions;

  String? get referenceText => reference?.reference;

  AddPassageState({
    required this.selectionMode,
    this.reference,
    this.selectedChapter,
    this.selectedBook,
    this.selectedStartVerse,
    this.selectedEndVerse,
    required this.version,
    required this.previewVerses,
    required this.bookList,
    this.filter = "",
    this.filteredBookList = const [],
    this.numberSuggestions = const [],
    this.verses = const [],
  });

  AddPassageState copyWith({
    SelectionMode? selectionMode,
    String? filter,
    String? Function()? selectedBook,
    Reference? Function()? reference,
    int? Function()? selectedChapter,
    int? Function()? selectedStartVerse,
    int? Function()? selectedEndVerse,
    List<String>? bookList,
    List<String>? filteredBookList,
    String? version,
    List<DisplayVerse>? previewVerses,
    List<int>? numberSuggestions,
    List<VerseInfo>? verses,
  }) =>
      AddPassageState(
        selectionMode: selectionMode ?? this.selectionMode,
        filter: filter ?? this.filter,
        selectedBook: selectedBook != null ? selectedBook() : this.selectedBook,
        selectedChapter:
            selectedChapter != null ? selectedChapter() : this.selectedChapter,
        selectedStartVerse: selectedStartVerse != null
            ? selectedStartVerse()
            : this.selectedStartVerse,
        selectedEndVerse: selectedEndVerse != null
            ? selectedEndVerse()
            : this.selectedEndVerse,
        bookList: bookList ?? this.bookList,
        filteredBookList: filteredBookList ?? this.filteredBookList,
        version: version ?? this.version,
        previewVerses: previewVerses ?? this.previewVerses,
        numberSuggestions: numberSuggestions ?? this.numberSuggestions,
        verses: verses ?? this.verses,
        reference: reference != null ? reference() : this.reference,
      );
}

class DisplayVerse {
  String get text => verseInfo.text;
  Reference get reference => verseInfo.reference;

  final DisplayType displayType;
  final VerseInfo verseInfo;

  DisplayVerse({
    required this.displayType,
    required this.verseInfo,
  });
}

class VerseInfo {
  final String text;
  final Reference reference;

  VerseInfo({
    required this.text,
    required this.reference,
  });
}

enum DisplayType {
  normal,
  highlighted,
}

enum SelectionMode {
  book,
  chapter,
  startVerse,
  endVerse,
}

extension SelectionModeStuff on SelectionMode {
  get isChapter => this == SelectionMode.chapter;
  get isBook => this == SelectionMode.book;
  get isVerse =>
      this == SelectionMode.startVerse || this == SelectionMode.endVerse;
  get isStartVerse => this == SelectionMode.startVerse;
  get isEndVerse => this == SelectionMode.endVerse;
}
