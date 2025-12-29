import 'package:vocadb_app/models.dart';

class ReleaseDateModel extends BaseModel {
  int? day;
  String? formatted;
  int? month;
  int? year;

  ReleaseDateModel.fromJson(Map<String, dynamic> json)
      : day = json['day'],
        month = json['month'],
        year = json['year'],
        formatted = json['formatted'] ?? _generateFormattedDate(json['day'], json['month'], json['year']);

  static String? _generateFormattedDate(int? day, int? month, int? year) {
    if (year == null) return null;
    List<String> parts = [];
    
    if (day != null) parts.add(day.toString());
    if (month != null) parts.add(month.toString());
    parts.add(year.toString());
    
    return parts.join('/');
  }
}
