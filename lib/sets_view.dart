import 'package:bibleram/guess_page.dart';
import 'package:bibleram/models/passage_set.dart';
import 'package:bibleram/passage_group_actions.dart';
import 'package:bibleram/passage_set_page.dart';
import 'package:bibleram/utils.dart';
import 'package:flutter/material.dart';

class SetsView extends StatefulWidget {
  const SetsView({
    super.key,
    required this.passageSets,
    required this.onStartSet,
  });
  final List<PassageSet> passageSets;
  final void Function(PassageSet) onStartSet;

  @override
  State<SetsView> createState() => _SetsViewState();
}

class _SetsViewState extends State<SetsView> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: basicSeparator,
      itemCount: widget.passageSets.length,
      itemBuilder: (context, index) {
        var passageSet = widget.passageSets[index];
        return InkWell(
          onTap: () {
            push(
              context,
              PassageSetPage(passageSet: passageSet),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(),
                      Text(
                        passageSet.name,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          passageSet.description,
                          style: textTheme.bodyMedium?.copyWith(
                            color: textTheme.bodySmall?.color,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      PassageGroupActions(
                        percent: passageSet.percentMemorized,
                        onPlaylistAdd: () {},
                        onStartVerse: () {
                          widget.onStartSet(passageSet);
                        },
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
