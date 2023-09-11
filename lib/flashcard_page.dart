import 'package:bibleram/app_cubit.dart';
import 'package:bibleram/guess_page.dart';
import 'package:bibleram/utils.dart';
import 'package:bibleram/verse_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class FlashcardPage extends StatefulWidget {
  const FlashcardPage({
    super.key,
  });

  @override
  State<FlashcardPage> createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  bool hideText = true;
  bool showAnwer = false;

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<AppCubit>(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: BlocBuilder<AppCubit, AppState>(builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Text(
                          !hideText && !showAnwer
                              ? "___________"
                              : state.passageBeingMemorized!.reference,
                          style: GoogleFonts.notoSansMono(
                            fontSize: 25,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Center(
                          child: Scrollbar(
                            thumbVisibility: true,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                child: Text(
                                  hideText && !showAnwer
                                      ? "_________________________"
                                      : state.passageBeingMemorized!
                                          .passageText(),
                                  style: GoogleFonts.notoSansMono(
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                RamButton(
                                  text: "<",
                                  onPressed: () {
                                    setState(() {
                                      showAnwer = false;
                                    });
                                    cubit.previousPassage();
                                  },
                                  fixedSize: null,
                                  textStyle: textTheme.titleLarge,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 30,
                                  ),
                                ),
                                Expanded(
                                  child: RamButton(
                                    text: showAnwer ? "Hide" : "Reveal",
                                    onLongPress: toggleShowAnswer,
                                    onPressed: toggleShowAnswer,
                                    fixedSize: null,
                                    textStyle: textTheme.titleLarge,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 30,
                                    ),
                                  ),
                                ),
                                RamButton(
                                  text: ">",
                                  onPressed: () {
                                    setState(() {
                                      showAnwer = false;
                                    });
                                    cubit.nextPassage();
                                  },
                                  fixedSize: null,
                                  textStyle: textTheme.titleLarge,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 30,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 24),
                            Row(
                              children: [
                                RamTextIconButton(
                                  icon: Icons.flip_to_front,
                                  text: !hideText
                                      ? 'Hide Text'
                                      : 'Hide Reference',
                                  iconSize: 30,
                                  color: colorScheme.onBackground,
                                  onTap: () {
                                    setState(() {
                                      hideText = !hideText;
                                      showAnwer = false;
                                    });
                                  },
                                ),
                                Visibility(
                                  visible: showAnwer,
                                  child: RamTextIconButton(
                                    icon: Icons.open_in_new,
                                    text: 'Verse',
                                    iconSize: 30,
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
                                              child: VerseCard(
                                                passage: state
                                                    .passageBeingMemorized!,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                                RamTextIconButton(
                                  icon: Icons.play_arrow,
                                  text: 'Practice',
                                  iconSize: 30,
                                  color: colorScheme.secondaryContainer,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GuessPage(),
                                      ),
                                    );
                                  },
                                ),
                              ].map((e) => Expanded(child: e)).toList(),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              }),
            ),
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: AppBar(
                title: Text(''),
                backgroundColor: Colors.transparent,
              ),
            )
          ],
        ),
      ),
    );
  }

  void toggleShowAnswer() {
    setState(() {
      showAnwer = !showAnwer;
    });
  }
}
