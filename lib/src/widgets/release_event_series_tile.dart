import 'package:flutter/material.dart';

/// A widget for display release event series tile
class ReleaseEventSeriesTile extends StatelessWidget {
  final String name;

  final GestureTapCallback onTap;

  const ReleaseEventSeriesTile({super.key, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (name.isEmpty) return Container();

    return ListTile(
        onTap: onTap,
        leading: Icon(Icons.calendar_today),
        title: Text(name));
  }
}
