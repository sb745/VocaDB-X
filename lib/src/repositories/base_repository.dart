import 'package:vocadb_app/services.dart';

class RestApiRepository {
  final HttpService httpService;

  RestApiRepository({required this.httpService});

  Future<dynamic> getList(String endpoint, Map<String, String> params) async {
    try {
      final response = await httpService.get(endpoint, params);
      
      // Handle null response
      if (response == null) {
        return [];
      }
      
      // If it's already iterable, return it
      if (response is Iterable) {
        return response;
      }
      
      // If it's a map with 'items' key, return that
      if (response is Map && response.containsKey('items')) {
        final items = response['items'];
        if (items == null) {
          return [];
        }
        return items is Iterable ? items : [items];
      }
      
      // If it's a map, return it as a single-item list
      if (response is Map) {
        return [response];
      }
      
      return response as Iterable;
    } catch (e) {
      print('Error in getList: $e');
      return [];
    }
  }

  Future<T> getObject<T>(String endpoint, Map<String, String> params) async {
    try {
      final response = await httpService.get(endpoint, params);
      
      // Handle null response
      if (response == null) {
        throw Exception('Null response from API');
      }
      
      return response as T;
    } catch (e) {
      print('Error in getObject: $e');
      rethrow;
    }
  }
}
