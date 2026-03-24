/// Dependency injection container for StreamShaala
///
/// This file sets up all dependencies using a simple service locator pattern.
/// In production, you may want to use Riverpod providers directly.
library;

import 'package:streamshaala/core/utils/logger.dart';
import 'package:streamshaala/data/datasources/json/content_json_datasource.dart';
import 'package:streamshaala/data/datasources/json/concept_json_data_source.dart';
import 'package:streamshaala/data/datasources/json/quiz_json_datasource.dart';
import 'package:streamshaala/data/datasources/local/database/dao/bookmark_dao.dart';
import 'package:streamshaala/data/datasources/local/database/dao/concept_mastery_dao.dart';
import 'package:streamshaala/data/datasources/local/database/dao/spaced_repetition_dao.dart';
import 'package:streamshaala/data/datasources/local/database/dao/collection_dao.dart';
import 'package:streamshaala/data/datasources/local/database/dao/collection_video_dao.dart';
import 'package:streamshaala/data/datasources/local/database/dao/note_dao.dart';
import 'package:streamshaala/data/datasources/local/database/dao/preference_dao.dart';
import 'package:streamshaala/data/datasources/local/database/dao/progress_dao.dart';
import 'package:streamshaala/data/datasources/local/database/dao/question_dao.dart';
import 'package:streamshaala/data/datasources/local/database/dao/quiz_dao.dart';
import 'package:streamshaala/data/datasources/local/database/dao/quiz_session_dao.dart';
import 'package:streamshaala/data/datasources/local/database/dao/quiz_attempt_dao.dart';
import 'package:streamshaala/data/datasources/local/database/dao/recommendations_history_dao.dart';
import 'package:streamshaala/data/datasources/local/database/dao/learning_path_dao.dart';
import 'package:streamshaala/data/datasources/local/database/database_helper.dart';
import 'package:streamshaala/data/repositories/bookmark_repository_impl.dart';
import 'package:streamshaala/data/repositories/collection_repository_impl.dart';
import 'package:streamshaala/data/repositories/content_repository_impl.dart';
import 'package:streamshaala/data/repositories/note_repository_impl.dart';
import 'package:streamshaala/data/repositories/preferences_repository_impl.dart';
import 'package:streamshaala/data/repositories/progress_repository_impl.dart';
import 'package:streamshaala/data/repositories/quiz_repository_impl.dart';
import 'package:streamshaala/data/repositories/learning_path_repository_impl.dart';
import 'package:streamshaala/data/repositories/recommendations_history_repository_impl.dart';
import 'package:streamshaala/domain/repositories/bookmark_repository.dart';
import 'package:streamshaala/domain/repositories/collection_repository.dart';
import 'package:streamshaala/domain/repositories/content_repository.dart';
import 'package:streamshaala/domain/repositories/note_repository.dart';
import 'package:streamshaala/domain/repositories/preferences_repository.dart';
import 'package:streamshaala/domain/repositories/progress_repository.dart';
import 'package:streamshaala/domain/repositories/quiz_repository.dart';
import 'package:streamshaala/domain/repositories/learning_path_repository.dart';
import 'package:streamshaala/domain/repositories/recommendations_history_repository.dart';
import 'package:streamshaala/domain/usecases/bookmark/add_bookmark_usecase.dart';
import 'package:streamshaala/domain/usecases/bookmark/get_all_bookmarks_usecase.dart';
import 'package:streamshaala/domain/usecases/bookmark/remove_bookmark_usecase.dart';
import 'package:streamshaala/domain/usecases/collection/add_video_to_collection_usecase.dart';
import 'package:streamshaala/domain/usecases/collection/create_collection_usecase.dart';
import 'package:streamshaala/domain/usecases/collection/get_collections_usecase.dart';
import 'package:streamshaala/domain/usecases/collection/remove_video_from_collection_usecase.dart';
import 'package:streamshaala/domain/usecases/content/get_boards_usecase.dart';
import 'package:streamshaala/domain/usecases/content/get_chapters_usecase.dart';
import 'package:streamshaala/domain/usecases/content/get_subjects_usecase.dart';
import 'package:streamshaala/domain/usecases/content/get_videos_usecase.dart';
import 'package:streamshaala/domain/usecases/content/search_videos_usecase.dart';
import 'package:streamshaala/domain/usecases/note/add_note_usecase.dart';
import 'package:streamshaala/domain/usecases/note/delete_note_usecase.dart';
import 'package:streamshaala/domain/usecases/note/get_notes_usecase.dart';
import 'package:streamshaala/domain/usecases/note/update_note_usecase.dart';
import 'package:streamshaala/domain/usecases/progress/get_statistics_usecase.dart';
import 'package:streamshaala/domain/usecases/progress/get_watch_history_usecase.dart';
import 'package:streamshaala/domain/usecases/progress/save_progress_usecase.dart';
import 'package:streamshaala/domain/usecases/quiz/complete_quiz_usecase.dart';
import 'package:streamshaala/domain/usecases/quiz/get_active_session_usecase.dart';
import 'package:streamshaala/domain/usecases/quiz/get_quiz_history_usecase.dart';
import 'package:streamshaala/domain/usecases/quiz/load_quiz_usecase.dart';
import 'package:streamshaala/domain/usecases/quiz/resume_session_usecase.dart';
import 'package:streamshaala/domain/usecases/quiz/submit_answer_usecase.dart';
import 'package:streamshaala/domain/services/gap_analysis_service.dart';
import 'package:streamshaala/domain/services/learning_path_generator.dart';
import 'package:streamshaala/domain/services/mastery_calculation_service.dart';
import 'package:streamshaala/domain/services/spaced_repetition_service.dart';
import 'package:streamshaala/domain/services/pre_assessment_service.dart';
import 'package:streamshaala/domain/services/gamification_service.dart';
import 'package:streamshaala/domain/services/path_analytics_service.dart';
import 'package:streamshaala/domain/services/path_validation_service.dart';
import 'package:streamshaala/domain/repositories/path_metrics_repository.dart';
import 'package:streamshaala/data/repositories/path_metrics_repository_impl.dart';
import 'package:streamshaala/domain/usecases/pedagogy/detect_gaps_usecase.dart';
import 'package:streamshaala/domain/usecases/pedagogy/analyze_subject_readiness_usecase.dart';
import 'package:streamshaala/domain/usecases/pedagogy/generate_learning_path_usecase.dart';
import 'package:streamshaala/domain/usecases/pedagogy/generate_quiz_recommendations_usecase.dart';
import 'package:streamshaala/data/datasources/json/spelling_json_datasource.dart';
import 'package:streamshaala/data/datasources/local/database/dao/spelling_attempt_dao.dart';
import 'package:streamshaala/data/datasources/local/database/dao/word_mastery_dao.dart';
import 'package:streamshaala/data/repositories/spelling_repository_impl.dart';
import 'package:streamshaala/domain/repositories/spelling_repository.dart';
import 'package:streamshaala/domain/services/word_mastery_service.dart';
import 'package:streamshaala/domain/services/spelling_bee_service.dart';
import 'package:streamshaala/domain/usecases/spelling/get_word_lists.dart';
import 'package:streamshaala/domain/usecases/spelling/get_words_for_list.dart';
import 'package:streamshaala/domain/usecases/spelling/get_word_of_the_day.dart';
import 'package:streamshaala/domain/usecases/spelling/submit_spelling_attempt.dart';
import 'package:streamshaala/domain/usecases/spelling/get_spelling_statistics.dart';
import 'package:streamshaala/domain/usecases/spelling/get_phonics_patterns.dart';
import 'package:streamshaala/domain/usecases/spelling/get_weak_words.dart';
import 'package:streamshaala/domain/usecases/spelling/search_words.dart';
import 'package:streamshaala/core/config/segment_config.dart';

