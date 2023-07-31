import 'package:flutter/material.dart';
import 'package:flutter_notes/data/db/notes_database.dart';
import 'package:flutter_notes/presentation/screens/note_detail_screen.dart';
import 'package:flutter_notes/presentation/screens/note_edit_screen.dart';
import 'package:flutter_notes/presentation/widgets/note_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../data/model/note_model.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late List<Notes> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();
    super.dispose();
  }

  Future refreshNotes() async {
    setState(() {
      isLoading = true;
    });

    notes = await NotesDatabase.instance.readAllNotes();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : notes.isEmpty
                ? const Text(
                    'No Notes',
                    style: TextStyle(color: Colors.black, fontSize: 24),
                  )
                : buildNotes(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddEditNotePage()));
          refreshNotes();
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: const Text(
        'Notes',
        style: TextStyle(color: Colors.blueAccent),
      ),
      actions: const [
        Icon(Icons.search),
        SizedBox(
          width: 12,
        )
      ],
    );
  }

  Widget buildNotes() {
    if (notes.isEmpty) {
      return const Center(
        child: Text(
          'No Notes',
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
      );
    }

    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      padding: const EdgeInsets.all(8),
      staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        if (index < notes.length) {
          final Notes note = notes[index];
          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NoteDetailScreen(noteId: note.id!),
              ));
              refreshNotes();
            },
            child: NoteCardWidget(note: note, index: index),
          );
        } else {
          return const SizedBox
              .shrink(); // Return an empty widget for invalid indices
        }
      },
    );
  }

  // Widget buildNotes() => StaggeredGridView.countBuilder(
  //       crossAxisCount: 4,
  //       mainAxisSpacing: 4,
  //       crossAxisSpacing: 4,
  //       padding: const EdgeInsets.all(8),
  //       staggeredTileBuilder: (index) => const StaggeredTile.fit(2),
  //       itemBuilder: (context, index) {
  //         final Notes note = notes[index];
  //         return GestureDetector(
  //           onTap: () async {
  //             await Navigator.of(context).push(MaterialPageRoute(
  //               builder: (context) => NoteDetailScreen(noteId: note.id!),
  //             ));
  //             refreshNotes();
  //           },
  //           child: NoteCardWidget(note: note, index: index),
  //         );
  //       },
  //     );
}
