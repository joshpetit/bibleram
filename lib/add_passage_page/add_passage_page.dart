import 'package:bibleram/add_passage_page/add_passage_action_bar.dart';
import 'package:bibleram/add_passage_page/add_passage_cubit.dart';
import 'package:bibleram/add_passage_page/popular_verse_popup.dart';
import 'package:bibleram/constants.dart';
import 'package:bibleram/guess_page.dart';
import 'package:bibleram/main.dart';
import 'package:bibleram/models/app_version_info.dart';
import 'package:bibleram/models/verse_being_memorized.dart';

import 'package:bibleram/app_cubit.dart';
import 'package:bibleram/passage_set_manager.dart';
import 'package:bibleram/services/bible_service.dart';
import 'package:bibleram/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPassagePage extends StatefulWidget {
  const AddPassagePage({
    super.key,
  });

  @override
  State<AddPassagePage> createState() => _AddPassagePageState();
}

class _AddPassagePageState extends State<AddPassagePage> {
  List<VerseBeingMemorized> refVerses = [];
  String version = "NKJV";
  int? scrollToOnNextRender;

  TextEditingController textController = TextEditingController();

  late BibleService bibleService;

  @override
  void initState() {
    version = sharedPreferences.getString(preferredTranslationKey) ?? "NKJV";
    if (!availableVersions.contains(version)) {
      // lol it would suck if I removedhttps://www.alltrails.com/trail/us/north-carolina/mount-mitchell-loop the nkjv and forgot that here
      version = "NKJV";
      sharedPreferences.setString(preferredTranslationKey, "NKJV");
    }
    var addPassageCubit = BlocProvider.of<AddPassageCubit>(context);
    addPassageCubit.reset();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      bibleService = BibleService();
      bibleService.setDatabaseVersion(version: version);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 40,
        title: Text(
          'Adding a new passage',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          var addPassageCubit = BlocProvider.of<AddPassageCubit>(context);
          var state = BlocProvider.of<AddPassageCubit>(context).state;
          if (state.selectedEndVerse != null) {
            await addPassageCubit.selectChapter(state.selectedChapter!);
            syncTextFieldToCubit();
            return false;
          }
          if (state.selectedStartVerse != null) {
            await addPassageCubit.selectChapter(state.selectedChapter!);
            syncTextFieldToCubit();
            return false;
          }
          if (state.selectedChapter != null) {
            addPassageCubit.selectBook(state.selectedBook!);
            syncTextFieldToCubit();
            return false;
          }
          // if (state.selectedBook != null) {
          //   addPassageCubit.reset();
          //   syncTextFieldToCubit();
          //   return false;
          // }
          return true;
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: 15.0,
              left: 25,
              right: 25,
            ),
            child: BlocBuilder<AddPassageCubit, AddPassageState>(
              builder: (context, state) {
                var addPassageCubit = BlocProvider.of<AddPassageCubit>(context);
                var selectionMode = state.selectionMode;
                var bookSelector = ListView.builder(
                  itemCount: state.filteredBookList.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    var book = state.filteredBookList.elementAt(index);
                    return Center(
                      child: ListTile(
                        title: Center(child: Text(book)),
                        onTap: () {
                          setState(
                            () {
                              addPassageCubit.selectBook(book);
                              FocusManager.instance.primaryFocus?.unfocus();
                              syncTextFieldToCubit();
                            },
                          );
                        },
                      ),
                    );
                  },
                );
                var keys = List.generate(
                    state.previewVerses.length, (i) => GlobalKey());
                var endingKeys = List.generate(
                    state.previewVerses.length, (i) => GlobalKey());
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  if (scrollToOnNextRender != null) {
                    Scrollable.ensureVisible(
                      keys[scrollToOnNextRender! - 1].currentContext ?? context,
                      alignment: 0,
                      duration: Duration(milliseconds: 500),
                    );
                    setState(() {
                      scrollToOnNextRender = null;
                    });
                  }
                });

