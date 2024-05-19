// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vocadb_app/src/features/api/api_client.dart';
import 'package:vocadb_app/src/features/api/data/api_query_result.dart';
import 'package:vocadb_app/src/features/tags/data/tag_repository.dart';
import 'package:vocadb_app/src/features/tags/domain/tag.dart';
import 'package:vocadb_app/src/features/tags/domain/tags_list_params.dart';

class TagApiRepository implements TagRepository {
  TagApiRepository({
    required this.client,
  });

  final ApiClient client;

  @override
  Future<Tag> fetchTagID(int id, {String lang = 'Default'}) async {
    final params = {
      'fields':
          'AdditionalNames,AliasedTo,Description,MainPicture,Names,Parent,RelatedTags,TranslatedDescription,WebLinks',
      'lang': lang,
    };

    final response = await client.get('/api/tags/$id', params: params);

    return Tag.fromJson(response);
  }

  @override
  Future<List<Tag>> fetchTagsList({TagsListParams params = const TagsListParams()}) async {

    final responseBody = await client.get('/api/tags', params: params.toJson());

    final queryResult = ApiQueryResult.fromMap(responseBody);

    return Tag.fromJsonToList(queryResult.items).toList();
  }
}

final tagApiRepositoryProvider = Provider.autoDispose<TagApiRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return TagApiRepository(client: apiClient);
});
