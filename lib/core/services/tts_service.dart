/// Text-to-Speech Service
/// Provides text-to-speech functionality across the app
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:crack_the_code/core/utils/logger.dart';

/// Text-to-Speech service singleton
class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  FlutterTts? _flutterTts;
  bool _isInitialized = false;
  bool _isSpeaking = false;
  String? _currentText;

  // Callbacks
  VoidCallback? onStart;
  VoidCallback? onComplete;
  VoidCallback? onCancel;
  void Function(String)? onError;

  /// Initialize the TTS engine
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final tts = FlutterTts();

      // Set default language to Indian English
      await tts.setLanguage('en-IN');

      // Set speech rate (0.0 to 1.0, default 0.5)
      await tts.setSpeechRate(0.45);

      // Set pitch (0.5 to 2.0, default 1.0)
      await tts.setPitch(1.0);

      // Set volume (0.0 to 1.0, default 1.0)
      await tts.setVolume(1.0);

      // Set up handlers
      tts.setStartHandler(() {
        _isSpeaking = true;
        onStart?.call();
        logger.info('TTS started speaking');
      });

      tts.setCompletionHandler(() {
        _isSpeaking = false;
        _currentText = null;
        onComplete?.call();
        logger.info('TTS completed');
      });

      tts.setCancelHandler(() {
        _isSpeaking = false;
        _currentText = null;
        onCancel?.call();
        logger.info('TTS cancelled');
      });

      tts.setErrorHandler((message) {
        _isSpeaking = false;
        _currentText = null;
        onError?.call(message.toString());
        logger.error('TTS error: $message');
      });

      // Only assign to field after successful setup
      _flutterTts = tts;
      _isInitialized = true;
      logger.info('TTS service initialized');
    } catch (e, stackTrace) {
      logger.error('Failed to initialize TTS', e, stackTrace);
      _isInitialized = false;
    }
  }

  /// Check if TTS is currently speaking
  bool get isSpeaking => _isSpeaking;

  /// Check if TTS is initialized
  bool get isInitialized => _isInitialized;

  /// Speak the given text
  Future<void> speak(String text) async {
    if (!_isInitialized) {
      await initialize();
    }

    final tts = _flutterTts;
    if (tts == null) {
      logger.warning('TTS not available');
      return;
    }

    // Stop any current speech
    if (_isSpeaking) {
      await stop();
    }

    _currentText = text;
    logger.info('TTS speaking: ${text.substring(0, text.length > 50 ? 50 : text.length)}...');

    await tts.speak(text);
  }

  /// Stop speaking
  Future<void> stop() async {
    final tts = _flutterTts;
    if (tts == null) return;

    await tts.stop();
    _isSpeaking = false;
    _currentText = null;
    logger.info('TTS stopped');
  }

  /// Pause speaking (if supported)
  Future<void> pause() async {
    final tts = _flutterTts;
    if (tts == null) return;
    await tts.pause();
    _isSpeaking = false;
    logger.info('TTS paused');
  }

  /// Set speech rate (0.0 to 1.0)
  Future<void> setSpeechRate(double rate) async {
    final tts = _flutterTts;
    if (tts == null) return;
    await tts.setSpeechRate(rate.clamp(0.0, 1.0));
  }

  /// Set language
  Future<void> setLanguage(String language) async {
    final tts = _flutterTts;
    if (tts == null) return;
    await tts.setLanguage(language);
  }

  /// Get available languages
  Future<List<String>> getAvailableLanguages() async {
    final tts = _flutterTts;
    if (tts == null) return [];
    final languages = await tts.getLanguages;
    return (languages as List).map((e) => e.toString()).toList();
  }

  /// Dispose the TTS engine
  Future<void> dispose() async {
    final tts = _flutterTts;
    if (tts != null) {
      await tts.stop();
      _flutterTts = null;
    }
    _isInitialized = false;
    _isSpeaking = false;
    _currentText = null;
    logger.info('TTS service disposed');
  }
}

/// Global TTS service instance
final ttsService = TtsService();