/// Dependency injection container
class InjectionContainer {
  static final InjectionContainer _instance = InjectionContainer._internal();

  // Data Sources
  late final DatabaseHelper databaseHelper;
  late final ContentJsonDataSource contentJsonDataSource;
  late final QuizJsonDataSource quizJsonDataSource;
  late final ConceptJsonDataSource conceptJsonDataSource;

  // DAOs
  late final BookmarkDao bookmarkDao;
  late final NoteDao noteDao;
  late final ProgressDao progressDao;
  late final CollectionDao collectionDao;
  late final CollectionVideoDao collectionVideoDao;
  late final PreferenceDao preferenceDao;
  late final QuestionDao questionDao;
  late final QuizDao quizDao;
  late final QuizSessionDao quizSessionDao;
  late final QuizAttemptDao quizAttemptDao; // PHASE 4: Quiz history
  late final ConceptMasteryDao conceptMasteryDao;
  late final SpacedRepetitionDao spacedRepetitionDao;
  late final RecommendationsHistoryDao recommendationsHistoryDao;
  late final LearningPathDao learningPathDao;

  // Pedagogy Services
  late final GapAnalysisService gapAnalysisService;
  late final LearningPathGenerator learningPathGenerator;
  late final MasteryCalculationService masteryCalculationService;
  late final SpacedRepetitionService spacedRepetitionService;
  late final PreAssessmentService preAssessmentService;
  late final GamificationService gamificationService;
  late final PathAnalyticsService pathAnalyticsService;
  late final PathValidationService pathValidationService;

