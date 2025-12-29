import 'package:get/get.dart';

class MainPageController extends GetxController {
  var tabIndex = 0.obs;
  dynamic onBottomNavTap(index) => tabIndex.value = index;
}
