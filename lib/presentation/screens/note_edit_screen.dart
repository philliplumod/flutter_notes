// import 'package:flutter/material.dart';
// import 'package:flutter_notes/data/db/notes_database.dart';
// import 'package:flutter_notes/data/model/note_model.dart';
// import 'package:flutter_notes/presentation/widgets/note_form.dart';

// class AddEditNotePage extends StatefulWidget {
//   final Notes? note;
//   const AddEditNotePage({super.key, this.note});

//   @override
//   State<AddEditNotePage> createState() => _AddEditNotePageState();
// }

// class _AddEditNotePageState extends State<AddEditNotePage> {
//   final _formKey = GlobalKey<FormState>();
//   // late bool isImportant;
//   // late int number;
//   late String title;
//   late String description;

//   @override
//   void initState() {
//     super.initState();
//     // isImportant = widget.note?.isImportant ?? false;
//     // number = widget.note?.number ?? 0;
//     title = widget.note?.title ?? '';
//     description = widget.note?.description ?? '';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         actions: [buildButton()],
//       ),
//       body: Form(
//         key: _formKey,
//         child: NoteFormWidget(
//           // isImportant: isImportant,
//           // number: number,
//           title: title,
//           description: description,
//           // onChangedNumber: (number) {
//           //   setState(() {
//           //     this.number = number;
//           //   });
//           // },
//           onChangedTitle: (title) {
//             setState(() {
//               this.title = title;
//             });
//           },
//           onChangedDescription: (description) {
//             setState(() {
//               this.description = description;
//             });
//           },
//         ),
//       ),
//     );
//   }

//   Widget buildButton() {
//     final isFormValid = title.isNotEmpty && description.isNotEmpty;
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         vertical: 8,
//         horizontal: 12,
//       ),
//       child: ElevatedButton(
//         onPressed: addOrUpdateNote,
//         style: ElevatedButton.styleFrom(
//             foregroundColor: Colors.black,
//             backgroundColor: isFormValid ? null : Colors.grey),
//         child: const Text('Save'),
//       ),
//     );
//   }

//   void addOrUpdateNote() async {
//     final isValid = _formKey.currentState!.validate();

//     if (isValid) {
//       final isUpdating = widget.note != null;

//       if (isUpdating) {
//         await updateNote();
//       } else {
//         await addNote();
//       }
//     }
//   }

//   Future updateNote() async {
//     final note = widget.note!.copy(
//       // isImportant: isImportant,
//       // number: number,
//       title: title,
//       description: description,
//     );

//     await NotesDatabase.instance.update(note);
//   }

//   Future addNote() async {
//     final note = Notes(
//         // isImportant: isImportant,
//         // number: number,
//         title: title,
//         description: description,
//         createdTime: DateTime.now());
//     await NotesDatabase.instance.create(note);
//   }
// }
