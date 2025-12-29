import 'package:flutter/material.dart';
import 'package:vocadb_app/widgets.dart';

/// A widget for display Icon, title and subtitle
class InfoMessageView extends StatelessWidget {
  final Widget? icon;

  final String? title;

  final String? subtitle;

  const InfoMessageView({super.key, this.icon, required this.title, this.subtitle})
      : assert(title != null);

  InfoMessageView.error({super.key, this.title, this.subtitle})
      : icon = Icon(Icons.error, size: 48);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (icon != null) icon!,
            SpaceDivider.small(),
            Text(title!, style: Theme.of(context).textTheme.headlineMedium),
            SpaceDivider.micro(),
            (subtitle != null)
                ? Text(subtitle!,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center)
                : Container()
          ],
        ),
      ),
    );
  }
}
