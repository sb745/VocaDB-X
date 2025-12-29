import 'package:flutter/cupertino.dart';

/// An utility widget for add blank space with full width and given height
class SpaceDivider extends StatelessWidget {
  /// The height of space
  final double height;

  const SpaceDivider(this.height, {super.key});

  const SpaceDivider.micro({super.key, this.height = 4.0});

  const SpaceDivider.small({super.key, this.height = 16.0});

  const SpaceDivider.medium({super.key, this.height = 32.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
    );
  }
}