                var numberSelector = GridView.count(
                  crossAxisCount: 4,
                  reverse: false,
                  childAspectRatio: 1.5,
                  children: state.numberSuggestions.map(
                    (number) {
                      return InkWell(
                        child: Center(
                          child: Text(
                            "$number",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        onTap: () async {
                          if (state.selectionMode.isVerse) {
                            Scrollable.ensureVisible(
                              keys[number - 1].currentContext ?? context,
                              alignment:
                                  state.selectionMode.isStartVerse ? 0.2 : .5,
                              duration: Duration(milliseconds: 500),
                            );
                          }
                          await addPassageCubit.selectNumber(number);
                          syncTextFieldToCubit();
                        },
                      );
                    },
                  ).toList(),
                );

                var currentSelector = switch (state.selectionMode) {
                  SelectionMode.book => bookSelector,
                  _ => numberSelector,
                };

                var selectionModeIsVerse = state.selectionMode.isVerse;

                List<TextSpan> displayVerses = [];

                for (var i = 0; i < state.previewVerses.length; i++) {
                  var verse = state.previewVerses[i];
                  var key = keys[i];
                  var verseRef = verse.reference;
                  bool highlight = verse.displayType == DisplayType.highlighted;

                  displayVerses.add(
                    TextSpan(
                      style: TextStyle(
                        backgroundColor:
                            highlight ? colorScheme.tertiaryContainer : null,
                      ),
                      children: [
                        TextSpan(
                          text: " ${verseRef.startVerseNumber} ",
                          style: textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            height: 1.87,
                            fontStyle: FontStyle.italic,
                            color: highlight
                                ? colorScheme.onTertiaryContainer
                                : null,
                          ),
                        ),
                        WidgetSpan(
                          child: SizedBox.fromSize(
                            size: Size.zero,
                            key: key,
                          ),
                        ),
                        TextSpan(
                          text: verse.text,
                          style: textTheme.bodyMedium?.copyWith(
                            fontSize: 19,
                            fontWeight: FontWeight.w300,
                            color: highlight
                                ? colorScheme.onTertiaryContainer
                                : null,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              addPassageCubit.verseClicked(i + 1);
                              FocusManager.instance.primaryFocus?.unfocus();
                              syncTextFieldToCubit();
                            },
                        ),
                        WidgetSpan(
                          child: SizedBox.fromSize(
                            size: Size.zero,
                            key: endingKeys[i],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      state.referenceText ?? "",
                      style: textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Visibility(
                      visible: state.selectedChapter != null,
                      child: Expanded(
                        flex: 2,
                        child: Center(
                          child: SingleChildScrollView(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: displayVerses,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    DefaultTextStyle(
                      style: textTheme.titleMedium ?? TextStyle(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 10),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  addPassageCubit.reset();
                                  syncTextFieldToCubit();
                                },
                                child: Center(
                                  child: Text(
                                    "Book",
                                    style: TextStyle(
                                      color: selectionMode.isBook
                                          ? null
                                          : colorScheme.tertiaryContainer,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (state.selectedBook != null) {
                                    addPassageCubit
                                        .selectBook(state.selectedBook!);
                                    syncTextFieldToCubit();
                                  }
                                },
                                child: Center(
                                  child: Text(
                                    "Chapter",
                                    style: TextStyle(
                                      color: selectionMode.isChapter
                                          ? null
                                          : colorScheme.tertiaryContainer,
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  "Verses",
                                  style: TextStyle(
                                    color: selectionMode.isVerse
                                        ? null
                                        : colorScheme.tertiaryContainer,
                                  ),
                                ),
                              )
                            ].map((e) => Expanded(child: e)).toList(),
                          ),
                          Visibility(
                            visible: selectionModeIsVerse,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      await addPassageCubit.selectChapter(
                                          state.selectedChapter!);
                                      syncTextFieldToCubit();
                                    },
                                    child: Center(
                                      child: Text(
                                        "Starting Verse",
                                        style: TextStyle(
                                          color: selectionMode.isStartVerse
                                              ? null
                                              : colorScheme.tertiaryContainer,
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      if (state.selectedStartVerse != null) {
                                        await addPassageCubit.selectStartVerse(
                                            state.selectedStartVerse!);
                                        syncTextFieldToCubit();
                                      }
                                    },
                                    child: Center(
                                      child: Text(
                                        "Ending Verse",
                                        style: TextStyle(
                                          color: selectionMode.isEndVerse
                                              ? null
                                              : colorScheme.tertiaryContainer,
                                        ),
                                      ),
                                    ),
                                  )
                                ].map((e) => Expanded(child: e)).toList(),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: currentSelector,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: SizedBox(),
                        ),
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: textController,
                            textAlign: TextAlign.center,
                            textCapitalization: TextCapitalization.words,
                            onChanged: (value) async {
                              await addPassageCubit.onTextFieldUpdate(value);
                              var state = addPassageCubit.state;
                              if (state.selectedStartVerse != null) {
                                Scrollable.ensureVisible(
                                  keys[state.selectedStartVerse! - 1]
                                          .currentContext ??
                                      context,
                                  alignment: state.selectionMode.isStartVerse
                                      ? 0.2
                                      : .5,
                                  duration: Duration(milliseconds: 500),
                                );
                              }
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(0),
                              hintText: "Genesis 2:4, Gen 2:4, Eccl 16:4",
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: colorScheme.secondaryContainer),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        DropdownButton(
                          value: state.version,
                          underline: SizedBox(),
                          alignment: Alignment.center,
                          isDense: true,
                          onChanged: (newVersion) async {
                            if (newVersion != null) {
                              try {
                                await addPassageCubit.setVersion(newVersion);
                              } catch (e) {
                                print(e);
                              }
                            }
                          },
                          items: availableVersions
                              .map(
                                (e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    AddActions(
                        addPassageEnabled: state.selectedChapter != null,
                        onAddVerse: saveToStorage,
                        onPractice: () {
                          saveToStorage(
                            notifyIfSaved: false,
                            setAsVerseBeingMemorizedAfter: true,
                          );
                          FocusScope.of(context).unfocus();
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute<Widget>(
                              builder: (_) {
                                return GuessPage();
                              },
                            ),
                          );
                        },
                        onPopularVerse: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Center(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: 350,
                                    maxHeight: 550,
                                  ),
                                  child: PopularPassagePopup(
                                      bibleService: bibleService,
                                      onSelected: (selectedPassage) async {
                                        textController.text =
                                            selectedPassage.reference!;

                                        await addPassageCubit
                                            .selectReference(selectedPassage);
                                        var state = addPassageCubit.state;
                                        setState(() {
                                          scrollToOnNextRender =
                                              state.selectedStartVerse! - 1;
                                        });
                                      }),
                                ),
                              );
                            },
                          );
                        },
                        onAddToSet: () {
                          if (state.selectedChapter == null) {
                            showSnackBar(context,
                                message: "You must select at least a chapter");
                            return;
                          }
                          push(
                              context,
                              PassageSetManager(
                                passageId: fastHash(
                                  "${state.reference?.reference ?? ""}${state.version}",
                                ),
                                onAddPassageToSet: (passageSet) async {
                                  saveToStorage(notifyIfSaved: false);
                                  appCubit.addPassageToSet(
                                      passageSet.id,
                                      fastHash(
                                        "${state.reference?.reference ?? ""}${state.version}",
                                      ));
                                },
                              ));
                        }),
                    SizedBox(
                      height: 10,
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void syncTextFieldToCubit() {
    var addPassageCubit = BlocProvider.of<AddPassageCubit>(context);
    setState(() {
      textController.text = addPassageCubit.state.referenceText ?? "";
      putTextFieldAtEnd();
    });
  }

  void putTextFieldAtEnd() {
    textController.selection = TextSelection.collapsed(
      offset: textController.text.length,
    );
  }

  void saveToStorage({
    bool notifyIfSaved = true,
    bool setAsVerseBeingMemorizedAfter = false,
  }) async {
    // Hack for song of solomon
    var state = BlocProvider.of<AddPassageCubit>(context).state;
    var ref = state.reference;
    if (ref == null) return;
    var cubit = BlocProvider.of<AppCubit>(context);

    var versesInPassage = state.verses
        .where(
          (e) => e.reference.startVerseNumber.betweenOrEqual(
              state.reference!.startVerseNumber,
              state.reference!.endVerseNumber!),
        )
        .map(
          (e) => VerseBeingMemorized(
            verseText: e.text,
            reference: e.reference.reference!,
            version: state.version,
            percentMemorized: 0,
            wordsRemoved: 1,
            stage: 1,
          ),
        )
        .toList();

    try {
      cubit.addPassageToBeMemorized(
        selectedReference: ref,
        refVerses: versesInPassage,
        version: version,
        setAsVerseAfter: setAsVerseBeingMemorizedAfter,
      );
      // :P screw build context
      showSnackBar(context, message: "Passage added ✅");
    } on PassageAlreadyAddedException {
      if (notifyIfSaved) {
        showSnackBar(context, message: "You're already memorizing this!");
      }
    }
    if (setAsVerseBeingMemorizedAfter) {
      cubit.refreshBoard();
    }
  }
}
