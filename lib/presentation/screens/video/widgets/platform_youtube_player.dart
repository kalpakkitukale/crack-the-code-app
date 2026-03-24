import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/core/theme/app_theme.dart';
import 'package:streamshaala/presentation/providers/user/progress_provider.dart';
import 'package:streamshaala/presentation/providers/content/video_provider.dart';

/// Platform-aware YouTube player widget
/// Uses flutter_inappwebview for all platforms with proper HTTP Referer headers
/// This ensures YouTube embed policy compliance across Android, iOS, Web, and Desktop
class PlatformYoutubePlayer extends ConsumerStatefulWidget {
  final String videoId;
  final bool autoPlay;
  final void Function(bool)? onFullscreenChanged;
  final bool useAspectRatio;
  final void Function(double currentTime, double duration)? onProgress; // For learning path completion tracking

  const PlatformYoutubePlayer({
    super.key,
    required this.videoId,
    this.autoPlay = true,
    this.onFullscreenChanged,
    this.useAspectRatio = true,
    this.onProgress,
  });

  @override
  ConsumerState<PlatformYoutubePlayer> createState() => _PlatformYoutubePlayerState();
}

class _PlatformYoutubePlayerState extends ConsumerState<PlatformYoutubePlayer> {
  InAppWebViewController? _webViewController;
  bool _isLoading = true;
  Timer? _progressTimer;
  int _lastSavedPosition = 0;
  bool _playerReady = false;
  bool _showCustomEndScreen = false;  // PHASE 2: Custom end screen overlay
  double _currentPlaybackRate = 1.0;  // Current playback speed (0.5x to 2x)
  bool _showSpeedMenu = false;  // Show speed selection menu

  /// HTTP Referer header to comply with YouTube's embed policy
  /// Format: https://[bundle-identifier] as required by YouTube
  String get _refererHeader => 'https://com.streamshaala.streamshaala';

  /// Custom HTML page with YouTube IFrame API properly integrated
  String get _youtubePlayerHtml {
    // Always start with autoplay disabled to prevent flash before seeking
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
    // Global player object
    var player;
    var resumeRequested = false;

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
          'autoplay': 0,  // Disabled to prevent flash before seeking
          'playsinline': 0,  // Allow fullscreen (0 = allow fullscreen)
          'controls': 1,
          'rel': 0,  // Show related videos from same channel only
          'modestbranding': 1,
          'enablejsapi': 1,
          'fs': 1,  // Enable fullscreen button
          'iv_load_policy': 3,  // Hide video annotations
          'disablekb': 0,  // Enable keyboard controls
          'showinfo': 0,  // Hide video title (deprecated but still works)
          'origin': window.location.origin  // Set origin for better embed compliance
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

      // Video states: -1 (unstarted), 0 (ended), 1 (playing), 2 (paused), 3 (buffering), 5 (cued)
      if (event.data === 0) {
        // Video ended - PHASE 2: Stop player and notify Flutter to show custom end screen
        console.log('[YouTube API] Video ended - stopping player and showing custom end screen');

        // Stop the video to hide YouTube's end screen
        player.stopVideo();

        // Notify Flutter to show custom end screen overlay
        if (window.flutter_inappwebview) {
          window.flutter_inappwebview.callHandler('onVideoEnded');
        }
      }
    }

    function onPlayerError(event) {
      console.error('[YouTube API] Player error:', event.data);
    }

