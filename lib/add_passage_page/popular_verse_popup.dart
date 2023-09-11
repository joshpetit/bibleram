import 'package:bibleram/models/passage_being_memorized.dart';
import 'package:bibleram/services/bible_service.dart';
import 'package:bibleram/utils.dart';
import 'package:flutter/material.dart';
import 'package:reference_parser/reference_parser.dart';

class PopularPassagePopup extends StatefulWidget {
  const PopularPassagePopup({
    super.key,
    required this.bibleService,
    required this.onSelected,
  });
  final BibleService bibleService;
  final void Function(Reference selectedPassage) onSelected;

  @override
  State<PopularPassagePopup> createState() => _PopularPassagePopupState();
}

class _PopularPassagePopupState extends State<PopularPassagePopup> {
  List<(PassageBeingMemorized, String)> passages = [];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      for (var passageRefText in popularPassages) {
        var passageRef = parseReference(passageRefText);
        var verses =
            await widget.bibleService.getVersesBeingMemorized(passageRef);
        var passage = PassageBeingMemorized(
          reference: passageRef.reference!,
          version: widget.bibleService.version,
        );
        passage.versesInPassage.addAll(verses);
        passages.add((
          passage,
          verses.map((e) => e.verseText).join(" ").truncateTo(120)
        ));
      }

      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Popular Verses",
                      style: textTheme.titleLarge,
                      textAlign: TextAlign.left,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2.0),
                      child: Text(
                        " (click to preview)",
                        style: textTheme.bodySmall,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: passages.length,
                          itemBuilder: (context, index) {
                            var passage = passages[index].$1;
                            var text = passages[index].$2;
                            return ListTile(
                              onTap: () {
                                widget.onSelected(passage.smartReference);
                                Navigator.pop(context);
                              },
                              contentPadding: EdgeInsets.only(left: 5, top: 10),
                              title: Text(
                                '${passage.reference} ${passage.version}',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(text),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 10.0,
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

List<String> popularPassages = [
  "Philippians 4:11-12",
  "John 10:10",
  "Philippians 4:8",
  "Exodus 20:8-11",
  "Philippians 4:6-7",
  "Matthew 28:19-20",
  "Romans 5:8",
  "Ephesians 2:8-9",
  "Proverbs 3:5",
  "Galatians 5:22-23",
  "Romans 8:28",
  "John 11:25-26",
  "Romans 12:1",
  "2 Timothy 1:7",
  "Isaiah 43:25",
  "Hebrews 12:11",
  "Romans 12:2",
];
