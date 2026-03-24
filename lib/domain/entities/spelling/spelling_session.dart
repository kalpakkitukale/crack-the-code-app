/// Represents an active spelling practice session
class SpellingSession {
  final String id;
  final String wordListId;
  final String activityType; // dictation, unscramble, fill_blank, mixed
  final List<String> wordIds;
  final int currentIndex;
  final int correctCount;
  final int incorrectCount;
  final int skippedCount;
  final DateTime startedAt;
  final DateTime? completedAt;
  final String? profileId;
  final List<String> completedWordIds;
  final List<String> incorrectWordIds;

  const SpellingSession({
    required this.id,
    required this.wordListId,
    required this.activityType,
    required this.wordIds,
    this.currentIndex = 0,
    this.correctCount = 0,
    this.incorrectCount = 0,
    this.skippedCount = 0,
    required this.startedAt,
    this.completedAt,
    this.profileId,
    this.completedWordIds = const [],
    this.incorrectWordIds = const [],
  });

  int get totalWords => wordIds.length;
  int get attemptedCount => correctCount + incorrectCount + skippedCount;
  double get progressPercent =>
      totalWords > 0 ? attemptedCount / totalWords : 0.0;
  double get accuracy =>
      (correctCount + incorrectCount) > 0
          ? correctCount / (correctCount + incorrectCount)
          : 0.0;
  bool get isCompleted => completedAt != null || currentIndex >= totalWords;
  String? get currentWordId =>
      currentIndex < wordIds.length ? wordIds[currentIndex] : null;

  SpellingSession copyWith({
    int? currentIndex,
    int? correctCount,
    int? incorrectCount,
    int? skippedCount,
    DateTime? completedAt,
    List<String>? completedWordIds,
    List<String>? incorrectWordIds,
  }) {
    return SpellingSession(
      id: id,
      wordListId: wordListId,
      activityType: activityType,
      wordIds: wordIds,
      currentIndex: currentIndex ?? this.currentIndex,
      correctCount: correctCount ?? this.correctCount,
      incorrectCount: incorrectCount ?? this.incorrectCount,
      skippedCount: skippedCount ?? this.skippedCount,
      startedAt: startedAt,
      completedAt: completedAt ?? this.completedAt,
      profileId: profileId,
      completedWordIds: completedWordIds ?? this.completedWordIds,
      incorrectWordIds: incorrectWordIds ?? this.incorrectWordIds,
    );
  }
}
