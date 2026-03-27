import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:crack_the_code/shared/models/level.dart';

class LevelRepository {
  List<Level> _levels = [];
  final Map<int, Level> _byNumber = {};
  bool _loaded = false;

  bool get isLoaded => _loaded;

  Future<void> loadFromAssets() async {
    final json = await rootBundle.loadString('assets/data/levels.json');
    final List<dynamic> list = jsonDecode(json) as List<dynamic>;
    _levels = list.map((e) => Level.fromJson(e as Map<String, dynamic>)).toList();
    for (final l in _levels) { _byNumber[l.number] = l; }
    _loaded = true;
  }

  List<Level> getAll() => _levels;
  Level? getByNumber(int num) => _byNumber[num];
  Level get level1 => _byNumber[1]!;
}
