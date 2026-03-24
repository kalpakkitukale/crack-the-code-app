/// Service for checking spelling and providing feedback
class SpellingCheckerService {
  /// Check if the user's spelling is correct
  SpellingCheckResult check(String userInput, String correctWord) {
    final input = userInput.trim();
    final correct = correctWord.trim();

    if (input.toLowerCase() == correct.toLowerCase()) {
      // Check case sensitivity
      if (input == correct) {
        return SpellingCheckResult(
          isCorrect: true,
          feedback: 'Perfect spelling!',
          similarity: 1.0,
        );
      }
      return SpellingCheckResult(
        isCorrect: true,
        feedback: 'Correct! Watch the capitalization though.',
        similarity: 0.99,
      );
    }

    final distance = _levenshteinDistance(input.toLowerCase(), correct.toLowerCase());
    final maxLen = correct.length > input.length ? correct.length : input.length;
    final similarity = maxLen > 0 ? 1.0 - (distance / maxLen) : 0.0;

    String feedback;
    List<SpellingMistake> mistakes = _analyzeMistakes(input, correct);

    if (similarity >= 0.8) {
      feedback = 'Almost! You\'re very close.';
    } else if (similarity >= 0.5) {
      feedback = 'Good try! Keep practicing this word.';
    } else {
      feedback = 'Let\'s try again. Listen carefully.';
    }

    if (mistakes.isNotEmpty) {
      feedback += ' ${mistakes.first.hint}';
    }

    return SpellingCheckResult(
      isCorrect: false,
      feedback: feedback,
      similarity: similarity,
      mistakes: mistakes,
      correctWord: correct,
    );
  }

  /// Analyze specific mistakes in the user's input
  List<SpellingMistake> _analyzeMistakes(String input, String correct) {
    final mistakes = <SpellingMistake>[];
    final inputLower = input.toLowerCase();
    final correctLower = correct.toLowerCase();

    // Check for common patterns
    if (_hasSwappedLetters(inputLower, correctLower)) {
      mistakes.add(SpellingMistake(
        type: MistakeType.swappedLetters,
        hint: 'Check the order of the letters.',
      ));
    }

    if (inputLower.length > correctLower.length) {
      mistakes.add(SpellingMistake(
        type: MistakeType.extraLetter,
        hint: 'You added an extra letter.',
      ));
    } else if (inputLower.length < correctLower.length) {
      mistakes.add(SpellingMistake(
        type: MistakeType.missingLetter,
        hint: 'You missed a letter.',
      ));
    }

    // Check for doubled letter mistakes
    if (_hasDoublingMistake(inputLower, correctLower)) {
      mistakes.add(SpellingMistake(
        type: MistakeType.doublingError,
        hint: 'Watch out for double letters.',
      ));
    }

    // Check for common vowel confusion
    if (_hasVowelConfusion(inputLower, correctLower)) {
      mistakes.add(SpellingMistake(
        type: MistakeType.vowelConfusion,
        hint: 'Check the vowels carefully.',
      ));
    }

    return mistakes;
  }

  bool _hasSwappedLetters(String input, String correct) {
    if (input.length != correct.length) return false;
    int diffs = 0;
    for (int i = 0; i < input.length; i++) {
      if (input[i] != correct[i]) diffs++;
    }
    return diffs == 2;
  }

  bool _hasDoublingMistake(String input, String correct) {
    // Check if adding or removing a doubled letter would fix it
    for (int i = 0; i < correct.length - 1; i++) {
      if (correct[i] == correct[i + 1]) {
        final withoutDouble = correct.substring(0, i) + correct.substring(i + 1);
        if (withoutDouble == input) return true;
      }
    }
    for (int i = 0; i < input.length - 1; i++) {
      if (input[i] == input[i + 1]) {
        final withoutDouble = input.substring(0, i) + input.substring(i + 1);
        if (withoutDouble == correct) return true;
      }
    }
    return false;
  }

  bool _hasVowelConfusion(String input, String correct) {
    const vowels = {'a', 'e', 'i', 'o', 'u'};
    if (input.length != correct.length) return false;
    for (int i = 0; i < input.length; i++) {
      if (input[i] != correct[i]) {
        if (vowels.contains(input[i]) && vowels.contains(correct[i])) {
          return true;
        }
      }
    }
    return false;
  }

  static int _levenshteinDistance(String s, String t) {
    if (s.isEmpty) return t.length;
    if (t.isEmpty) return s.length;
    final List<List<int>> d = List.generate(
      s.length + 1,
      (i) => List.generate(t.length + 1, (j) => 0),
    );
    for (int i = 0; i <= s.length; i++) {
      d[i][0] = i;
    }
    for (int j = 0; j <= t.length; j++) {
      d[0][j] = j;
    }
    for (int i = 1; i <= s.length; i++) {
      for (int j = 1; j <= t.length; j++) {
        final cost = s[i - 1] == t[j - 1] ? 0 : 1;
        d[i][j] = [
          d[i - 1][j] + 1,
          d[i][j - 1] + 1,
          d[i - 1][j - 1] + cost,
        ].reduce((a, b) => a < b ? a : b);
      }
    }
    return d[s.length][t.length];
  }
}

/// Result of a spelling check
class SpellingCheckResult {
  final bool isCorrect;
  final String feedback;
  final double similarity; // 0.0 to 1.0
  final List<SpellingMistake> mistakes;
  final String? correctWord;

  const SpellingCheckResult({
    required this.isCorrect,
    required this.feedback,
    required this.similarity,
    this.mistakes = const [],
    this.correctWord,
  });
}

/// A specific mistake identified in the spelling
class SpellingMistake {
  final MistakeType type;
  final String hint;
  final int? position;

  const SpellingMistake({
    required this.type,
    required this.hint,
    this.position,
  });
}

/// Types of spelling mistakes
enum MistakeType {
  swappedLetters,
  extraLetter,
  missingLetter,
  doublingError,
  vowelConfusion,
  silentLetter,
  homophone,
  prefixError,
  suffixError,
  other,
}
