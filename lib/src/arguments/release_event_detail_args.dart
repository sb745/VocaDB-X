import 'package:vocadb_app/models.dart';

class ReleaseEventDetailArgs {
  /// An id of release event.
  final int id;

  /// Optional release event data for pre-display before fetch.
  final ReleaseEventModel? event;

  const ReleaseEventDetailArgs({required this.id, this.event});
}
