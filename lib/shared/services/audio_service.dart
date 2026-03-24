import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

class AudioService {
  final List<AudioPlayer> _pool = List.generate(4, (_) => AudioPlayer());
  int _nextPlayer = 0;
  final Set<String> _preloadedPaths = {};
  bool _initialized = false;

  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    _initialized = true;
  }

  Future<void> preloadDirectory(String dir) async {
    // In production, this would preload OGG files into memory.
    // For now, just mark as preloaded so play() knows to use asset source.
    _preloadedPaths.add(dir);
  }

  Future<void> preloadManifest(String manifestPath) async {
    try {
      final jsonString = await rootBundle.loadString(manifestPath);
      final List<dynamic> files = jsonDecode(jsonString) as List<dynamic>;
      for (final f in files) {
        _preloadedPaths.add(f as String);
      }
    } catch (_) {
      // Manifest not found — okay for dev, audio just won't preload
    }
  }

  Future<void> evictNonEssential() async {
    // Remove non-tier-1 paths from preloaded set
    _preloadedPaths.removeWhere(
        (p) => !p.contains('phonograms/') && !p.contains('ui/'));
  }

  Future<void> play(String assetPath) async {
    if (!_initialized) return;

    try {
      final player = _pool[_nextPlayer];
      _nextPlayer = (_nextPlayer + 1) % _pool.length;

      await player.setAsset('assets/audio/$assetPath');
      await player.seek(Duration.zero);
      await player.play();
    } catch (_) {
      // Audio file not found — silent fail during development
    }
  }

  Future<void> setVolume(double volume) async {
    for (final player in _pool) {
      await player.setVolume(volume);
    }
  }

  Future<void> dispose() async {
    for (final player in _pool) {
      await player.dispose();
    }
    _initialized = false;
  }
}
