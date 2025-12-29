import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpandableContent extends StatefulWidget {
  final Widget child;

  const ExpandableContent({super.key, required this.child});

  @override
  _ExpandableContentState createState() => _ExpandableContentState();
}

class _ExpandableContentState extends State<ExpandableContent> {
  bool expanded = false;

  @override
  void initState() {
    super.initState();
  }

  void open() {
    setState(() {
      expanded = true;
    });
  }

  void close() {
    setState(() {
      expanded = false;
    });
  }

  Widget buildHide() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: open,
        child: Text('showMore'.tr),
      ),
    );
  }

  Widget buildShow() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        widget.child,
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: close,
            child: Text('hide'.tr),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 200),
      transitionBuilder: (widget, animation) => SizeTransition(
        sizeFactor: animation,
        child: widget,
      ),
      child: (expanded) ? buildShow() : buildHide(),
    );
  }
}
