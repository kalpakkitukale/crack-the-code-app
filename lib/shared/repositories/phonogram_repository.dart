import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:crack_the_code/shared/models/category.dart';
import 'package:crack_the_code/shared/models/phonogram.dart';
import 'package:crack_the_code/shared/models/phonogram_sound.dart';

class PhonogramRepository {
  List<Phonogram> _phonograms = [];
  final Map<String, Phonogram> _byId = {};
  final Map<String, PhonogramSound> _soundsById = {};
  bool _loaded = false;

  bool get isLoaded => _loaded;
  int get totalPhonograms => _phonograms.length;
  int get totalSounds => _soundsById.length;

  Future<void> loadFromAssets() async {
    final jsonString =
        await rootBundle.loadString('assets/data/phonograms.json');
    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
    _phonograms = jsonList
        .map((e) => Phonogram.fromJson(e as Map<String, dynamic>))
        .toList();

    _byId.clear();
    _soundsById.clear();
    for (final p in _phonograms) {
      _byId[p.id] = p;
      for (final s in p.sounds) {
        _soundsById[s.soundId] = s;
      }
    }
    _loaded = true;
  }

  List<Phonogram> getAll() => _phonograms;

  Phonogram? getById(String id) => _byId[id];

  PhonogramSound? getSoundById(String soundId) => _soundsById[soundId];

  List<Phonogram> getByCategory(PhonogramCategory category) =>
      _phonograms.where((p) => p.category == category).toList();

  List<Phonogram> search(String query) {
    final q = query.toLowerCase();
    return _phonograms.where((p) {
      if (p.text.toLowerCase().contains(q)) return true;
      return p.sounds.any((s) => s.notation.toLowerCase().contains(q));
    }).toList();
  }

  List<PhonogramSound> getAllSounds() => _soundsById.values.toList();
}
