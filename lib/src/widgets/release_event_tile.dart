import 'package:flutter/material.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/utils.dart';
import 'package:vocadb_app/widgets.dart';

/// A widget to display release event information for horizontal list.
class ReleaseEventTile extends StatelessWidget {
  final String? name;

  final String? venueName;

  final String? imageUrl;

  final String? category;

  final DateTime? startDate;

  final DateTime? endDate;

  final GestureTapCallback? onTap;

  /// The height of image preview. Default is 180
  final double imageHeight;

  const ReleaseEventTile(
      {super.key, this.name,
      this.venueName,
      this.imageUrl,
      this.category,
      this.startDate,
      this.endDate,
      this.onTap,
      this.imageHeight = 180});

  ReleaseEventTile.releaseEvent(ReleaseEventModel releaseEventModel,
      {super.key, this.imageHeight = 180, this.onTap})
      : name = releaseEventModel.name,
        venueName = releaseEventModel.venueName,
        imageUrl = releaseEventModel.imageUrl,
        category = releaseEventModel.displayCategory,
        startDate = DateTime.now(),
        endDate = null;

  ReleaseEventTile.fromEntry(EntryModel entryModel,
      {super.key, this.imageHeight = 180, this.onTap})
      : name = entryModel.name ?? 'Unknown Event',
        venueName = null,
        imageUrl = entryModel.imageUrl,
        category = entryModel.eventCategory,
        startDate = null,
        endDate = null;

  @override
  Widget build(BuildContext context) {
    final String? dateRange = (startDate == null)
        ? null
        : (endDate == null)
            ? DateTimeUtils.toSimpleFormat(startDate)
            : '${DateTimeUtils.toSimpleFormat(startDate)} - ${DateTimeUtils.toSimpleFormat(endDate)}';

    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: onTap,
          child: Column(
            children: [
              SizedBox(
                height: imageHeight,
                child: Stack(
                  children: [
                    Container(
                      color: Colors.black,
                    ),
                    Container(
                        child: (imageUrl != null)
                            ? CustomNetworkImage(
                          imageUrl!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        )
                            : Container(color: Colors.grey)),
                    (dateRange == null)
                        ? Container()
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Card(
                                color: Colors.black,
                                margin: EdgeInsets.all(8.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    dateRange,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SpaceDivider.micro(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          category ?? 'Unknown',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        (venueName == null)
                            ? Container()
                            : Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 4.0),
                                    child: Icon(
                                      Icons.place,
                                      size: 12,
                                    ),
                                  ),
                                  Text(
                                    venueName!,
                                    style: Theme.of(context).textTheme.labelMedium,
                                  )
                                ],
                              )
                      ],
                    ),
                    SpaceDivider.micro(),
                    Text(
                      name!,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SpaceDivider.micro(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
