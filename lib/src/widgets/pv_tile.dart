import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vocadb_app/utils.dart';

/// A widget display simple information about PV as tile.
class PVTile extends StatelessWidget {
  final String name;

  final String service;

  final String url;

  final String pvType;

  final VoidCallback onTap;

  final double iconSize;

  const PVTile(
      {super.key,
      required this.name,
      required this.service,
      required this.url,
      required this.pvType,
      required this.onTap,
      this.iconSize = 32});

  Widget buildLeading() {
    IconSite? ic = IconSiteList.findIconAsset(service);

    return (ic == null)
        ? Icon(Icons.ondemand_video)
        : buildImageIcon(ic.assetName);
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
    return ListTile(
      leading: buildLeading(),
      title: Text(name, overflow: TextOverflow.ellipsis),
      subtitle: Text('$service • $pvType'),
      onTap: onTap,
      trailing: PopupMenuButton<String>(
        onSelected: (String selectedValue) {
          if (selectedValue == 'share') {
            Share.share(url);
          }
        },
        itemBuilder: (BuildContext context) => [
          PopupMenuItem<String>(
            value: 'share',
            child: Text('Share'),
          ),
        ],
      ),
    );
  }
}
