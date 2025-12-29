import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vocadb_app/bindings.dart';
import 'package:vocadb_app/config.dart';
import 'package:vocadb_app/pages.dart';
import 'package:vocadb_app/services.dart';
import 'package:vocadb_app/routes.dart';
import 'package:vocadb_app/themes.dart';
import 'package:vocadb_app/utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  
  // Initialize theme synchronously before running the app
  final prefService = Get.find<SharedPreferenceService>();
  Themes.changeTheme(prefService.theme.string);
  Get.changeTheme(Themes.getThemeByName(prefService.theme.string));
  
  runApp(VocaDBApp());
}

Future<void> initServices() async {
  print('starting services ...');
  final appDirectory = AppDirectory();
  final dio = Dio();
  final httpService = HttpService(dio: dio, appDirectory: appDirectory);

  await Get.putAsync(() => appDirectory.init());
  await Get.putAsync(() => httpService.init());
  await Get.putAsync(() =>
      AuthService(httpService: httpService, appDirectory: appDirectory)
          .checkCurrentUser());

  await GetStorage.init(SharedPreferenceService.container);
  Get.put(
      SharedPreferenceService(
          box: GetStorage(SharedPreferenceService.container))
        ..init(),
      permanent: true);

  print('All services started...');
}

class VocaDBApp extends StatefulWidget {
  const VocaDBApp({super.key});

  @override
  State<VocaDBApp> createState() => _VocaDBAppState();
}

class _VocaDBAppState extends State<VocaDBApp> {
  @override
  void initState() {
    super.initState();
    _setupThemeListener();
  }

  void _setupThemeListener() {
    final prefService = Get.find<SharedPreferenceService>();
    
    // Listen to theme preference changes and trigger rebuilds
    ever(prefService.theme, (theme) {
      setState(() {
        // Rebuild the widget tree when theme changes
        if (theme == 'system') {
          final systemBrightness = MediaQuery.platformBrightnessOf(context);
          Get.changeTheme(Themes.getSystemAwareTheme(systemBrightness));
        } else if (theme == 'light') {
          Get.changeTheme(Themes.light);
        } else if (theme == 'dark') {
          Get.changeTheme(Themes.dark);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        // Make the entire build reactive to theme changes
        final prefService = Get.find<SharedPreferenceService>();
        prefService.theme.string; // Subscribe to updates
        
        return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            translations: AppTranslation(),
            locale: Get.locale,
            fallbackLocale: AppTranslation.fallbackLocale,
            theme: Themes.light,
            darkTheme: Themes.dark,
            themeMode: _getThemeMode(),
            defaultTransition: Transition.fade,
            initialBinding: MainPageBinding(),
            initialRoute: Routes.INITIAL,
            home: MainPage(),
            getPages: AppPages.pages);
      },
    );
  }

  ThemeMode _getThemeMode() {
    final prefService = Get.find<SharedPreferenceService>();
    final themePref = prefService.theme.string;
    
    if (themePref == 'system') {
      return ThemeMode.system;
    } else if (themePref == 'dark') {
      return ThemeMode.dark;
    } else {
      return ThemeMode.light;
    }
  }
}
