import 'package:get/get.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/pages.dart';
import 'package:vocadb_app/services.dart';
import 'package:vocadb_app/src/repositories/auth_repository.dart';

class LoginPageController extends GetxController {
  final processing = false.obs;

  final message = ''.obs;

  final AuthRepository authRepository;

  final AuthService authService;

  final username = ''.obs;
  final password = ''.obs;

  LoginPageController({required this.authRepository, required this.authService});

  void login() {
    if (username.string.isEmpty || password.string.isEmpty) {
      message('invalidUsernameOrPassword');
      return;
    }
    
    processing(true);
    message('');
    print('===== LOGIN ATTEMPT START =====');
    print('Username: ${username.string}');
    print('Password: ${password.string.replaceAll(RegExp(r'.'), '*')}');
    
    authRepository
        .login(username: username.string, password: password.string)
        .then((cookie) {
          print('===== LOGIN RESPONSE =====');
          print('Login returned cookie: $cookie');
          print('Now calling getCurrent()...');
          return authService.getCurrent();
        })
        .then((user) {
          print('===== GETCURRENT RESPONSE =====');
          print('User: $user');
          postLoginSuccess(user);
        })
        .catchError((err) {
          print('===== LOGIN ERROR =====');
          print('Error type: ${err.runtimeType}');
          print('Error: $err');
          print('Stacktrace: ${StackTrace.current}');
          error(err);
        });
  }

  void postLoginSuccess(user) {
    processing(false);
    print('login success $user');
    
    // If user is null, login failed
    if (user == null || user.id == null) {
      print('Login failed: user is null or has no id');
      message('invalidUsernameOrPassword');
      return;
    }
    
    authService.currentUser(user);
    Get.off(MainPage());
  }

  void onUsernameChanged(value) {
    print(value);
    username(value);
  }

  void onPasswordChanged(value) => password(value);

  void error(err) {
    processing(false);
    print('Error occurs...$err');
    message('invalidUsernameOrPassword');
  }
}
