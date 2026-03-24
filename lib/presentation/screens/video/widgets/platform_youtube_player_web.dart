// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
// ignore: undefined_prefixed_name
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:crack_the_code/core/utils/logger.dart';

/// Web-specific implementation of YouTube player
/// Uses dart:html and HtmlElementView for direct iframe embedding
class PlatformYoutubePlayerImpl extends StatefulWidget {
  final String videoId;
  final bool autoPlay;
  final void Function(bool)? onFullscreenChanged;
  final bool useAspectRatio;
  final void Function(int currentSeconds, int totalSeconds)? onProgressUpdate;

  const PlatformYoutubePlayerImpl({
    super.key,
    required this.videoId,
    this.autoPlay = true,
    this.onFullscreenChanged,
    this.useAspectRatio = true,
    this.onProgressUpdate,
  });

  @override
  State<PlatformYoutubePlayerImpl> createState() => _PlatformYoutubePlayerImplState();
}

class _PlatformYoutubePlayerImplState extends State<PlatformYoutubePlayerImpl> {
  final String _viewType = 'youtube-player-';
  late final String _uniqueViewType;

  @override
  void initState() {
    super.initState();
    // Create unique view type for this instance
    _uniqueViewType = _viewType + widget.videoId + DateTime.now().millisecondsSinceEpoch.toString();
    _registerView();
  }

  void _registerView() {
    logger.info('[Web YouTube Player] Registering view for video: ${widget.videoId}');

    // Build YouTube embed URL with parameters
    final embedUrl = _buildYouTubeEmbedUrl();

    // Register the platform view
    // ignore: undefined_prefixed_name
    ui_web.platformViewRegistry.registerViewFactory(
      _uniqueViewType,
      (int viewId) {
        final iframe = html.IFrameElement()
          ..src = embedUrl
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%'
          ..allow = 'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share'
          ..allowFullscreen = true;

        logger.info('[Web YouTube Player] Created iframe with URL: $embedUrl');

        // Listen for fullscreen changes
        html.document.onFullscreenChange.listen((event) {
          final isFullscreen = html.document.fullscreenElement != null;
          logger.info('[Web YouTube Player] Fullscreen changed: $isFullscreen');
          widget.onFullscreenChanged?.call(isFullscreen);
        });

        return iframe;
      },
    );
  }

  String _buildYouTubeEmbedUrl() {
    // Build YouTube embed URL with appropriate parameters
    final params = <String, dynamic>{
      'autoplay': widget.autoPlay ? '1' : '0',
      'controls': '1',
      'rel': '0',
      'modestbranding': '1',
      'playsinline': '1',
      'enablejsapi': '1',
      'origin': html.window.location.origin,
    };

    final queryString = params.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');

    return 'https://www.youtube.com/embed/${widget.videoId}?$queryString';
  }

  @override
  Widget build(BuildContext context) {
    logger.info('[Web YouTube Player] Building HtmlElementView for ${widget.videoId}');

    return Stack(
      children: [
        // The YouTube iframe
        HtmlElementView(
          viewType: _uniqueViewType,
        ),
        // Loading indicator overlay (optional)
        // You can add this if you want a loading state
      ],
    );
  }

  @override
  void dispose() {
    logger.info('[Web YouTube Player] Disposing player for ${widget.videoId}');
    super.dispose();
  }
}
