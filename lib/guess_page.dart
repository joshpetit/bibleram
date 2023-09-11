import 'dart:async';

import 'package:bibleram/app_cubit.dart';
import 'package:bibleram/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class GuessPage extends StatefulWidget {
  const GuessPage({
    super.key,
  });

  @override
  State<GuessPage> createState() => _GuessPageState();
}

class _GuessPageState extends State<GuessPage> {
  int? rightIndex;
  int? wrongIndex;

  bool peekText = false;

  @override
  Widget build(BuildContext context) {
    var textStyleBlankWord = TextStyle(
      color: Theme.of(context).colorScheme.tertiaryContainer,
    );
    var textStyleHighlightedWord = TextStyle(
      color: Theme.of(context).colorScheme.tertiary,
    );
    var textStyleNormal = TextStyle(
      color: colorScheme.onBackground,
    );
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: BlocBuilder<AppCubit, AppState>(builder: (context, state) {
                final List<RamButton> buttons =
                    state.displayOptions.asMap().entries.map(
                  (e) {
                    var option = e.value;
                    Color? color;
                    if (rightIndex == e.key) {
                      color = Theme.of(context).colorScheme.secondary;
                    } else if (wrongIndex == e.key) {
                      color = Theme.of(context).colorScheme.tertiary;
                    }
                    return RamButton(
                      text: option.value,
                      color: color,
                      animateToGoodOnPress: option.correctAnswer,
                      onPressed: () {
                        option.enterOption();
                        setState(() {
                          if (option.correctAnswer) {
                            rightIndex = e.key;
                          } else {
                            wrongIndex = e.key;
                          }
                        });

                        Timer(Duration(milliseconds: 100), () {
                          setState(() {
                            rightIndex = null;
                            wrongIndex = null;
                          });
                        });
                      },
                    );
                  },
                ).toList();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: peekText
                          ? Text(
                              state.verseBeingMemorized.reference,
                              style: GoogleFonts.notoSansMono(
                                fontSize: 25,
                              ),
                            )
                          : RichText(
                              text: TextSpan(
                                style: GoogleFonts.notoSansMono(
                                  fontSize: 25,
                                ),
                                children: state.displayReferenceSpans
                                    .map(
                                      (e) => TextSpan(
                                          text: e.text,
                                          style: switch (e.type) {
                                            TextType.text => textStyleNormal,
                                            TextType.underline =>
                                              textStyleBlankWord,
                                            TextType.highlightedUnderline =>
                                              textStyleHighlightedWord,
                                          }),
                                    )
                                    .toList(),
                              ),
                              textAlign: TextAlign.center,
                            ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 250,
                          child: LinearProgressIndicator(
                            value: state.verseBeingMemorized.percentMemorized /
                                100,
                            semanticsValue:
                                "${state.verseBeingMemorized.percentMemorized}%",
                            minHeight: 15,
                            backgroundColor:
                                Theme.of(context).colorScheme.tertiary,
                            valueColor: AlwaysStoppedAnimation(
                              Theme.of(context).colorScheme.secondaryContainer,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 20,
                          child: Text(
                            "${state.verseBeingMemorized.percentMemorized}%",
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      ],
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
                                child: peekText
                                    ? Text(
                                        state.verseBeingMemorized.verseText
                                            .trim(),
                                        style: GoogleFonts.notoSansMono(
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.center,
                                      )
                                    : RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          style: GoogleFonts.notoSansMono(
                                            fontSize: 16,
                                          ),
                                          children: state.displaySpans
                                              .map(
                                                (e) => TextSpan(
                                                    text: e.text,
                                                    style: switch (e.type) {
                                                      TextType.text =>
                                                        textStyleNormal,
                                                      TextType.underline =>
                                                        textStyleBlankWord,
                                                      TextType
                                                            .highlightedUnderline =>
                                                        textStyleHighlightedWord,
                                                    }),
                                              )
                                              .toList(),
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: SizedBox(
                        height: 30,
                        child: Visibility(
                          visible: state.totalBeingMemorized > 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RamTextIconButton(
                                icon: Icons.skip_previous,
                                iconSize: 25,
                                onTap: cubit.goToPreviousVerse,
                              ),
                              Text(
                                "Verse ${state.indexInMemorization + 1}/${state.totalBeingMemorized}",
                                style: textTheme.titleLarge,
                              ),
                              RamTextIconButton(
                                icon: Icons.skip_next,
                                iconSize: 25,
                                onTap: cubit.goToNextVerse,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 0,
                              blurRadius: 4,
                              offset:
                                  Offset(0, -1), // changes position of shadow
                            ),
                          ],
                          color: colorScheme.surface,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: state.displayOptions.isNotEmpty
                              ? Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        buttons[0],
                                        buttons[1],
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        buttons[2],
                                        buttons[3],
                                      ],
                                    ),
                                    SizedBox(
                                      height: 65,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              child: RamTextIconButton(
                                                text: "Back",
                                                icon: Icons.navigate_before,
                                                textStyle: TextStyle(
                                                  color:
                                                      colorScheme.onSecondary,
                                                ),
                                                onTap: cubit.previousPassage,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: RamButton(
                                              text: "Retry",
                                              fixedSize: null,
                                              alt: true,
                                              textColor:
                                                  colorScheme.onSecondary,
                                              onPressed: cubit.refreshBoard,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              child: RamTextIconButton(
                                                text: "Next",
                                                icon: Icons.navigate_next,
                                                textStyle: TextStyle(
                                                  color:
                                                      colorScheme.onSecondary,
                                                ),
                                                onTap: cubit.nextPassage,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        RamTextIconButton(
                                          icon: Icons.restart_alt,
                                          text: 'Start Over',
                                          color: colorScheme.tertiary,
                                          onTap: () {
                                            cubit.startOver();
                                          },
                                        ),
                                        RamTextIconButton(
                                          icon: Icons.fast_forward,
                                          text: 'Fast Forward',
                                          color: colorScheme.secondaryContainer,
                                          onTap: () {
                                            cubit.fastForward();
                                          },
                                        ),
                                        RamTextIconButton(
                                          icon: Icons.visibility,
                                          text: "Peek",
                                          onTapDown: (_) {
                                            setState(() {
                                              peekText = true;
                                            });
                                            cubit.onPeekText();
                                          },
                                          onTapUp: (_) {
                                            setState(() {
                                              peekText = false;
                                            });
                                          },
                                          onTapCancel: () {
                                            setState(() {
                                              peekText = false;
                                            });
                                          },
                                        ),
                                      ].map((e) => Expanded(child: e)).toList(),
                                    ),
                                  ],
                                )
                              : Container(),
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

  ColorScheme get colorScheme => Theme.of(context).colorScheme;
  AppCubit get cubit => BlocProvider.of<AppCubit>(context);
}

class RamButton extends StatefulWidget {
  const RamButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.fixedSize = const Size(150, 65),
    this.alt = false,
    this.animateToGoodOnPress = true,
    this.color,
    this.padding,
    this.textColor,
    this.textStyle,
    this.onLongPress,
  });
  final Color? color;
  final Color? textColor;
  final String text;
  final bool alt;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final Size? fixedSize;
  final bool animateToGoodOnPress;
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;

  @override
  State<RamButton> createState() => _RamButtonState();
}

class _RamButtonState extends State<RamButton> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(
        seconds: 3,
      ),
      child: FilledButton(
        child: Text(
          widget.text,
          style: widget.textStyle ?? TextStyle(color: widget.textColor),
          textAlign: TextAlign.center,
        ),
        onLongPress: widget.onLongPress,
        onPressed: () {
          widget.onPressed();
        },
        style: ElevatedButton.styleFrom(
          fixedSize: widget.fixedSize,
          padding: widget.padding,
          shape: RoundedRectangleBorder(),
          backgroundColor: widget.color,
        ),
      ),
    );
  }
}

class RamTextIconButton extends StatelessWidget {
  const RamTextIconButton({
    super.key,
    required this.icon,
    this.text,
    this.color,
    this.horizontal = false,
    this.onTap,
    this.onLongPress,
    this.iconSize = 20,
    this.iconSpacing = 0,
    this.textStyle,
    this.onTapUp,
    this.onTapDown,
    this.onTapCancel,
  });

  final IconData icon;
  final bool horizontal;
  final String? text;
  final Color? color;
  final double iconSize;
  final double iconSpacing;
  final TextStyle? textStyle;
  final VoidCallback? onTap;
  final VoidCallback? onTapCancel;
  final void Function(TapUpDetails?)? onTapUp;
  final void Function(TapDownDetails?)? onTapDown;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    var widget = [
      Icon(
        icon,
        size: iconSize,
        color: color,
      ),
      if (text != null) ...[
        SizedBox(
          height: iconSpacing,
        ),
        Text(text!, style: textStyle, textAlign: TextAlign.center),
      ]
    ];
    return InkWell(
      onTap: onTap,
      highlightColor: Colors.transparent,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      onLongPress: onLongPress,
      radius: 200,
      splashFactory: NoSplash.splashFactory,
      child: horizontal
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: widget.reversed.toList(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: widget,
            ),
    );
  }
}
