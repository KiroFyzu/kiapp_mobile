import '../config/api_config.dart';
import 'api_client.dart';

class HistoryItem {
  final String id;
  final String url;
  final String platform;
  final String title;
  final String? thumbnail;
  final List<dynamic> media;
  final DateTime createdAt;

  HistoryItem({
    required this.id,
    required this.url,
    required this.platform,
    required this.title,
    this.thumbnail,
    required this.media,
    required this.createdAt,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'] as String,
      url: json['url'] as String,
      platform: json['platform'] as String,
      title: json['title'] as String? ?? '',
      thumbnail: json['thumbnail'] as String?,
      media: json['media'] as List<dynamic>? ?? [],
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

class HistoryService {
  final ApiClient _client;

  HistoryService(this._client);

  Future<List<HistoryItem>> getHistory({int limit = 50}) async {
    final resp = await _client.get('${ApiConfig.history}?limit=$limit');
    final data = resp['data'] as List<dynamic>;
    return data.map((e) => HistoryItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> deleteHistory(String id) async {
    await _client.delete('${ApiConfig.history}/$id');
  }

  Future<void> clearHistory() async {
    await _client.delete(ApiConfig.history);
  }
}
