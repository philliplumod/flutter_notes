import 'package:flutter/material.dart';
import 'package:flutter_notes/presentation/widgets/note_form.dart';
import 'package:flutter_notes/presentation/widgets/note_icon_button.dart';

import '../../data/db/notes_database.dart';
import '../../data/model/note_model.dart';

class AddNotePage extends StatefulWidget {
  final Notes? note;
  const AddNotePage({super.key, this.note});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();
    // isImportant = widget.note?.isImportant ?? false;
    // number = widget.note?.number ?? 0;
    title = widget.note?.title ?? '';
    description = widget.note?.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        actions: [
          CustomIconButton(
            onPressed: () {
              addNotePage();
            },
            icon: Icon(
              Icons.save_outlined,
              color: isFormValid ? Colors.white : Colors.white38,
            ),
          )
        ],
      ),
      body: Form(
          key: _formKey,
          child: NoteFormWidget(
              title: title,
              description: description,
              onChangedTitle: (title) {
                setState(() {
                  this.title = title;
                });
              },
              onChangedDescription: (description) {
                setState(() {
                  this.description = description;
                });
              })),
    );
  }

  // void addNotePage() async {
  //   final isValid = _formKey.currentState!.validate();

  //   if (isValid) {
  //     await addNote();
  //   }
  // }

  // Future addNote() async {
  //   final note = Notes(
  //       // isImportant: isImportant,
  //       // number: number,
  //       title: title,
  //       description: description,
  //       createdTime: DateTime.now());
  //   await NotesDatabase.instance.create(note);
  // }

  void addNotePage() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final note = Notes(
        title: title,
        description: description,
        createdTime: DateTime.now(),
      );
      debugPrint('Adding note: $note');
      final id = await NotesDatabase.instance.create(note);
      debugPrint('Note added with ID: $id');
    }
  }
}
