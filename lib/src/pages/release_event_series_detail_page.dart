import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vocadb_app/arguments.dart';
import 'package:vocadb_app/controllers.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/pages.dart';
import 'package:vocadb_app/repositories.dart';
import 'package:vocadb_app/routes.dart';
import 'package:vocadb_app/services.dart';
import 'package:vocadb_app/widgets.dart';

class ReleaseEventSeriesDetailPage extends StatelessWidget {
  const ReleaseEventSeriesDetailPage({super.key});

  ReleaseEventSeriesDetailController initController() {
    final httpService = Get.find<HttpService>();
    return ReleaseEventSeriesDetailController(
        eventSeriesRepository:
            ReleaseEventSeriesRepository(httpService: httpService));
  }

  @override
  Widget build(BuildContext context) {
    final ReleaseEventSeriesDetailController controller = initController();
    final ReleaseEventSeriesDetailArgs args = Get.arguments;
    final String? id = Get.parameters['id'];

    return PageBuilder<ReleaseEventSeriesDetailController>(
      tag: "event_series_$id",
      controller: controller,
      builder: (c) =>
          ReleaseEventSeriesDetailPageView(controller: c, args: args),
    );
  }
}

class ReleaseEventSeriesDetailPageView extends StatelessWidget {
  final ReleaseEventSeriesDetailController controller;

  final ReleaseEventSeriesDetailArgs args;

  const ReleaseEventSeriesDetailPageView({super.key, required this.controller, required this.args});

  void _onTapShareButton() => Share.share(controller.eventSeries().originUrl);

  void _onTapInfoButton() => launch(controller.eventSeries().originUrl);

  void _onTapHome() => Get.offAll(MainPage());

  void _onTapEntrySearch() => Get.toNamed(Routes.ENTRIES);

  void _onSelectTag(TagModel tag) => AppPages.toTagDetailPage(tag);

  void _onTapEvent(ReleaseEventModel event) => AppPages.toReleaseEventDetailPage(event);

  Widget buildData() {
    return OrientationBuilder(
      builder: (context, orientation) {
        final expandedHeight = orientation == Orientation.landscape ? 120.0 : 200.0;
        
        return CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: expandedHeight,
              pinned: true,
              actions: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _onTapEntrySearch,
                ),
                IconButton(
                  icon: Icon(Icons.home),
                  onPressed: _onTapHome,
                )
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: Text(controller.eventSeries().name.toString()),
                background: (controller.eventSeries().imageUrl == null)
                    ? Container()
                    : CustomNetworkImage(controller.eventSeries().imageUrl),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate.fixed([
                SpaceDivider.small(),
                OverflowBar(
                  alignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: _onTapShareButton,
                      child: Column(
                        children: [Icon(Icons.share), Text('share'.tr)],
                      ),
                    ),
                    TextButton(
                      onPressed: _onTapInfoButton,
                      child: Column(
                        children: [Icon(Icons.info), Text('info'.tr)],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TagGroupView(
                        onPressed: _onSelectTag,
                        tags: controller
                                .eventSeries()
                                .tagGroups
                                ?.map((t) => t.tag)
                                .whereType<TagModel>()
                                .toList() ??
                            [],
                      ),
                      TextInfoSection(
                        title: 'name'.tr,
                        text: controller.eventSeries().name,
                      ),
                      TextInfoSection(
                        title: 'category'.tr,
                        text:
                            'eventCategory.${controller.eventSeries().category}'.tr,
                      ),
                      TextInfoSection(
                        title: 'description'.tr,
                        text: controller.eventSeries().description,
                      ),
                    ],
                  ),
                ),
                Section(
                  title: 'references'.tr,
                  child: Column(
                    children: (controller.eventSeries().webLinks ?? [])
                        .map((e) => WebLinkTile(
                              title: e.description ?? 'Unknown Link',
                              url: e.url ?? '',
                            ))
                        .toList(),
                  ),
                ),
                Section(
                  title: 'events'.tr,
                  child: Column(
                    children: (controller.eventSeries().events ?? [])
                        .map((e) => ListTile(
                              leading: Icon(Icons.event),
                              title: Text(e.name ?? '<unknown>'),
                              subtitle: Text(e.dateFormatted ?? ''),
                              onTap: (e.id != null) ? () => _onTapEvent(e) : null,
                            ))
                        .toList(),
                  ),
                ),
              ]),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(
      () => (controller.initialLoading.value)
          ? CenterLoading()
          : (controller.errorMessage.string.isNotEmpty)
              ? CenterText(controller.errorMessage.string)
              : buildData(),
    ));
  }
}
