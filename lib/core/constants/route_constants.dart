/// Route names and paths for navigation
class RouteConstants {
  RouteConstants._();

  // Root routes
  static const String splash = '/';
  static const String home = '/home';

  // Browse routes
  static const String browse = '/browse';
  static const String boards = '/browse/boards';
  static const String subjects = '/browse/subjects/:boardId';
  static const String chapters = '/browse/chapters/:subjectId';
  static const String topics = '/browse/topics/:chapterId';

  // Video routes
  static const String video = '/video/:videoId';

  // Search routes
  static const String search = '/search';

  // Progress routes
  static const String progress = '/progress';

  // Bookmarks routes
  static const String bookmarks = '/bookmarks';
  static const String collections = '/collections';
  static const String collectionDetail = '/collections/:collectionId';

  // Notes routes
  static const String notes = '/notes';
  static const String noteEditor = '/notes/:noteId';
  static const String createNote = '/notes/create';

  // Library route (Middle & Senior segments)
  static const String library = '/library';

  // Practice route (Preboard segment)
  static const String practice = '/practice';

  // Settings routes
  static const String settings = '/settings';
  static const String about = '/settings/about';
  static const String dataManagement = '/settings/data';

  // Quiz routes
  static const String quiz = '/quiz/:entityId/:studentId';
  static const String quizResults = '/quiz/:entityId/:studentId/results';
  static const String quizReview = '/quiz/:entityId/:studentId/results/review';
  static const String quizHistory = '/quiz-history';
  static const String quizStatistics = '/quiz-statistics';

  // Study tools routes
  static const String flashcardDecks = '/study-tools/flashcard-decks/:chapterId';
  static const String flashcardStudy = '/study-tools/flashcards/:deckId';
  static const String mindMap = '/study-tools/mind-map/:chapterId';
  static const String glossary = '/study-tools/glossary/:chapterId';
  static const String studyHub = '/study-hub/:chapterId';
  static const String chapterSummary = '/study-hub/:chapterId/summary';
  static const String chapterNotes = '/study-hub/:chapterId/notes';
  static const String reviewDue = '/review-due';

  // Pre-assessment routes
  static const String preAssessment = '/pre-assessment/:subjectId/:targetGrade';

  // Recommendations routes
  static const String recommendations = '/recommendations';
  static const String recommendedVideos = '/recommended-videos';
  static const String learningPath = '/learning-path/:pathId';

  // Spelling routes (Crack the Code variant)
  static const String spellingHome = '/spelling-home';
  static const String spellingPractice = '/spelling-practice/:wordListId';
  static const String spellingBee = '/spelling-bee';
  static const String wordDetail = '/word/:wordId';
  static const String wordExplorer = '/word-explorer';
  static const String phonicsPatterns = '/phonics-patterns';
  static const String wordJournal = '/word-journal';
  static const String spellingProgress = '/spelling-progress';

  // Route names for navigation
  static const String homeRoute = 'home';
  static const String browseRoute = 'browse';
  static const String searchRoute = 'search';
  static const String progressRoute = 'progress';
  static const String settingsRoute = 'settings';
  static const String videoRoute = 'video';
  static const String bookmarksRoute = 'bookmarks';
  static const String collectionsRoute = 'collections';
  static const String collectionDetailRoute = 'collection-detail';
  static const String libraryRoute = 'library';
  static const String practiceRoute = 'practice';
  static const String quizRoute = 'quiz';
  static const String quizResultsRoute = 'quiz-results';
  static const String quizReviewRoute = 'quiz-review';
  static const String quizHistoryRoute = 'quiz-history';
  static const String quizStatisticsRoute = 'quiz-statistics';
  static const String preAssessmentRoute = 'preAssessment';
  static const String recommendationsRoute = 'recommendations';
  static const String recommendedVideosRoute = 'recommended-videos';
  static const String learningPathRoute = 'learning-path';

  // Spelling route names
  static const String spellingHomeRoute = 'spelling-home';
  static const String spellingPracticeRoute = 'spelling-practice';
  static const String spellingBeeRoute = 'spelling-bee';
  static const String wordDetailRoute = 'word-detail';
  static const String wordExplorerRoute = 'word-explorer';
  static const String phonicsPatternsRoute = 'phonics-patterns';
  static const String wordJournalRoute = 'word-journal';
  static const String spellingProgressRoute = 'spelling-progress';

