import 'package:bibleram/app_cubit.dart';
import 'package:bibleram/guess_page.dart';
import 'package:bibleram/models/passage_being_memorized.dart';
import 'package:bibleram/passage_set_manager.dart';
import 'package:bibleram/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerseCard extends StatefulWidget {
  const VerseCard({
    super.key,
    required this.passage,
  });

  final PassageBeingMemorized passage;

  @override
  State<VerseCard> createState() => _VerseCardState();
}

class _VerseCardState extends State<VerseCard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(24),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${widget.passage.reference} (${widget.passage.version})",
                  style: textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Text(
                        widget.passage.passageText(),
                        style: textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RamTextIconButton(
                      icon: Icons.queue,
                      text: "Add to set",
                      iconSize: 30,
                      onTap: () {
                        var cubit = BlocProvider.of<AppCubit>(context);
                        push(context, PassageSetManager(
                          passageId: widget.passage.id,
                          onAddPassageToSet: (passageSet) {
                            cubit.addPassageToSet(
                              passageSet.id,
                              widget.passage.id,
                            );
                          },
                        ));
                      },
                    ),
                    RamTextIconButton(
                      icon: Icons.copy,
                      text: "Copy",
                      iconSize: 30,
                      onTap: () {
                        Clipboard.setData(ClipboardData(
                          text:
                              "${widget.passage.passageText()} ${widget.passage.reference} ${widget.passage.version}",
                        ));
                      },
                    ),
                    RamTextIconButton(
                      icon: Icons.play_arrow,
                      text: "Practice",
                      color: colorScheme.secondaryContainer,
                      iconSize: 40,
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute<Widget>(
                            builder: (context) {
                              BlocProvider.of<AppCubit>(context)
                                  .start(
                                passage: widget.passage,
                              );
                              return GuessPage();
                            },
                          ),
                        );
                      },
                    ),
                    RamTextIconButton(
                      icon: Icons.delete,
                      text: "Delete",
                      iconSize: 30,
                      color: colorScheme.tertiary,
                      onTap: () {
                        var cubit = BlocProvider.of<AppCubit>(context);
                        cubit.removePassage(passage: widget.passage);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Positioned(
          top: -3.0,
          left: 0.0,
          right: 0.0,
          child: AppBar(
            title: Text(''),
            backgroundColor: Colors.transparent,
          ),
        )
      ],
    );
  }
}
