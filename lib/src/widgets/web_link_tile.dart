import 'package:flutter/material.dart';
import 'package:vocadb_app/utils.dart';
import 'package:vocadb_app/widgets.dart';

/// A widget for display web link and redirect to the given url
class WebLinkTile extends StatelessWidget {
  final String title;

  final String url;

  final double iconSize;

  const WebLinkTile({super.key, required this.title, required this.url, this.iconSize = 32});

  Widget buildLeading() {
    IconSite? ic = IconSiteList.findIconAsset(title);

    return (ic == null) ? Icon(Icons.web) : buildImageIcon(ic.assetName);
  }

  Widget buildImageIcon(String assetName) {
    return SizedBox(
      width: iconSize,
      height: iconSize,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Image.asset(assetName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SiteTile(
      title: title,
      url: url, 
      subtitle: '',
    );
  }
}
