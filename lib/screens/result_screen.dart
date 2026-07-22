import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../config/theme.dart';
import '../services/download_service.dart';
import '../services/file_service.dart';
import '../widgets/index.dart';

class ResultScreen extends StatefulWidget {
  final DownloadResult result;

  const ResultScreen({super.key, required this.result});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  final FileService _fileService = FileService();
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _previewReady = false;
  bool _downloading = false;
  String? _downloadMsg;
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutQuad);
    _animCtrl.forward();
    _initPreview();
  }

  void _initPreview() {
    final video = widget.result.media.where((m) =>
        m.type == 'video' ||
        m.format?.contains('mp4') == true ||
        m.format?.contains('webm') == true).firstOrNull;

    if (video != null && video.url.isNotEmpty) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(video.url));
      _videoController!.initialize().then((_) {
        if (!mounted) return;
        final aspect = _videoController!.value.aspectRatio;
        _chewieController = ChewieController(
          videoPlayerController: _videoController!,
          autoPlay: false,
          looping: false,
          aspectRatio: aspect > 0 ? aspect : 16 / 9,
          placeholder: Container(
            color: Colors.black,
            child: const Center(child: CircularProgressIndicator(color: AppTheme.primaryLight)),
          ),
          materialProgressColors: ChewieProgressColors(
            playedColor: AppTheme.primary,
            handleColor: AppTheme.primary,
            backgroundColor: Colors.white24,
          ),
        );
        setState(() => _previewReady = true);
      }).catchError((_) {
        setState(() => _previewReady = false);
      });
    }
  }

  Future<void> _downloadMedia(MediaItem media) async {
    setState(() {
      _downloading = true;
      _downloadMsg = null;
    });

    try {
      final path = await _fileService.downloadToDevice(
        media.url,
        fileName: 'sosmed_${DateTime.now().millisecondsSinceEpoch}',
      );
      if (!mounted) return;
      setState(() {
        _downloading = false;
        _downloadMsg = 'Tersimpan di: $path';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _downloading = false;
        _downloadMsg = 'Gagal download: $e';
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    final firstVideo = result.media.where((m) =>
        m.type == 'video' ||
        m.format?.contains('mp4') == true ||
        m.format?.contains('webm') == true).firstOrNull;

    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.glassWhite,
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          title: const Text('Hasil Download',
              style: TextStyle(fontWeight: FontWeight.w600)),
          centerTitle: true,
        ),
        body: FadeTransition(
          opacity: _fadeAnim,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Preview ──
                if (firstVideo != null && _previewReady && _chewieController != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.black,
                      ),
                      child: AspectRatio(
                        aspectRatio: _chewieController!.aspectRatio ?? 16 / 9,
                        child: Chewie(controller: _chewieController!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ] else if (firstVideo != null && !_previewReady) ...[
                  _buildThumbnail(result.thumbnail),
                  const SizedBox(height: 16),
                ],

                if (firstVideo == null && result.thumbnail != null && result.thumbnail!.isNotEmpty) ...[
                  _buildThumbnail(result.thumbnail),
                  const SizedBox(height: 16),
                ],

                // ── Title ──
                if (result.title.isNotEmpty) ...[
                  Text(result.title,
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),
                ],

                // ── Media Items ──
                ...result.media.asMap().entries.map((entry) {
                  final i = entry.key;
                  final media = entry.value;
                  final isVideo = media.type == 'video' ||
                      media.format?.contains('mp4') == true;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GlassCard(
                      dark: true,
                      radius: 16,
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  gradient: AppTheme.primaryGradient,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Icon(
                                  isVideo ? Icons.videocam : Icons.image,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${isVideo ? 'Video' : 'Gambar'} ${i + 1}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(fontSize: 14),
                                    ),
                                    if (media.quality != null)
                                      Text('Kualitas: ${media.quality}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium),
                                    if (media.format != null)
                                      Text('Format: ${media.format}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _downloading
                                  ? null
                                  : () => _downloadMedia(media),
                              icon: _downloading
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white))
                                  : const Icon(Icons.download, size: 20),
                              label: Text(_downloading
                                  ? 'Mengunduh...'
                                  : 'Unduh ke Device'),
                            ),
                          ),
                          if (_downloadMsg != null) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: _downloadMsg!.contains('Gagal')
                                    ? AppTheme.error.withValues(alpha: 0.15)
                                    : AppTheme.success.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _downloadMsg!.contains('Gagal')
                                        ? Icons.error_outline
                                        : Icons.check_circle_outline,
                                    size: 14,
                                    color: _downloadMsg!.contains('Gagal')
                                        ? AppTheme.error
                                        : AppTheme.success,
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      _downloadMsg!,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _downloadMsg!.contains('Gagal')
                                            ? AppTheme.error
                                            : AppTheme.success,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }),

                // ── Copy URL ──
                if (result.media.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: result.media.first.url));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('URL media tersalin!'),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      },
                      icon: const Icon(Icons.copy, size: 20),
                      label: const Text('Salin URL Media'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryLight,
                        side: BorderSide(
                            color: AppTheme.primaryLight.withValues(alpha: 0.4)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail(String? url) {
    if (url != null && url.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          url,
          height: 220,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _placeholder(),
        ),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: AppTheme.glassCardDark(radius: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.play_circle_outline,
              size: 64, color: Colors.white.withValues(alpha: 0.15)),
          const SizedBox(height: 8),
          Text('Preview tidak tersedia',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.3))),
        ],
      ),
    );
  }
}
