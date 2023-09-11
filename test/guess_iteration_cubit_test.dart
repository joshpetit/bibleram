import 'package:bibleram/guess_iteration_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Stage 1', () {
    test('Doesnt advance when getting wrong with 0', () {
      var cubit = AppCubit();
      expect(cubit.state.percentMemorized, equals(0));
      expect(cubit.state.wordsRemoved, equals(stage1WordsRemoved));
      cubit.answerWrong();
      cubit.answerWrong();
      expect(cubit.state.percentMemorized, equals(0));
      expect(cubit.state.wordsRemoved, equals(stage1WordsRemoved));
    });

    test('Advances by 2% every time is right for first 5 questions', () {
      var cubit = AppCubit();
      for (int numberCorrectAnswers = 1;
          numberCorrectAnswers < 6;
          numberCorrectAnswers++) {
        cubit.answerRight();
        expect(cubit.state.percentMemorized,
            equals(stage1MemorizationGain * numberCorrectAnswers));
        expect(cubit.state.wordsRemoved, equals(stage1WordsRemoved));
      }
    });

    test('Decrements by 2% every time is wrong', () {
      var cubit = AppCubit();
      cubit.answerRight();
      cubit.answerRight();
      cubit.answerRight();
      expect(
        cubit.state.percentMemorized,
        equals(stage1MemorizationGain * 3),
      );
      cubit.answerWrong();
      expect(
        cubit.state.percentMemorized,
        equals(stage1MemorizationGain * 2),
      );
      expect(
        cubit.state.wordsRemoved,
        equals(stage1WordsRemoved),
      );
    });
    test('Advances to stage 2 after 5 correct questions', () {
      var cubit = AppCubit();
      for (int numberCorrectAnswers = 1;
          numberCorrectAnswers < 6;
          numberCorrectAnswers++) {
        cubit.answerRight();
        expect(cubit.state.percentMemorized,
            equals(stage1MemorizationGain * numberCorrectAnswers));
        expect(cubit.state.wordsRemoved, equals(stage1WordsRemoved));
      }
      expect(cubit.state.stage, equals(2));
    });
  });

  group('Stage 2', () {
    test('Advances by 5% every time is right for 2 questions', () {
      var cubit = AppCubit(
        initialState: AppState.atState(
          verseBeingGuessed: "rando verse being guessed you feel my man!",
          stage: 2,
          wordsRemoved: 2,
          percentMemorized: 10,
        ),
      );
      for (int numberCorrectAnswers = 1;
          numberCorrectAnswers < 3;
          numberCorrectAnswers++) {
        cubit.answerRight();
        expect(cubit.state.percentMemorized,
            equals(10 + stage2MemorizationGain * numberCorrectAnswers));
        expect(cubit.state.wordsRemoved, equals(stage2WordsRemoved));
      }
    });

    test('Decrements by 5% every time is wrong', () {
      var cubit = AppCubit(
        initialState: AppState.atState(
          verseBeingGuessed: "rando verse being guessed you feel my man!",
          stage: 2,
          wordsRemoved: 2,
          percentMemorized: 20,
        ),
      );
      var previousMemorizationValue = cubit.state.percentMemorized;
      cubit.answerWrong();
      expect(
        cubit.state.percentMemorized,
        equals(previousMemorizationValue - 5),
      );
      expect(
        cubit.state.wordsRemoved,
        equals(stage2WordsRemoved),
      );
    });

    test('Advances to stage 3 after 2 correct questions', () {
      var cubit = AppCubit(
        initialState: AppState.atState(
          verseBeingGuessed: "rando verse being guessed you feel my man!",
          referenceBeingGuessed: "WHATT",
          stage: 2,
          wordsRemoved: 2,
          percentMemorized: 10,
        ),
      );
      for (int numberCorrectAnswers = 1;
          numberCorrectAnswers < 3;
          numberCorrectAnswers++) {
        cubit.answerRight();
      }
      expect(cubit.state.stage, equals(3));
    });
  });

  group('Stage 3', () {
    AppState makeState({
      String? verseBeingGuessed,
      int? wordsRemoved,
    }) {
      return AppState.atState(
        verseBeingGuessed: verseBeingGuessed ?? "1 2 3 4 5 6 7 8 9 10 11",
        referenceBeingGuessed: "Cool reference",
        stage: 3,
        wordsRemoved: wordsRemoved ?? 3,
        percentMemorized: 20,
      );
    }

    test('adds 1 removed word for every right answer ', () {
      var cubit = AppCubit(
        initialState: makeState(
          verseBeingGuessed: "1 2 3 4 5 6 7 8 9 10",
          wordsRemoved: 2,
        ),
      );
      for (int numberCorrectAnswers = 1;
          numberCorrectAnswers < 3;
          numberCorrectAnswers++) {
        cubit.answerRight();
        expect(cubit.state.wordsRemoved, equals(2 + numberCorrectAnswers));
      }
    });

    test('makes memorization percentage based on percent removed', () {
      var cubit = AppCubit(
        initialState: makeState(),
      );
      var previousPercentRemoved = cubit.state.percentRemoved;
      cubit.answerRight();
      print(cubit.state.percentRemoved);
      expect(cubit.state.percentMemorized, equals(previousPercentRemoved * 2));
    });

    test('Decrements by 5% every time is wrong', () {
      var cubit = AppCubit(
        initialState: makeState(),
      );
      var previousMemorizationValue = cubit.state.percentMemorized;
      cubit.answerWrong();
      expect(
        cubit.state.percentMemorized,
        equals(previousMemorizationValue - 5),
      );
      expect(
        cubit.state.wordsRemoved,
        equals(stage2WordsRemoved),
      );
    });

    test('advances to stage 4 after 1/3 words are gone', () {
      var cubit = AppCubit(
        initialState: makeState(
            verseBeingGuessed: "1, 2, 3, 4, 5, 6, 7, 8, 9", wordsRemoved: 3),
      );
      cubit.answerRight();
      expect(cubit.state.stage, equals(4));
    });
  });

  group('Stage 4', () {
    AppState makeState({
      String? verseBeingGuessed,
      int? wordsRemoved,
      int? percentMemorized,
    }) {
      return AppState.atState(
        verseBeingGuessed: verseBeingGuessed ?? "1 2 3 4 5 6 7 8 9 10",
        referenceBeingGuessed: "Cool reference",
        stage: 4,
        wordsRemoved: wordsRemoved ?? 8,
        percentMemorized: percentMemorized ?? 30,
      );
    }

    test('Keeps 80% of words removed for 3 guesses', () {
      var cubit = AppCubit(
        initialState: makeState(),
      );
      for (int numberCorrectAnswers = 1;
          numberCorrectAnswers <= 3;
          numberCorrectAnswers++) {
        cubit.answerRight();
        expect(cubit.state.percentRemoved, greaterThan(79));
      }
    });

    test('adds 2% to memorization for 3 guesses', () {
      var cubit = AppCubit(
        initialState: makeState(percentMemorized: 60),
      );
      for (int numberCorrectAnswers = 1;
          numberCorrectAnswers <= 3;
          numberCorrectAnswers++) {
        cubit.answerRight();
        expect(
          cubit.state.percentMemorized,
          equals(60 + (5 * numberCorrectAnswers)),
        );
      }
    });

    test('Decrements by 5% every time is wrong', () {
      var cubit = AppCubit(
        initialState: makeState(
          percentMemorized: 60,
        ),
      );
      var previousMemorizationValue = cubit.state.percentMemorized;
      cubit.answerWrong();
      expect(
        cubit.state.percentMemorized,
        equals(previousMemorizationValue - 5),
      );
    });

    test('advances to stage 5 after 3 correct answers', () {
      var cubit = AppCubit(
        initialState: makeState(
            verseBeingGuessed: "1, 2, 3, 4, 5, 6, 7, 8, 9",
            wordsRemoved: 4,
            percentMemorized: 60),
      );
      for (int numberCorrectAnswers = 1;
          numberCorrectAnswers <= 4;
          numberCorrectAnswers++) {
        cubit.answerRight();
      }
      expect(cubit.state.stage, equals(5));
    });
  });

  group('Stage 5', () {
    AppState makeState({
      String? verseBeingGuessed,
      int? wordsRemoved,
      int? percentMemorized,
    }) {
      return AppState.atState(
        verseBeingGuessed: verseBeingGuessed ?? "1 2 3 4 5 6 7 8 9 10",
        stage: 5,
        wordsRemoved: wordsRemoved ?? 8,
        percentMemorized: percentMemorized ?? 30,
      );
    }

    test('Keeps 100% of words removed for all correct guesses', () {
      var cubit = AppCubit(
        initialState: makeState(),
      );
      for (int numberCorrectAnswers = 1;
          numberCorrectAnswers <= 5;
          numberCorrectAnswers++) {
        cubit.answerRight();
        expect(cubit.state.percentRemoved, equals(100));
      }
    });

    test('adds 5% to memorization for 4 guesses', () {
      var wordBeingGuessed = "a long verse right here";
      var cubit = AppCubit(
        initialState: makeState(
            percentMemorized: 80,
            wordsRemoved: wordBeingGuessed.split(" ").length,
            verseBeingGuessed: wordBeingGuessed),
      );
      for (int numberCorrectAnswers = 1;
          numberCorrectAnswers <= 4;
          numberCorrectAnswers++) {
        cubit.answerRight();
        expect(
          cubit.state.percentMemorized,
          equals(80 + (5 * numberCorrectAnswers)),
        );
      }
    });

    test('Decrements by 10% every time is wrong', () {
      var cubit = AppCubit(
        initialState: makeState(
          percentMemorized: 80,
        ),
      );
      var previousMemorizationValue = cubit.state.percentMemorized;
      cubit.answerWrong();
      expect(
        cubit.state.percentMemorized,
        equals(previousMemorizationValue - 10),
      );
    });

    test('advances to stage 6 after 4 correct answers', () {
      var cubit = AppCubit(
        initialState: makeState(
          verseBeingGuessed: "1, 2, 3, 4, 5, 6, 7, 8, 9",
          wordsRemoved: 7,
          percentMemorized: 80,
        ),
      );
      for (int numberCorrectAnswers = 1;
          numberCorrectAnswers <= 4;
          numberCorrectAnswers++) {
        cubit.answerRight();
      }
      expect(cubit.state.stage, equals(6));
    });

    test('goes to stage 4 after dropping below 80%', () {
      var cubit = AppCubit(
        initialState: makeState(
          verseBeingGuessed: "1, 2, 3, 4, 5, 6, 7, 8, 9",
          wordsRemoved: 9,
          percentMemorized: 80,
        ),
      );
      cubit.answerWrong();
      expect(cubit.state.stage, equals(4));
    });
  });

  test('Stage 6 goes to 90% when wrong', () {
    var cubit = AppCubit(
      initialState: AppState.atState(
        stage: 6,
        verseBeingGuessed: "1, 2, 3, 4, 5, 6, 7, 8, 9",
        wordsRemoved: "1, 2, 3, 4, 5, 6, 7, 8, 9".split(" ").length,
        percentMemorized: 100,
      ),
    );
    cubit.answerWrong();
    expect(cubit.state.stage, equals(5));
    expect(cubit.state.percentMemorized, equals(90));
  });
}
