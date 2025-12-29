import 'package:dio/dio.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/services.dart';

class AuthRepository {
  final HttpService httpService;

  const AuthRepository({required this.httpService});

  Future<UserCookie> login({
    required String username,
    required String password,
  }) async {
    return await httpService.login(username, password);
  }

  Future<UserModel?> getCurrent() async {
    try {
      UserModel us = await httpService.get('/api/users/current',
          {'fields': 'MainPicture'}).then((item) => UserModel.fromJson(item));

      return us;
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) {
        print('current user not found');
        return null;
      }

      rethrow;
    }
  }
}
