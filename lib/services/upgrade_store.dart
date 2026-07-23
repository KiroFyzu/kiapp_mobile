import 'dart:convert';
import 'package:upgrader/upgrader.dart';
import 'package:version/version.dart';

class GitHubReleasesStore extends UpgraderStore {
  final String owner;
  final String repo;

  GitHubReleasesStore({required this.owner, required this.repo});

  @override
  Future<UpgraderVersionInfo> getVersionInfo({
    required UpgraderState state,
    required Version installedVersion,
    required String? country,
    required String? language,
  }) async {
    // Ambil semua releases (termasuk draft) via API
    final uri = Uri.parse(
      'https://api.github.com/repos/$owner/$repo/releases',
    );
    final response = await state.client.get(
      uri,
      headers: {
        ...?state.clientHeaders,
        'Accept': 'application/vnd.github.v3+json',
        'User-Agent': '$owner/$repo',
      },
    );

    if (response.statusCode != 200) {
      return UpgraderVersionInfo(installedVersion: installedVersion);
    }

    final releases = jsonDecode(response.body) as List;

    if (releases.isEmpty) {
      return UpgraderVersionInfo(installedVersion: installedVersion);
    }

    // Cari release dengan tag tertinggi
    String bestTag = '';
    Version? bestVersion;
    String? bestUrl;
    String? bestNotes;

    for (final r in releases) {
      final tagName = r['tag_name'] as String;
      final versionStr = tagName.replaceFirst(RegExp(r'^v'), '');
      final cleanVersion = versionStr.split('+').first;

      try {
        final v = Version.parse(cleanVersion);
        if (bestVersion == null || v > bestVersion) {
          bestVersion = v;
          bestTag = tagName;
          bestUrl = r['html_url'] as String;
          bestNotes = r['body'] as String?;
        }
      } catch (_) {
        // skip kalo versi ga valid
      }
    }

    if (bestVersion == null) {
      return UpgraderVersionInfo(installedVersion: installedVersion);
    }

    // Cari asset APK di release terbaik
    String? apkUrl;
    final bestRelease = releases.firstWhere(
      (r) => r['tag_name'] == bestTag,
      orElse: () => null,
    );
    if (bestRelease != null) {
      final assets = bestRelease['assets'] as List? ?? [];
      // Cari APK arm64-v8a (paling umum), fallback ke APK pertama
      for (final asset in assets) {
        final name = asset['name'] as String? ?? '';
        if (name.contains('arm64-v8a') && name.endsWith('.apk')) {
          apkUrl = asset['browser_download_url'] as String?;
          break;
        }
      }
      if (apkUrl == null) {
        // Fallback ke APK pertama
        for (final asset in assets) {
          final name = asset['name'] as String? ?? '';
          if (name.endsWith('.apk') || name.endsWith('.aab')) {
            apkUrl = asset['browser_download_url'] as String?;
            break;
          }
        }
      }
    }

    return UpgraderVersionInfo(
      installedVersion: installedVersion,
      appStoreVersion: bestVersion,
      appStoreListingURL: apkUrl ?? bestUrl,
      releaseNotes: bestNotes,
    );
  }
}
