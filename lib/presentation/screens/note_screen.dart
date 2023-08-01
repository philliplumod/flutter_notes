import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../data/db/notes_database.dart';
import '../../data/model/note_model.dart';
import '../bloc/notes_bloc.dart';
import '../widgets/note_card.dart';
import 'note_detail_screen.dart';
import 'note_edit_screen.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key}) : super(key: key);

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late NotesBloc _notesBloc;

  @override
  void initState() {
    super.initState();
    _notesBloc = NotesBloc(NotesDatabase.instance);
    _notesBloc.add(RefreshNotesEvent());
  }

  @override
  void dispose() {
    _notesBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _notesBloc,
      child: Scaffold(
        appBar: _appBar(),
        body: BlocBuilder<NotesBloc, NotesState>(
          builder: (context, state) {
            if (state is NotesLoadingState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NotesLoadedState) {
              final notes = state.notes;
              return Center(
                child: notes.isEmpty
                    ? const Text(
                        'No Notes',
                        style: TextStyle(color: Colors.black, fontSize: 24),
                      )
                    : buildNotes(notes),
              );
            }
            return Container();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddEditNotePage()),
            );
            _notesBloc.add(RefreshNotesEvent());
          },
          backgroundColor: Colors.black,
          child: const Icon(Icons.add),
        ),
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

  Widget buildNotes(List<Notes> notes) {
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
              _notesBloc.add(RefreshNotesEvent());
            },
            child: NoteCardWidget(note: note, index: index),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
