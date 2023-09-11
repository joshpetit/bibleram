import 'package:bibleram/constants.dart';
import 'package:bibleram/main.dart';
import 'package:flutter/material.dart';
import 'package:reference_parser/reference_parser.dart';

int fastHash(String string) {
  var hash = 0xcbf29ce484222325;

  var i = 0;
  while (i < string.length) {
    final codeUnit = string.codeUnitAt(i++);
    hash ^= codeUnit >> 8;
    hash *= 0x100000001b3;
    hash ^= codeUnit & 0xFF;
    hash *= 0x100000001b3;
  }

  return hash;
}

extension CoolInts on num {
  /// inclusive
  bool betweenOrEqual(int lowerEnd, int higherEnd) =>
      this >= lowerEnd && this <= higherEnd ||
      (this == lowerEnd || this == higherEnd);
}

extension DoperString on String {
  String truncateTo(int maxLength) =>
      (length <= maxLength) ? this : '${substring(0, maxLength)}...';
  bool containsIgnoreCase(String string) {
    return toLowerCase().contains(string.toLowerCase());
  }
}

extension Dope on State {
  ColorScheme get colorScheme => Theme.of(context).colorScheme;
  ThemeData get theme => Theme.of(context);
  TextTheme get textTheme => Theme.of(context).textTheme;
}

class ClearFocusOnPop extends NavigatorObserver {
  @override
  void didPop(route, previousRoute) {
    super.didPop(route, previousRoute);
    final focus = FocusManager.instance.primaryFocus;
    focus?.unfocus();
  }
}

String getPreferredTranslation() {
  return sharedPreferences.getString(preferredTranslationKey) ??
      myPreferredTranslation;
}

extension ReferenceTypeChecks on ReferenceType? {
  bool get isBook => this == ReferenceType.BOOK;
  bool get isChapter => this == ReferenceType.CHAPTER;
  bool get isChapterRange => this == ReferenceType.CHAPTER_RANGE;
  bool get isVerse => this == ReferenceType.VERSE;
  bool get isVerseRange => this == ReferenceType.VERSE_RANGE;
}

Widget basicSeparator(context, index) {
  return Column(
    children: [
      Container(
        height: 1,
        color: Theme.of(context).colorScheme.tertiaryContainer,
      ),
    ],
  );
}

void push(BuildContext context, Widget page) => Navigator.of(context).push(
      MaterialPageRoute<Widget>(
        builder: (_) {
          return page;
        },
      ),
    );
