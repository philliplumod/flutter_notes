import 'package:flutter/material.dart';
import 'package:flutter_notes/data/db/notes_database.dart';
import 'package:flutter_notes/presentation/screens/note_edit_screen.dart';
import 'package:intl/intl.dart';

import '../../data/model/note_model.dart';

class NoteDetailScreen extends StatefulWidget {
  final int noteId;
  const NoteDetailScreen({super.key, required this.noteId});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late Notes note;
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

    note = (await NotesDatabase.instance.readNote(widget.noteId));
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  Text(
                    note.title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DateFormat.yMMMd().format(note.createdTime),
                    style: const TextStyle(color: Colors.white70, fontSize: 18),
                  )
                ],
              ),
            ),
    );
  }

  AppBar _appBar() => AppBar(
        actions: [editButton(), deleteButton()],
      );

  Widget editButton() {
    return IconButton(
      icon: const Icon(Icons.edit_outlined),
      onPressed: () async {
        if (isLoading) {}
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddEditNotePage(note: note)));

        refreshNote();
      },
    );
  }

  Widget deleteButton() {
    return IconButton(
        onPressed: () async {
          await NotesDatabase.instance.delete(widget.noteId);
        },
        icon: const Icon(Icons.delete));
  }
}
