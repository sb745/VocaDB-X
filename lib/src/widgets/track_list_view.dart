import 'package:flutter/material.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/widgets.dart';
import 'package:get/get.dart';

/// A widget display list of tracks
class TrackListView extends StatelessWidget {
  final List<TrackModel> tracks;

  final Function(TrackModel) onSelect;

  const TrackListView({super.key, required this.tracks, required this.onSelect});

  Widget _mapTrackModel(TrackModel t) {
    if (t.song == null) {
      return TrackTile.fromTrackModel(t);
    }

    return TrackTile.fromTrackModel(
      t,
      onTap: () => onSelect(t),
    );
  }

  Column _buildHasData(BuildContext context, List<TrackModel> tracks) {
    List<Widget> widgets = [];

    Map<String, List<TrackModel>> tracksByDisc = TrackList(tracks).groupByDisc as Map<String, List<TrackModel>>;

    if (tracksByDisc.length > 1) {
      tracksByDisc.forEach((key, value) {
        widgets.add(ListTile(
          title: Text('${'disc'.tr} $key'),
        ));

        widgets.addAll(value.map<Widget>(_mapTrackModel).toList());
      });
    } else {
      widgets.addAll(tracks.map<Widget>(_mapTrackModel).toList());
    }
    return Column(
      children: widgets,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildHasData(context, tracks);
  }
}
