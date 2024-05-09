import 'package:flutter/material.dart';
import 'package:vocadb_app/src/common_widgets/space_divider.dart';
import 'package:vocadb_app/src/constants/app_sizes.dart';
import 'package:vocadb_app/src/features/home/presentation/app_bar/app_title.dart';
import 'package:vocadb_app/src/features/home/presentation/app_bar/global_app_bar.dart';
import 'package:vocadb_app/src/features/home/presentation/home_screen/highlighted_section.dart';
import 'package:vocadb_app/src/features/home/presentation/home_screen/home_content_list.dart';
import 'package:vocadb_app/src/features/home/presentation/home_screen/random_albums_section.dart';
import 'package:vocadb_app/src/features/home/presentation/home_screen/recent_albums_section.dart';
import 'package:vocadb_app/src/features/home/presentation/home_screen/recent_events_section.dart';
import 'package:vocadb_app/src/features/home/presentation/home_screen/shortcut_menu_button.dart';
import 'package:vocadb_app/src/routing/app_route_context.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlobalAppBar(
        title: AppTitle(),
        displayHome: false,
      ),
      body: HomeContentList(
        children: [
          const SpaceDivider.small(),
          Center(
            child: Wrap(
               crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.center,
                runSpacing: 24.0,
                children: <Widget>[
                  ShortcutMenuButton(
                    title: 'Songs', 
                    iconData: Icons.music_note, 
                    onPressed: () {
                      context.goSongSearchScreen();
                    },
                  ),
                  ShortcutMenuButton(
                    title: 'Artists', 
                    iconData: Icons.person, 
                    onPressed: () {
                      context.goArtistSearchScreen();
                    },
                  ),
                  ShortcutMenuButton(
                    title: 'Albums', 
                    iconData: Icons.album, 
                    onPressed: () {
                      context.goAlbumSearchScreen();
                    },
                  ),
                  ShortcutMenuButton(
                    title: 'Tags', 
                    iconData: Icons.label, 
                    onPressed: () {},
                  ),
                  ShortcutMenuButton(
                    title: 'Events', 
                    iconData: Icons.event, 
                    onPressed: () {
                      context.goReleaseEventList();
                    },
                  )
                ],
            ),
          ),
          HighlightedSection(),
          RecentAlbumSection(),
          RandomAlbumSection(),
          RecentEventsSection(),
          gapH24,
        ],
      ),
    );
  }
}
