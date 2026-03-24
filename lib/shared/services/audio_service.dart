import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';

/// Audio service with TTS fallback.
/// Uses audio files when available, falls back to text-to-speech.
class AudioService {
  final List<AudioPlayer> _pool = List.generate(4, (_) => AudioPlayer());
  int _nextPlayer = 0;
  final Set<String> _preloadedPaths = {};
  bool _initialized = false;

  // TTS engine for fallback when audio files don't exist
  final FlutterTts _tts = FlutterTts();

  // Maps sound IDs to their pronunciation text for TTS
  final Map<String, String> _soundPronunciations = {};
  // Maps words to their text for TTS
  final Map<String, String> _wordPronunciations = {};

  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    // Configure TTS
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45); // Slower for clarity
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    _initialized = true;
  }

  /// Register phonogram sounds for TTS fallback
  void registerPhonogramSounds(Map<String, String> soundIdToText) {
    _soundPronunciations.addAll(soundIdToText);
  }

  /// Register word pronunciations for TTS fallback
  void registerWords(Map<String, String> wordToText) {
    _wordPronunciations.addAll(wordToText);
  }

  Future<void> preloadDirectory(String dir) async {
    _preloadedPaths.add(dir);
  }

  Future<void> preloadManifest(String manifestPath) async {
    try {
      final jsonString = await rootBundle.loadString(manifestPath);
      final List<dynamic> files = jsonDecode(jsonString) as List<dynamic>;
      for (final f in files) {
        _preloadedPaths.add(f as String);
      }
    } catch (_) {}
  }

  Future<void> evictNonEssential() async {
    _preloadedPaths.removeWhere(
        (p) => !p.contains('phonograms/') && !p.contains('ui/'));
  }

  /// Play audio file, fallback to TTS if file not found
  Future<void> play(String assetPath) async {
    if (!_initialized) return;

    // Try to play the audio file first
    try {
      final player = _pool[_nextPlayer];
      _nextPlayer = (_nextPlayer + 1) % _pool.length;

      await player.setAsset('assets/audio/$assetPath');
      await player.seek(Duration.zero);
      await player.play();
      return; // Success — audio file exists
    } catch (_) {
      // Audio file not found — use TTS fallback
    }

    // TTS fallback
    await _speakFromPath(assetPath);
  }

  /// Speak a phonogram sound using TTS
  Future<void> speakPhonogram(String soundId, String notation,
      {String? exampleWord}) async {
    if (!_initialized) return;

    // Speak the sound notation, then the example word
    final text = exampleWord != null
        ? '${_cleanNotation(notation)}, as in $exampleWord'
        : _cleanNotation(notation);

    await _tts.speak(text);
  }

  /// Speak a word using TTS
  Future<void> speakWord(String word) async {
    if (!_initialized) return;
    await _tts.speak(word.toLowerCase());
  }

  /// Speak arbitrary text
  Future<void> speak(String text) async {
    if (!_initialized) return;
    await _tts.speak(text);
  }

  /// Set TTS language (en-US, hi-IN, mr-IN)
  Future<void> setTtsLanguage(String language) async {
    await _tts.setLanguage(language);
  }

  Future<void> setVolume(double volume) async {
    for (final player in _pool) {
      await player.setVolume(volume);
    }
    await _tts.setVolume(volume);
  }

  Future<void> stop() async {
    await _tts.stop();
    for (final player in _pool) {
      await player.stop();
    }
  }

  Future<void> dispose() async {
    await _tts.stop();
    for (final player in _pool) {
      await player.dispose();
    }
    _initialized = false;
  }

  /// Convert asset path to TTS text
  Future<void> _speakFromPath(String assetPath) async {
    // phonograms/01a.ogg → look up sound ID "01a"
    if (assetPath.startsWith('phonograms/')) {
      final soundId = assetPath
          .replaceFirst('phonograms/', '')
          .replaceFirst('.ogg', '');
      final text = _soundPronunciations[soundId];
      if (text != null) {
        await _tts.speak(text);
        return;
      }
    }

    // words/cat.ogg → speak "cat"
    if (assetPath.startsWith('words/')) {
      final word = assetPath
          .replaceFirst('words/', '')
          .replaceFirst('.ogg', '');
      await _tts.speak(word);
      return;
    }

    // UI sounds — just skip, no TTS for UI sounds
    if (assetPath.startsWith('ui/')) {
      return;
    }

    debugPrint('AudioService: no handler for $assetPath');
  }

  /// Clean notation like "/sh/" to "sh" for TTS
  String _cleanNotation(String notation) {
    return notation.replaceAll('/', '').trim();
  }
}
