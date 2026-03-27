import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:crack_the_code/shared/models/sound.dart';

class SoundRepository {
  List<Sound> _sounds = [];
  final Map<String, Sound> _byId = {};
  bool _loaded = false;

  bool get isLoaded => _loaded;
  int get totalSounds => _sounds.length;

  Future<void> loadFromAssets() async {
    final json = await rootBundle.loadString('assets/data/sounds.json');
    final List<dynamic> list = jsonDecode(json) as List<dynamic>;
    _sounds = list.map((e) => Sound.fromJson(e as Map<String, dynamic>)).toList();
    for (final s in _sounds) { _byId[s.id] = s; }
    _loaded = true;
  }

  List<Sound> getAll() => _sounds;
  Sound? getById(String id) => _byId[id];
  List<Sound> getConsonants() => _sounds.where((s) => s.isConsonant).toList();
  List<Sound> getVowels() => _sounds.where((s) => s.isVowel).toList();
  List<Sound> getForTrialDay(int day) => _sounds.where((s) => s.trialDay == day).toList();
}
