import 'package:bibleram/guess_page.dart';
import 'package:flutter/material.dart';

class PassageGroupActions extends StatelessWidget {
  const PassageGroupActions({
    super.key,
    required this.percent,
    required this.onPlaylistAdd,
    this.onStartVerse,
  });

  final int percent;
  final void Function() onPlaylistAdd;
  final void Function()? onStartVerse;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              width: 100,
              child: LinearProgressIndicator(
                value: percent / 100,
                semanticsValue: "$percent% memorized",
                minHeight: 15,
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                valueColor: AlwaysStoppedAnimation(
                  Theme.of(context).colorScheme.secondaryContainer,
                ),
              ),
            ),
            Positioned(
              right: -35,
              child: Text("$percent%"),
            ),
          ],
        ),
        Spacer(),
        Row(
          children: [
            if (onStartVerse != null)
              RamTextIconButton(
                onTap: onStartVerse,
                icon: Icons.play_arrow,
                color: Theme.of(context).colorScheme.secondaryContainer,
                iconSize: 30,
              ),
            // SizedBox(width: 15),
            // RamTextIconButton(
            //   onTap: onPlaylistAdd,
            //   icon: Icons.playlist_add,
            //   iconSize: 30,
            // ),
          ],
        ),
        Spacer(),
        Spacer(),
      ],
    );
  }
}
