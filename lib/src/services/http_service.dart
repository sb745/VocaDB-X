import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:dio_http_cache_lts/dio_http_cache_lts.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vocadb_app/constants.dart';
import 'package:vocadb_app/exceptions.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/utils.dart';

class _UserAgentInterceptor extends Interceptor {
  String userAgent = 'VocaDB X/unknown';

  _UserAgentInterceptor(this.userAgent);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['User-Agent'] = userAgent;
    super.onRequest(options, handler);
  }
}

class HttpService extends GetxService {
  late Dio _dio;
  final AppDirectory _appDirectory;

  // Public getter to access dio for uncached requests
  Dio get dio => _dio;

  HttpService({required Dio dio, required AppDirectory appDirectory})
      : _appDirectory = appDirectory {
    _dio = dio;
  }

  Future<HttpService> init() async {
    _dio = Dio();
    
    // Get app version and create User Agent string
    String userAgent = 'VocaDB X/unknown';
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      userAgent = 'VocaDB X/${packageInfo.version}';
    } catch (e) {
      print('Failed to get package info: $e');
    }
    
    // Add User Agent interceptor first (runs before cache and cookie managers)
    _dio.interceptors.add(_UserAgentInterceptor(userAgent));
    
    _dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: baseUrl)).interceptor);
    _dio.interceptors.add(CookieManager(
        PersistCookieJar(storage: FileStorage(_appDirectory.cookiesDirectory.path))));
    return this;
  }

  Future<dynamic> get(String endpoint, Map<String, String> params) async {
    params.removeWhere((key, value) => value.isEmpty);

    String url = Uri.https(authority, endpoint, params).toString();
    print('GET $url | $params');
    final response =
        await _dio.get(url, options: buildCacheOptions(Duration(minutes: 5)));

    if (response.statusCode == 200) {
      return response.data;
    }

    throw HttpRequestErrorException();
  }

  Future<dynamic> post(String endpoint, Map<String, String> params) async {
    params.removeWhere((key, value) => value.isEmpty);
    String url = Uri.https(authority, endpoint, params).toString();

    print('POST $url | $params');

    final response = await _dio.post(url);

    if (response.statusCode == 204 || response.statusCode == 200) {
      return 'done';
    } else {
      print(response.statusMessage);
    }

    throw HttpRequestErrorException();
  }

  Future<UserCookie> login(String username, String password) async {
    try {
      // Step 1: GET the login page to establish session and get CSRF token
      print('Step 1: Getting login page for CSRF token...');
      final loginPageUrl = Uri.https(authority, '/User/Login').toString();
      await _dio.get(loginPageUrl);
      print('GET response OK');
      
      // Step 2: POST login with credentials - don't follow redirects automatically
      print('Step 2: Posting login credentials...');
      
      final postResponse = await _dio.post(loginPageUrl, 
        data: 'UserName=$username&Password=$password',
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          validateStatus: (status) => status != null,
          followRedirects: false,
        ),
      );
      
      print('Login POST response status: ${postResponse.statusCode}');
      
      // Check for 302 redirect
      if (postResponse.statusCode == 302) {
        print('Got 302 redirect, following manually...');
        // Get the redirect location
        final location = postResponse.headers['location'];
        if (location != null) {
          print('Redirect location: $location');
          
          // Step 3: Follow the redirect manually so CookieManager captures the response properly
          var redirectUrl = location.first;
          
          // If the redirect URL is relative, make it absolute
          if (!redirectUrl.startsWith('http')) {
            redirectUrl = Uri.https(authority, redirectUrl).toString();
            print('Converted to absolute URL: $redirectUrl');
          }
          
          final finalResponse = await _dio.get(redirectUrl);
          print('Follow redirect response status: ${finalResponse.statusCode}');
        }
      }
      
      print('Login successful');
      return UserCookie(cookies: []);
    } catch (e) {
      print('Login exception: $e');
      throw LoginFailedException();
    }
  }
}
