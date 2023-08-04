import 'package:flutter/material.dart';
import 'package:flutter_notes/presentation/widgets/note_form.dart';
import 'package:intl/intl.dart';

import '../../data/db/notes_database.dart';
import '../../data/model/note_model.dart';

class NoteUpdateScreen extends StatefulWidget {
  final Notes? notes;
  final int noteId;
  const NoteUpdateScreen({super.key, required this.noteId, this.notes});

  @override
  State<NoteUpdateScreen> createState() => _NoteUpdateScreenState();
}

class _NoteUpdateScreenState extends State<NoteUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String description;
  late Notes note;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNote();
    title = widget.notes?.title ?? '';
    description = widget.notes?.description ?? '';
  }

  Future refreshNote() async {
    setState(() {
      isLoading = true;
    });
    note = (await NotesDatabase.instance.readNote(widget.noteId));
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          // : Padding(
          //     padding: const EdgeInsets.all(12),
          //     child: ListView(
          //       padding: const EdgeInsets.symmetric(vertical: 8),
          //       children: [
          //         Text(
          //           note.title,
          //           style: const TextStyle(
          //               color: Colors.black,
          //               fontSize: 22,
          //               fontWeight: FontWeight.bold),
          //         ),
          //         const SizedBox(height: 8),
          //         Text(note.description),
          //         Text(
          //           DateFormat.yMMMd().format(note.createdTime),
          //           style: const TextStyle(color: Colors.grey),
          //         ),
          //       ],
          //     ),
          //   ),
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