  // Helper methods
  static String getSubjectsPath(String boardId) =>
      subjects.replaceAll(':boardId', boardId);

  static String getChaptersPath(String subjectId) =>
      chapters.replaceAll(':subjectId', subjectId);

  static String getTopicsPath(String chapterId) =>
      topics.replaceAll(':chapterId', chapterId);

  static String getVideoPath(String videoId) =>
      video.replaceAll(':videoId', videoId);

  /// Get video path with topicId for quiz loading
  /// The topicId is passed as a query parameter so the video player can load quizzes
  static String getVideoPathWithTopic(String videoId, {String? topicId}) {
    final basePath = video.replaceAll(':videoId', videoId);
    if (topicId != null && topicId.isNotEmpty) {
      return '$basePath?topicId=$topicId';
    }
    return basePath;
  }

  static String getSubjectChaptersPath(String boardId, String subjectId) =>
      '/browse/board/$boardId/subject/$subjectId/chapters';

  static String getCollectionPath(String collectionId) =>
      collectionDetail.replaceAll(':collectionId', collectionId);

  static String getNoteEditorPath(String noteId) =>
      noteEditor.replaceAll(':noteId', noteId);

  static String getQuizPath(String entityId, String studentId) =>
      quiz.replaceAll(':entityId', entityId).replaceAll(':studentId', studentId);

  /// Get quiz path with assessment type parameter.
  ///
  /// [assessmentType] should be either 'readiness' or 'knowledge'
  /// - 'readiness': PRE-assessment for gap analysis (before learning)
  /// - 'knowledge': POST-assessment for validation (after learning)
  static String getQuizPathWithType(
    String entityId,
    String studentId, {
    required String assessmentType,
  }) {
    final basePath = getQuizPath(entityId, studentId);
    return '$basePath?type=$assessmentType';
  }

  static String getQuizResultsPath(String entityId, String studentId) =>
      quizResults.replaceAll(':entityId', entityId).replaceAll(':studentId', studentId);

  static String getQuizReviewPath(String entityId, String studentId) =>
      quizReview.replaceAll(':entityId', entityId).replaceAll(':studentId', studentId);

  static String getPreAssessmentPath(String subjectId, int targetGrade, {
    required String subjectName,
    required String studentId,
  }) =>
      '${preAssessment.replaceAll(':subjectId', subjectId).replaceAll(':targetGrade', targetGrade.toString())}?name=$subjectName&studentId=$studentId';

  // Study tools helpers
  static String getFlashcardDecksPath(String chapterId, {String? subjectId}) {
    final basePath = flashcardDecks.replaceAll(':chapterId', chapterId);
    if (subjectId != null && subjectId.isNotEmpty) {
      return '$basePath?subjectId=$subjectId';
    }
    return basePath;
  }

  static String getFlashcardStudyPath(String deckId) =>
      flashcardStudy.replaceAll(':deckId', deckId);

  static String getMindMapPath(String chapterId) =>
      mindMap.replaceAll(':chapterId', chapterId);

  static String getGlossaryPath(String chapterId) =>
      glossary.replaceAll(':chapterId', chapterId);

  static String getStudyHubPath(String chapterId, {String? subjectId}) {
    final basePath = studyHub.replaceAll(':chapterId', chapterId);
    if (subjectId != null && subjectId.isNotEmpty) {
      return '$basePath?subjectId=$subjectId';
    }
    return basePath;
  }

  static String getChapterSummaryPath(String chapterId, {String? subjectId}) {
    final basePath = chapterSummary.replaceAll(':chapterId', chapterId);
    if (subjectId != null && subjectId.isNotEmpty) {
      return '$basePath?subjectId=$subjectId';
    }
    return basePath;
  }

  static String getChapterNotesPath(String chapterId, {String? subjectId}) {
    final basePath = chapterNotes.replaceAll(':chapterId', chapterId);
    if (subjectId != null && subjectId.isNotEmpty) {
      return '$basePath?subjectId=$subjectId';
    }
    return basePath;
  }

  // Spelling helper methods
  static String getSpellingPracticePath(String wordListId) =>
      spellingPractice.replaceAll(':wordListId', wordListId);

  static String getWordDetailPath(String wordId) =>
      wordDetail.replaceAll(':wordId', wordId);
}
