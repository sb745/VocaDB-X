/// An utility class for manipulate url value
class UrlUtils {
  /// Update url value from http to https
  static String? toHttps(String url) {
    return url.replaceFirst('http:', 'https:');
  }
}
