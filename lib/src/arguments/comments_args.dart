class CommentsArgs {
  final String entityType;  // 'song', 'album', etc.
  final int entityId;
  final String entityName;

  CommentsArgs({
    required this.entityType,
    required this.entityId,
    required this.entityName,
  });
}
