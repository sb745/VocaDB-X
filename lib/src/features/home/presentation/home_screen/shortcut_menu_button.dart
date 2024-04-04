import 'package:flutter/material.dart';

class ShortcutMenuButton extends StatelessWidget {
  final String title;
  final IconData iconData;
  final VoidCallback onPressed;

  const ShortcutMenuButton(
      {super.key, required this.title, required this.iconData, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RawMaterialButton(
          onPressed: onPressed,
          shape: const CircleBorder(),
          elevation: 2.0,
          fillColor: Theme.of(context).cardColor,
          padding: const EdgeInsets.all(15.0),
          child: Icon(
            iconData,
            color: Theme.of(context).iconTheme.color,
            size: 24.0,
          ),
        ),
        Text(title)
      ],
    );
  }
}