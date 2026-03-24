/// Audio Player Service for pronunciation playback
library;

import 'dart:async';
import 'package:just_audio/just_audio.dart';
import 'package:crack_the_code/core/utils/logger.dart';

/// Service for playing audio files (glossary pronunciations, etc.)
class AudioPlayerService {
  static final AudioPlayerService _instance = AudioPlayerService._internal();
  factory AudioPlayerService() => _instance;
  AudioPlayerService._internal();

  AudioPlayer? _player;
  String? _currentUrl;
  bool _isPlaying = false;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  /// Get the audio player instance
  AudioPlayer get player {
    final p = _player ?? AudioPlayer();
    _player = p;
    return p;
  }

  /// Check if audio is currently playing
  bool get isPlaying => _isPlaying;

  /// Get currently playing URL
  String? get currentUrl => _currentUrl;

  /// Play audio from URL
  Future<bool> playFromUrl(String url) async {
    try {
      // Stop any currently playing audio
      await stop();

      logger.info('Playing audio from: $url');
      _currentUrl = url;
      _isPlaying = true;

      // Set the audio source
      await player.setUrl(url);

      // Play the audio
      await player.play();

      // Cancel any existing subscription before creating new one
      await _playerStateSubscription?.cancel();

      // Listen for completion
      _playerStateSubscription = player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          _isPlaying = false;
          _currentUrl = null;
        }
      });

      return true;
    } catch (e, stackTrace) {
      logger.error('Failed to play audio', e, stackTrace);
      _isPlaying = false;
      _currentUrl = null;
      return false;
    }
  }

  /// Play audio from asset
  Future<bool> playFromAsset(String assetPath) async {
    try {
      await stop();

      logger.info('Playing audio from asset: $assetPath');
      _currentUrl = assetPath;
      _isPlaying = true;

      await player.setAsset(assetPath);
      await player.play();

      // Cancel any existing subscription before creating new one
      await _playerStateSubscription?.cancel();

      // Listen for completion
      _playerStateSubscription = player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          _isPlaying = false;
          _currentUrl = null;
        }
      });

      return true;
    } catch (e, stackTrace) {
      logger.error('Failed to play audio from asset', e, stackTrace);
      _isPlaying = false;
      _currentUrl = null;
      return false;
    }
  }

  /// Stop playing audio
  Future<void> stop() async {
    try {
      await _playerStateSubscription?.cancel();
      _playerStateSubscription = null;
      final p = _player;
      if (p != null) {
        await p.stop();
        _isPlaying = false;
        _currentUrl = null;
      }
    } catch (e) {
      logger.error('Failed to stop audio', e);
    }
  }

  /// Pause playing audio
  Future<void> pause() async {
    try {
      final p = _player;
      if (p != null && _isPlaying) {
        await p.pause();
        _isPlaying = false;
      }
    } catch (e) {
      logger.error('Failed to pause audio', e);
    }
  }

  /// Resume playing audio
  Future<void> resume() async {
    try {
      final p = _player;
      if (p != null && !_isPlaying && _currentUrl != null) {
        await p.play();
        _isPlaying = true;
      }
    } catch (e) {
      logger.error('Failed to resume audio', e);
    }
  }

  /// Dispose the audio player
  Future<void> dispose() async {
    try {
      await _playerStateSubscription?.cancel();
      _playerStateSubscription = null;
      await _player?.dispose();
      _player = null;
      _isPlaying = false;
      _currentUrl = null;
    } catch (e) {
      logger.error('Failed to dispose audio player', e);
    }
  }
}

/// Global audio player service instance
final audioPlayerService = AudioPlayerService();
