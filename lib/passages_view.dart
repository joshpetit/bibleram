import 'package:bibleram/guess_page.dart';
import 'package:bibleram/models/passage_being_memorized.dart';
import 'package:bibleram/passage_group_actions.dart';
import 'package:bibleram/utils.dart';
import 'package:bibleram/verse_card.dart';
import 'package:flutter/material.dart';

class PassagesView extends StatelessWidget {
  const PassagesView({
    super.key,
    required this.passages,
    required this.onStartVerse,
  });

  final List<PassageBeingMemorized> passages;
  final void Function(PassageBeingMemorized passage) onStartVerse;

  @override
  Widget build(BuildContext context) {
    return passages.isEmpty
        ? Center(
            child: Text(
            "No passages",
          ))
        : ListView.separated(
            physics: BouncingScrollPhysics(),
            separatorBuilder: basicSeparator,
            itemCount: passages.length,
            itemBuilder: (context, index) {
              var passage = passages[index];
              return InkWell(
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
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                              padding:
                                  const EdgeInsets.symmetric(vertical: 6.0),
                              child: Text(
                                passage.passageText().truncateTo(120),
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
                              onStartVerse: () => onStartVerse(passage),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      RamTextIconButton(
                        icon: Icons.more_horiz,
                        iconSize: 30,
                      )
                    ],
                  ),
                ),
              );
            },
          );
  }
}
