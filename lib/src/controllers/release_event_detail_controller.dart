import 'package:get/get.dart';
import 'package:vocadb_app/arguments.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/repositories.dart';
import 'package:vocadb_app/services.dart';

class ReleaseEventDetailController extends GetxController {
  final event = ReleaseEventModel().obs;

  final songs = <SongModel>[].obs;

  final albums = <AlbumModel>[].obs;

  final ReleaseEventRepository eventRepository;

  ReleaseEventDetailController({required this.eventRepository});

  @override
  void onInit() {
    initArgs();
    fetchApis();
    super.onInit();
  }

  void initArgs() {
    ReleaseEventDetailArgs args = Get.arguments;

    if (args.event != null) {
      event(args.event);
    } else {
      event(ReleaseEventModel(id: args.id));
    }
  }

  void fetchApis() {
    String lang = SharedPreferenceService.lang;
    int? eventId = event().id;
    if (eventId != null) {
      eventRepository.getById(eventId, lang: lang).then(event.call);
      eventRepository.getAlbums(eventId, lang: lang).then(albums.call);
      eventRepository.getPublishedSongs(eventId, lang: lang).then(songs.call);
    }
  }
}
