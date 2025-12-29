import 'package:get/get.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/repositories.dart';
import 'package:vocadb_app/services.dart';

class RankingController extends GetxController {
  final initialLoading = true.obs;

  /// List of top rated songs in 24 hours.
  final daily = <SongModel>[].obs;

  /// List of top rated songs in 7 days.
  final weekly = <SongModel>[].obs;

  /// List of top rated songs in 30 days.
  final monthly = <SongModel>[].obs;

  /// List of top rated songs all times.
  final overall = <SongModel>[].obs;

  /// Filter parameter.
  final filterBy = 'CreateDate'.obs;

  /// Filter parameter.
  final vocalist = 'Nothing'.obs;

  final SongRepository songRepository;
  
  bool _initialDataFetched = false;

  RankingController({required this.songRepository});

  @override
  void onInit() {
    // Defer initial fetch to avoid blocking tab switch - only fetch once
    Future.delayed(Duration.zero, () {
      if (!_initialDataFetched) {
        _initialDataFetched = true;
        fetchApi();
      }
    });
    
    // Debounce filter changes to avoid excessive API calls
    debounce(filterBy, (_) => fetchApi(), time: Duration(milliseconds: 500));
    debounce(vocalist, (_) => fetchApi(), time: Duration(milliseconds: 500));
    super.onInit();
  }

  void fetchApi() {
    String lang = SharedPreferenceService.lang;
    songRepository
        .getTopRatedDaily(
            filterBy: filterBy.value, vocalist: vocalist.value, lang: lang)
        .then(daily.call)
        .catchError((err) {
          print('Error loading daily songs: $err');
          daily.value = [];
          return <SongModel>[];
        });
    songRepository
        .getTopRatedWeekly(
            filterBy: filterBy.value, vocalist: vocalist.value, lang: lang)
        .then(weekly.call)
        .catchError((err) {
          print('Error loading weekly songs: $err');
          weekly.value = [];
          return <SongModel>[];
        });
    songRepository
        .getTopRatedMonthly(
            filterBy: filterBy.value, vocalist: vocalist.value, lang: lang)
        .then(monthly.call)
        .catchError((err) {
          print('Error loading monthly songs: $err');
          monthly.value = [];
          return <SongModel>[];
        });
    songRepository
        .getTopRated(
            filterBy: filterBy.value, vocalist: vocalist.value, lang: lang)
        .then(overall.call)
        .catchError((err) {
          print('Error loading overall songs: $err');
          overall.value = [];
          return <SongModel>[];
        });
  }
}
