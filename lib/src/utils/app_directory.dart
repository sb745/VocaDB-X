import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class AppDirectory extends GetxService {
  late Directory applicationDocument;

  late Directory cookiesDirectory;

  AppDirectory();

  Future<AppDirectory> init() async {
    applicationDocument = await getApplicationDocumentsDirectory();
    cookiesDirectory = Directory('${applicationDocument.path}/.cookies');
    print('app cookies dir : ${applicationDocument.path}/.cookies');
    return this;
  }

  void clearCookies() {
    if (cookiesDirectory.existsSync()) {
      print('clear cookies');
      cookiesDirectory.deleteSync(recursive: true);

      if (cookiesDirectory.existsSync()) {
        print('cookies not clear!!!!!');
      } else {
        print('cookies cleared!');
      }
    } else {
      print('cookies does not exists for clear');
    }
  }
}
