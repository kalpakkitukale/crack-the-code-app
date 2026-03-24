import 'dart:typed_data';

/// Simple in-memory Trie for fast word validation.
/// For now, uses a Map-based implementation.
/// Can be replaced with binary-packed Trie for production (50K+ words).
class TrieDictionary {
  final _TrieNode _root = _TrieNode();
  int _wordCount = 0;

  int get wordCount => _wordCount;

  /// Build from a list of words (used during development)
  TrieDictionary.fromWords(List<String> words) {
    for (final word in words) {
      insert(word.toLowerCase());
    }
  }

  /// Build from binary data (for production — pre-compiled asset)
  factory TrieDictionary.fromBinary(Uint8List data) {
    // For now, decode as newline-separated word list
    // In production, replace with binary-packed Trie format
    final text = String.fromCharCodes(data);
    final words = text.split('\n').where((w) => w.trim().isNotEmpty).toList();
    return TrieDictionary.fromWords(words);
  }

  void insert(String word) {
    var node = _root;
    for (int i = 0; i < word.length; i++) {
      final char = word[i];
      node = node.children.putIfAbsent(char, () => _TrieNode());
    }
    if (!node.isEnd) {
      node.isEnd = true;
      _wordCount++;
    }
  }

  bool contains(String word) {
    var node = _root;
    final lower = word.toLowerCase();
    for (int i = 0; i < lower.length; i++) {
      final child = node.children[lower[i]];
      if (child == null) return false;
      node = child;
    }
    return node.isEnd;
  }

  /// Get all words starting with prefix (limited for autocomplete)
  List<String> wordsWithPrefix(String prefix, {int limit = 20}) {
    var node = _root;
    final lower = prefix.toLowerCase();
    for (int i = 0; i < lower.length; i++) {
      final child = node.children[lower[i]];
      if (child == null) return [];
      node = child;
    }

    final results = <String>[];
    _collectWords(node, lower, results, limit);
    return results;
  }

  void _collectWords(
      _TrieNode node, String prefix, List<String> results, int limit) {
    if (results.length >= limit) return;
    if (node.isEnd) results.add(prefix);
    for (final entry in node.children.entries) {
      _collectWords(entry.value, prefix + entry.key, results, limit);
      if (results.length >= limit) return;
    }
  }
}

class _TrieNode {
  final Map<String, _TrieNode> children = {};
  bool isEnd = false;
}
