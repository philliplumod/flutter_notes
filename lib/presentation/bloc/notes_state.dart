part of 'notes_bloc.dart';

@immutable
abstract class NotesState {}

class NotesInitial extends NotesState {}

class NotesLoadingState extends NotesState {
  
}

class NotesLoadedState extends NotesState {
  final List<Notes> notes;

  NotesLoadedState(this.notes);
}