  // Repositories
  late final BookmarkRepository bookmarkRepository;
  late final ContentRepository contentRepository;
  late final NoteRepository noteRepository;
  late final ProgressRepository progressRepository;
  late final CollectionRepository collectionRepository;
  late final PreferencesRepository preferencesRepository;
  late final QuizRepository quizRepository;
  late final LearningPathRepository learningPathRepository;
  late final PathMetricsRepository pathMetricsRepository;
  late final RecommendationsHistoryRepository recommendationsHistoryRepository;

  // Use Cases - Bookmark
  late final AddBookmarkUseCase addBookmarkUseCase;
  late final RemoveBookmarkUseCase removeBookmarkUseCase;
  late final GetAllBookmarksUseCase getAllBookmarksUseCase;

  // Use Cases - Content
  late final GetBoardsUseCase getBoardsUseCase;
  late final GetSubjectsUseCase getSubjectsUseCase;
  late final GetChaptersUseCase getChaptersUseCase;
  late final GetVideosUseCase getVideosUseCase;
  late final SearchVideosUseCase searchVideosUseCase;

  // Use Cases - Note
  late final AddNoteUseCase addNoteUseCase;
  late final UpdateNoteUseCase updateNoteUseCase;
  late final DeleteNoteUseCase deleteNoteUseCase;
  late final GetNotesUseCase getNotesUseCase;

  // Use Cases - Progress
  late final SaveProgressUseCase saveProgressUseCase;
  late final GetWatchHistoryUseCase getWatchHistoryUseCase;
  late final GetStatisticsUseCase getStatisticsUseCase;

  // Use Cases - Collection
  late final CreateCollectionUseCase createCollectionUseCase;
  late final AddVideoToCollectionUseCase addVideoToCollectionUseCase;
  late final RemoveVideoFromCollectionUseCase removeVideoFromCollectionUseCase;
  late final GetCollectionsUseCase getCollectionsUseCase;

  // Use Cases - Quiz
  late final LoadQuizUseCase loadQuizUseCase;
  late final SubmitAnswerUseCase submitAnswerUseCase;
  late final CompleteQuizUseCase completeQuizUseCase;
  late final ResumeSessionUseCase resumeSessionUseCase;
  late final GetQuizHistoryUseCase getQuizHistoryUseCase;
  late final GetActiveSessionUseCase getActiveSessionUseCase;

  // Use Cases - Pedagogy
  late final DetectGapsUseCase detectGapsUseCase;
  late final AnalyzeSubjectReadinessUseCase analyzeSubjectReadinessUseCase;
  late final GenerateFoundationPathUseCase generateFoundationPathUseCase;
  late final GenerateQuizRecommendationsUseCase generateQuizRecommendationsUseCase;

  // Spelling Data Sources
  late final SpellingJsonDataSource spellingJsonDataSource;

  // Spelling DAOs
  SpellingAttemptDao? spellingAttemptDao;
  WordMasteryDao? spellingMasteryDao;

  // Spelling Repository
  late final SpellingRepository spellingRepository;

  // Spelling Services
  late final WordMasteryService wordMasteryService;
  late final SpellingBeeService spellingBeeService;

