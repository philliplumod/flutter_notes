import 'package:flutter/material.dart';
import 'package:flutter_notes/presentation/screens/note_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NoteScreen(),
    );
  }
}
