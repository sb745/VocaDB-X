import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A builder widget to build individual pages with own view and state.
/// Used on any page that can be duplicated but with different id.
/// Such as detail pages.
class PageBuilder<T extends GetxController> extends StatelessWidget {
  final T? controller;

  final Widget Function(T) builder;

  /// An unique string value for seperated state.
  final String? tag;

  const PageBuilder({super.key, this.controller, required this.builder, this.tag});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<T>(
      tag: tag,
      global: false,
      init: controller,
      dispose: (_) => controller?.onClose(),
      builder: (controller) => builder(controller),
    );
  }
}
