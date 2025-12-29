import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vocadb_app/constants.dart';
import 'package:vocadb_app/controllers.dart';
import 'package:vocadb_app/pages.dart';
import 'package:vocadb_app/routes.dart';

/// First page with tab bottom navigation
class MainPage extends GetView<MainPageController> {
  const MainPage({super.key});

  void _onTapEntrySearch() {
    Get.toNamed(Routes.ENTRIES);
  }

  // Lazy-load page builders - only create pages when tab is accessed
  Widget _buildPageByIndex(int index) {
    switch (index) {
      case 0:
        return HomePage();
      case 1:
        return RankingPage();
      case 2:
        return MenuPage();
      default:
        return HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // If on Ranking (1) or Menu (2) tab, go back to Home (0)
          int currentIndex = controller.tabIndex.toInt();
          if (currentIndex != 0) {
            controller.onBottomNavTap(0);
          } else {
            // If already on Home tab, allow app to exit
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appName),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search), onPressed: _onTapEntrySearch),
            Obx(() => (controller.tabIndex.toInt() != 1)
                ? Container()
                : IconButton(
                    icon: Icon(Icons.tune),
                    onPressed: () => Get.to(RankingFilterPage())))
          ],
        ),
        body: Obx(() => IndexedStack(
              index: controller.tabIndex.toInt(),
              children: [
                _buildPageByIndex(0),
                _buildPageByIndex(1),
                _buildPageByIndex(2),
              ],
            )),
        bottomNavigationBar: Obx(() => BottomNavigationBar(
                currentIndex: controller.tabIndex.toInt(),
                onTap: controller.onBottomNavTap,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: 'home'.tr),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.trending_up), label: 'ranking'.tr),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.menu), label: 'menu'.tr),
                ])),
      ),
    );
  }
}
