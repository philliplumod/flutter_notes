import 'package:flutter/material.dart';
import 'package:flutter_notes/data/db/notes_database.dart';
import 'package:flutter_notes/data/model/note_model.dart';
import 'package:flutter_notes/presentation/widgets/note_form.dart';

class NoteUpdateScreen extends StatefulWidget {
  final int noteId;
  const NoteUpdateScreen({Key? key, required this.noteId}) : super(key: key);

  @override
  State<NoteUpdateScreen> createState() => _NoteUpdateScreenState();
}

class _NoteUpdateScreenState extends State<NoteUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String description;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNote();
  }

  Future refreshNote() async {
    setState(() {
      isLoading = true;
    });
    final note = await NotesDatabase.instance.readNote(widget.noteId);
    setState(() {
      isLoading = false;
      title = note.title;
      description = note.description;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
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
                },
              ),
            ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black,
      elevation: 0,
    );
  }
}
