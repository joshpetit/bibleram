import 'package:bibleram/app_cubit.dart';
import 'package:bibleram/guess_page.dart';
import 'package:bibleram/main.dart';
import 'package:bibleram/models/passage_set.dart';
import 'package:bibleram/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PassageSetManager extends StatefulWidget {
  const PassageSetManager({
    super.key,
    required this.onAddPassageToSet,
    required this.passageId,
  });
  final void Function(PassageSet) onAddPassageToSet;
  final int passageId;

  @override
  State<PassageSetManager> createState() => _PassageSetManagerState();
}

class _PassageSetManagerState extends State<PassageSetManager> {
  var newSetTextController = TextEditingController();
  var textFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    newSetTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Passage Sets", style: textTheme.titleLarge),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<AppCubit, AppState>(
                    builder: (context, appState) {
                  var sets = appState.passageSets;
                  return ListView.builder(
                    itemCount: sets.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      var passageSet = sets[index];
                      var hasPassage = passageSet.passages
                          .any((e) => widget.passageId == e.id);
                      return ListTile(
                        title: Text(passageSet.name),
                        subtitle: Text(
                          passageSet.description,
                        ),
                        trailing: SizedBox(
                          height: 20,
                          child: Icon(
                            hasPassage ? Icons.remove : Icons.queue,
                          ),
                        ),
                        onTap: () {
                          if (hasPassage) {
                            appCubit.removePassageFromSet(
                              passageSet.id,
                              widget.passageId,
                            );
                          } else {
                            widget.onAddPassageToSet(passageSet);
                          }
                        },
                      );
                    },
                  );
                }),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                        controller: newSetTextController,
                        focusNode: textFocusNode,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          hintText: "New Set Name...",
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: RamTextIconButton(
                      icon: Icons.add,
                      text: "Add New Set",
                      iconSize: 25,
                      textStyle: textTheme.bodySmall,
                      onTap: () {
                        var text = newSetTextController.text;
                        if (text.isNotEmpty) {
                          appCubit.createSet(newSetTextController.text);
                        } else {
                            FocusScope.of(context).requestFocus(textFocusNode);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
