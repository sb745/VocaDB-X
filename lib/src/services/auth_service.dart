import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/services.dart';
import 'package:vocadb_app/utils.dart';

class AuthService extends GetxService {
  final HttpService httpService;

  final AppDirectory appDirectory;

  final currentUser = UserModel().obs;

  AuthService({required this.httpService, required this.appDirectory});

  Future<UserCookie> login({
    required String username,
    required String password,
  }) async {
    return await httpService.login(username, password);
  }

  Future<AuthService> checkCurrentUser() async {
    print('check current user');
    getCurrent().then(currentUser.call).catchError((e) {
      print('Error checking current user: $e');
      currentUser.value = UserModel();
      return UserModel();
    });
    return this;
  }

  Future<UserModel?> getCurrent() async {
    try {
      // Use direct httpService.dio request to bypass cache
      final url = Uri.https('vocadb.net', '/api/users/current', {'fields': 'MainPicture'}).toString();
      final response = await httpService.dio.get(url);
      
      // If response is not a Map, it's not valid user data
      if (response.data is! Map) {
        print('current user response is not a map: ${response.data}');
        return null;
      }
      
      // Cast Map to Map<String, dynamic>
      final Map<String, dynamic> userData = Map<String, dynamic>.from(response.data as Map);
      UserModel us = UserModel.fromJson(userData);
      print('current user : $us');
      return us;
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) {
        print('current user not found');
        return null;
      }

      print('Unknown error from get current user $e');

      return null;
    }
  }

  Future<void> logout() async {
    appDirectory.clearCookies();
    currentUser(UserModel());
  }
}
