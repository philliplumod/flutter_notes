import 'package:flutter/material.dart';

class CustomIconButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget icon;

  const CustomIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
  });

  @override
  State<CustomIconButton> createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        widget.onPressed();
        Navigator.pop(context);
      },
      icon: widget.icon,
    );
  }
}
