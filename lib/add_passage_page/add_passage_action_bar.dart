import 'package:bibleram/guess_page.dart';
import 'package:bibleram/utils.dart';
import 'package:flutter/material.dart';

class AddActions extends StatefulWidget {
  final VoidCallback onAddVerse;
  final VoidCallback onPopularVerse;
  final VoidCallback onPractice;
  final VoidCallback onAddToSet;

  const AddActions({
    super.key,
    required this.onAddVerse,
    required this.onAddToSet,
    required this.onPopularVerse,
    required this.onPractice,
    bool addPassageEnabled = true,
  });

  @override
  State<AddActions> createState() => _AddActionsState();
}

class _AddActionsState extends State<AddActions> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        RamTextIconButton(
          icon: Icons.diamond,
          text: "Popular",
          color: Color(0xFFA5D6F7),
          iconSize: 30,
          onTap: widget.onPopularVerse,
        ),
        RamTextIconButton(
          icon: Icons.queue,
          text: "Add to set",
          iconSize: 30,
          onTap: widget.onAddToSet,
        ),
        RamTextIconButton(
          icon: Icons.check_rounded,
          text: "Add",
          color: colorScheme.secondaryContainer,
          iconSize: 30,
          onTap: widget.onAddVerse,
        ),
        RamTextIconButton(
          icon: Icons.play_arrow,
          text: "Start",
          color: colorScheme.secondaryContainer,
          iconSize: 30,
          onTap: widget.onPractice,
        ),
      ].map((e) => Expanded(child: e)).toList(),
    );
  }
}
