import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:crack_the_code/shared/models/word_entry.dart';
import 'package:crack_the_code/shared/services/trie_dictionary.dart';

class WordRepository {
  late TrieDictionary _trie;
  List<WordEntry> _words = [];
  final Map<String, List<WordEntry>> _byPhonogram = {};
  final Map<int, List<WordEntry>> _byRule = {};
  final Map<int, List<WordEntry>> _byDifficulty = {};
  final Map<int, List<WordEntry>> _byTier = {};
  bool _loaded = false;

  bool get isLoaded => _loaded;
  int get totalWords => _words.length;
  int get trieWordCount => _trie.wordCount;

  Future<void> loadFromAssets() async {
    // Load word metadata JSON
    final jsonString = await rootBundle.loadString('assets/data/words.json');
    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
    _words = jsonList
        .map((e) => WordEntry.fromJson(e as Map<String, dynamic>))
        .toList();

    // Build Trie from the words we have (expand to 50K binary later)
    final allWords = _words.map((w) => w.word.toLowerCase()).toList();
    _trie = TrieDictionary.fromWords(allWords);

    // Build indexes
    _byPhonogram.clear();
    _byRule.clear();
    _byDifficulty.clear();
    _byTier.clear();
    for (final w in _words) {
      for (final p in w.phonogramBreakdown) {
        _byPhonogram.putIfAbsent(p, () => []).add(w);
      }
      for (final r in w.ruleNumbers) {
        _byRule.putIfAbsent(r, () => []).add(w);
      }
      _byDifficulty.putIfAbsent(w.difficulty, () => []).add(w);
      _byTier.putIfAbsent(w.tier, () => []).add(w);
    }
    _loaded = true;
  }

  bool isValidWord(String word) => _trie.contains(word.toLowerCase());

  bool isValidPhonogramSequence(List<String> phonograms) {
    return _trie.contains(phonograms.join().toLowerCase());
  }

  List<WordEntry> getWordsForPhonogram(String phonogramText) =>
      _byPhonogram[phonogramText] ?? [];

  List<WordEntry> getWordsForRule(int ruleNum) => _byRule[ruleNum] ?? [];

  List<WordEntry> getWordsByDifficulty(int difficulty) =>
      _byDifficulty[difficulty] ?? [];

  WordEntry? getRandomWord({int? difficulty, List<String>? phonogramPool}) {
    var candidates = _words.toList();

    if (difficulty != null) {
      candidates = candidates.where((w) => w.difficulty == difficulty).toList();
    }

    if (phonogramPool != null && phonogramPool.isNotEmpty) {
      candidates = candidates
          .where(
              (w) => w.phonogramBreakdown.any((p) => phonogramPool.contains(p)))
          .toList();
    }

    if (candidates.isEmpty) return null;
    return candidates[Random().nextInt(candidates.length)];
  }

  List<WordEntry> searchWords(String query) {
    final q = query.toLowerCase();
    return _words.where((w) => w.word.toLowerCase().contains(q)).toList();
  }

  List<String> autocomplete(String prefix, {int limit = 10}) {
    return _trie.wordsWithPrefix(prefix.toLowerCase(), limit: limit);
  }

  // Tier-aware queries
  List<WordEntry> getWordsForTier(int tier) => _byTier[tier] ?? [];

  List<WordEntry> getUnlockedWords(Set<int> unlockedTiers) =>
      _words.where((w) => unlockedTiers.contains(w.tier)).toList();

  List<WordEntry> getWordsForPhonogramInTiers(
      String phonogramText, Set<int> unlockedTiers) {
    return (_byPhonogram[phonogramText] ?? [])
        .where((w) => unlockedTiers.contains(w.tier))
        .toList();
  }

  bool isInUnlockedTier(String word, Set<int> unlockedTiers) {
    final entry = _words.where(
        (w) => w.word.toLowerCase() == word.toLowerCase()).firstOrNull;
    if (entry == null) return false;
    return unlockedTiers.contains(entry.tier);
  }

  WordEntry? getWordEntry(String word) {
    return _words.where(
        (w) => w.word.toLowerCase() == word.toLowerCase()).firstOrNull;
  }
}
