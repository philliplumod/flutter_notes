import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes/presentation/screens/note_detail_screen.dart';
import 'package:flutter_notes/presentation/widgets/note_icon_button.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';

import '../../data/db/notes_database.dart';
import '../../data/model/note_model.dart';
import '../bloc/notes_bloc.dart';
import '../widgets/note_card.dart';
import 'note_edit_screen.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key}) : super(key: key);

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  bool isEditing = false;
  late NotesBloc _notesBloc;
  Notes? note;

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
      elevation: 0,
      centerTitle: true,
      title: RichText(
        text: const TextSpan(
            children: [
              TextSpan(text: 'Flutter'),
              TextSpan(
                text: 'Notes',
                style: TextStyle(color: Colors.blue),
              )
            ],
            style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
      ),
      actions: const [
        Icon(Icons.search, color: Colors.black),
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
            onTap: () {
              _showNoteDetailBottomSheet(note);
            },
            child: NoteCardWidget(note: note, index: index),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  void _showNoteDetailBottomSheet(Notes note) {
    setState(() {
      this.note = note;
    });
    final currentContext = context;
    showModalBottomSheet(
      context: currentContext,
      builder: (BuildContext context) {
        return _buildNoteDetailBottomSheet(note, context);
      },
    );
  }

  Widget _buildNoteDetailBottomSheet(Notes note, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            spreadRadius: 0.0,
          )
        ],
      ),
      alignment: Alignment.topLeft,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                note.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  // edit
                  IconButton(
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NoteDetailScreen(
                            noteId: note.id!,
                          ),
                        ),
                      );
                      _notesBloc.add(RefreshNotesEvent());
                    },
                    icon: const Icon(Icons.edit_outlined),
                  ),

                  // delete
                  CustomIconButton(
                    onPressed: () async {
                      await NotesDatabase.instance.delete(note.id!);
                      _notesBloc.add(RefreshNotesEvent());
                    },
                    icon: const Icon(Icons.delete_outline),
                    parentContext: context,
                  )
                ],
              )
            ],
          ),
          Text(note.description),
          Text(
            DateFormat.yMMMd().format(note.createdTime),
            style: const TextStyle(color: Colors.black, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
