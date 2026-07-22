import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class FileService {
  final Dio _dio = Dio();

  /// Download media ke direktori download publik.
  /// Return path file yang sudah di-download.
  Future<String> downloadToDevice(String url, {String? fileName}) async {
    final dir = await getApplicationDocumentsDirectory();
    final downloadDir = Directory('${dir.path}/Downloads');
    if (!await downloadDir.exists()) {
      await downloadDir.create(recursive: true);
    }

    final ext = _extractExtension(url);
    final name = fileName ?? 'sosmed_download_${DateTime.now().millisecondsSinceEpoch}';
    final path = '${downloadDir.path}/$name$ext';

    await _dio.download(url, path);
    return path;
  }

  String _extractExtension(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return '.mp4';
    final path = uri.path;
    final ext = path.split('.').last;
    if (ext.length > 5 || ext.contains('/')) return '.mp4';
    return '.$ext';
  }
}
