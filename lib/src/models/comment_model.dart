import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/utils.dart';

class CommentModel {
  UserModel? author;
  String? authorName;
  String? created;
  int? id;
  String? message;

  CommentModel({
    this.author,
    this.authorName,
    this.created,
    this.id,
    this.message,
  });

  CommentModel.fromJson(Map<String, dynamic> json)
      : author = json.containsKey('author') && json['author'] != null
            ? UserModel.fromJson(json['author'])
            : null,
        authorName = json['authorName'] ?? json['author']?['name'],
        created = json['created'],
        id = json['id'],
        message = json['message'];

  static List<CommentModel> jsonToList(List items) {
    return items.map((i) => CommentModel.fromJson(i)).toList();
  }

  String? get createdFormatted {
    if (created == null) return null;
    try {
      final dateTime = DateTime.parse(created!);
      return DateTimeUtils.toSimpleFormat(dateTime);
    } catch (e) {
      return null;
    }
  }

  String get authorImageUrl {
    if (author?.imageUrl != null) {
      return author!.imageUrl!;
    }
    return 'https://vocadb.net/Content/unknown.png';
  }
}
