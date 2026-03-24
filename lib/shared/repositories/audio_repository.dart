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

  Future<void> playPhonogram(String soundId) async {
    await _audioService.play('phonograms/$soundId.ogg');
  }

  Future<void> playWord(String word) async {
    await _audioService.play('words/${word.toLowerCase()}.ogg');
  }

  Future<void> playUI(String soundName) async {
    await _audioService.play('ui/$soundName.ogg');
  }

  Future<void> playHindi(String soundId) async {
    await _audioService.play('hindi/$soundId.ogg');
  }

  Future<void> playMarathi(String soundId) async {
    await _audioService.play('marathi/$soundId.ogg');
  }

  Future<void> setVolume(double volume) async {
    await _audioService.setVolume(volume);
  }
}