    // Expose methods for Flutter to call
    window.getCurrentTime = function() {
      try {
        if (player && player.getCurrentTime) {
          var time = player.getCurrentTime();
          console.log('[YouTube API] getCurrentTime called:', time);
          return time;
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
          var duration = player.getDuration();
          console.log('[YouTube API] getDuration called:', duration);
          return duration;
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
          resumeRequested = true;
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

    window.setPlaybackRate = function(rate) {
      try {
        if (player && player.setPlaybackRate) {
          console.log('[YouTube API] setPlaybackRate called:', rate);
          player.setPlaybackRate(rate);
          return true;
        }
        return false;
      } catch (e) {
        console.error('[YouTube API] Error in setPlaybackRate:', e);
        return false;
      }
    };

    window.getPlaybackRate = function() {
      try {
        if (player && player.getPlaybackRate) {
          var rate = player.getPlaybackRate();
          console.log('[YouTube API] getPlaybackRate called:', rate);
          return rate;
        }
        return 1.0;
      } catch (e) {
        console.error('[YouTube API] Error in getPlaybackRate:', e);
        return 1.0;
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
    // Start progress tracking for all platforms
    _startProgressTracking();
    _resumeVideoFromSavedPosition();
    _loadSavedPlaybackSpeed();
  }

  Future<void> _loadSavedPlaybackSpeed() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedSpeed = prefs.getDouble('playback_speed') ?? 1.0;
      setState(() {
        _currentPlaybackRate = savedSpeed;
      });

      // Apply saved speed after player is ready
      Future.delayed(const Duration(seconds: 3), () async {
        if (mounted && _webViewController != null) {
          await _setPlaybackRate(savedSpeed);
          logger.info('[Playback Speed] Loaded and applied saved speed: ${savedSpeed}x');
        }
      });
    } catch (e) {
      logger.warning('[Playback Speed] Error loading saved speed: $e');
    }
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    _saveProgressBeforeExit();
    super.dispose();
  }

  void _startProgressTracking() {
    // Wait a bit for the player to initialize
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

          logger.info('Progress tracking - Time: ${currentTime}s / ${duration}s');

          // Call onProgress callback for learning path tracking
          if (widget.onProgress != null && duration > 0) {
            widget.onProgress!(currentTime, duration);
          }

          if (currentTime > 0 && duration > 0) {
            final currentSeconds = currentTime.toInt();
            final totalSeconds = duration.toInt();

            // Only save if position changed significantly (more than 5 seconds)
            if ((currentSeconds - _lastSavedPosition).abs() > 5) {
              _lastSavedPosition = currentSeconds;

              // Get video details
              final videoState = ref.read(videoProvider);
              final video = videoState.getVideoById(widget.videoId);

              logger.info('Saving progress: ${currentSeconds}s / ${totalSeconds}s');

              await ref.read(progressProvider.notifier).updateProgress(
                videoId: widget.videoId,
                watchedSeconds: currentSeconds,
                totalSeconds: totalSeconds,
                title: video?.title,
                channelName: video?.channelName,
                thumbnailUrl: video?.thumbnailUrl,
              );
            }
          }
        } catch (e) {
          logger.warning('Progress tracking error: $e');
        }
      });
    });
  }

  Future<void> _saveProgressBeforeExit() async {
    if (_webViewController == null) return;

    try {
      final currentTime = await _getCurrentTimeFromWebView();
      final duration = await _getDurationFromWebView();

      if (currentTime > 0 && duration > 0) {
        final videoState = ref.read(videoProvider);
        final video = videoState.getVideoById(widget.videoId);

        logger.info('Saving progress on exit: ${currentTime.toInt()}s / ${duration.toInt()}s');

        await ref.read(progressProvider.notifier).updateProgress(
          videoId: widget.videoId,
          watchedSeconds: currentTime.toInt(),
          totalSeconds: duration.toInt(),
          title: video?.title,
          channelName: video?.channelName,
          thumbnailUrl: video?.thumbnailUrl,
        );
      }
    } catch (e) {
      logger.warning('Failed to save progress on exit: $e');
    }
  }

  Future<double> _getCurrentTimeFromWebView() async {
    if (_webViewController == null) return 0.0;

    try {
      logger.info('[YouTube API] Getting current time...');
      final result = await _webViewController!.evaluateJavascript(
        source: 'window.getCurrentTime();',
      );

      if (result != null) {
        final time = result is num ? result.toDouble() : (double.tryParse(result.toString()) ?? 0.0);
        logger.info('[YouTube API] Current time result: ${time}s');
        return time;
      }
      logger.warning('[YouTube API] No result from getCurrentTime');
      return 0.0;
    } catch (e) {
      logger.warning('[YouTube API] Error getting current time from webview: $e');
      return 0.0;
    }
  }

  Future<double> _getDurationFromWebView() async {
    if (_webViewController == null) return 0.0;

    try {
      logger.info('[YouTube API] Getting duration...');
      final result = await _webViewController!.evaluateJavascript(
        source: 'window.getDuration();',
      );

      if (result != null) {
        final duration = result is num ? result.toDouble() : (double.tryParse(result.toString()) ?? 0.0);
        logger.info('[YouTube API] Duration result: ${duration}s');
        return duration;
      }
      logger.warning('[YouTube API] No result from getDuration');
      return 0.0;
    } catch (e) {
      logger.warning('[YouTube API] Error getting duration from webview: $e');
      return 0.0;
    }
  }

  Future<void> _setPlaybackRate(double rate) async {
    if (_webViewController == null) return;

    try {
      logger.info('[YouTube API] Setting playback rate to: ${rate}x');
      await _webViewController!.evaluateJavascript(
        source: 'window.setPlaybackRate($rate);',
      );

      setState(() {
        _currentPlaybackRate = rate;
      });

      // Save preference
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('playback_speed', rate);

      logger.info('[YouTube API] Playback rate set to: ${rate}x');
    } catch (e) {
      logger.warning('[YouTube API] Error setting playback rate: $e');
    }
  }

  Future<double> _getPlaybackRate() async {
    if (_webViewController == null) return 1.0;

    try {
      final result = await _webViewController!.evaluateJavascript(
        source: 'window.getPlaybackRate();',
      );

      if (result != null) {
        final rate = result is num ? result.toDouble() : (double.tryParse(result.toString()) ?? 1.0);
        return rate;
      }
      return 1.0;
    } catch (e) {
      logger.warning('[YouTube API] Error getting playback rate: $e');
      return 1.0;
    }
  }

  void _resumeVideoFromSavedPosition() {
    // Wait for WebView and YouTube player to be ready
    Future.delayed(const Duration(milliseconds: 2500), () async {
      if (!mounted || _webViewController == null) return;

      try {
        // Get saved progress for this video
        final progressState = ref.read(progressProvider);
        final savedProgress = progressState.getProgress(widget.videoId);

        logger.info('[Resume] Checking saved progress for video ${widget.videoId}: ${savedProgress?.watchDuration}s / ${savedProgress?.totalDuration}s');

        if (savedProgress != null && savedProgress.watchDuration > 5 && !savedProgress.completed) {
          final resumePosition = savedProgress.watchDuration;
          logger.info('[Resume] Seeking to saved position: ${resumePosition}s');

          // Seek first
          await _webViewController!.evaluateJavascript(
            source: 'window.seekTo($resumePosition);',
          );

          // Wait for seek to complete
          await Future.delayed(const Duration(milliseconds: 800));

          // Verify the seek worked
          final actualPosition = await _getCurrentTimeFromWebView();
          logger.info('[Resume] After seek, actual position is: ${actualPosition}s (expected: ${resumePosition}s)');

          // Then play
          await _webViewController!.evaluateJavascript(
            source: 'window.playVideo();',
          );

          _lastSavedPosition = resumePosition;
          logger.info('[Resume] Resumed playback at position: ${actualPosition}s');
        } else {
          logger.info('[Resume] No saved progress to resume (progress: ${savedProgress?.watchDuration}s, completed: ${savedProgress?.completed})');

          // If no saved progress, auto-play from the beginning if requested
          if (widget.autoPlay) {
            await Future.delayed(const Duration(milliseconds: 500));
            await _webViewController!.evaluateJavascript(
              source: 'window.playVideo();',
            );
            logger.info('[Resume] No saved progress - starting from beginning');
          }
        }
      } catch (e, stackTrace) {
        logger.warning('[Resume] Failed to resume from saved position: $e\n$stackTrace');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use consistent player for all platforms
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
            useShouldOverrideUrlLoading: true,  // Enable navigation interception
          ),
          onWebViewCreated: (controller) {
            _webViewController = controller;
            logger.info('WebView created for video player with Referer: $_refererHeader');

            // PHASE 2: Register handler for video end event
            controller.addJavaScriptHandler(
              handlerName: 'onVideoEnded',
              callback: (args) {
                logger.info('[YouTube Player] Video ended - showing custom end screen');
                if (mounted) {
                  setState(() {
                    _showCustomEndScreen = true;
                  });
                }
              },
            );
          },
          // PHASE 1: Block navigation to other videos
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            final url = navigationAction.request.url.toString();

            // Allow navigation within the same video
            if (url.contains(widget.videoId) ||
                url.contains('youtube.com/embed/${widget.videoId}') ||
                url == _refererHeader ||
                url.contains('about:blank')) {
              return NavigationActionPolicy.ALLOW;
            }

            // Block navigation to other YouTube videos or external sites
            if (url.contains('youtube.com') || url.contains('youtu.be')) {
              logger.info('[YouTube Player] 🚫 Blocked navigation to other video: $url');

              // Show feedback to user (Phase 3)
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cannot navigate to other videos. Stay focused on your learning!'),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }

              return NavigationActionPolicy.CANCEL;
            }

            return NavigationActionPolicy.ALLOW;
          },
          onLoadStart: (controller, url) {
            setState(() {
              _isLoading = true;
            });
          },
          onLoadStop: (controller, url) async {
            logger.info('[YouTube API] WebView loaded');
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
            logger.error('WebView Error: ${error.description}');
          },
          // Handle fullscreen enter/exit events
          onEnterFullscreen: (controller) {
            logger.info('[YouTube Player] Entered fullscreen mode');
            widget.onFullscreenChanged?.call(true);
          },
          onExitFullscreen: (controller) {
            logger.info('[YouTube Player] Exited fullscreen mode');
            widget.onFullscreenChanged?.call(false);
          },
        ),
        if (_isLoading)
          Container(
            color: AppTheme.darkSurface,
            child: const Center(
              child: CircularProgressIndicator(
                color: AppTheme.lightOnPrimary,
              ),
            ),
          ),

        // PHASE 2: Custom end screen overlay
        if (_showCustomEndScreen)
          Container(
            color: AppTheme.darkSurface.withValues(alpha: 0.95),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 80,
                    color: AppTheme.lightOnPrimary,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Video Completed!',
                    style: TextStyle(
                      color: AppTheme.lightOnPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Great job! Keep learning.',
                    style: TextStyle(
                      color: AppTheme.lightOnPrimary.withValues(alpha: 0.7),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                    onPressed: () async {
                      // Replay the video from the beginning
                      logger.info('[YouTube Player] Replaying video');
                      setState(() {
                        _showCustomEndScreen = false;
                      });

                      // Seek to beginning and play
                      await _webViewController?.evaluateJavascript(
                        source: 'window.seekTo(0); window.playVideo();',
                      );
                    },
                    icon: const Icon(Icons.replay),
                    label: const Text('Watch Again'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Playback speed selector
        if (_playerReady && !_showCustomEndScreen)
          Positioned(
            bottom: 16,
            right: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Speed options menu
                if (_showSpeedMenu)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.darkSurface.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildSpeedOption(0.5),
                        _buildSpeedOption(0.75),
                        _buildSpeedOption(1.0),
                        _buildSpeedOption(1.25),
                        _buildSpeedOption(1.5),
                        _buildSpeedOption(2.0),
                      ],
                    ),
                  ),

                // Speed button
                Material(
                  color: AppTheme.darkSurface.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _showSpeedMenu = !_showSpeedMenu;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.speed,
                            color: AppTheme.lightOnPrimary,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${_currentPlaybackRate}x',
                            style: const TextStyle(
                              color: AppTheme.lightOnPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSpeedOption(double speed) {
    final isSelected = (_currentPlaybackRate - speed).abs() < 0.01;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          await _setPlaybackRate(speed);
          setState(() {
            _showSpeedMenu = false;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.lightOnPrimary.withValues(alpha: 0.15) : Colors.transparent,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 20,
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: AppTheme.lightOnPrimary,
                        size: 16,
                      )
                    : null,
              ),
              const SizedBox(width: 8),
              Text(
                '${speed}x',
                style: const TextStyle(
                  color: AppTheme.lightOnPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
