import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:streamshaala/core/utils/logger.dart';

/// Native platform implementation of YouTube player
/// Uses flutter_inappwebview for Android, iOS, and macOS
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
  InAppWebViewController? _webViewController;
  bool _isLoading = true;
  Timer? _progressTimer;
  bool _playerReady = false;

  /// HTTP Referer header to comply with YouTube's embed policy
  String get _refererHeader => 'https://com.streamshaala.streamshaala';

  /// Custom HTML page with YouTube IFrame API properly integrated
  String get _youtubePlayerHtml {
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="referrer" content="strict-origin-when-cross-origin">
  <style>
    body, html {
      margin: 0;
      padding: 0;
      width: 100%;
      height: 100%;
      background-color: #000;
      overflow: hidden;
    }
    #player {
      width: 100%;
      height: 100%;
    }
  </style>
</head>
<body>
  <div id="player"></div>
  <script>
    var player;

    // Load YouTube IFrame API
    var tag = document.createElement('script');
    tag.src = 'https://www.youtube.com/iframe_api';
    var firstScriptTag = document.getElementsByTagName('script')[0];
    firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

    // API Ready callback
    function onYouTubeIframeAPIReady() {
      console.log('[YouTube API] API Ready, creating player');
      player = new YT.Player('player', {
        videoId: '${widget.videoId}',
        width: '100%',
        height: '100%',
        playerVars: {
          'autoplay': ${widget.autoPlay ? '1' : '0'},
          'playsinline': 0,
          'controls': 1,
          'rel': 0,
          'modestbranding': 1,
          'enablejsapi': 1,
          'fs': 1
        },
        events: {
          'onReady': onPlayerReady,
          'onStateChange': onPlayerStateChange,
          'onError': onPlayerError
        }
      });
    }

    function onPlayerReady(event) {
      console.log('[YouTube API] Player ready');
      window.playerReady = true;
    }

    function onPlayerStateChange(event) {
      console.log('[YouTube API] State changed:', event.data);
    }

    function onPlayerError(event) {
      console.error('[YouTube API] Player error:', event.data);
    }

    // Expose methods for Flutter to call
    window.getCurrentTime = function() {
      try {
        if (player && player.getCurrentTime) {
          return player.getCurrentTime();
        }
        return 0;
      } catch (e) {
        console.error('[YouTube API] Error in getCurrentTime:', e);
        return 0;
      }
    };

    window.getDuration = function() {
      try {
        if (player && player.getDuration) {
          return player.getDuration();
        }
        return 0;
      } catch (e) {
        console.error('[YouTube API] Error in getDuration:', e);
        return 0;
      }
    };

    window.seekTo = function(seconds) {
      try {
        if (player && player.seekTo) {
          console.log('[YouTube API] seekTo called:', seconds);
          player.seekTo(seconds, true);
          return true;
        }
        return false;
      } catch (e) {
        console.error('[YouTube API] Error in seekTo:', e);
        return false;
      }
    };

    window.playVideo = function() {
      try {
        if (player && player.playVideo) {
          console.log('[YouTube API] playVideo called');
          player.playVideo();
          return true;
        }
        return false;
      } catch (e) {
        console.error('[YouTube API] Error in playVideo:', e);
        return false;
      }
    };
  </script>
</body>
</html>
    ''';
  }

  @override
  void initState() {
    super.initState();
    _startProgressTracking();
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  void _startProgressTracking() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      _progressTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
        if (!mounted || _webViewController == null) {
          timer.cancel();
          return;
        }

        try {
          final currentTime = await _getCurrentTimeFromWebView();
          final duration = await _getDurationFromWebView();

          if (currentTime > 0 && duration > 0) {
            final currentSeconds = currentTime.toInt();
            final totalSeconds = duration.toInt();

            // Report progress to parent
            widget.onProgressUpdate?.call(currentSeconds, totalSeconds);
          }
        } catch (e) {
          logger.warning('Progress tracking error: $e');
        }
      });
    });
  }

  Future<double> _getCurrentTimeFromWebView() async {
    if (_webViewController == null) return 0.0;

    try {
      final result = await _webViewController!.evaluateJavascript(
        source: 'window.getCurrentTime();',
      );

      if (result != null) {
        final time = result is num ? result.toDouble() : (double.tryParse(result.toString()) ?? 0.0);
        return time;
      }
      return 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  Future<double> _getDurationFromWebView() async {
    if (_webViewController == null) return 0.0;

    try {
      final result = await _webViewController!.evaluateJavascript(
        source: 'window.getDuration();',
      );

      if (result != null) {
        final duration = result is num ? result.toDouble() : (double.tryParse(result.toString()) ?? 0.0);
        return duration;
      }
      return 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InAppWebView(
          initialData: InAppWebViewInitialData(
            data: _youtubePlayerHtml,
            baseUrl: WebUri(_refererHeader),
            encoding: 'utf-8',
            mimeType: 'text/html',
          ),
          initialSettings: InAppWebViewSettings(
            mediaPlaybackRequiresUserGesture: false,
            allowsInlineMediaPlayback: true,
            transparentBackground: false,
            javaScriptEnabled: true,
            javaScriptCanOpenWindowsAutomatically: true,
            useHybridComposition: true,
            allowsBackForwardNavigationGestures: false,
            disableContextMenu: true,
          ),
          onWebViewCreated: (controller) {
            _webViewController = controller;
            logger.info('[Native YouTube Player] WebView created for video: ${widget.videoId}');
          },
          onLoadStart: (controller, url) {
            setState(() {
              _isLoading = true;
            });
          },
          onLoadStop: (controller, url) async {
            logger.info('[Native YouTube Player] WebView loaded');
            setState(() {
              _isLoading = false;
              _playerReady = true;
            });
          },
          onProgressChanged: (controller, progress) {
            if (progress == 100 && !_playerReady) {
              setState(() {
                _isLoading = false;
                _playerReady = true;
              });
            }
          },
          onConsoleMessage: (controller, consoleMessage) {
            logger.info('[WebView Console] ${consoleMessage.message}');
          },
          onReceivedError: (controller, request, error) {
            logger.error('[Native YouTube Player] WebView Error: ${error.description}');
          },
          onEnterFullscreen: (controller) {
            logger.info('[Native YouTube Player] Entered fullscreen mode');
            widget.onFullscreenChanged?.call(true);
          },
          onExitFullscreen: (controller) {
            logger.info('[Native YouTube Player] Exited fullscreen mode');
            widget.onFullscreenChanged?.call(false);
          },
        ),
        if (_isLoading)
          Container(
            color: Colors.black,
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}
