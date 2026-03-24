import 'package:crack_the_code/shared/services/audio_service.dart';

class AudioRepository {
  final AudioService _audioService;

  AudioRepository(this._audioService);

  Future<void> preloadTier1() async {
    await _audioService.preloadDirectory('assets/audio/phonograms/');
    await _audioService.preloadDirectory('assets/audio/ui/');
  }

  Future<void> loadForGame(String gameId) async {
    await _audioService.preloadManifest('assets/audio/manifests/$gameId.json');
  }

  Future<void> evictTier2() async {
    await _audioService.evictNonEssential();
  }

  /// Play a phonogram sound — tries audio file, falls back to TTS
  Future<void> playPhonogram(String soundId,
      {String? notation, String? exampleWord}) async {
    if (notation != null) {
      // Use TTS with pronunciation info for better quality
      await _audioService.speakPhonogram(soundId, notation,
          exampleWord: exampleWord);
    } else {
      // Try audio file (will fall back to TTS via AudioService)
      await _audioService.play('phonograms/$soundId.ogg');
    }
  }

  /// Play a word — tries audio file, falls back to TTS
  Future<void> playWord(String word) async {
    await _audioService.speakWord(word);
  }

  Future<void> playUI(String soundName) async {
    await _audioService.play('ui/$soundName.ogg');
  }

  /// Speak text in Hindi
  Future<void> playHindi(String text) async {
    await _audioService.setTtsLanguage('hi-IN');
    await _audioService.speak(text);
    await _audioService.setTtsLanguage('en-US'); // reset
  }

  /// Speak text in Marathi
  Future<void> playMarathi(String text) async {
    await _audioService.setTtsLanguage('mr-IN');
    await _audioService.speak(text);
    await _audioService.setTtsLanguage('en-US'); // reset
  }

  Future<void> setVolume(double volume) async {
    await _audioService.setVolume(volume);
  }

  Future<void> stop() async {
    await _audioService.stop();
  }
}
