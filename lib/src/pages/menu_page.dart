import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vocadb_app/pages.dart';
import 'package:vocadb_app/routes.dart';
import 'package:vocadb_app/services.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Get.find();
    return Scaffold(
      body: ListView(
        children: [
          Obx(
            () => Visibility(
                visible: authService.currentUser().id != null,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(authService
                            .currentUser()
                            .imageUrl ??
                        'https://vocadb.net/Content/unknown.png?s=150'),
                  ),
                  title: Text(authService.currentUser().name ?? 'Unknown'),
                )),
          ),
          Obx(() => Visibility(
                visible: authService.currentUser().id == null,
                child: ListTile(
                  leading: Icon(Icons.login),
                  title: Text('login'.tr),
                  onTap: () => Get.off(LoginPage()),
                ),
              )),
          Obx(() => Visibility(
                visible: authService.currentUser().id != null,
                child: ListTile(
                  leading: Icon(Icons.library_music),
                  title: Text('favoriteSongs'.tr),
                  onTap: () => Get.toNamed(Routes.FAVORITE_SONGS),
                ),
              )),
          Obx(() => Visibility(
                visible: authService.currentUser().id != null,
                child: ListTile(
                  leading: Icon(Icons.people),
                  title: Text('favoriteArtists'.tr),
                  onTap: () => Get.toNamed(Routes.FAVORITE_ARTISTS),
                ),
              )),
          Obx(() => Visibility(
                visible: authService.currentUser().id != null,
                child: ListTile(
                  leading: Icon(Icons.album),
                  title: Text('favoriteAlbums'.tr),
                  onTap: () => Get.toNamed(Routes.FAVORITE_ALBUMS),
                ),
              )),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('settings'.tr),
            onTap: () => Get.to(SettingsPage()),
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('contact'.tr),
            onTap: () => Get.to(ContactUsPage()),
          ),
          FutureBuilder(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              String versionName = 'Unknown';
              if (snapshot.connectionState == ConnectionState.done) {
                PackageInfo? packageInfo = snapshot.data;
                if (packageInfo != null) {
                  versionName = packageInfo.version;
                }
              }
              return ListTile(
                leading: Icon(Icons.info),
                title: Text("version".tr),
                subtitle: Text(versionName),
              );
            },
          ),
          Obx(() => Visibility(
                visible: authService.currentUser().id != null,
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('logout'.tr),
                  onTap: () {
                    authService.logout();
                    Get.off(LoginPage());
                  },
                ),
              )),
        ],
      ),
    );
  }
}
