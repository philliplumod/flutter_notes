part of 'notes_bloc.dart';

@immutable
abstract class NotesEvent {}

class RefreshNotesEvent extends NotesEvent {}

class AddNoteEvent extends NotesEvent {
  final Notes note;
  AddNoteEvent(this.note);
}

class UpdateNoteEvent extends NotesEvent {
  final Notes note;
  UpdateNoteEvent(this.note);
}

class DeleteNoteEvent extends NotesEvent {
  final int noteId;

  DeleteNoteEvent(this.noteId);
}
