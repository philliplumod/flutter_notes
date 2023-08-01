import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes/data/db/notes_database.dart';
import 'package:flutter_notes/data/model/note_model.dart';
import 'package:meta/meta.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesDatabase database;

  NotesBloc(this.database) : super(NotesLoadingState()) {
    on<RefreshNotesEvent>(_mapRefreshNotesEventToState);
    on<AddNoteEvent>(_mapAddNoteEventToState);
    on<UpdateNoteEvent>(_mapUpdateNoteEventToState);
    on<DeleteNoteEvent>(_mapDeleteNoteEventToState);
  }

  Future<void> _mapRefreshNotesEventToState(RefreshNotesEvent event, Emitter<NotesState> emit) async {
    emit(NotesLoadingState());
    final notes = await database.readAllNotes();
    emit(NotesLoadedState(notes));
  }

  Future<void> _mapAddNoteEventToState(AddNoteEvent event, Emitter<NotesState> emit) async {
    await database.create(event.note);
    add(RefreshNotesEvent());
  }

  Future<void> _mapUpdateNoteEventToState(UpdateNoteEvent event, Emitter<NotesState> emit) async {
    await database.update(event.note);
    add(RefreshNotesEvent());
  }

  Future<void> _mapDeleteNoteEventToState(DeleteNoteEvent event, Emitter<NotesState> emit) async {
    await database.delete(event.noteId);
    add(RefreshNotesEvent());
  }
}