  // Spelling Use Cases
  late final GetWordListsUseCase getWordListsUseCase;
  late final GetWordsForListUseCase getWordsForListUseCase;
  late final GetWordOfTheDayUseCase getWordOfTheDayUseCase;
  late final SubmitSpellingAttemptUseCase submitSpellingAttemptUseCase;
  late final GetSpellingStatisticsUseCase getSpellingStatisticsUseCase;
  late final GetPhonicsPatterns getPhonicsPatterns;
  late final GetWeakWordsUseCase getWeakWordsUseCase;
  late final SearchWordsUseCase searchWordsUseCase;

  bool _isInitialized = false;

  InjectionContainer._internal();

  factory InjectionContainer() {
    return _instance;
  }

  /// Initialize all dependencies
  Future<void> initialize() async {
    if (_isInitialized) {
      logger.warning('InjectionContainer already initialized');
      return;
    }

    logger.info('Initializing InjectionContainer');

    try {
      // Initialize data sources
      await _initDataSources();

      // Initialize DAOs
      await _initDAOs();

      // Initialize repositories
      _initRepositories();

      // Initialize services
      _initServices();

      // Initialize use cases
      _initUseCases();

      _isInitialized = true;
      logger.info('InjectionContainer initialized successfully');
    } catch (e, stackTrace) {
      logger.error('Failed to initialize InjectionContainer', e, stackTrace);
      rethrow;
    }
  }

  /// Initialize data sources
  Future<void> _initDataSources() async {
    logger.debug('Initializing data sources');

    // Database Helper
    databaseHelper = DatabaseHelper();
    await databaseHelper.database; // Initialize database

    // JSON Data Sources
    contentJsonDataSource = ContentJsonDataSource();
    quizJsonDataSource = QuizJsonDataSource();
    conceptJsonDataSource = ConceptJsonDataSource();

    // Spelling JSON Data Source
    spellingJsonDataSource = SpellingJsonDataSource();
    if (SegmentConfig.isInitialized && SegmentConfig.isSpelling) {
      await spellingJsonDataSource.initialize();
    }

    logger.debug('Data sources initialized');
  }

  /// Initialize DAOs
  Future<void> _initDAOs() async {
    logger.debug('Initializing DAOs');

    bookmarkDao = BookmarkDao(databaseHelper);
    noteDao = NoteDao(databaseHelper);
    progressDao = ProgressDao(databaseHelper);
    collectionDao = CollectionDao(databaseHelper);
    collectionVideoDao = CollectionVideoDao(databaseHelper);
    preferenceDao = PreferenceDao(databaseHelper);
    questionDao = QuestionDao(databaseHelper);
    quizDao = QuizDao(databaseHelper);
    quizSessionDao = QuizSessionDao(databaseHelper);
    quizAttemptDao = QuizAttemptDao(databaseHelper); // PHASE 4: Quiz history
    conceptMasteryDao = ConceptMasteryDao(databaseHelper);
    spacedRepetitionDao = SpacedRepetitionDao(databaseHelper);
    recommendationsHistoryDao = RecommendationsHistoryDao(databaseHelper);
    learningPathDao = LearningPathDao(databaseHelper);

    // Spelling DAOs - initialize for all segments (they use raw Database)
    final db = await databaseHelper.database;
    spellingAttemptDao = SpellingAttemptDao(db);
    spellingMasteryDao = WordMasteryDao(db);

    logger.debug('DAOs initialized');
  }

  /// Initialize repositories
  void _initRepositories() {
    logger.debug('Initializing repositories');

    bookmarkRepository = BookmarkRepositoryImpl(bookmarkDao);
    contentRepository = ContentRepositoryImpl(contentJsonDataSource);
    noteRepository = NoteRepositoryImpl(noteDao);
    progressRepository = ProgressRepositoryImpl(progressDao, contentRepository);
    collectionRepository = CollectionRepositoryImpl(collectionDao, collectionVideoDao);
    preferencesRepository = PreferencesRepositoryImpl(preferenceDao);
    quizRepository = QuizRepositoryImpl(
      questionDao: questionDao,
      quizDao: quizDao,
      quizSessionDao: quizSessionDao,
      quizAttemptDao: quizAttemptDao, // PHASE 4: Quiz history
      jsonDataSource: quizJsonDataSource,
    );
    learningPathRepository = LearningPathRepositoryImpl(
      dao: learningPathDao,
      recommendationsDao: recommendationsHistoryDao,
    );
    pathMetricsRepository = PathMetricsRepositoryImpl(
      databaseHelper: databaseHelper,
    );
    recommendationsHistoryRepository = RecommendationsHistoryRepositoryImpl(
      dao: recommendationsHistoryDao,
    );

    // Spelling repository
    spellingRepository = SpellingRepositoryImpl(
      jsonDataSource: spellingJsonDataSource,
      attemptDao: spellingAttemptDao,
      masteryDao: spellingMasteryDao,
    );

    logger.debug('Repositories initialized');
  }

