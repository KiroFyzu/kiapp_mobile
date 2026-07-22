import '../config/api_config.dart';
import 'api_client.dart';

class DownloadResult {
  final String title;
  final String? thumbnail;
  final String? description;
  final List<MediaItem> media;
  final int? downloadsRemaining;

  DownloadResult({
    required this.title,
    this.thumbnail,
    this.description,
    required this.media,
    this.downloadsRemaining,
  });

  factory DownloadResult.fromJson(Map<String, dynamic> json) {
    final mediaList = (json['media'] as List<dynamic>?)
            ?.map((e) => MediaItem.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    final quota = json['quota'] as Map<String, dynamic>?;
    return DownloadResult(
      title: json['title'] as String? ?? '',
      thumbnail: json['thumbnail'] as String?,
      description: json['description'] as String?,
      media: mediaList,
      downloadsRemaining: quota?['downloadsRemaining'] as int?,
    );
  }
}

class MediaItem {
  final String url;
  final String? quality;
  final String? type;
  final String? format;
  final int? width;
  final int? height;

  MediaItem({
    required this.url,
    this.quality,
    this.type,
    this.format,
    this.width,
    this.height,
  });

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(
      url: json['url'] as String,
      quality: json['quality'] as String?,
      type: json['type'] as String?,
      format: json['format'] as String?,
      width: json['width'] as int?,
      height: json['height'] as int?,
    );
  }
}

class DownloadService {
  final ApiClient _client;

  DownloadService(this._client);

  Future<(List<String>, int?)> getPlatforms() async {
    final resp = await _client.get(ApiConfig.platforms);
    final data = resp['data'] as List<dynamic>;
    final quota = resp['quota'] as Map<String, dynamic>?;
    final remaining = quota?['downloadsRemaining'] as int?;
    return (data.map((e) => e as String).toList(), remaining);
  }

  Future<DownloadResult> download(String url, {bool saveToHistory = true}) async {
    final resp = await _client.post(ApiConfig.download, body: {
      'url': url,
      'saveToHistory': saveToHistory,
    });
    return DownloadResult.fromJson(resp['data'] as Map<String, dynamic>);
  }
}
