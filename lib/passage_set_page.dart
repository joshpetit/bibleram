import 'package:bibleram/app_cubit.dart';
import 'package:bibleram/guess_page.dart';
import 'package:bibleram/models/passage_being_memorized.dart';
import 'package:bibleram/models/passage_set.dart';
import 'package:bibleram/passage_group_actions.dart';
import 'package:bibleram/utils.dart';
import 'package:bibleram/verse_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PassageSetPage extends StatefulWidget {
  const PassageSetPage({
    super.key,
    required this.passageSet,
  });

  final PassageSet passageSet;

  @override
  State<PassageSetPage> createState() => _PassageSetPageState();
}

class _PassageSetPageState extends State<PassageSetPage> {
  final TextEditingController controller = TextEditingController();

  AppCubit get cubit => BlocProvider.of<AppCubit>(context);

  @override
  initState() {
    controller.text = widget.passageSet.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  children: [
                    Text(widget.passageSet.name, style: textTheme.titleMedium),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<AppCubit, AppState>(
                  builder: (context, state) {
                    var passages = state.passageSets
                        .firstWhere(
                            (element) => element.id == widget.passageSet.id)
                        .passages
                        .toList();
                    return ListView.separated(
                      physics: BouncingScrollPhysics(),
                      separatorBuilder: basicSeparator,
                      itemCount: passages.length,
                      itemBuilder: (context, index) {
                        var passage = passages[index];
                        return Dismissible(
                          key: Key("$passage.id"),
                          onDismissed: (_) {
                            cubit.removePassageFromSet(
                                widget.passageSet.id, passage.id);
                          },
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Center(
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: 350,
                                        maxHeight: 350,
                                      ),
                                      child: VerseCard(passage: passage),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                "${passage.reference} (${passage.version})",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 6.0),
                                                child: Text(
                                                  passage
                                                      .passageText()
                                                      .truncateTo(120),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                        color: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall
                                                            ?.color,
                                                      ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              PassageGroupActions(
                                                percent:
                                                    passage.percentMemorized,
                                                onPlaylistAdd: () {},
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        RamTextIconButton(
                                          icon: Icons.cancel,
                                          onTap: () {
                                            cubit.removePassageFromSet(
                                                widget.passageSet.id,
                                                passage.id);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              RamTextIconButton(
                icon: Icons.add,
                text: "Add Passage",
                iconSize: 37,
                textStyle: theme.textTheme.titleMedium,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 350,
                            maxHeight: 350,
                          ),
                          child: _AddPassage(onAddPassage: (passage) {
                            cubit.addPassageToSet(
                                widget.passageSet.id, passage.id);
                          }),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddPassage extends StatefulWidget {
  const _AddPassage({required this.onAddPassage});

  final void Function(PassageBeingMemorized passage) onAddPassage;

  @override
  State<_AddPassage> createState() => __AddPassageState();
}

class __AddPassageState extends State<_AddPassage> {
  String filter = "";
  TextEditingController searchController = TextEditingController();

  void clearFilter() {
    setState(() {
      filter = "";
      searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (searchController.text.isNotEmpty) {
          clearFilter();
          return false;
        }
        return true;
      },
      child: Material(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
            Expanded(
              child: BlocBuilder<AppCubit, AppState>(builder: (context, state) {
                var passages = state.passagesBeingMemorized;
                passages = state.passagesBeingMemorized
                    .where((p) =>
                        p.reference.containsIgnoreCase(filter) ||
                        p.passageText().containsIgnoreCase(filter))
                    .toList();

                return ListView.separated(
                  physics: BouncingScrollPhysics(),
                  separatorBuilder: basicSeparator,
                  itemCount: passages.length,
                  itemBuilder: (context, index) {
                    var passage = passages[index];
                    return InkWell(
                      onTap: () {
                        widget.onAddPassage(passage);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "${passage.reference} (${passage.version})",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 6.0),
                                          child: Text(
                                            passage
                                                .passageText()
                                                .truncateTo(120),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.color,
                                                ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        PassageGroupActions(
                                          percent: passage.percentMemorized,
                                          onPlaylistAdd: () {},
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
