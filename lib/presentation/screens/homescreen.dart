import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: const Text.rich(
        TextSpan(
          text: 'Flutter',
          style: TextStyle(color: Colors.black),
          children: [
            TextSpan(
              text: 'Notes',
              style: TextStyle(color: Colors.blueAccent),
            ),
          ],
        ),
      ),
    );
  }
}
