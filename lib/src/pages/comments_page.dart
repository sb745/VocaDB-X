import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vocadb_app/controllers.dart';
import 'package:vocadb_app/models.dart';
import 'package:vocadb_app/repositories.dart';
import 'package:vocadb_app/services.dart';
import 'package:vocadb_app/utils.dart';
import 'package:vocadb_app/widgets.dart';

class CommentsPage extends StatelessWidget {
  const CommentsPage({super.key});

  CommentsController initController() {
    final httpService = Get.find<HttpService>();
    return CommentsController(
      songRepository: SongRepository(httpService: httpService),
      albumRepository: AlbumRepository(httpService: httpService),
      artistRepository: ArtistRepository(httpService: httpService),
    );
  }

  @override
  Widget build(BuildContext context) {
    final CommentsController controller = initController();

    return PageBuilder<CommentsController>(
      controller: controller,
      builder: (c) => CommentsPageView(controller: c),
    );
  }
}

class CommentsPageView extends StatelessWidget {
  final CommentsController controller;

  const CommentsPageView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${controller.entityName} - ${'comments'.tr}'),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.displayedComments.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.allComments.isEmpty) {
          return Center(
            child: Text('noComments'.tr),
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            if (scrollInfo.metrics.pixels ==
                scrollInfo.metrics.maxScrollExtent) {
              controller.onReachEndScroll();
            }
            return false;
          },
          child: ListView.builder(
            itemCount: controller.displayedComments.length +
                (controller.hasMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              // Show loading indicator at the end if more comments to load
              if (index == controller.displayedComments.length) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final comment = controller.displayedComments[index];
              return _buildCommentTile(comment);
            },
          ),
        );
      }),
    );
  }

  Widget _buildCommentTile(CommentModel comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: LimitedBox(
        maxWidth: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User avatar
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(comment.authorImageUrl),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {},
                ),
              ),
            ),
            SizedBox(width: 12),
            // Comment content
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          comment.authorName ?? 'Unknown',
                          style: TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        comment.createdFormatted ?? '',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  _buildMessageWithLinks(comment.message ?? ''),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageWithLinks(String message) {
    final urlRegex = RegExp(
      r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
      caseSensitive: false,
    );

    final matches = urlRegex.allMatches(message);
    if (matches.isEmpty) {
      return Text(
        message,
        style: TextStyle(fontSize: 13),
      );
    }

    List<TextSpan> spans = [];
    int lastIndex = 0;

    for (final match in matches) {
      // Add text before the URL
      if (match.start > lastIndex) {
        spans.add(TextSpan(text: message.substring(lastIndex, match.start)));
      }

      // Add the clickable URL
      final url = match.group(0)!;
      spans.add(TextSpan(
        text: url,
        style: TextStyle(
          fontSize: 13,
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () => launch(url),
      ));

      lastIndex = match.end;
    }

    // Add remaining text
    if (lastIndex < message.length) {
      spans.add(TextSpan(text: message.substring(lastIndex)));
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 13, color: Colors.black),
        children: spans,
      ),
    );
  }
}