  /// Initialize pedagogy services
  void _initServices() {
    logger.debug('Initializing pedagogy services');

    // Core calculation services
    masteryCalculationService = MasteryCalculationService(masteryDao: conceptMasteryDao);
    spacedRepetitionService = SpacedRepetitionService(dao: spacedRepetitionDao);

    // Gap analysis and path generation
    gapAnalysisService = GapAnalysisService(
      conceptDataSource: conceptJsonDataSource,
      masteryDao: conceptMasteryDao,
    );
    learningPathGenerator = LearningPathGenerator(
      gapService: gapAnalysisService,
      conceptDataSource: conceptJsonDataSource,
    );

    // Pre-assessment service
    preAssessmentService = PreAssessmentService(
      conceptDataSource: conceptJsonDataSource,
      masteryDao: conceptMasteryDao,
      gapService: gapAnalysisService,
      masteryService: masteryCalculationService,
    );

    // Gamification service
    gamificationService = GamificationService(dbHelper: databaseHelper);

    // Path analytics and validation services
    pathAnalyticsService = PathAnalyticsService();
    pathValidationService = PathValidationService(
      pathRepository: learningPathRepository,
    );

    // Spelling services
    wordMasteryService = WordMasteryService();
    spellingBeeService = SpellingBeeService();

    logger.debug('Pedagogy services initialized');
  }

  /// Initialize use cases
  void _initUseCases() {
    logger.debug('Initializing use cases');

    // Bookmark use cases
    addBookmarkUseCase = AddBookmarkUseCase(bookmarkRepository);
    removeBookmarkUseCase = RemoveBookmarkUseCase(bookmarkRepository);
    getAllBookmarksUseCase = GetAllBookmarksUseCase(bookmarkRepository);

    // Content use cases
    getBoardsUseCase = GetBoardsUseCase(contentRepository);
    getSubjectsUseCase = GetSubjectsUseCase(contentRepository);
    getChaptersUseCase = GetChaptersUseCase(contentRepository);
    getVideosUseCase = GetVideosUseCase(contentRepository);
    searchVideosUseCase = SearchVideosUseCase(contentRepository);

    // Note use cases
    addNoteUseCase = AddNoteUseCase(noteRepository);
    updateNoteUseCase = UpdateNoteUseCase(noteRepository);
    deleteNoteUseCase = DeleteNoteUseCase(noteRepository);
    getNotesUseCase = GetNotesUseCase(noteRepository);

    // Progress use cases
    saveProgressUseCase = SaveProgressUseCase(progressRepository);
    getWatchHistoryUseCase = GetWatchHistoryUseCase(progressRepository);
    getStatisticsUseCase = GetStatisticsUseCase(progressRepository);

    // Collection use cases
    createCollectionUseCase = CreateCollectionUseCase(collectionRepository);
    addVideoToCollectionUseCase = AddVideoToCollectionUseCase(collectionRepository);
    removeVideoFromCollectionUseCase = RemoveVideoFromCollectionUseCase(collectionRepository);
    getCollectionsUseCase = GetCollectionsUseCase(collectionRepository);

    // Quiz use cases
    loadQuizUseCase = LoadQuizUseCase(quizRepository);
    submitAnswerUseCase = SubmitAnswerUseCase(quizRepository);
    completeQuizUseCase = CompleteQuizUseCase(quizRepository);
    resumeSessionUseCase = ResumeSessionUseCase(quizRepository);
    getQuizHistoryUseCase = GetQuizHistoryUseCase(quizRepository);
    getActiveSessionUseCase = GetActiveSessionUseCase(quizRepository);

    // Pedagogy use cases
    detectGapsUseCase = DetectGapsUseCase(gapAnalysisService);
    analyzeSubjectReadinessUseCase = AnalyzeSubjectReadinessUseCase(gapAnalysisService);
    generateFoundationPathUseCase = GenerateFoundationPathUseCase(learningPathGenerator);
    generateQuizRecommendationsUseCase = GenerateQuizRecommendationsUseCase(
      gapAnalysisService: gapAnalysisService,
      conceptDataSource: conceptJsonDataSource,
      contentRepository: contentRepository,
    );

    // Spelling use cases
    getWordListsUseCase = GetWordListsUseCase(spellingRepository);
    getWordsForListUseCase = GetWordsForListUseCase(spellingRepository);
    getWordOfTheDayUseCase = GetWordOfTheDayUseCase(spellingRepository);
    submitSpellingAttemptUseCase = SubmitSpellingAttemptUseCase(spellingRepository, wordMasteryService);
    getSpellingStatisticsUseCase = GetSpellingStatisticsUseCase(spellingRepository);
    getPhonicsPatterns = GetPhonicsPatterns(spellingRepository);
    getWeakWordsUseCase = GetWeakWordsUseCase(spellingRepository);
    searchWordsUseCase = SearchWordsUseCase(spellingRepository);

    logger.debug('Use cases initialized');
  }

