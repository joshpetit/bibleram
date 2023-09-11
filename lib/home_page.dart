import 'package:bibleram/add_passage_page/add_passage_page.dart';
import 'package:bibleram/app_cubit.dart';
import 'package:bibleram/flashcard_page.dart';
import 'package:bibleram/guess_page.dart';
import 'package:bibleram/main.dart';
import 'package:bibleram/models/passage_being_memorized.dart';
import 'package:bibleram/passages_view.dart';
import 'package:bibleram/reminders_page.dart';
import 'package:bibleram/sets_view.dart';
import 'package:bibleram/settings_page.dart';
import 'package:bibleram/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String filter = "";
  Sortby sortby = Sortby.none;
  TextEditingController searchController = TextEditingController();
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(vsync: this, length: 2);
    tabController.addListener(() {
      setState(() {
        filter = "";
        searchController.text = "";
      });
      FocusScope.of(context).unfocus();
    });
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<AppCubit>(context);
    return WillPopScope(
      onWillPop: () async {
        if (searchController.text.isNotEmpty) {
          clearFilter();
          return false;
        }
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: BlocBuilder<AppCubit, AppState>(
            builder: (context, state) {
              var filteredPassages = state.passagesBeingMemorized
                  .where((p) =>
                      p.reference.containsIgnoreCase(filter) ||
                      p.passageText().containsIgnoreCase(filter))
                  .toList();

              var filteredPassageSets = state.passageSets
                  .where(
                    (e) =>
                        e.name.containsIgnoreCase(filter) ||
                        e.passages.any(
                            (el) => el.reference.containsIgnoreCase(filter)),
                  )
                  .toList();
              if (sortby == Sortby.memorizedDesc) {
                filteredPassages.sort(
                    (a, b) => a.percentMemorized < b.percentMemorized ? 1 : -1);
                filteredPassageSets.sort(
                    (a, b) => a.percentMemorized < b.percentMemorized ? 1 : -1);
              } else if (sortby == Sortby.memorizedAsc) {
                filteredPassages.sort(
                    (a, b) => a.percentMemorized < b.percentMemorized ? -1 : 1);
                filteredPassageSets.sort(
                    (a, b) => a.percentMemorized < b.percentMemorized ? -1 : 1);
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            onChanged: (value) => setState(() {
                              filter = value;
                            }),
                            decoration: InputDecoration(
                              hintText: "Search",
                              suffix: Visibility(
                                visible: filter.isNotEmpty,
                                child: RamTextIconButton(
                                  icon: Icons.clear,
                                  iconSize: 17,
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    clearFilter();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              sortby = switch (sortby) {
                                Sortby.none => Sortby.memorizedAsc,
                                Sortby.memorizedAsc => Sortby.memorizedDesc,
                                Sortby.memorizedDesc => Sortby.none,
                              };
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: Row(
                              children: [
                                Text('Sort By: '),
                                Text(sortby.title),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        PassagesView(
                          passages: filteredPassages,
                          onStartVerse: (passage) {
                            startMemorizing(state, passage);
                          },
                        ),
                        SetsView(
                            passageSets: filteredPassageSets,
                            onStartSet: (passageSet) {
                              appCubit.practiceSet(passageSet);
                              pushPracticePage();
                            })
                      ],
                    ),
                  ),
                  TabBar(
                    controller: tabController,
                    tabs: [
                      Tab(text: "Passages"),
                      Tab(text: "Sets"),
                    ],
                  ),
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 0,
                          blurRadius: 4,
                          offset: Offset(0, -1), // changes position of shadow
                        ),
                      ],
                      color: colorScheme.surface,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Passage Selection:",
                                        textAlign: TextAlign.center,
                                        style: textTheme.bodySmall,
                                      ),
                                      SizedBox(height: 5),
                                      DropdownButton(
                                        value: state.memorizationMode,
                                        itemHeight: 75,
                                        underline: Container(),
                                        isDense: true,
                                        selectedItemBuilder: (context) =>
                                            MemorizationMode.values
                                                .map(
                                                  (e) => Text(
                                                    e.title,
                                                    textAlign: TextAlign.left,
                                                  ),
                                                )
                                                .toList(),
                                        onChanged: (selectedMode) {
                                          cubit.setMemorizationMode(
                                              selectedMode);
                                        },
                                        items: MemorizationMode.values
                                            .map(
                                              (e) => DropdownMenuItem(
                                                value: e,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      e.title,
                                                      textAlign: TextAlign.left,
                                                    ),
                                                    Text(
                                                      e.description,
                                                      textAlign: TextAlign.left,
                                                      style: theme
                                                          .textTheme.bodySmall,
                                                    ),
                                                  ],
                                                ),
                                                key: Key(e.title),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    RamTextIconButton(
                                      icon: Icons.play_arrow,
                                      text: "Start/Shuffle",
                                      color: colorScheme.secondaryContainer,
                                      iconSize: 70,
                                      textStyle: theme.textTheme.titleLarge,
                                      onTap: () => startMemorizing(state),
                                    ),
                                    Visibility(
                                      visible: cubit.state.queue.isNotEmpty,
                                      child: RamTextIconButton(
                                        icon: Icons.play_circle,
                                        text: "Continue",
                                        iconSize: 30,
                                        textStyle: theme.textTheme.titleSmall,
                                        onTap: pushPracticePage,
                                      ),
                                    ),
                                  ],
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Practice mode:",
                                          textAlign: TextAlign.center,
                                          style: textTheme.bodySmall,
                                        ),
                                        SizedBox(height: 5),
                                        DropdownButton(
                                          value: state.practiceMode,
                                          underline: Container(),
                                          isDense: true,
                                          itemHeight: 60,
                                          onChanged: (selectedMode) {
                                            cubit.setPracticeMode(selectedMode);
                                          },
                                          selectedItemBuilder: (context) =>
                                              PracticeMode.values
                                                  .map(
                                                    (e) => Text(
                                                      e.title,
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  )
                                                  .toList(),
                                          items: PracticeMode.values
                                              .map(
                                                (e) => DropdownMenuItem(
                                                  value: e,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        e.title,
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                      Text(
                                                        e.description,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: theme.textTheme
                                                            .bodySmall,
                                                      ),
                                                    ],
                                                  ),
                                                  key: Key(e.title),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              RamTextIconButton(
                                icon: Icons.alarm,
                                text: "Reminders",
                                iconSpacing: 5,
                                iconSize: 25,
                                textStyle: theme.textTheme.titleMedium,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<Widget>(
                                      builder: (_) => RemindersPage(),
                                    ),
                                  );
                                },
                              ),
                              // RamTextIconButton(
                              //   icon: Icons.playlist_add_check,
                              //   text: "Queue",
                              //   iconSize: 37,
                              //   textStyle: theme.textTheme.titleMedium,
                              // ),
                              RamTextIconButton(
                                icon: Icons.add,
                                text: "Add Verse",
                                iconSize: 37,
                                textStyle: theme.textTheme.titleMedium,
                                onTap: pushAddVersePage,
                              ),
                              RamTextIconButton(
                                icon: Icons.settings,
                                iconSpacing: 5,
                                text: "Settings",
                                iconSize: 25,
                                textStyle: theme.textTheme.titleMedium,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<Widget>(
                                      builder: (_) => SettingsPage(),
                                    ),
                                  );
                                },
                              ),
                            ].map((e) => Expanded(child: e)).toList(),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void clearFilter() {
    setState(() {
      filter = "";
      searchController.clear();
    });
  }

  void startMemorizing(AppState state, [PassageBeingMemorized? passage]) {
    var cubit = BlocProvider.of<AppCubit>(context);
    if (state.passagesBeingMemorized.isEmpty) {
      askIfWantToAddVerse();
      return;
    }
    cubit.start(passage: passage);
    pushPracticePage();
  }

  void pushPracticePage() {
    if (appCubit.state.practiceMode == PracticeMode.normal) {
      Navigator.of(context).push(
        MaterialPageRoute<Widget>(
          builder: (_) => GuessPage(),
        ),
      );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<Widget>(
        builder: (_) => FlashcardPage(),
      ),
    );
  }

  void askIfWantToAddVerse() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              "You don't seem to have any verses. Let's fix that!",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: colorScheme.onBackground,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  pushAddVersePage();
                },
                child: Text(
                  "Add Passage",
                ),
              ),
            ],
          );
        });
  }

  void pushAddVersePage() {
    Navigator.of(context).push(
      MaterialPageRoute<Widget>(
        builder: (_) => AddPassagePage(),
      ),
    );
  }
}

extension PracticeModeExt on PracticeMode {
  String get description => switch (this) {
        PracticeMode.normal => "Progressively remove blanks",
        PracticeMode.flashcard => "Show/hide answers",
      };

  String get title => switch (this) {
        PracticeMode.normal => "Normal",
        PracticeMode.flashcard => "Flashcard",
      };
}

extension MemorizationModeExt on MemorizationMode {
  String get description => switch (this) {
        MemorizationMode.random => "Practice your passages at random",
        MemorizationMode.review => "Practice well memorized passages",
        MemorizationMode.unfamiliar => "Practice less memorized passages",
      };

  String get title => switch (this) {
        MemorizationMode.random => "Random",
        MemorizationMode.review => "Review",
        MemorizationMode.unfamiliar => "Unfamiliar",
      };
}

enum MemorizationMode {
  random,
  review,
  unfamiliar,
}

enum PracticeMode {
  normal,
  flashcard,
}

enum Sortby { none, memorizedAsc, memorizedDesc }

extension SortbyExt on Sortby {
  String get title => switch (this) {
        Sortby.none => "None",
        Sortby.memorizedAsc => "% ASC",
        Sortby.memorizedDesc => "% DESC",
      };
}
