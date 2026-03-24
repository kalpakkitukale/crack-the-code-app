import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:crack_the_code/shared/models/spelling_rule.dart';

class RuleRepository {
  List<SpellingRule> _rules = [];
  final Map<int, SpellingRule> _byNum = {};
  bool _loaded = false;

  bool get isLoaded => _loaded;

  Future<void> loadFromAssets() async {
    final jsonString = await rootBundle.loadString('assets/data/rules.json');
    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
    _rules = jsonList
        .map((e) => SpellingRule.fromJson(e as Map<String, dynamic>))
        .toList();

    _byNum.clear();
    for (final r in _rules) {
      _byNum[r.ruleNum] = r;
    }
    _loaded = true;
  }

  List<SpellingRule> getAll() => _rules;

  SpellingRule? getByNum(int num) => _byNum[num];

  List<SpellingRule> getByCategory(String category) =>
      _rules.where((r) => r.category == category).toList();

  List<String> getAllCategories() =>
      _rules.map((r) => r.category).toSet().toList();
}
