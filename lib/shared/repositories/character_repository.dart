import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:crack_the_code/shared/models/character.dart';

class CharacterRepository {
  List<Character> _characters = [];
  final Map<String, Character> _byId = {};
  final Map<int, List<Character>> _byLevel = {};
  final Map<String, List<Character>> _byPhonogram = {};
  bool _loaded = false;

  bool get isLoaded => _loaded;
  int get totalCharacters => _characters.length;

  Future<void> loadFromAssets() async {
    final json = await rootBundle.loadString('assets/data/characters.json');
    final List<dynamic> list = jsonDecode(json) as List<dynamic>;
    _characters = list.map((e) => Character.fromJson(e as Map<String, dynamic>)).toList();
    for (final c in _characters) {
      _byId[c.id] = c;
      _byLevel.putIfAbsent(c.level, () => []).add(c);
      _byPhonogram.putIfAbsent(c.phonogram, () => []).add(c);
    }
    _loaded = true;
  }

  List<Character> getAll() => _characters;
  Character? getById(String id) => _byId[id];
  List<Character> getByLevel(int level) => _byLevel[level] ?? [];
  List<Character> getByPhonogram(String phonogram) => _byPhonogram[phonogram] ?? [];
  List<Character> getUpToLevel(int maxLevel) =>
      _characters.where((c) => c.level <= maxLevel).toList();
}