  /// Reset the container (useful for testing)
  Future<void> reset() async {
    logger.warning('Resetting InjectionContainer');

    if (_isInitialized) {
      await databaseHelper.close();
      contentJsonDataSource.clearCache();
      quizJsonDataSource.clearCache();
      conceptJsonDataSource.clearCache();
    }

    _isInitialized = false;
    logger.info('InjectionContainer reset complete');
  }

  /// Check if initialized
  bool get isInitialized => _isInitialized;

  /// Set the active profile ID for multi-profile support
  /// This updates the profileId on all repositories that support profile-scoped data
  void setActiveProfileId(String? profileId) {
    logger.info('Setting active profile ID: $profileId');

    // Update repositories that support profile IDs
    if (progressRepository is ProgressRepositoryImpl) {
      (progressRepository as ProgressRepositoryImpl).profileId = profileId;
    }
    if (bookmarkRepository is BookmarkRepositoryImpl) {
      (bookmarkRepository as BookmarkRepositoryImpl).profileId = profileId;
    }
    if (noteRepository is NoteRepositoryImpl) {
      (noteRepository as NoteRepositoryImpl).profileId = profileId;
    }
    if (collectionRepository is CollectionRepositoryImpl) {
      (collectionRepository as CollectionRepositoryImpl).profileId = profileId;
    }
    if (quizRepository is QuizRepositoryImpl) {
      (quizRepository as QuizRepositoryImpl).profileId = profileId;
    }
  }

  /// Get the current active profile ID
  String? getActiveProfileId() {
    if (progressRepository is ProgressRepositoryImpl) {
      return (progressRepository as ProgressRepositoryImpl).profileId;
    }
    return null;
  }

  /// Delete all data for a specific profile
  /// Call this when a profile is being deleted to clean up all associated data
  Future<void> deleteAllDataForProfile(String profileId) async {
    logger.info('Deleting all data for profile: $profileId');

    try {
      // Delete from all DAOs that support profile-scoped data
      await Future.wait([
        progressDao.deleteAllForProfile(profileId),
        bookmarkDao.deleteAllForProfile(profileId),
        noteDao.deleteAllForProfile(profileId),
        collectionDao.deleteAllForProfile(profileId),
        quizSessionDao.deleteAllForProfile(profileId),
        quizAttemptDao.deleteAllForProfile(profileId),
        gamificationService.deleteAllForProfile(profileId),
      ]);

      logger.info('All data deleted for profile: $profileId');
    } catch (e, stackTrace) {
      logger.error('Failed to delete data for profile: $profileId', e, stackTrace);
      rethrow;
    }
  }
}

/// Global instance for easy access
final injectionContainer = InjectionContainer();
